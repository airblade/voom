# voom: a Vim plugin manager

voom is a simplest-thing-that-works way to manage your Vim plugins.  It's definitely simpler than git submodules.

It assumes:

- The plugins you use are on GitHub (or in-progress on disk).
- You use [Pathogen][] to manage Vim's runtime path.


## How Does It Work?

You declare your plugins in `repos`, a plain-text file you add to your dotvim repo.  Here's an example:

```
# Comments start with a hash character.
airblade/vim-gitgutter
tpope/vim-fugitive
```

Create a directory to hold all your plugins (default: `~/dotvim/src`) and `.gitignore` it.

Empty out your `bundle/` directory and `.gitignore` it.

Now you can install your plugins with:

```sh
$ voom install
```

This clones each plugin declared in `repos` into `~/dotvim/src` and symlinks each to `~/dotvim/bundle/`.

To uninstall a plugin, remove it from `repos` and run:

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


## What About Plugins I'm Hacking On?

If you're working on a plugin, you don't want to install it from GitHub; you want to use your local copy.  To do this, manually symlink your plugin into `bundle/`.  There's no need to add it to `repos`.  E.g.

```sh
$ ln -nfs ~/code/src/vim-newhotness ~/dotvim/bundle/vim-newhotness
```


## Installation

Put `voom` somewhere on your `PATH`.  Adjust the directory locations in the script if you need.

Empty your `~/dotvim/bundle/` directory and add `bundle/` to `.gitignore`.

Create the `~/dotvim/src/` (or wherever) directory and add it to `.gitignore`.

Declare your plugins in `repos` and add the file to your repo.


## To do (maybe)

- Instead of (1) editing `repos` and (2) running `voom`, get `voom` to update `repos`.
- Support SHAs in plugin declarations in `repos`.  E.g. `foo/bar@abc123`.

  [pathogen]: https://github.com/tpope/vim-pathogen
