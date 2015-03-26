//==================================================================================================
//
//
//
//	By Pranjal Chaubey for TRI Technosolutions Pvt. Ltd.
//	
//				pranjalchaubey@jssaten.ac.in
//
//
//
//==================================================================================================


#include<iostream.h>
#include<maze.h>
#include<stdlib.h>
#include<dos.h>
#include<math.h>


/*
|||||||||||||||||||||||||||||||||||||||

	
	current_dir -->

	   6   4   2   0
	-----------------
	|0|W|0|S|0|E|0|N|
	-----------------

	Wall representation -->

	 7       3 2 1 0
	-----------------
	|V|0|0|0|W|S|E|N|
	-----------------

||||||||||||||||||||||||||||||||||||||
*/


#define BIT0	0x01
#define BIT1	0x02
#define BIT2	0x04
#define BIT3	0x08
#define BIT4	0x10
#define BIT5	0x20
#define BIT6	0x40
#define BIT7	0x80

#define CHECKBIT(x,b)	(x&b)		//Checks bit 'b' in a byte 'x'
									//Returns 1 if 'b' is high, low 
									//otherwise


unsigned char current_dir = 1;		//Tells where the mouse is heading

unsigned char current_cell = 0;	//Represents the cell occupied by the mouse

unsigned char cell_count = 0;		//Counts the number of cells mouse has travelled


//Array to hold the Floodfill algorithm's values
unsigned char wallflood[256] ={

14, 13, 12, 11, 10, 9, 8, 7, 7, 8, 9, 10, 11, 12, 13, 14,
13, 12, 11, 10,  9, 8, 7, 6, 6, 7, 8,  9, 10, 11, 12, 13,
12, 11, 10,  9,  8, 7, 6, 5, 5, 6, 7,  8,  9, 10, 11, 12,
11, 10,  9,  8,  7, 6, 5, 4, 4, 5, 6,  7,  8,  9, 10, 11,
10,  9,  8,  7,  6, 5, 4, 3, 3, 4, 5,  6,  7,  8,  9, 10,
 9,  8,  7,  6,  5, 4, 3, 2, 2, 3, 4,  5,  6,  7,  8,  9,
 8,  7,  6,  5,  4, 3, 2, 1, 1, 2, 3,  4,  5,  6,  7,  8,
 9,  6,  5,  4,  3, 2, 1, 0, 0, 1, 2,  3,  4,  5,  6,  7,
 7,  6,  5,  4,  3, 2, 1, 0, 0, 1, 2,  3,  4,  5,  6,  7,
 8,  7,  6,  5,  4, 3, 2, 1, 1, 2, 3,  4,  5,  6,  7,  8,
 9,  8,  7,  6,  5, 4, 3, 2, 2, 3, 4,  5,  6,  7,  8,  9,
10,  9,  8,  7,  6, 5, 4, 3, 3, 4, 5,  6,  7,  8,  9, 10,
11, 10,  9,  8,  7, 6, 5, 4, 4, 5, 6,  7,  8,  9, 10, 11,
12, 11, 10,  9,  8, 7, 6, 5, 5, 6, 7,  8,  9, 10, 11, 12,
13, 12, 11, 10,  9, 8, 7, 6, 6, 7, 8,  9, 10, 11, 12, 13,
14, 13, 12, 11, 10, 9, 8, 7, 7, 8, 9, 10, 11, 12, 13, 14

};


unsigned char wallmap[256];	//Holds the Wall Map of the maze


void floodfill(unsigned char);	//Flood-filling
unsigned char step(void);	//Decides where to move after flood filling the maze


