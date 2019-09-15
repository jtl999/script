source build/envsetup.sh

export LANG=en_US.UTF-8
export _JAVA_OPTIONS=-XX:-UsePerfData
export BUILD_NUMBER=$(cat out/build_number.txt 2>/dev/null || date -u +%Y.%m.%d.%H)
echo "BUILD_NUMBER=$BUILD_NUMBER"
export DISPLAY_BUILD_NUMBER=true
chrt -b -p 0 $$
export PATH="$PWD/script/bin:$PATH"
export BUILD_USERNAME=grapheneos
export BUILD_HOSTNAME=grapheneos

# Fix building on Gentoo
if test -f "/etc/gentoo-release"; then
    echo "[DEBUG] Applying Gentoo fix"
    set -x
    unset JAVAC

    if [ -z $OLDPATH ]; then
        export OLDPATH=$PATH
    else
        export PATH=$OLDPATH
    fi

    export PATH="/usr/lib/python-exec/python2.7:/usr/lib/python-exec/python3.7:$PATH" # Python 2.7 first, then 3.x
    export EPYTHON=python2.7
    set +x
fi
