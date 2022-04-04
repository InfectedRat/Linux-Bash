#!/bin/bash

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
cd $SCRIPT_PATH

# Vars
# ---------------------------------------------------\
ME=`basename "$0"`
BACKUPS=$SCRIPT_PATH/backups
SERVER_NAME=`hostname`
SERVER_IP=$(hostname -I | cut -d' ' -f1)
LOG=$SCRIPT_PATH/actions.log

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

gen_pass() {
  local l=$1
  [ "$l" == "" ] && l=9
  tr -dc A-Za-z0-9 < /dev/urandom | head -c ${l} | xargs
}

create_user() {
    space
    read -p "Enter user name: " user

    if id -u "$user" >/dev/null 2>&1; then
        Error "Error" "User $user exists. Try to set another user name."
    else
        Info "Info" "User $user will be create.."

        local pass=$(gen_pass)

        if confirm "Promote user to admin? (y/n or enter for n)"; then
            useradd -m -s /bin/bash -G wheel ${user}
            echo "%$user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$user
        else
            useradd -m -s /bin/bash ${user}
        fi

        # set password
        echo "$user:$pass" | chpasswd

        Info "Info" "User created. Name: $user. Password: $pass"
        logthis "User created. Name: $user. Password: $pass"

    fi
    space

}

# Menu user
  while true
    do
        PS3='Please enter your choice: '
        options=(
        "Create new user"
        "Quit"
        )
        select opt in "${options[@]}"
        do
         case $opt in
            "Create new user")
            break
            ;;
            "Quit")
                 Info "Exit" "Bye"
                 exit
             ;;
            *) echo invalid option;;
         esac
    done
   done