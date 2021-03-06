#!/bin/sh

lso() {
    # -n
    ls -alG --group-directories-first "$@" | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print}';
}

shutdown() {
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


yarnglist() {
    yarn global list --depth=0
}

whatsize() {
    du -sh /*
}

linkedmodules() {
	( ls -l node_modules ; ls -l node_modules/@* ) | grep ^l
}

makeLaptopSleep() {
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
    local pid=$(lsof -ti tcp:$1) 
    if [[ ! -z "$pid" ]]; then
        echo "Killing something on port ${1}, pid:${pid}"
        kill -9 $(lsof -ti tcp:$1)
    else
        echo "Nothing to kill on port ${1}"
    fi
}

moveAllFilesToOneLetterDirs() {
    for f in *; do d="${f:0:1}"; mkdir -p "$d"; mv -t "$d" -- "$f"; done
}

deleteImagesByContainerName() {
    docker ps -a | grep $1 | awk '{print $1}' | xargs docker rm
}

serve() {
    if [[ -z $1 ]]; then
        local dir=.
    else
        local dir=$1
    fi
    if [[ -z $2 ]]; then
        local port=9000
    else
        local port=$2
    fi
    printf '%s %s %s %s' 'Serving content of' $dir 'on port' $port
    pushd $dir; python -m SimpleHTTPServer $port; popd;
}

elk() {
    docker start elk
}

yarnpubkey() {
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
}

winepubkey() {
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && sudo apt-key add winehq.key
    # && sudo apt update
    #curl -sS https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
}

chromepubkey() {
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
}


signalpubkey() {
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
}

# show all ppa
showppa() {
    apt-cache policy | grep http | awk '{print $2 $3}' | sort -u
}

disableLineIn() {
    pactl unload-module module-loopback
}

enableLineIn() {
    # pacmd load-module module-loopback latency_msec=10
    pactl load-module module-loopback latency_msec=10
}

mountBtrfsPool() {
    sudo mount -t btrfs /dev/sdb2 /mnt/btrfs_pool
}

# https://askubuntu.com/questions/156650/apt-get-update-very-slow-stuck-at-waiting-for-headers
aptGetCleanLists() {
    pushd /var/lib/apt
    sudo apt-get clean
    sudo mv lists lists.old
    sudo mkdir -p lists/partial
    sudo apt-get clean
    sudo apt-get update
    popd
}

# https://askubuntu.com/a/759459/28081
docker-ssh() {
    container=$@
    if [[ "$container" == "" ]]; then
        # if no id given simply just connect to the first running container
        container=$(docker ps | grep -Eo "^[0-9a-z]{8,}\b")
    fi
    # start an interactive bash inside the container
    # note some containers don't have bash, then try: ash (alpine), or simply sh
    # the -l at the end stands for login shell that reads profile files (read man)
    docker exec -i -t $container bash -l
}

# https://github.com/teracyhq/httpie-jwt-auth
http-jwt() {
    export JWT_AUTH_TOKEN=$@
}


showPkgDependencies() {
    packages=($@) #openjdk-13-jre-headless default-jre-headless
    for pkg in "${packages[@]}"; do
        apt_cache_out="$(apt-cache --installed rdepends "$pkg" | grep -E '^ [| ]\S')"
        if (( $? == 0 )); then
            echo -----------------------
            echo "$pkg"
            echo "$apt_cache_out"
        fi
    done
}

lazydocker() {
    docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /home/marek/.config/jesseduffield/lazydocker:/.config/jesseduffield/lazydocker \
    lazyteam/lazydocker
}


updatenvm() {
    set -e
    cd ~/.nvm
    git fetch --tags
    TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
    echo "Checking out tag $TAG..."
    git checkout "$TAG"
    source ~/.nvm/nvm.sh
}


findhere() {
    find . -name $1 
}

ispackageinstalled() {
    dpkg --list | grep "$1"
}

md5() {
    echo -n $1 | md5sum | awk '{print $1}'
}

__bashrc_command_timer_start() {
    __bashrc_command="${__bashrc_command-"${BASH_COMMAND%% *}"}"
    __bashrc_command_start="${__bashrc_command_start-"$SECONDS"}"
}
trap __bashrc_command_timer_start DEBUG

__bashrc_command_timer_notify() {
    # https://gitlab.com/victor-engmark/tilde/-/blob/1fc8b9f6ab0586499c7921b1452c43c394cd1e39/.bashrc
    # Notify if the command ran for a long time
    if [[ "$(("$SECONDS" - "$__bashrc_command_start"))" -gt 60 ]]
    then
        notify-send "\`${__bashrc_command} …\` finished with exit code ${exit_code}"
    fi
    unset __bashrc_command __bashrc_command_start

}

makeSureAllTerminalsSaveHistory() {
    # https://gitlab.com/victor-engmark/tilde/-/blob/1fc8b9f6ab0586499c7921b1452c43c394cd1e39/.bashrc
    # Make sure all terminals save history
    # put into PROMPT_COMMAND
    history -a
    history -c
    history -r
}
