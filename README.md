# vimogen

Vimogen is a menu-based command-line utility that installs, updates or removes <a href="http://www.vim.org/">Vim</a> plugins. It can also keep your plugins synchronized across multiple Vim installs. Just run `vimogen update` and you've updated all of your vim plugins to the latest versions.

No difficult commands to remember and no configuration required, beyond a simple text file consisting of a list of Git repository URLs to the plugins you use. Vimogen uses <a href="https://github.com/tpope/vim-pathogen/">Pathogen</a> which lets you store all of your plugins in one place, as Git checkouts. (Vimogen is needed because Pathogen alone isn't a plugin manager).

Motivation: Many plugins that I use (vim-go, syntastic, etc.) get updated a lot and I wanted an easy way to keep my copies updated. I also wanted a better way to install all of my favorite plugins at once whenever I install a new operating system. The alternatives either didn't use Git or required configuration and other stuff I didn't like. 

Unlike the popular `vim-plug` and `vundle` managers, vimogen keeps your vimrc file smaller, as you put your plugin list in a separate file (.vimogen_repos) rather than inside your vimrc. This was a major design intention of vimogen.

In fact, with Vimogen you can use the same `.vimrc` across multiple machines, but have separate manifest files for each machine. This is useful if you don't want to use development plugins on a production machine, and so on. 

Finding Git URLs for all of your plugins is easy because vim.org mirrors them all on Github <a href="https://github.com/vim-scripts">here</a>.  You can also use Bitbucket or any other Git repository location if you need to.

## Usage

Add Git URLs to `~/.vimogen_repos`--one line at a time--like:

    # Color Scheme
    https://github.com/romainl/Apprentice
    
    # Snippets
    https://github.com/honza/vim-snippets
    https://github.com/jhkersul/vim-jest-snippets

    # Linting
    https://github.com/w0rp/ale
    https://github.com/scrooloose/syntastic
    ...

Note how comments (lines starting with #) and blank lines are allowed for organization.

(<a href="https://github.com/vim-scripts">Find github hosted Vim plugin URLs here</a>)

Run vimogen without arguments:

    $ vimogen

It will give you a menu of items to choose from:

    1) INSTALL
    2) UNINSTALL
    3) UPDATE
    4) EXIT
    Enter the number of the menu option to perform:

For example, typing `1` will install all the plugins listed in .vimogen_repos.

Choosing __INSTALL__ clones all the repos from .vimogen_repos into your Pathogen dir (~/.vim/bundle).
Skipping ones that already exist.  It uses a shallow clone (of depth 3) to help conserve disk space while still
providing flexibility if you need to checkout a slightly older commit.

After it clones it also installs any submodules the repo may have.

Note: You can append new plugin repos to the .vimogen_repos file later and install them incrementally by re-running Vimogen's install command.

Choosing `2` to __UNINSTALL__ gives you a list of all your plugins:

    1) BACK                  8) python-mode         15) vim-rhubarb
    2) ALL                   9) rainbow             16) vim-pathogen
    3) coc                  10) syntastic           17) vim-prettier
    4) fzf                  11) tagbar              18) vim-rails
    5) indentLine           12) tComment            19) vim-repeat
    6) nerdtree             13) vim-dispatch        20) vim-surround
    7) nerdtree-git-plugin  14) vim-fugitive        21) vimogen
    Enter the number of the plugin you wish to uninstall:

Press `1` to cancel and go back to the main menu or `2` to remove all of your plugins at once.
    
Choosing `3` to __UPDATE__ runs a `git pull` and updates any submodules on all of your bundles:

![update](https://cloud.githubusercontent.com/assets/244283/17818417/5505c364-65f8-11e6-8dfc-0797c96cd06b.png)

### Command-line options

To update vimogen straight from the command-line just pass the update argument (useful for scripts/cron jobs):

    $ vimogen update

To output the current contents of your .vimogen_repos file, add the 'heap' argument:

    $ vimogen heap

For more verbose output, use the `-v` flag (not recommended for normal use).

## Requirements

* A Unix-like operating system (Linux, MacOS, etc., with Bash, Perl and Git installed)
* The Vim plug-in: [Pathogen](https://github.com/tpope/vim-pathogen/ "Pathogen")

## Installation

Create a text file called `$HOME/.vimogen_repos` and add a list of Git URLs to the Vim plugin repositories you use, one URL per line. Vim.org mirrors them all plugins to Github <a href="https://github.com/vim-scripts">here</a>. See [my .vimogen_repos file](https://github.com/rkulla/vimrc/blob/master/.vimogen_repos) for an example.

Alternatively, vimogen will auto-generate `$HOME/.vimogen_repos` if you run it without creating the file first. It generates based off the current Pathogen bundles you already have. This allows you to update or uninstall any existing plugins you have. You'll only need to edit .vimogen_repos yourself when you want to add more plugins.

Then run:

    $ git clone https://github.com/rkulla/vimogen
    $ cd vimogen

Then copy the vimogen script to your $PATH. I like to do this as:

    $ mkdir ~/bin
    $ cp vimogen ~/bin

then in your shell config (e.g., ~/.bashrc or ~/.zshrc) add:

    PATH="$HOME/bin:$PATH"
    export PATH


## Tips

- If you ever want to temporarily disable a plugin, just use vimogen to UNINSTALL it, 
then whenever you want it back just run vimogen's INSTALL again.

- Keep a reference to the vimogen repository in .vimogen_repos and it will show you
if a new version was updated whenever you run the update command. Then all you have to do is
copy the updated vimogen file to your PATH to have the latest version. Do the same for
vim-pathogen.

## FAQ

> __Why depend on Pathogen when Vim8+ supports native packages?__

  I find that this dependency is actually simpler because native packages would require that
  Vimogen manage a list of plugins that go into both start/ and opt/ folders, instead of just one
  bundle/ directory. Pathogen can manage optional packages and still takes up very little of vimrc:

    if has("gui_running") " list plugins to disable if GUI Vim is running
      let g:pathogen_disabled = []
      call add(g:pathogen_disabled, 'coc')
    endif
    execute pathogen#infect() 

  And Pathogen will "just work" on any of your Vim installs.

> __Does vimogen support git submodules?__

  Vimogen supports _plugins_ that support submodules (it will init and update them).
  However, if your .vim/ is in a git repo (as in dotfiles repo) and you installed vim plugins through
  submodules, then no. I find packages as submodules to be less convenient to use than vimogen.
  Instead I just commit the .vimogen_repos file to my dotfiles repo.  This allows me to gitignore my
  entire plugin directory, which is cleaner than committing it with submodule references to all plugins.

> __Can Vimogen manage Vim color schemes?__

Yes. Anything that works with Pathogen (which is almost everything)
will work with Vimogen.

> __I downloaded a Vim plugin as a .zip file. What should I do?__

Vimogen doesn't use zip files, it uses git repos. All of
the plugins from vim.org are mirrored on https://github.com/vim-scripts so
find it on there and put its github clone URL into ~/.vimogen_repos. If
a plugin you want is not mirrored, it's probably still somewhere on Github
or somewhere if you search.

> __I already use Dropbox (or similar) to keep my .vim/ directory synchronized. 
Why should I use Vimogen?__

Even if you've created a symlink from ~/.vim/ to ~/Dropbox/path/to/.vim/, that
will only help you keep your existing versions of plugins synchronized. Vimogen 
also pulls from all your plugins' Git repositories to keep them updated.

## License

Copyright (c) Ryan Kulla. Distributed under the same terms as Vim itself. See :help license
