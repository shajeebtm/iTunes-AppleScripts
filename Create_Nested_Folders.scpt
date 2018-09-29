global sleepBetweenAlbums
global updateStartAttempts
global updateFinishAttempts

set myDevice to {}
set rootFolder to "Albums:All" -- Name of the root folder
set myString to "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
set myChars to characters of myString -- get a list with every character as one element
set sleepBetweenFolders to 0.25
set sleepBetweenAlbums to 2
set updateStartAttempts to 20 -- with a delay of 0.5 sec between every attempt
set updateFinishAttempts to 30 -- with a delay of 1 sec between every attempt



-- BEGIN : create roolfolder and sub folders if they dont exists
tell application "iTunes"
	activate
	
	-- BEGIN : Find connected ipod/iphone name
	-- try
		-- set myIpods to (name of every source whose kind is iPod) -- for testing if any ipod
	-- on error
	--	error "Ohh, No ipod/iphone connected"
	-- end try
	-- set myIpods to (name of every source whose kind is iPod) as list -- to get in the list form
	set myIpods to (name of every source) as list -- to get in the list form
	set myDevice to (choose from list myIpods as list) as text
	if myDevice contains "false" then
		error "Ohh, You didnt choose any ipod/iphone"
	end if
	-- log myDevice
	-- END : Find connected ipod/iphone name
	
	
	--  BEGIN: create root folder	
	set currentFolderLists to (get name of playlists of source myDevice)
	if currentFolderLists does not contain rootFolder then
		log "Not found " & rootFolder
		make new folder playlist at source myDevice with properties {name:rootFolder}
		delay sleepBetweenFolders
		tell me to wait_for_sync()
	end if
	--  END: create root folder	
	
	
	
	--  BEGIN: create sub folders
	repeat with myLetter in myChars
		set listName to myLetter & "_albums"
		if currentFolderLists does not contain listName then
			with transaction
				make new folder playlist at folder playlist rootFolder of source myDevice with properties {name:listName}
				delay sleepBetweenFolders
				tell me to wait_for_sync()
				
				log "completed " & listName
			end transaction
		end if
	end repeat
	--  END: create sub folders

	display dialog "Completed !"

end tell
-- END : create roolfolder and sub folders if they dont exists



-- BEGIN : Supporting functions

on wait_for_sync()
	tell application "System Events" to tell application process "iTunes"
		-- tell application "iTunes" to activate
		set theStatusText to ""
		set C to 0
		repeat until theStatusText  contain "Updating Files on"
			set C to (C + 1)
			if C > updateStartAttempts then
				error "Giving up , didnt start update in " & C &" attempts"
			end if
			try
				set theStatusText to value of static text 1 of scroll area 1 of window "iTunes"
			on error errText
				set theStatusText to ""
				
			end try
			delay 0.5
			log theStatusText
		end repeat

		log "Yes, update has started in " & C &" attempts \n"

		delay sleepBetweenAlbums
		set C to 0
                repeat until theStatusText does not contain "Updating Files on"
			set C to (C + 1)
			if C > updateFinishAttempts then
				error "Giving up , didnt finish update in " & C &" attempts"
			end if
			
                        try
                                set theStatusText to value of static text 1 of scroll area 1 of window "iTunes"
                        on error errText
                                set theStatusText to ""

                        end try
                        delay 1
                        log theStatusText
                end repeat
		log "Yes, update has finsihed in " & C &" attempts \n" 


	end tell
end wait_for_sync

-- END : Supporting functions
