# dotfiles
Install software and run scripts I need on a fresh copy of OS X.

## Installation

```bash
curl -s https://raw.githubusercontent.com/sraeburn/dotfiles/master/bin/bootstrap.sh | bash -s ~/.dotfiles
```

The first (optional) bash parameter indicates the target directory to install the dotfiles files. The default location (~/.dotfiles) is used when no bash parameter is specified:

```bash
curl -s https://raw.githubusercontent.com/sraeburn/dotfiles/master/bin/bootstrap.sh | bash
```
Shortened alternative: 
```bash
curl -sL https://goo.gl/beoVOr | bash

## Update 

To update, run the installation command again.

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as detecting which version of `ls` is being used) takes place.

Here’s an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Steve Raeburn"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="steve@ninsky.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

You could also use `~/.extra` to override settings, functions and aliases from the dotfiles repository. 
### Sensible OS X defaults

The following scripts are (optionally) invoked by the bootstrap.sh command. They can also be invoked individually from the command line.

### Install Homebrew formulae
```bash
~./.dotfiles/bin/brew.sh
```

### Install VMWare Tools
```bash
~./.dotfiles/bin/vmware-tools.sh
```

### Configure OSX settings
```bash
~./.dotfiles/bin/config.sh
```

There is also a script to set-up a shared Sublime Text 3 profile in Dropbox.
```bash
~./.dotfiles/bin/sublime-setup.sh
```


### Summary 
##bootstrap.sh
	Install XCode Developer Tools
	Checkout .dotfiles

##brew.sh
	Install / Upgrade Homebrew
	Install / Upgrade Formulae
	Install / Upgrade Casks
	Configure Apps
	Move Links -> /Applications
	Clean Up

##config.sh
	dotfiles
	defaults
	restart shell & apps

vmware-tools.sh


### Inspired by

* [Mathias Bynens dotfiles](https://github.com/mathiasbynens/dotfiles)
* [YJ Yang osx-init](https://github.com/chcokr/osx-init)
