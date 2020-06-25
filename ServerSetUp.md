## Set up OpenSUSE 15.2 as Server

###Transactional Server (Read-only)

All System-wide installations have to be done by **root** as below. They are atomic, which means that either everything or nothing is installed. ANY errors will result in any attempted update being rolled back. 

 If successful, you will receive this message

>Please reboot your machine to activate the changes and avoid data loss.
>New default snapshot is #\<snapshot number\> (/.snapshots/\<snapshot number\>/snapshot).
>transactional-update finished

Otherwise, you will have to scroll up in the console output and find the error that needs to be fixed

```zsh
zypper refresh 
transactional-update up patch pkg in --download-in-advance -t pattern devel_C_C++ devel_basis devel_java devel_python3 devel_qt5 devel_rpm_build console
ldconfig
reboot


zypper refresh
transactional-update up patch pkg in --download-in-advance glibc-devel glibc-devel-static glibc-extra glibc-utils texlive autoconf autoconf213 automake libtool pkg-config cmake doxygen asciidoc ant ant-contrib ant-scripts libxslt-devel libxslt-tools xalan-j2-xsltc libxslt1 libxslt-tools libxslt-python java-11-openjdk-devel wget wget-lang freetype freetype-devel freetype-tools libfreetype6 libwmf-devel libwmf-tools libwmf-0_2-7 lcms2 liblcms2-devel liblcms2-doc libxml2-devel libxml2-tools perl-XML-LibXML python3-libxml2-python libyaml-devel libyaml-0-2 libpng16-devel libpng16-tools libtiff-devel libtiff5 libopenjp2-7 libopenjpeg1 libgif7 zlib-devel zlibrary-data zlibrary-devel libicu-devel libpango-1_0-0 libpangomm-2_44-1 libcairo2 libcairo-script-interpreter2 libcairo-gobject2 mozilla-nss mozilla-nss-certs mozilla-nss-devel mozilla-nss-sysinit mozilla-nss-tools pandoc MultiMarkdown-6 cmark discount pandoc texlive-context wkhtmltopdf maven maven-lib maven-local maven-shared gradle gradle-local javapackages-gradle mtree tree xclip vsftpd zsh
ldconfig
reboot

```

####Set up ftp

Done by **root**

```zsh
vi /etc/vsftpd.conf
#These are CHANGES that need to be made (changing, commenting, or adding settings)
#Make the service “listen”. IPV4 and disable IPV6.
listen=YES
#listen_ipv6=NO

#Allow writing
write_enable=YES

#Set port 21 (best for FileZilla default)
#connect_from_port_20=YES
listen_port=21

#Set up chroot list for FTP users
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list
```

#####Create chroot list and add users

```zsh
vi /etc/vsftpd.chroot_list
<user>
```

#####Add ports

```zsh
firewall-cmd --add-port=21/tcp --permanent
firewall-cmd --add-port=30000-30100/tcp --permanent
firewall-cmd --reload
# Will print "Success" if it works
```

#####Start server

```zsh
# Starts ftp server
systemctl start vsftpd
# Checks status
systemctl status vsftpd
```

###To set up zsh and set it as default user shell

This is still done by **root**

```zsh
chsh -s $(which zsh)
sudo vi /etc/passwd #make edits to change any /bin/bash to /bin/zsh
```

### Set up .zshrc

This is done as user or else it will be saved under \$HOME for **root** and not **user**

```zsh
vi ~/.zshrc #enter .zshrc with vim to edit (can also use emacs or nano as desired)
###################################
# Set up Paths and Linkers for $HOME/.local program install
###################################
export PATH=$HOME/.local/bin:$PATH
export C_INCLUDE_PATH=$HOME/.local/include
export CPLUS_INCLUDE_PATH=$HOME/.local/include
export LIBRARY_PATH=$HOME/.local/lib
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:$HOME/.local/lib64/pkgconfig
export LD_LIBRARY_PATH=$HOME/.local/lib: $HOME/.local/lib64 #crude/blunt force method
export MANPATH=$HOME/.local/share/man:$(manpath)
###################################
# Configurations for zsh
###################################
setopt AUTO_CD
setopt NO_CASE_GLOB
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt EXTENDED_HISTORY
SAVEHIST=5000
HISTSIZE=2000
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
setopt CORRECT
setopt CORRECT_ALL
autoload -Uz compinit && compinit
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
# Left Prompt
PROMPT='%n@%B%F{yellow}%d%f%b %# '
# Right Prompt set to tell me where I am within any Github Projects
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{magenta}(%b)%f%F{yellow}%r%f'
zstyle ':vcs_info:*' enable git
```

#### Set up git to clone via SSH rather than https

Done as **user** or else you cannot read RSA keys

```zsh
git config --global user.name "mrhunsaker"
git config --global user.email "hunsakerconsulting@gmail.com"
ssh-keygen -t rsa -b 4096 -C "hunsakerconsulting@gmail.com"
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_rsa
xclip -sel clip < $HOME/.ssh/id_rsa.p
#paste this into GitHub under Settings > SSH and GPG Keys
```

#### Set up to Install Programs into \$HOME/.local

**Step 1:** Done as **user** 

Verify that **user** has read/write permissions for their \$HOME directory (.home/\<user>)

```zsh
cd $HOME
ls -la
```

IF (and only IF) NO, then ask root to give permissions

```zsh
chown -R <user> /home/<user>
```

**Step 2:** Done as **user**

Set up basic directories in \$HOME/.local

```zsh
mkdir -p ~/.local/{bin,share/man,include,lib/pkgconfig,lib64,src,games,src}
```

####Environmental Variables for \$HOME/.local install (in \$HOME/.zshrc)

```zsh
export PATH=$HOME/.local/bin:$PATH
export C_INCLUDE_PATH=$HOME/.local/include
export CPLUS_INCLUDE_PATH=$HOME/.local/include
export LIBRARY_PATH=$HOME/.local/lib
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig
export LD_LIBRARY_PATH=$HOME/.local/lib #crude/blunt force method
export MANPATH=$HOME/.local/share/man:$(manpath)
```

#### Compile and Install patterns for \$HOME/.local

##### Autoconf and ./configure

```zsh
git clone --depth 1 git@github.com:<user>/<repo>
cd <repo>
sh ./autogen.sh
# The prefix command is what makes this work Typically this installs to /usr/local by default, we are changing that behavior to avoid su or sudo-ing
./configure --prefix $HOME/.local
make 
make install
# Have root run ldconfig -v /$HOME/.local/lib
```

##### CMAKE

```zsh
cd <program>
mkdir build
cd <build>
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local 
make
make install
# Have root run ldconfig -v /$HOME/.local/lib
```

##### Standalone Binaries

```zsh
tar xzf name-version.tar.gz
cd name-version/
make
cp <repo> $HOME/.local/bin
# Have root run ldconfig -v /$HOME/.local/lib
```

