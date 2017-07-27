#!/bin/sh

lso() {
ls -alG "$@" | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print}';
}

locs() {
find . -name '*.js' | xargs -L 1 -I'{}' cat {} | wc -l | tr '\n' ' ';
echo 'locs of JavaScript code';
}