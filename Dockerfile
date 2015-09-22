FROM buildpack-deps:micro
MAINTAINER uochan

ENV OTP_VERSION 18.0
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq \
    && apt-get install -y \
       build-essential \
       libncurses5-dev \
       openssl libssl-dev \
       locales

RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src
RUN wget http://www.erlang.org/download/otp_src_${OTP_VERSION}.tar.gz \
    && tar xvf otp_src_${OTP_VERSION}.tar.gz \
    && rm -rf otp_src_${OTP_VERSION}.tar.gz
WORKDIR /usr/local/src/otp_src_${OTP_VERSION}
RUN ./configure && make && make install

RUN echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && update-locale LANG=ja_JP.UTF-8
ENV LC_ALL C
ENV LC_ALL ja_JP.UTF-8

WORKDIR /usr/local
RUN git clone --depth 1 https://github.com/elixir-lang/elixir.git \
    && cd elixir \
    && make clean test ; exit 0
ENV PATH $PATH:/usr/local/elixir/bin

RUN mix local.hex --force \
    && mix local.rebar --force
