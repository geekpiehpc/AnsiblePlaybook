mv /etc/apt/sources.list /etc/apt/sources.list.bak
SYS_VERSION=$(lsb_release -c | grep -o "\s.*")
cat >> /etc/apt/sources.list << EOF
deb https://mirrors.sjtug.sjtu.edu.cn/debian/ buster main 
deb-src https://mirrors.sjtug.sjtu.edu.cn/debian/ buster main 

deb http://security.debian.org/debian-security  buster/updates main 
deb-src http://security.debian.org/debian-security buster/updates main 

deb https://mirrors.sjtug.sjtu.edu.cn/debian/ buster-updates main 
deb-src https://mirrors.sjtug.sjtu.edu.cn/debian/ buster-updates main 
EOF
apt update