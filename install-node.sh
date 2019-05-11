#!/bin/bash
# =================== RUN THIS ========================
# bash <( curl -s https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-node.sh )"
# =====================================================


## Only tested with linux-x64 & Ubuntu 16 & 18 - feel free to do a PR to improve compatibility ##
arch="linux-x64"    #(Most desktop distributions like CentOS, Debian, Fedora, Ubuntu and derivatives) ##
#arch="linux-arm"   # Linux distributions running on ARM like Raspberry Pi)
OS="Ubuntu*"

read -p "Which Coin (redstone, x42, impleum, city, stratis)? " coin

COINSERVICEINSTALLER="https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-coin.sh"
COINSERVICECONFIG="https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/config/config-${coin}.sh"

# Install Coins Service
wget ${COINSERVICEINSTALLER} -O /tmp/install-coin.sh
wget ${COINSERVICECONFIG} -O /tmp/config-${coin}.sh
chmod +x /tmp/install-coin.sh
/tmp/install-coin.sh -c ${coin} -a ${arch} -o ${OS}

