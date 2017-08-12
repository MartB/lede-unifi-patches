#!/bin/bash
set -e
directory=./feeds

if [ ! -f compiler-latest.zip ]; then
  wget http://dl.google.com/closure-compiler/compiler-latest.zip
  unzip -qn compiler-latest.zip
fi

if [ ! -f yuicompressor-2.4.8.jar ]; then
 wget https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar
fi

for file in $( find $directory -name '*.js' )
do
  if [[ $file == *arduino* ]]
  then
  echo Skipping $file
      continue
  fi
  if [[ $file == *min* ]]
  then
  echo Already minified $file
      continue
  fi
  echo Compiling $file
  java -jar closure-compiler-*.jar --warning_level QUIET --compilation_level=SIMPLE_OPTIMIZATIONS --js="$file" --js_output_file="$file-min.js"
  mv -b "$file-min.js" "$file"
done

for file in $( find $directory -name '*.css' )
do
  echo Minifying $file
  java -jar yuicompressor-2.4.8.jar -o "$file-min.css" "$file"
  mv -b "$file-min.css" "$file"
done

for file in $( find $directory -name '*.png' )
do
  echo optipng $file
  optipng "$file" -o7
done

for file in $( find $directory -name '*.jpg' )
do
  echo guetzli $file
  guetzli --quality 85 "$file" "$file.new"
  mv "$file.new" "$file"
done
