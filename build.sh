#!/bin/bash -x

function antlr4 {
    java -jar /usr/local/lib/antlr-4.5.3-complete.jar $*
}

function grun {
    java org.antlr.v4.gui.TestRig $*
}

function createIfNotExists {
    if [ ! -d "$1" ]; then
	mkdir -p $1
    fi
}

function recreateDirectory {
    if [ -d "$1" ]; then
	rm -rf $1
    fi

    mkdir -p $1
}

function removeDirectory {
    if [ -d "$1" ]; then
	rm -rf $1
    fi
}    

function runGrammar {
    grammarPath=$1
    grammarFile=`basename $1`
    grammarDir=`dirname $1`
    grammarName=$(echo $grammarFile | cut -f 1 -d '.')
    targetDir=target/$grammarDir

    # Copy grammar file to target
    createIfNotExists $targetDir
    target/preprocess.exe $grammarPath $targetDir/$grammarFile grammars/include
    
    # Generate and compile Java files to target then test grammar
    pushd $targetDir
    antlr4 -o generated $grammarFile
    javac generated/*.java -d .
    grun $grammarName compilationUnit generated/*.java
    popd
}

function runGrammars {
    runGrammar grammars/java/Java.g4
    runGrammar grammars/split-java/Java.g4
}

function clean {
    #TODO(Ibrahim) Need to find a better alternative.
    # Should delete files and directories ignored by git
    #git clean -xdi
    removeDirectory target
}    

function main {
    clean
    recreateDirectory target
    gmcs csharp/preprocess.cs -out:target/preprocess.exe
    runGrammars
}

main

