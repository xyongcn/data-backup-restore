#!/bin/bash

if [ $# -ne 2 ];then
  echo "please input two android installed disk name"
  exit 1
else 
  if [ -f $1 -a -f $2 ];then
    echo "find file $1 and $2"
  else
    echo " please input two android installed disk name "
    exit 1
  fi
fi


#install software
echo "detecting necessary software package......"
dpkg -s tree
if [ $? -ne 0 ];then
  sudo apt-get install tree
else
  echo "package tree is already installed."
fi
dpkg -s kpartx
if [ $? -ne 0 ];then
  sudo apt-get install kpartx
else
  echo "package kpartx is already installed."
fi

#get  $1 system directory
sudo sh mountgetsh.sh $1
if [ $? -ne 0 ];then
   echo "running mountgetsh.sh $1 faild."
   exit 1
fi

#get directory name
var=$1
dirname=${var%'-'*} # get tree dir name
diro=${var%.*}
echo "creating source tree for $diro... ..."

#get source tree with signkey
sudo sh treesh.sh $diro
if [ $? -ne 0 ];then
  echo "get source tree for $diro program running stoped."
  exit 1
else
  echo "get source tree for $diro program running successful."
  sudo rm -R $dirname 
fi

#get $2 system directory
sudo sh mountgetsh.sh $2
if [ $? -ne 0 ];then
   echo "running mountgetsh.sh $2 faild."
   exit 1
fi

#get directory name
var=$2
dirn=${var%.*}
#get source tree with signkey

sudo sh treesh.sh $dirn
if [ $? -ne 0 ];then
  echo "get source tree for $dirn program running stoped."
  exit 1
else
  echo "get source tree for $dirn program running successful."
  sudo rm -R $dirname
fi

#get diff between old and new
if [ $? -eq 0 ];then
   diff -Nur ftreefor"$diro".txt ftreefor"$dirn".txt > ftree-cmp.patch
   echo "diff file treefor-cmp.patch created successful."
else
  echo "file not existed!"
fi

if [ $? -eq 0 ];then
  echo "all is running successful, program end."
fi

