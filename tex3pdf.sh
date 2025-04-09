#!/bin/bash

get_help() {
	cat << EOF >&2
Usage: tex3pdf [options] [-f FILENAME] [-o OUTPUT]"

-h	get this help"
-f 	specify input tex file, default is main.tex"
-o	specify output pdf name, default is document"
-b	use when you tex file includes references from a bib file"
-c	get bib citation keys in alphabetic order, needs path to bib file"
-x	run with XeLaTex instead of PDFLaTex"
EOF
}
# get citationkey from bib file
get_citkey() {
	grep "@" $1 | cut -d '{' -f 2 | sort
}

filename=main
outname=document
bibtex=1
engine=pdflatex

while getopts ":hf:o:bc:x" flag; do
	case $flag in
		h) get_help; exit 1;;
		f) filename=$(sed 's/\.tex//g' <<< $OPTARG) ;;
		o) outname=$OPTARG ;;
		b) bibtex=0 ;;
		c) get_citkey $OPTARG; exit 1;;
		x) engine=xelatex ;;
		:) >&2 echo "Invalid option: $OPTARG requires an argument";
			get_help; exit 1;;
		*) >&2 echo "Invalid option: -$OPTARG";
			get_help; exit 1;;
		#?) >&2 echo "Invalid option: unknown option -$OPTARG"; exit ;;
	esac
done

# create .tex directory if needed
[[ ! -d .tex ]] && mkdir .tex

# compile .tex into pdf with bibtex references
if [[ $bibtex -eq 1 ]]; then
	$engine ${filename}.tex
	$engine ${filename}.tex
	bibtex ${filename}.aux
	$engine ${filename}.tex
else
	$engine ${filename}.tex
	$engine ${filename}.tex
fi

# get these out of sight
mv *aux *log *toc *nav *out *snm *vrb *bbl *blg .tex

# rename pdf
rename $filename $outname ${filename}.pdf
