#!/bin/bash

## 
####  Parse Command Line Arguments 
##

		#echo "Arguments passed are $@"
		echo

		for i in "$@"
		do
		case $i in
			-e=*|--extension=*)
			EXTENSION="${i#*=}"
			shift # past argument=value
			;;
			-p=*|--path=*)
			SCRIPTPATH="${i#*=}"
			shift # past argument=value
			;;
			-u=*|--url=*)
			GITURL="${i#*=}"
			shift # past argument=value
			;;
			--default)
			DEFAULT=YES
			shift # past argument with no value
			;;
			*)
					# unknown option
			;;
		esac
		done

		echo "FILE EXTENSION  = ${EXTENSION}"
		echo "BUILD SCRIPT PATH     = ${SCRIPTPATH}"
		echo "GIT URL    = ${GITURL}"
		echo 

		[ -z ${SCRIPTPATH} ] && echo "Please provide build script path" && exit 1; 
		[ -z ${GITURL} ] && echo "Please provide GIT URL" && exit 1; 

##
####  Set extra/internal parameters
##
listdirectories="Mainbuildscripts"; export listdirectories
		

##
##### 1. Check if files and directories exists under given path
##
  		listoffiles=`ls -1 "${SCRIPTPATH}"/*."${EXTENSION}" | wc -l` > /dev/null 
		echo "Number files in Path "${SCRIPTPATH}"/*."${EXTENSION}" with EXTENSION: $listoffiles" 
		echo
		
		if [ $listoffiles -eq "0" ]; then
		  echo "There are no files under ${SCRIPTPATH} with extention ${EXTENSION}."
		  #exit 1; 
			if [ -z $listdirectories ] ; then 
				echo "Option directory $listdirectories is not provided."
				echo "Aborting the execution..."
				exit 1;
			else  
				for dir in $listdirectories 
				do  
					echo "Checking if directory $dir exists"
					if [ ! -d ${SCRIPTPATH}/${dir} ] ; then
						echo "Directory ${SCRIPTPATH}/${dir} does not exists." 
						echo "Aborting the execution..."
						exit 1; 
					fi 
				done	
				echo "Directories $listdirectories exists"
		    fi 
		fi
		

	cd ${SCRIPTPATH}; 
	SPATH=`pwd`;
	echo "Changed path to : $SPATH"
	echo
	
##
#### 2. Make sure there is something available to commit "
##
	echo
	echo "###########################################################"
	echo "Make sure there is something available to commit "
	echo 

	var=`git status --porcelain`;
	if [ -z $var ];    then
       echo "YOUR REPO IS CLEAN. NOTHING TO COMMIT!"
	   echo "###########################################################"
	   exit 0; 
    fi	
	echo

##
####  3. Add changed file to git repository 
##		
 	echo "[ info ]:= Add *.${EXTENSION} to git repository"
	echo
	git add "*.${EXTENSION}" || { echo "git add *.${EXTENSION} command failed" && exit 1; }
		 
 	echo "[ info ]:= Add "$listdirectories" files to git repository" 
	echo 
	for dir in $listdirectories 
	do  
	     echo "[ info ]:= git add $dir "
	     git add $dir || { echo "git add $dir command failed" && exit 1; }
	done	

##
#### Print git status 
##
	echo
	echo "###########################################################"
	echo "Output of git stauts command as below:- "
	echo 
	git status || { echo "git status command failed" && exit 1; }
	echo "###########################################################"
	echo
	
## 
#### Commit changes 
##
		echo "[ info ]:= Commit added and changed files to repository"
		timestamp=`date '+%Y%m%d%H%M'`
		git commit -m "Committing build script changes $timestamp" || { echo "git commit command failed" && exit 1; }
		

##
#### Print git status 
##
	echo
	echo "###########################################################"
	echo "Output of git stauts command as below:- "
	echo 
	git status || { echo "git status command failed" && exit 1; }
	echo "###########################################################"
	echo

	
## 
#### Push changes to repo
##
	echo "[ info ]:= Push committed changes to $GITURL"
	git push $GITURL || { echo "git commit command failed, $?, $*" && exit 1; }
	

## 
#### Show brief commit log 
##
	echo "###########################################################"
	echo "[ info ]:= Git log in one line"
	git log --oneline || { echo "git commit command failed, $?, $*" && exit 1; }
	echo "###########################################################"	
	
exit 0;

### Test code written below. 

# var=`git status --porcelain`;
# echo $var
# if [ -z $var ];
# then
    # echo "IT IS CLEAN"
# else
    # echo "PLEASE COMMIT YOUR CHANGE FIRST!!!"
    # echo git status
# fi	