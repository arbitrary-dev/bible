#!/bin/zsh

MAX=$1

# Signature should be even!
SIGN=32

declare -a A
declare -a B
declare -a C

process() {
	local off=$(( SIGN + $1 / SIGN * SIGN ))

	local num_1=$1
	local num_2=$(( off - ($1 % SIGN) + 1 ))

	(( num_1 > MAX )) && num_1='{}'
	(( num_2 > MAX )) && num_2='{}'

	if (( $1 % 2 != 0 )); then
		A+=( "$num_2" "$num_1" )
	else
		if (( ($1 / 2) % 2 != 0 )); then
			B+=( "$num_1" "$num_2" )
		elif (( ${#B} < 3 )); then
			B=( "$num_1" "$num_2" "${B[@]}" )
		else
			B=( ${B[1,-3]} "$num_1" "$num_2" ${B[-2,-1]} )
		fi
	fi

	if (( (${#A} + ${#B}) % (SIGN / 2) == 0 && (${#A} + ${#B}) > 0 )); then
		C+=("${A[@]}" "${B[@]}")
		A=()
		B=()
	fi
}

local i=1
while (( i <= (MAX + SIGN/4 - 1) / (SIGN/4) * (SIGN/4) )); do
	process $i
	if (( i % (SIGN / 2) != 0 )); then
		i=$(( i+1 ))
	else
		i=$(( i + (SIGN / 2 + 1) ))
	fi
done

echo "${(j:,:)C}"
