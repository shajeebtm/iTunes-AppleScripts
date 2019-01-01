global thePlaylist
global smartPlaylists
global allLists
global hashIndex
global hashValue
global hashKind
global beginRow
global endRow
global longSleep
global shortSleep
global isClicked
global sleepBetweenAlbums
global updateStartAttempts
global updateFinishAttempts


set playlistsSkipped to {"Music Videos", "TV & Movies", "Home Videos", "Books", "PDFs", "Audiobooks", "My Top Rated", "op 25 Most Played", "Recently Played", "Top 25 Most Played", "90?~@~Ys Music", "Classical Music", "Last Added", "Music", "Movies", "TV Shows", "Genius", "iTunes?| U", "Genres", "Internet Radio", "iTunes Store", "Audiobooks" , "Tones"}

set smartPlaylists to {}

set myDevice to {}
set beginRow to 0
set endRow to 0
set hashIndex to {}
set hashValue to {}
set hashKind to {}
set maxRow to 0
set longSleep to 1
set shortSleep to 0.5
set isClicked to 0
set sleepBetweenAlbums to 2
set updateStartAttempts to 50 -- with a delay of 0.5 sec between every attempt
set updateFinishAttempts to 3000000 -- with a delay of 1 sec between every attempt


-- ++ BEGIN : Getting list of connected devices and allowing user to choose one
tell application "iTunes"
        activate
        -- BEGIN : Find connected ipod/iphone name
        try
                set myIpods to (name of every source whose kind is iPod) -- for testing if any ipod
                -- set myIpods to (name of every source) -- for testing if any ipod
        on error
                error "Ohh, No ipod/iphone connected"
        end try
        set myIpods to (name of every source whose kind is iPod) as list -- to get in the list form
        set myDevice to (choose from list myIpods as list) as text
        if myDevice contains "false" then
                error "Ohh, You didnt choose any ipod/iphone"
        end if
        -- END : Find connected ipod/iphone name

        set allLists to (get every playlist of source myDevice)

end tell
-- ++ END : Getting list of connected devices and allowing user to choose one




-- ++ BEGIN : Collecting list of all playlists in the device
tell application "iTunes"
        activate
        repeat with A from 1 to count of allLists
                set myPlaylist to item A of allLists

                set myRow to A + 10

                set playlistName to name of myPlaylist

                if playlistsSkipped does not contain playlistName then
                        set myKind to special kind of myPlaylist as string
                        if myKind is "none" or myKind is "folder" then
                                set end of hashIndex to myRow
                                set end of hashValue to playlistName
                                set end of hashKind to myKind
                        end if
                end if
        end repeat
end tell

tell application "System Events"
        tell application process "iTunes"
                set maxRow to get count of row in outline 1 of scroll area 1 of splitter group 1 of window "iTunes"
        end tell
end tell

set maxItem to count of hashIndex
repeat with C from 1 to maxItem
        set I to item C of hashIndex
        set V to item C of hashValue
end repeat

tell application "iTunes"
        set myPlaylist to item 1 of allLists
        set view of front window to myPlaylist
        my verifyRowNumbers("FIRST")
        delay longSleep
        set myPlaylist to last item of allLists
        set view of front window to myPlaylist
        my verifyRowNumbers("LAST")

end tell
-- ++ END : Collecting list of all playlists in the device

