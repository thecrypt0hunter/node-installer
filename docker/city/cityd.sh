#!/bin/bash
export DOTNET_CLI_TELEMETRY_OPTOUT=1
STAKEPARAMS=""
if [ -f /var/secure/credentials.sh ]; then
    source /var/secure/credentials.sh
    STAKEPARAMS=\"-stake -walletname=\${STAKINGNAME} -walletpassword=\${STAKINGPASSWORD}\"
fi
cd /root/citynode
exec dotnet ./City.Chain.dll -datadir=/root/.citychain -maxblkmem=1 -txindex=1 ${STAKEPARAMS}