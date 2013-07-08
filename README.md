oh my zsh psyrendust
====================

Custom plugins and themes for [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) maintained by [psyrendust](https://github.com/psyrendust)

Usage
-----

Clone oh-my-zsh to your home folder:

```shell
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
```

Create a new zsh config by copying the zsh template we’ve provided:

```shell
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

Set zsh as your default shell:

```shell
chsh -s /bin/zsh
```

Clone oh-my-zsh-psyrendust to your home folder

```shell
git clone https://github.com/psyrendust/oh-my-zsh-psyrendust.git ~/.oh-my-zsh-psyrendust
```

Edit your `~/.zshrc` file with your favorite editor and edit the following:

```shell
ZSH_THEME="psyrendust"
ZSH_CUSTOM="$HOME/.oh-my-zsh-psyrendust"
```

You can add the plugins that you would like to load:

```shell
plugins=(apache2 server sublime)
```

Start / restart zsh (open a new terminal is easy enough…)

Plugins
-----
Plugins can be found in the `oh-my-zsh-psyrendust/plugins` folder.

| Plugins | Description |
|:--------|:------------|
| **apache2.plugin.zsh**        | Commands to control local apache2 server installation on Mac. |
| **git-psyrendust.plugin.zsh** | Custom aliases for Git. |
| **mkcd.plugin.zsh**           | Make a directory (recursively) and cd into it. |
| **npp.plugin.zsh**            | Notepad++ plugin. |
| **sever.plugin.zsh**          | Start an HTTP server from a directory, optionally specifying the port. |
| **sublime.plugin.zsh**        | Open path or files in Sublime Text 2. Uses a sleep command to fix a bug with ST2 opening with no files/folders showing in the sidebar. |

Themes
-----
Themes can be found in the `oh-my-zsh-psyrendust/themes` folder.

| Themes | Description |
|:--------|:------------|
| **psyrendust.zsh-theme** | A custom [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) theme based off of [Bobby](https://github.com/revans/bash-it/blob/master/themes/bobby/bobby.theme.bash). |

Known Bugs
-----
 - Having issues getting `subl` to work as the git `core.editor` on Mac
 - Zsh prompt gets cut off for `scm_prompt_char` when using the font [`Inconsolata`](http://levien.com/type/myfonts/inconsolata.html) in CYGWIN

Release History
-----
 - 2013-07-02   v0.1.3   Added `AutoHotkeys` config. Bug fix for sublime.plugin.zsh. Added git reset alias.
 - 2013-07-02   v0.1.2   Added `npp` plugin.
 - 2013-07-02   v0.1.1   Added `mkcd` plugin. Added `git-psyrendust` plugin. Bug fixes.
 - 2013-06-27   v0.1.0   Initial release.

## License
Copyright (c) 2013 Larry Gordon
Licensed under the MIT license.
