#include "stdint.h"
#include "ports.h"

static uint32_t strlen(const char* str) {
	uint32_t len = 0;
	while (str[len])
		len++;
	return len;
}

void putchar(char c) {
	outb(c, 0xe9);
}

void putstring(const char* data) {
	int len = strlen(data);
	for (int i = 0; i < len; i++)
		putchar(data[i]);
}

char bchars[] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
void puthex32(uint32_t i) {
	putchar(bchars[(i >> 28) & 0xF]);
	putchar(bchars[(i >> 24) & 0xF]);
	putchar('.');
	putchar(bchars[(i >> 20) & 0xF]);
	putchar(bchars[(i >> 16) & 0xF]);
	putchar('.');
	putchar(bchars[(i >> 12) & 0xF]);
	putchar(bchars[(i >> 8)  & 0xF]);
	putchar('.');
	putchar(bchars[(i >> 4)  & 0xF]);
	putchar(bchars[(i >> 0)  & 0xF]);
}
void puthex8(uint8_t i) {
	putchar(bchars[(i >> 4)  & 0xF]);
	putchar(bchars[(i >> 0)  & 0xF]);
}
