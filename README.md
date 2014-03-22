
Vimogen is a very easy way to install, update, or remove Vim plugins --
and optionally keep them synchronized across multiple vim installations.

Requiring no configuration other than a manifest file, vimogen is essentially a 
<a href="https://github.com/tpope/vim-pathogen/">Pathogen</a> bundle manager 
that manages the installing/deleting/updating of all your Vim add-ons. If you don't know what Pathogen is, it
lets you store all of your plugins in one directory, as git checkouts.

I created Vimogen because many plugins that I use (vim-rails, syntastic, etc), get new
changes all of the time and I wanted an easy way to keep my copies up-to-date. And I
wanted a super simple way to install all my favorite plugins whenever I install a new 
operating system and need to get vim the way I like it quickly. I also wanted something
that didn't clutter up my vimrc file. 

There are alternatives to Pathogen+Vimogen but they either don't use git or require configuration or other things
that I didn't like. For example, with Vimogen you can use your same .vimrc across multiple machines, but have
separate .vimogen_repo manifest files for each one and it just works. This is useful if you don't want to use
development plugins on a production machine, and so on. I tend to keep .vimogen_repos.dev and .vimogen_repos.prod
and upload the corresponding files to the appropriate machines, and rename them to .vimogen_repos once uploaded.


How Vimogen works...

Simply create a manifest file in your home directory called .vimogen_repos 
(or let vimogen generate one for you) and put Git clone URLs to Vim plug-in
repositories inside of it -- one line at a time -- like:
    
    git://github.com/tpope/vim-sensible.git
    git://github.com/tpope/vim-surround.git
    git://github.com/scrooloose/nerdtree.git
    git://github.com/tomasr/molokai.git
    ...

Don't worry, finding Git URLs for all of your plugins is actually very easy 
because vim.org mirrors them all on github <a href="https://github.com/vim-scripts">here</a>.
You can also use bitbucket or any other git repository location if you need to.

Running the _vimogen_ command will give you the option to install, update, or
uninstall all of the Vim plugins and color schemes that you use.

Requirements
============
* A Unix-like system (Linux, OS X, etc.) running the Bash shell and Git.

* The [Pathogen](https://github.com/tpope/vim-pathogen/ "Pathogen") plugin for Vim.

Installation
============
Installation is optional and is as simple as installing a shell script.

Create a manifest file called $HOME/.vimogen_repos that consists
of just git repositories. I supplied a sample .vimogen_repos file
which contains the plugins that I may use. Make up your own, though.

Note that Vimogen wil auto-enerate $HOME/.vimogen_repos if you run it
without creating the file first. It will genereate it based off the
current pathogen bundles you already have, if any. This allows you to
update or uninstall any existing plugins you have. You will only need
to edit .vimogen_repos yourself when you want to install more plugins.

Next, run:

    git clone git://github.com/rkulla/vimogen.git
    chmod u+x vimogen.sh
    cp vimogen.sh ~/bin/vimogen 
    
or put it somewhere else in your $PATH if you don't use ~/bin.

Usage
=====
Run vimogen without arguments:

    $ vimogen

or, for more verbose output:

    $ vimogen -v

It will give you a menu of items to choose from:

    1) INSTALL
    2) UNINSTALL
    3) UPDATE
    4) EXIT
    Enter the number of the menu option to perform:

For example, typing __1__ will install all the plugins listed in .vimogen_repos.

*    If you choose INSTALL, then it will a _git clone_ on all the git repositories 
that you specified in ~/.vimogen_repos into your Pathogen dir (~/.vim/bundle).
It will skip any directories that already exist. You can also append new plugin
repos to the .vimogen_repos file later and install them incrementally by re-
running Vimogen's install command.

*    If you choose UNINSTALL, it will give you a list of all your plugins to choose from:

         1) CANCEL                8) tabular             15) vimogen
         2) ctrlp                 9) taglist             16) vim-pathogen
         3) molokai              10) tComment            17) vim-rails
         4) nerdtree             11) tlib_vim            18) vim-repeat
         5) pydiction            12) vcscommand          19) vim-snipmate
         6) python-mode          13) vim-addon-mw-utils  20) vim-surround
         7) snipmate-snippets    14) vim-jade            21) ZenCoding
         Enter the number of the plugin you wish to uninstall:

Press 1 to cancel. 2 to remove all your plugins at once.
    
*    If you choose UPDATE, then it will run a _git pull_ on all of your bundles. 
This is great because you can stay up-to-date with all the new features the 
plugin authors create just by re-running this command often.

TIP: If you ever want to temporarily disable a plugin, just use vimogen to UNINSTALL it, 
then whenever you want it back just run vimogen's INSTALL command, which will restore it
as long as you don't delete it from .vimogen_repos.

TIP: Keep a reference to the vimogen repository in .vimogen_repos and it will show you
if a new version was updated whenever you run the update command. Then all you have to do is
copy the updated vimogen.sh file to your PATH to have the latest version. Do the same for
vim-pathogen's repo.

FAQ
===
__Q: What is pathogen?__

A: Pathogen has become the de-facto standard way of activating Vim plugins
that were installed in modular way into their own directories, rather than
unzip'ing all plugins into the same directory. Vimogen assumes that you are 
using Pathogen, so install Pathogen first, which is as easy as following the
simple steps <a href="https://github.com/tpope/vim-pathogen">here</a>.

__Q: Where can I find git URLs for Vim plugins?__

A: All of the plugins from vim.org are mirrored on https://github.com/vim-scripts

__Q: I downloaded a Vim plugin as a .zip file. What should I do?__

A: Delete it. Vimogen doesn't use zip files, it uses git repositories. All of
the plugins from vim.org are mirrored on https://github.com/vim-scripts so
find it on there and put its github clone URL into ~/.vimogen_repos. If
a plugin you want is not mirrored, i's probably still somewhere on github
or somewhere if you search for it.

__Q: What is this $HOME/.vimogen_repos file about?__

A: It is simply a text file that consists of git URLs to the Vim plugins you
want to install. If you don't have any new plugins you wish to install, you
can still use vimogen to update or uninstall your existing plugins as long
as they were installed as Pathogen bundles. Vimogen will look in your bundle
directory and generate a $HOME/.vimogen_repos for you the first time you run 
it. Note that for this to work your existing bundles must also contain git 
repositories.

__Q: Can Vimogen install Vim color schemes, like Molokai?__

A: Absolutely. Anything that works with Pathogen (which is almost everything)
will work with Vimogen.

__Q: I already use Dropbox (or similar) to keep my .vim/ directory synchronized. 
Why do I need something like Vimogen?__

A: Even if you've created a symlink from ~/.vim/ to ~/Dropbox/path/to/.vim/, that
will only help you keep your existing versions of plugins synchronized. Vimogen 
allows you to also automatically pull from all your plugins' git repositories in
order to keep them up-to-date.

__Q: Is Vimogen really the easiest way to manage Vim plugins?__

A: You tell me. I evolved the way I was handling it into this script. Vimogen
doesn't require adding anything to your .vimrc file or remember any new vim commands. 

There are other ways to handle the automation of installing Vim plugins via 
pathogen -- such as making your entire .vim directory a git repo and then
making the plugin directories git submodules, but to me submodules are overkill and besides
I like to keep my .vim/ chmod 600 and store my .swp files there, and without having to manage
it as a git repo. There are also other plugin managers such as Vundle that require configuration.
Vimogen is just the easiest method I've seen.

License
=======
Copyright (c) Ryan Kulla. Distributed under the same terms as Vim itself. See :help license
