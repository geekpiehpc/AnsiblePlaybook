mv /etc/apt/sources.list /etc/apt/sources.list.bak
SYS_VERSION=$(lsb_release -c | grep -o "\s.*")
cat >> /etc/apt/sources.list << EOF
deb https://mirrors.geekpie.club/debian/ $SYS_VERSION main 
deb-src https://mirrors.geekpie.club/debian/ $SYS_VERSION main 

deb http://security.debian.org/debian-security  $SYS_VERSION/updates main 
deb-src http://security.debian.org/debian-security $SYS_VERSION/updates main 

deb https://mirrors.geekpie.club/debian/ $SYS_VERSION-updates main 
deb-src https://mirrors.geekpie.club/debian/ $SYS_VERSION-updates main 
EOF
apt update