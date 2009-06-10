package game.event;

import java.awt.event.KeyListener;
import java.awt.event.KeyEvent;

import game.Observer;


public class Key implements KeyListener
{
    public Key()
    {
        game.Observer.getInstance().registerEvent("keyTyped");
        game.Observer.getInstance().registerEvent("keyPressed");
        game.Observer.getInstance().registerEvent("keyReleased");
    }

    public void keyTyped(KeyEvent e)
    {
        game.Observer.getInstance().dispatchEvent("keyTyped", Integer.toString(e.getKeyCode()));
    }

    public void keyPressed(KeyEvent e)
    {
        game.Observer.getInstance().dispatchEvent("keyPressed", Integer.toString(e.getKeyCode()));
    }

    public void keyReleased(KeyEvent e)
    {
        game.Observer.getInstance().dispatchEvent("keyReleased", Integer.toString(e.getKeyCode()));
    }
}

