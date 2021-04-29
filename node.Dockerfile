FROM ubuntu:16.04

ARG version=
COPY ./common.sh /scripts/
COPY ./run-node.sh /scripts/

SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates software-properties-common && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88 && \
    echo "deb https://repo.sovrin.org/deb xenial stable" >> /etc/apt/sources.list && \
    apt-get update && \
    if [ -z "${version}" ]; then \
      list="indy-node"; \
    else \
      apt-cache showpkg indy-node > /tmp/pkg; \
      list="indy-node=${version}"; \
      pkgs=( $(grep "${version} - " /tmp/pkg | sed "s/${version} - //" | sed 's/([0-9]\{0,1\}//g' | sed 's/)//g') ); \
      for (( i=0; i<${#pkgs[*]}; i=${i}+2 )); do \
        if [ "${pkgs[$(( ${i}+1 ))]}" = "null" ]; then \
          list="${list} ${pkgs[${i}]}"; \
        else list="${list} ${pkgs[${i}]}=${pkgs[$(( ${i}+1 ))]}"; \
        fi; \
        if [ "${pkgs[${i}]}" = "indy-plenum" ]; then \
          plenumVer="${pkgs[$(( ${i}+1 ))]}"; \
          apt-cache showpkg indy-plenum > /tmp/plenumPkg; \
          subpkgs=( $(grep "${plenumVer} - " /tmp/plenumPkg | sed "s/${plenumVer} - //" | sed 's/([0-9]\{0,1\}//g' | sed 's/)//g') ); \
          for (( i=0; i<${#subpkgs[*]}; i=${i}+2 )); do \
            if [ "${subpkgs[$(( ${i}+1 ))]}" = "null" -o "${subpkgs[${i}]}" = "python3-pip" ]; then \
              list="${list} ${subpkgs[${i}]}"; \
            else list="${list} ${subpkgs[${i}]}=${subpkgs[$(( ${i}+1 ))]}"; \
            fi; \
          done; \
        fi; \
      done; \
    fi && \
    echo ${list} && \
    apt-get install -y --no-install-recommends ${list} && \
    apt-get clean && \
    rm -f /tmp/pkg && \
    chmod +x /scripts/*.sh

VOLUME /var/lib/indy
EXPOSE 9701 9702

ENTRYPOINT ["/scripts/run-node.sh"]