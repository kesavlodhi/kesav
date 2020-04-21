#!/bin/bash
###############################################################################
#                                                                             #
#       Script name : compare_file.sh                                         #
#       Discription : This script is to check the file changes agter the      # 
#                     pull from the master repository                         #
#                                                                             #
#       Date created:   06/04/2020                                            #
#                                                                             #
#       Author      :   Kesav Lodhi                                           #
#       Change History :                                                      #
###############################################################################
#setting variables
set -o xtrace

GIT=`which git`
CLONE_DIR=/home/ec2-user/work/release1/
GITHUB_REPOSITORY=https://github.com/kesavlodhi/release1.git
BACKUP_CLONE_DIR=/home/ec2-user/work/backup/release1/
FILE_LIST=/tmp/file_list.txt
MAILFILE=/tmp/logfile.txt 
DIFF_DIR=/tmp/diff.txt
AVAILABILITY=/tmp/log.html
#LOG_PATH=/tmp/log.txt
#message="auto-commit from $USER@$(hostname -s) on $(date)"

#backup the files from clone directory to Backup directory#
#cp -rp $CLONE_DIR* $BACKUP_CLONE_DIR

#Get the latest code from the remote repository#

#cd ${CLONE_DIR}
#${GIT} pull origin master

#to check change file list

#diff -q /mnt/d/Code_clone/backup/release1 /mnt/d/Code_clone/release1/ | grep "Only in" > /tmp/t.txt 
diff -q $BACKUP_CLONE_DIR $CLONE_DIR | grep differ > $DIFF_DIR

echo "filename,line" > ${AVAILABILITY}
#file1=/tmp/t1.txt

if [[ -s "$DIFF_DIR" ]] 
  then 
	  echo "some files got changed"
	  cat $DIFF_DIR | awk '{print $2}' | awk -F/ '{ print $7 }' > $FILE_LIST
else
	echo "$DIFF_DIR is empty."
fi
line=/tmp/lines
for line in `cat $FILE_LIST`
do
	git diff $CLONE_DIR$line $BACKUP_CLONE_DIR$line > $MAILFILE
	a=`awk 'NR==5 {print}' $MAILFILE | cut -d" " -f3`
	echo $line $a > $line
	tr ' ' '|' < $line >> ${AVAILABILITY}
done

cat /dev/null > $FILE_LIST
cat /dev/null > $DIFF_DIR
