FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build

## Compile wallet
RUN git clone --branch v1.0.17 https://github.com/CityChainFoundation/city-chain.git \
    && cd city-chain/src/City.Chain \
	&& dotnet publish -c "release" -r "linux-x64" -v m -o "/root/citynode" 

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS runtime
WORKDIR /root/citynode
COPY --from=build /root/citynode /root/citynode

## Setup startup files
WORKDIR /root/.citychain/city/CityMain/
COPY city.conf /root/.citychain/city/CityMain/city.conf
COPY cityd.sh /usr/bin/cityd.sh
RUN chmod +x /usr/bin/cityd.sh

## Open ports
EXPOSE 4333 4334 4335

STOPSIGNAL SIGINT
ENTRYPOINT ["/usr/bin/cityd.sh"]
