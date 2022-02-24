# builder
FROM alpine:latest as builder

ARG BDEPS="git build-base cmake automake libintl autoconf libtool pkgconf coreutils curl unzip gettext-tiny-dev"
ARG TARGET=nightly
ARG BTYPE=RelWithDebInfo

RUN apk add --no-cache ${BDEPS} && \
    git clone https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    git switch --create ${TARGET} && \
    git fetch --force && \
    make CMAKE_BUILD_TYPE=${BYPE} && \
    make CMAKE_INSTALL_PREFIX=/usr/local install

# main
FROM alpine:latest

COPY --from=builder /usr/local/ /usr/local/

COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/
COPY --from=builder /usr/lib/libgcc_s.so.1 /usr/lib/
COPY --from=builder /usr/lib/libintl.so.8 /usr/lib/

RUN mkdir /root/.config/
COPY ./nvim/ /root/.config/

# ARG RDEPS0="musl libgcc libintl libluv libtermkey libuv libvterm luajit msgpack-c tree-sitter unibilium nodejs ripgrep fd"
# ARG RDEPS1="tree-sitter unibilium nodejs ripgrep fd"
# RUN apk add --no-cache ${RDEPS0} ${RDEPS1}

VOLUME "/mnt/workdir/"

CMD ["/usr/local/bin/nvim"]
