# voom: a simple Vim plugin manager

voom is a simplest-thing-that-works tool to manage your Vim plugins.  It installs plugins, updates them, and uninstalls them.

It assumes:

- The plugins you use are on GitHub (or in-progress on disk).
- You use [Pathogen][] or Vim packages to manage Vim's runtime path.

voom is an alternative to [vim-plug][], [Vundle][], [NeoBundle][], [vam][], [Vizadry][], etc.

Features:

* Fast: plugins are installed in parallel.
* Lightweight (100 lines of bash).
* No git submodules :)


## Installation

Voom works with both Vim and NeoVim.

Vim users: just follow the instructions below.

NeoVim users: follow the instructions below but:

- replace `~/.vim` with `~/.config/nvim`
- replace `~/.vimrc` with `~/.config/nvim/init.vim`

If you’re using Vim packages: follow the instructions below but:

- replace `~/.vim/bundle` with `~/.vim/pack/bundle/start` (or any other package name instead of `bundle`)


#### If you already have a `~/.vim` directory

Empty your `~/.vim/bundle/` directory and git-ignore everything in `bundle/`.

```sh
$ rm -rf ~/.vim/bundle/*
$ cd ~/.vim && echo 'bundle/' >> .gitignore
```


#### If you don't yet have a `~/.vim` directory

Create it together with the `autoload` and `bundle` subdirectories:

```sh
$ mkdir -p ~/.vim/{autoload,bundle}
```


#### Install Pathogen

You can skip this step if you want to use Vim 8 packages.

```sh
$ curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
```

Add this to the top of your `~/.vimrc`:

```viml
execute pathogen#infect()
```


#### Install the `voom` script somewhere on your PATH

For example, if `~/bin` is on your path:

```sh
$ curl -LSso ~/bin/voom https://raw.githubusercontent.com/airblade/voom/master/voom
```

NeoVim users: tell voom where your configuration is:

```sh
$ alias voom='VIM_DIR=~/.config/nvim voom'
```

If you’re using Vim 8 packages: tell voom where to save your plugins configuration:

```sh
$ alias voom='VIM_BUNDLE_DIR=~/.vim/pack/bundle/start voom'
```


#### Declare your plugins in `plugins` and add the file to your repo

```sh
$ echo 'airblade/voom' > ~/.vim/plugins
$ voom edit
$ git add ~/.vim/plugins
```

You don't need `airblade/voom` in your manifest – the `voom` script does all the work – but it makes editing the manifest a little nicer.


## Usage

You declare your plugins in `plugins`, a plain-text manifest in your vim repo.  Open your manifest with:

```sh
$ voom edit
```

Here's an example of a manifest:

```
# Comments start with a hash character.
# Note the plugin declarations are case-sensitive.

# Declare repos on GitHub with: username/repo.
tpope/vim-fugitive

# Declare repos on your file system with the absolute path.
/Users/andy/code/src/vim-gitgutter
```

Run `voom` without arguments to install and uninstall plugins as necessary to match your manifest.

To update your (GitHub-hosted) plugins:

```sh
$ voom update
```

If you just want to update one plugin:

```sh
$ voom update vim-fugitive
```

Restart Vim to pick up changes to your plugins.



## How does it work?

When `voom` installs a plugin:

- GitHub-hosted: `voom` clones it [1] into `~/.vim/bundle/`.
- local: `voom` symlinks it into `~/.vim/bundle/`.

When `voom` uninstalls a plugin:

- GitHub-hosted: `voom` removes the directory from `~/.vim/bundle/`.
- local: `voom` removes the symlink from `~/.vim/bundle/`.

[1] `voom` performs a shallow clone of depth 1.  If you subsequently want a repo's full history, do `git pull --unshallow`.


## Why is voom written in bash not VimL?

Installing, updating, and uninstalling plugins simply involves making directory trees available at the appropriate locations on the file system.  It's basic command-line stuff involving things like `git`, `ln`, `rm`.  A shell script is the natural solution.

All a VimL wrapper would do is call those same shell commands – but with all the problems that come with shelling out from Vim.

In this case the simplest thing that works is a shell script.


  [pathogen]: https://github.com/tpope/vim-pathogen
  [vim-plug]:https://github.com/junegunn/vim-plug
  [vundle]: https://github.com/gmarik/vundle.vim
  [NeoBundle]: https://github.com/Shougo/neobundle.vim
  [vam]: https://github.com/MarcWeber/vim-addon-manager
  [vizadry]: https://github.com/ardagnir/vizardry
  [neovim]: https://neovim.io/doc/user/nvim_from_vim.html


## Intellectual Property

Copyright Andrew Stewart.  Released under the MIT licence.

