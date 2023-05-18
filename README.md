# Arcadas MacBook Environment

## System Preferences

Open a new terminal and run the .macos file and reboot.

Check and set:
- Tap click, Natural scroll
- Keyboard lang, Desktop shortcut
- Background
- Battery - Display turn off
- Accessibility - Reduce Transparency
- Dock position left (remove unnecessary items, auto hide)
- Menubar - Battery - Show percentage, Clock - Show seconds
- Sound - Play sound on startup.
- Set up Internet Accounts.

## Apps

Open Safari and download Chrome. Sign in (copy password from Password app).

Download and install:
- iStat, Dropbox, Slack, iTerm2, MonitorControl Lite
- Docker, VSCode, Sequel Pro, Insomnia, Nodejs

VSCode: Open the Command Palette (Cmd+Shift+P) and type 'shell command' to find the Shell Command: Install 'code' command in PATH command.

Sign in to VSCode with GitHub account to sync.

## iTerm2

Preferences:
- Preferences -> Profiles -> Window -> Style -> Fullscreen

Change shell to bash

```sh
chsh -s /bin/bash
```

Note: Restart and copy all bash files.

Install brew (https://brew.sh/).

```sh
brew install git vim mc wget openssh nvm awscli
```

## SSH and GitHub

```sh
# Set git globals
git config --global user.name "<firstname lastname>"
git config --global user.email "<e-mail>"
# Generate SSH key and set it to GitHub
ssh-keygen -t rsa -b 4096 -C "<email@address.com>"
# Clone this repo
mkdir ~/git
cd ~/git
git clone git@github.com:arcadas/arcadas-mac.git
```

## MacOS file

```sh
chmod +x .macos
./.macos
```

## Bash and other dotfiles

```sh
cd
copy ~/git/arcadas-mac/.profile .
copy ~/git/arcadas-mac/*bash* .
copy ~/git/arcadas-mac/.vimrc .
# Restart iTerm
```

## Hosts

```sh
sudo vim /etc/hosts
```

## Set up server connections

```sh
vim .bash_aliases_aws
# Copy pem files into home directory and setup permissions
chmod 400 /Users/<username>/<path-to-pem>/<server-name>.pem
# Add pem to SSH config
cp ~/git/arcadas-mac/.ssh/config ~/.ssh/
vim ~/.ssh/config
```

## Nginx Reverse Proxy

```sh
# Create a custom network
docker network create proxy
# Start proxy
cd ~/git/arcadas-mac/nginx-proxy
docker-compose up -d
```

For nginx-proxy to discover our services, we have to put services to the same network (proxy). In docker-compose.yml definition we have to add the following definitions:

```sh
version: '2'

services:

  <service>:
    image: <image>
    environment:
      - VIRTUAL_HOST=<service>.arcadas.com
      - VIRTUAL_PORT=8080
    networks:
      - proxy

networks:
  proxy:
    external: true
```

## Certificates for Development

Setup SSL Certificate by OpenSSL.

Documentation: [Certificates for localhost](https://letsencrypt.org/docs/certificates-for-localhost/)

```sh
# Generate certificate
# !!! Change localhost to domain name (e.g.: transmission.arcadas.com)
openssl req -x509 -out localhost.crt -keyout localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

# Move into .ssh folder
# Change loclahost to domain name
mv localhost.* ~/.ssh/
```

Import certificate into your client OS, for example mac:

Change localhost name to domain name. \
`Keychain Access -> File -> Import Items... -> localhost.crt`

Open certificate and select `Always Trust`.
