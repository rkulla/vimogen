
Vimogen is an opinionated shell script that believes you should install
your Vim plugins via Pathogen bundles/git repos and automates installing
and updating of them. 

Simply create a manifest file in your home directory called .vimogen_repos 
and put full paths to git repos to vim plugins in it, one line at a time:
    
    git://github.com/tpope/vim-surround.git
    git://github.com/tpope/vim-rails.git
    git://github.com/scrooloose/nerdtree.git
    git://github.com/godlygeek/tabular.git
    ...

and run vimogen and it will give you the option to install or update. This
allows you to set up a your Vim installation on a new computer very quickly
and it allows you to keep all your Vim plugins up-to-date very easily.

If you don't know what pathogen is, it's become the de-facto standard way of
installing Vim plugins because it makes it very easy to keep them modular
and as git repositories. See https://github.com/tpope/vim-pathogen

There are other ways to handle the automation of installing Vim plugins
via pathogen -- such as making your entire .vim directory a git repo and
then making the plugin directories git submodules -- but I prefer this
simpler method I created.

Installation
============
Create a manifest file called $HOME/.vimogen_repos that consists
of just git repositories. (See the supplied example)

Next:

    chmod u+x vimogen.sh
    mv vimogen.sh ~/bin/vimogen 
    
or put it somewhere else in your $PATH if you don't like ~/bin.

Usage
=====
Run vimogen without arguments:

    $ vimogen

It will give you a menu of items to choose from. Such as 'Install' or 'Update':

    1) Install
    2) Update
    3) Exit
    Select a menu option to perform: 1

If you choose Install, then it will a 'git clone' on all the git repositories 
that you specified in ~/.vimogen_repos into your Pathogen dir (~/.vim/bundle).
It will skip any directories that already exist, so you can append new plugins
to the vimogen_repos manifest later and install them too.

If you choose Update, then it will run a 'git pull' on the bundles. This is 
great because you can stay up-to-date with all the new features the plugin
authors create just by re-running this command often.
