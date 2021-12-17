#! /bin/bash

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}


function copy_file() {
    echo "copying $1 to $2"
    local filename="${1##}"
    local targetname="${2##}"
    if (test -e "${filename%.*}M01.XML" ); then
        if [ "$move_file" == "YES" ]; then
          echo "mv ${filename%.*}M01.XML ${targetname%.*}M01.XML"
          mv ${filename%.*}M01.XML ${targetname%.*}M01.XML
        else
          echo "copy ${filename%.*}M01.XML ${targetname%.*}M01.XML"
          cp ${filename%.*}M01.XML ${targetname%.*}M01.XML
        fi
    fi
    if [ "$move_file" == "YES" ]; then    
      mv $1 $2
    else
      cp $1 $2
    fi
}

function copy_video() {
    # echo "Source File is $1"
    # echo "Target Root is $2"
    local create_date=`exiftool $convert_timezone -CreateDate $1`
    local file_name=`exiftool -FileName $1`
    read X X YEAR MONTH DAY HOUR MINUTE SECOND X X <<<${create_date//[:-\\+]/ }
    read X X ORIG_NAME <<<${file_name//:/ }
    # echo $YEAR
    # echo $MONTH
    # echo $DAY
    # echo $HOUR
    # echo $MINUTE
    # echo $SECOND
    # echo $ORIG_NAME
    # exit 
    local target="$2/$YEAR/$YEAR-$MONTH/$YEAR-$MONTH-$DAY/$YEAR$MONTH$DAY-$HOUR$MINUTE$SECOND-$ORIG_NAME"
    if (! test -e $2/$YEAR/$YEAR-$MONTH/$YEAR-$MONTH-$DAY/); then
        echo "create dir $2/$YEAR/$YEAR-$MONTH/$YEAR-$MONTH-$DAY"
        mkdir -p $2/$YEAR/$YEAR-$MONTH/$YEAR-$MONTH-$DAY
    fi
    if (test -e $target); then
        echo "Warning: $target already exist"
        if [ "$diff_existing_file" == "YES" ]; then
            diff $1 $target
        fi
        yes_or_no "Overwrite?" && copy_file $1 $target
    else
        copy_file $1 $target
    fi

}


function usage {
        echo "Usage: $(basename $0) [-d -e EXTENSION] -s SOURCE -t TARGET " 2>&1
        echo 'Import Video Files.'
        echo '   -d           diff existing file'
        echo '   -e EXTENSION file extension, default MP4'
        echo '   -m           move instead of copy'
        echo '   -s SOURCE    Specify Source File Pattern'
        echo '   -t TARGET    Specify the target dir for root'
        echo '   -z           do not convert timezone, '
        exit 1
}


# list of arguments expected in the input
optstring=":de:hms:t:z"
video_extension="MP4"
diff_existing_file="NO"
move_file="NO"
convert_timezone="-api QuickTimeUTC"

while getopts ${optstring} arg; do
  case ${arg} in
    d)
      diff_existing_file="YES"
      ;;
    h)
      echo "showing usage!"
      usage
      ;;
    e)
      video_extension=$OPTARG
      ;;
    m)
      move_file="YES"
      ;;
    s)
      source=$OPTARG
      ;;
    t)
      target=$OPTARG
      ;;
    z)
      convert_timezone=""
      ;;
    :)
      echo "$0: Must supply an argument to -$OPTARG." >&2
      exit 1
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
  esac
done

echo "importing from $source to $target..."
for file in `ls -1 $source/*.$video_extension`
do
    echo $file
    copy_video $file $target
done
