#!/bin/bash
#
# Run this script after the first cvs checkout to build
# makefiles and friends

PATH="/usr/pack/automake-1.13.2-to/amd64-linux-ubuntu8.04/bin:/usr/pack/gettext-0.18.2.1-to/amd64-linux-ubuntu8.04/bin:$PATH"
export PATH

vcheck (){
  perl <<PERL
@t = split /\./, "$1";
@v = map { int \$_ } split /\./, (split /\s+/, \`$2\`)[3];
print "$2 = ", (join ".",@v), "  (expecting $1 or later)\n";
\$v = \$t[0]*1000000+\$t[1]*1000+\$t[2] <= \$v[0]*1000000+\$v[1]*1000+\$v[2];
exit \$v
PERL
}

ERROR=0
LIBTOOL_VER="1.5.6"
AUTOMAKE_VER="1.9.2"
AUTOCONF_VER="2.59"
LIBTOOL_BIN="libtool"

# On MAC OS X, GNU libtool is named 'glibtool':
if [ `(uname -s) 2>/dev/null` == 'Darwin' ]
then
  LIBTOOL_BIN="glibtool"
fi

if vcheck $LIBTOOL_VER "$LIBTOOL_BIN --version"
then
  echo "get a copy of GNU libtool >= $LIBTOOL_VER"
  ERROR=1
fi

if vcheck $AUTOMAKE_VER  "automake  --version"
then
  if vcheck $AUTOMAKE_VER  "automake-1.11 --version"
  then
    echo "get a copy of GNU automake >= $AUTOMAKE_VER"
    ERROR=1
  else
    AUTOMAKE="automake-1.11"
    ACLOCAL="aclocal-1.11"
    export AUTOMAKE ACLOCAL
  fi
fi


if vcheck $AUTOCONF_VER "autoconf --version"
then
  echo "get a copy of GNU autoconf >= $autoconf_ver"
  ERROR=1
fi

if [ $ERROR -ne 0 ]
then
  exit 1
fi

./autogen.sh

# vim: set syntax=sh :
