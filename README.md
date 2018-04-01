# voom: a simple Vim plugin manager

voom is a simplest-thing-that-works tool to manage your Vim plugins.  It installs plugins, updates them, and uninstalls them.

It assumes:

- The plugins you use are on GitHub, cloneable with an http/https URL, or in-progress on disk.
- You use Vim 8 packages (or [Pathogen][] to manage Vim's runtime path).

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

If you use Pathogen instead of Vim packages, follow the instructions below but:

- replace `pack/voom/start/` with `bundle/`


#### Create the installation directory

Create a `~/.vim/pack/voom/start` (Vim) or `~/.config/nvim/pack/voom/start` (NeoVim) directory and git-ignore everything in `pack/voom/`.

```sh
$ cd ~/.vim && mkdir -p pack/voom/start && echo 'pack/voom/' >> .gitignore
$ cd ~/.config/nvim && mkdir -p pack/voom/start && echo 'pack/voom/' >> .gitignore
```


#### Install the `(n)voom` scripts somewhere on your PATH

For example, if `~/bin` is on your path:

```sh
$ curl -LSso ~/bin/voom https://raw.githubusercontent.com/airblade/voom/master/voom
$ curl -LSso ~/bin/nvoom https://raw.githubusercontent.com/airblade/voom/master/nvoom
```

Pathogen users: tell voom where to save your plugins:

```sh
$ alias voom='VIM_PLUGINS_DIR=~/.vim/bundle voom'
```


#### Declare your plugins in `plugins` and add the file to your repo

```sh
$ echo 'airblade/voom' > ~/.vim/plugins    # optional
$ voom edit                                # opens your editor so you can declare your plugins
$ git add ~/.vim/plugins
```

You don't need `airblade/voom` in your manifest – the `voom` script does all the work – but it makes editing the manifest a little nicer.


## Usage

Declare your plugins in `plugins`, a plain-text manifest in your vim repo.  Open your manifest with:

```sh
$ voom edit
```

Here's an example of a manifest:

```
# Comments start with a hash character.
# Note the plugin declarations are case-sensitive.

# Declare repos on GitHub with: username/repo.
tpope/vim-fugitive

# Declare repos on Gitlab or others with full URL:
https://github.com/tpope/vim-obsession
https://gitlab.com/hugoh/vim-auto-obsession

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

If you want to update plugins with minimal output:

```sh
$ voom update -q
```

Restart Vim to pick up changes to your plugins.



## How does it work?

When `voom` installs a plugin:

- GitHub-hosted: `voom` clones it [1] into `~/.vim/pack/voom/start/`.
- local: `voom` symlinks it into `~/.vim/pack/voom/start/`.

When `voom` uninstalls a plugin:

- GitHub-hosted: `voom` removes the directory from `~/.vim/pack/voom/start/`.
- local: `voom` removes the symlink from `~/.vim/pack/voom/start/`.

[1] `voom` performs a shallow clone of depth 1.  If you subsequently want a repo's full history, do `git pull --unshallow`.


## Why is voom written in bash not Vim script?

Installing, updating, and uninstalling plugins simply involves making directory trees available at the appropriate locations on the file system.  It's basic command-line stuff involving things like `git`, `ln`, `rm`.  A shell script is the natural solution.

All a Vim script wrapper would do is call those same shell commands – but with all the problems that come with shelling out from Vim.

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

