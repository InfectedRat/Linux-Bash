#!/bin/bash
# User manager script for Linux
# Created by Y.G.

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

# Output messages
# ---------------------------------------------------\
RED='\033[0;91m'
GREEN='\033[0;92m'
CYAN='\033[0;96m'
YELLOW='\033[0;93m'
PURPLE='\033[0;95m'
BLUE='\033[0;94m'
BOLD='\033[1m'
WHiTE="\e[1;37m"
NC='\033[0m'

ON_SUCCESS="DONE"
ON_FAIL="FAIL"
ON_ERROR="Oops"
ON_CHECK="✓"

Info() {
  echo -en "[${1}] ${GREEN}${2}${NC}\n"
}

Warn() {
  echo -en "[${1}] ${PURPLE}${2}${NC}\n"
}

Success() {
  echo -en "[${1}] ${GREEN}${2}${NC}\n"
}

Error () {
  echo -en "[${1}] ${RED}${2}${NC}\n"
}

Splash() {
  echo -en "${WHiTE} ${1}${NC}\n"
}

space() {
  echo -e ""
}


# Functions
# ---------------------------------------------------\

# Yes / No confirmation
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

check_bkp_folder() {
    if [[ ! -d "$BACKUPS" ]]; then
        mkdir -p $BACKUPS
    fi
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

# Actions
# ---------------------------------------------------\

# User menu rotator
  while true
    do
        PS3='Please enter your choice: '
        options=(
        "Create new user"
        "List users"
        "Reset password for user"
        "Lock user"
        "Unlock user"
        "List all locked users"
        "Backup user"
        "Generate SSH key for user"
        "Promote user to admin"
        "Degrate user from admin"
        "Delete user"
        "Quit"
        )
        select opt in "${options[@]}"
        do
         case $opt in
            "Create new user")
                create_user
                break
                ;;
            "List users")
                list_users
                break
                ;;
            "Reset password for user")
                reset_password
                break
                ;;
            "Lock user")
                lock_user
                break
                ;;
            "Unlock user")
                unlock_user
                break
                ;;
            "List all locked users")
                list_locked_users
                break
                ;;
            "Backup user")
                backup_user
                break
                ;;
            "Generate SSH key for user")
                generate_ssh_key
                break
                ;;
            "Delete user")
                delete_user
                break
                ;;
            "Promote user to admin")
                 promote_user
                 break
             ;;
            "Degrate user from admin")
                 degrate_user
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