from ipdi.ip.pyaip import pyaip, pyaip_init

import sys

try:
    connector = '/dev/ttyACM0'
    nic_addr = 1
    port = 0
    csv_file = '/home/efrenuzlemon/Desktop/AIP_Generated/ID1000500B_/ID1000500B_config.csv'

    aip = pyaip_init(connector, nic_addr, port, csv_file)

    aip.reset()

    #==========================================
    # Code generated with IPAccelerator 

    ID = aip.getID()
    print(f'Read ID: {ID:08X}\n')

    STATUS = aip.getStatus()
    print(f'Read STATUS: {STATUS:08X}\n')

    SIZEY = [0x00000000]

    print('Write configuration register: CSIZEY')
    aip.writeConfReg('CSIZEY', SIZEY, 1, 0)
    print(f'SIZEY Data: {[f"{x:08X}" for x in SIZEY]}\n')

    MEMY = [0x00000000, 0x00000001, 0x00000002, 0x00000003, 0x00000004, 0x00000005, 0x00000006, 0x00000007, 0x00000008, 0x00000009, 0x0000000A, 0x0000000B, 0x0000000C, 0x0000000D, 0x0000000E, 0x0000000F, 0x00000010, 0x00000011, 0x00000012, 0x00000013, 0x00000014, 0x00000015, 0x00000016, 0x00000017, 0x00000018, 0x00000019, 0x0000001A, 0x0000001B, 0x0000001C, 0x0000001D, 0x0000001E, 0x0000001F]

    print('Write memory: MEMY')
    aip.writeMem('MEMY', MEMY, 32, 0)
    print(f'MEMY Data: {[f"{x:08X}" for x in MEMY]}\n')

    STATUS = aip.getStatus()
    print(f'Read STATUS: {STATUS:08X}\n')

    print('Start IP\n')
    aip.start()

    STATUS = aip.getStatus()
    print(f'Read STATUS: {STATUS:08X}\n')

    print('Read memory: MMEMZ')
    MEMZ = aip.readMem('MMEMZ', 64, 0)
    print(f'MEMZ Data: {[f"{x:08X}" for x in MEMZ]}\n')

    print('Clear INT: 0')
    aip.clearINT(0)

    STATUS = aip.getStatus()
    print(f'Read STATUS: {STATUS:08X}\n')

    #==========================================

    aip.finish()

except:
    e = sys.exc_info()
    print('ERROR: ', e)

    aip.finish()
    raise
