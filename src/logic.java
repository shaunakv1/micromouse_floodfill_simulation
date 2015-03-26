
public class logic
{
	currx=16;
	curry=1;

	ori=N;
	quad=3;
	zone=6;
	pathcount=2;
	
	void move_north()
	{
		currx-=1;
		gy=gy-25;
		ori=N;

		if(!dead_flag)
		{
			pathcount++;
			map[currx][curry]=pathcount;

		}
		else
		{
		 if(dead_flag)
		   {
			pathcount--;

		   }
		}
	}

	void move_south()
	{
		currx+=1;
		gy=gy+25;
		ori=S;

		if(!dead_flag)
		{
			pathcount++;
			map[currx][curry]=pathcount;

		}
		else
		{
		 if(dead_flag)
		   {
			pathcount--;

		   }
		}
	}

	void move_east()
	{
		curry+=1;
		gx=gx+25;
		ori=E;
		if(!dead_flag)
		{
			pathcount++;


		}
		else
		{
		 if(dead_flag)
		   {
			pathcount--;

		   }
		}
	}

	void move_west()
	{
		curry-=1;
		gx=gx-25;
		ori=W;

		if(!dead_flag)
		{
			pathcount++;
			map[currx][curry]=pathcount;

		}
		else
		{
		 if(dead_flag)
		   {
			pathcount--;

		   }
		}
	}

	void setdead(int x, int y)
	{
		map[x][y]=0;
		dead_flag=true;

	}

	void backtrack()
	{
	 setdead(currx,curry);

	 if(came_from==S)
	 {
	  move_south();
	 }
	 else
		if(came_from==W)
		{
		 move_west();
		}
	 else
		if(came_from==N)
		{
		 move_north();
		}
	 else
		if(came_from==E)
		{
		 move_east();
		}

	}


	void see_where_you_came_from()
	{
	 if(map[currx-1][curry]==(pathcount-1))came_from=N;
	 else if(map[currx][curry+1]==(pathcount-1)) came_from=E;
	 else if(map[currx+1][curry]==(pathcount-1)) came_from=S;
	 else if(map[currx][curry-1]==(pathcount-1)) came_from=W;
	}

	//--------------------------------------------------

	void scan(int mi,int mj)//Stores wall info of pos in wall array 1->present
							//                                      0->absent
	{
	 wall[N]=1;wall[S]=1;wall[E]=1;wall[W]=1;
	 short sensorOp=readSensors();
	 if(maze[mi-1][mj]==0||maze[mi-1][mj]==7) wall[N]=0;
	 if(maze[mi+1][mj]==0||maze[mi-1][mj]==7) wall[S]=0;
	 if(maze[mi][mj+1]==0||maze[mi-1][mj]==7) wall[E]=0;
	 if(maze[mi][mj-1]==0||maze[mi-1][mj]==7) wall[W]=0;
	}

	void pos_scan(int x,int y)//GETS THE CURRENT QUDRANT AND ZONE OF JERRY
	{
	// x=x/2;y=y/2;

	 if( (x>8) && (y<9) )
	   {
		quad=3;
	   }
	 else
	 if( (x>8) && (y>8) )
	   {
		quad=4;
	   }
	 else
	 if( (x<9) && (y<9) )
	   {
		quad=2;
	   }
	 else
	 if( (x<9) && (y>8) )
	   {
		quad=1;
	   }


	if( (x==8) && (y<9) )
	   {
		zone=11;
	   }
	 else
	 if( (x==9) && (y<9) )
	   {
		zone=12;
	   }
	 else
	 if( (x==8) && (y>8) )
	   {
		zone=15;
	   }
	 else
	 if( (x==9) && (y>8) )
	   {
		zone=16;
	   }
	 else
	 if( (x<8) && (y==8) )
	   {
		zone=9;
	   }
	 else
	 if( (x<8) && (y==9) )
	   {
		zone=10;
	   }
	 else
	 if( (x>9) && (y==8) )
	   {
		zone=13;
	   }
	 else
	 if( (x>9) && (y==9) )
	   {
		zone=14;
	   }
	 else
	 if( (x<8) && (y<8) && (y>=x))
	   {
		zone=3;
	   }
	 else
	 if( (x<8) && (y<8) && (y<x) )
	   {
		zone=4;
	   }
	 else
	 if( (x>9) && (y>9) && (y<=x))
	   {
		zone=7;
	   }
	 else
	 if( (x>9) && (y>9) && (y>x) )
	   {
		zone=8;
	   }
	 else
	 if( (x>9) && (y<8) && ((y+x)<17))
	   {
		zone=5;
	   }
	 else
	 if( (x>9) && (y<8) && ((y+x)>=17))
	   {
		zone=6;
	   }
	  else
	 if( (x<8) && (y>9) && ((y+x)<=17))
	   {
		zone=1;
	   }
	 else
	 if( (x<8) && (y>9) && ((y+x)>17))
	   {
		zone=2;
	   }
	}


