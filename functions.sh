#!/bin/sh

lso() {
    # -n
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
    cut -d: -f1 /etc/group | sort
}

npm-do() {
    (PATH=$(npm bin):$PATH; eval $@;)
}

yarn-do() {
    (PATH=$(yarn bin):$PATH; eval $@;)
}

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

linkedmodules(){
	( ls -l node_modules ; ls -l node_modules/@* ) | grep ^l
}

makeLaptopSleep(){
	sudo sh -c "echo EHC1 > /proc/acpi/wakeup;echo EHC2 > /proc/acpi/wakeup;echo XHC > /proc/acpi/wakeup"
}

ssteam() {
	STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0 steam
}

prettyPrint() {
	python -m json.tool
}

#https://github.com/cshorler/webcam-tools/
afon() {
    sudo uvcdynctrl -v --set='Focus, Auto' 1
}

afoff() {
    sudo uvcdynctrl -v --set='Focus, Auto' 0
}

killbyport() {
    kill -9 $(lsof -ti tcp:$1)
}

moveAllFilesToOneLetterDirs () {
    for f in *; do d="${f:0:1}"; mkdir -p "$d"; mv -t "$d" -- "$f"; done
}

deleteImagesByContainerName () {
    docker ps -a | grep $1 | awk '{print $1}' | xargs docker rm
}

serve() {
    pushd $@; python -m SimpleHTTPServer 8899; popd;
}

elk() {
    docker start elk
}

yarnpubkey() {
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
}