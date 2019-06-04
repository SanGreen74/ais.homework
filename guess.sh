#!/bin/bash
number=$RANDOM
if [ "$1" == "debug" ] 
then
  echo $number
fi

regex="^[+-]?[0-9]+$"
while true
do 
  read line
  if [[ $line =~ $regex ]]
  then
    if (($line > $number))
    then
      echo 'My number is smaller than your'
    elif (($line == $number))
    then
      echo 'Guessed'
      break
    else
      echo 'My number is greater than your'
    fi
  else 
    echo "You should write a number"
  fi
done