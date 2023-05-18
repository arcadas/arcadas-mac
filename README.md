# Arcadas MacBook Environment

- Log in with iCloud account
- Open Safari and download Chrome
- Log in into Chrome (MacOS Passwords)
- Download and check the [.macos](https://github.com/arcadas/arcadas-mac/blob/main/.macos) file
- Run it from the Terminal app

```sh
cd Downloads
chmod +x .macos
./.macos
```

Restart the computer

## System Settings

- Control Center
  - Bluetooth: Show in Menu Bar
  - Battery: Show Percentage
  - Clock - Clock Options...
    - Show Date: always
    - Display the time with secounds: on
- Privacy & Security
  - Screen Recording: add Chrome
- Desktop & Dock
  - Position on screen: Left
  - Menu Bar - Automatically hide...: Never
  - Show indicators for open applications: off
  - Show recent applications in Dock: off
  - Hot Corners...: disable all
- Lock Screen
  - Start Screen Saver when inactive: Never
- Accessibility
  - Display: Reduce transparency: on
- Keyboard
  - Keyboard Shortcuts
    - Mission Control: Mission Control: Switch to Desktop 1: CMD + Enter
  - Input Sources
    - Edit: Add (+): English (ABC)
- Trackpad
  - Force Click: off
  - Tap to click: off -> on
- Internet Accounts
  - Add accounts (MacOS Passwords)
    - Google: Calendars

Remove unnecessary app icons from dock bar.

Finder -> Preferences -> General tab -> New Finder windows show

Open a new Finder window and right-click “Recents” in the sidebar. In the menu that appears, select “Remove from Sidebar.”

## Applications

- Dropbox, iStat, iTerm2
- Slack, Zoom, Skype, Mail
- MonitorControl Lite, VLC
- Docker, VSCode, Sequel Ace, Insomnia

VSCode
- Sign in to VSCode with GitHub account to sync.
- Open the Command Palette (Cmd+Shift+P) and type 'shell command' to find the Shell Command: Install 'code' command in PATH command.
- Open terminal (CMD + T) and delete zsh shell and open settings.json and paste this settings

```json
"terminal.integrated.inheritEnv": false,
"terminal.integrated.defaultProfile.osx": "bash",
"terminal.integrated.profiles.osx": {
  "bash": {
    "path": "bash",
    "args": ["-l"]
  }
},
```

## iTerm2

Preferences:
- Preferences -> Profiles -> Window -> Style -> Fullscreen

Change shell to bash

```sh
chsh -s /bin/bash
```

Note: Restart iTerm2

Install brew (https://brew.sh/).

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/arcadas/.profile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Install CLI apps

```sh
brew install git vim mc wget openssh nvm awscli node php

# Install node and yarn
nvm install --lts
nvm use --lts
node -v
npm install --global yarn

# Install PHP
brew install php
# Install PHP 7.4 (unsupported)
brew tap shivammathur/php
brew install shivammathur/php/php@7.4
brew link php@7.4
```

Clone arcadas-mac repo

```sh
mkdir ~/git
cd ~/git
git clone https://github.com/arcadas/arcadas-mac.git

# Copy files into home
cd arcadas-mac
cp -a nginx-proxy/. ~/git/arcadas/nginx-proxy
cp .ssh/config ~/.ssh/
cp .vimrc ~/
cp .bash_* ~/
cp .profile ~/
source ~/.profile
```

Setup font size (14) in iTerm

## SSH and GitHub

```sh
# Set git globals
git config --global user.name "<firstname lastname>"
git config --global user.email "<e-mail>"

# Generate SSH key and set it to GitHub
ssh-keygen -t ed25519 -C "<email@address.com>"
eval "$(ssh-agent -s)"
# Copy public key to clipboard
cat ~/.ssh/id_ed25519.pub | pbcopy
```

Add key to GitHub: https://github.com/settings/keys

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
