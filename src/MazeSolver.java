/**
 * @author Shaunak Vairagare
 *
 */
public class MazeSolver implements Runnable
{
	//simulator object
	MazeSimulator sim;
	//macro Definations 
	static short N=0;
	static short E=1;
	static short S=2;
	static short W=3;
	static short B=100;//backtrack

	static short TRUE=1;
	static short FALSE=0;
	
	//Logical Storage
	short mouseR;
	short mouseC;

	short ori;
	short quad;
	short zone;
	short pathcount;
	short deadFlag;
	short cameFrom;
	short map[][]=new short[33][33];
	short wall[]=new short[4];
	short wallflood[]={

			14, 13, 12, 11, 10, 9, 8, 7, 7, 8, 9, 10, 11, 12, 13, 14,
			13, 12, 11, 10,  9, 8, 7, 6, 6, 7, 8,  9, 10, 11, 12, 13,
			12, 11, 10,  9,  8, 7, 6, 5, 5, 6, 7,  8,  9, 10, 11, 12,
			11, 10,  9,  8,  7, 6, 5, 4, 4, 5, 6,  7,  8,  9, 10, 11,
			10,  9,  8,  7,  6, 5, 4, 3, 3, 4, 5,  6,  7,  8,  9, 10,
			 9,  8,  7,  6,  5, 4, 3, 2, 2, 3, 4,  5,  6,  7,  8,  9,
			 8,  7,  6,  5,  4, 3, 2, 1, 1, 2, 3,  4,  5,  6,  7,  8,
			 7,  6,  5,  4,  3, 2, 1, 0, 0, 1, 2,  3,  4,  5,  6,  7,
			 7,  6,  5,  4,  3, 2, 1, 0, 0, 1, 2,  3,  4,  5,  6,  7,
			 8,  7,  6,  5,  4, 3, 2, 1, 1, 2, 3,  4,  5,  6,  7,  8,
			 9,  8,  7,  6,  5, 4, 3, 2, 2, 3, 4,  5,  6,  7,  8,  9,
			10,  9,  8,  7,  6, 5, 4, 3, 3, 4, 5,  6,  7,  8,  9, 10,
			11, 10,  9,  8,  7, 6, 5, 4, 4, 5, 6,  7,  8,  9, 10, 11,
			12, 11, 10,  9,  8, 7, 6, 5, 5, 6, 7,  8,  9, 10, 11, 12,
			13, 12, 11, 10,  9, 8, 7, 6, 6, 7, 8,  9, 10, 11, 12, 13,
			14, 13, 12, 11, 10, 9, 8, 7, 7, 8, 9, 10, 11, 12, 13, 14

			};
	private long delay;

	
	void initializeSystem()
	{
		 mouseR=15;
		 mouseC=0;
		 
		 ori=N;
		 quad=3;
		 zone=6;
		 pathcount=2;
		 deadFlag=FALSE;
		 cameFrom=S;
		 map[32][1]=1;
		 wall[N]=1;
		 
		 for(short r=0;r<16;r++)
			 for(short c=0;c<16;c++)
			 {
				 map[m(r)][m(c)]=1;
				
			 }
		 //--------temp code ends here------------------
		 
		 sim.updateSystem(mouseR, mouseC, map);
	}
	
	//Functions to replace in code finally
	short m(short val)//to convert mouse coordinates in to matrix coordinate
	{
		return (short)((val*2)+1);
	}
	short valInArray(short r,short c)
	{
		short val=0;
				
		val=(short)((r*16)+c);
		return val;
	}
	
	//Functions to replace in code finally END here
	
	void move_north()
	{
		System.out.println("move N");
		mouseR-=1;
		ori=N;
		if(deadFlag==FALSE)pathcount++;
		else  if(deadFlag==TRUE)pathcount--;
		
	}
	
	void move_south()
	{
		System.out.println("move S");
		mouseR+=1;
		ori=S;

		if(deadFlag==FALSE)pathcount++;
		else if(deadFlag==TRUE) pathcount--;
	}

	void move_east()
	{
		System.out.println("move E");
		mouseC+=1;
		ori=E;

		if(deadFlag==FALSE)pathcount++;
		else if(deadFlag==TRUE) pathcount--;
	}

	void move_west()
	{
		System.out.println("move W");
		mouseC-=1;
		ori=W;
		
		if(deadFlag==FALSE)pathcount++;
		else if(deadFlag==TRUE) pathcount--;
	}

	void setdead(short r, short c)
	{
		map[r][c]=0;
		deadFlag=TRUE;
	}
	
