#!/bin/sh
### HTMLファイルの内容を正規表現で置換する


declare -i argc=0
declare -a argv=()


FLAG_OVERWRITE=0
FLAG_ALL=0

while (( $# > 0 ))
do
    case "$1" in
        -*)
            if [[ "$1" =~ 'o' || "$1" = "--overwrite" ]]; then
                FLAG_OVERWRITE=1
            fi
            if [[ "$1" =~ 'a' || "$1" = "--all" ]]; then
		FLAG_ALL=1
            fi
            shift
            ;;
        *)
            ((++argc))
            argv=("${argv[@]}" "$1")
            shift
            ;;
    esac
done



usage() {
    echo "Usage:$0 regexp string [filename (if not --all selected)] [options]"
    echo "[options]"
    echo "  -o  --overwrite           overwrite the read textfile"
    exit 1
}




if [ $argc -lt 2 ];then
    usage;
fi


#echo $argc
#echo ${argv[0]}
#echo ${argv[1]}
#echo ${argv[2]}

if [ $FLAG_ALL = 1 ]
then
    # .htmlファイルのbackupをとる（シェルスクリプト基本リファレンスp96）
    for file in *.*
    do
	cp -p "$file" "$file".bak
    done
    # カレントディレクトリの.htmlファイル内の文字列を置換して上書き保存する
    exec find . -maxdepth 1 -name '*.*' -type f -print0 | xargs -0 perl -p -i -e "s/${argv[0]}/${argv[1]}/g"
else
    if [ $argc -gt 2 ]; then
	if [ $FLAG_OVERWRITE -eq 1 ];then
	    exec perl -p -i -e "s/${argv[0]}/${argv[1]}/g" ${argv[2]}
	else
	    exec perl -p -e "s/${argv[0]}/${argv[1]}/g" ${argv[2]}
	fi
    else
	usage
    fi
fi