	int sense()//returns 1 when center reached
	{


		map[currx][curry]=pathcount;

		scan((currx*2),(curry*2));

		pos_scan(currx,curry);

		dead_flag=false;

		looppathflag=false;

		/////////////////////  mark new paths /////////////////////////

	  if(wall[N]==0) // if north wall zero
		{
		   //	map[currx-1][curry]=0;//mark open wall in map matrix
			north=true;
			if( !((map[currx-1][curry]>1)&&(map[currx-1][curry]<254))&&(map[currx-1][curry]!=0))
			map[currx-1][curry]=300;
		}
	  else
		{
			north=false;
		   //map[currx-1][curry]=1;//mark closed wall in map matrix
		}

	  if(wall[S]==0) // if south wall is zero
		{
		   //	map[currx+1][curry]=0;
			south=true;
			if(!((map[currx+1][curry]>1)&&(map[currx+1][curry]<254))&&(map[currx+1][curry]!=0))
				map[currx+1][curry]=300;
		}
	  else
		{
			south=false;
		   //	map[currx+1][curry]=1;
		}

	  if(wall[W]==0) // if west wall is zero
		{
		   //	map[currx][curry-1]=0;
			west=true;
			if(!((map[currx][curry-1]>1)&&(map[currx][curry-1]<254))&&(map[currx][curry-1]!=0))
				map[currx][curry-1]=300;
		}
	  else
		{
			west=false;
		   //	map[currx][curry-1]=1;
		}

	  if(wall[E]==0) // if east wall is zero
		{
		   //	map[currx][curry+1]=0;
			east=true;
			if(!((map[currx][curry+1]>1)&&(map[currx][curry+1]<254))&&(map[currx][curry+1]!=0))
				map[currx][curry+1]=300;
		}
	  else
		{
			east=false;
		   //	map[currx][curry+1]=1;
		}




		//////////// win condition///////////////////

	   /*	if((map[currx-2][curry-2]>1)&&(map[currx-2][curry-1]==0)&&(map[currx-2][curry]>1)&&(map[currx-1][curry-2]==0)&&(map[currx-1][curry]==0)&&(map[currx][curry-2]>1)&&(map[currx][curry-1]==0)&&(map[currx][curry]>1))
		  {
			return(1);
		  }
		else
		 {
		  if((map[currx+2][curry+2]>1)&&(map[currx+2][curry+1]==0)&&(map[currx+2][curry]>1)&&(map[currx+1][curry+2]==0)&&(map[currx+1][curry]==0)&&(map[currx][curry+2]>1)&&(map[currx][curry+1]==0)&&(map[currx][curry]>1))
		   {
			 return(1);
		   }
		  else return(0);
		 }*/

	   if((currx==8&&curry==8)||(currx==8&&curry==9)||(currx==9&&curry==8)||(currx==9&&curry==9))
		 {
		  return(1);
		  }
	   else
	   return(0);

	}

