function setMainVars() {
## set network dependent variables
NETWORK=""
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.${FORK}node/${FORK}/ObsidianXMain
COINPORT=46660
COINRPCPORT=46661
COINAPIPORT=47221
}

function setTestVars() {
## set network dependent variables
NETWORK="-testnet"
NODE_USER=${FORK}${NETWORK}
COINCORE=/home/${NODE_USER}/.${FORK}node/${FORK}/ObsidianXTest
COINPORT=46660
COINRPCPORT=46661
COINAPIPORT=47221
}

function setGeneralVars() {
## set general variables
COINRUNCMD="sudo dotnet Obsidian.OxD.dll ${NETWORK} -datadir=/home/${NODE_USER}/.${FORK}chain -maxblkmem=2 -hdwallet \${stakeparams}"
COINGITHUB=https://github.com/obsidianproject/Obsidian-StratisNode.git
COINDSRC=/home/${NODE_USER}/code/src/Obsidian.OxD
CONF=release
COINDAEMON=${FORK}d
COINCONFIG=${FORK}.conf
COINSTARTUP=/home/${NODE_USER}/${FORK}d
COINDLOC=/home/${NODE_USER}/${FORK}node
COINSERVICELOC=/etc/systemd/system/
COINSERVICENAME=${COINDAEMON}@${NODE_USER}
SWAPSIZE="1024" ## =1GB
}