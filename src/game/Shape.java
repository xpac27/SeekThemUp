package game;

import javax.media.opengl.*;
import javax.media.opengl.glu.*;

public class Shape
{
    public Shape()
    {
    }

    public void draw(GL gl)
    {
        gl.glPushMatrix();

        gl.glBegin(GL.GL_QUADS);

        gl.glColor3f(1, 0, 0);

        gl.glVertex2f(-10.0f, -10.0f);
        gl.glVertex2f(-10.0f,  10.0f);
        gl.glVertex2f( 10.0f,  10.0f);
        gl.glVertex2f( 10.0f, -10.0f);

        gl.glEnd();

        gl.glPopMatrix();
    }
}

