#!/bin/bash

indir="/home/kah/env/" # Installation prefix
dldir=$PWD"/tmp" # Directory to download archives to

OLDPYTHON=true # Python2.7 is necessary for ODB Python binding
PROJ4=true
SWIG=true # Used for python binding in ODB
LIBPNG=true
ZLIB=true
SZIP=true # For HDF5 compression
JPEG=true
JASPER=true
HDF5=true # Dependency for netcdf and eccodes
NETCDFC=false # Not a required dependency, but nice to have
NETCDFFORTRAN=false # Not a required dependency, but nice to have
ECCODES=true # A must have and dependency to ODB
ODB=false
MAGIGS=false


# THERE IS NO NEED TO TOUCH ANYTHING BELOW THIS #

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

# Headers and  Logging
e_header() { printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@"
}
e_arrow() { printf "➜ $@\n"
}
e_success() { printf "${green}✔ %s${reset}\n" "$@"
}
e_error() { printf "${red}✖ %s${reset}\n" "$@"
}
e_warning() { printf "${tan}➜ %s${reset}\n" "$@"
}
e_underline() { printf "${underline}${bold}%s${reset}\n" "$@"
}
e_bold() { printf "${bold}%s${reset}\n" "$@"
}
e_note() { printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"
}

seek_confirmation() {
  printf "\n${bold}$@${reset}"
  read -p " (y/n) " -n 1
  printf "\n"
}

# Test whether the result of an 'ask' is a confirmation
is_confirmed() {
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  return 0
fi
return 1
}

e_header "BASH INSTALLATION SCRIPT OF ECCODES AND DEPENDENCIES"

if [ $OLDPYTHON == false ] ; then
  e_warning "oldpython (python2.7) is set to false"
else
  e_success "oldpython (python2.7) is set to true"
fi

if [ $PROJ4 == false ] ; then
  e_warning "proj4 is set to false"
else
  e_success "proj4 is set to true"
fi

if [ $SWIG == false ] ; then
  e_warning "swig is set to false"
else
  e_success "swig is set to true"
fi

if [ $LIBPNG == false ] ; then
  e_warning "libpng is set to false"
else
  e_success "libpng is set to true"
fi

if [ $ZLIB == false ] ; then
  e_warning "zlib is set to false"
else
  e_success "zlib is set to true"
fi

if [ $SZIP == false ] ; then
  e_warning "szip is set to false"
else
  e_success "szip is set to true"
fi

if [ $JPEG == false ] ; then
  e_warning "jpeg is set to false"
else
  e_success "jpeg is set to true"
fi

if [ $JASPER == false ] ; then
  e_warning "jasper is set to false"
else
  e_success "jasper is set to true"
fi

if [ $HDF5 == false ] ; then
  e_warning "hdf5 is set to false"
else
  e_success "hdf5 is set to true"
fi

if [ $NETCDFC == false ] ; then
  e_warning "netcdf-c is set to false"
else
  e_success "netcdf-c is set to true"
fi

if [ $NETCDFFORTRAN == false ] ; then
  e_warning "netcdf-Fortran is set to false"
else
  e_success "netcdf-Fortran is set to true"
fi

if [ $ECCODES == false ] ; then
  e_warning "eccodes is set to false"
else
  e_success "eccodes is set to true"
fi

if [ $ODB == false ] ; then
  e_warning "odb is set to false"
else
  e_success "odb is set to true"
fi

if [ $MAGIGS == false ] ; then
  e_warning "magics is set to false"
else
  e_success "magics is set to true"
fi

seek_confirmation "This will (try to) install the dependencies for ECCODES. Do you want to continue?"
if is_confirmed; then
  e_success "Ok, continuing"
  continue_install=true
else
  e_error "Ok, stopping then"
  continue_install=false
  exit 1
fi

test_for_package () {
  package=$1
  PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $package|grep "install ok installed")
  echo Checking for $package: $PKG_OK
  if [ "" == "$PKG_OK" ]; then
    echo "No $package. Setting up $package."
    sudo apt-get --force-yes --yes install $package
  fi
}

oldpython_url='https://www.python.org/ftp/python/2.7.17/Python-2.7.17.tar.xz'
proj4_url='https://download.osgeo.org/proj/proj-6.2.1.tar.gz'
proj4datum_url='https://download.osgeo.org/proj/proj-datumgrid-1.8.zip'
swig_url='http://prdownloads.sourceforge.net/swig/swig-4.0.1.tar.gz'
libpng_url='https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz'
zlib_url='https://www.zlib.net/zlib-1.2.11.tar.gz'
szip_url='https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz'
jpeg_url='https://sourceforge.net/projects/libjpeg/files/libjpeg/6b/jpegsrc.v6b.tar.gz'
jasper_url='http://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.14.tar.gz'
hdf5_url='https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz'
netcdf_c_url='https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.3.tar.gz'
netcdf_fortran_url='https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.2.tar.gz'
eccodes_url='https://confluence.ecmwf.int/download/attachments/45757960/eccodes-2.13.1-Source.tar.gz'
odb_url='https://confluence.ecmwf.int/download/attachments/61117379/odb_api_bundle-0.18.1-Source.tar.gz'
magics_url='https://confluence.ecmwf.int/download/attachments/3473464/Magics-4.2.3-Source.tar.gz'
pip_url='https://bootstrap.pypa.io/get-pip.py'

