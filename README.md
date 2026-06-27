# unraid-liquidctl

An Unraid plugin that installs a self-contained [liquidctl](https://github.com/liquidctl/liquidctl) executable and provides configuration at `/Settings/liquidctl` under **Settings > User Utilities**.

## How it works

- The release bundle contains liquidctl 1.16.0, Python, and its Python dependencies in one PyInstaller executable.
- The bundle is extracted to `/usr/local/emhttp/plugins/liquidctl` at install and after each reboot.
- `/usr/local/bin/liquidctl` links to the bundled executable.
- Settings persist in `/boot/config/plugins/liquidctl`.
- The Unraid `started` event applies configured commands when enabled.
- The settings page can discover devices and run the configured commands immediately.

Unraid does not need Python, pip, a compiler, or a virtual environment.

## Build

The Linux release bundle must be built on Linux. GitHub Actions runs the build in a Debian Bullseye Python container for broad glibc compatibility:

```text
Actions > build > Run workflow
```

Download the `liquidctl-unraid` artifact and place its `.tgz` file in `dist/`.

To build directly on Linux instead:

```bash
VERSION=2026.06.27.1 PYTHON=python3 ./scripts/build-release.sh
```

## Local Unraid test

After the `2026.06.27.1` GitHub release exists, copy the repository to `/mnt/user/temp/plugins/liquidctl`, then run:

```bash
installplg /mnt/user/temp/plugins/liquidctl/liquidctl.plg
liquidctl --version
liquidctl list --verbose
```

The locally opened manifest downloads its matching bundle from the GitHub release.

Open `/Settings/liquidctl` in the Unraid web interface.

## Install from GitHub

After publishing the `2026.06.27.1` release, install this URL from **Plugins > Install Plugin**:

```text
https://github.com/SkippyTheLost/unraid-liquidctl/releases/latest/download/liquidctl.plg
```

Creating the matching `2026.06.27.1` Git tag runs the build and publishes both required release assets automatically.

## Startup commands

Enter one liquidctl command per line without the leading executable name:

```text
initialize all
set fan speed 40
set pump speed 80
```

Use liquidctl selection arguments such as `--match`, `--vendor`, or `--product` in **Global arguments** when commands should target a particular device.
