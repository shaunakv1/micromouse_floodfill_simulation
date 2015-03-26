//==================================================================================================
//
//
//
//	By Manish Sharma for TRI Technosolutions Pvt. Ltd.
//	
//				manish.jss.noida@gmail.com
//
//
//
//==================================================================================================


#include<graphics.h>
#include<stdio.h>
#include<stdlib.h>
#include<conio.h>
#include<dos.h>

#define sizemaze 16
#define X 0
#define Y 0
#define length 28

#define LEFT  0
#define RIGHT 1
#define FRONT 2

#define EAST  0
#define WEST  2
#define NORTH 1
#define SOUTH 3


/*
//My Own test maze
//violates maze building rules!
int hori_walls[sizemaze+1][sizemaze]={{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},//0
				      {0,1,1,1,0,0,0,0,1,1,1,1,1,1,0,0},//1
				      {0,1,0,1,0,0,0,1,0,1,0,0,1,0,1,1},//2
				      {0,1,1,1,1,0,0,1,0,0,0,1,0,0,0,0},//3
				      {0,1,1,1,0,0,0,0,0,0,1,0,1,0,0,0},//4
				      {1,1,1,0,0,0,1,1,1,1,0,0,1,0,0,1},//5
				      {0,1,1,1,0,0,1,1,0,1,0,0,1,0,0,0},//6
				      {0,1,1,0,1,0,0,1,1,0,0,0,0,0,0,0},//7
				      {0,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0},//8
				      {0,1,0,0,0,0,0,1,1,0,0,0,1,1,0,1},//9
				      {0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0},//10
				      {0,0,0,1,1,0,1,0,1,0,1,0,1,1,1,0},//11
				      {0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0},//12
				      {0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0},//13
				      {0,1,1,1,0,0,0,1,0,1,1,0,0,1,1,0},//14
				      {0,1,1,0,0,1,1,1,1,0,0,0,0,0,0,0},//15
				      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}//16
				     };
int vert_walls[sizemaze][sizemaze+1]={{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},//0
				      {1,1,1,0,1,0,1,0,1,1,1,0,0,0,0,0,1},//1
				      {1,1,1,0,0,0,1,0,1,1,1,0,1,0,0,1,1},//2
				      {1,1,0,0,0,1,1,1,1,1,0,1,0,0,0,1,1},//3
				      {1,0,0,0,1,1,1,0,1,0,1,0,0,1,1,0,1},//4
				      {1,0,0,0,1,1,1,0,0,0,0,0,1,0,1,0,1},//5
				      {1,0,0,1,0,1,1,0,1,1,0,1,0,0,1,1,1},//6
				      {1,0,1,0,1,0,1,1,0,0,0,0,0,0,1,1,1},//7
				      {1,1,0,1,0,0,1,1,0,0,0,0,1,0,0,1,1},//8
				      {1,0,1,0,0,0,1,1,0,0,0,0,1,0,0,0,1},//9
				      {1,1,0,1,0,1,0,1,1,1,1,1,0,0,0,0,1},//10
				      {1,0,0,0,1,0,1,0,1,1,1,1,1,0,0,0,1},//11
				      {1,1,0,1,0,1,0,0,0,0,0,0,1,1,0,0,1},//12
				      {1,1,1,0,1,0,0,1,1,0,1,0,1,1,0,1,1},//13
				      {1,1,0,1,0,0,0,0,1,0,1,0,1,0,0,0,1},//14
				      {1,1,0,0,1,1,0,0,0,0,1,0,1,0,1,1,1}//15
				     };

 */