-- ++ BEGIN : Allowing user to choose playlist type , then playlists and update all of them
tell application "iTunes"
        activate
        set playListTypes to {"SMART PlayLists", "STANDARD PlayLists"}
        set chooseListType to (choose from list playListTypes with title "Select PlayList type" with prompt "Category" as list) as text
        log "you chose :" & chooseListType

        if chooseListType contains "false" then
                error "Ohh, You didnt choose any playlist type"
        end if

        if chooseListType contains "SMART" then
                set smartPlaylists to (get user playlists of source myDevice whose smart is true and special kind is none)
        else
                set smartPlaylists to (get user playlists of source myDevice whose smart is not true and special kind is none)
        end if

        set PNames to {}
        set itemValueOfP to {}
        repeat with P in smartPlaylists


                set N to name of P as text
                set end of itemValueOfP to N as text
                if playlistsSkipped does not contain N then
                        set end of PNames to N as text
                end if
        end repeat

        set C to count of PNames
        set chosen_lists to choose from list PNames with title "Select PlayList" with prompt "Choose from " & C & " " & chooseListType & " " with multiple selections allowed
        set C to count of chosen_lists



        -- repeat with myPlaylist in smartPlaylists
        repeat with P in chosen_lists
                set playlistName to P as string

                -- set playlistName to name of myPlaylist
                if playlistsSkipped does not contain playlistName then

                        set myItem to 0
                        set isFound to 0
                        repeat until isFound is 1
                                set myItem to (myItem + 1)
                                set myValue to item myItem of itemValueOfP

                                if myValue is playlistName then
                                        set isFound to 1
                                        set myPlaylist to item myItem of smartPlaylists
                                end if
                        end repeat

                        -- log "name of myPlaylist is :" & name of myPlaylist
                        delay shortSleep
                        set view of front window to myPlaylist
                        delay shortSleep
                        my invoke_right_click(playlistName)
                        if isClicked is 1 then
                                -- delay longSleep
                                my wait_for_sync()
                        end if

                end if
        end repeat
        display dialog "Completed !"

end tell
-- ++ END : Allowing user to choose playlist type , then playlists and update all of them


--------------- FUNCTIONS START HERE

-- BEGIN : Function to get row number of each playlist
on verifyRowNumbers(rowName)

        if rowName is "FIRST" then
                set firstRow to item 1 of hashIndex
                set firstRowValue to item 1 of hashValue
        else
                if rowName is "LAST" then
                        set firstRow to last item of hashIndex
                        set firstRowValue to last item of hashValue
                else
                        return -- dont know what to do
                end if

        end if
        tell application "System Events"
                tell application process "iTunes"
                        if exists text field 1 of UI element 1 of row firstRow of outline 1 of scroll area 1 of splitter group 1 of window "iTunes" then
                                set lineName to value of text field 1 of UI element 1 of row firstRow of outline 1 of scroll area 1 of splitter group 1 of window "iTunes"
                                if firstRowValue is not lineName then
                                        error "Error : " & rowName & " row , " & firstRow & " , " & firstRowValue & " , found in GUI is : " & lineName
                                end if
                        end if
                end tell
        end tell

end verifyRowNumbers
-- END : Function to get row number of each playlist

-- BEGIN : Function of right click 
on invoke_right_click(listName)
        log "received listName : " & listName
        tell application "System Events"
                tell application process "iTunes"
                        set frontmost to true

                        set maxItem to count of hashIndex
                        repeat with C from 1 to maxItem
                                set myValue to item C of hashValue
                                set myRow to item C of hashIndex


                                if myValue is listName then
                                        log "I am going to click on : " & myValue

                                        delay 3
                                        set myItem to text field 1 of UI element 1 of row myRow of outline 1 of scroll area 1 of splitter group 1 of window "iTunes"

                                        set frontmost to true

                                        set {x, y} to position of myItem
                                        -- do shell script "/opt/local/bin/cliclick rc:" & x & "," & y
                                        do shell script "/opt/local/bin/cliclick kd:ctrl c:" & x & "," & y & " ku:ctrl"

                                        delay longSleep

                                        tell UI element 1
                                                tell menu 1
                                                        if exists menu item "Copy to Play Order" then

                                                                tell menu item "Copy to Play Order"
                                                                        --get properties of menu item "Play"
                                                                        click
                                                                        set isClicked to 1
                                                                end tell
                                                                -- delay shortSleep
                                                        else
                                                                key code 53 -- press escape key

                                                        end if
                                                end tell
                                        end tell

                                        return -- no more processing. duplicates playlist name will be skipped

                                else
                                        -- log "I dont  click on : " & myValue

                                end if

                        end repeat

                end tell
        end tell
end invoke_right_click
-- END : function for right click


-- BEGIN : function to make sure ipod is updated properly.
on wait_for_sync()
        tell application "System Events" to tell application process "iTunes"
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

                -- log "Yes, update has started in " & C &" attempts \n"

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

-- END: function to make sure ipod is updated properly. Otherwise some entries not reflected on ipod
-- END of functions

