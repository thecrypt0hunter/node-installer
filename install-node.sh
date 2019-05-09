#!/bin/bash
# =================== RUN THIS ========================
# bash <( curl -s https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-node.sh )"
# =====================================================

read -p "Which Fork (redstone, x42, impleum, city, stratis)? " coin

COINSERVICEINSTALLER="https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-coin.sh"
COINSERVICECONFIG="https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/config/config-${coin}.sh"

# Install Coins Service
wget ${COINSERVICEINSTALLER} -O /tmp/install-coin.sh
wget ${COINSERVICECONFIG} -O /tmp/config-${coin}.sh
chmod +x /tmp/install-${coin}.sh
/tmp/install-coin.sh -c ${coin}

