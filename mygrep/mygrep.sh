#!/bin/sh
show_number=false
invert=false

while getopts "nv" option; do
    case $option in
    n) show_number=true ;;
    v) invert=true ;;
    *)
        echo "invaild options: -$OPTARG "
        exit 1
        ;;
    esac
done


# OPTIND starts from 1 and it gets increased by one everytime getopts processes an option
# so we need to return it to 1 so we get process our arguments
# to ignore the options arguments
shift $((OPTIND - 1))


if [[ -z $1 || -z $2 ]] ; then
echo "grep: too few arguments"  ;
echo "Usage: $0 [-n] [-v] search_string filename" ;
exit
fi

FILE=$2
if [ ! -e $FILE ] ; then
    echo "grep : $2 : No such file or directory" ;
    exit
fi


lineNumber=0
FLAG=false
# to make the search case-insensitive
shopt -s nocasematch


while IFS= read -r line || [[ -n "$line" ]]; do
    isFound=false

    ((++lineNumber))


    if [[ "$line" == *$1* ]]; then
        isFound=true
    fi

    if [[ "$invert" == true ]]; then
        if [[ "$isFound" == true ]]; then
            isFound=false
        else
            isFound=true
        fi
    fi

    if [[ "$isFound" == true ]]; then
        if [[ "$show_number" == true ]]; then
            printf '%d %s %s\n' "$lineNumber" : "$line"
        else
            printf '%s\n' "$line"
        fi
        FLAG=true
    fi
done <$FILE

if [[ "$FLAG" == false ]]; then
    echo "grep: This string is not found in the file"
fi