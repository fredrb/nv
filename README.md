# Node Versioning

This is a lightweight alternative to [NVM](https://github.com/creationix/nvm). Node Versioning relies on a node installation folder and a symlink to a single node binaries folder in your path. This way the amount of tweaking in shell is minimized and only a couple of folders must be added to the `$PATH` variable.  

## Quick Install

```bash
wget -qO- https://raw.githubusercontent.com/fredrb/nv/master/install.sh | bash
```

This will download NV repository into `$HOME/.config/nv` and the following line to your `$HOME/.profile`:

```bash
export NV_CONFIG="$HOME/.config/nv"
export PATH="$PATH:$HOME/.config/nv/bin:$HOME/.config/nv/nbin"
```

You might need to run `source ~/.profile`. See [Login Shell](#login-shell).

### Installation Parameters

The default folders for installation can be overwritten by the following environment variables: 

- Configuration Folder: `$NV_CONFIG`
- Shell init file: `$NV_SHELL_FILE`

For example, the installation can be targeted to `$HOME/.node_versioning` and the path update to file `$HOME/.zprofile` using the following command:

```bash
wget -qO- https://raw.githubusercontent.com/fredrb/nv/master/install.sh | NV_CONFIG="$HOME/.ndenv" NV_SHELL_FILE="$HOME/.zprofile" bash

```

## Manual Installation

- Clone this repository 
- Create the folder `$HOME/.config/nv` where NodeJS dependencies will be installed 
- Add `nv.sh` to your path or create a symlink to somewhere like `$HOME/.local/bin` or `/usr/local/bin`

## Login Shell

Since the default `export` path is set to `$HOME/.profile`, `nv` relies on login-shells to access NodeJS binaries. As an alternative, you can export the path variable in interactive, non-login startup files (e.g. `.bashrc` or `.zshrc` ).

*Obs: You might need to `source ~/.profile` (or other shell file you installed into) in order to use `nv` in the same session*

## Design Goals

Node Versioning was designed to be the least intrusive as possible. The only two entry points needed to glue `nv` into your system are:

-  Environment variable `$NV_CONFIG`. This variable is used to map where are the node installations and the current installation symlink.
- Export to path of `$NV_CONFIG/current`

### Default Installation Folders

**$NV_CONFIG/bin:** This folder hold the bash executable for `nv` command

**$NV_CONFIG/current:** This is a symlink folder with current `node`, `npm` and any other executable from NodeJS modules.

**$NV_CONFIG/dist/<version>**: Node installed folder. 

## Contributing

- Keep in mind the [design goals](#design-goals).
- 2 space indentation (use editorconfig preferably)

## Usage

#### `nv list [option]`

This command lists all the downloaded versions of NodeJS and the current selected version

**Options:**

`-r|--remote`: List the currect releases for `latest`, `carbon`, `boron` and `argon`

#### `nv get [version]`

Downloads and installs a specific version of NodeJS. If no version specified, latest version will be downloaded

You can use the aliases for releases, such as `latest`, `carbon`, `boron` and `argon`.

#### `nv use <version>` 

Given an installed version of NodeJS, this command will create the symlink for the selected NodeJS version and installed packages.


#### `nv update`

Update `nv` command to newer version. This will download any updates in git repository and, if needed, run a post-install script.


