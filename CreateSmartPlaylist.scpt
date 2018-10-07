global longSleep
global shortSleep
global myDevice

on run argv -- for running from command line with argument
	
	set myDevice to {}
	set longSleep to 2
	set shortSleep to 0.5
	
	
	-- START : Getinput file name and check for existance
	if ((count of argv) is 0) then
		log "
Usage : " & my name & "  <Full path of file containing smart play list details>
"
		return
	end if
	
	log "you entered : " & item 1 of argv
	
	set fileName to item 1 of argv
	
	tell application "Finder"
		if not (exists fileName as POSIX file) then
			log "
couldnt find file '" & fileName & "'"
			log "
Usage : " & my name & "<Full path of  containing smart play list details>
"
			return
		end if
	end tell
	
	set myFile to POSIX file fileName -- to convert file path name to Apple path format
	
	
	
	
	tell application "iTunes"
		activate
		
		-- BEGIN : Find connected ipod/iphone name
		try
			set myIpods to (name of every source whose kind is iPod) -- for testing if any ipod
		on error
			error "Ohh, No ipod/iphone connected"
		end try
		-- set myIpods to (name of every source whose kind is iPod) as list -- to get ipod names alone  in  list form
		set myIpods to (name of every source) as list -- to get any device name in  list form
		set myDevice to (choose from list myIpods as list) as text
		if myDevice contains "false" then
			error "Ohh, You didnt choose any ipod/iphone"
		end if
		-- END : Find connected ipod/iphone name
		
		
	end tell
	
	
	set myInputData to read myFile using delimiter {string id 10, string id 13} -- read every line with carriage return delimiter
	repeat with myLine in myInputData
		
		log "

