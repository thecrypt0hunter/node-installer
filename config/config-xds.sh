function setMainVars() {
## set network dependent variables
NETWORK=""
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.fullnoderoot/${FORK}/MainNet
COINPORT=46660
COINRPCPORT=48333
COINAPIPORT=48334
}

function setTestVars() {
## set network dependent variables
NETWORK="-testnet"
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.fullnoderoot/${FORK}/TestNet
COINPORT=46660
COINRPCPORT=48333
COINAPIPORT=48334
}

function setGeneralVars() {
## set general variables
COINRUNCMD="dotnet Daemon.dll ${NETWORK} -datadir=/home/${NODE_USER}/.fullnoderoot -maxblkmem=2 \${stakeparams}"
COINGITHUB=https://github.com/sonofsatoshi2020/xds.git
COINDSRC=/home/${NODE_USER}/code/src/daemon
CONF=release
COINDAEMON=${FORK}d
COINCONFIG=${FORK}.conf
COINSTARTUP=/home/${NODE_USER}/${FORK}d
COINDLOC=/home/${NODE_USER}/${FORK}node
COINSERVICELOC=/etc/systemd/system/
COINSERVICENAME=${COINDAEMON}@${NODE_USER}
SWAPSIZE="1024" ## =1GB
}