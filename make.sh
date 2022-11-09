#!/bin/bash
set -x -e

CC=clang
CPP=clang++
AR=ar
STRIP=strip
CFLAGS=-static

CURDIR="$(pwd)"
LIBDIR="$CURDIR/lib"
INCLUDEDIR="$LIBDIR/include"
LIBOUTDIR="$LIBDIR/lib"
BINDIR="$CURDIR/bin"

mkdir -p "$LIBOUTDIR" "$BINDIR"

cd "$CURDIR/logging/liblog"
case "$OSTYPE" in
  linux* | darwin*)
    src="event_tag_map.cpp"
  ;;
  *)
  ;;
esac
$CC -std=c++17 -I"$INCLUDEDIR" -Iinclude -I"$LIBDIR/base/include" -DLIBLOG_LOG_TAG=1006 -DSNET_EVENT_LOG_TAG=1397638484 ${CFLAGS} -c log_event_list.cpp log_event_write.cpp logger_name.cpp logger_read.cpp logger_write.cpp logprint.cpp properties.cpp ${src}
$AR rcs "$LIBOUTDIR/liblog.a" *.o
rm -r *.o
unset src

cd "$LIBDIR/zlib"
CFLAGS="-DHAVE_HIDDEN -DZLIB_CONST" ./configure --static
make

cd "$CURDIR/libbase"
case "$OSTYPE" in
  linux* | darwin*)
    src="errors_unix.cpp"
  ;;
  *)
    src="errors_windows.cpp utf8.cpp"
  ;;
esac
# gnu++17 instead of c++17 because posix_strerror_r.cpp does not define _POSIX_C_SOURCE
$CC -std=gnu++17 -I"$INCLUDEDIR" ${CFLAGS} -c abi_compatibility.cpp chrono_utils.cpp file.cpp logging.cpp mapped_file.cpp parsebool.cpp parsenetaddress.cpp posix_strerror_r.cpp process.cpp properties.cpp stringprintf.cpp strings.cpp threads.cpp test_utils.cpp ${src}
$AR rcs "$LIBOUTDIR/libbase.a" *.o
rm -r *.o
unset src

cd "$CURDIR/core/libsparse"
$CC -std=c++17 -I"$INCLUDEDIR" ${CFLAGS} -c backed_block.cpp output_file.cpp sparse.cpp sparse_crc32.cpp sparse_err.cpp sparse_read.cpp
$AR rcs "$LIBOUTDIR/libsparse.a" *.o
rm -r *.o

cd "$LIBDIR/fmt"
$CC -std=c++17 -Iinclude ${CFLAGS} -c src/format.cc
$AR rcs "$LIBOUTDIR/fmtlib.a" *.o
rm -r *.o

cd "$CURDIR/core/fs_mgr/liblp"
$CC -std=c++17 -I"$INCLUDEDIR" -D_FILE_OFFSET_BITS=64 ${CFLAGS} -c builder.cpp images.cpp partition_opener.cpp property_fetcher.cpp reader.cpp utility.cpp writer.cpp
$AR rcs "$LIBOUTDIR/liblp.a" *.o
rm -r *.o

cd "$CURDIR/extras/ext4_utils"
$CC -std=c++17 -I"$INCLUDEDIR" -fno-strict-aliasing ${CFLAGS} -c ext4_utils.cpp wipe.cpp ext4_sb.cpp
$AR rcs "$LIBOUTDIR/libext4_utils.a" *.o
rm -r *.o

cd "$CURDIR/core/libcrypto_utils"
$CC -std=c++17 -Iinclude -I"$LIBDIR/boringssl/include" ${CFLAGS} -c android_pubkey.cpp
$AR rcs "$LIBOUTDIR/libcrypto_utils.a" *.o
rm -r *.o

cd "$LIBDIR/boringssl"
cmake -S . -B "build"
cd "build"
make crypto
LIBCRYPTODIR="$LIBDIR/boringssl/build/crypto"

cd "$LIBDIR/protobuf"
./autogen.sh
./configure
cd "src"
make -j$(nproc) libprotobuf.la protoc
LIBPROTOBUF="$LIBDIR/protobuf/src/.libs"

cd "$CURDIR/extras/libjsonpb"
$CC -std=c++17 -I"$INCLUDEDIR" -Iparse/include ${CFLAGS} -c parse/jsonpb.cpp
$AR rcs "$LIBOUTDIR/libjsonpbparse.a" *.o
rm -r *.o

