import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Frame;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * @author Shaunak Vairagare
 *
 */
public class MazeSimulator extends Frame implements Runnable
{
	//macro Definations 
	static short N=0;
	static short E=1;
	static short S=2;
	static short W=3;

	static short TRUE=1;
	static short FALSE=0;
	
	Graphics2D g;
	Image DBImg;
	int mouseR,mouseC;
	private static final int IMAGE_C = 50;
	private static final int IMAGE_R = 50;
	
	//Logical Veriables
	short maze[][]=new short [33][33];
	short map[][]=new short [33][33];
	
	public MazeSimulator(String fileName)
	{
		this.addWindowListener(new WindowAdapter(){public void windowClosing(WindowEvent we){System.exit(0);}});
		
		this.setSize(1280,729);
		setVisible(true);

		DBImg=createImage(getWidth(),getHeight());
		g=(Graphics2D)DBImg.getGraphics();
		g.addRenderingHints(new RenderingHints(RenderingHints.KEY_ANTIALIASING,RenderingHints.VALUE_ANTIALIAS_ON));
		readMaze(fileName);
		//readMaze("91japx.maze");
	}
	private void readMaze(String fileName)
	{
		BufferedReader br;
		try
		{
			br = new BufferedReader(new InputStreamReader(new FileInputStream("mazes/"+fileName)));
			int r=0;
			for (String line = br.readLine(); line != null; line = br.readLine(),r++)
			{
				System.out.println(line);
				for(int c=0;c<line.length();c++)
				{
					if(line.charAt(c)=='-')maze[r][c]=1;
					if(line.charAt(c)=='|')maze[r][c]=1;
					if(line.charAt(c)==' ')maze[r][c]=0;
					if(line.charAt(c)=='+')maze[r][c]=9;
					//System.out.print(maze[r][c]);	
				}
				//System.out.print("\n");
			}
	    	br.close();
	 
		} catch (FileNotFoundException e)
		{

			e.printStackTrace();
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
		
	    
	}
	
	public short readSensors(short r, short c, short ori)
	{
		short sensorVal=0;
		if(ori==N)
		{
			sensorVal=(short)((maze[r][c-1]*100)+(maze[r-1][c]*10)+(maze[r][c+1]));
		}
		else if(ori==E)
			{
				sensorVal=(short)((maze[r-1][c]*100)+(maze[r][c+1]*10)+(maze[r+1][c]));
			}
		else if(ori==S)
		{
			sensorVal=(short)((maze[r][c+1]*100)+(maze[r+1][c]*10)+(maze[r][c-1]));
		}
		else if(ori==W)
		{
			sensorVal=(short)((maze[r+1][c]*100)+(maze[r][c-1]*10)+(maze[r-1][c]));
		}
		
		System.out.println("sensor="+sensorVal);
		return sensorVal;
	}
	
	public void updateSystem(short r, short c, short map[][])
	{
		mouseR=r;
		mouseC=c;
		this.map=map;
	}
	
	public final void run()
	{
	  while(true)
		{

			g.setColor(Color.white);
			g.fillRect(0,0,getWidth(),getHeight());
			
			drawMaze(maze,5,5,30,g);
			drawMaze(map,600,5,30,g);
			repaint();
			try{Thread.sleep(30);}catch(InterruptedException e){}
		}// end of fwhile


	}
	
	private void drawMaze(short maze[] [],int topX, int topY,int cellWidth, Graphics2D g)
	{
		int cx=topX+(cellWidth/2),cy=topY+(cellWidth/2); //center x center y
		int tlx,tly,brx,bry;//top left x, top left y, right bottom x right bottom x
		
		BasicStroke b=new BasicStroke(4f);
		g.setStroke(b);
		for(int r=1;r<32;r+=2)
		{
			tly=cy-(cellWidth/2);
			bry=cy+(cellWidth/2);
			for(int c=1;c<32;c+=2)
			{
				
				tlx=cx-(cellWidth/2);
				brx=cx+(cellWidth/2);
				
				g.setColor(Color.black);
				if(r==mouseR && c==mouseC)g.fillOval(cx-10, cy-10, 20, 20);
				//draw cell value
				if(maze[r][c]==255){g.setColor(Color.green);g.fillOval(cx-5, cy-5, 10, 10);}
				else
				g.drawString(""+maze[r][c], cx, cy);
				
				
				
						
				g.setColor(Color.red);
				//draw north wall
				if(maze[r-1][c]==1)g.drawLine(tlx, tly, brx, tly);
				//draw East wall
				if(maze[r][c+1]==1)g.drawLine(brx, tly, brx, bry);
				//draw South wall
				if(maze[r+1][c]==1)g.drawLine(tlx, bry, brx, bry);
				//draw West wall
				if(maze[r][c-1]==1)g.drawLine(tlx, tly, tlx, bry);
				
				//draw pegs
				g.setColor(Color.black);
				g.fillRect(tlx-1, tly-1, 4, 4);
				g.fillRect(brx-1, tly-1, 4, 4);
				g.fillRect(brx-1, bry-1, 4, 4);
				g.fillRect(tlx-1, bry-1, 4, 4);
				
				cx+=cellWidth;
			}
			cy+=cellWidth;
			cx=topX+(cellWidth/2);
		}
	}
	public final void update(Graphics g)
	{
		paint(g);
	}
	public final void paint(Graphics g)
	{
		if(DBImg!=null)
		{
			g.drawImage(DBImg,IMAGE_C,IMAGE_R,null);
		}
	}
	public static void main(String[] args)
	{
		MazeSimulator sim=new MazeSimulator(args[0]);//"93japx.maze"
		new Thread(sim).start();
		
		MazeSolver sol=new MazeSolver(sim,Integer.parseInt(args[1]));
		new Thread(sol).start();
	}

}
