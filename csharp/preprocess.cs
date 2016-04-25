using System;
using System.IO;

namespace Mindfulthinktank.Utilities
{
  /// Preprocesses a file for C-style #include directives.
  ///
  class Program {
    public static void Main(string[] arguments) {
      if (arguments.Length != 3) {
        throw new Exception(string.Format("Expecting 3 arguments; got {0}: {1}",
	  arguments.Length, string.Join(", ", arguments)));
      }

      string inputFileName = arguments[0];
      string outputFileName = arguments[1];
      string pathsToIncludes = arguments[2];
      string[] paths = pathsToIncludes.Split(
        new char[] {','},
	StringSplitOptions.None);

      using (var reader = new StreamReader(inputFileName)) {
        using (var writer = new StreamWriter(outputFileName)) {
	  string line = reader.ReadLine();
	  int lineNumber = 1;
	  while (line != null) {
     	    int index = line.Trim().IndexOf("#include");
            if (index == -1) {
	      // This is not an include directive line. Write as is to output.
	      //
	      writer.WriteLine(line);
	    } else {
	      // This is an include directive; extract the file name
	      //
  	      int start = line.IndexOf('"', index);
	      int end = line.IndexOf('"', start+1);
	      
	      if (start == -1 || end == -1) {
	        throw new Exception(string.Format(
	          "Malformed include quotes on line {0}: {1}",
	          lineNumber, line));
	      }
	      
              if (end != line.Trim().Length-1) {
	        throw new Exception(string.Format(
		  "Non whitespace after include quote: {0}", line));
	      }
	      
	      string include = line.Substring(start + 1, end - start - 1);

	      // Try to find the include file in one of the include paths.
	      // If found write entire contents to output.
	      //
              bool found = false;
	      foreach (var path in paths) {
	        string fullPath = Path.Combine(path, include);
		if (!File.Exists(fullPath)) continue;
		found = true;
		using (var includeReader = new StreamReader(fullPath)) {
		  writer.WriteLine(includeReader.ReadToEnd());
		}
		break;
	      }

              if (!found) {
	        throw new Exception(
		  string.Format("{0} on line {1} not found in {2}",
		  include, lineNumber, pathsToIncludes));
	      }
            }

	    // Move on to the next line in input file.
	    //
            line = reader.ReadLine();
	    lineNumber++;
	  }
	}
      }
    }
  }
}
