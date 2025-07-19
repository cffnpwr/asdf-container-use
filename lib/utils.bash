#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/dagger/container-use"
TOOL_NAME="container-use"
TOOL_TEST="container-use --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if <YOUR TOOL> is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if <YOUR TOOL> has other means of determining installable versions.
	list_github_tags
}

detect_os() {
	case "$(uname -s)" in
		Darwin*) echo "Darwin" ;;
		Linux*) echo "Linux" ;;
		*) fail "Unsupported OS: $(uname -s)" ;;
	esac
}

detect_arch() {
	case "$(uname -m)" in
		x86_64) echo "amd64" ;;
		aarch64 | arm64) echo "arm64" ;;
		*) fail "Unsupported architecture: $(uname -m)" ;;
	esac
}

download_release() {
	local version filename url os arch
	version="$1"
	filename="$2"
	os="$(detect_os | tr '[:upper:]' '[:lower:]')"
	arch="$(detect_arch)"

	url="$GH_REPO/releases/download/v${version}/container-use_v${version}_${os}_${arch}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

version_lt() {
	printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1 | grep -q "^$1$"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# Determine binary name based on version
		# v0.1.x uses 'cu', v0.2.0+ uses 'container-use'
		if version_lt "$version" "0.2.0"; then
			# v0.1.x: binary is named 'cu'
			chmod +x "$install_path/cu"
			# Create container-use symlink for consistency
			ln -sf "cu" "$install_path/container-use"
			test -x "$install_path/cu" || fail "Expected $install_path/cu to be executable."
		else
			# v0.2.0+: binary is named 'container-use'
			chmod +x "$install_path/container-use"
			# Create cu symlink for convenience
			ln -sf "container-use" "$install_path/cu"
			test -x "$install_path/container-use" || fail "Expected $install_path/container-use to be executable."
		fi

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
