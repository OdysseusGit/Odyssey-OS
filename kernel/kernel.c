/*
 * A simple kernel that displays a welcome message for Odyssey OS.
 */

#include "../drivers/screen.h"

void kernel_main()
{
	clear_screen();
	print("Welcome to Odyssey OS.\n");
}