#!/bin/bash
###############################################################################
#                                                                             #
#       Script name : exercise2.sh                                            #
#       Discription : This script is to check any changes happened on files   #
#       and script should commit to the respective folder in Master and       #
#       respective branch                                                     #
#                                                                             #
#       Date created:   06/04/2020                                            #
#                                                                             #
#       Author      :   Kesav Lodhi                                           #
#       Change History :                                                      #
###############################################################################
#setting variables
set -o xtrace

GIT=`which git`
CLONE_DIR=/home/ec2-user/work/exercise2/
BACKUP_CLONE_DIR=/home/ec2-user/work/backup_exercise2/
MASTER_REPOSITORY=https://github.com/kesavlodhi/exercise2.git
FILE_NAME=/tmp/filename.txt
message="auto-commit from $USER@$(hostname -s) on $(date)"

#changed file#
cd $CLONE_DIR
#$GIT checkout master
git status --porcelain | awk '{print $2}' > $FILE_NAME

if [[ -s "$FILE_NAME" ]] 
  then 
	  echo "some files got changed"
 else
	echo "$FILE_NAME is empty."
	echo "There are no files changes"
	exit 11
fi

for file in `cat $FILE_NAME`
do
find /home/ec2-user/work/exercise2/*/ -type f -name $file | cut -d'/' -f6 > /tmp/dir.txt
for dir in `cat /tmp/dir.txt`
do
#cp $file ./$file1/
#git add $file
git stash
git checkout Branch1
if [ -d "$dir" ];then
git stash pop
git add -A
mv $file ./$dir/
rm -rf file*
git add -A
git commit -m "copied"
else echo "no directory in this branch"
fi

git checkout Branch2
if [ -d "$dir" ];then
git stash pop
git add -A
mv $file ./$dir/
rm -rf file*
git add -A
git commit -m "copied"
else echo "no directory in this branch"
fi

git checkout Branch3
if [ -d "$dir" ];then
git stash pop
git add -A
mv $file ./$dir/
rm -rf file*
git add -A
git commit -m "copied"
else echo "no directory in this branch"
fi
git checkout master
git stash pop
cp $file ./$dir/
#git add ./$dir/$file
#git add $file
#git commit -m"$message"
done
done
git add --all
git commit -m"$message"
cat /dev/null > $FILE_NAME
cat /dev/null > /tmp/dir.txt
