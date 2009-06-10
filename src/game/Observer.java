package game;

import java.util.*;


public class Observer
{
    private static game.Observer ref;

    private Observer(){}

    public static synchronized Observer getInstance()
    {
      if (ref == null)
      {
          ref = new game.Observer();
      }
      return ref;
    }


    // ----------------


    private HashMap eventRegister = new HashMap();

    public void registerEvent(String name)
    {
        Object[] emptyList = {};
        this.eventRegister.put(name, emptyList);
    }

    public void dispatchEvent(String name, String data)
    {
        System.out.println("dispatchEvent: " + name + " = " + data);
    }

//    public void observe(String name, Object method)
//    {
//    }
}

