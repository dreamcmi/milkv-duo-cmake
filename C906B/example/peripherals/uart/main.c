#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

int main(void) {
    // 打开设备文件
    int fd = open("/dev/ttyS1", O_RDWR | O_NOCTTY);
    if (fd == -1) {
        return -1;
    }
    // 获取并修改终端属性
    struct termios options;
    tcgetattr(fd, &options);                           // 获取当前属性
    cfsetispeed(&options, B9600);                      // 设置输入波特率为9600
    cfsetospeed(&options, B9600);                      // 设置输出波特率为9600
    options.c_cflag |= (CLOCAL | CREAD);               // 设置本地模式和使能接收
    options.c_cflag &= ~CSIZE;                         // 清除数据位掩码
    options.c_cflag |= CS8;                            // 设置数据位为8
    options.c_cflag &= ~PARENB;                        // 清除校验位
    options.c_cflag &= ~CSTOPB;                        // 清除停止位
    options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);// 设置为原始模式
    options.c_iflag &= ~(IXON | IXOFF | IXANY);        // 关闭软件流控制
    options.c_oflag &= ~OPOST;                         // 设置为原始输出模式
    tcsetattr(fd, TCSANOW, &options);                  // 设置新属性
    // 写入数据
    char *data = "Hello, world!\n";
    int n = write(fd, data, strlen(data));
    if (n == -1) {
        return -2;
    }
    printf("写入了%d个字节\n", n);
    // 读取数据
    char buffer[256];
    n = read(fd, buffer, sizeof(buffer));
    if (n == -1) {
        return -3;
    }
    printf("读取了%d个字节\n", n);
    buffer[n] = '\0';// 添加字符串结束符
    printf("读取的数据是：%s\n", buffer);
    // 关闭设备文件
    close(fd);
    return 0;
}