#!/bin/bash
#bash <( curl -s https://raw.githubusercontent.com/thecrypt0hunter/node-installer/master/install-strax-hot-node.sh )

NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
PURPLE='\033[01;35m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

function setVars() {
## set network dependent variables
NODE_USER=strax
COINPORT=17105
COINRPCPORT=17104
COINAPIPORT=17103

## set general variables
DATE_STAMP="$(date +%y-%m-%d-%s)"
OS_VER="Ubuntu*"
ARCH="linux-x64"
DOTNETVER="3.1.102"
COINRUNCMD="dotnet ./Stratis.StraxD.dll -agentprefix=trustaking -datadir=/home/${NODE_USER}/.${NODE_USER}node -maxblkmem=2 \${stakeparams} \${rpcparams}"
COINGITHUB=https://github.com/stratisproject/StratisFullNode.git
COINDSRC=/home/${NODE_USER}/code/src/Stratis.StraxD
CONF=release
#COINBIN=https://github.com/SolarisPlatform/SolarisBitcoinFullNode/releases/download/v3.0.0.0/solaris-daemon-3.0.0.0-linux64.tar.gz
COINDAEMON=${NODE_USER}d
COINSTARTUP=/home/${NODE_USER}/${NODE_USER}d
COINDLOC=/home/${NODE_USER}/${NODE_USER}node
COINSERVICELOC=/etc/systemd/system/
COINSERVICENAME=${COINDAEMON}@${NODE_USER}
SWAPSIZE="1024" ## =1GB

SCRIPT_LOGFILE="/tmp/${NODE_USER}_${DATE_STAMP}_output.log"
}

function check_root() {
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}* Sorry, this script needs to be run as root. Do \"sudo su root\" and then re-run this script${NONE}"
    exit 1
    echo -e "${NONE}${GREEN}* All Good!${NONE}";
fi
}

