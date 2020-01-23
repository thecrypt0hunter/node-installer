#!/bin/bash
# =================== RUN THIS ========================
#bash <( curl -s https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-node.sh )
# =====================================================

read -p "Which Coin (redstone, x42, impleum, city, stratis, xds)? " coin
read -p "Mainnet (m) or Testnet (t) or Upgrade (u)? " net
read -p "Which branch (default=master)? " branch

if [${branch} = ""]; then 
branch="master";
fi

COINSERVICEINSTALLER="https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-coin.sh"
COINSERVICECONFIG="https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/config/config-${coin}.sh"

# Install Coins Service
wget ${COINSERVICEINSTALLER} -O /tmp/install-coin.sh
wget ${COINSERVICECONFIG} -O /tmp/config-${coin}.sh
chmod +x /tmp/install-coin.sh
cd ~
/tmp/install-coin.sh -f ${coin} -n ${net} -b ${branch}