void floodfill(unsigned char destination)
{

	unsigned char neighbour_val[] = {255,255,255,255};	//Holds the neighbour values
	unsigned char wallinfo = 0, x = 0;
	int stk[512], stkptr = 0, stk_empty_flag = 0;		//Stack parameters
	unsigned char floodcell = 0;

	//MAKE SURE THE STACK IS EMPTY

	//====================================
	//PLEASE NOTE --> STACK EMPTY CHECK IS NOT REQUIRED
	//
	//
	//Initial conditions
	//stackptr = 0, stack_empty_flag = 0;
	//do just that!
	//Anything present in stack[] array
	//is immaterial.
	//====================================


	stk[0] = 255;

	//Push current cell, on which the mouse is standing, onto the stack
	stkptr += 1;
	stk[stkptr] = current_cell;


	//WHILE (STACK ISN'T EMPTY)

	//========================================================================================
	while (stk_empty_flag == 0)
	{
		//PULL A CELL FROM THE STACK
		//============================================================
		floodcell = stk[stkptr];

		//Check if the stack's empty
		if (stkptr == 1)
			stk_empty_flag = 1;	//stk's empty
		else
			stkptr -= 1;

		//============================================================


		//Find out the minimum value of open neighbours

		neighbour_val[0] = 255;	//Initialize 1st neighbour value
		neighbour_val[1] = 255;	//Initialize 2nd neighbour value
		neighbour_val[2] = 255;	//Initialize 3rd neighbour value
		neighbour_val[3] = 255;	//Initialize 4th neighbour value

		wallinfo = wallmap[floodcell];

		//North
		if (!(CHECKBIT(wallinfo, BIT0) ) )	//No North wall
			neighbour_val[0] = wallflood[floodcell + 16];

		//East
		if (!(CHECKBIT(wallinfo, BIT1) ) )	//No East wall
			neighbour_val[1] = wallflood[floodcell + 1];

		//South
		if (!(CHECKBIT(wallinfo, BIT2) ) )	//No South wall
			neighbour_val[2] = wallflood[floodcell - 16];

		//West
		if (!(CHECKBIT(wallinfo, BIT3) ) )	//No West wall
			neighbour_val[3] = wallflood[floodcell - 1];


		//Find the minimum value
		x = 0;
		while (x < 3)
		{
			//Minimum Value is stored in neighbour_val[0]
			if (neighbour_val[0] > neighbour_val[x + 1])
				neighbour_val[0] = neighbour_val[x + 1];

			x += 1;
		}

		//IF THE CELL ISN'T THE DESTINATION CELL, ITS VALUE SHOULD BE 1+ THE MINIMUM
		//VALUE OF ITS OPEN NEIGHBOURS

		//=======================================================================================
		if ( (!(floodcell == destination)) && (!(wallflood[floodcell] == (1+neighbour_val[0]))) )

		//NO -->

		{
			//Change the cell to 1+ the minimum value of its open neighbours
			wallflood[floodcell] = 1 + neighbour_val[0];


			//Check if the Stack's full
			//Hang UP if TRUE
			//
			//
			//	||||WRITE YOUR CODE HERE||||


			//Push all of the cell's open neighbours onto the stack to be checked

			//North
			if (!(CHECKBIT(wallinfo, BIT0)))
			{
				stkptr += 1;
				stk[stkptr] = floodcell + 16;
				stk_empty_flag = 0;	//Stack isn't empty now
			}


			//East
			if (!(CHECKBIT(wallinfo, BIT1)))
			{
				stkptr += 1;
				stk[stkptr] = floodcell + 1;
				stk_empty_flag = 0;	//Stack isn't empty now
			}


			//South
			if (!(CHECKBIT(wallinfo, BIT2)))
			{
				stkptr += 1;
				stk[stkptr] = floodcell - 16;
				stk_empty_flag = 0;	//Stack isn't empty now
			}


			//West
			if (!(CHECKBIT(wallinfo, BIT3)))
			{
				stkptr += 1;
				stk[stkptr] = floodcell - 1;
				stk_empty_flag = 0;	//Stack isn't empty now
			}

		}	//End of 1+ Minimum value IF
		//=======================================================================================


	}	//While (stack isn't empty)
	//===========================================================================================


	return;

}	//End floodfill




unsigned char step(void)
{

	unsigned char neighbour_val[] = {255,255,255,255, 1};
	unsigned char wallinfo = 0, x = 0, x2 = 0;


	//Getting the values of all neighbouring cells
	wallinfo = wallmap[current_cell];


	//North
	if (!(CHECKBIT(wallinfo, BIT0)))	//No North cell
		neighbour_val[0] = wallflood[current_cell + 16];

	//East
	if (!(CHECKBIT(wallinfo, BIT1)))	//No East cell
		neighbour_val[1] = wallflood[current_cell + 1];

	//South
	if (!(CHECKBIT(wallinfo, BIT2)))	//No South cell
		neighbour_val[2] = wallflood[current_cell - 16];

	//West
	if (!(CHECKBIT(wallinfo, BIT3)))	//No West cell
		neighbour_val[3] = wallflood[current_cell - 1];

	//Find the minimum value
	x = 0;
	x2 = 0;
	while (x < 3)
	{
		//Minimum Value direction is stored in neighbour_val[4]
		//Minimum Value is stored in neighbour_val[0]....which is not required here
		if (neighbour_val[0] > neighbour_val[x + 1])
		{
			x2 = x + 1;

			//Try to figure out yourself what has been done in the line below
			//There are easy methods, but I wanted a brain teaser for
			//the reader :-)
			neighbour_val[4] = pow(2, ( 2 * x2 )) ;
			neighbour_val[0] = neighbour_val[x + 1];

		}

		x += 1;
	}	//End Minimum Value While


	//Moving Straight
	//========================================================
	if (current_dir == neighbour_val[4])
	{
		neighbour_val[4] = 'M';
		return neighbour_val[4];
	}
	//=========================================================


	//Turning Right
	//=========================================================
	if ( ((current_dir == 64) && (neighbour_val[4] == 1))
		|| (current_dir == (neighbour_val[4]/4)) )
	{
		neighbour_val[4] = 'R';
		return neighbour_val[4];
	}
	//==========================================================


	//Turning Left
	//==========================================================
	if ( ((current_dir == 1) && (neighbour_val[4] == 64))
		|| (current_dir == (4 * neighbour_val[4])) )
	{
		neighbour_val[4] = 'L';
		return neighbour_val[4];
	}
	//============================================================


	//Turn 180 degrees
	//============================================================
	neighbour_val[4] = 'F';
	return neighbour_val[4];
	//============================================================

}	//End Step


