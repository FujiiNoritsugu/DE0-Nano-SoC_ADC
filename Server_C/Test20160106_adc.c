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
#define FPGA2HPS_BRIDGE_BASE 0xff200000
#define SERVO_OFFSET 0x1

volatile unsigned char *blink_mem1, *blink_mem2;
void *bridge_map;
volatile unsigned char *value1, *value2, *value3;
volatile unsigned int a,b,c;
volatile unsigned int servo_value1, servo_value2;
volatile unsigned int pressure, bend;

int main(int argc, char *argv[]){
	int fd, ret = EXIT_FAILURE;
	int i;
	
	off_t blink_base = FPGA2HPS_BRIDGE_BASE;

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

	if (argc > 2) {
		servo_value1 = atoi(argv[1]);
		servo_value2 = atoi(argv[2]);
		blink_mem1 = (unsigned char *) (bridge_map);
		*blink_mem1 = servo_value1;
		blink_mem2 = (unsigned char *) (bridge_map + SERVO_OFFSET);
		*blink_mem2 = servo_value2;
		return 0;
	}

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

	//for(i = 0; i < 3; i++){
	//	blink_mem = (unsigned char *) (bridge_map + i);
	//	printf("value = %d", *blink_mem);
	//}

	if (munmap(bridge_map, PAGE_SIZE) < 0) {
		perror("munmap");
		goto cleanup;
	}

	ret = 0;

cleanup:
	close(fd);
	return ret;
}
