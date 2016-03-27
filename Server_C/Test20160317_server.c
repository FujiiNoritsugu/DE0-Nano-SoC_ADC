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

#define MAX_BUF 3
#define PAGE_SIZE 4096
#define LWHPS2FPGA_BRIDGE_BASE 0xff200000

volatile unsigned char *blink_mem;
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
	addr.sin_port = htons(23);
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
	char buf[MAX_BUF];
	char command[1];

		while(1){
			read_size = read(sock, command, 1);
//printf("command = %c", *command);
			if(read_size <= 0){
				continue;
			}else if(command[0] == 'e'){
printf("end \n");
				close(sock);
				relase_bridge_map(bridge_map);
				break;
			}else if(command[0] == 'a' || command[0] == 'b'){
				memset(buf, 0, MAX_BUF);
				read_size = read(sock, buf, 3);
printf("buf = %s \n", buf);
				move_servo(command, atoi(buf));
			}else{
printf("command = %c \n", command[0]);
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

// サーボの移動
int move_servo(char *command, int angle){

	bridge_map = (unsigned char *)get_bridge_map();

	int fd, ret = EXIT_FAILURE;
	unsigned char value;
	int blink_offset;
//printf("command = %s ", command);
	if(command[0] == 'a'){
		blink_offset = 0x0;
		printf("angle a = %d  \n", angle);
	}else{
		blink_offset = 0x1;
		printf("angle b = %d  \n", angle);
	}
	
	blink_mem = (unsigned char *) (bridge_map + blink_offset);
	*blink_mem = angle;
	
	relase_bridge_map(bridge_map);
}
