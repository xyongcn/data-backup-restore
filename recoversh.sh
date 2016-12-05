#!/bin/bash

# this shell script is to auto mount and get info 
#about files in android installed disk(format qcow2 or raw) 
if [ $# -ne 2 ];then
  echo "please input a need recover android disk name and a absolute path name"
  exit 1
else
  if [ -f $1 ];then
    echo "recoverdisk name is $1"
  else
    echo "please input a need recover android disk name" 
    exit 1
  fi
  if [ -d $2 ];then
    echo "recover data from $2"
    sudo chmod -R 777 $2
  else
    echo "please input a absolute path name"
    exit 1
  fi
fi
#mount $1 and get source folder
var=$1
# get static dir name android
dirname=${var%.*}
if [ -d /mnt/$dirname ];then 
  echo "/mnt/$dirname is already exist."
else
 echo "create $dirname directory in /mnt"
 sudo mkdir -m 755 /mnt/$dirname
fi
echo $dirname
devname=`sudo losetup -f` 
loname=${devname##*/}
echo "find unused device $devname $loname"
sudo losetup $devname $1
sudo kpartx -av $devname
sudo mount /dev/mapper/"$loname"p1 /mnt/$dirname
#extract the version information
version=`ls /mnt/$dirname |grep android`
echo $version
cat confile | while read line
do
    [ -z $line ] && continue
    echo $line
   var=${line##*/}
   echo $var
   newpath=/mnt/$dirname/$version/$line 
    echo $newpath
if [ -f "$newpath" -o -d "$newpath" ];then
    echo "exist"
    sudo chmod -R 755 $newpath
elif [ -f "$newpath" ];then
    sudo touch  $newpath
    sudo chmod  755 $newpath
  echo "file create"
else
    sudo mkdir -p $newpath
    sudo chmod -R 755 $newpath
 echo "director create"
  fi
    path=`ls $2 |grep $var`
    cd $2
    if [ -f "$path" ];then
     sudo cp $2/$path $newpath
     echo "recover file"
    else 
      sudo cp -Rf $2/$path/. $newpath/
      echo "recover directory"
    fi
    if [ $? -ne 0 ];then
    echo "copy faild.program running stoped."
    exit 1
    else
    echo "copy successful."
    fi
done

#release source
sudo umount /mnt/$dirname
sudo kpartx -dv $devname
sudo losetup -d $devname
if [ $? -ne 0 ];then
    echo "release loop for $1 faild.program running stoped."
    exit 1
  else
    echo "release loop for $1 successful."
  fi

sudo rm -rf /mnt/$dirname
