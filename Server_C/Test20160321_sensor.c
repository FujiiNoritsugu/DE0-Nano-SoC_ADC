#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <netinet/in.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

#define PAGE_SIZE 4096
#define LWHPS2FPGA_BRIDGE_BASE 0xff200000

volatile unsigned char *blink_mem;
volatile unsigned char *value1, *value2, *value3;
volatile unsigned int a,b,c;
volatile unsigned int pressure, bend;
unsigned char *bridge_map;
int fd;

void process_all(int sock, unsigned char *bridge_map);
void *get_bridge_map();
void relase_bridge_map(void *bridge_map);

int main(void){
	
	int sock_org;
	struct sockaddr_in addr;
	struct sockaddr_in client;
	int len;
	int sock;
	
	sock_org = socket(AF_INET, SOCK_STREAM, 0);

	addr.sin_family = AF_INET;
	addr.sin_port = htons(24);
	addr.sin_addr.s_addr = INADDR_ANY;

	bind(sock_org, (struct sockaddr *)&addr, sizeof(addr));

	listen(sock_org, 5);

	while(1){
		len = sizeof(client);
		sock = accept(sock_org, (struct sockaddr *)&client, &len);
		process_all(sock, bridge_map);
	}

	close(sock_org);

	}

// 処理プロセスの実行
void process_all(int sock, unsigned char *bridge_map){
	int read_size;
	char command[1];

		while(1){
			read_size = read(sock, command, 1);
//printf("command = %c", *command);
			if(read_size <= 0){
				continue;
//			}else if(command[0] == 'e'){
//printf("end \n");
//				close(sock);
//				relase_bridge_map(bridge_map);
//				break;
			}else if(command[0] == 'a'){
printf("exec \n");
				send_sensor_data(sock);
			}else{
//printf("command = %c \n", command[0]);
send(sock, "test", 4, 0);
				continue;
			}
		}

}

// ブリッジアドレスの取得
void *get_bridge_map(){
	int ret = EXIT_FAILURE;
	int i;
	
	off_t blink_base = LWHPS2FPGA_BRIDGE_BASE;

	/* open the memory device file */
	fd = open("/dev/mem", O_RDWR|O_SYNC);
	if (fd < 0) {
		perror("open");
		exit(EXIT_FAILURE);
	}

	/* map the LWHPS2FPGA bridge into process memory */
	bridge_map = mmap(NULL, PAGE_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED,
				fd, blink_base);
	if (bridge_map == MAP_FAILED) {
		perror("mmap");
		goto cleanup;
	}

	return bridge_map;
	
cleanup:
	close(fd);
	return (void *)0;

}

// ブリッジアドレスの開放
void relase_bridge_map(void *bridge_map){
	if (munmap(bridge_map, PAGE_SIZE) < 0) {
		perror("munmap");
		goto cleanup;
	}

cleanup:
	close(fd);
}

// センサデータの送信
int send_sensor_data(int sock){
	char buff[1024];
	int write_result;
	// 対象アドレスの取得
	bridge_map = (unsigned char *)get_bridge_map();
	
	/* get the delay_ctrl peripheral's base address */
	value1 = (unsigned char *) (bridge_map + 0);
	value2 = (unsigned char *) (bridge_map + 1);
	value3 = (unsigned char *) (bridge_map + 2);
	
	//printf("value1 = %d value2 = %d value3 = %d \n", *value1, *value2, *value3);
	a = (unsigned int)*value1;
	b = (unsigned int)*value2;
	c = (unsigned int)*value3;
	
	//printf("a = %d b = %d c = %d \n", a, b, c);
	
	pressure = a + ((b & 0x0f) << 8);
	bend = ((b & 0xf0) >> 4) + (c << 4);
	
	printf("pressure = %d bend = %d \n", pressure, (1170 -bend));
	sprintf(buff, "{\"p\":%d,\"b\":%d}", pressure, (1170 - bend));
	
	write_result = write(sock, buff, strlen(buff));
	if(write_result == -1){
		printf("socket write failed !!");
	}
	
	// 対象アドレスのリリース
	relase_bridge_map(bridge_map);
}
