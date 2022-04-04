#!/bin/bash

#USER=$1
#PASS=$2
#N=$1
#for (( i = 1; i <= $N; i++ )); do
#  useradd "${USER}_$i" && $(echo "${USER}_$i:${PASS}_$i" |chpasswd)
#  echo "Пользователь ${USER}_$i добавлен!"
#done


 # Оценка входящих параметров, выход, если одно условие параметра не выполнено
[ ! $# -eq 1 ] && echo "args error!!!" && exit 2

 # Определение существования пользователя, выход, если он существует
id $1 >&/dev/null && echo "user exist" && exit 3

 # Создать пользователя, выйти после успешного создания
useradd $1 >&/dev/null && echo $1 | passwd --stdin $1 >&/dev/null && echo "user add success" && exit 4

 # Создать сообщение об ошибке
