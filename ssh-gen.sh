#!/bin/bash

#Create xuser
PFILE=/etc/passwd
xuseraction() {
/usr/sbin/useradd -G users,cdrom,floppy,audio,video,plugdev,users,lp -s /bin/bash -p $MD5PASS -d $XHOME $XUSER
}
xuseradd() {
 echo "Создаю пользователя xuser"
        XUSER=xuser
        XHOME=/home/xuser
        echo "Введите пароль для пользователя xuser:"
        echo "В целях безопасности вводите пароль достаточной сложности: не менее 8 символов, содержащий буквы верхнего и нижнего регистра";
        stty -echo
        read PASSWD
        echo "Повторите пароль для пользователя xuser:"
        stty -echo
        read REPASSWD
        stty echo
}

if [ -e $PFILE ]; then
        PLINE=$(grep -c '^xuser:' $PFILE)
        echo $PLINE

                if [ "$PLINE" -eq 0 ]; then
        while [ "$PLINE" -eq 0 ]
do
        xuseradd
        if [ "$PASSWD" = "$REPASSWD" ]; then
        MD5PASS=$(/usr/bin/mkpasswd -m md5 $PASSWD)
        xuseraction
        PLINE=$(grep -c '^xuser:' $PFILE)
        else
        echo "================================================================="
        echo "Пароли не совпадают"
        echo "================================================================="
        fi
done
else echo "Пользователь $XUSER уже зарегестрирован в вашей системе"
                fi
fi