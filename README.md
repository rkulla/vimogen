# vimogen

Vimogen is a small utility that installs, updates or removes <a href="http://www.vim.org/">Vim</a> plugins. It can also keep your plugins synchronized across multiple Vim installs.

Requiring no configuration -- just a text file with a list of Git repositories URLs to the plugins you use -- Vimogen uses <a href="https://github.com/tpope/vim-pathogen/">Pathogen</a> which lets you store all of your plugins in one place, as Git checkouts.

Motivation: Many plugins that I use (vim-go, syntastic, etc.) get updated a lot and I wanted an easy way to keep my copies updated. I also wanted a better way to install all of my favorite plugins at once whenever I install a new operating system. The alternatives either didn't use Git or required configuration and other stuff I didn't like. 

With Vimogen, you can use the same `.vimrc` across multiple machines, but have separate manifest files for each machine. This is useful if you don't want to use development plugins on a production machine, and so on.

Don't worry, finding Git URLs for all of your plugins is actually very easy 
because vim.org mirrors them all on Github <a href="https://github.com/vim-scripts">here</a>.
You can also use Bitbucket or any other Git repository location if you need to.

## Requirements

* Bash, perl and git.
* The [Pathogen](https://github.com/tpope/vim-pathogen/ "Pathogen") plugin for Vim.

## Installation

Create a file called $HOME/.vimogen_repos that consists of just Git URLs. It's just a plain-text file with a git repo on each line. See [my .vimogen_repos file](https://github.com/rkulla/vimrc/blob/master/.vimogen_repos) for an example.

Vimogen auto-generates `$HOME/.vimogen_repos` if you run it
without creating the file first. It generates based off the
current Pathogen bundles you already have. This allows you to
update or uninstall any existing plugins you have. You'll only need
to edit .vimogen_repos yourself when you want to add more plugins.

Then run:

    $ git clone https://github.com/rkulla/vimogen
    $ chmod u+x vimogen
    
and copy vimogen to your $PATH.

## Usage

First create a manifest file called `~/.vimogen_repos`
(or let vimogen generate one for you) and put Git clone URLs to Vim plug-in
repositories inside of it -- one line at a time -- like:
    
    https://github.com/tpope/vim-sensible
    https://github.com/tpope/vim-surround
    https://github.com/scrooloose/nerdtree
    https://github.com/tomasr/molokai
    ...

<a href="https://github.com/vim-scripts">Find vim URLs here</a>.

Run vimogen without arguments:

    $ vimogen

For more verbose output, use the `-v` flag.

It will give you a menu of items to choose from:

    1) INSTALL
    2) UNINSTALL
    3) UPDATE
    4) EXIT
    Enter the number of the menu option to perform:

For example, typing `1` will install all the plugins listed in .vimogen_repos.

Choosing __INSTALL__ clones all the repos from .vimogen_repos into your Pathogen dir (~/.vim/bundle).
Skipping ones that already exist. 

Note: You can append new plugin repos to the .vimogen_repos file later and install them incrementally by re-running Vimogen's install command.

Choosing `2` to __UNINSTALL__ gives you a list of all your plugins:

         1) BACK                  8) tabular             15) vimogen
         2) ALL                   9) taglist             16) vim-pathogen
         3) ctrlp                10) tComment            17) vim-rails
         4) molokai              11) tlib_vim            18) vim-repeat
         5) pydiction            12) vcscommand          19) vim-snipmate
         6) python-mode          13) vim-addon-mw-utils  20) vim-surround
         7) snipmate-snippets    14) vim-jade            21) ZenCoding
         Enter the number of the plugin you wish to uninstall:

Press `1` to cancel and go back to the main menu or `2` to remove all of your plugins at once.
    
Choosing `3` to __UPDATE__ runs a `git pull` on all of your bundles:

![update](https://cloud.githubusercontent.com/assets/244283/17818417/5505c364-65f8-11e6-8dfc-0797c96cd06b.png)

Choosing `4` to __EXIT__ is a good idea because returning to the main menu will show you any notifications about things that happened (at the top of the screen). So don't just Ctrl+C to exit out of menus.

## Tips

- If you ever want to temporarily disable a plugin, just use vimogen to UNINSTALL it, 
then whenever you want it back just run vimogen's INSTALL again.

- Keep a reference to the vimogen repository in .vimogen_repos and it will show you
if a new version was updated whenever you run the update command. Then all you have to do is
copy the updated vimogen file to your PATH to have the latest version. Do the same for
vim-pathogen.

## FAQ

> Can Vimogen install Vim color schemes, like Molokai?__

Yes. Anything that works with Pathogen (which is almost everything)
will work with Vimogen.

> I downloaded a Vim plugin as a .zip file. What should I do?__

Vimogen doesn't use zip files, it uses git repos. All of
the plugins from vim.org are mirrored on https://github.com/vim-scripts so
find it on there and put its github clone URL into ~/.vimogen_repos. If
a plugin you want is not mirrored, it's probably still somewhere on Github
or somewhere if you search.

> I already use Dropbox (or similar) to keep my .vim/ directory synchronized. 
Why should I use Vimogen?__

Even if you've created a symlink from ~/.vim/ to ~/Dropbox/path/to/.vim/, that
will only help you keep your existing versions of plugins synchronized. Vimogen 
allows you to also automatically pull from all your plugins' git repos keep up-to-date.

## License

Copyright (c) Ryan Kulla. Distributed under the same terms as Vim itself. See :help license
