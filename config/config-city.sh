function setMainVars() {
## set network dependent variables
NETWORK=""
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.${FORK}node/${FORK}/CityMain
COINPORT=4333
COINRPCPORT=4334
COINAPIPORT=4335
}

function setTestVars() {
## set network dependent variables
NETWORK="-testnet"
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.${FORK}node/${FORK}/CityTest
COINPORT=24333
COINRPCPORT=24334
COINAPIPORT=24335
}

function setGeneralVars() {
## set general variables
COINRUNCMD="sudo dotnet ./City.Chain.dll ${NETWORK} -datadir=/home/${NODE_USER}/.${FORK}chain -maxblkmem=2 #-stake -walletname=\${STAKINGNAME} -walletpassword=\${STAKINGPASSWORD}"
COINGITHUB=https://github.com/CityChainFoundation/city-chain.git
COINDSRC=/home/${NODE_USER}/code/src/City.Chain
CONF=release
COINDAEMON=${FORK}d
COINCONFIG=${FORK}.conf
COINSTARTUP=/home/${NODE_USER}/${FORK}d
COINDLOC=/home/${NODE_USER}/${FORK}node
COINSERVICELOC=/etc/systemd/system/
COINSERVICENAME=${COINDAEMON}@${NODE_USER}
SWAPSIZE="1024" ## =1GB
}