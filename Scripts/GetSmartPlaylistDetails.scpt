set playlistsSkipped to {"Music Videos", "TV & Movies", "Home Videos", "Books", "PDFs", "Audiobooks", "My Top Rated", "op 25 Most Played", "Recently Played", "Top 25 Most Played", "90?~@~Ys Music", "Classical Music", "Last Added", "Music", "Movies", "TV Shows", "Genius", "iTunes?| U"}
-- Above list is for skipping default smart playlists created by iTues.

set playlistDetails to {}
set myDevice to {}
set songDetails to {}
set rootFolder to "Albums:All"


-- BEGIN : Choose device
tell application "iTunes"
        activate
        -- BEGIN : Find connected ipod/iphone name
        try
                -- set myIpods to (name of every source whose kind is iPod) -- for testing if any ipod
                set myIpods to (name of every source) -- for testing if any ipod
        on error
                error "Ohh, No ipod/iphone connected"
        end try
        set myIpods to (name of every source as list) -- to get in the list form
        set myDevice to (choose from list myIpods as list) as text
        if myDevice contains "false" then
                error "Ohh, You didnt choose any ipod/iphone"
        end if

end tell
-- END : Choose device


tell application "iTunes"
        activate
        set thePlaylist to playlist "Music" of source myDevice -- setting "Music" on iPhone to active playlist
        set view of front window to thePlaylist -- setting "Music" on iPhone to active playlist
        delay 0.5
        repeat with aPlaylist in (get user playlists of source myDevice whose smart is true)

                set playlistName to name of aPlaylist as string
                set playlistPath to playlistName -- start path as the name of playlist
                set isSmart to "NON SMART"
                if aPlaylist is smart then
                        set isSmart to "SMART"
                end if


                if playlistsSkipped does not contain playlistPath then
                        set view of front window to aPlaylist
                        delay 0.5

                        set parentId to aPlaylist -- start with playlist as the parent
                        set P to 1
                        repeat while P = 1 -- repeat to get name of entire path
                                try
                                        set myParent to name of parentId's parent
                                on error
                                        set P to 0
                                end try
                                if P is 1 then
                                        set playlistPath to myParent & "::" & playlistPath
                                        set parentId to parentId's parent
                                end if
                        end repeat


                        set playlistDetails to {}
                        if isSmart is "SMART" then
                                set playlistDetails to my invokeEdit(playlistName as text)
                        end if
                        set myString to isSmart & "::" & playlistPath & ":-:" & playlistDetails & "
"
                        set songDetails to songDetails & {myString}

                        delay 1
                end if

        end repeat
        display alert "I am done !. Look at the terminal for Playlist details"
        return songDetails as text
end tell


on invokeEdit(theLabel)
        tell application "System Events"
                tell process "iTunes"
                        keystroke "i" using {command down} -- EditSmart Playlist?~@?
                        delay 1
                        -- get every UI element of window theLabel
                        tell window theLabel
                                tell scroll area 1

                                        -- get every UI element of group 1
                                        tell group 1
                                                -- get value of pop up button 1
                                                -- get value of pop up button 2
                                                -- get value of text field 1

                                                -- BEGIN : read all first row  conditions
                                                set nextText to 1
                                                set returnString to value of pop up button 1 & "," & value of pop up button 2 & "," & value of text field nextText

                                                if value of pop up button 2 contains "in the range" then
                                                        set nextText to (nextText + 1)
                                                        set returnString to returnString & "-" & value of text field nextText
                                                end if
                                                -- END : read all first row  conditions

                                                -- BEGIN : read condition of further rows
                                                set buttonCount to count of every pop up button
                                                repeat with n from 3 to buttonCount by 2 -- first 2 buttons are used by row one
                                                        set nextText to (nextText + 1)
                                                        set returnString to returnString & ":" & value of pop up button n & "," & value of pop up button (n + 1) & "," & value of text field nextText
                                                        if value of pop up button (n + 1) contains "in the range" then
                                                                set nextText to (nextText + 1)
                                                                set returnString to returnString & "-" & value of text field nextText
                                                        end if
                                                end repeat

                                        end tell

                                end tell
                                click button "Cancel"
                        end tell

                end tell
        end tell
        return returnString
end invokeEdit

