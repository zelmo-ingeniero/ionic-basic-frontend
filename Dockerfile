FROM registry.access.redhat.com/ubi9/ubi-init
USER root
RUN yum install -y wget unzip iputils xz && yum clean all \
 && groupadd -g 9999 appuser \
 && useradd -m -u 9999 -d /home/appuser -g appuser appuser \
 && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Mexico/General /etc/localtime \
 && mkdir /nodejs && cd /nodejs \
 && wget https://nodejs.org/download/release/v22.13.1/node-v22.13.1-linux-x64.tar.gz \
 && tar -zxvf /nodejs/node-v22.13.1-linux-x64.tar.gz \
 && ln -s /nodejs/node-v22.13.1-linux-x64/bin/node /bin/node \
 && ln -s /nodejs/node-v22.13.1-linux-x64/bin/npm /bin/npm
WORKDIR /app
COPY . .
RUN npm install \
  && npm install -g @ionic/cli \
  && ln -s /nodejs/node-v22.13.1-linux-x64/bin/ionic /bin/ionic
RUN chown -R appuser:appuser /app /nodejs
USER appuser
CMD ["ionic", "serve", "--host", "0.0.0.0"]

