FROM eclipse-temurin:21
ADD https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz /opt/coursier/coursier.gz
RUN gunzip /opt/coursier/coursier.gz && \
    mv /opt/coursier/coursier /usr/bin/cs && \
    chmod 755 /usr/bin/cs
