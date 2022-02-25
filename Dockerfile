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
COPY ./nvim /root/.config/nvim/

ARG RDEPS="git nodejs"

RUN apk add --no-cache ${RDEPS}

COPY ./add_plugin /usr/local/bin/
RUN chmod +x /usr/local/bin/add_plugin

RUN add_plugin "wbthomason/packer.nvim"
RUN add_plugin "windwp/nvim-autopairs"
RUN add_plugin "neovim/nvim-lspconfig"
RUN add_plugin "williamboman/nvim-lsp-installer"
RUN add_plugin "hrsh7th/cmp-nvim-lsp"
RUN add_plugin "hrsh7th/cmp-buffer"
RUN add_plugin "hrsh7th/nvim-cmp"
RUN add_plugin "saadparwaiz1/cmp_luasnip"
RUN add_plugin "L3MON4D3/LuaSnip"
RUN add_plugin "b3nj5m1n/kommentary"
RUN add_plugin "mhartington/formatter.nvim"
RUN add_plugin "nvim-treesitter/nvim-treesitter"
RUN add_plugin "sheerun/vim-polyglot"
RUN add_plugin "norcalli/nvim-colorizer.lua"
RUN add_plugin "vimwiki/vimwiki"
RUN add_plugin "nvim-telescope/telescope.nvim"
RUN add_plugin "nvim-lua/plenary.nvim"
RUN add_plugin "hoob3rt/lualine.nvim"
RUN add_plugin "kyazdani42/nvim-web-devicons"
RUN add_plugin "akinsho/bufferline.nvim"
RUN add_plugin "kyazdani42/nvim-web-devicons"
RUN add_plugin "famiu/bufdelete.nvim"
RUN add_plugin "github/copilot.vim"
RUN add_plugin "fladson/vim-kitty"
RUN add_plugin "cocatrip/idjo.nvim"
RUN add_plugin "tpope/vim-fugitive"
RUN add_plugin "ellisonleao/glow.nvim"
RUN add_plugin "tpope/vim-surround"

VOLUME "/mnt/workdir/"

CMD ["/usr/local/bin/nvim"]