if [ $continue_install == true ] ; then
  e_note "Starting installation..."

echo " "
echo "          _nnnn_                             "
echo "         dGGGGMMb      ,....................."
echo "        @p~qp~~qMb     | grab some coffee,  |"
echo "        M|@||@) M|   __| while we compile.  |"
echo "        @,----.JM| -'  ..................... "
echo "       JS^\__/  qKL                          "
echo "      dZP        qKRb                        "
echo "     dZP          qKKb                       "
echo "    fZP            SMMb                      "
echo "    HZM            MMMM                      "
echo "    FqM            MMMM                      "
echo "   __| ..        |\dS.qML                    "
echo "  |    -.       | -. \Zq                     "
echo "_)      \.___.,|     ..                      "
echo "\____   )MMMMMM|    ..                       "
echo "     .--       .--- hjm                      "
echo " "
echo " "

#  e_note "Make sure that your current python environment is 2.7"
#  e_note "ODB API does not yet support python3"

  sleep 2

  mkdir -p $indir
  mkdir -p $dldir
  cd $dldir
fi


if [ $continue_install == true ] ; then


  test_for_package "cmake"
  test_for_package "gdal-bin"
  test_for_package "libproj-dev"
  test_for_package "binutils"
  test_for_package "gfortran"
  test_for_package "bison"
  test_for_package "flex"
  test_for_package "libncurses5-dev"
  test_for_package "flex"
  test_for_package "libblas-dev" # Dependency for ODB
  test_for_package "liblapack-dev" # Dependency for ODB
  test_for_package "libssl-dev"
  test_for_package "libcurl4"
  test_for_package "libcurl4-openssl-dev"
  test_for_package "libqt5webkit5"
  test_for_package "libgtk2.0-dev"
  test_for_package "libpango1.0-dev"
  test_for_package "libglib2.0-dev"
  test_for_package "libcairo2-dev"
  test_for_package "libboost-all-dev"
  test_for_package "libexpat1-dev"
  test_for_package "qtbase5-dev"
  test_for_package "sqlite3" # Dependency for PROJ4
  test_for_package "libsqlite3-dev" # Dependency for PROJ4

  export PYTHON_BASE=$indir

  # EXPORT FLAGS FOR COMPILATION
  export CPPFLAGS=-I/$indir/include
  export LDFLAGS=-L/$indir/lib
  export LD_LIBRARY_PATH=$indir/lib:$LD_LIBRARY_PATH

  export PATH=$PYTHON_BASE/bin:$PATH # Needed to overwrite the default Python executable

  if [ $OLDPYTHON == true ] ; then
    e_arrow "Fetching Python2 from the Museum"
    wget --no-clobber $oldpython_url
    tar --keep-old-files -xf Python-2.7.17.tar.xz
    cd Python-2.7.17
    ./configure --prefix=$PYTHON_BASE --enable-shared LDFLAGS="-Wl,-rpath=$PYTHON_PREFIX/lib"
    make
    make install
    cd $dldir

    curl $pip_url -o get-pip.py
    $indir/bin/python2 get-pip.py
    yes | $indir/bin/pip2 install jinja2
    yes | $indir/bin/pip2 install numpy

  fi

  # SWIG
  if [ $PROJ4 == true ] ; then
    e_arrow "Fetching PROJ4"
    wget --no-clobber $proj4_url
    tar --keep-old-files -xf proj-6.2.1.tar.gz
    mkdir -p $dldir/proj_build
    cd $dldir/proj_build
    cmake -DCMAKE_INSTALL_PREFIX=$indir ../proj-6.2.1
    make
    make install
    cd $dldir
  fi

  # SWIG
  if [ $SWIG == true ] ; then
    e_arrow "Fetching SWIG"
    wget --no-clobber $swig_url
    tar --keep-old-files -xf swig-4.0.1.tar.gz
    cd swig-4.0.1
    ./configure --prefix=$indir
    make
    make install
    cd $dldir
  fi

  # LIBPNG
  if [ $LIBPNG == true ] ; then
    e_arrow "Fetching libpng"
    wget --no-clobber $libpng_url
    tar --keep-old-files -xf libpng-1.6.37.tar.gz
    cd libpng-1.6.37
    ./configure --prefix=$indir
    make
    make install
    cd $dldir
  fi

  # ZLIB
  if [ $ZLIB == true ] ; then
    e_arrow "Fetching zlib"
    wget --no-clobber $zlib_url
    tar --keep-old-files -xf zlib-1.2.11.tar.gz
    cd zlib-1.2.11
    ./configure --prefix=$indir
    make
    make install
    cd $dldir
  fi

  # SZIP
  if [ $SZIP == true ] ; then
    e_arrow "Fetching slib"
    wget --no-clobber $szip_url
    tar --keep-old-files -xf szip-2.1.1.tar.gz
    cd szip-2.1.1
    ./configure --prefix=$indir
    make
    make install
    cd $dldir
  fi

  # JPEG
  if [ $JPEG == true ] ; then
    e_arrow "Fetching jpeg"
    wget --no-clobber $jpeg_url
    tar --keep-old-files -xf jpegsrc.v6b.tar.gz
    mkdir -p $indir/man/man1/ #Fix for stupid naming convention
    cd jpeg-6b
    ./configure --prefix=$indir
    make
    make install
    cd $dldir
  fi

  # JPEG
  if [ $JASPER == true ] ; then
    e_arrow "Fetching jasper"
    wget --no-clobber $jasper_url
    tar --keep-old-files -xf jasper-2.0.14.tar.gz
    mkdir -p $dldir/jasper_build
    cd $dldir/jasper_build
    cmake -DCMAKE_INSTALL_PREFIX=$indir ../jasper-2.0.14
    make
    make install
    cd $dldir
  fi

  # HDF5
  if [ $HDF5 == true ] ; then
    e_arrow "Fetching hdf5"
    wget --no-clobber $hdf5_url
    tar --keep-old-files -xf hdf5-1.10.5.tar.gz
    cd hdf5-1.10.5
    ./configure --prefix=$indir CPPFLAGS=-I/$indir/include LDFLAGS=-L/$indir/lib
    make
    make install
    cd $dldir
  fi

  # NETCDF-C
  if [ $NETCDFC == true ] ; then
    e_arrow "Fetching netcdf-c"
    wget --no-clobber $netcdf_c_url
    tar --keep-old-files -xf netcdf-c-4.7.3.tar.gz
    cd netcdf-c-4.7.3
    ./configure --prefix=$indir --disable-dap CPPFLAGS="-I/$indir/include" LDFLAGS="-L/$indir/lib"
    make
    make install
    cd $dldir
  fi

  # NETCDF-FORTRAN
  if [ $NETCDFFORTRAN == true ] ; then
    e_arrow "Fetching netcdf-fortran"
    wget --no-clobber $netcdf_fortran_url
    tar --keep-old-files -xf netcdf-fortran-4.5.2.tar.gz
    cd netcdf-fortran-4.5.2
    ./configure --prefix=$indir CPPFLAGS=-I/$indir/include LDFLAGS=-L/$indir/lib
    make
    make install
    cd $dldir
  fi

  # ECCODES
  if [ $ECCODES == true ] ; then
    export CPPFLAGS=-I/$indir/include
    export LDFLAGS=-L/$indir/lib
    e_arrow "Fetching eccodes"
    wget --no-clobber $eccodes_url
    tar --keep-old-files -xf eccodes-2.13.1-Source.tar.gz
    mkdir -p $dldir/ec_build
    cd $dldir/ec_build
    cmake -DCMAKE_INSTALL_PREFIX=$indir -DENABLE_JPG=OFF -DENABLE_PYTHON=OFF -DENABLE_NETCDF=ON ../eccodes-2.13.1-Source
    make
    make install
    cd $dldir
  fi

  # ODB
  if [ $ODB == true ] ; then
    export CPPFLAGS="-I/$indir/include"
    export LDFLAGS="-L/$indir/lib"
    export LD_LIBRARY_PATH="$indir/lib:$LD_LIBRARY_PATH"
    e_arrow "Fetching odb"
    e_note "LD_LIBRARY_PATH is:"
    echo $LD_LIBRARY_PATH
    wget --no-clobber $odb_url
    tar --keep-old-files -xf odb_api_bundle-0.18.1-Source.tar.gz
    mkdir -p $dldir/odb_build
    cd $dldir/odb_build
    cmake -DCMAKE_INSTALL_PREFIX=$indir -DENABLE_PYTHON=ON -DENABLE_FORTRAN=ON ../odb_api_bundle-0.18.1-Source
    make
    make install
    cd $dldir
  fi

  # MAGIGS
  if [ $MAGIGS == true ] ; then
    export CPPFLAGS="-I/$indir/include"
    export LDFLAGS="-L/$indir/lib"
    export LD_LIBRARY_PATH="$indir/lib:$LD_LIBRARY_PATH"
    e_arrow "Fetching magics"
    e_note "LD_LIBRARY_PATH is:"
    echo $LD_LIBRARY_PATH
    wget --no-clobber $magics_url
    tar --keep-old-files -xf Magics-4.2.3-Source.tar.gz
    mkdir -p $dldir/magics_build
    cd $dldir/magics_build
    cmake -DCMAKE_INSTALL_PREFIX=$indir -DECCODES_PATH=$indir -DENABLE_ODB=ON -DODB_API_PATH=$indir -DENABLE_METVIEW=ON -DENABLE_NETCDF=ON -DNETCDF_PATH=$indir ../Magics-4.2.3-Source
    make
    make install
    cd $dldir
  fi

  e_note "Remember to set LD_LIBRARY_PATH to $indir/lib"
  e_success "Finished"

fi
