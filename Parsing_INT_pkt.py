#sudo python Parsing_INT_pkt.py eth1 udp 54321 1000 0
#sudo python Parsing_INT_pkt.py eth2 udp 54321 1000 0


import binascii
from scapy.all import *
import sys
import keyboard
import os
import datetime
import influxdb
import time

hop_latency_1 = 0
hop_latency_2 = 0
hop_latency_1_max = 0
hop_latency_2_max = 0
switch_id = None

#grafana push period
period=0.5

toDB=1
ipdb='ip address'
db="INT-GTP"
client=None
drop=1

#ipdb='localhost'
epoch = datetime.datetime(1970,1,1)
polling=1

def send_data(hop_latency_avg_1, hop_latency_avg_2):
  if hop_latency_1:
    fields={"hop_latency_avg": hop_latency_avg_1, "hop_latency_max": hop_latency_1_max}
    d = datetime.datetime.utcnow()
    ts = int(((d - epoch).total_seconds())*1000)
    json = [{'measurement': 'measurement',
             'tags': {"switchID": switch_id ,"serviceID": "Flow1" },
             'time': ts,
             'fields': fields }]
    #print fields
    client.write_points(json, time_precision='ms')
    #time.sleep(polling)
  if hop_latency_2:
    fields={"hop_latency_avg": hop_latency_avg_2, "hop_latency_max": hop_latency_2_max}
    d = datetime.datetime.utcnow()
    ts = int(((d - epoch).total_seconds())*1000)
    json = [{'measurement': 'measurement',
             'tags': {"switchID":switch_id ,"serviceID": "Flow2"},
             'time': ts,
             'fields': fields }]
    #print fields
    client.write_points(json, time_precision='ms')
    #time.sleep(polling)

def pkt_callback(pkt):
    global hop_latency_1
    global hop_latency_2
    global hop_latency_1_max
    global hop_latency_2_max
    global switch_id
    l=pkt[Raw]
    if not switch_id:
      switch_id =  binascii.b2a_hex(str(l)[4:8])
    if ( int(binascii.b2a_hex(str(l)[8:12]),16) == 1):
       if(hop_latency_1_max < int(binascii.b2a_hex(str(l)[16:20]),16) - int(binascii.b2a_hex(str(l)[12:16]),16)):
          hop_latency_1_max = int(binascii.b2a_hex(str(l)[16:20]),16) - int(binascii.b2a_hex(str(l)[12:16]),16)
       hop_latency_1 = hop_latency_1 + int(binascii.b2a_hex(str(l)[16:20]),16) - int(binascii.b2a_hex(str(l)[12:16]),16)
    if ( int(binascii.b2a_hex(str(l)[8:12]),16) == 2):
       if(hop_latency_2_max < int(binascii.b2a_hex(str(l)[16:20]),16) - int(binascii.b2a_hex(str(l)[12:16]),16)):
          hop_latency_2_max = int(binascii.b2a_hex(str(l)[16:20]),16) - int(binascii.b2a_hex(str(l)[12:16]),16)
       hop_latency_2 = hop_latency_2 + int(binascii.b2a_hex(str(l)[16:20]),16) - int(binascii.b2a_hex(str(l)[12:16]),16)

def main():  
    global hop_latency_1
    global hop_latency_2
    global hop_latency_1_max
    global hop_latency_2_max
    global client
    global toDB
    global ipdb
    global db
    global drop
    global period

    try:  
        interface = str(sys.argv[1])
        protocol =  str(sys.argv[2])
        port_selected = str(sys.argv[3])
        rate = int(sys.argv[4])
        cycle = int(sys.argv[5])
        filter= protocol +" port " + port_selected
        if toDB:
             client=influxdb.InfluxDBClient(ipdb, 8086, 'root', 'root', db)
             if interface == "eth1":
                if drop:
                   client.drop_database(db)
                client.create_database(db)
        print "tep1 ok"
        n = 1
        N = int(rate) * period
        print "Sniffing packets at port: "+ interface + " at " + protocol +" port: "+ port_selected +" numbers of pkts: " + str(N) + " cycles: "+ str(cycle)
    except:
        print "Usage: sudo python Parsing_INT_pkt.py <name_inteface> <protocol> <udp/tcp port> <n packets> <n cycle>"
        sys.exit(1)
    while True:
      try:
        sniff(iface = interface, prn=pkt_callback, filter = filter, store = 0, count = int(N))
        if hop_latency_1:
          print("flow 1 max value: " + str(hop_latency_1_max) + " avg value: " + str(hop_latency_1/int(N)))
        if hop_latency_2: 
          print("flow 2 max value: " + str(hop_latency_2_max) + " avg value: " + str(hop_latency_2/int(N)))
        if toDB:
            send_data(hop_latency_1/int(N), hop_latency_2/int(N))
        hop_latency_1 = 0
        hop_latency_2 = 0
        hop_latency_1_max = 0
        hop_latency_2_max = 0
        #print str(hop_latency_1_max) , str(hop_latency_2_max), str(hop_latency_1), str(hop_latency_2)
        #print "cycle", n
        if n == cycle and n != 0:
          print 'Interrupted! cycle number', n
          sys.exit(1)
        n = n+1
      except KeyboardInterrupt:
          print 'interrupted!'
          sys.exit(1)
            
                        

main()
