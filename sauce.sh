#!/bin/bash -x

source util.sh

function clean {
    removeDirectory target
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
    cp samples/special-k/* $targetDir
    # Generate and compile Java files to target then test grammar
    pushd $targetDir
    antlr4 -o generated $grammarFile
    javac generated/*.java -d .
    grun $grammarName compilationUnit *.sk
    popd
}


function main {
    clean
    recreateDirectory target
    gmcs csharp/preprocess.cs -out:target/preprocess.exe
    runGrammar grammars/special-k/SpecialK.g4
}

main

