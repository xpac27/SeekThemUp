import java.awt.*;
import java.awt.event.*;
import javax.media.opengl.*;
import javax.media.opengl.glu.*;

import com.sun.opengl.util.Animator;

import game.Main;
import game.event.Key;


public class Game extends Frame
{
    public Game()
    {
        super("seekThemUp - v0.1");

        this.addWindowListener(new WindowAdapter()
        {
            public void windowClosing(WindowEvent e)
            {
                System.exit(0);
            }
        });

        // Create a new window
        setSize(640, 480);
        setLocation(320, 160);
        setVisible(true);
        setupJOGL();
    }

    private void setupJOGL()
    {
        GLCapabilities caps = new GLCapabilities();
        caps.setDoubleBuffered(true);
        caps.setHardwareAccelerated(true);

        GLCanvas canvas = new GLCanvas(caps);

        Animator anim = new Animator(canvas);
        anim.start();

        // Add Listeners
        canvas.addGLEventListener(new game.Main());
        canvas.addKeyListener(new game.event.Key());

        add(canvas, BorderLayout.CENTER);
    }

    public static void main(String[] args)
    {
        // Create Game
        Game game = new Game();
        game.setVisible(true);
    }
}

