/*
 * A series of low level I/O functions that will be used by hardware drivers.
 */

#include "ports.h"

//read a byte from the specified port
unsigned char port_byte_in(unsigned short port)
{
	unsigned char result;
	//"=a" (result)	-> point al to result
	//"d" (port)	-> load edx with port
	__asm__("in %%dx, %%al" : "=a" (result) : "d" (port));

	return result;
}

void port_byte_out(unsigned short port, unsigned char data)
{
	//"a" (data)	->	load eax with data
	//"d" (port)	->	load edx with port
	__asm__("out %%al, %%dx" :: "a" (data), "d" (port));
}

unsigned short port_word_in(unsigned short port)
{
	unsigned short result;
	__asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));

	return result;
}

void port_word_out(unsigned short port, unsigned short data)
{
	__asm__("out %%ax, %%dx" :: "a" (data), "d" (port));
}
