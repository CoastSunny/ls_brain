/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package javagraphdraw;
import java.io.*;
import org.openide.util.Exceptions;


/**
 *
 * @author Lev
 */
public class GraphDraw {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        int ExitCode = 0;
         try {
            if (args.length < 1) {  System.err.println("At least one parameter (input file name) is requires ");  ExitCode = -2;  }
            if (ExitCode==0 && !new File(args[0]).exists()) { System.err.println("Missing file \"" + args[0] +"\""); ExitCode = -3; }
            if (ExitCode==0) {
             GraphLayout graphLayout = new  GraphLayout();
             if (ExitCode==0 && !graphLayout.Load(args[0])) { System.err.println("Failed loading instructions \"" + args[0] +"\"");ExitCode = -4;  }
             if (ExitCode==0 && !graphLayout.DrawGraph()) { System.err.println("Failed to generate the graph " ); ExitCode = -5; }         
            }
         }
         catch (java.lang.NullPointerException ex){
             ExitCode = -1; 
             ex.printStackTrace();
         }        
         finally {        System.exit(ExitCode);      }
    }
}
