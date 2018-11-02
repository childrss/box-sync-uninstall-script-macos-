#!/bin/bash
#
# Based off of a script posted here: https://www.jamf.com/jamf-nation/discussions/25924/script-to-uninstall-box-sync
#
# Changed specifically to work as a Munki pre-install script (test to see if the Box Sync.app exists) to be used with
# Box DRIVE installation.
#
# AND to not just do the logged-in user but all of the users on the machine.
#

BOX_SYNC_APP=/Applications/Box\ Sync.app
BOX_SYNC_DIRECTORIES=/Users/*/Box\ Sync

if [ -d "$BOX_SYNC_APP" ]; then

    # echo it so it hits the munki log...
    echo "Uninstalling Box Sync, Files moved to Box Sync (OLD)"

	#Quit Box Sync
	killall "Box Sync"
    
     # Remove the main Box Sync application
	/bin/rm -rf "/Applications/Box Sync.app"

	# Remove the finder extension stuff
	/bin/rm -rf "/Library/PrivilegedHelperTools/com.box.sync.bootstrapper"
	/bin/rm -rf "/Library/PrivilegedHelperTools/com.box.sync.iconhelper"


    # Go over each user directory and make sure the Box stuff is labed (OLD) and unecessary per-user stuff is removed

	for d in $BOX_SYNC_DIRECTORIES
	do
		echo $d
		#Copy old user data. Change mv to cp if you prefer to copy it
		/bin/mv "/Users/$d/Box Sync" "/Users/$d/Desktop/Box Sync (OLD)"

		#We don't care about the per-user Box Sync logs anymore...
		/bin/rm -rf "/Users/$d/Library/Logs/Box/Box Sync/"

		# Remove old Box Sync application data
		/bin/rm -rf "/users/$loggedInUser/Library/Application Support/Box/Box Sync/"
	done

fi
