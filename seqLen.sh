#!/bin/bash

read input

seq=$(tr -d ' ' <<< "$input")

fold -w 1 <<< "$seq" | wc -l