"
		
		set myParent to ""
		
		set text item delimiters to ":-:" -- to separate folder path & playlist conditions
		set myGiven to item 1 of (text items of myLine)
		set myCondition to item 2 of (text items of myLine)
		
		set text item delimiters to "::"
		set isSmart to item 1 of (text items of myGiven) -- first item in the line says if it is smart
		
		-- set myPath to (text items of myGiven as list) as text
		set myPath to (text items of myGiven as list) -- to separate every items in the path
		set originalPath to myPath
		
		
		if isSmart is "SMART" then -- we want only smart playlists
			
			set text item delimiters to ""
			set myCount to count of myPath
			
			set myParent to ""
			repeat with C from 2 to myCount -- walk through every item in the folder path
				set P to item C of myPath
				
				--- START : dealing with playlist	
				if (C is myCount) then -- dealing with smart playlist name
					
					log "Now it is user playlist time " & P
					
					
					tell application "iTunes"
						activate
						set myPlaylists to (user playlists of source myDevice whose name is P)
						if myPlaylists is {} then -- No playlist with name P
							if myParent is "" then -- no parent means new playlist must be in root location
								set thePlaylist to playlist "Music" of source myDevice
								set view of front window to thePlaylist
								my createSmartPlaylist(P, myCondition)
								my sort_palylist_by("Album")
								delay longSleep
								tell me to wait_for_sync()
							else -- there is parent means new playlist must be inside parent
								set view of front window to myParent
								my createSmartPlaylist(P, myCondition)
								my sort_palylist_by("Album")
								delay longSleep
								tell me to wait_for_sync()
							end if
						else -- found one or more playlists
							log "Found " & (count of myPlaylists) & " Playlists"
							if myParent is "" then -- Parent is empty, In this case playlist found must be in the root, else create
								
								set isFound to 0
								
								repeat with aList in myPlaylists
									try
										set GP to name of aList's parent -- there is a parent means this playlist is not in root
									on error
										set isFound to 1 -- what ever found is in the root ,  
									end try
								end repeat
								
								if isFound is 0 then -- confirm that none of  found playlist is me 
									set thePlaylist to playlist "Music" of myDevice -- create in the root
									set view of front window to thePlaylist
									my createSmartPlaylist(P, myCondition)
									my sort_palylist_by("Album")
									delay longSleep
									tell me to wait_for_sync()
									log "Created playlist " & P
								else
									log "Found playlist " & P
								end if
							else -- found one ore more playlists and myParent is not empty 
								log "myParent is not empty, Need to work further"
								
								set isFound to 0
								repeat with aList in myPlaylists
									set GP to ""
									try
										set GP to aList's parent -- there is a parent means this folder is not in root
									end try
									if id of GP is id of myParent then -- comparing parent of  found playlist  parent  with parent folder of me
										log "found aParent : " & P
										set isFound to 1
										
									end if
								end repeat
								
								if isFound is 0 then -- what ever playlists found is not matching with me
									set view of front window to myParent -- creating in the parent folder
									my createSmartPlaylist(P, myCondition)
									my sort_palylist_by("Album")
									delay longSleep
									tell me to wait_for_sync()
									
									log "create  playlist in the : " & name of myParent & " : " & P
								else
									log "Found playlist , nothing to do " & P
								end if
								
							end if
							
						end if
					end tell
					
					--- END : dealing with playlist
					
					
					
					
					--- START : dealing with Folders	
				else -- dealing with Folder playlists of the path
					log "Now it is folder list time : " & P
					tell application "iTunes"
						set myFolders to (folder playlists of source myDevice whose name is P)
						log "Count of myFolders is : " & (count of myFolders)
						if myFolders is {} then -- No folders found
							log "Folder doesnt exists : " & P
							if myParent is "" then -- create folder P in the root 
								set myParent to (make new folder playlist at source myDevice with properties {name:P})
								delay longSleep
								tell me to wait_for_sync()
								log "created folder inside root : " & P
							else
								log "creating folder in the : " & name of myParent & " : " & P
								-- set myParent to make new folder playlist at playlist myParent of source myDevice with properties {name:P}
								set myParent to (make new folder playlist at myParent with properties {name:P}) -- no need to again tell myDevice
								
								delay longSleep
								tell me to wait_for_sync()
							end if
							
						else -- found one or more folders
							if myParent is "" then -- Parent is empty, In this case folder found must be in the root, else create
								
								repeat with aFolder in myFolders
									try
										set GP to name of aFolder's parent -- there is a parent means this folder is not in root
									on error
										set myParent to aFolder -- what ever found is in the root ,  myParent ahead. assumption is  only one folder in the root
									end try
								end repeat
								
								if myParent is "" then -- means we couldn't find a folder in the root
									set myParent to (make new folder playlist at source myDevice with properties {name:P}) -- create a folder at root and set to myParent
									delay longSleep
									tell me to wait_for_sync()
									log "created a folder at root - from lower : " & P
								else
									log "DEBUG : myParent is :" & name of myParent
									log "Root Folder  exists : " & P
								end if
								
							else -- myParent is not empty, means folder found must be under myParent, otherwise create new
								log "myParent is not empty"
								set isFound to 0
								repeat with aFolder in myFolders
									set GP to ""
									try
										set GP to aFolder's parent -- there is a parent means this folder is not in root
									end try
									if id of GP is id of myParent then -- comparing newly found parent with myParent
										log "found aParent : " & P
										set isFound to 1
										set tmpParent to aFolder -- what ever found is the myParent ahead
									end if
								end repeat
								
								if isFound is 0 then
									set myParent to (make new folder playlist at myParent with properties {name:P})
									delay longSleep
									tell me to wait_for_sync()
									log "create folder in the : " & name of myParent & " : " & P
								else
									set myParent to tmpParent -- what ever found is the myParent ahead
								end if
								
							end if
							
						end if
					end tell
				end if
				--- END  : dealing with Folders

			end repeat
			
		end if
		
	end repeat
	
end run


