<div align="center">

# asdf-container-use [![Build](https://github.com/cffnpwr/asdf-container-use/actions/workflows/build.yml/badge.svg)](https://github.com/cffnpwr/asdf-container-use/actions/workflows/build.yml) [![Lint](https://github.com/cffnpwr/asdf-container-use/actions/workflows/lint.yml/badge.svg)](https://github.com/cffnpwr/asdf-container-use/actions/workflows/lint.yml)

[container-use](https://github.com/dagger/container-use) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [asdf-container-use  ](#asdf-container-use--)
- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `git` for version management and repository operations.

# Install

Plugin:

```shell
asdf plugin add container-use
# or
asdf plugin add container-use https://github.com/cffnpwr/asdf-container-use.git
```

container-use:

```shell
# Show all installable versions
asdf list-all container-use

# Install specific version
asdf install container-use latest

# Set a version globally (on your ~/.tool-versions file)
asdf global container-use latest

# Now container-use commands are available
cu --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# License

See [LICENSE](LICENSE) © [cffnpwr](https://github.com/cffnpwr/)
