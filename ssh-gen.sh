#!/bin/bash

#!/usr/bin/env bash
#filename admin.sh
echo "Wellcome to Rassia"
echo "What you want to do?"
select task in ADDUSER EXIT

do
    case $task in
        ADDUSER)
            read -p "Введите имя нового пользователя: " user
            awk -F: '$3 ~ /1[0-9][0-9][0-9]/ {print $1;}' /home
            useradd -N -g $user
            read -p "Задайте пароль пользователя $user: " pswd
            chpasswd <<< "$user:$pswd"
            [[ $? == 0 ]] && echo "Ползователь создан" && exit 0;;
        EXIT)
            echo 'by!'
            exit 0;;
        *)
            echo "What is this?";;
    esac
done