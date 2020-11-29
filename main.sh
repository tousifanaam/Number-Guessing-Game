#!/bin/bash
clear

# The random number $(seq 1 100)
a=$((1 + $RANDOM % 100))

manual () {
n=0; failure=0
while [ $n -eq 0 ];do
	read -p $'I am have a number between 1 and 100.\nCan you guess the number?\nYou have as many attempts you need.\nThe shortest amounts of guesses required to predict is what matters.\n\nEnter your guess:  >  '  guess
	if [ $guess = $a ];then
		b=$(($failure+1))
		echo -e "\nCorrect guess!. No. of attempts taken: $b"
		n=1
	elif [ $guess -gt $a ];then
		echo -e "\nToo high!\n"
		failure=$(($failure+1))
	elif [ $guess -lt $a ];then
		echo -e "\nToo low!\n"
		failure=$(($failure+1))
	fi
done 
}

auto () {
guess=50; failure=0; ll=1, ul=100

# Start
if [ $guess -eq $a ];then
	attempts=$(($failure+1))
	echo -e "\n${guess} - Correct guess!. No. of attempts taken: $attempts"
	exit
elif [ $guess -gt $a ];then
	echo -e "\n${guess} - Too High!" # -
	pg2=$guess; failure=$(($failure+1))
	guess=$((${ul}/4))
elif [ $guess -lt $a ];then
	echo -e "\n${guess} - Too Low!" # +
	pg2=$guess; failure=$(($failure+1))
	guess=$(($guess+$((${guess}/2))))
fi
pg1=$guess # output variables: guess = 25 or 75, pg1 = 25 or 75, pg2 = 50

# Main Process 
check () {
if [ $guess -eq $a ];then
	attempts=$(($failure+1))
	echo -e "\n${guess} - Correct guess!. No. of attempts taken: $attempts"; n=1
	exit
elif [ $guess -gt $a ];then 
	echo -e "\n${guess} - Too High!" # -
	if [ $pg2 -gt $pg1 ];then # previous guess was an output of too high
		pg3=$pg2; pg2=$pg1; failure=$(($failure+1)) 
		guess=$(($(($ll+$pg2))/2))
	elif [ $pg2 -lt $pg1 ];then # previous guess was an output of too low
		pg3=$pg2; pg2=$pg1; failure=$(($failure+1)) 
		guess=$(($(($pg3+$pg2))/2))
	fi
elif [ $guess -lt $a ];then
	echo -e "\n${guess} - Too Low!" # +
	if [ $pg2 -gt $pg1 ];then # previous guess was an output of too high
		pg3=$pg2; pg2=$pg1; failure=$(($failure+1)) 
		guess=$(($(($pg2+$pg3))/2))
	elif [ $pg2 -lt $pg1 ];then # previous guess was an output of too low
		pg3=$pg2; pg2=$pg1; failure=$(($failure+1)) 
		guess=$(($(($pg2+$ul))/2))
	fi	
fi 
pg1=$guess 
}

# Loop
n=0
while [ $n -eq 0 ];do
	check
done
}

thread () {
failure=0
for i in $(seq 1 100);do
	if [ $i -lt $a ];then
		echo -e "\n${i} - Too low!"
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