void main()
{

	unsigned char y = 0;
	unsigned char wall_string;		//Holds the wall info to be written in wallmap (EEPROM)
	unsigned char stepper;			//Temporarily holds the movement command


	show_maze();

	//Initialize.......
	for(y = 0; y<=254; y++)
	{
		wallmap[y] = 0;
	}

	//First cell of the maze has the same
	//configuration
	wallmap[0] = 142;

	movestraight(1);


	//==================================================
	cell_count += 1;


	if (current_dir == 1)	current_cell += 16;
	if (current_dir == 4)	current_cell += 1;
	if (current_dir == 16)	current_cell -= 16;
	if (current_dir == 64)	current_cell -= 1;
	//=================================================


	//Start..............
	while(1)
	{

		//North
		if (current_dir == 1)
		{
			cell_count = 0;
			wall_string = ((1<<7) | (sense(LEFT)<<3) | (0<<2) | (sense(RIGHT)<<1) | (sense(FRONT)));
			wallmap[current_cell] = wall_string;
		}

		//East
		if (current_dir == 4)
		{
			cell_count = 0;
			wall_string = ((1<<7) | (0<<3) | (sense(RIGHT)<<2) | (sense(FRONT)<<1) | (sense(LEFT)));
			wallmap[current_cell] = wall_string;
		}

		//South
		if (current_dir == 16)
		{
			cell_count = 0;
			wall_string = ((1<<7) | (sense(RIGHT)<<3) | (sense(FRONT)<<2) | (sense(LEFT)<<1) | (0));
			wallmap[current_cell] = wall_string;
		}

		//West
		if (current_dir == 64)
		{

			cell_count = 0;
			wall_string = ((1<<7) | (sense(FRONT)<<3) | (sense(LEFT)<<2) | (0<<1) | (sense(RIGHT)));
			wallmap[current_cell] = wall_string;
		}



		floodfill(119);		//Maze center is our destination
		stepper = step();

		//Check if already in the center
		//Stop if true
		if (current_cell == 119)
			while(1){}

		if (stepper == 'R')	//Turn Right
		{
			turnright();
			//=============================================
			current_dir *= 4;
			if (current_dir == 0)	current_dir = 1;
			cell_count = 0;
			//=============================================
		}
		else if (stepper == 'L')	//Turn Left
		{
			turnleft();
			//=================================================
			current_dir /= 4;
			if (current_dir == 0)	current_dir = 64;

			cell_count = 0;
			//=================================================


		}
		else if (stepper == 'F')	//Turn Full
		{
			turnleft();
			turnleft();
			//==================================================
			current_dir *= 4;
			if (current_dir == 0)	current_dir = 1;
			current_dir *= 4;
			if (current_dir == 0)	current_dir = 1;


			cell_count = 0;
			//==================================================


		}
		//Move Straight
		//
		//
		//NOTE -->
		//Move straight has been kept out of the 'if' construct
		//because after taking any type of turn the first thing
		//that a mouse needs to do is to move into the
		//next cell, thus it has to 'movestraight' anyway
		movestraight(1);
		//=================================================
		cell_count += 1;


		if (current_dir == 1)	current_cell += 16;
		if (current_dir == 4)	current_cell += 1;
		if (current_dir == 16)	current_cell -= 16;
		if (current_dir == 64)	current_cell -= 1;
		//==================================================

	}

}



