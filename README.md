# voom: a Vim plugin manager

voom is a simplest-thing-that-works way to manage your Vim plugins.

It assumes:

- The plugins you use are on GitHub (or in-progress on disk).
- You use [Pathogen][] to manage Vim's runtime path.

voom is an alternative to [Vundle][], [NeoBundle][], [vam][], [Vizadry][], etc.

Features:

* Fast.
* Lightweight (<100 lines bash).
* No git submodules :)


## How Does It Work?

You declare your plugins in `plugins`, a plain-text file you add to your dotvim repo.  Here's an example:

```
# Comments start with a hash character.
# Note the plugin declarations are case-sensitive.

# Declare repos on GitHub with: username/repo.
airblade/vim-gitgutter
tpope/vim-fugitive

# Declare repos on your file system with the absolute path.
~/code/src/vim-rooter
```

Create a directory to hold all your plugins (default: `~/dotvim/src`) and `.gitignore` it.

Empty out your `bundle/` directory and `.gitignore` it.

Now you can install your plugins with:

```sh
$ voom install
```

This clones each GitHub-hosted plugin declared in `plugins` into `~/dotvim/src` and symlinks all the sources to `~/dotvim/bundle/`.

To uninstall a plugin, remove it from `plugins` and run:

```sh
$ voom clean
```

To update your plugins:

```sh
$ voom update
```

If you just want to update one plugin:

```sh
$ voom update vim-gitgutter
```

Finally, to see which plugins are out of date (i.e. to see what would happen if you ran `voom update`):

```sh
$ voom outdated
```

Again, you can pass a plugin name if you just want to focus on a single plugin.


## Installation

Put `voom` somewhere on your `PATH`.  Adjust the directory locations in the script if you need.

Empty your `~/dotvim/bundle/` directory and add `bundle/` to `.gitignore`.

Create the `~/dotvim/src/` (or wherever) directory and add it to `.gitignore`.

Declare your plugins in `plugins` and add the file to your repo.


## To do (maybe)

- Instead of (1) editing `plugins` and (2) running `voom`, get `voom` to update `plugins`.
- Support SHAs in plugin declarations in `plugins`.  E.g. `foo/bar@abc123`.
- Speed up `voom install` by passing `--depth 1` to `git clone`.

  [pathogen]: https://github.com/tpope/vim-pathogen
  [vundle]: https://github.com/gmarik/vundle.vim
  [NeoBundle]: https://github.com/Shougo/neobundle.vim
  [vam]: https://github.com/MarcWeber/vim-addon-manager
  [vizadry]: https://github.com/ardagnir/vizardry


## Intellectual Property

Copyright Andrew Stewart.  Released under the MIT licence.

