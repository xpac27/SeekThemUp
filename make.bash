#!/bin/bash
if [ -d "bin" ]; then
    rm -Rf bin/*
else
    mkdir bin
fi

javac -sourcepath src -classpath bin src/Game.java -d bin

echo 'Done !'
