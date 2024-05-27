#include "caip.h"

#include <stdint.h>
#include <stdio.h>

#include <conio.h>

int main(){
    const char *connector = "/dev/ttyACM0";
    uint8_t nic_addr = 1;
    uint8_t port = 0;
    const char *csv_file = "/home/efrenuzlemon/Desktop/AIP_Generated/ID1000500B_/ID1000500B_config.csv";

    caip_t *aip = caip_init(connector, nic_addr, port, csv_file);

    aip->reset();

    /*========================================*/
    /* Code generated with IPAccelerator */

    uint32_t ID[1];


    aip->getID(ID);
    printf("Read ID: %08X\n\n", ID[0]);


    uint32_t STATUS[1];


    aip->getStatus(STATUS);
    printf("Read STATUS: %08X\n\n", STATUS[0]);


    uint32_t SIZEY[1] = {0x00000000};
    uint32_t SIZEY_size = sizeof(SIZEY) / sizeof(uint32_t);


    printf("Write configuration register: CSIZEY\n");
    aip->writeConfReg("CSIZEY", SIZEY, 1, 0);
    printf("SIZEY Data: [");
    for(int i=0; i<SIZEY_size; i++){
        printf("0x%08X", SIZEY[i]);
        if(i != SIZEY_size-1){
            printf(", ");
        }
    }
    printf("]\n\n");


    uint32_t MEMY[32] = {0x00000000, 0x00000001, 0x00000002, 0x00000003, 0x00000004, 0x00000005, 0x00000006, 0x00000007, 0x00000008, 0x00000009, 0x0000000A, 0x0000000B, 0x0000000C, 0x0000000D, 0x0000000E, 0x0000000F, 0x00000010, 0x00000011, 0x00000012, 0x00000013, 0x00000014, 0x00000015, 0x00000016, 0x00000017, 0x00000018, 0x00000019, 0x0000001A, 0x0000001B, 0x0000001C, 0x0000001D, 0x0000001E, 0x0000001F};
    uint32_t MEMY_size = sizeof(MEMY) / sizeof(uint32_t);


    printf("Write memory: MEMY\n");
    aip->writeMem("MEMY", MEMY, 32, 0);
    printf("MEMY Data: [");
    for(int i=0; i<MEMY_size; i++){
        printf("0x%08X", MEMY[i]);
        if(i != MEMY_size-1){
            printf(", ");
        }
    }
    printf("]\n\n");


    aip->getStatus(STATUS);
    printf("Read STATUS: %08X\n\n", STATUS[0]);


    printf("Start IP\n\n");
    aip->start();


    aip->getStatus(STATUS);
    printf("Read STATUS: %08X\n\n", STATUS[0]);


    uint32_t MEMZ[64];
    uint32_t MEMZ_size = sizeof(MEMZ) / sizeof(uint32_t);


    printf("Read memory: MMEMZ\n");
    aip->readMem("MMEMZ", MEMZ, 64, 0);
    printf("MEMZ Data: [");
    for(int i=0; i<MEMZ_size; i++){
        printf("0x%08X", MEMZ[i]);
        if(i != MEMZ_size-1){
            printf(", ");
        }
    }
    printf("]\n\n");


    printf("Clear INT: 0\n");
    aip->clearINT(0);


    aip->getStatus(STATUS);
    printf("Read STATUS: %08X\n\n", STATUS[0]);



    /*========================================*/

    aip->finish();

    printf("\n\nPress key to close ... ");
    getch();

    return 0;

}
