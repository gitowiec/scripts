#!/bin/sh

lso() {
ls -alG --group-directories-first "$@" | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print}';
}

shutdown(){
sudo shutdown -h now;
}

locs() {
find . -name '*.js' | xargs -L 1 -I'{}' cat {} | wc -l | tr '\n' ' ';
echo 'locs of JavaScript code';
}

showgroups() {
    cut -d: -f1 /etc/group
}

function npm-do { (PATH=$(npm bin):$PATH; eval $@;) }

dolp() {
    echo -e "Starting default file manager here...\n"
    kfmclient exec .
}

npmglist() {
    npm list -g --depth=0
}
whatsize() {
    du -sh /*
}

afon() {
    sudo uvcdynctrl -v --set='Focus, Auto' 1
}

afoff() {
    sudo uvcdynctrl -v --set='Focus, Auto' 0
}