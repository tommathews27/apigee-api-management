#!/bin/bash --login

set -e
###########################
## Shell script to do pre-deploy tasks on all the project in a specific repository
##
###########################
function JSUnitTesting
{
	printf "$(tput setaf 6)[Info] $(tput setaf 7) Executing Jasmine unit test cases for Java script files for the $CI_COMMIT_ID\n"
	printf "$(tput setaf 6)[Info]  $(tput setaf 7) Executing Jasmine unit test cases for Java script files projects from $CI_REPO_NAME , $CI_BRANCH branch\n"
	cd /home/rof/src/github.com/$CI_REPO_NAME
	for i in $(find . -maxdepth 1 -type d -not -name ".git" -not -name "tmp" -not -name "log" -not -name . -not -name "node_modules")
	do
		proxydir=${i##*/}
		echo "$(tput setaf 6) $proxydir \n"
	    (cd $proxydir;
		echo " $(tput setaf 6) In $PWD , executing the Jasmine specs \n"
		../node_modules/.bin/istanbul cover ../node_modules/jasmine/bin/jasmine.js -x **/spec/**)
	done
	printf "$(tput setaf 2) =========================================PRE-DEPLOY SCRIPT COMPLETED SUCCESSFULLY=====================================================\n"
}


function JSLint 
{
	printf "$(tput setaf 6)[Info] $(tput setaf 7) Validating JS files for the $CI_COMMIT_ID\n"
	printf "$(tput setaf 6)[Info]  $(tput setaf 7) Validating JS files for all the projects from $CI_REPO_NAME , $CI_BRANCH branch\n"
	cd /home/rof/src/github.com/$CI_REPO_NAME
	for i in $(find . -maxdepth 1 -type d -not -name ".git" -not -name "tmp" -not -name "log" -not -name . -not -name "node_modules")
	do
		proxydir=${i##*/}
		echo "$(tput setaf 6) $proxydir \n"
	    (cd $proxydir;
		echo " $(tput setaf 6) In $PWD , executing the JSLint validation Maven plugin \n"
		mvn jshint:lint)
	done
	printf "$(tput setaf 2) =========================================PRE-DEPLOY SCRIPT COMPLETED SUCCESSFULLY=====================================================\n"
}
##############################################
#    Main
##############################################
printf "$(tput setaf 2)==========================================START OF PRE-DEPLOYMENT STEPS SCRIPT=========================================================\n"
JSLint
JSUnitTesting