	int try_north()
	{
	 if((map[currx-1][curry]>map[currx][curry])&&(currx>1)&&north)
		{
			move_north();
			return(true);
		}
	 else
	 return(false);
	}

	int try_south()
	{
	 if((map[currx+1][curry]>map[currx][curry])&&(currx<16)&&south)
			{
			 move_south();
			 return(true);
			}
	  else
	  return(false);
	}



	int try_east()
	{
	 if((map[currx][curry+1]>map[currx][curry])&&(curry<16)&&east)
			{
			 move_east();
			 return(true);
			}
	   else
	   return(false);
	}



	int try_west()
	{

	 if((map[currx][curry-1]>map[currx][curry])&&(curry>1)&&west)
			{
			 move_west();
			 return(true);
			}
	 else
	 return(false);
	}


	void moveAI1()
	{

	int moved=false;
	int priority=1;


	while(!moved)
		 {
		  if(dir[zone][priority][ori]==N)
			{
			 moved=try_north();
			}
		  else
		  if(dir[zone][priority][ori]==E)
			{
			 moved=try_east();
			}
		  else
		  if(dir[zone][priority][ori]==S)
			{
			 moved=try_south();
			}
		  else
		  if(dir[zone][priority][ori]==W)
			{
			 moved=try_west();
			}

		  priority++;

		  if(priority==5 && moved==false)
			{
			 moved=true;
			 backtrack();
			}

		 }



	see_where_you_came_from();
	}

	void move()
	{


		if((map[currx-1][curry]>map[currx][curry])&&(currx>1)&&north)
		{
			move_north();
		}

		else
			if((map[currx][curry-1]>map[currx][curry])&&(curry>1)&&west)
			{
			 move_west();
			}

		else
			if((map[currx+1][curry]>map[currx][curry])&&(currx<16)&&south)
			{
			 move_south();
			}

		else
			if((map[currx][curry+1]>map[currx][curry])&&(curry<16)&&east)
			{
			 move_east();
			}

		//////////// when no new turns exist  ///////////////////////////////
		else

		   backtrack();



	see_where_you_came_from();
	}
}
/*void positionScan()//GETS THE CURRENT QUDRANT AND ZONE OF JERRY
{
// mouseR=mouseR/2;mouseC=mouseC/2;

 if( (mouseR>8) && (mouseC<9) )quad=3;
 else if( (mouseR>8) && (mouseC>8) )quad=4;
 else if( (mouseR<9) && (mouseC<9) )quad=2;
 else if( (mouseR<9) && (mouseC>8) )quad=1;
 
 if( (mouseR==8) && (mouseC<9) )zone=11;
 else if( (mouseR==9) && (mouseC<9) )zone=12;
 else if( (mouseR==8) && (mouseC>8) )zone=15;
 else if( (mouseR==9) && (mouseC>8) )zone=16;
 else if( (mouseR<8) && (mouseC==8) )zone=9;
 else if( (mouseR<8) && (mouseC==9) )zone=10;
 else if( (mouseR>9) && (mouseC==8) )zone=13;
 else if( (mouseR>9) && (mouseC==9) )zone=14;
 else if( (mouseR<8) && (mouseC<8) && (mouseC>=mouseR))zone=3;
 else if( (mouseR<8) && (mouseC<8) && (mouseC<mouseR) )zone=4;
 else if( (mouseR>9) && (mouseC>9) && (mouseC<=mouseR))zone=7;
 else if( (mouseR>9) && (mouseC>9) && (mouseC>mouseR) )zone=8;
 else if( (mouseR>9) && (mouseC<8) && ((mouseC+mouseR)<17))zone=5;
 else if( (mouseR>9) && (mouseC<8) && ((mouseC+mouseR)>=17))zone=6;
 else if( (mouseR<8) && (mouseC>9) && ((mouseC+mouseR)<=17))zone=1;
 else if( (mouseR<8) && (mouseC>9) && ((mouseC+mouseR)>17))zone=2;
}*/