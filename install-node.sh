#!/bin/bash
# =================== RUN THIS ========================
# bash <( curl -s https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-node.sh )"
# =====================================================

read -p "Which Fork (redstone, x42, impleum, city, stratis)? " coin

COINSERVICEINSTALLER="https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-node.sh"
COINSERVICECONFIG="https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/config/config-$coin.sh"

# Install Coins Service
wget ${COINSERVICEINSTALLER} -O /home/${USER}/install-${coin}.sh
wget ${COINSERVICECONFIG} -O /home/${USER}/config-${coin}.sh
chmod +x /home/${USER}/install-${coin}.sh
/home/${USER}/install-$fork.sh -f ${coin}

