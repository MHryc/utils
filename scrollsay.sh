#!/usr/bin/env bash

# $* string of all arguments passed to script ($@ would be an array)

readarray -t message < <(fold -w 40 <<< "$*")

for word in "${message[@]}"; do
	echo $word
done
