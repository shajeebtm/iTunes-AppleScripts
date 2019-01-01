set myDevice to {}
set songDetails to {}

tell application "iTunes"
        -- BEGIN : Choose one the Library
        set myIpods to (name of every source as list) -- to get in the list form
        set myDevice to (choose from list myIpods as list) as text
        if myDevice contains "false" then
                error "Ohh, You didnt choose any ipod/iphone"
        end if      
end tell


tell application "iTunes"
        set thePlaylist to playlist "Music" of source myDevice -- setting "Music" on iPhone to active playlist
        set view of front window to thePlaylist -- setting "Music" on iPhone to active playlist
        
        set allSongs to (every track of thePlaylist whose enabled is true) as list
        repeat with mySong in allSongs
                set songName to name of mySong as text
                set albumName to album of mySong as text
                set thisSong to name of mySong as text & ":" &album of mySong as text &":" &album artist of mySong &":" &composer of mySong &":" &year of mySong &":" &artist of mySong &":" &comment of mySong &"\n"
                set songDetails to songDetails & {thisSong}
        end repeat
        
        return songDetails as text
        
end tell
