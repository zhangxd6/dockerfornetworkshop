FROM docker:dind

# Install .NET
ENV DOTNET_VERSION=5.0.10

RUN wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-musl-x64.tar.gz \
    && dotnet_sha512='d0ca3aef030a575daf09fcfb8abc3056dcb6567da661c8c18162882a8ae9af3de013053ada82e0ee3042a806cb10dd234f59aa5bbdcd229d5ead582464ad4154' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm dotnet.tar.gz

# Install ASP.NET Core
ENV ASPNET_VERSION=5.0.10

RUN wget -O aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$ASPNET_VERSION/aspnetcore-runtime-$ASPNET_VERSION-linux-musl-x64.tar.gz \
    && aspnetcore_sha512='0e995f892eca8893e211e9965b2378da263233ad92c5f32624c4dfbdaec1ad7b8b3c5496a27a81891b321eb12d7a08445cd86832e219584a31cad4baef18b9d2' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz -C /usr/share/dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # SDK version
    DOTNET_SDK_VERSION=5.0.401 \
    # Disable the invariant mode (set in base image)
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Alpine-3.14

RUN apk add --no-cache \
        curl \
        icu-libs \
        git \
        bash \
        libstdc++\
        gcompat \
        sudo

# Install .NET SDK
RUN wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-musl-x64.tar.gz \
    && dotnet_sha512='a2077f4d1c9da9c69453b771cd239bad27f62379402cc5e1c74a1f2a960fd55efc85cc15eafbac11f17ea975895ce107fab4bbfc49880a0a14791e8ac13ca2de' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./packs ./sdk ./templates ./LICENSE.txt ./ThirdPartyNotices.txt \
    && rm dotnet.tar.gz \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

# Install PowerShell global tool
RUN powershell_version=7.1.4 \
    && wget -O PowerShell.Linux.Alpine.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.Alpine.$powershell_version.nupkg \
    && powershell_sha512='61bc34d4f67ee73cb137ebf96ae3a1f8e978a32acfc02115f80c47277e553f1ce68cb41c1ad2b15ce0ed75a085f7f70dba237c09084855ff420e9a09f481b672' \
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


ARG RELEASE_TAG=openvscode-server-v1.60.2

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

ENV HOME=/home/workspace
ENV EDITOR=code
ENV VISUAL=code
ENV GIT_EDITOR="code --wait"
ENV OPENVSCODE_SERVER_ROOT=/home/${RELEASE_TAG}-linux-x64

COPY . .
EXPOSE 3000

#ENTRYPOINT ${OPENVSCODE_SERVER_ROOT}/server.sh
ENTRYPOINT [ "./startup.sh" ]