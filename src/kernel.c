// Color text mode
volatile unsigned char *video = 0xb8000;

const int SCREEN_WIDTH = 80;
const char EOS = '\0';
const char ZERO = '0';
const int WHITE = 0xf;

int next_text_position = 0;
int current_line = 0;

void print(char *);
void println();
void printi(int);

void kernel_main()
{
	char *s = "Hello from C";
	int n = -539;
	print(s);
	println();
	printi(n);
	println();
	while (1)
	{
		// loop
	};
}

void print(char *str)
{
	int current_char_location;
	int current_color_location;

	while (*str != EOS)
	{
		current_char_location = next_text_position * 2;
		current_color_location = current_char_location + 1;

		video[current_char_location] = *str;
		video[current_color_location] = WHITE;

		++next_text_position;
		++str;
	}
}

void println()
{
	next_text_position = ++current_line * SCREEN_WIDTH;
}

void printi(int number)
{
	if (number < 0)
	{
		print("-");
		number = -number;
	}

	if (number >= 10)
	{
		printi(number / 10);
	}

	int final_digit = number % 10;
	char str[2];
	str[0] = ZERO + final_digit;
	str[1] = EOS;
	print(str);
}
