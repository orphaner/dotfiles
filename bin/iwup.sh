#!/bin/bash

rmmod iwlmvm
rmmod iwlwifi

modprobe iwlwifi
sleep 1s
ip link set wlp2s0 up
