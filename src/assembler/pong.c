#include "standard.h"

#define WINDOW_WIDTH 99
#define WINDOW_OFFSCREEN 29
#define WINDOW_HEIGHT 32

#define ROW (WINDOW_WIDTH+WINDOW_OFFSCREEN)

#define TOPROW (2*ROW)

#define BOTTOM (WINDOW_WIDTH+WINDOW_OFFSCREEN)*(WINDOW_HEIGHT-1)

/// block - 33


void draw_walls() {
	int a = 0, b=0;
	for (a=0;a<WINDOW_WIDTH;a++) {
		put_chr_vga(31, 0, a);
		put_chr_vga(31, b, 0);
		put_chr_vga(31, b, WINDOW_WIDTH-1);
		b = b + WINDOW_WIDTH + WINDOW_OFFSCREEN;
	}
}

void clear_screen() {
	int a = 0, b = 0, pos=0;
	for(a=0;a<WINDOW_HEIGHT;a++) {
		for(b=0;b<WINDOW_WIDTH;b++) {
			put_chr_vga(' ', 0, pos);
			pos += 1;	
		}
		pos += WINDOW_OFFSCREEN;
	}
}

#define FLIPPER_WIDTH 12
#define FLIPPER_Y 31*ROW

void erase_flipper(int x) {
	int a = 0;
	for(a=0;a<FLIPPER_WIDTH;a++)
		put_chr_vga(' ', FLIPPER_Y, x+a);
}

void draw_flipper(int x) {
	int a = 0;
	for(a=0;a<FLIPPER_WIDTH;a++) {
		put_chr_vga('_', FLIPPER_Y, x+a);
	}
}

void draw_ball(int x, int y, int oldx, int oldy) {
	put_chr_vga(' ', oldy, oldx);
	put_chr_vga('*', y, x);
}

#define BALLZ_Y 30*ROW
#define SCORE_Y 2*ROW + 2

int main() {
	int a = 0,b=0, score;
	int flipper_x, old_flipper_x;
	int ballz_x, ballz_y=BALLZ_Y, lastballz_x, lastballz_y;
	int ball_dir_x, ball_dir_y;
	int flipper_speed,pause;
	//put_chr('i'); // Play init sound


start_game: // Reset game
	score = 0;
	flipper_x = 44;
	old_flipper_x = 44;
	ballz_x = 46;
	ballz_y=BALLZ_Y;
	lastballz_x=46;
	lastballz_y=BALLZ_Y;
	ball_dir_x = 1;
	ball_dir_y = -ROW;
	flipper_speed = 4;
	pause = 1;
	a = get_chr();
	clear_screen();
	while (1) {
		// Lets draw
		draw_walls();
		erase_flipper(old_flipper_x);
		draw_flipper(flipper_x);
		
		draw_ball(ballz_x, ballz_y, lastballz_x, lastballz_y);

		put_hex_vga(score, SCORE_Y);

		lastballz_x = ballz_x;
		lastballz_y = ballz_y;
		old_flipper_x = flipper_x;

		// Wait for keyboard input
/*		a = get_kbd_nb() & 0xf;
		if (a > -1)
			 put_chr_vga(a, 0, 276);

		if (a == 0x1c && flipper_x > 1)
			flipper_x -= flipper_speed;
		else if (a == 0x23 && flipper_x < (WINDOW_WIDTH - FLIPPER_WIDTH - 2))
			flipper_x += flipper_speed;
*/
		// Wait for serial input
		a = get_chr_nb();
		if (a > -1) put_chr(a);
	 	
		if (pause && a == 'w')
			pause = 0;

		if (a == 'a' && flipper_x > 1)
			flipper_x -= flipper_speed;
		else if (a == 'd' && flipper_x < (WINDOW_WIDTH - FLIPPER_WIDTH - 2))
			flipper_x += flipper_speed;

		if (ballz_x < 2 || ballz_x > (WINDOW_WIDTH - 3)) {
			ball_dir_x = -ball_dir_x;
		}
		if (ballz_y < TOPROW)
			ball_dir_y = -ball_dir_y;
		else if (ballz_y > FLIPPER_Y && (ballz_x > flipper_x && ballz_x < flipper_x + FLIPPER_WIDTH) ) {
			ball_dir_y = -ball_dir_y; 
			score += 10;
		}
		else if (ballz_y > FLIPPER_Y)
			break;
		// Only move when game is paused
		if (!pause) {
			ballz_x += ball_dir_x;
			ballz_y += ball_dir_y;
		}

	}
	put_chr('g');
	put_chr_vga('G', 640, 45);
	put_chr_vga('a', 640, 46);
        put_chr_vga('m', 640, 47);
        put_chr_vga('e', 640, 48);
        put_chr_vga(' ', 640, 49);
        put_chr_vga('o', 640, 50);
        put_chr_vga('v', 640, 51);
        put_chr_vga('e', 640, 52);
        put_chr_vga('r', 640, 53);
        put_chr_vga('!', 640, 54);
	goto start_game;
	return 0;
}

