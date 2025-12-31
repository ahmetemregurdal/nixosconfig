#!/bin/sh

menu="@dmenu@ -i"
terminal="@spawnTerm@"
copyCmd="@copyCmd@"
dunstify="@dunstify@"
editor="@editor@"
rbw="@rbw@"

[ ! -f "$HOME/.config/rbw/config.json" ] && $dunstify -t 15000 "rbw not configured, or config file is broken" "\nRun \"rbw config set email your_bit_warden_login_email\" to config.\n\nMake sure $HOME/.config/rbw/config.json exists\n\nOnce that's done, start rbwmenu again" && exit 1

entry_list=$(rbw list)
set -- " Add" "󱡄 Generate" "$entry_list"

entry=$(printf "%s\n" "$@" | $menu -p "󰌾 ")
[ -z "$entry" ] && exit 1

fn_add () {
    getnewentry=$($menu -p "Entry name: " < /dev/null)
    [ -z "$getnewuser" ] && exit 1

    getnewuser=$($menu -p "Username: " < /dev/null)
    [ -z "$getnewuser" ] && exit 1

    gen_pass=$(printf "Generate\nNew\nReuse" | $menu -p "Password Method: ")
    [ -z "$gen_pass" ] && exit 1

    case $gen_pass in
        "Generate" ) pass_length=$($menu -p "Password length: " < /dev/null )
            [ -z "$pass_length" ] && exit 1

            $rbw gen $pass_length | $copyCmd
            $dunstify -t 5000 "Please paste the password into the new entry terminal"

            $terminal $rbw add $getnewentry $getnewuser
            $dunstify "$getnewentry added to personal Bitwarden database"
            ;;

        "New" ) $dunstify "rbw opened a terminal to add password for new entry \"$getnewuser\""

            $terminal $rbw add $getnewentry $getnewuser
            $dunstify "$getnewentry added to personal Bitwarden database"
            ;;

        "Reuse" ) $dunstify "Reusing passwords across accounts is not recommended"
            where_from=$($rbw list | $dmenu -p "Target")
            [ -z "$where_from" ] && exit 1

            $rbw get $where_from | $copyCmd
            $dunstify -t 5000 "Please paste the password into the new entry terminal"

            $terminal $rbw add $getnewentry $getnewuser
            $dunstify "$getnewentry added to personal Bitwarden database" ;;
    esac
    exit
}

fn_gen () {
    while : ; do
        how_long=$($dmenu -p "Enter a number for password length (>21 recommended)" < /dev/null)
        [ -z "$how_long" ] && exit 1

        case $how_long in
            ''|*[!0-9]* ) $dunstify -t 5000 "Need a number. Try again" ;;
            * ) $rbw gen $how_long | $copyCmd
                $dunstify "New password copied to clipboard"
                exit
        esac
    done
}


[ "$entry" = " Add" ] && fn_add
[ "$entry" = "󱡄 Generate" ] && fn_gen

# Only functions here. scroll down to the while loop for script operation
edit_entry () {
    $dunstify -t 5000 "Please read instruction carefully before saving new passowrd"
    $terminal $rbw edit "$entry"
    exit
}

getpass=$($rbw get "$entry") || ($dunstify "Error getting password for \"$entry\"" "Please try again" && exit)
getlogin=$($rbw get --field user "$entry" | cut -d ' ' -f 2)

nologin_nopass () {
    $dunstify -5000 "Both username and password are empty" "Consider adding them maybe \?"
    exit 1
}

nologin () { printf '%s' "$getpass" | $copyCmd \
    && $dunstify -t 5000 "No username found for \"$entry\"" "Password copied to clipboard" && exit
}

nopass () { printf '%s' "$getlogin" | $copyCmd \
    && $dunstify -t 5000 "No password found for \"$entry\"" "Username copied to clipboard" && exit
}

yeslogin_yespass () {
    printf '%s' "$getlogin" | $copyCmd
    clickme=$($dunstify -t "$notiduration" --action="default,Reply" "Username copied to clipboard" "Click this to copy password to clipboard\n\n<b>Noti will last for "$(($notiduration/1000))" seconds</b>")
    [ "$clickme" = "1" ] && exit 1
    [ "$clickme" = "default" ] && printf '%s' "$getpass" | $copyCmd
    exit
}

delete_entry () {
    confirm=$(printf "Yes\nNo" | $menu -p "Confirm deleting \"$entry\" ")
    [ -z "$confirm" ] && exit 1
    [ ! "$confirm" = "Yes" ] && exit 1
    [ "$confirm" = "Yes" ] && $rbw remove "$entry" && $dunstify "Success" "Entry \"$entry\" deleted" || $dunstify "Failed" "Entry \"$entry\" not deleted"
    exit
}

