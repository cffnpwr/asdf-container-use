#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/dagger/container-use"
TOOL_NAME="container-use"
TOOL_TEST="cu --help"

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

		# Set executable permission for cu binary
		chmod +x "$install_path/cu"

		# Ensure cu executable exists and is executable
		test -x "$install_path/cu" || fail "Expected $install_path/cu to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
