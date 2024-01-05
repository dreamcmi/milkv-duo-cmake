#include <fcntl.h>
#include <linux/spi/spidev.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <unistd.h>

// 定义SPI设备的路径
#define SPI_DEV_PATH "/dev/spidev0.0"

// 定义SPI设备的参数
#define SPI_MODE SPI_MODE_0// SPI模式
#define SPI_BITS 8         // 每个字节的位数
#define SPI_SPEED 1000000  // SPI速度，单位Hz
#define SPI_DELAY 0        // SPI传输之间的延迟，单位微秒

// 定义一个函数，用于打开SPI设备，并设置参数
int spi_open() {
    // 打开SPI设备
    int fd = open(SPI_DEV_PATH, O_RDWR);
    if (fd < 0) {
        perror("open");
        return -1;
    }

    // 设置SPI模式
    int mode = SPI_MODE;
    if (ioctl(fd, SPI_IOC_WR_MODE, &mode) < 0) {
        perror("ioctl");
        close(fd);
        return -1;
    }

    // 设置每个字节的位数
    int bits = SPI_BITS;
    if (ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &bits) < 0) {
        perror("ioctl");
        close(fd);
        return -1;
    }

    // 设置SPI速度
    int speed = SPI_SPEED;
    if (ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed) < 0) {
        perror("ioctl");
        close(fd);
        return -1;
    }

    // 返回文件描述符
    return fd;
}

// 定义一个函数，用于关闭SPI设备
void spi_close(int fd) {
    // 关闭文件描述符
    close(fd);
}

// 定义一个函数，用于向SPI设备发送和接收数据
int spi_transfer(int fd, unsigned char *tx_buf, unsigned char *rx_buf, int len) {
    // 定义一个SPI传输结构体
    struct spi_ioc_transfer tr = {
            .tx_buf = (unsigned long) tx_buf,// 发送缓冲区
            .rx_buf = (unsigned long) rx_buf,// 接收缓冲区
            .len = len,                      // 传输长度
            .delay_usecs = SPI_DELAY,        // 传输延迟
            .speed_hz = SPI_SPEED,           // 传输速度
            .bits_per_word = SPI_BITS,       // 每个字节的位数
    };

    // 调用ioctl函数，执行SPI传输
    if (ioctl(fd, SPI_IOC_MESSAGE(1), &tr) < 0) {
        perror("ioctl");
        return -1;
    }

    // 返回传输长度
    return len;
}

// 定义一个主函数，用于测试SPI设备
int main() {
    // 打开SPI设备
    int fd = spi_open();
    if (fd < 0) {
        printf("Failed to open SPI device\n");
        return -1;
    }

    // 定义发送和接收缓冲区
    unsigned char tx_buf[6] = {0x90, 0x00, 0x00, 0x00, 0x00, 0x00};
    unsigned char rx_buf[6] = {0};

    // 向SPI设备发送和接收数据
    int len = spi_transfer(fd, tx_buf, rx_buf, 6);
    if (len < 0) {
        printf("Failed to transfer data\n");
        spi_close(fd);
        return -1;
    }

    // 打印发送和接收的数据
    printf("Sent: ");
    for (int i = 0; i < len; i++) {
        printf("%02X ", tx_buf[i]);
    }
    printf("\n");

    printf("Received: ");
    for (int i = 0; i < len; i++) {
        printf("%02X ", rx_buf[i]);
    }
    printf("\n");

    // 关闭SPI设备
    spi_close(fd);

    // 返回0
    return 0;
}
