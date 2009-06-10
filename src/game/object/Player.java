package game.object;

import javax.media.opengl.*;
import javax.media.opengl.glu.*;

import game.Observer;
import game.Object;
import game.Shape;

public class Player extends game.Object
{
    protected Shape shape;

    public Player()
    {
        this.shape = new Shape();

//        game.Observer.getInstance().observe("keyPressed", this.handle_keyPressed);
    }

//    public void handle_keyPressed(key)
//    {
//    }

    public void compute()
    {
    }

    public void draw(GL gl)
    {
        gl.glPushMatrix();

        gl.glRotatef(10.0f, 0, 0, 1.0f);
        this.goToPosition(gl);
        this.shape.draw(gl);

        gl.glPopMatrix();
    }
}

