#!/bin/bash
clear

# The random number $(seq 1 100)
a=$((1+$RANDOM%100))

manual () {
n=0; failure=1
echo -e "I am having a number between 1 and 100. Can you guess the number? You have as many attempts you need. The shortest amounts of guesses required to predict is what matters.\n"
while [ $n -eq 0 ];do
	read -p "Enter your guess:  >  "  guess
	if [ $guess = $a ];then
		echo -e "\nCorrect guess!. No. of attempts taken: $failure"
		n=1
	elif [ $guess -gt $a ];then
		m='Too High'
		failure=$(($failure+1))
	elif [ $guess -lt $a ];then
		m='Too Low!'
		failure=$(($failure+1))
	fi
	if [ $n -eq 0 ];then
		sleep 1s && clear
		if [ $failure -eq 2 ];then
			echo -e "Last Guess: $guess | $m | ${failure}nd attempt.\n"
		elif [ $failure -eq 3 ];then
			echo -e "Last Guess: $guess | $m | ${failure}rd attempt.\n"
		else
			echo -e "Last Guess: $guess | $m | ${failure}th attempt.\n"
		fi
	fi
done
}

auto () {
# variables
low=1; high=100; guess=50; attepmt=0

# Main
while :; do
	attempt=$((attempt+1))
	if [ $guess -eq $a ];then
		if [ $guess -lt 10 ];then
			echo "0$guess - Done!"
		else
			echo "$guess - Done!"
		fi
		echo -e "\nTotal attempts: $attempt\nSuccess!";break
	elif [ $guess -eq 99 ] && [ $guess -lt $a ];then
		echo "$guess - Too low!"
		guess=$(($guess+1))
	elif [ $guess -lt $a ];then
		if [ $guess -lt 10 ];then
			echo "0$guess - Too low!"
		else
			echo "$guess - Too low!"
		fi
		low=$guess; guess=$((($high+$low)/2))
	elif [ $guess -gt $a ];then
		if [ $guess -lt 10 ];then
			echo "0$guess - Too low!"
		else
			echo "$guess - Too low!"
		fi
		high=$guess; guess=$((($high+$low)/2))
	fi
done
}

thread () {
failure=0
for i in $(seq 1 100);do
	if [ $i -lt $a ];then
		echo -e "${i} - Too low!"
		failure=$(($failure+1))
	elif [ $i = $a ];then
		b=$(($failure+1))
		echo -e "\n${i} - Correct guess!.\n\nNo. of attempts taken: $b"
		break
	fi
done
}

if [ "$1" = "-a" ];then
	auto
elif [ "$1" = "-m" ];then
	manual
elif [ "$1" = "-t" ];then
	thread
fi
