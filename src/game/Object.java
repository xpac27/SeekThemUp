package game;

import javax.media.opengl.*;


public class Object
{
    protected float x = 0.0f;
    protected float y = 0.0f;

    public Object()
    {
    }

    public void goToPosition(GL gl)
    {
        gl.glTranslatef(this.x, this.y, -100.0f);
    }
}

