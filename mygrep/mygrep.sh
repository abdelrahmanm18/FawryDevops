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


// OPTIND starts from 1 and it gets increased by one everytime getopts processes an option
// so we need to return it to 1 so we get process our arguments
// to ignore the options arguments
shift $((OPTIND - 1))


if [ -z $2 ] ; then
echo "grep: too few arguments" ;
exit
fi

FILE=$2
if [ ! -e $FILE ] ; then
    echo "grep : $2 : No such file or directory" ;
    exit
fi



i=0
FLAG=false

# to make the search case-insensitive
shopt -s nocasematch


while IFS= read -r line || [[ -n "$line" ]]; do
    ((++i))
    if [[ "$line" == *$1* ]]; then
        printf '%d %s\n' $i "$line"
        FLAG=true
        break
    fi
done <$FILE

if [[ "$FLAG" == false ]]; then
    echo "grep: This string is not found in the file"
fi