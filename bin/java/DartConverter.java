import java.io.*;
import java.util.regex.*;

/**
 * Actionscript to Dart converter.
 * 
 * Based on Actionscript to Java converter by Boris van Schooten:
 * http://www.borisvanschooten.nl/blog/2011/05/01/a-mini-actionscript-3-to-java-converter/
 * 
 * Java RegExp Docs:
 * http://docs.oracle.com/javase/7/docs/api/java/util/regex/Pattern.html
 * 
 */
public class DartConverter {

	/**
	 * @param string Full path to the Java file you want to convert.
	 * @param string Basedir path. This will get 'substracted' from the Full path in order to preserve package dir structures
	 * @param string Full path to Output dir. Normally, your Dart project's lib directory
	 * @param string Name of the Dart library you want to create. 
	 */
	public static void main(String [] args) {
        if (args.length!=4) {
            System.out.println("\n Usage: java -jar DartConverter.jar <sourcefile> <basedir> <outputdir> <dartlib>\n");
            System.exit(0);
        }
        
        File file = new File(args[0]);
        String f = getContents(file);
       
        // replace package declaration
        f=f.replaceAll("(\\s*)package\\s+[a-z0-9.]+\\s*\\{","$1 part of " + args[3] + ";");
        // remove closing bracket at end of class
        f=f.replaceAll("\\}\\s*$","");
        // reposition override keyword
        f=f.replaceAll("(\\s+)override(\\s+)","$1@override$2\n\t\t");
        // remove Event Metadata
        f=f.replaceAll("(\\[Event\\(.*\\])","// $1");
        // remove Bindable Metadata
        f=f.replaceAll("(\\[Bindable\\(.*\\])","// $1");
        // replace interface
        f=f.replaceAll("interface","abstract class");
        // remove 'final' from class declaration
        f=f.replaceAll("final class","class");
        // delete imports
        f=f.replaceAll(".*import.*(\r?\n|\r)?","");
        // delete all scopes
        f=f.replaceAll("public|private|protected","");
        // convert * datatype
        f=f.replaceAll(":\\s*(\\*)",": dynamic");
        // convert Vector syntax and datatype (i.e. Vector.<int> to List<int>)
        f=f.replaceAll("Vector.([a-zA-Z0-9_<>]*)","List$1");

        // === constructors and functions ===
        // note: the unprocessed function parameters are enclosed by '%#'
        //       marks. These are replaced later.
       
        // constructors (detected by missing return type)
        f=f.replaceAll("([a-z]*)\\s+function\\s+(\\w*)\\s*\\Q(\\E\\s*"
            +"([^)]*)"
            +"\\s*\\Q)\\E(\\s*\\{)","\n\t$1 $2(%#$3%#)$4");

       
        // getters/setters
        f=f.replaceAll("([a-z]*\\s+)function\\s+(get|set)\\s+(\\w*)\\s*\\Q(\\E\\s*"
            +"([^)]*)"
            +"\\s*\\Q)\\E\\s*:\\s*([a-zA-Z0-9_.<>]*)","$1 $5 $2 $3(%#$4%#)");
        // remove empty parentheses from getters
        f=f.replaceAll("([a-zA-Z]*\\s+get\\s+\\w*\\s*)\\(%#%#\\)","$1");
        
        
        // functions
        f=f.replaceAll("([a-z]*\\s+)function\\s+(\\w*)\\s*\\Q(\\E\\s*"
                +"([^)]*)"
                +"\\s*\\Q)\\E\\s*:\\s*([a-zA-Z0-9_.<>]*)","$1 $4 $2(%#$3%#)");
       
        // deal with super call in constructor
        f=f.replaceAll("(\\s*\\{)\\s*(super\\s*\\Q(\\E.*\\Q)\\E);",": $2 $1");
        // disable super(this) in constructor
        f=f.replaceAll("(super\\s*\\Q(this)\\E)","super(/*this*/)");
        
        
        // remove zero parameter marks
        f=f.replaceAll("%#\\s*%#", "");
      
        // Now, replace unprocessed parameters (maximum 9 parameters)
        for (int i=0; i<9; i++) {
            // parameters w/o default values
            f=f.replaceAll("%#\\s*(\\w*)\\s*:\\s*([a-zA-Z0-9_.<>]*)\\s*,", "$2 $1,%#"); //first param of several
            f=f.replaceAll("%#\\s*(\\w*)\\s*:\\s*([a-zA-Z0-9_.<>]*)\\s*%#", "$2 $1"); //last or only param in declaration
            
            // parameters w/ default values. a bit tricky as dart has a special way of defining optional arguments
            //first find
            f=f.replaceAll("%#\\s*(\\w*)\\s*:\\s*([a-zA-Z0-9_.<>]*)\\s*=\\s*([^):,]*)\\s*,", "[$2 $1=$3, %##");
            //other finds
            f=f.replaceAll("%##\\s*(\\w*)\\s*:\\s*([a-zA-Z0-9_.<>]*)\\s*=\\s*([^):,]*)\\s*,", "$2 $1=$3, %##");
            //last find
            f=f.replaceAll("%##\\s*(\\w*)\\s*:\\s*([a-zA-Z0-9_.<>]*)\\s*=\\s*([^):,]*)\\s*%#", "$2 $1=$3]");
            
            //if only one param:
            f=f.replaceAll("%#\\s*(\\w*)\\s*:\\s*([a-zA-Z0-9_.<>]*)\\s*=\\s*([^):,]*)\\s*%#", "[$2 $1=$3]");
        }
 
        // === variable declarations ===
        f=f.replaceAll("var\\s+([a-zA-Z0-9_]*)\\s*:\\s*([a-zA-Z0-9_.<>]*)","$2 $1");

        // === const declarations ===
        f=f.replaceAll("const\\s+([a-zA-Z0-9_]*)\\s*:\\s*([a-zA-Z0-9_]*)","const $2 $1");
        f=f.replaceAll("static const","static final");
        // XXX multiple comma separated declarations not supported!
       
        // === more translations ===
        f=f.replaceAll("IEventDispatcher","/*I*/EventDispatcher");//no IEventDispatcher in StageXL
        f=f.replaceAll("Class","Type");
        f=f.replaceAll("Number","num");
        f=f.replaceAll("Boolean","bool");
        f=f.replaceAll("uint","int");
        f=f.replaceAll("Array","List");
        f=f.replaceAll(".push",".add");
        f=f.replaceAll("Vector","List");
        f=f.replaceAll("Dictionary","Map");
        f=f.replaceAll("(\\s+)Object","$1Map");
        f=f.replaceAll("trace","print");
        f=f.replaceAll("for\\s+each","for");
        f=f.replaceAll("!==","==");
        f=f.replaceAll("===","==");
        f=f.replaceAll("^:\\s(super\\(\\s*\\))","// $1");
        
        //Math
        f=f.replaceAll("Math\\.PI","PI");
        f=f.replaceAll("Math\\.max","/*Math.*/max");
        f=f.replaceAll("Math\\.tan","/*Math.*/tan");
        f=f.replaceAll("Math\\.sin","/*Math.*/sin");
        f=f.replaceAll("Math\\.cos","/*Math.*/cos");
        f=f.replaceAll("Math\\.min","/*Math.*/min");
        f=f.replaceAll("Math\\.floor\\Q(\\E(.+)\\Q)\\E","($1).floor()");
        f=f.replaceAll("Math\\.round\\Q(\\E(.+)\\Q)\\E","($1).round()");
        f=f.replaceAll("Math\\.abs\\Q(\\E(.+)\\Q)\\E","($1).abs()");
        f=f.replaceAll("Math\\.random\\Q(\\E\\Q)\\E","new Random().nextDouble()");
        f=f.replaceAll("toFixed\\Q(\\E(\\d+)\\Q)\\E","toStringAsFixed($1)");
        
        //Geometry
        f=f.replaceAll("new\\s+Point\\Q(\\E\\Q)\\E","new Point(0,0)");
        
        //Timer
        f=f.replaceAll("getTimer\\Q(\\E\\Q)\\E","/*getTimer()*/ (stage.juggler.elapsedTime*1000)");
        
        
        //when testing for null, this works in as3: if(variable). In Dart, we need if(variable != null)
        f=f.replaceAll("if\\s*\\Q(\\E\\s*([a-zA-Z0-9]+)\\s*\\Q)\\E","if( $1 != null)");
       
        // === typecasts ===
        
        // int(value) --> value.toInt()
        f=f.replaceAll("\\s+int\\s*\\Q(\\E([^)]+)\\Q)\\E","(($1).toInt())");
        // (Class) variable --> (variable as Class)
        f=f.replaceAll("\\Q(\\E([a-zA-Z^)]+)\\Q)\\E\\s*(\\w+)","($2 as $1)");
        // Class(variable) --> (variable as Class)
        f=f.replaceAll("^new([A-Z]+[a-zA-Z0-9]+)\\s*\\Q(\\E\\s*(\\w+)\\s*\\Q)\\E","($2 as $1)");

        //e.g. _ignoredRootViews ||= new List<DisplayObject>();
        f=f.replaceAll("(\\w+)\\s*\\|\\|\\=(.+);","($1 != null) ? $1 :$1 = $2;");
        
        
        /********* OUTPUT *********/
        
        //Convert CamelCase filename to match Dart convention (camel_case)
        String fileName = file.getName().replaceAll("(\\w*).\\w*", "$1");
        fileName = fileName.replaceAll("(IO|I|[^A-Z-])([A-Z])", "$1_$2").toLowerCase();
        
        // relativize file path
        String relative = new File(args[1]).toURI().relativize(file.getParentFile().toURI()).getPath();
        
        PrintWriter out;
        
        //write dart file to target
        try {
        	//create dirs if necessary
        	new File(args[2] + "/src/" + relative).mkdirs();
        	//write converted file
        	out = new PrintWriter(args[2] + "/src/" + relative + "/" + fileName + ".dart");
        	out.println(f);
        	out.close();
        }
        catch (FileNotFoundException e){
        	System.out.println("Couldn't write file: " + e);
        }
        
        //add class to library definition
        try {
        	out = new PrintWriter(new BufferedWriter(new FileWriter(args[2] + "/"+args[3]+".dart", true)));
        	out.println("part 'src/" + relative + fileName + ".dart';");
        	out.close();
        }
        catch (IOException io){
        	System.out.println("Couldn't write file: " + io);
        }
    }
	
	static public String getContents(File file) {
		StringBuffer contents = new StringBuffer();
		try {
			BufferedReader input = new BufferedReader(new FileReader(file));
			try {
				String line = null;
				while ((line = input.readLine()) != null) {
					contents.append(line);
					contents.append(System.getProperty("line.separator"));
				}
			} finally {
				input.close();
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		}
		return contents.toString();
	}
}