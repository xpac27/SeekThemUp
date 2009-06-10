package game;

import javax.media.opengl.*;
import javax.media.opengl.glu.*;

public class Object
{
    protected float x = 0.0f;
    protected float y = 0.0f;

    public Object()
    {
    }

    public void setPosition(float posX, float posY)
    {
        this.x = posX;
        this.y = posY;
    }

    public void goToPosition(GL gl)
    {
        gl.glTranslatef(this.x, this.y, -100.0f);
    }
}

