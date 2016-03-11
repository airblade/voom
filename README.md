# voom: a simple Vim plugin manager

voom is a simplest-thing-that-works tool to manage your Vim plugins.  It installs plugins, updates them, and uninstalls them.

It assumes:

- The plugins you use are on GitHub (or in-progress on disk).
- You use [Pathogen][] to manage Vim's runtime path.

voom is an alternative to [Vundle][], [NeoBundle][], [vam][], [Vizadry][], etc.

Features:

* Fast.
* Lightweight (<100 lines bash).
* No git submodules :)


## Why is voom written in bash not VimL?

Installing, updating, and uninstalling plugins simply involves making directory trees available at the appropriate locations on the file system.  It's basic command-line stuff involving things like `git`, `ln`, `rm`.  A shell script is the natural solution.

All a VimL wrapper would do is call those same shell commands – but with all the problems that come with shelling out from Vim.

In this case the simplest thing that works is a shell script.


## Usage

You declare your plugins in `plugins`, a plain-text manifest in your dotvim repo.  Open your manifest with:

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

Run `voom` without arguments to install and uninstall plugins as necessary to match the state declared in your manifest.

To update your (GitHub-hosted) plugins:

```sh
$ voom update
```

If you just want to update one plugin:

```sh
$ voom update vim-fugitive
```

Restart Vim to pick up changes to your plugins.


## Installation

- Put `voom` somewhere on your `PATH`.
- Empty your `~/dotvim/bundle/` directory and add `bundle/` to `.gitignore`.
- Declare your plugins in `plugins` and add the file to your repo.

If you'd like simple vim support for your manifest (e.g. syntax highlighting, setting the `commentstring`), declare the `voom` repo in your manifest and install it as a vim plugin.


## How does it work?

When `voom` installs a plugin:

- GitHub-hosted: `voom` clones it [1] into `~/dotvim/bundle/`.
- local: `voom` symlinks it into `~/dotvim/bundle/`.

When `voom` uninstalls a plugin:

- GitHub-hosted: `voom` removes the directory from `~/dotvim/bundle/`.
- local: `voom` removes the symlink from `~/dotvim/bundle/`.

[1] `voom` performs a shallow clone of depth 1.  If you subsequently want a repo's full history, do `git pull --unshallow`.


  [pathogen]: https://github.com/tpope/vim-pathogen
  [vundle]: https://github.com/gmarik/vundle.vim
  [NeoBundle]: https://github.com/Shougo/neobundle.vim
  [vam]: https://github.com/MarcWeber/vim-addon-manager
  [vizadry]: https://github.com/ardagnir/vizardry


## Intellectual Property

Copyright Andrew Stewart.  Released under the MIT licence.

