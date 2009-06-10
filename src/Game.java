import java.awt.*;
import java.awt.event.*;

import javax.media.opengl.*;
import javax.media.opengl.glu.*;

import com.sun.opengl.util.Animator;

import game.Main;

public class Game extends Frame
{
    public Game()
    {
        super("Base game");

        this.addWindowListener(new WindowAdapter()
        {
            public void windowClosing(WindowEvent e)
            {
                System.exit(0);
            }
        });

        setSize(640, 480);
        setLocation(320, 160);
        setVisible(true);
        setupJOGL();
    }

    public static void main(String[] args)
    {
        Game game = new Game();
        game.setVisible(true);
    }

    private void setupJOGL()
    {
        GLCapabilities caps = new GLCapabilities();
        caps.setDoubleBuffered(true);
        caps.setHardwareAccelerated(true);

        GLCanvas canvas = new GLCanvas(caps);

        Animator anim = new Animator(canvas);
        anim.start();

        Main app = new Main();
        canvas.addGLEventListener(app);
        canvas.addKeyListener(app);

        add(canvas, BorderLayout.CENTER);
    }
}