	void backtrack()
	{
		System.out.println("back, came from="+cameFrom);
		
		setdead(m(mouseR),m(mouseC));

	 	  if(cameFrom==S && wall[S]==FALSE) move_south();
	 else if(cameFrom==W && wall[W]==FALSE) move_west();
	 else if(cameFrom==N && wall[N]==FALSE) move_north();
	 else if(cameFrom==E && wall[E]==FALSE) move_east();
	 	 
	}
	
	void see_where_you_came_from()
	{
	    
		if(mouseR>0 &&  map[m(mouseR)-2][m(mouseC)  ]==(pathcount-1)) cameFrom=N;
	 else if(mouseC<15 && map[m(mouseR)  ][m(mouseC)+2]==(pathcount-1)) cameFrom=E;
	 else if(mouseR<15 && map[m(mouseR)+2][m(mouseC)  ]==(pathcount-1)) cameFrom=S;
	 else if(mouseC>0 &&  map[m(mouseR)  ][m(mouseC)-2]==(pathcount-1)) cameFrom=W;
	}
	
	void scan()
	{
		short sensorOp,L,F,R;
		sensorOp=sim.readSensors(m(mouseR),m(mouseC),ori);//this function returns 1's/0's in LFR format
				
		L=(short)(ori-1);if(L<0)L=W;
		F=ori;
		R=(short)((ori+1)%4);//to keep o/p between NESW(0,1,2,3)
			
		
		wall[(ori+2)%4]=wall[(((ori+2)%4)+2)%4];
		wall[R]=(short)(sensorOp%10);sensorOp/=10;
		wall[F]=(short)(sensorOp%10);sensorOp/=10;
		wall[L]=(short)(sensorOp%10);
		
		System.out.println("N="+wall[N]+" E="+wall[E]+" S="+wall[S]+" W="+wall[W]);
	}
	
	
	
	short sense()//returns 1 when center reached
	{
		System.out.println("mouse r="+mouseR+"mouse c="+mouseC);
		System.out.println("orientation="+ori);
		map[m(mouseR)][m(mouseC)]=pathcount;
		
		//if(deadFlag==FALSE)
		{	
			scan();
			map[m(mouseR)-1][m(mouseC)]=wall[N];
			map[m(mouseR)][m(mouseC)+1]=wall[E];
			map[m(mouseR)+1][m(mouseC)]=wall[S];
			map[m(mouseR)][m(mouseC)-1]=wall[W];
		}
		
		deadFlag=FALSE;
		////////////////////// Add Wall info in map matrix ////////////
		
		
		/////////////////////  mark new paths /////////////////////////
		
	    if(mouseR >0  && wall[N]==FALSE && map[m(mouseR)-2][m(mouseC)]==1)  map[m(mouseR)-2][m(mouseC)]=255; 
	    if(mouseR <15 && wall[S]==FALSE && map[m(mouseR)+2][m(mouseC)]==1)  map[m(mouseR)+2][m(mouseC)]=255;
	    if(mouseC >0  && wall[W]==FALSE && map[m(mouseR)][m(mouseC)-2]==1)  map[m(mouseR)][m(mouseC)-2]=255;
	    if(mouseC <15 && wall[E]==FALSE && map[m(mouseR)][m(mouseC)+2]==1)  map[m(mouseR)][m(mouseC)+2]=255;
		
	    //////////// win condition///////////////////

	   	/*if((map[m(mouseR)-2][m(mouseC)-2]>1)&&(map[m(mouseR)-2][m(mouseC)-1]==0)&&(map[m(mouseR)-2][m(mouseC)]>1)&&(map[m(mouseR)-1][m(mouseC)-2]==0)&&(map[m(mouseR)-1][m(mouseC)]==0)&&(map[m(mouseR)][m(mouseC)-2]>1)&&(map[m(mouseR)][m(mouseC)-1]==0)&&(map[m(mouseR)][m(mouseC)]>1))
		return(1);
		else
		if((map[m(mouseR)+2][m(mouseC)+2]>1)&&(map[m(mouseR)+2][m(mouseC)+1]==0)&&(map[m(mouseR)+2][m(mouseC)]>1)&&(map[m(mouseR)+1][m(mouseC)+2]==0)&&(map[m(mouseR)+1][m(mouseC)]==0)&&(map[m(mouseR)][m(mouseC)+2]>1)&&(map[m(mouseR)][m(mouseC)+1]==0)&&(map[m(mouseR)][m(mouseC)]>1))
		return(1);
		else return(0);*/
		
	  if((mouseR==7&&mouseC==7)||(mouseR==7&&mouseC==8)||(mouseR==8&&mouseC==7)||(mouseR==8&&mouseC==8))
		 {
		  return(1);
		  }
	   else
	   return(0);

	}
	
