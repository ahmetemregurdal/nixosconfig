#!/bin/sh

menu="@dmenu@ -i"
terminal="@spawnTerm@"
copyCmd="@copyCmd@"
editor="@editor@"

entry_list=$(rbw list)
set -- "$entry_list"

entry=$(printf "%s\n" "$@" | $menu -p "󰌾 ")
[ -z "$entry" ] && exit 1

getpass=$(rbw get "$entry") || (dunstify "Error getting password for \"$entry\"" "Please try again" && exit)
getlogin=$(rbw get --field user "$entry" | cut -d ' ' -f 2)

while : ; do
    set -- "Password" "Username"

    askaction=$(printf '%s\n' "$@" | $menu -p "Action: " )
    [ -z "$askaction" ] && exit 1
    case $askaction in

        "Password" ) # print password to clipboard
            [ -z "$getpass" ] && dunstify -t 3000 "rbwmenu" "Entry for <b>\"$entry\"</b> had no password" && exit
            printf '%s' "$getpass" | $copyCmd && dunstify "Password for \"$entry\"" "copied to clipboard" && exit ;;

        "Username" ) # print username to clipboard
            [ -z "$getlogin" ] && dunstify -t 3000 "rbwmenu" "Entry for <b>\"$entry\"</b> had no username" && exit 1
            printf '%s' "$getlogin" | $copyCmd && dunstify "Username for \"$entry\"" "copied to clipboard" && exit ;;

        * ) dunstify -t 5000 "Invalid option. Try again" "And choose a valid one this time"
    esac
done

