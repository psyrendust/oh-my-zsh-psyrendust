# oh my zsh psyrendust

Custom plugins and themes for [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) maintained by [psyrendust](https://github.com/psyrendust)

## Setup

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

## Plugins

Plugins can be found in the `oh-my-zsh-psyrendust/plugins` folder.

|                                 Plugins                                 |                                                              Description                                                               |
| :---------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------- |
| **[alias-grep.plugin.zsh](#alias-greppluginzsh)**                       | Filter your zsh aliases using regex.                                                                                                   |
| **[apache2.plugin.zsh](#apache2pluginzsh)**                             | Commands to control local apache2 server installation on Mac.                                                                          |
| **[git-psyrendust.plugin.zsh](#git-psyrendustpluginzsh)**               | Custom aliases for Git.                                                                                                                |
| **[grunt-autocomplete.plugin.zsh](#grunt-autocompletepluginzsh)**       | Zsh tab completion for GruntJS.                                                                                                        |
| **[kill-process.plugin.zsh](#killprocesspluginzsh)**                    | Kill a process by name.                                                                                                                |
| **[mkcd.plugin.zsh](#mkcdpluginzsh)**                                   | Make a directory (recursively) and cd into it.                                                                                         |
| **[npp.plugin.zsh](#npppluginzsh)**                                     | Notepad&#43;&#43; plugin.                                                                                                              |
| **[psyrendust-auto-update.plugin.zsh](#psyrendustautoupdatepluginzsh)** | Auto update plugin for this repo.                                                                                                      |
| **[refresh.plugin.zsh](#refreshupdatepluginzsh)**                       | Refresh the current folder. Helps when a network share disconnects temporarily.                                                        |
| **[sever.plugin.zsh](#severpluginzsh)**                                 | Start an HTTP server from a directory, optionally specifying the port.                                                                 |
| **[sublime.plugin.zsh](#sublimepluginzsh)**                             | Open path or files in Sublime Text 2. Uses a sleep command to fix a bug with ST2 opening with no files/folders showing in the sidebar. |

## Plugin Usage

### alias-grep.plugin.zsh

| Command |                                 Description                                 |                         Equivalent                        |
| :------ | :-------------------------------------------------------------------------- | :-------------------------------------------------------- |
| `ag`    | List all installed aliases or filter using regex                            | `alias` or <code>alias &#124; grep -e [pattern]</code>    |
| `agb`   | List all installed aliases or filter using regex at the start of the string | `alias` or <code>alias &#124; grep -e "^[pattern]"</code> |

#### Usage
List all aliases

```bash
ag
```

List all aliases that contain the substring `git`

```bash
ag git
```

List all aliases that start with the string `gs`

```bash
agb gs
```

---

### apache2.plugin.zsh

|     Command      |                Description                 |
| :--------------- | :----------------------------------------- |
| `apache2start`   | Start Apache                               |
| `apache2stop`    | Stop Apache                                |
| `apache2restart` | Restart Apache                             |
| `apache2load`    | Load Apache as a service using `launchd`   |
| `apache2unload`  | Remove Apache as a service using `launchd` |

---

### git-psyrendust.plugin.zsh

|   Command    |                         Shortcut                        |
| :----------- | :------------------------------------------------------ |
| `gass`       | `git update-index --assume-unchanged`                   |
| `gaa`        | `git add -A`                                            |
| `gun`        | `git reset && git checkout . && git clean -fdx`         |
| `gt`         | `git tag`                                               |
| `gta`        | `git tag -a`                                            |
| `gindex`     | `git rm --cached -r . && git reset --hard && git add .` |
| `gbfromhere` | `git checkout -b [newBranchName] [currentBranchName]`   |

---

### grunt-autocomplete.plugin.zsh

#### Usage
Start typing `gru` then hit `<tab>` for a list of 

```Bash
cmd
```

---

### mkcd.plugin.zsh

#### API
- `foo`: Bar

#### Usage
Something

```Bash
cmd
```

---

### npp.plugin.zsh

#### API
- `foo`: Bar

#### Usage
Something

```Bash
cmd
```

---

### psyrendust-auto-update.plugin.zsh

#### API
- `foo`: Bar

#### Usage
Something

```Bash
cmd
```

---

### sever.plugin.zsh

#### API
- `foo`: Bar

#### Usage
Something

```Bash
cmd
```

---

### sublime.plugin.zsh

#### API
- `foo`: Bar

#### Usage
Something

```Bash
cmd
```

---


## Themes

Themes can be found in the `oh-my-zsh-psyrendust/themes` folder.

| Themes | Description |
|:--------|:------------|
| **psyrendust.zsh-theme** | A custom [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) theme based off of [Bobby](https://github.com/revans/bash-it/blob/master/themes/bobby/bobby.theme.bash). |

## Known Bugs

 - Having issues getting `subl` to work as the git `core.editor` on Mac
 - Zsh prompt gets cut off for `scm_prompt_char` when using the font [`Inconsolata`](http://levien.com/type/myfonts/inconsolata.html) in CYGWIN

## Release History

 - 2013-07-17   v0.1.5   Fix issue #2. Add `alias-grep` plugin. Add `kill-process` plugin. Update README.md.
 - 2013-07-17   v0.1.4   Add `grunt-autocomplete` plugin. Add `psyrendust-auto-update` plugin. Fix bug for `server` plugin. Update `git-psyrendust` plugin.
 - 2013-07-02   v0.1.3   Add `AutoHotkeys` config. Bug fix for sublime.plugin.zsh. Added git reset alias.
 - 2013-07-02   v0.1.2   Add `npp` plugin.
 - 2013-07-02   v0.1.1   Add `mkcd` plugin. Added `git-psyrendust` plugin. Bug fixes.
 - 2013-06-27   v0.1.0   Initial release.

## License
Copyright (c) 2013 Larry Gordon
Licensed under the MIT license.
