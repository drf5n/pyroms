#!/bin/sh

#DESTDIR=/usr/local
DESTDIR=/u1/uaf/kate/Python
CURDIR=`pwd`

echo
echo "installing pyroms..."
echo
python setup.py install --prefix=$DESTDIR
echo "installing external libraries..."
echo "installing gridgen..."
cd $CURDIR/external/nn
./configure --prefix=$DESTDIR
make install
cd $CURDIR/external/csa
./configure --prefix=$DESTDIR
make install
cd $CURDIR/external/gridutils
CPPFLAGS=-I$DESTDIR/include LDFLAGS=-L$DESTDIR/lib ./configure --prefix=$DESTDIR
make install
cd $CURDIR/external/gridgen
CPPFLAGS=-I$DESTDIR/include CFLAGS=-I$DESTDIR/include ./configure --prefix=$DESTDIR
make
make lib
make shlib
make install
PYROMS_PATH=`python -c 'import pyroms ; print pyroms.__path__[0]'`
cp libgridgen.so $PYROMS_PATH
#cp $LOCALDIR/lib/libgridgen.so $PYROMS_PATH
echo "installing scrip..."
cd $CURDIR/external/scrip/source
perl -pe "s#\/usr\/local#$DESTDIR#" makefile > makefile2
make -f makefile2
make -f makefile2 f2py
make -f makefile2 install
#cp $LOCALDIR/lib/scrip.so $PYROMS_PATH/remapping
cp scrip.so $PYROMS_PATH/remapping
cd $CURDIR
echo
echo "Done installing pyroms..."
echo "pyroms make use of the so-called gridid file to store"
echo "grid information like the path to the grid file, the"
echo "number of vertical level, the vertical transformation"
echo "use, ..."
echo "Please set the environment variable PYROMS_GRIDID_FILE"
echo "to point to your gridid file. A gridid file template"
echo "is available here:"
echo "$LOCALDIR/python/pyroms/pyroms/gridid.txt"
read -p "Press any key to continue or Ctrl+C to quit this install"
echo
