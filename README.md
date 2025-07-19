# asdf-container-use

[asdf](https://github.com/asdf-vm/asdf) plugin for [container-use](https://github.com/dagger/container-use).

## Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities
- `git`: required for downloading from GitHub

## Install

Plugin:

```shell
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
container-use --help
```

## Binary naming

- **v0.1.x**: Uses `cu` as the main binary name with `container-use` symlink for compatibility
- **v0.2.0+**: Uses `container-use` as the main binary name with `cu` symlink for convenience

Both commands are available regardless of version for consistency.

## Usage

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions.

## Contributing

Contributions of any kind are welcome! See the [contributing guide](../../blob/main/contributing.md).

[Thanks goes to these contributors](../../graphs/contributors)!

## License

See [LICENSE](LICENSE) © [cffnpwr](https://github.com/cffnpwr/)
