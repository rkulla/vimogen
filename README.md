
Vimogen is an opinionated shell script that believes you should install
your Vim plugins via Pathogen bundles/git repos and automates installing
and updating your bundles.

There are other ways to handle the automation of installing Vim plugins
via pathogen -- such as making your entire .vim directory a git repo and
then making the plugin directories git submodules -- but I prefer this
simpler method I created.

Installation
============
Create a manifest file called $HOME/.vimogen_repos that conists
of just git repositories. (See the supplied example)

Then mv vimogen.sh ~/bin/vimogen (or somewhere in your $PATH)

Usage
=====
Run vimogen without arguments:

    $ vimogen

It will give you a menu of items to choose from. Such as 'Install' or 'Update'.

If you choose Install, then it will a 'git clone' on all the git repositories 
that you specified in ~/.vimogen_repos into your Pathogen dir (~/.vim/bundle).
It will skip any directories that already exist, so you can append new plugins
to the vimogen_repos manifest later and install them too.

If you choose Update, then it will run a 'git pull' on the bundles.
