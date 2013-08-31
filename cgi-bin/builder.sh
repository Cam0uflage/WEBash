#!/bin/bash
#Author: Cam0 a.k.a Cam0uflage a.k.a Zer0
#Info: This is a small set of functions that helps creating the website

##GLOBAL VARIABLES
WEBSITE="WEBash"					#The website's name
CSS_RDIR="/css/main.css"				#Relative directory where the css is at
P_DIR="/var/www/pages"					#The directory where the page contents are at
P_RDIR="/pages"						#Relative directory
A_DIR="/var/www/articles"				#The directory where the articles are at
A_RDIR="/articles"					#Relative directory (needed 'cause often webservers deny access to the filesystem)
A_IND="index.html"					#Articles' contents file
M_ID="Menu" 						#The id given in the CSS file where the menu will be displayed
M_sy="-"						#Symbol used to list the items
M_S=("index.html" "articles.sh")			#The "static" menu items - MUST CONTAIN AT LEAST THE INDEX
M_SA=("HOME" "ARTICLES")				#Static menu items aliases - MUST BE IN THE CORRECT ORDER
C_ID="Content"						#The id given in the CSS file where the content will be displayed
B_FILE="/cgi-bin/browser.sh"				#The browser script's name(browser.sh is the default one)

###PAGES	
P_404="404.html"					#The 404 error page(if any)
P_INDEX="index.html"					#The index
###END PAGES
##END GLOBAL VARIABLES

function html_start {
	#This function generates a fast html page start code
	echo "Content-Type: text/html"
	echo ""
	echo "<html>"
        echo "<head>"
                echo "  <title>$WEBSITE</title>"
                echo "  <style type=\"text/css\" media=\"all\">@import \"$CSS_RDIR\";</style>"
        echo "</head>"
	echo "<body>"
	echo "<center><h1>$>$WEBSITE<blink>_</blink></h1></center>"
}

function html_end {
	#This function generates a fast html page end code
	echo "</body>"
	echo "</html>"
}

function update_menu {
	#This function manages the Menu content
	echo -e "<div id=\"$M_ID\">"
	
	#List all the "static" menu items
	local c=0
	for i in ${M_S[*]};do
		echo -e "$M_sy<a href=\"$B_PAGE?p=$i\">${M_SA[$c]}</a><br>"
		((c++))
	done
	
	#List all the "dynamic" menu items
	cd $P_DIR
	for i in $(ls *.html);do
		if [ $i != $P_INDEX ];then #DO NOT LIST INDEX
			echo -e "$M_sy<a href=\"$B_FILE?p=$i\">$i</a><br>"
		fi
	done

	echo "</div>"
}

function update_content {
	#This function updates the page Content
	echo -e "<div id=\"$C_ID\">"

	if [ $# -eq 1 ];then
		#TODO find a better way to secure input
		local page=$1;page=${page//'p='/''};page=$(basename $page) #(Try to)Sanitize input

		#Check if it's a dynamic webash page(supported extensions: sh,s)
		if [ "${page##*.}" = "sh" -o "${page##*.}" = "s" -o "${page##*.}" = "" ];then
			bash $P_DIR/$page #Executes the specified page's code
		else
			cat $P_DIR/$page #Displays content
		fi
	else
		cat $P_DIR/$P_404	#Shows a 404 error(if any 404.html page is present)
		cat $P_DIR/$P_INDEX 	#Shows the index 
	fi
	
	echo "</div>"	
}

function update_articles {
	#This function updates the article's page
	cat $A_DIR/$A_IND
	echo -e "<center><table border=\"1\">"
	echo "<tr>"
	echo "	<td><i>FILE</i></td>"
	echo "	<td><i>AUTHOR</i></td>"
	echo "  <td><i>TITLE</i></td>"
	echo "	<td><i>DATE</i></td>"
	echo "</tr>"
	
	#Fill the table with the articles
        for x in $(ls $A_DIR/*.txt);do
	        local article=$(basename $x)
                local desc=$(head -1 $x)
                local author=$(tail -1 $x)
                local date=$(date -r $x)
                echo -e "<tr><td><a href=\"$A_RDIR/$article\">$article</a></td><td>$author</td><td>$desc</td><td>$date</td></tr>"
        done
	
	echo "</table></center>"	
}
