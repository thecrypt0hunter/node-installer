function setMainVars() {
## set network dependent variables
NETWORK=""
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.${FORK}node/${FORK}/x42Main
COINPORT=52342
COINRPCPORT=52343
COINAPIPORT=42220
}

function setTestVars() {
## set network dependent variables
NETWORK="-testnet"
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.${FORK}node/${FORK}/x42Test
COINPORT=62342
COINRPCPORT=62343
COINAPIPORT=42221
}

function setGeneralVars() {
## set general variables
COINRUNCMD="sudo dotnet ./x42.x42D.dll ${NETWORK} -datadir=/home/${NODE_USER}/.${FORK}node -maxblkmem=2 \${stakeparams}"
COINGITHUB=https://github.com/x42protocol/x42-BlockCore.git
COINDSRC=/home/${NODE_USER}/code/X42-FullNode/src/x42.x42D
CONF=release
COINDAEMON=${FORK}d
COINCONFIG=${FORK}.conf
COINSTARTUP=/home/${NODE_USER}/${FORK}d
COINDLOC=/home/${NODE_USER}/${FORK}node
COINSERVICELOC=/etc/systemd/system/
COINSERVICENAME=${COINDAEMON}@${NODE_USER}
SWAPSIZE="1024" ## =1GB
}