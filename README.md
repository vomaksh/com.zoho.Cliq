# vomaksh/com.zoho.Cliq

This repository contains the Flatpak packaging for Zoho Cliq, a team communication and collaboration app. By containerizing Zoho Cliq as a Flatpak, you can easily install and run the application across various Linux distributions.

## Prerequisites

Before you begin, ensure you have the following installed on your system from your package manager:

- flatpak
- flatpak-builder

## How to build?

```sh
flatpak-builder --user --install-deps-from=flathub --install --force-clean build cliq.yaml
```

## How to Install?

```sh
flatpak run com.zoho.Cliq
```

## How to Uninstall?

```sh
flatpak remove com.zoho.Cliq
```

## Contributing

Contributions are welcome! If you encounter issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## Todos

- [ ] Add build script (above build section needs more prerequisities)
- [ ] Add GitHub workflow which creates flatpak builds
