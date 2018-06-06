#!/bin/bash

#设置
if [ ! -n "$1" ] ;then
user="me"
else
user=$1
fi
echo "create account: $user"

name=".$user-alias"
declare -A logs_path=(
["127.0.0.1"]="/var/log1"
["127.0.0.2"]="/var/log2"
["127.0.0.3"]="/var/log3"
)
my_ip=`ifconfig -a|grep inet|grep 255.255.255.0|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"__`

(
cat<<EOF

#!/bin/bash

#set special alias
alias $user="([ -d /home/$user ] || mkdir /home/$user) && cd /home/$user"
alias logs="cd ${logs_path[$my_ip]}"
alias log="tail -fn 200"

#set common alias
alias l.='ls -d .* -h --color=auto --time-style=long-iso'
alias ll='ls -l -h --color=auto --time-style=long-iso'
alias ls='ls -h --color=auto --time-style=long-iso'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

EOF
) > "/root/$name"

#执行
. "/root/$name"

#清理
sed -i "/$name/d" /root/.bashrc > /dev/null

#配置
echo ". /root/$name" >> /root/.bashrc

#生效
. /root/.bashrc
echo "install success..."

