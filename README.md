guacamole-server-debian
=======================

Packaging scripts for building guacamole-server from source on debian

## Synopsis

```sh
git clone https://github.com/grncdr/guacamole-server-debian.git
cd guacamole-server-debian
./build.sh
sudo dpkg -i *.deb
```

## License

MIT

## Acknowledgements

The debian configuration was taken almost directly from the `debian` branch of
[`guacamole-server`](https://github.com/glyptodon/guacamole-server) repo. It's
my hope that this will be a temporary measure and this repository will be
adopted and maintained as the canonical build process for Guacamole.
