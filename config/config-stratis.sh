function setMainVars() {
## set network dependent variables
NETWORK=""
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.${FORK}node/${FORK}/StratisMain
COINPORT=16178
COINRPCPORT=16174
COINAPIPORT=37221
}

function setTestVars() {
## set network dependent variables
NETWORK="-testnet"
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.${FORK}node/${FORK}/StratisTest
COINPORT=26178
COINRPCPORT=26174
COINAPIPORT=38221
}

function setGeneralVars() {
## set general variables
COINRUNCMD="sudo dotnet ./Stratis.StratisD.dll ${NETWORK} -datadir=/home/${NODE_USER}/.${FORK}node -maxblkmem=2 #-stake -walletname=\${STAKINGNAME} -walletpassword=\${STAKINGPASSWORD}"
COINGITHUB=https://github.com/stratisproject/StratisBitcoinFullNode.git
COINDSRC=/home/${NODE_USER}/code/src/Stratis.StratisD
CONF=release
COINDAEMON=${FORK}d
COINCONFIG=${FORK}.conf
COINSTARTUP=/home/${NODE_USER}/${FORK}d
COINDLOC=/home/${NODE_USER}/${FORK}node
COINSERVICELOC=/etc/systemd/system/
COINSERVICENAME=${COINDAEMON}@${NODE_USER}
SWAPSIZE="1024" ## =1GB
}