	void move()
	{
		/*System.out.println("--in move--");
		System.out.println("wall N="+wall[N]);
		System.out.println("mouse r="+mouseR);
		System.out.println("north cell value"+map[m(mouseR)-2][mouseC]);*/
		
			 if(mouseR >0  && wall[N]==FALSE && (map[m(mouseR)-2][m(mouseC)]>map[m(mouseR)][m(mouseC)])) move_north();
		else if(mouseC <15 && wall[E]==FALSE && (map[m(mouseR)][m(mouseC)+2]>map[m(mouseR)][m(mouseC)])) move_east();
		else if(mouseR <15 && wall[S]==FALSE && (map[m(mouseR)+2][m(mouseC)]>map[m(mouseR)][m(mouseC)])) move_south();	
		else if(mouseC >0  && wall[W]==FALSE && (map[m(mouseR)][m(mouseC)-2]>map[m(mouseR)][m(mouseC)])) move_west();
		else backtrack();
		see_where_you_came_from();
	}
	
	void moveByFloodPriority()
	{
		System.out.println("curr flood value ="+wallflood[valInArray(mouseR, mouseC)]);	
		short min=100;//just to check if min has  first value
		short selectDir=B;
		
		
		 if(mouseR >0  && wall[N]==FALSE && (map[m(mouseR)-2][m(mouseC)]>map[m(mouseR)][m(mouseC)]))
		 {
			
			 if(min==100)min=wallflood[valInArray((short)(mouseR-1), mouseC)];
			 if(wallflood[valInArray((short)(mouseR-1), mouseC)]<=min)
			 {
				 min=wallflood[valInArray((short)(mouseR-1), mouseC)];
				 selectDir=N; 
			 }
			 
			 System.out.println("North flood value ="+wallflood[valInArray((short)(mouseR-1), mouseC)]);
			 
		 }
		if(mouseC <15 && wall[E]==FALSE && (map[m(mouseR)][m(mouseC)+2]>map[m(mouseR)][m(mouseC)]))
		{
			
			if(min==100)min=wallflood[valInArray(mouseR,(short) (mouseC+1))];
			if(wallflood[valInArray(mouseR,(short) (mouseC+1))]<=min)
			{
				 min=wallflood[valInArray(mouseR,(short) (mouseC+1))];
				 selectDir=E; 
			}
			System.out.println("East flood value ="+wallflood[valInArray(mouseR,(short) (mouseC+1))]);
			
		}
		if(mouseR <15 && wall[S]==FALSE && (map[m(mouseR)+2][m(mouseC)]>map[m(mouseR)][m(mouseC)])) 
		 {
			
			if(min==100)min=wallflood[valInArray((short)(mouseR+1), mouseC)]; 
			if(wallflood[valInArray((short)(mouseR+1), mouseC)]<=min)
			 {
				 min=wallflood[valInArray((short)(mouseR+1), mouseC)];
				 selectDir=S;
			 }
			System.out.println("South flood value ="+wallflood[valInArray((short)(mouseR+1), mouseC)]);
			
		 }
		if(mouseC >0  && wall[W]==FALSE && (map[m(mouseR)][m(mouseC)-2]>map[m(mouseR)][m(mouseC)])) 
		 {
			
			if(min==100)min=wallflood[valInArray(mouseR,(short) (mouseC-1))]; 
			if(wallflood[valInArray(mouseR,(short) (mouseC-1))]<=min)
			 {
				 min=wallflood[valInArray(mouseR,(short) (mouseC-1))];
				 selectDir=W;
			 }
			System.out.println("West flood value ="+wallflood[valInArray(mouseR,(short) (mouseC-1))]);
			 
		 }
		
		if(selectDir==N)move_north();
		else if(selectDir==E)move_east();
		else if(selectDir==S)move_south();
		else if(selectDir==W)move_west();
		else if(selectDir==B)backtrack();
	
		 see_where_you_came_from();
	}
	void moveByFlood()
	{
		System.out.println("curr flood value ="+wallflood[valInArray(mouseR, mouseC)]);	
		short min=100;//just to check if min has  first value
		short selectDir=B;
		
		
		 if(mouseR >0  && wall[N]==FALSE )
		 {
			
			 if(min==100)min=wallflood[valInArray((short)(mouseR-1), mouseC)];
			 if(wallflood[valInArray((short)(mouseR-1), mouseC)]<=min)
			 {
				 min=wallflood[valInArray((short)(mouseR-1), mouseC)];
				 selectDir=N; 
			 }
			 
			 System.out.println("North flood value ="+wallflood[valInArray((short)(mouseR-1), mouseC)]);
			 
		 }
		if(mouseC <15 && wall[E]==FALSE )
		{
			
			if(min==100)min=wallflood[valInArray(mouseR,(short) (mouseC+1))];
			if(wallflood[valInArray(mouseR,(short) (mouseC+1))]<=min)
			{
				 min=wallflood[valInArray(mouseR,(short) (mouseC+1))];
				 selectDir=E; 
			}
			System.out.println("East flood value ="+wallflood[valInArray(mouseR,(short) (mouseC+1))]);
			
		}
		if(mouseR <15 && wall[S]==FALSE ) 
		 {
			
			if(min==100)min=wallflood[valInArray((short)(mouseR+1), mouseC)]; 
			if(wallflood[valInArray((short)(mouseR+1), mouseC)]<=min)
			 {
				 min=wallflood[valInArray((short)(mouseR+1), mouseC)];
				 selectDir=S;
			 }
			System.out.println("South flood value ="+wallflood[valInArray((short)(mouseR+1), mouseC)]);
			
		 }
		if(mouseC >0  && wall[W]==FALSE ) 
		 {
			
			if(min==100)min=wallflood[valInArray(mouseR,(short) (mouseC-1))]; 
			if(wallflood[valInArray(mouseR,(short) (mouseC-1))]<=min)
			 {
				 min=wallflood[valInArray(mouseR,(short) (mouseC-1))];
				 selectDir=W;
			 }
			System.out.println("West flood value ="+wallflood[valInArray(mouseR,(short) (mouseC-1))]);
			 
		 }
		
		if(selectDir==N)move_north();
		else if(selectDir==E)move_east();
		else if(selectDir==S)move_south();
		else if(selectDir==W)move_west();
		//else if(selectDir==B)backtrack();
	
		 //see_where_you_came_from();
	}
	void floodfill(short destination,short current_cell)
	{
		short neighbour_val[] = {255,255,255,255};	//Holds the neighbour values
		short x = 0;
		short stk[]=new short[512];
		short stkptr = 0, stk_empty_flag = 0;		//Stack parameters
		short floodcell = 0;
		short r,c;
		
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
			c=(short)(floodcell%16);
			r=(short)((floodcell-c)/16);
			
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

			
			if (map[m(r)-1][m(c)]==FALSE)	//No North wall
				neighbour_val[0] = wallflood[floodcell - 16];

			
			if (map[m(r)][m(c)+1]==FALSE)	//No East wall
				neighbour_val[1] = wallflood[floodcell + 1];

			
			if (map[m(r)+1][m(c)]==FALSE)	//No South wall
				neighbour_val[2] = wallflood[floodcell + 16];

			
			if (map[m(r)][m(c)-1]==FALSE)	//No West wall
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
				wallflood[floodcell] = (short)(1 + neighbour_val[0]);


				//Check if the Stack's full
				//Hang UP if TRUE
				//
				//
				//	||||WRITE YOUR CODE HERE||||


				//Push all of the cell's open neighbours onto the stack to be checked

				//North
				if (map[m(r)-1][m(c)]==FALSE)
				{
					stkptr += 1;
					stk[stkptr] = (short)(floodcell + 16);
					stk_empty_flag = 0;	//Stack isn't empty now
				}


				//East
				if (map[m(r)][m(c)+1]==FALSE)
				{
					stkptr += 1;
					stk[stkptr] = (short)(floodcell + 1);
					stk_empty_flag = 0;	//Stack isn't empty now
				}


				//South
				if (map[m(r)+1][m(c)]==FALSE)
				{
					stkptr += 1;
					stk[stkptr] = (short)(floodcell - 16);
					stk_empty_flag = 0;	//Stack isn't empty now
				}


				//West
				if (map[m(r)][m(c)-1]==FALSE)
				{
					stkptr += 1;
					stk[stkptr] = (short)(floodcell - 1);
					stk_empty_flag = 0;	//Stack isn't empty now
				}

			}	//End of 1+ Minimum value IF
			//=======================================================================================


		}	//While (stack isn't empty)
		//===========================================================================================


		return;

	}
	public MazeSolver(MazeSimulator sim, int delay)
	{
		this.sim=sim;
		this.delay=delay;
	}

	public void run()
	{
		initializeSystem();
		short centerReached=FALSE;
		while(centerReached==FALSE)
		{
			System.out.println("----------------------------");
			centerReached=sense();
			//floodfill((short)119, valInArray(mouseR, mouseC));
			sim.updateSystem(m(mouseR), m(mouseC), map);
			moveByFloodPriority();
			//move();
			
			try{Thread.sleep(delay);} catch (InterruptedException e){}
			
		}
		
	}

}
