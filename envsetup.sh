source build/envsetup.sh

export LANG=en_US.UTF-8
export _JAVA_OPTIONS=-XX:-UsePerfData
export BUILD_NUMBER=$(cat out/build_number.txt 2>/dev/null || date -u +%Y.%m.%d.%H)
echo "BUILD_NUMBER=$BUILD_NUMBER"
export DISPLAY_BUILD_NUMBER=true
chrt -b -p 0 $$

if [ -z $OLDPATH ]; then # Save old path variable
    export OLDPATH=$PATH
else
    export PATH=$OLDPATH
fi

export PATH="$PWD/script/bin:$PATH"
export BUILD_USERNAME=grapheneos
export BUILD_HOSTNAME=grapheneos

# Fix building on Gentoo
if [ -f "/etc/gentoo-release" ]; then
    source script/python-eselect.in
    echo "[DEBUG] Applying Gentoo fixes/workarounds"
    unset JAVAC

    preferred_py3_versions=($(get_installed_pythons "${@}" --py3))
    preferred_py3_version=${preferred_py3_versions[@]:0:1}

    echo "[DEBUG] using $preferred_py3_version for python3"

    if [ ! -d "/usr/lib/python-exec/$preferred_py3_version" ]; then
        echo "[DEBUG] $preferred_py3_version not found, this may have unexpected results"
        return 1
    fi

    if [ ! -d "/usr/lib/python-exec/python2.7" ]; then
        echo "[DEBUG] python2.7 not found, this may have unexpected results"
        return 1
    fi

    export PATH="/usr/lib/python-exec/python2.7:/usr/lib/python-exec/$preferred_py3_version:$PATH" # Python 2.7 first, then 3.x
fi