/*
//The Japan 1991 Maze
//Just Awesome!!!
int hori_walls[sizemaze+1][sizemaze]={
{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},//0
				      {0,1,1,0,1,0,0,1,0,1,1,0,1,1,0,1},//1
				      {0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0},//2
				      {0,0,1,0,1,1,1,1,0,1,1,0,1,0,1,0},//3
				      {0,1,0,1,0,1,0,1,0,1,0,1,1,1,0,0},//4
				      {0,0,1,0,1,0,0,1,0,1,0,1,0,1,1,0},//5
				      {0,1,0,1,1,0,0,1,0,1,0,0,0,0,1,0},//6
				      {0,0,1,0,1,1,0,1,1,0,0,1,0,1,0,0},//7
				      {0,1,1,0,0,0,0,0,0,0,1,0,0,0,0,0},//8
				      {1,1,1,1,0,0,1,1,1,1,0,1,0,0,0,0},//9
				      {1,1,1,0,1,1,1,0,1,0,1,1,0,0,0,0},//10
				      {1,1,0,1,1,1,0,1,0,1,0,1,1,0,0,0},//11
				      {0,1,1,1,0,1,1,0,1,1,0,0,1,0,0,0},//12
				      {0,0,1,0,0,1,0,0,1,1,1,0,1,0,0,0},//13
				      {0,0,1,1,0,1,0,1,1,1,1,1,1,1,0,0},//14
				      {0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0},//15
				      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}//16
				     };



int vert_walls[sizemaze][sizemaze+1]={
{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1},//0
				      {1,1,1,0,1,0,1,1,0,0,1,0,0,0,0,0,1},//1
				      {1,1,0,1,0,1,0,0,0,0,1,0,0,0,0,0,1},//2
				      {1,0,1,0,1,0,0,1,0,0,1,0,0,0,0,1,1},//3
				      {1,1,0,1,0,1,0,1,0,0,0,1,0,0,0,0,1},//4
				      {1,0,1,0,1,1,1,1,0,0,0,1,1,1,0,0,1},//5
				      {1,1,0,1,0,0,1,0,1,0,0,0,1,1,0,1,1},//6
				      {1,0,1,1,1,0,1,1,0,1,1,1,0,0,1,1,1},//7
				      {1,0,0,0,1,1,1,0,0,1,1,0,1,1,1,1,1},//8
				      {1,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1},//9
				      {1,0,0,0,0,0,0,0,1,0,1,0,0,1,1,1,1},//10
				      {1,0,0,0,0,0,0,1,0,1,1,1,0,0,1,1,1},//11
				      {1,1,0,0,1,0,0,0,0,0,0,1,1,1,1,1,1},//12
				      {1,1,0,0,0,1,1,1,0,0,0,0,0,0,1,1,1},//13
				      {1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1},//14
				      {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}//15
				     };

*/

//The US 1982 Maze
int hori_walls[sizemaze+1][sizemaze]={
{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},//0
				      {0,0,1,1,1,1,1,0,1,0,0,0,0,0,0,0},//1
				      {0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0},//2
				      {0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,0},//3
				      {0,0,0,0,0,0,0,0,1,1,1,0,1,1,0,0},//4
				      {0,0,0,0,0,0,0,0,1,1,1,0,1,1,0,0},//5
				      {0,0,0,0,0,0,0,0,1,1,1,0,1,1,0,0},//6
				      {0,1,0,0,0,0,0,1,1,1,1,1,1,1,1,0},//7
				      {0,1,0,0,0,0,0,0,0,1,1,1,1,1,0,0},//8
				      {0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0},//9
				      {0,0,0,0,0,0,0,0,1,1,1,0,1,1,0,0},//10
				      {0,0,0,0,0,0,0,0,1,1,1,0,1,1,0,0},//11
				      {0,0,0,0,0,0,0,0,1,1,1,0,1,1,0,0},//12
				      {0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,0},//13
				      {0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0},//14
				      {0,0,1,1,1,1,1,0,1,0,0,0,0,0,0,0},//15
				      {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}//16
				     };



int vert_walls[sizemaze][sizemaze+1]={
{1,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,1},//0
				      {1,1,0,0,0,0,1,1,0,0,1,1,1,1,1,1,1},//1
				      {1,1,1,1,1,1,1,1,0,0,1,1,0,0,1,1,1},//2
				      {1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1},//3
				      {1,1,0,1,1,1,1,1,0,0,0,0,0,0,0,1,1},//4
				      {1,1,1,1,0,0,0,1,0,0,0,0,0,0,0,1,1},//5
				      {1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1},//6
				      {1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1,1},//7
				      {1,1,1,1,1,1,1,1,0,1,0,0,0,0,0,0,1},//8
				      {1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1},//9
				      {1,1,1,1,0,0,0,1,0,0,0,0,0,0,0,1,1},//10
				      {1,1,0,1,1,1,1,1,0,0,0,0,0,0,0,1,1},//11
				      {1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1},//12
				      {1,1,1,1,1,1,1,1,0,0,1,1,0,0,1,1,1},//13
				      {1,1,0,0,0,0,1,1,0,0,1,1,1,1,1,1,1},//14
				      {1,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,1}//15
				     };



int direction=NORTH;
int pr_row=0,pr_column=0;  //pr stands for present

int m_x=length/2,m_y=15*length+length/2;

void put_mouse(int i,int j)
{
setcolor(getmaxcolor());
rectangle(i-8,j-8,i+8,j+8);
setfillstyle(SOLID_FILL,getmaxcolor());
floodfill(i,j,getmaxcolor());
}
void hide_mouse(int i,int j)
{
setcolor(BLACK);
rectangle(i-8,j-8,i+8,j+8);
setfillstyle(SOLID_FILL,BLACK);
floodfill(i,j,BLACK);
}

