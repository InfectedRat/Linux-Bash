#!/bin/bash

USER=$1
PASS=$2
N=$1
for (( i = 1; i <= $N; i++ )); do
  useradd "${USER}_$i" && $(echo "${USER}_$i:${PASS}_$i" |chpasswd)
  echo "Пользователь ${USER}_$i добавлен!"
done