function create_user() {
    echo
    echo "* Checking for user & add if required. Please wait..."
    # our new mnode unpriv user acc is added
    if id "${NODE_USER}" >/dev/null 2>&1; then
        echo "user exists already, do nothing"
    else
        echo -e "${NONE}${GREEN}* Adding new system user ${NODE_USER}${NONE}"
        adduser --disabled-password --gecos "" ${NODE_USER} &>> ${SCRIPT_LOGFILE}
        echo -e "${NODE_USER} ALL=(ALL) NOPASSWD:ALL" &>> /etc/sudoers
    fi
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

function set_permissions() {
    chown -R ${NODE_USER}:${NODE_USER} ${COINSTARTUP} ${COINDLOC} &>> ${SCRIPT_LOGFILE}
    # make group permissions same as user, so vps-user can be added to node group
    chmod -R g=u ${COINSTARTUP} ${COINDLOC} &>> ${SCRIPT_LOGFILE}
}

function checkOSVersion() {
   echo
   echo "* Checking OS version..."
    if [[ `cat /etc/issue.net`  == ${OS_VER} ]]; then
        echo -e "${GREEN}* You are running `cat /etc/issue.net` . Setup will continue.${NONE}";
    else
        echo -e "${RED}* You are not running ${OS_VER}. You are running `cat /etc/issue.net` ${NONE}";
        echo && echo "Installation cancelled" && echo;
        exit;
    fi
}

function updateAndUpgrade() {
    echo
    echo "* Running update and upgrade. Please wait..."
    apt-get update &>> ${SCRIPT_LOGFILE}
    DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" dist-upgrade &>> ${SCRIPT_LOGFILE}
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y &>> ${SCRIPT_LOGFILE}
    echo -e "${GREEN}* Done${NONE}";
}

function setupSwap() {
#check if swap is available
    echo
    echo "* Creating Swap File. Please wait..."
    if [ $(free | awk '/^Swap:/ {exit !$2}') ] || [ ! -f "/var/node_swap.img" ];then
    echo -e "${GREEN}* No proper swap, creating it.${NONE}";
    # needed because ant servers are ants
    rm -f /var/node_swap.img &>> ${SCRIPT_LOGFILE}
    dd if=/dev/zero of=/var/node_swap.img bs=1024k count=${SWAPSIZE} &>> ${SCRIPT_LOGFILE}
    chmod 0600 /var/node_swap.img &>> ${SCRIPT_LOGFILE}
    mkswap /var/node_swap.img &>> ${SCRIPT_LOGFILE}
    swapon /var/node_swap.img &>> ${SCRIPT_LOGFILE}
    echo '/var/node_swap.img none swap sw 0 0' | tee -a /etc/fstab &>> ${SCRIPT_LOGFILE}
    echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf &>> ${SCRIPT_LOGFILE}
    echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf &>> ${SCRIPT_LOGFILE}
else
    echo -e "${GREEN}* All good, we have a swap.${NONE}";
fi
}

function installFail2Ban() {
    echo
    echo -e "* Installing fail2ban. Please wait..."
    apt-get -y install fail2ban &>> ${SCRIPT_LOGFILE}
    systemctl enable fail2ban &>> ${SCRIPT_LOGFILE}
    systemctl start fail2ban &>> ${SCRIPT_LOGFILE}
    # Add Fail2Ban memory hack if needed
    if ! grep -q "ulimit -s 256" /etc/default/fail2ban; then
       echo "ulimit -s 256" | tee -a /etc/default/fail2ban &>> ${SCRIPT_LOGFILE}
       systemctl restart fail2ban &>> ${SCRIPT_LOGFILE}
    fi
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

function installFirewall() {
    echo
    echo -e "* Installing UFW. Please wait..."
    apt-get -y install ufw &>> ${SCRIPT_LOGFILE}
    ufw allow OpenSSH &>> ${SCRIPT_LOGFILE}
    ufw allow $COINPORT/tcp &>> ${SCRIPT_LOGFILE}
    ufw allow $COINRPCPORT/tcp &>> ${SCRIPT_LOGFILE}
    if [ "${DNSPORT}" != "" ] ; then
        ufw allow ${DNSPORT}/tcp &>> ${SCRIPT_LOGFILE}
        ufw allow ${DNSPORT}/udp &>> ${SCRIPT_LOGFILE}
    fi
    echo "y" | ufw enable &>> ${SCRIPT_LOGFILE}
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

function installDependencies() {
    echo
    echo -e "* Installing dependencies. Please wait..."
    timedatectl set-ntp no &>> ${SCRIPT_LOGFILE}
    apt-get install git ntp nano wget curl software-properties-common libc6 libgcc1 libgssapi-krb5-2 libstdc++6 zlib1g -qy &>> ${SCRIPT_LOGFILE}
    if [[ -r /etc/os-release ]]; then
         . /etc/os-release
         if [[ "${VERSION_ID}" = "16.04" ]]; then
            apt-get install libicu55 libssl1.0.0 -qy &>> ${SCRIPT_LOGFILE}
         fi
         if [[ "${VERSION_ID}" = "18.04" ]]; then
            apt-get install libicu60 libssl1.1 -qy &>> ${SCRIPT_LOGFILE}
         fi
         if [[ "${VERSION_ID}" = "20.04" ]]; then
            apt-get install libicu66 libssl1.1 -qy &>> ${SCRIPT_LOGFILE}
         fi
         else
         echo -e "${NONE}${RED}* Version: ${VERSION_ID} not supported.${NONE}";
    fi
}

# function compileWallet() {
#     echo
#     echo -e "* Compiling wallet. Please wait, this might take a while to complete..."
#     rm -rf ${COINDLOC} &>> ${SCRIPT_LOGFILE}
#     mkdir -p ${COINDLOC} &>> ${SCRIPT_LOGFILE}
#     cd /home/${NODE_USER}/
#     wget --https-only -O coinbin.tar ${COINBIN} &>> ${SCRIPT_LOGFILE}
#     tar -zxf coinbin.tar -C ${COINDLOC} &>> ${SCRIPT_LOGFILE}
#     rm coinbin.tar &>> ${SCRIPT_LOGFILE}
#     echo -e "${NONE}${GREEN}* Done${NONE}";
# }

function compileWallet() {
    echo
    echo -e "* Compiling wallet. Please wait, this might take a while to complete..."
    if [ ! -d /home/${NODE_USER} ]; then 
        mkdir /home/${NODE_USER} 
    fi
    cd /home/${NODE_USER}/
    git clone ${COINGITHUB} code &>> ${SCRIPT_LOGFILE}
    cd /home/${NODE_USER}/code
    # Install the correct version of dotnet based on global.json not --version ${DOTNETVER} installs SDK not --runtime dotnet
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --jsonfile /home/${NODE_USER}/code/src/global.json --verbose &>> ${SCRIPT_LOGFILE}
    export DOTNET_ROOT=$HOME/.dotnet
    export PATH=$PATH:$HOME/.dotnet
    cd ${COINDSRC}
    dotnet publish -c ${CONF} -r ${ARCH} -v m -o ${COINDLOC} &>> ${SCRIPT_LOGFILE} ### compile & publish code
    rm -rf /home/${NODE_USER}/code &>> ${SCRIPT_LOGFILE} 	                       ### Remove source
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

function installWallet() {
    echo
    echo -e "* Installing wallet. Please wait..."
    cd /home/${NODE_USER}/
    echo -e "#!/bin/bash\nexport DOTNET_CLI_TELEMETRY_OPTOUT=1\nexport LANG=en_US.UTF-8\nif [ -f /var/secure/credentials.sh ]; then\nsource /var/secure/credentials.sh\nstakeparams=\"-stake -walletname=\${STAKINGNAME} -walletpassword=\${STAKINGPASSWORD}\"\nfi\ncd $COINDLOC\n$COINRUNCMD" > ${COINSTARTUP}
    echo -e "[Unit]\nDescription=${COINDAEMON}\nAfter=network-online.target\n\n[Service]\nType=simple\nUser=${NODE_USER}\nGroup=${NODE_USER}\nExecStart=${COINSTARTUP}\nRestart=always\nRestartSec=5\nPrivateTmp=true\nTimeoutStopSec=60s\nTimeoutStartSec=5s\nStartLimitInterval=120s\nStartLimitBurst=15\n\n[Install]\nWantedBy=multi-user.target" >${COINSERVICENAME}.service
    mv $COINSERVICENAME.service ${COINSERVICELOC} &>> ${SCRIPT_LOGFILE}
    chmod 777 ${COINSTARTUP} &>> ${SCRIPT_LOGFILE}
    systemctl --system daemon-reload &>> ${SCRIPT_LOGFILE}
    systemctl enable ${COINSERVICENAME} &>> ${SCRIPT_LOGFILE}
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

function startWallet() {
    echo
    echo -e "* Starting wallet daemon...${COINSERVICENAME}"
    service ${COINSERVICENAME} start &>> ${SCRIPT_LOGFILE}
    sleep 10
    echo -e "${GREEN}* Done${NONE}";
}
function stopWallet() {
    echo
    echo -e "* Stopping wallet daemon...${COINSERVICENAME}"
    service ${COINSERVICENAME} stop &>> ${SCRIPT_LOGFILE}
    sleep 2
    echo -e "${GREEN}* Done${NONE}";
}

function installUnattendedUpgrades() {
    echo
    echo "* Installing Unattended Upgrades..."
    apt install unattended-upgrades -y &>> ${SCRIPT_LOGFILE}
    sleep 3
    sh -c 'echo "Unattended-Upgrade::Allowed-Origins {" >> /etc/apt/apt.conf.d/50unattended-upgrades'
    sh -c 'echo "        \"\${distro_id}:\${distro_codename}\";" >> /etc/apt/apt.conf.d/50unattended-upgrades'
    sh -c 'echo "        \"\${distro_id}:\${distro_codename}-security\";}" >> /etc/apt/apt.conf.d/50unattended-upgrades'
    sh -c 'echo "APT::Periodic::AutocleanInterval \"7\";" >> /etc/apt/apt.conf.d/20auto-upgrades'
    sh -c 'echo "APT::Periodic::Unattended-Upgrade \"1\";" >> /etc/apt/apt.conf.d/20auto-upgrades'
    cat /etc/apt/apt.conf.d/50unattended-upgrades &>> ${SCRIPT_LOGFILE}
    cat /etc/apt/apt.conf.d/20auto-upgrades &>> ${SCRIPT_LOGFILE}
    echo -e "${GREEN}* Done${NONE}";
}

function displayServiceStatus() {
	echo
	echo
	on="${GREEN}ACTIVE${NONE}"
	off="${RED}OFFLINE${NONE}"

	if systemctl is-active --quiet ${COINSERVICENAME}; then echo -e "Service: ${on}"; else echo -e "Service: ${off}"; fi
}

function installHotWallet() {
######## Get some information from the user about the wallet ############
echo
echo -e "${RED}${BOLD}#############################################################################${NONE}"
echo -e "${RED}${BOLD}##################### REMOTE WALLET - COLD STAKING SETUP ####################${NONE}"
echo -e "${RED}${BOLD}#############################################################################${NONE}"
echo
echo -e "Please enter some details about your hot wallet (that will on used for staking)"
echo 
read -p "Wallet name: " HotWalletName
read -p "Password: " HotWalletPassword
read -p "Passphrase: " HotWalletPassphrase
echo 

##### Setup the hot wallet ########

echo -e "*Creating your Hot wallet ... please wait."

### grab a 12 word mneumonic

HotWalletSecretWords=$(sed -e 's/^"//' -e 's/"$//' <<<$(curl -sX GET "http://localhost:${COINAPIPORT}/api/Wallet/mnemonic?language=english&wordCount=12" -H "accept: application/json")) 
curl -sX POST "http://localhost:${COINAPIPORT}/api/Wallet/create" -H  "accept: application/json" -H  "Content-Type: application/json-patch+json" -d "{  \"mnemonic\": \"${HotWalletSecretWords}\",  \"password\": \"${HotWalletPassword}\",  \"passphrase\": \"${HotWalletPassphrase}\",  \"name\": \"${HotWalletName}\"}" &>> ${SCRIPT_LOGFILE}

echo -e "${GREEN}Done.${NONE}"
echo

##### Convert the hot wallet to a cold staking wallet ######

echo -e "* Preparing your Hot wallet for cold staking   ... please wait."
curl -sX POST "http://localhost:${COINAPIPORT}/api/ColdStaking/cold-staking-account" -H  "accept: application/json" -H  "Content-Type: application/json-patch+json" -d "{  \"walletName\": \"$HotWalletName\",  \"walletPassword\": \"$HotWalletPassword\",  \"isColdWalletAccount\": false}" &>> ${SCRIPT_LOGFILE}

echo -e "${GREEN}Done.${NONE}"
echo

##### Get the Hot Wallet - Hot Address ######

echo -e "* Fetching your Hot wallet details for cold staking   ... please wait."

HotWalletColdStakingHotAddress=$(curl -sX GET "http://localhost:${COINAPIPORT}/api/ColdStaking/cold-staking-address?WalletName=$HotWalletName&IsColdWalletAddress=false" -H  "accept: application/json")
HotWalletColdStakingHotAddress=$(echo $HotWalletColdStakingHotAddress | cut -d \" -f4)

echo -e "${GREEN}Done.${NONE}"
echo

##### Start staking on the Hot Wallet ######

echo -e "* Preparing to start cold staking on your Hot wallet   ... please wait."

curl -sX POST "http://localhost:${COINAPIPORT}/api/Staking/startstaking" -H  "accept: application/json" -H  "Content-Type: application/json-patch+json" -d "{  \"password\": \"$HotWalletPassword\",  \"name\": \"$HotWalletName\"}" &>> ${SCRIPT_LOGFILE}
curl -X GET "http://localhost:${COINAPIPORT}/api/Staking/getstakinginfo" -H  "accept: application/json" &>> ${SCRIPT_LOGFILE}

##### Create and secure staking credentials ######

[ ! -d /var/secure ] && mkdir -p /var/secure 
touch /var/secure/credentials.sh
echo "STAKINGNAME=${HotWalletName}" &>> /var/secure/credentials.sh
echo "STAKINGPASSWORD=${HotWalletPassword}" &>> /var/secure/credentials.sh
chmod 0644 /var/secure/credentials.sh

echo -e "${GREEN}Done.${NONE}"
}


function displayHotWalletInfo() {

##### Display Hot Wallet to user ######
echo
echo -e "Here's all the Cold Staking Server details - keep this information safe offline:"
echo
echo -e "Name      	            :" $HotWalletName
echo -e "Password  	            :" $HotWalletPassword
echo -e "Passphrase	            :" $HotWalletPassphrase
echo -e "Mnemonic  	            :" $HotWalletSecretWords
echo -e "Cold staking address   :${RED}" $HotWalletColdStakingHotAddress
echo 
echo -e "${RED}IMPORTANT: NEVER SEND COINS TO YOUR HOT ADDRESS - THIS IS FOR COLD STAKING ONLY!!!${NONE}"
echo -e "${NONE}"
}

### Begin execution plan ####
clear
echo -e "${PURPLE}**********************************************************************${NONE}"
echo -e "${PURPLE}*  This script will install and configure your cold staking node.    *${NONE}"
echo -e "${PURPLE}**********************************************************************${NONE}"
echo -e "${BOLD}"

cd /home/${NODE_USER}/

    check_root
    setVars
    checkOSVersion
    echo
    echo -e "${BOLD} The log file can be monitored here: ${SCRIPT_LOGFILE}${NONE}"
    create_user
    setupSwap
    installFail2Ban
    installFirewall
    installDependencies
    compileWallet
    installWallet
    installUnattendedUpgrades
    startWallet
    set_permissions
    installHotWallet
    stopWallet
    startWallet
    displayServiceStatus
    displayHotWalletInfo

echo
echo -e "${GREEN} Installation complete. Check service with: journalctl -f -u ${COINSERVICENAME} ${NONE}"
echo -e "${GREEN} If you find this service valuable we appreciate any tips, please visit https://donations.trustaking.com ${NONE}"
echo -e "${GREEN} @trustaking(2020)${NONE}"
cd ~
