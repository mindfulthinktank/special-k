#!/bin/bash -x

source util.sh

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