cd "$CURDIR/extras/partition_tools"
case "$OSTYPE" in
  linux* | darwin*)
  ;;
  *)
    LDFLAGS="-lws2_32"
  ;;
esac

LD_LIBRARY_PATH="$LIBPROTOBUF/" "$LIBPROTOBUF/protoc" --cpp_out=. dynamic_partitions_device_info.proto

${CPP} -std=c++17 -I"$INCLUDEDIR" ${CFLAGS} -D_FILE_OFFSET_BITS=64 -o "$BINDIR/lpmake" lpmake.cc "$LIBOUTDIR/liblp.a" "$LIBOUTDIR/libsparse.a" "$LIBOUTDIR/libext4_utils.a" "$LIBDIR/zlib/libz.a" "$LIBOUTDIR/libbase.a" "$LIBOUTDIR/fmtlib.a" "$LIBOUTDIR/liblog.a" "$LIBOUTDIR/libcrypto_utils.a" "$LIBCRYPTODIR/libcrypto.a" -lpthread ${LDFLAGS}
${CPP} -std=c++17 -I"$INCLUDEDIR" ${CFLAGS} -D_FILE_OFFSET_BITS=64 -o "$BINDIR/lpadd" lpadd.cc "$LIBOUTDIR/liblp.a" "$LIBOUTDIR/libsparse.a" "$LIBOUTDIR/libext4_utils.a" "$LIBDIR/zlib/libz.a" "$LIBOUTDIR/libbase.a" "$LIBOUTDIR/fmtlib.a" "$LIBOUTDIR/liblog.a" "$LIBOUTDIR/libcrypto_utils.a" "$LIBCRYPTODIR/libcrypto.a" -lpthread ${LDFLAGS}
${CPP} -std=c++17 -I"$INCLUDEDIR" ${CFLAGS} -D_FILE_OFFSET_BITS=64 -o "$BINDIR/lpflash" lpflash.cc "$LIBOUTDIR/liblp.a" "$LIBOUTDIR/libsparse.a" "$LIBOUTDIR/libext4_utils.a" "$LIBDIR/zlib/libz.a" "$LIBOUTDIR/libbase.a" "$LIBOUTDIR/fmtlib.a" "$LIBOUTDIR/liblog.a" "$LIBOUTDIR/libcrypto_utils.a" "$LIBCRYPTODIR/libcrypto.a" -lpthread ${LDFLAGS}
${CPP} -std=c++17 -I"$INCLUDEDIR" ${CFLAGS} -D_FILE_OFFSET_BITS=64 -o "$BINDIR/lpunpack" lpunpack.cc "$LIBOUTDIR/liblp.a" "$LIBOUTDIR/libsparse.a" "$LIBOUTDIR/libext4_utils.a" "$LIBDIR/zlib/libz.a" "$LIBOUTDIR/libbase.a" "$LIBOUTDIR/fmtlib.a" "$LIBOUTDIR/liblog.a" "$LIBOUTDIR/libcrypto_utils.a" "$LIBCRYPTODIR/libcrypto.a" -lpthread ${LDFLAGS}
${CPP} -std=c++17 -I"$INCLUDEDIR" ${CFLAGS} -D_FILE_OFFSET_BITS=64 -o "$BINDIR/lpdump" lpdump.cc dynamic_partitions_device_info.pb.cc lpdump_host.cc "$LIBOUTDIR/liblp.a" "$LIBOUTDIR/libsparse.a" "$LIBOUTDIR/libext4_utils.a" "$LIBDIR/zlib/libz.a" "$LIBOUTDIR/libbase.a" "$LIBOUTDIR/fmtlib.a" "$LIBOUTDIR/liblog.a" "$LIBOUTDIR/libcrypto_utils.a" "$LIBCRYPTODIR/libcrypto.a" "$LIBOUTDIR/libjsonpbparse.a" "$LIBPROTOBUF/libprotobuf.a" -lpthread ${LDFLAGS}

rm -f dynamic_partitions_device_info.pb.h dynamic_partitions_device_info.pb.cc

rm -rf "$LIBOUTDIR"
rm -rf "$LIBDIR/boringssl/build"
cd "$LIBDIR/protobuf"
make distclean
cd "$LIBDIR/zlib"
make distclean
cd "$CURDIR"

$STRIP "$BINDIR/lpmake"
$STRIP "$BINDIR/lpadd"
$STRIP "$BINDIR/lpflash"
$STRIP "$BINDIR/lpunpack"
$STRIP "$BINDIR/lpdump"