on createSmartPlaylist(theLabel, receivedCondition)
	
	log "receivedCondition is : " & receivedCondition -- conditions of the playlist
	log "theLabel is : " & theLabel -- name of the playlist
	
	
	set text item delimiters to ":"
	set myConditions to (text items of receivedCondition)
	if (count of myConditions) is 0 then
		return
	end if
	
	
	-- log "count of myConditions is " & (count of myConditions)
	set conditionCount to 0
	repeat with aCondition in myConditions -- repeat with every condition in the input
		set conditionCount to (conditionCount + 1)
		log "aCondition is : " & aCondition
		set text item delimiters to ","
		set aSplit to every text item of aCondition
		
		if item 2 of aSplit is "is in the range" then -- to deal with range based conditions
			set text item delimiters to "-"
			set aFrom to item 1 of (text items of (item 3 of aSplit))
			set aTo to item 2 of (text items of (item 3 of aSplit))
		end if
		
		
		tell application "iTunes"
			
			-- START : section  for just creating a playlist and to set its name properly. Actual conditions are set later	
			if conditionCount is 1 then -- only needed if the work is only on first condition of one playlist
				tell application "iTunes"
					
					tell application "System Events"
						tell process "iTunes"
							keystroke "n" using {option down, command down} -- New Smart Playlist…
							delay shortSleep
							tell window "Smart Playlist"
								tell scroll area 1
									tell group 1
										keystroke theLabel & return
									end tell
								end tell
							end tell
							
						end tell
						
					end tell
					
				end tell
				
				delay (longSleep + 1)
			end if
			-- END : section  for just creating a playlist and to set its name properly
			
			
			
			
			-- START : section  for setting conditions on above created playlist
			tell application "System Events"
				tell process "iTunes"
					if conditionCount is 1 then
						keystroke "i" using {command down} -- Edit newly created Smart Playlist…
					end if
					delay longSleep
					
					-- tell window "Smart Playlist"
					tell window theLabel
						
						tell scroll area 1
							
							-- get every UI element of group 1
							
							delay shortSleep
							tell group 1
								set myButton to (conditionCount * 2)
								log "myButton is : " & myButton
								
								if myButton > 2 then
									-- click  button "+"
									click (last button whose title is "+")
								end if
								
								tell pop up button (myButton - 1)
									click
									tell menu 1
										click menu item (item 1 of aSplit)
									end tell
								end tell
								tell pop up button (myButton)
									click
									tell menu 1
										click menu item (item 2 of aSplit)
									end tell
								end tell
								delay shortSleep
								if item 2 of aSplit is "is in the range" then
									log "reached for aFrom to aTo " & aFrom & " - " & aTo
									delay shortSleep
									keystroke aFrom & tab
									delay shortSleep
									keystroke aTo
								else
									keystroke (item 3 of aSplit)
									try
										set item3Char to (item 3 of aSplit as integer)
									on error
										set item3Char to "TEXT"
									end try
									set item3Type to class of item3Char as text
									if item3Type is "text" then -- have to press space & backspace to prevent auto fill
										log "item3 is text, might need backspace"
										delay shortSleep
										set nowText to value of last text field
										log "Now value is : " & nowText
										if nowText is not item 3 of aSplit then
											log "item3 is text, must need backspace"
											keystroke (ASCII character 8)
										end if
									end if
								end if
								
								delay shortSleep
							end tell
						end tell
					end tell
					
				end tell
				
			end tell
			
		end tell
	end repeat
	
	
	tell application "iTunes"
		activate
		tell application "System Events"
			keystroke return -- press enter key only after creating and updating playlist
		end tell
	end tell
	
	delay longSleep
	tell me to wait_for_sync()
end createSmartPlaylist



on sort_palylist_by(orderString)
	tell application "System Events"
		tell application process "iTunes"
			set frontmost to true
			tell window "iTunes"
				tell splitter group 1
					if myDevice is "Library" then -- this section is for Library
						
						if not (exists splitter group 1) then
							-- log "clicking View As Song"
							my click_viewas_song()
						end if
						if exists splitter group 1 then -- splitter group inside a splitter group works for Library device
							tell splitter group 1
								
								tell scroll area 1
									tell outline 1
										tell group 1
											delay 2
											tell button orderString
												-- log "first click"
												click
											end tell
										end tell
									end tell
								end tell
								
							end tell
						end if
					else
						tell scroll area 2 -- this section for ipod/iphone, assume scroll area exists
							tell outline 1
								tell group 1
									delay 2
									tell button orderString
										-- log "second click"
										click
									end tell
								end tell
							end tell
						end tell
					end if
				end tell
				
				
			end tell
			
		end tell
	end tell
end sort_palylist_by


on click_viewas_song()
	tell application "System Events"
		tell application process "iTunes"
			set frontmost to true
			tell menu bar 1
				tell menu "View"
					if exists menu item "View As" then
						tell menu item "View As"
							tell menu "View As"
								tell menu item "Songs"
									click
									-- get every UI element
								end tell
							end tell
						end tell
					end if
				end tell
			end tell
		end tell
	end tell
end click_viewas_song






-- START: function to make sure ipod is updated properly. Otherwise some entries not reflected on ipod 
on wait_for_sync()
	tell application "System Events" to tell application process "iTunes"
		set theStatusText to "Updating Files on"
		repeat until theStatusText does not contain "Updating Files on"
			try
				set theStatusText to value of static text 1 of scroll area 1 of window "iTunes"
			on error errText
				set theStatusText to ""
				
			end try
			delay shortSleep
			log theStatusText
		end repeat
	end tell
end wait_for_sync
-- END: function to make sure ipod is updated properly. Otherwise some entries not reflected on ipod 
