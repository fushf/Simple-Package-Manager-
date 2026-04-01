#!/bin/bash

PKG_DIR="./packages"
PKG_DB="./pkgdb"

install_pkg() {
    pkg="$1"
    tarball="$PKG_DIR/$pkg.tar.gz"

    if [ ! -f "$tarball" ]; then
        echo "Package $pkg not found!"
        return 1
    fi

    echo "Installing $pkg..."
    tar -xzf "$tarball" -C /
    echo "$pkg" >> "$PKG_DB"
    echo "$pkg installed."
}

remove_pkg() {
    pkg="$1"
    if ! grep -q "^$pkg\$" "$PKG_DB"; then
        echo "$pkg is not installed!"
        return 1
    fi

    echo "Removing $pkg..."
    # opcjonalnie: pakiety mogą mieć uninstall.sh
    if [ -f "/usr/local/$pkg/uninstall.sh" ]; then
        bash "/usr/local/$pkg/uninstall.sh"
    fi

    # usuń wpis z bazy
    grep -v "^$pkg\$" "$PKG_DB" > "${PKG_DB}.tmp"
    mv "${PKG_DB}.tmp" "$PKG_DB"

    echo "$pkg removed."
}

list_pkgs() {
    echo "Installed packages:"
    cat "$PKG_DB"
}

case "$1" in
    install) install_pkg "$2" ;;
    remove)  remove_pkg "$2" ;;
    list)    list_pkgs ;;
    *) echo "Usage: $0 {install|remove|list} package_name" ;;
esac
