FROM ruby:3.3

# Instala dependências do sistema
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    npm \
    build-essential \
    libpq-dev \
    sqlite3 \
    libsqlite3-dev \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Instala a versão mais recente do Rails
RUN gem install rails bundler

# Cria usuário vscode para desenvolvimento
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Configura permissões do bundle
RUN mkdir -p /usr/local/bundle && \
    chown -R $USERNAME:$USERNAME /usr/local/bundle

# Muda para usuário vscode
USER $USERNAME

# Expõe porta do Rails
EXPOSE 3000

# Comando padrão
CMD ["bash"]

