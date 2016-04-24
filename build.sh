#!/bin/bash -x

function antlr4 {
    java -jar /usr/local/lib/antlr-4.5.3-complete.jar $*
}

function grun {
    java org.antlr.v4.gui.TestRig $*
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
    cp grammars/java/Java.g4 target
    antlr4 -o generated grammars/java/Java.g4
    javac generated/grammars/java/*.java -d target
    pushd target
    grun Java compilationUnit ../generated/grammars/java/*.java
    popd
}

function clean {
    removeDirectory target
    removeDirectory generated
}    

function main {
    clean
    
    recreateDirectory target
    runGrammar
}

main

