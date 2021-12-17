# Import videos with datetime folder heiarchy 

The goal is to import (rename) various video files into a folder/filename pattern as `YYYY/YYYY-MM/YYYY-MM-DD/YYYYMMDD-HH24MISS-<original filename>`

## Videos from Sony
`CreateDate` is the local time.  `-api QuickTimeUTC` is needed to convert the time to local time.
To copy and rename the related XML files. use `import-sony-video.sh` 
*note*, for large file (> 2GB) make sure use the configuration file to enable the large file support

```shell
Usage: import-sony-video.sh [-d -e EXTENSION] -s SOURCE -t TARGET 
Import Video Files.
   -d           diff existing file
   -e EXTENSION file extension, default MP4
   -m           move instead of copy
   -s SOURCE    Specify Source File Pattern
   -t TARGET    Specify the target dir for root
   -z           do not convert timezone

# typical use cases

# copy from one location to the target
$ import-sony-video.sh -s <card location> -t <target folder>

# copy move from one location to the target
$ import-sony-video.sh -s <card location> -t <target folder> -m

```

## Videos from DJI
`CreateDate` is the local time.

These `mov` files can be imported with exiftool directly
```shell
$ cd targetroot
exiftool  -d %Y/%Y-%m/%Y-%m-%d/%Y%m%d_%H%M%S-%%f.%%e "-filename<CreateDate" DIR
```


## Videos from Apple
`CreateDate` seems to be the file create time (if the file is shared).  `CreationDate` is the local time

```shell
$ cd targetroot
$ exiftool  -d %Y/%Y-%m/%Y-%m-%d/%Y%m%d_%H%M%S-%%f.%%e "-filename<CreationDate" <source>
```
