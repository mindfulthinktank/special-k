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

