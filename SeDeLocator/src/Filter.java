import java.io.*;
import java.util.*;

import com.ibm.wala.classLoader.SourceDirectoryTreeModule;
import com.ibm.wala.cast.java.ipa.callgraph.JavaSourceAnalysisScope;
import com.ibm.wala.ipa.callgraph.AnalysisScope;

public class Filter{
    public static void main (string [] args){
	string source = "/home/guanpu/Desktop/FormatCheck/software/cassandra/build/apache-cassandra-4.0-SNAPSHOT.jar";
	AnalysisScope scope = new JavaSourceAnalysisScope();
	scope.AddToScope(JavaSourceAnalysisScope.SOURCE, new SourceDirectoryTreeModule(new File(source)));
    }
}
