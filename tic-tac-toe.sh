#!/bin/bash
emptyCellChar=" "
emptyCellsCount=9
x=0
y=0
field=("$emptyCellChar" "$emptyCellChar" "$emptyCellChar" "$emptyCellChar" "$emptyCellChar" "$emptyCellChar" "$emptyCellChar" "$emptyCellChar" "$emptyCellChar")

redColor="\033[41m"
magnetaColor="\033[45m"
defaultColor="\033[0m"

colors=("$redColor" "$magnetaColor")

up="[A"
down="[B"
right="[C"
left="[D"

players=("X" "O")

function getWinnerMessage {
	if [ "${field[0]}" != "$emptyCellChar" ] && [ "${field[0]}" == "${field[1]}" ] && [ "${field[0]}" == "${field[2]}" ]
	then
		echo "${field[0]} win"
	fi
	if [ "${field[3]}" != "$emptyCellChar" ] && [ "${field[3]}" == "${field[4]}" ] && [ "${field[3]}" == "${field[5]}" ]
	then
		echo "${field[3]} win"
	fi
	if [ "${field[6]}" != "$emptyCellChar" ] && [ "${field[6]}" == "${field[7]}" ] && [ "${field[6]}" == "${field[8]}" ]
	then
		echo "${field[6]} win"
	fi
	if [ "${field[0]}" != "$emptyCellChar" ] && [ "${field[0]}" == "${field[3]}" ] && [ "${field[0]}" == "${field[6]}" ]
	then
		echo "${field[0]} win"
	fi
	if [ "${field[1]}" != "$emptyCellChar" ] && [ "${field[1]}" == "${field[4]}" ] && [ "${field[1]}" == "${field[7]}" ]
	then
		echo "${field[1]} win"
	fi
	if [ "${field[2]}" != "$emptyCellChar" ] && [ "${field[2]}" == "${field[5]}" ] && [ "${field[2]}" == "${field[8]}" ]
	then
		echo "${field[2]} win"
	fi
	if [ "${field[0]}" != "$emptyCellChar" ] && [ "${field[0]}" == "${field[4]}" ] && [ "${field[0]}" == "${field[8]}" ]
	then
		echo "${field[0]} win"
	fi
	if [ "${field[2]}" != "$emptyCellChar" ] && [ "${field[2]}" == "${field[4]}" ] && [ "${field[2]}" == "${field[6]}" ]
	then
		echo "${field[2]} win"
	fi
}

function getIndexFromCoordinates {
	local index=$(( $2*3+$1 ))
	echo $index
}

function getCurrentPlayer {
  if [[ $emptyCellsCount%2 -eq 1 ]] 
  then
    echo 1
  else
    echo 0
  fi
}

function renderField {
  clear
	for ((row=0;row<3;row++))
	do
		local result=""
    local currentPlayer=$(getCurrentPlayer)

		for ((col=0;col<3;col++))
		do
			local cellColor="\033[0m"
			if [[ $row -eq $y ]] && [[ $col -eq $x ]]
			then
        cellColor=${colors[$currentPlayer]}
			fi
			local currentIndex=$(getIndexFromCoordinates $col $row)
			result="$result ${cellColor}${field[currentIndex]}${defaultColor} "
			if [[ $col -ne 2 ]]
			then
				result="$result|"
			fi
		done

		echo -e "$result"
	done
}

function onMoveClick {
    if [[ "$1" == "$up" ]]
    then
      y=$(( ($y + 2) % 3 ))
    elif [[ "$1" == "$down" ]]
    then
      y=$(( ($y + 1) % 3  ))
    elif [[ "$1" == "$right" ]]
    then
      x=$(( ($x + 1) % 3  ))
    elif [[ "$1" == "$left" ]]
    then
      x=$(( ($x + 2) % 3  ))
    fi
}

function makeStep {
  read -s -n1 code
	if [[ "$code" == $'\x1B' ]]
  then
    read -s -n2 cursor
    onMoveClick $cursor
  else
    local index=$(getIndexFromCoordinates $x $y)
    if [[ "${field[$index]}" == "$emptyCellChar" ]]
    then
      local currentPlayer=$(getCurrentPlayer)
      local symbol=${players[$currentPlayer]}
      field[$index]="$symbol"
      emptyCellsCount=$[ $emptyCellsCount - 1 ]
    fi
  fi

  renderField
  local winnerInfo=$(getWinnerMessage)
  if [ ! -z "$winnerInfo" ]
  then
    echo $winnerInfo
    exit
  fi
}

renderField
while [ $emptyCellsCount -ne 0 ] 
do
  makeStep
done
echo "Game over. Standof"