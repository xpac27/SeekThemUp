package game;

import javax.media.opengl.*;
import javax.media.opengl.glu.*;

import game.object.Player;


public class Main implements GLEventListener
{
    protected game.object.Player player;

    public Main()
    {
        this.player = new game.object.Player();
    }

    public void init(GLAutoDrawable drawable)
    {
        final GL gl = drawable.getGL();

        gl.glClearColor(0.0f, 0.0f, 0.0f, 0.0f);                    //set black for the background
        gl.glShadeModel(GL.GL_SMOOTH);                              //Shade model, GL.GL_FLAT does interesting things when unknown
        gl.glClearDepth(1.0f);                                      //Set up depth buffer
        gl.glEnable(GL.GL_DEPTH_TEST);                              // Enables Depth Testing
        gl.glDepthFunc(GL.GL_LEQUAL);                               // The Type Of Depth Testing To Do
        gl.glHint(GL.GL_PERSPECTIVE_CORRECTION_HINT, GL.GL_NICEST); //Adds tiny amount of computation, makes things look nicer
    }

    public void reshape(GLAutoDrawable drawable, int x, int y, int width, int height)
    {
        GLU glu = new GLU();

        GL gl = drawable.getGL();

        if(height <= 0)
        {
            height =1;
        }

        float h = (float)width/(float)height;

        gl.glViewport(0, 0, width, height);         //Set viewport area
        gl.glMatrixMode(GL.GL_PROJECTION);          //Set matrix mode
        gl.glLoadIdentity();                        //reset everything
        glu.gluPerspective(45.0f, h, 99.0, 100.0);  //set perspective
        gl.glMatrixMode(GL.GL_MODELVIEW);           //set matrix mode
        gl.glLoadIdentity();                        //reset things
    }

    public void displayChanged(GLAutoDrawable drawable, boolean modeChanged, boolean deviceChanged)
    {
    }

    public void display(GLAutoDrawable drawable)
    {
        // Compute
        this.player.compute();

        // Draw
        GL gl = drawable.getGL();

        gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
        gl.glLoadIdentity();

        this.player.draw(gl);

        gl.glFlush();
    }
}

