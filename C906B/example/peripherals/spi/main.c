#include <stdio.h>
#include <unistd.h>
#include <stdint.h>

#include <wiringx.h>

// 硬件SPI的CS不连续 使用软CS解决
#define CS_PIN (14)

int main(void)
{
    int fd_spi;
    unsigned char buff[6] = {0x90, 0, 0, 0, 0xff, 0xff};

    if(wiringXSetup("duo", NULL) == -1) {
        wiringXGC();
        return -1;
    }

    if ((fd_spi = wiringXSPISetup(0, 500000)) <0) {
        printf("SPI Setup failed: %d\r\n", fd_spi);
        wiringXGC();
        return -1;
    }

    if(wiringXValidGPIO(CS_PIN) != 0) {
        printf("Invalid GPIO %d\n", CS_PIN);
    }

    pinMode(CS_PIN, PINMODE_OUTPUT);
    digitalWrite(CS_PIN, HIGH);
    delayMicroseconds(100);

    digitalWrite(CS_PIN, LOW);
    wiringXSPIDataRW(fd_spi, buff, sizeof buff);
    digitalWrite(CS_PIN, HIGH);
    
    printf("Manufacturer id: %02x\r\n", buff[4]);
    printf("Device id: %02x\r\n", buff[5]);

    return 0;
}