alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
alias md5sum=md5
alias sha1sum=shasum
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"
alias sed=gsed
