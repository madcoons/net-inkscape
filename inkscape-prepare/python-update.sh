#!/bin/bash
set -e

PY_VER=3.11

make_ld_launcher() {
    cat > "$2" <<EOF
#!/bin/sh
set -e

HERE="\$(dirname "\$(readlink -f "\${0}")")"
exec "\${HERE}/../../lib/x86_64-linux-gnu/ld-linux-x86-64.so.2" "\${HERE}/$1" "\$@"
EOF
    chmod a+x "$2"
}

(
    cd usr/bin
    rm python3
    make_ld_launcher "python${PY_VER}" python3
)
