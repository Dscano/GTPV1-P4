import sys

def main():
    try:
        n_entry = int(sys.argv[1])
    except:
        print "Usage: python write_entries_scan.py <number of entries>"
        sys.exit(1)
    print "Partenza"
    w = 0
    n = 0
    fs1 = open("Commands_s1.txt","w")
    fs2 = open("Commands_s2.txt", "w")
    fs3 = open("Commands_s3.txt", "w")

    for i in range (0, n_entry ):

        fs1.write('table_add table_encap_gtp encap_gtp 11.0.' + str(n) + '.' + str(w+1) +' 10.0.'+str(n)+'.'+ str(w+1) + ' 0x11 => 157'
                + str(i) +' 163.162.' + str(n)+'.' + str(w+1) + '1' + '0x01' + '\n' )
        fs1.write('table_add tb_generate_report do_report_encapsulation  0x01 11.0.' + str(n) + '.' + str(w+1) + ' => 00:04:00:00:00:00 00:04:00:00:00:10 127.0.0.1 10.0.0.10 54321'
                + '0x0a' + '0x0' + str(n) + '\n' )

        fs2.write('table_add table_decap_gtp decap_gtp 157' + str(i) ' => ' + '2' + '180' + str(i) + '0x01' + '\n' )
        fs2.write('table_add tb_generate_report do_report_encapsulation  0x01 11.0.' + str(n) + '.' + str(w+1) + ' => 00:04:00:00:00:00 00:04:00:00:00:10 127.0.0.1 10.0.0.10 54321'
                + '0x0b' + '0x0' + str(n) + '\n' )

        fs3.write('table_add table_decap_gtp decap_gtp 180' + str(i) + ' =>' + '2' + '0x01' + '\n')
        fs3.write('table_add tb_generate_report do_report_encapsulation  0x01 11.0.' + str(n) + '.' + str(w+1) + ' => 00:04:00:00:00:00 00:04:00:00:00:10 127.0.0.1 10.0.0.10 54321'
                + '0x0c' + '0x0' + str(n) + '\n' )

        w = w+1
        if w == 255 :
            w = 0
            n = n + 1

    fs1.close()
    fs2.close()
    fs3.close()

if __name__ == '__main__':
    main()
