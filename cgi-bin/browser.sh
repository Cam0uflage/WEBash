#!/bin/bash
#Author: Cam0 a.k.a Cam0uflage a.k.a Zer0
#Info: This script is the one that handles the requests and creates the pages

##INCLUDES
source builder.sh
##END INCLUDES

##GLOBAL VARIABLES
PAGE=""						#Content file to display
##END GLOBAL VARIABLES

##MAIN
if [ "$REQUEST_METHOD" = "GET" ];then
	if [[ ! -z $QUERY_STRING ]];then
		PAGE=$QUERY_STRING
	fi
fi	

##START CREATING THE WEBPAGE
html_start
#GENERATE MENU
update_menu
#GENERATE CONENTS
update_content $PAGE
##ENDS THE PAGE
html_end
