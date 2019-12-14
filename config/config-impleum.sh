function setMainVars() {
## set network dependent variables
NETWORK=""
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.${FORK}node/${FORK}/ImpleumMain
COINPORT=16271
COINRPCPORT=16172
COINAPIPORT=38222
}

function setTestVars() {
## set network dependent variables
NETWORK="-testnet"
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.${FORK}node/${FORK}/ImpleumTest
COINPORT=16271
COINRPCPORT=16272
COINAPIPORT=39222
}

function setGeneralVars() {
## set general variables
COINRUNCMD="sudo dotnet ./impleum.impleumFullNodeD.dll ${NETWORK} -datadir=/home/${NODE_USER}/.${FORK}node -maxblkmem=2 \${stakeparams}"
COINDSRC=/home/${NODE_USER}/code/src/Impleum.ImpleumD
COINGITHUB=https://github.com/impleum/ImpleumBitcoinFullNode.git
CONF=release
COINDAEMON=${FORK}d
COINCONFIG=${FORK}.conf
COINSTARTUP=/home/${NODE_USER}/${FORK}d
COINDLOC=/home/${NODE_USER}/${FORK}node
COINSERVICELOC=/etc/systemd/system/
COINSERVICENAME=${COINDAEMON}@${NODE_USER}
SWAPSIZE="1024" ## =1GB
}