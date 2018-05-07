//some useful screen-related constants
#define VIDEO_ADDRESS 0xb8000 //beginning of the video display memory
#define WIDTH 80 //width of the screen (in lines)
#define HEIGHT 25 //height of the screen (in lines)
#define WHITE_ON_BLACK 0x0f //standard colour scheme

//screen device I/O ports
#define REG_SCREEN_CTRL 0x3d4
#define REG_SCREEN_DATA 0x3d5

void print(char *message);
void clear_screen();
void set_cursor(int position);
int get_cursor();