int sense(int WALL)
{
if(WALL==LEFT)
  {
    if(direction==NORTH)
      {
      return (vert_walls[sizemaze-1-pr_row][pr_column]);
      }
    if(direction==SOUTH)
      {
      return (vert_walls[sizemaze-1-pr_row][pr_column+1]);
      }
    if(direction==EAST)
      {
      return (hori_walls[sizemaze-1-pr_row][pr_column]);
      }
    if(direction==WEST)
      {
      return (hori_walls[sizemaze-pr_row][pr_column]);
      }
  }
if(WALL==RIGHT)
  {
    if(direction==NORTH)
      {
      return (vert_walls[sizemaze-1-pr_row][pr_column+1]);
      }
    if(direction==SOUTH)
      {
      return (vert_walls[sizemaze-1-pr_row][pr_column+1-1]);
      }
    if(direction==EAST)
      {
      return (hori_walls[sizemaze-1-pr_row+1][pr_column]);
      }
    if(direction==WEST)
      {
      return (hori_walls[sizemaze-1-pr_row][pr_column]);
      }
  }
if(WALL==FRONT)
  {
    if(direction==NORTH)
      {
      return (hori_walls[sizemaze-1-pr_row][pr_column]);
      }
    if(direction==SOUTH)
      {
      return (hori_walls[sizemaze-1-pr_row+1][pr_column]);
      }
    if(direction==EAST)
      {
      return (vert_walls[sizemaze-1-pr_row][pr_column+1]);
      }
    if(direction==WEST)
      {
      return (vert_walls[sizemaze-1-pr_row][pr_column]);
      }
  }
return -1;
}


void show_maze()
{

/* request auto detection */
int gdriver = DETECT, gmode, errorcode;
int i,j;

/* initialize graphics and local variables */
initgraph(&gdriver, &gmode, "");

/* read result of initialization */
errorcode = graphresult();
if (errorcode != grOk)  /* an error occurred */
{
   printf("Graphics error: %s\n", grapherrormsg(errorcode));
   printf("Press any key to halt:");
   getch();
   exit(1); /* terminate with an error code */
}

setcolor(BROWN);
for(i=0;i<=sizemaze;i++)
   for(j=0;j<sizemaze;j++)
   {
      if(hori_walls[i][j]==1)
	line(X+(length*j),Y+(i*length),X+(length*(j+1)),Y+(i*length));
   }
for(i=0;i<=sizemaze-1;i++)
   for(j=0;j<=sizemaze;j++)
   {
      if(vert_walls[i][j]==1)
	line(X+(j*length),Y+(i*length),X+(j*length),Y+((i+1)*length));
   }
setcolor(GREEN);
for(i=0;i<3;i++)
rectangle(X-i,Y-i,X+sizemaze*length+i,Y+sizemaze*length+i);

getch();
}

void turnleft()
{
direction=(direction+1)%4;
}
void turnright()
{
direction=(direction+3)%4;
}
void movestraight(int i)
{
int j;
hide_mouse(m_x,m_y);
if(direction==EAST)
  {
    pr_column++;
    for(j=0;j<i*length;j++)
    {  m_x++;
       put_mouse(m_x,m_y);
	   
	   
	   //================================================
	   
	   
	   //Changing this will change the animation speed
	   //Increasing it will slow the animation
       delay(3);
	   
	   
	   //================================================
	   
	   
       hide_mouse(m_x,m_y);
    }
    put_mouse(m_x,m_y);
  }
if(direction==WEST)
  {
  pr_column--;
    for(j=0;j<i*length;j++)
    {  m_x--;
       put_mouse(m_x,m_y);
	   
	   
	   //================================================
	   
	   
	   //Changing this will change the animation speed
	   //Increasing it will make the animation slow
       delay(3);
	   
	   
	   //================================================
	   
	   
       hide_mouse(m_x,m_y);
    }
    put_mouse(m_x,m_y);
  }
if(direction==NORTH)
  {
  pr_row++;
    for(j=0;j<i*length;j++)
    {  m_y--;
       put_mouse(m_x,m_y);
	   
	   
	   //================================================
	   
	   
	   //Changing this will change the animation speed
	   //Increasing it will make the animation slow
       delay(3);
	   
	   
	   //================================================
	   
	   
       hide_mouse(m_x,m_y);
    }
    put_mouse(m_x,m_y);
  }
if(direction==SOUTH)
  {
  pr_row--;
    for(j=0;j<i*length;j++)
    {  m_y++;
       put_mouse(m_x,m_y);
	   
	   
	   //================================================
	   
	   
	   //Changing this will change the animation speed
	   //Increasing it will make the animation slow
       delay(3);
	   
	   
	   //================================================
	   
	   
       hide_mouse(m_x,m_y);
    }
    put_mouse(m_x,m_y);
  }
}




