/*
 * Various printing and cursor managment functions that use CPU ports to interact with the screen.
 */

#include "screen.h"
#include "ports.h"

//print a string of characters at the current cursor position
void print(char *message)
{
	//begin printing at the current cursor position
	int position = get_cursor();

	//print each character successively until we reach the null termination
	int character = 0;
	while(message[character] != 0)
	{
		char *screen = (char*)VIDEO_ADDRESS;

		//check for '\n' newline characters
		if(message[character] == '\n')
		{
			int column = position % WIDTH;
			position += WIDTH - column;
		}
		else
		{
			screen[2 * position] = message[character]; //N.B., cells have size 2
			screen[(2 * position) + 1] = WHITE_ON_BLACK;
			position++;
		}

		character++;
	}

	//update the cursor to the end of our newly printed text
	set_cursor(2 * position);
}

void clear_screen()
{
	//set all cells to ' ', with the default attribute WHITE_ON_BLACK
	char *screen = (char*)VIDEO_ADDRESS;
	int screen_size = WIDTH * HEIGHT;
	for(int position = 0; position < screen_size; position++)
	{
			screen[2 * position] = ' ';
			screen[(2 * position) + 1] = WHITE_ON_BLACK;
	}

	//move the cursor to the top left of the screen
	set_cursor(0);
}

//set the cursor position using VGA ports
void set_cursor(int position)
{
	position /= 2;
	port_byte_out(REG_SCREEN_CTRL, 14); //high byte
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(position >> 8));
	port_byte_out(REG_SCREEN_CTRL, 15); //low byte
	port_byte_out(REG_SCREEN_DATA, (unsigned char)(position & 0xff));
}

//get the cursor position using VGA ports
int get_cursor()
{
	port_byte_out(REG_SCREEN_CTRL, 14); //high byte
	int position = port_byte_in(REG_SCREEN_DATA) << 8;
	port_byte_out(REG_SCREEN_CTRL, 15); //low byte
	position += port_byte_in(REG_SCREEN_DATA);

	return 2 * position;
}