# Node Versioning

This is a lightweight alternative to NVM. 

### Install NV
```bash
wget -qO- https://bitbucket.org/fredericorb/nv/raw/525d6a81a3c8f2ac9cb36b97d632e482ff4b83ff/install.sh | bash
```

This will download NV repository into `$HOME/.config/nv` and the following line to your `$HOME/.profile`:

```
export PATH="$PATH:$HOME/.config/nv/bin:$HOME/.config/nv/nbin"
```

**.config/nv/bin:** This folder hold the bash executable for `nv` command

**.config/nv/nbin:** This is a symlink folder with current `node`, `npm` and any other executable from NodeJS modules.

#### Manual installation

- Clone this repository 
- Create the folder `$HOME/.config/nv` where NodeJS dependencies will be installed 
- Add `nv.sh` to your path or create a symlink to somewhere like `$HOME/.local/bin` or `/usr/local/bin`

### Usage 

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

Update `nv` command to newer version. This will download any updates in git repository and, if needed, run a postinstall script.


