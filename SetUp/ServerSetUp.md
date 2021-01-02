## Set up in OpenSUSE 15.2

### On Windows 10 running WSL2

All System-wide installations have to be done by **root** as below.  My setup separates my user from **root**

```zsh
zypper refresh in --download-in-advance -t pattern devel_C_C++ devel_basis devel_java devel_python3 devel_qt5 devel_rpm_build console

zypper refresh in --download-in-advance glibc-devel glibc-devel-static glibc-extra glibc-utils texlive autoconf autoconf213 automake libtool pkg-config cmake doxygen asciidoc ant ant-contrib ant-scripts libxslt-devel libxslt-tools xalan-j2-xsltc libxslt1 libxslt-tools libxslt-python java-11-openjdk-devel wget wget-lang freetype freetype-devel freetype-tools libfreetype6 libwmf-devel libwmf-tools libwmf-0_2-7 lcms2 liblcms2-devel liblcms2-doc libxml2-devel libxml2-tools perl-XML-LibXML python3-libxml2-python libyaml-devel libyaml-0-2 libpng16-devel libpng16-tools libtiff-devel libtiff5 libopenjp2-7 libopenjpeg1 libgif7 zlib-devel zlibrary-data zlibrary-devel libicu-devel libpango-1_0-0 libpangomm-2_44-1 libcairo2 libcairo-script-interpreter2 libcairo-gobject2 mozilla-nss mozilla-nss-certs mozilla-nss-devel mozilla-nss-sysinit mozilla-nss-tools pandoc MultiMarkdown-6 cmark discount pandoc texlive-context wkhtmltopdf maven maven-lib maven-local maven-shared gradle gradle-local javapackages-gradle mtree tree xclip vsftpd zsh cairo-devel cairo-tools libcairo2 openjpeg2 openjpeg2-devel cmake-full tmux
```

### To set up zsh and set it as default user shell

This is still done by **root**

```zsh
chsh -s $(which zsh)
# make edits to change any /bin/bash to /bin/zsh
sudo vi /etc/passwd 
```

### Set up .zshrc

This is done as user or else it will be saved under **\$HOME** for **root** and not **user**

```zsh
#enter .zshrc with vim to edit (can also use emacs or nano as desired)
vi ~/.zshrc 

# Copy and paste the following to .zshrc

###################################
# Set up Paths and Linkers for $HOME/.local program install
###################################
export PATH=$HOME/.local/bin:$PATH
export C_INCLUDE_PATH=$HOME/.local/include
export CPLUS_INCLUDE_PATH=$HOME/.local/include
export LIBRARY_PATH=$HOME/.local/lib:$HOME/.local/lib64
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig:$HOME/.local/lib64/pkgconfig
export LD_LIBRARY_PATH=$HOME/.local/lib:$HOME/.local/lib64
export MANPATH=$HOME/.local/share/man:$(manpath)
export PATH=$HOME/.local/python/Python3.9:$PATH
export PATH=$HOME/.local/bin/:$PATH
alias python=$HOME/.local/python/bin/python3
alias python3=$HOME/.local/python/bin/python3
alias pip3=$HOME/.local/python/bin/pip3
alias pip=$HOME/.local/python/bin/pip3
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
xclip -sel clip < $HOME/.ssh/id_rsa.pub
# paste this into GitHub under Settings > SSH and GPG Keys

# Set Git to use Windows Credential manager
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe"
```

#### Set up to Install Programs into \$HOME/.local

**Step 1:** Done as **user** 

Verify that **user** has read/write permissions for their \$HOME directory (.home/\<user>)

```zsh
cd $HOME
ls -la
```

IF (and only IF) NO, then ask **root** to give permissions

```zsh
chown -R <user> /home/<user>
```

**Step 2:** Done as **user**

Set up basic directories in **\$HOME/.local**

```zsh
mkdir -p ~/.local/{bin,share/man,include,lib/pkgconfig,lib64/pkgconfig,src}
```

