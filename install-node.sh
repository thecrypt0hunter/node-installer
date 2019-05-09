#!/bin/bash
# =================== RUN THIS ========================
# bash <( curl -s https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-node.sh )"
# =====================================================

read -p "Which Fork (redstone, x42, impleum, city, stratis)? " coin

COINSERVICEINSTALLER="https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-node.sh"
COINSERVICECONFIG="https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/config/config-$coin.sh"

# Install Coins Service
wget ${COINSERVICEINSTALLER} -O ~/install-${coin}.sh
wget ${COINSERVICECONFIG} -O ~/config-${coin}.sh
chmod +x ~/install-${coin}.sh
~/install-$fork.sh -f ${coin}

