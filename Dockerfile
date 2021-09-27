FROM ruby:2.7.4

RUN echo "alias be='bundle exec'" >> /root/.bashrc

RUN apt-get update -qq \
    && apt-get install -y build-essential libsasl2-dev libldap2-dev ruby-ldap libpq-dev nodejs  vim \
    && mkdir /app

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && apt-get update -qq \
    && apt -y install postgresql-client-11

RUN echo 'alias be="bundle exec"' >> ~/.bashrc
RUN echo 'alias run_rspec="RAILS_ENV=test be rspec"' >> ~/.bashrc

WORKDIR /app
EXPOSE 3003
