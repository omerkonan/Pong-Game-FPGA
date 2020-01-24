
/*
 * Pong Game
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xgpio.h"
#include "xparameters.h"
#include "Pong.h"
#include <unistd.h>


int main()
{
	int status;
	XGpio btnsw;
    init_platform();

//    Renderer

	status = XGpio_Initialize(&btnsw, XPAR_AXI_GPIO_0_DEVICE_ID);
	if (status != XST_SUCCESS) { return XST_FAILURE; }

	XGpio_SetDataDirection(&btnsw, 1, 0xFF); // Channel 1

//	 Create a pointer to the base of the starting address of the buffer
	volatile uint32_t *objs = (volatile uint32_t*)(XPAR_PONG_1_S_AXI_BASEADDR);

	u32 player1_py; // send to vhdl side as address
	u32 player1_dpy;
	u32 player2_py; // send to vhdl side as address
	u32 player2_dpy;
	u32 ball_px;
	u32 ball_py;
	u32 ball_dpx;
	u32 ball_dpy;
	int32_t is_initialized = 0;
	u32 player1_score;
	u32 player2_score;
	u32 speed;
	u32 player_size = 128;

	sleep(2);

	while(1){
		usleep(3000);

		u32 b = XGpio_DiscreteRead(&btnsw, 1); // Read buttons
		u32 s = XGpio_DiscreteRead(&btnsw, 2); // Read switches
		if (player1_score == 5 || player2_score == 5)
		{
			sleep(5);
			is_initialized = 0;
			player1_score = 0;
			player2_score = 0;
			objs[4] = (player1_score);
			objs[5] = (player2_score);
		}
		else
		{
			if (!is_initialized)
			{
				is_initialized = 1;
				ball_px = 624;
				ball_py = 360;
				ball_dpx = 1;
				ball_dpy = 1;
				speed = 1;
				player1_py = 296;
				player2_py = 296;
				player1_score = 0;
				player2_score = 0;

				objs[0] = (player1_py);
				objs[1] = (player2_py);
				objs[2] = (ball_px);
				objs[3] = (ball_py);
				objs[4] = (player1_score);
				objs[5] = (player2_score);

			}

//			Multi Player Mode
			if (b == 1)
			{
				if(player1_py > 590){
					player1_dpy = 0;
				}
				else{
					player1_dpy = speed;
				}
			}
			else if (b == 2)
			{
				if(player1_py < 62){
					player1_dpy = 0;
				}
				else
				{
					player1_dpy = -speed;
				}
			}
			else
			{
				player1_dpy = 0;
			}
			player1_py += player1_dpy ;
			if (s == 1)
			{
				player2_dpy = 0;

				if (b == 4)
				{
					if (player2_py > 590)
					{
						player2_dpy = 0;
					}
					else
					{
						player2_dpy = speed;
					}
				}
				else if (b == 8)
				{
					if(player2_py < 62)
					{
						player2_dpy = 0;
					}
					else
					{
						player2_dpy = -speed;
					}
				}
				else
				{
					player2_dpy = 0;
				}
				player2_py += player2_dpy ;
			}
//			Showcase Mode
			else if(s == 2){
				u32 top_set_1 = player1_py + 10;
				u32 bottom_set_1 = player1_py + player_size + 10;
				u32 top_set_2 = player2_py + 10;
				u32 bottom_set_2 = player2_py + player_size + 10;
				if(ball_px < 640){
					player2_dpy = 0;
					if ((top_set_1 < ball_py) && (bottom_set_1 > ball_py))
					{
						player1_dpy = 0;
					}
					else if (top_set_1 > ball_py)
					{
						if(player1_py < 62)
						{
							player1_dpy = 0;
						}
						else
						{
							player1_dpy = -speed;
						}
					}
					else
					{
						if (player1_py > 590)
						{
							player1_dpy = 0;
						}
						else
						{
							player1_dpy = speed;
						}
					}
				}
				else
				{
					player1_dpy = 0;
					if ((top_set_2 < ball_py) && (bottom_set_2 > ball_py))
					{
						player2_dpy = 0;
					}
					else if (top_set_2 > ball_py)
					{
						if(player2_py < 62)
						{
							player2_dpy = 0;
						}
						else
						{
							player2_dpy = -speed;
						}
					}
					else
					{
						if (player2_py > 590)
						{
							player2_dpy = 0;
						}
						else
						{
							player2_dpy = speed;
						}
					}
				}

				player2_py += player2_dpy;
				player1_py += player1_dpy;
			}
//			Single Player Mode
			else
			{
				u32 top_set = player2_py + 20;
				u32 bottom_set = player2_py + player_size + 20;
				if ((top_set < ball_py) && (bottom_set > ball_py))
				{
					player2_dpy = 0;
				}
				else if (top_set > ball_py)
				{
					if(player2_py < 62)
					{
						player2_dpy = 0;
					}
					else
					{
						player2_dpy = -speed;
					}
				}
				else
				{
					if (player2_py > 590)
					{
						player2_dpy = 0;
					}
					else
					{
						player2_dpy = speed;
					}
				}
				player2_py += player2_dpy;
			}

//			Ball Mechanics
			ball_py += ball_dpy;
			ball_px += ball_dpx;
//			Ball Mechanics for Y
			if (ball_py >= 679)
			{
				ball_dpy *= -1;
			}
			else if (ball_py <= 64)
			{
				ball_dpy *= -1;
			}

//			Ball Mechanics for X
			if (ball_px >= 1215 && ball_px < 1239){
				if (ball_py + 32 < player2_py + player_size + 32 && ball_py > player2_py - 32){
					if (ball_dpx == 1)
					{
						ball_dpx *= -1;
					}
				}
			}
			else if(ball_px >= 1239){
				player1_score += 1;
				sleep(1);
				ball_px = 624;
				ball_py = 360;
			}
			else if(ball_px <= 32 && ball_px > 10){
				if (ball_py + 32 < player1_py + player_size + 32 && ball_py > player1_py - 32)
				{
					if (ball_dpx == -1)
					{
						ball_dpx *= -1;
					}
				}
			}
			else if(ball_px <= 10){
					player2_score += 1;
					sleep(1);
					ball_px = 624;
					ball_py = 360;
			}
			else
			{
				ball_dpx *= 1;
			}
//			update objects
			objs[0] = (player1_py);
			objs[1] = (player2_py);
			objs[2] = (ball_px);
			objs[3] = (ball_py);
			objs[4] = (player1_score);
			objs[5] = (player2_score);
		}
	}
	return 0;
}