while : ; do
    set -- "Password" "Username" "Both" "Notes" "URL" "Full" "Card options" "Edit" "Delete"

    askaction=$( printf '%s\n' "$@" | $menu -p "Action: " )
    [ -z "$askaction" ] && exit 1
    case $askaction in

        "Password" ) # print password to clipboard
            [ -z "$getpass" ] && $dunstify -t 3000 "rbwmenu" "Entry for <b>\"$entry\"</b> had no password" && exit
            printf '%s' "$getpass" | $copyCmd && $dunstify "Password for \"$entry\"" "copied to clipboard" && exit ;;

        "Username" ) # print username to clipboard
            [ -z "$getlogin" ] && $dunstify -t 3000 "rbwmenu" "Entry for <b>\"$entry\"</b> had no username" && exit 1
            printf '%s' "$getlogin" | $copyCmd && dunstify "Username for \"$entry\"" "copied to clipboard" && exit ;;

        "Both" )
            [ ! "$getpass" ] && [ ! "$getlogin" ] && nologin_nopass
            [ "$getpass" ] && [ ! "$getlogin" ] && nologin
            [ ! "$getpass" ] && [ "$getlogin" ] && nopass
            [ "$getpass" ] && [ "$getlogin" ] && yeslogin_yespass ;;

        "Notes" ) getnotes=$($rbw get --field notes "$entry")
            click_notes=$($dunstify -t "$notiduration" --action="default,Reply" "Notes for \"$entry\"" "\n$getnotes\n\n<b>Noti lasts "$(($notiduration/1000))" seconds\n\nClick to copy content to clipboard and view in \$EDITOR</b>")
            case "$click_notes" in
                1 )  exit 1 ;;
                default ) printf '%s' "$getnotes" | $copyCmd
                    note_file=$(mktemp)
                    $rbw get --field notes "$entry" > $note_file
                    $editor $note_file 2>/dev/null
                    rm $note_file
                    exit
            esac
            ;;

        "URL" ) geturl=$($rbw get --field urls "$entry" | cut -d ' ' -f 2)
            click_url=$($dunstify -t "$notiduration" --action="default,Reply" "URL for \"$entry\"" "\n$geturl\n\n<b>Noti last for "$(($notiduration/1000))" seconds</b>")
            [ "$click_url" = "1" ] && exit 1
            [ "$click_url" = "default" ] && printf '%s' "$geturl" | xclip -se c
            exit ;;

        "Full" ) getfull=$($rbw get --full "$entry")
            click_full=$($dunstify -t "$notiduration" --action="default,Reply" "Notes for \"$entry\"" "\n$getfull\n\n<b>Noti lasts for "$(($notiduration/1000))" seconds\n\nClick to copy content to clipboard and view in \$EDITOR</b>")
            case "$click_full" in
                1 )  exit 1 ;;
                default ) printf '%s' "$getfull" | $copyCmd
                    full_file=$(mktemp)
                    $rbw get --full "$entry" > $full_file
                    $editor $full_file 2>/dev/null
                    rm $full_file
                    exit
            esac ;;

        "Card options" )
            set -- "Number" "Exp" "CVV" "Name" "Type" "Notes"

            # TODO: add a fail message if entry is not a card
            # meaning it wont have card infos
            # now to bed. too tired to anything else

            while : ; do
                card_opt=$(printf '%s\n' "$@" | $menu -p "Card options for "$entry": ")
                [ -z "$card_opt" ] && exit 1

                get_card=$(rbw get --field "$card_opt" "$entry")
                printf '%s' "$get_card" | $copyCmd

                click_card=$($dunstify -t "$notiduration" --action="default,Reply" "$card_opt for \"$entry\"" \
                    "[ copied to clipboard ]<b>\n\nClick noti to view in \$EDITOR</b>\nNoti lasts for "$(($notiduration/1000))" seconds")

                case "$click_card" in
                    1 )  exit 1 ;;
                    default ) card_file=$(mktemp)
                        printf "$get_card" > $card_file
                        $rbw get --full "$entry" > $full_file
                        $editor $card_file 2>/dev/null
                        rm $card_file
                        exit
                esac
            done
            ;;

        "Edit" ) edit_entry ;;
        "Delete" ) delete_entry ;;

        * ) $dunstify -t 5000 "Invalid option. Try again" "And choose a valid one this time"
    esac
done

