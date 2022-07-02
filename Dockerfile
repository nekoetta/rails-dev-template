FROM ruby:3.1.2-slim-bullseye

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends curl=7.74.0-1.3+deb11u1; \
    apt-get install -y --no-install-recommends make=4.3-4.1; \
    apt-get install -y --no-install-recommends gcc=4:10.2.1-1; \
    apt-get install -y --no-install-recommends libsqlite3-dev=3.34.1-3; \
    apt-get install -y --no-install-recommends libmariadb-dev=1:10.5.15-0+deb11u1; \
    apt-get install -y --no-install-recommends git=1:2.30.2-1; \
    apt-get install -y --no-install-recommends vim=2:8.2.2434-3+deb11u1; \
    gem update --system; \
    gem install --default bundler:2.3.17; \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash -; \
    apt-get install --no-install-recommends -y nodejs=16.15.1-deb-1nodesource1; \
    npm install --global npm@^8.13.2; \
    npm install --global yarn@^1.22.19; \
    rm -rf /var/lib/apt/lists/*

ARG UID=30000
ARG GID=30000
ARG USER=ruby
ARG GROUP=ruby

RUN groupadd -g ${GID} ${GROUP} && \
    useradd -l -m -s /bin/bash -u ${UID} -g ${GID} ${USER}

WORKDIR /home/${USER}
COPY --chown=${USER}:${GROUP} Gemfile* /home/${USER}/
RUN bundle install

USER ${USER}
COPY --chown=${USER}:${GROUP} . /home/${USER}/

EXPOSE 3000

COPY --chown=${USER}:${GROUP} --chmod=744 ./docker-entrypoint.sh /tmp
ENTRYPOINT [ "/tmp/docker-entrypoint.sh" ]
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
