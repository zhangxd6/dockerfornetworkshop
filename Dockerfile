FROM docker:dind

# Install .NET
ENV DOTNET_VERSION=6.0.0

RUN wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && dotnet_sha512='1b6b5346426e53afd7ea4344e79b29a903b36bb1dfbc88d68f3a17a88b42ca9563d8af7c086cc0d455cb344c7d11896d585667c76e424b2e2760e7421018c1c7' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm dotnet.tar.gz

# Install ASP.NET Core
ENV ASPNET_VERSION=6.0.0

RUN wget -O aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-musl-x64.tar.gz \
    && aspnetcore_sha512='7273e40bc301923052e2176e8321462790e3b654688f473dc7cac613ad27f181190dabbba79929f983424c9b5b5085b8d4be9cc9f0f1d0197f58ef3bb9aa8638' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz -C /usr/share/dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=6.0.100 \
    # Disable the invariant mode (set in base image)
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Unset Logging__Console__FormatterName from aspnet base image
    Logging__Console__FormatterName= \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Alpine-3.14

RUN apk add --no-cache \
        curl \
        icu-libs \
        git\
        bash \
        libstdc++\
        gcompat \
        sudo

# Install .NET SDK
RUN wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-musl-x64.tar.gz \
    && dotnet_sha512='428082c31fd588b12fd34aeae965a58bf1c26b0282184ae5267a85cdadc503f667c7c00e8641892c97fbd5ef26a38a605b683b45a0fef2da302ec7f921cf64fe' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./packs ./sdk ./sdk-manifests ./templates ./LICENSE.txt ./ThirdPartyNotices.txt \
    && rm dotnet.tar.gz \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

# Install PowerShell global tool
RUN powershell_version=7.2.0 \
    && wget -O PowerShell.Linux.Alpine.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.Alpine.$powershell_version.nupkg \
    && powershell_sha512='671e1e7e5a8c1e9986ca6f5bf13f52898f4e812bc8fdaa9e406df6eb3ad704acdff06d493d97525678036441282ce4eb3eaaa0094232cee16507d3259b1321ca' \
    && echo "$powershell_sha512  PowerShell.Linux.Alpine.$powershell_version.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.Alpine \
    && dotnet nuget locals all --clear \
    && rm PowerShell.Linux.Alpine.$powershell_version.nupkg \
    && chmod 755 /usr/share/powershell/pwsh \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm \
    # Add ncurses-terminfo-base to resolve psreadline dependency
    && apk add --no-cache ncurses-terminfo-base


ARG RELEASE_TAG=openvscode-server-v1.62.0

ARG USERNAME=openvscode-server
ARG USER_UID=1000
ARG USER_GID=$USER_UID


WORKDIR /home/

# Downloading the latest VSC Server release and extracting the release archive
RUN wget https://github.com/gitpod-io/openvscode-server/releases/download/${RELEASE_TAG}/${RELEASE_TAG}-linux-x64.tar.gz && \
    tar -xzf ${RELEASE_TAG}-linux-x64.tar.gz && \
    rm -f ${RELEASE_TAG}-linux-x64.tar.gz



# Creating the user and usergroup
RUN addgroup --gid $USER_GID $USERNAME &&\
    adduser -u $USER_UID -G $USERNAME  -D $USERNAME  &&\
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME  &&\
    chmod 0440 /etc/sudoers.d/$USERNAME &&\
    addgroup --gid 1001  docker &&\
    addgroup $USERNAME docker 
   

RUN chmod g+rw /home && \ 
    mkdir -p /home/workspace && \
    chown -R $USERNAME:$USERNAME /home/workspace && \
    chown -R $USERNAME:$USERNAME /home/${RELEASE_TAG}-linux-x64 



RUN wget https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64 &&\
    mv docker-compose-linux-x86_64 docker-compose &&\
    chmod +x docker-compose &&\
    mkdir -p /home/workspace/.docker/cli-plugins &&\
    mv docker-compose /home/workspace/.docker/cli-plugins

USER $USERNAME

WORKDIR /home/workspace/
COPY . .
# RUN chmod +x ./startup.sh

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 
ENV HOME=/home/workspace
ENV EDITOR=code
ENV VISUAL=code
ENV GIT_EDITOR="code --wait"
ENV OPENVSCODE_SERVER_ROOT=/home/${RELEASE_TAG}-linux-x64

RUN mkdir -p .docker/cli-plugins &&\
    wget -O docker-compose  https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64 &&\
    chmod +x docker-compose
# RUN  ls &&\
#    mv docker-compose .docker/cli-plugins && 
    

EXPOSE 3000

#ENTRYPOINT ${OPENVSCODE_SERVER_ROOT}/server.sh
ENTRYPOINT [ "./startup.sh" ]