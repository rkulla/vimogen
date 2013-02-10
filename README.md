
Vimogen is a zero-configuration Pathogen bundle manager that manages the 
installing/deleting/updating of all your Vim plugins.

Because of these abilities, Vimogen also makes it very easy to keep all your Vim
plugins synchronized across different machines.

Simply create a manifest file in your home directory called .vimogen_repos 
(or let vimogen generate one for you) and put full paths to git repos to vim 
plugins in it, one line at a time:
    
    git://github.com/tpope/vim-surround.git
    git://github.com/tpope/vim-rails.git
    git://github.com/scrooloose/nerdtree.git
    git://github.com/godlygeek/tabular.git
    ...

Running vimogen will give you the option to install, update, or uninstall
the Vim plugins you like to use. This allows you to set up a your Vim 
installation on a new computer very quickly and it allows you to keep all 
your Vim plugins up-to-date very easily.

Q: What is pathogen?

A: Pathogen has become the de-facto standard way of installing Vim plugins
because it makes it very easy to keep them modular and as git repositories.
See https://github.com/tpope/vim-pathogen

Q: Where can I find git URLs for Vim plugins?

A: All the plugins from vim.org are mirrored on https://github.com/vim-scripts

Q: Is vimogen the best way to manage Pathogen bundles?

A: I don't know. I just evolved the way I was handling it into this script.
There are other ways to handle the automation of installing Vim plugins
via pathogen -- such as making your entire .vim directory a git repo and
then making the plugin directories git submodules. There's also another
project someone created called Vundle, but I prefer this simpler method I made.

Requirements
============
A Unix-like system (Linux, OS X, etc.) running the Bash shell.

Vim and the [Pathogen](https://github.com/tpope/vim-pathogen/ "Pathogen") plugin.

Git.

Installation
============
Installation is optional.

Create a manifest file called $HOME/.vimogen_repos that consists
of just git repositories. I supplied an example .vimogen_repos file
which contains the plugins that I like to use. Make up your own, though.

Note that Vimogen wil auto-enerate $HOME/.vimogen_repos if you run it
without creating the file first. It will genereate it based off the
current pathogen bundles you already have, if any.

Then:

    git clone git://github.com/rkulla/vimogen.git
    chmod u+x vimogen.sh
    cp vimogen.sh ~/bin/vimogen 
    
or put it somewhere else in your $PATH if you don't like ~/bin.

Usage
=====
Run vimogen without arguments:

    $ vimogen

It will give you a menu of items to choose from. Such as 'Install' or 'Update':

    1) Install
    2) Uninstall
    3) Update
    4) Exit
    Select a menu option to perform: 

If you choose Install, then it will a 'git clone' on all the git repositories 
that you specified in ~/.vimogen_repos into your Pathogen dir (~/.vim/bundle).
It will skip any directories that already exist, so you can append new plugins
to the vimogen_repos manifest later and install them too.

If you choose Uninstall, it will give you a list of all your plugins to choose from:

    1) EXIT              7) tlib_vim            13) vim-matchit
    2) vim-rails         8) vim-addon-mw-utils  14) taglist.vim
    3) vim-surround      9) snipmate-snippets   15) tabular
    4) nerdtree         10) ZenCoding.vim       16) tComment
    5) ctrlp.vim        11) vcscommand.vim      17) python-mode
    6) vim-snipmate     12) dbext.vim           18) pydiction
    Select a plugin to completely uninstall:
    
If you choose Update, then it will run a 'git pull' on all of your bundles. 
This is great because you can stay up-to-date with all the new features the 
plugin authors create just by re-running this command often.

License
=======
Copyright (c) Ryan Kulla. Distributed under the same terms as Vim itself. See :help license
