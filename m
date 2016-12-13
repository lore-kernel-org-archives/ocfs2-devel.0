From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:27 +0800
Subject: [Ocfs2-devel] [PATCH 09/17] Single run: make blocksize and
	clustersize as parameters
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-10-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

It takes too long to get the result of a round testing. This
can shorten a lot time by eliminating 2-layer loops with blocksize
and clustersize. Now blocksize defaults to 4096, while clustersize
to 32768 if not specified.

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/backup_super/test_backup_super.sh |  29 +++-
 programs/inline-data/single-inline-run.sh  |  24 ++-
 programs/mkfs-tests/mkfs-test.sh           |  27 +++-
 programs/python_common/single_run-WIP.sh   | 247 +++++++++++++++++++++--------
 programs/reflink_tests/reflink_test_run.sh |  26 ++-
 programs/tunefs-test/tunefs-test.sh        |  28 +++-
 programs/xattr_tests/xattr-single-run.sh   |  26 ++-
 7 files changed, 308 insertions(+), 99 deletions(-)

diff --git a/programs/backup_super/test_backup_super.sh b/programs/backup_super/test_backup_super.sh
index ed7c94b..530109e 100755
--- a/programs/backup_super/test_backup_super.sh
+++ b/programs/backup_super/test_backup_super.sh
@@ -49,6 +49,9 @@ LOGFILE=""
 FIRST_BACKUP_OFF=1073741824	#1G
 MAX_NUM=6
 
+blocksize=
+clustersize=
+
 #
 # usage			Display help information and exit.
 #
@@ -65,11 +68,13 @@ function usage()
 	      --with-mkfs=PROGRAM          use the PROGRAM as fswreck
 	      --with-debugfs=PROGRAM        use the PROGRAM as mkfs.ocfs2
 	      --with-tunefs=PROGRAM        use the PROGRAM as tunefs.ocfs2
+	      --block-size=blocksize       block size
+	      --cluster-size=clustersize   cluster size
 
 	Examples:
 
-	  $script --with-debugfs=../debugfs.ocfs2/debugfs.ocfs2 /dev/sde2
-	  $script --with-mkfs=/sbin/mkfs.ocfs2 --log-dir=/tmp /dev/sde2
+	  $script --with-debugfs=../debugfs.ocfs2/debugfs.ocfs2 --block-size=4096 --clustersize=32768??/dev/sde2
+	  $script --with-mkfs=/sbin/mkfs.ocfs2 --log-dir=/tmp --block-size=4096 --clustersize=32768 /dev/sde2
 	EOF
 }
 
@@ -376,10 +381,20 @@ function volume_small_test()
 ##################################
 function normal_test()
 {
-	for blocksize in 512 4096
+	if [ "$blocksize" != "NONE" ];then
+		bslist="$blocksize"
+	else
+		bslist="512 4096"
+	fi
+	if [ "$clustersize" != "NONE" ];then
+		cslist="$clustersize"
+	else
+		cslist="4096 32768 1048576"
+	fi
+	for blocksize in $(echo "$bslist")
 	do
 		for clustersize in \
-			4096 32768 1048576
+			$(echo "$cslist")
 		do
 
 			vol_byte_size=$FIRST_BACKUP_OFF
@@ -462,6 +477,12 @@ do
 	"--with-tunefs="*)
 		TUNEFS_BIN="${1#--with-tunefs=}"
 		;;
+	"--block-size="*)
+		blocksize="${1#--block-size=}"
+		;;
+	"--cluster-size="*)
+		clustersize="${1#--cluster-size=}"
+		;;
 	*)
 		DEVICE="$1"
 		;;
diff --git a/programs/inline-data/single-inline-run.sh b/programs/inline-data/single-inline-run.sh
index 5a176cd..89b2f4c 100755
--- a/programs/inline-data/single-inline-run.sh
+++ b/programs/inline-data/single-inline-run.sh
@@ -105,8 +105,10 @@ exit_or_not()
 ################################################################################
 f_usage()
 {
-    echo "usage: `basename ${0}` [-o output] <-d <device>> <mountpoint path>"
+    echo "usage: `basename ${0}` [-o output] <-b blocksize> <-c clustersize> <-d <device>> <mountpoint path>"
     echo "       -o output directory for the logs"
+    echo "       -b blocksize"
+    echo "       -c clustersize"
     echo "       -d device name used for ocfs2 volume"
     echo "       <mountpoint path> path of mountpoint where the ocfs2 volume will be mounted on."
     exit 1;
@@ -120,10 +122,12 @@ f_getoptions()
                 exit 1
          fi
 
-         while getopts "o:hd:" options; do
+         while getopts "o:hd:b:c:" options; do
                 case $options in
                 o ) LOG_OUT_DIR="$OPTARG";;
                 d ) OCFS2_DEVICE="$OPTARG";;
+                b ) BLOCKSIZE="$OPTARG";;
+                c ) CLUSTERSIZE="$OPTARG";;
                 h ) f_usage
                     exit 1;;
                 * ) f_usage
@@ -132,7 +136,6 @@ f_getoptions()
         done
         shift $(($OPTIND -1))
         MOUNT_POINT=${1}
-
 }
 
 f_setup()
@@ -373,9 +376,20 @@ trap ' : ' SIGTERM
 
 f_setup $*
 
-for BLOCKSIZE in 512 1024 4096
+if [ "$BLOCKSIZE" != "NONE" ];then
+	bslist="$BLOCKSIZE"
+else
+	bslist="512 1024 4096"
+fi
+if [ "$CLUSTERSIZE" != "NONE" ];then
+	cslist="$CLUSTERSIZE"
+else
+	cslist="4096 32768 1048576"
+fi
+
+for BLOCKSIZE in $(echo "$bslist")
 do
-	for CLUSTERSIZE in 4096 32768 1048576
+	for CLUSTERSIZE in $(echo "$cslist")
 	do
 		echo "++++++++++Single node inline-data test with \"-b ${BLOCKSIZE} -C ${CLUSTERSIZE}\"++++++++++" |tee -a ${RUN_LOG_FILE}
 		echo "++++++++++Single node inline-data test with \"-b ${BLOCKSIZE} -C ${CLUSTERSIZE}\"++++++++++">>${DATA_LOG_FILE}
diff --git a/programs/mkfs-tests/mkfs-test.sh b/programs/mkfs-tests/mkfs-test.sh
index 8fdd02a..67299ac 100755
--- a/programs/mkfs-tests/mkfs-test.sh
+++ b/programs/mkfs-tests/mkfs-test.sh
@@ -1,12 +1,14 @@
 #!/bin/sh
 #
-# mkfs_test -o <outdir> -d <device>
+# mkfs_test -o <outdir> -d <device> -b <blocksize> -c <clustersize>
 #
 usage() {
-    echo "usage: ${MKFS_TEST} -o <outdir> -d <device> -m <mountpoint>"
+    echo "usage: ${MKFS_TEST} -o <outdir> -d <device> -m <mountpoint> -b <blocksize> -c <clustersize>"
     echo "       -o output directory for the logs"
     echo "       -d device"
     echo "       -m mountpoint"
+    echo "       -b blocksize"
+    echo "       -c clustersize"
     exit 1
 }
 
@@ -255,13 +257,17 @@ bindir=`basename ${0}`
 outdir=`basename ${bindir}`
 device=
 mntdir=
+blocksize=
+clustersize=
 OPTIND=1
-while getopts "d:i:o:m:c" args
+while getopts "d:i:o:m:c:b:" args
 do
   case "$args" in
     o) outdir="$OPTARG";;
     d) device="$OPTARG";;
     m) mntdir="$OPTARG";;
+    b) blocksize="$OPTARG";;
+    c) clustersize="$OPTARG";;
   esac
 done
 LOGFILE=${outdir}/mkfs-test.log
@@ -296,11 +302,22 @@ numblks=1048576
 
 testnum=1
 
+if [ "$blocksize" != "NONE" ];then
+    bslist="$blocksize"
+else
+    bslist="512 1024 2048 4096"
+fi
+
+if [ "$clustersize" != "NONE" ];then
+    cslist="$clustersize"
+else
+    cslist="4096 8192 16384 32768 65536 131072 262144 524288 1048576"
+fi
 
 ### Test all combinations of blocksizes and clustersizes
-for blks in 512 1024 2048 4096
+for blks in $(echo "$bslist")
 do
-    for clusts in 4096 8192 16384 32768 65536 131072 262144 524288 1048576
+    for clusts in $(echo "$cslist")
     do
         TAG=mkfs_test_${testnum}
         OUT=${outdir}/${TAG}.log
diff --git a/programs/python_common/single_run-WIP.sh b/programs/python_common/single_run-WIP.sh
index d474463..c7bbfdf 100755
--- a/programs/python_common/single_run-WIP.sh
+++ b/programs/python_common/single_run-WIP.sh
@@ -197,7 +197,7 @@ do_mkdir() {
 run_create_and_open()
 {
 	log_message "run_create_and_open" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_create_and_open()"
                 exit 1
         fi
@@ -205,10 +205,20 @@ run_create_and_open()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	if [ $4 != "NONE" ];then
+		blocksize=$4
+	else
+		blocksize=4096
+	fi
+
+	if [ $5 != "NONE" ];then
+		clustersize=$5
+	else
+		clustersize=32768
+	fi
+
 
 	workdir=${mountpoint}/create_and_open_test
-	blocksize=4096
-	clustersize=32768
 	features="sparse,unwritten,inline-data"
 
 	mountopts="defaults"
@@ -269,7 +279,7 @@ run_extend_and_write()
 run_directaio()
 {
 	log_message "run_directaio" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_directaio()"
                 exit 1
         fi
@@ -277,10 +287,19 @@ run_directaio()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	if [ $4 != "NONE" ];then
+		blocksize=$4
+	else
+		blocksize=4096
+	fi
+
+	if [ $5 != "NONE" ];then
+		clustersize=$5
+	else
+		clustersize=32768
+	fi
 
 	workfile=${mountpoint}/directaio_testfile
-	blocksize=4096
-	clustersize=32768
 	features="sparse,unwritten,inline-data"
 
 	for mopt in writeback ordered
@@ -303,11 +322,11 @@ run_directaio()
 	done
 }
 
-# run_aiostress ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+# run_aiostress ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 run_aiostress()
 {
 	log_message "run_aiostress" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_aiostress()"
                 exit 1
         fi
@@ -315,10 +334,19 @@ run_aiostress()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	if [ $4 != "NONE" ];then
+		blocksize=$4
+	else
+		blocksize=4096
+	fi
+
+	if [ $5 != "NONE" ];then
+		clustersize=$5
+	else
+		clustersize=32768
+	fi
 
 	workdir=${mountpoint}/testme
-	blocksize=4096
-	clustersize=8192
 	features="sparse,unwritten,inline-data"
 
 	for mopt in writeback ordered
@@ -347,11 +375,11 @@ run_aiostress()
 	done
 }
 
-# run_buildkernel ${LOGDIR} ${DEVICE} {MOUNTPOINT} ${KERNELSRC}
+# run_buildkernel ${LOGDIR} ${DEVICE} {MOUNTPOINT} ${KERNELSRC} ${BLOCKSIZE} ${CLUSTERSIZE}
 run_buildkernel()
 {
 	log_message "run_buildkernel" $@
-        if [ "$#" -lt "4" ]; then
+        if [ "$#" -lt "6" ]; then
                 echo "Error in run_buildkernel()"
                 exit 1
         fi
@@ -360,11 +388,20 @@ run_buildkernel()
 	device=$2
 	mountpoint=$3
 	kernelsrc=$4
+	if [ $5 != "NONE" ];then
+		blocksize=$5
+	else
+		blocksize=4096
+	fi
+
+	if [ $6 != "NONE" ];then
+		clustersize=$6
+	else
+		clustersize=32768
+	fi
 
 	node=`${HOSTNAME}`
 	workdir=${mountpoint}/testme
-	blocksize=4096
-	clustersize=4096
 	features="sparse,unwritten,inline-data"
 
 	for mopt in writeback ordered
@@ -392,11 +429,11 @@ run_buildkernel()
 	done
 }
 
-# run_filesizelimits ${LOGDIR} ${DEVICE} {MOUNTPOINT}
+# run_filesizelimits ${LOGDIR} ${DEVICE} {MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 run_filesizelimits()
 {
 	log_message "run_filesizelimits" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_filesizelimits()"
                 exit 1
         fi
@@ -404,10 +441,19 @@ run_filesizelimits()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	if [ $4 != "NONE" ];then
+		blocksize=$4
+	else
+		blocksize=4096
+	fi
+
+	if [ $5 != "NONE" ];then
+		clustersize=$5
+	else
+		clustersize=32768
+	fi
 
 	mountopts=defaults
-	clustersize=4096
-	blocksize=4096
 
 	get_bits $blocksize
 	blocksize_bits=$?
@@ -566,11 +612,11 @@ EOF
 	done
 }
 
-# run_renamewriterace ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+# run_renamewriterace ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 run_renamewriterace()
 {
 	log_message "run_renamewriterace" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_renamewriterace()"
                 exit 1
         fi
@@ -578,10 +624,19 @@ run_renamewriterace()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	if [ $4 != "NONE" ];then
+		blocksize=$4
+	else
+		blocksize=4096
+	fi
+
+	if [ $5 != "NONE" ];then
+		clustersize=$5
+	else
+		clustersize=32768
+	fi
 
 	workdir=${mountpoint}/testme
-	blocksize=4096
-	clustersize=4096
 	features="sparse,unwritten,inline-data"
 
 	for mopt in writeback ordered
@@ -608,7 +663,7 @@ run_renamewriterace()
 run_splice()
 {
 	log_message "run_splice" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_splice()"
                 exit 1
         fi
@@ -616,10 +671,19 @@ run_splice()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	if [ $4 != "NONE" ];then
+		blocksize=$4
+	else
+		blocksize=4096
+	fi
+
+	if [ $5 != "NONE" ];then
+		clustersize=$5
+	else
+		clustersize=32768
+	fi
 
 	workdir=${mountpoint}/testme
-	blocksize=4096
-	clustersize=32768
 	features="sparse,unwritten,inline-data"
 
 	for mopt in writeback ordered
@@ -646,7 +710,7 @@ run_splice()
 run_sendfile()
 {
 	log_message "run_sendfile" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_sendfile()"
                 exit 1
         fi
@@ -655,11 +719,21 @@ run_sendfile()
 	device=$2
 	mountpoint=$3
 
+	if [ $4 != "NONE" ];then
+		blocksize=$4
+	else
+		blocksize=4096
+	fi
+
+	if [ $5 != "NONE" ];then
+		clustersize=$5
+	else
+		clustersize=32768
+	fi
+
 	workfile=${mountpoint}/ocfs2_sendfile_data
 	verifyfile=/tmp/sendfile_verify
 	
-	blocksize=4096
-	clustersize=32768
 	features="sparse,unwritten,inline-data"
 	port=8001
 
@@ -697,7 +771,7 @@ run_sendfile()
 run_mmap()
 {
 	log_message "run_mmap" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_mmap()"
                 exit 1
         fi
@@ -705,12 +779,22 @@ run_mmap()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	if [ "$4" != "NONE" ];then
+		bslist="$4"
+	else
+		bslist="512 1024 2048 4096"
+	fi
+	if [ "$5" != "NONE" ];then
+		cslist="$5"
+	else
+		cslist="4096 32768 1048576"
+	fi
 
 	workfile=${mountpoint}/mmap_testfile
 	features="sparse,unwritten,inline-data"
 
-	for blocksize in 512 1024 2048 4096;do
-		for clustersize in 4096 32768 1048576;do
+	for blocksize in $(echo "$bslist");do
+		for clustersize in $(echo "$cslist");do
 			for mopt in writeback ordered;do
 				mountopts="data=${mopt}"
 
@@ -736,7 +820,7 @@ run_mmap()
 run_reserve_space()
 {
 	log_message "run_reserve_space" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_reserve_space()"
                 exit 1
         fi
@@ -744,14 +828,24 @@ run_reserve_space()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	if [ "$4" != "NONE" ];then
+		bslist="$4"
+	else
+		bslist="512 1024 2048 4096"
+	fi
+	if [ "$5" != "NONE" ];then
+		cslist="$5"
+	else
+		cslist="4096 32768 1048576"
+	fi
 
 	workfile=${mountpoint}/reserve_space_testfile
 	features="sparse,unwritten,inline-data"
 	space_free=
 	iter=1000
 
-	for blocksize in 512 1024 2048 4096;do
-		for clustersize in 4096 32768 1048576;do
+	for blocksize in $(echo "$bslist");do
+		for clustersize in $(echo "$cslist");do
 			for mopt in writeback ordered;do
 				mountopts="data=${mopt}"
 
@@ -792,7 +886,7 @@ run_reserve_space()
 run_inline_data()
 {
 	log_message "run_inline_data" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_inline_data()"
                 exit 1
         fi
@@ -800,9 +894,11 @@ run_inline_data()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	blocksize=$4
+	clustersize=$5
 
 	log_start "inline_data_test" 
-	single-inline-run.sh  -o ${logdir} -d ${device} ${mountpoint}
+	single-inline-run.sh  -o ${logdir} -d ${device} -b ${blocksize} -c ${clustersize} ${mountpoint}
 	RC=$?
 	log_end ${RC}
 }
@@ -810,7 +906,7 @@ run_inline_data()
 run_dx_dir()
 {
 	log_message "run_dx_dir" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "6" ]; then
                 echo "Error in run_dx_dir()"
                 exit 1
         fi
@@ -819,9 +915,11 @@ run_dx_dir()
 	device=$2
 	mountpoint=$3
         kernelsrc=$4
+	blocksize=$5
+	clustersize=$6
 
 	log_start "index_dir_test" 
-	index_dir_run.sh  -o ${logdir} -d ${device} -t ${kernelsrc} ${mountpoint}
+	index_dir_run.sh  -o ${logdir} -d ${device} -t ${kernelsrc} -b ${blocksize} -c ${clustersize} ${mountpoint}
 	RC=$?
 	log_end ${RC}
 }
@@ -829,7 +927,7 @@ run_dx_dir()
 run_xattr_test()
 {
 	log_message "run_xattr_test" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_xattr_test()"
                 exit 1
         fi
@@ -837,9 +935,11 @@ run_xattr_test()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	blocksize=$4
+	clustersize=$5
 
 	log_start "xattr_test" 
-	xattr-single-run.sh -c -o ${logdir} -d ${device} ${mountpoint}
+	xattr-single-run.sh -c -o ${logdir} -d ${device} -b ${blocksize} -C ${clustersize} ${mountpoint}
 	RC=$?
 
 	log_end ${RC}
@@ -848,7 +948,7 @@ run_xattr_test()
 run_reflink_test()
 {
 	log_message "run_reflink_test" $@
-        if [ "$#" -lt "3" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_reflink()"
                 exit 1
         fi
@@ -856,17 +956,19 @@ run_reflink_test()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	blocksize=$4
+	clustersize=$5
 
 	#ordered mount option
 	log_start "reflink_test" "ordered"
-	reflink_test_run.sh -o ${logdir} -d ${device} ${mountpoint} || {
+	reflink_test_run.sh -o ${logdir} -d ${device} -b ${blocksize} -c ${clustersize} ${mountpoint} || {
 		RC=$?
 		log_end ${RC}
 	}
 
 	#writeback mount option
 	#log_start "reflink_test" "writeback"
-	#reflink_test_run.sh -W -o ${logdir} -d ${device} ${mountpoint}
+	#reflink_test_run.sh -W -o ${logdir} -d ${device} -b ${blocksize} -c ${clustersize} ${mountpoint}
 	RC=$?
 	log_end ${RC}
 }
@@ -895,7 +997,7 @@ run_filecheck_test()
 run_mkfs()
 {
 	log_message "run_mkfs" $@
-        if [ "$#" -lt "2" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_mkfs()"
                 exit 1
         fi
@@ -903,9 +1005,11 @@ run_mkfs()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	blocksize=$4
+	clustersize=$5
 
 	log_start "mkfs_test"
-	mkfs-test.sh -o ${logdir} -d ${device} -m ${mountpoint}
+	mkfs-test.sh -o ${logdir} -d ${device} -m ${mountpoint} -b ${blocksize} -c ${clustersize}
 	RC=$?
 	log_end ${RC}
 }
@@ -913,7 +1017,7 @@ run_mkfs()
 run_tunefs()
 {
 	log_message "run_tunefs" $@
-        if [ "$#" -lt "2" ]; then
+        if [ "$#" -lt "5" ]; then
                 echo "Error in run_tunefs()"
                 exit 1
         fi
@@ -921,9 +1025,11 @@ run_tunefs()
 	logdir=$1
 	device=$2
 	mountpoint=$3
+	blocksize=$4
+	clustersize=$5
 
 	log_start "tunefs_test"
-	tunefs-test.sh -o ${logdir} -d ${device} -m ${mountpoint}
+	tunefs-test.sh -o ${logdir} -d ${device} -m ${mountpoint} -b ${blocksize} -c ${clustersize}
 	RC=$?
 	log_end ${RC}
 }
@@ -931,16 +1037,18 @@ run_tunefs()
 run_backup_super()
 {
 	log_message "run_backup_super" $@
-        if [ "$#" -lt "2" ]; then
+        if [ "$#" -lt "4" ]; then
                 echo "Error in run_backup_super()"
                 exit 1
         fi
 
 	logdir=$1
 	device=$2
+	blocksize=$3
+	clustersize=$4
 
 	log_start "backup_super_test"
-	test_backup_super.sh --log-dir=${logdir} ${device}
+	test_backup_super.sh --log-dir=${logdir} --block-size=${blocksize} --cluster-size=${clustersize} ${device}
 	RC=$?
 	log_end ${RC}
 }
@@ -953,11 +1061,11 @@ run_backup_super()
 
 usage()
 {
-	${ECHO} "usage: ${APP} [-k kerneltarball] -m mountpoint -l logdir -d device [-t testcases]"
+	${ECHO} "usage: ${APP} [-k kerneltarball] -m mountpoint -l logdir -d device [-t testcases] [-b blocksize] [-c clustersize]"
 	exit 1
 }
 
-while getopts "d:m:k:l:t:h:?" args
+while getopts "d:m:k:l:t:b:c:h:?" args
 do
 	case "$args" in
 		d) DEVICE="$OPTARG";;
@@ -965,6 +1073,8 @@ do
 		k) KERNELSRC="$OPTARG";;
 		l) OUTDIR="$OPTARG";;
 		t) TESTCASES="$OPTARG";;
+		b) BLOCKSIZE="$OPTARG";;
+		c) CLUSTERSIZE="$OPTARG";;
     		h) usage;;
     		?) usage;;
   	esac
@@ -995,6 +1105,9 @@ if [ -z ${TESTCASES} ]; then
 	TESTCASES="all"
 fi
 
+BLOCKSIZE=${BLOCKSIZE:-4096}
+CLUSTERSIZE=${CLUSTERSIZE:-32768}
+
 SUPPORTED_TESTCASES="all create_and_open directaio fillverifyholes renamewriterace aiostress\
   filesizelimits mmaptruncate buildkernel splice sendfile mmap reserve_space inline xattr\
   reflink mkfs tunefs backup_super filecheck"
@@ -1021,11 +1134,11 @@ ${ECHO} "Output log is ${LOGFILE}"
 for tc in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 
 	if [ "$tc"X = "create_and_open"X -o "$tc"X = "all"X ];then
-		run_create_and_open ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_create_and_open ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "directaio"X -o "$tc"X = "all"X ];then
-		run_directaio ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_directaio ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "fillverifyholes"X -o "$tc"X = "all"X ];then
@@ -1033,15 +1146,15 @@ for tc in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 	fi
 
 	if [ "$tc"X = "renamewriterace"X -o "$tc"X = "all"X ];then
-		run_renamewriterace ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_renamewriterace ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "aiostress"X -o "$tc"X = "all"X ];then
-		run_aiostress ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_aiostress ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "filesizelimits"X -o "$tc"X = "all"X ];then
-		run_filesizelimits ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_filesizelimits ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "mmaptruncate"X -o "$tc"X = "all"X ];then
@@ -1059,35 +1172,35 @@ for tc in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 			usage
 		fi
 
-		run_buildkernel ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${KERNELSRC}
+		run_buildkernel ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${KERNELSRC} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "splice"X -o "$tc"X = "all"X ];then
-		run_splice ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_splice ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "sendfile"X -o "$tc"X = "all"X ];then
-		run_sendfile ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_sendfile ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "mmap"X -o "$tc"X = "all"X ];then
-		run_mmap ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_mmap ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "reserve_space"X -o "$tc"X = "all"X ];then
-		run_reserve_space ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_reserve_space ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "inline"X -o "$tc"X = "all"X ];then
-		run_inline_data ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_inline_data ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "xattr"X -o "$tc"X = "all"X ];then
-		run_xattr_test ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_xattr_test ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "reflink"X -o "$tc"X = "all"X ];then
-		run_reflink_test ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_reflink_test ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "filecheck"X ];then
@@ -1097,15 +1210,15 @@ for tc in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 # For tools test.
 
 	if [ "$tc"X = "mkfs"X -o "$tc"X = "all"X ];then
-		run_mkfs ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_mkfs ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "tunefs"X -o "$tc"X = "all"X ];then
-		run_tunefs ${LOGDIR} ${DEVICE} ${MOUNTPOINT}
+		run_tunefs ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 	if [ "$tc"X = "backup_super"X -o "$tc"X = "all"X ];then
-		run_backup_super ${LOGDIR} ${DEVICE}
+		run_backup_super ${LOGDIR} ${DEVICE} ${BLOCKSIZE} ${CLUSTERSIZE}
 	fi
 
 done
diff --git a/programs/reflink_tests/reflink_test_run.sh b/programs/reflink_tests/reflink_test_run.sh
index 5c4d233..d09a8f0 100755
--- a/programs/reflink_tests/reflink_test_run.sh
+++ b/programs/reflink_tests/reflink_test_run.sh
@@ -98,13 +98,15 @@ set -o pipefail
 function f_usage()
 {
         echo "usage: `basename ${0}` [-D <-a remote_listener_addr_in_IPV4> <-p port>] \
-[-v verify_log] [-W] [-A] [-o logdir] <-d device> <mountpoint path>"
+[-v verify_log] [-W] [-A] [-o logdir] <-d device> <-b blocksize> <-c clustersize> <mountpoint path>"
         echo "       -o output directory for the logs"
         echo "       -d block device name used for ocfs2 volume"
         echo "       -W enable data=writeback mode"
 	echo "       -A enable asynchronous io testing mode"
 	echo "       -D enable destructive test,it will crash the testing node,\
 be cautious, you need to specify listener addr and port then"
+	echo "	     -b block size"
+	echo "	     -c cluster size"
         echo "       <mountpoint path> specify the testing mounting point."
         exit 1;
 
@@ -117,7 +119,7 @@ function f_getoptions()
                 exit 1
          fi
 
-         while getopts "o:WDAhd:a:p:v:" options; do
+         while getopts "o:WDAhd:a:p:v:b:c:" options; do
                 case $options in
                 o ) LOG_DIR="$OPTARG";;
                 d ) DEVICE="$OPTARG";;
@@ -127,6 +129,8 @@ function f_getoptions()
 		a ) LISTENER_ADDR="$OPTARG";;
 		p ) LISTENER_PORT="$OPTARG";;
 		v ) VERI_LOG="$OPTARG";;
+		b ) BLOCKSIZE="$OPTARG";;
+		c ) CLUSTERSIZE="$OPTARG";;
                 h ) f_usage;;
                 * ) f_usage;;
                 esac
@@ -729,16 +733,26 @@ trap 'echo -ne "\n\n">>${RUN_LOG_FILE};echo  "Interrupted by Ctrl+C,Cleanuping\
 
 f_check $*
 
+if [ "$BLOCKSIZE" != "NONE" ];then
+	bslist="$BLOCKSIZE"
+else
+	bslist="512 1024 4096"
+fi
+
+if [ "$CLUSTERSIZE" != "NONE" ];then
+	cslist="$CLUSTERSIZE"
+else
+	cslist="4096 32768 1048576"
+fi
+
 START_TIME=${SECONDS}
 f_LogRunMsg ${RUN_LOG_FILE} "=====================Reflink tests start:  `date`\
 =====================\n"
 f_LogMsg ${LOG_FILE} "=====================Reflink tests start:  `date`\
 ====================="
 
-#for BLOCKSIZE in 512 1024 4096;do
-#	for CLUSTERSIZE in 4096 32768 1048576;do
-for BLOCKSIZE in 4096;do
-	for CLUSTERSIZE in 1048576;do
+for BLOCKSIZE in $(echo "$bslist");do
+	for CLUSTERSIZE in $(echo "$cslist");do
 		f_LogRunMsg ${RUN_LOG_FILE} "<- Running test with ${BLOCKSIZE} \
 bs and ${CLUSTERSIZE} cs ->\n"
 		f_LogMsg ${LOG_FILE} "<- Running test with ${BLOCKSIZE} bs \
diff --git a/programs/tunefs-test/tunefs-test.sh b/programs/tunefs-test/tunefs-test.sh
index dc1bd1b..0fc3da3 100755
--- a/programs/tunefs-test/tunefs-test.sh
+++ b/programs/tunefs-test/tunefs-test.sh
@@ -40,8 +40,8 @@ BLOCKDEV="`which sudo` -u root `which blockdev`"
 DEVICE=""
 MOUNT_POINT=""
 
-BLOCKSIZE=4k
-CLUSTERSIZE=8k
+BLOCKSIZE=
+CLUSTERSIZE=
 
 LABEL1=ocfs2test
 LABEL2=ocfs2test1
@@ -66,10 +66,12 @@ FS_FEATURES=
 #
 function usage()
 {
-    echo "usage: ${TUNEFS_TEST} -o <outdir> -d <device> -m <mountpoint>"
+    echo "usage: ${TUNEFS_TEST} -o <outdir> -d <device> -m <mountpoint> -b <blocksize> -c <clustersize>"
     echo "       -o output directory for the logs"
     echo "       -d device"
     echo "       -m mountpoint"
+    echo "       -b blocksize"
+    echo "       -c clustersize"
     exit 1
 }
 # 
@@ -512,8 +514,20 @@ Enable_Disable_Inline_Data()
         O_BLOCKSIZE=${BLOCKSIZE}
         O_CLUSTERSIZE=${CLUSTERSIZE}
 
-        for BLOCKSIZE in 512 1k 4k;do
-                for CLUSTERSIZE in 32k;do
+	if [ "$BLOCKSIZE" != "NONE" ];then
+		bslist="$BLOCKSIZE"
+	else
+		bslist="512 1k 4k"
+	fi
+
+	if [ "$CLUSTERSIZE" != "NONE" ];then
+		cslist="$CLUSTERSIZE"
+	else
+		cslist="32k"
+	fi
+
+	for BLOCKSIZE in $(echo "$bslist");do
+		for CLUSTERSIZE in $(echo "$cslist");do
                         
                         #set none inline-data support for volume
                         LogMsg "tunefs_test : Enable/Disable Inline-data"
@@ -647,12 +661,14 @@ TUNEFS_TEST=`basename $0`
 bindir=`basename ${0}`
 LOG_DIR=`basename ${bindir}`
 
-while getopts "d:o:m:" args
+while getopts "d:o:m:b:c:" args
 do
   case "$args" in
     o) LOG_DIR="$OPTARG";;
     d) DEVICE="$OPTARG";;
     m) MOUNT_POINT="$OPTARG";;
+    b) BLOCKSIZE="$OPTARG";;
+    c) CLUSTERSIZE="$OPTARG";;
   esac
 done
 
diff --git a/programs/xattr_tests/xattr-single-run.sh b/programs/xattr_tests/xattr-single-run.sh
index 09044e1..1d3e8f7 100755
--- a/programs/xattr_tests/xattr-single-run.sh
+++ b/programs/xattr_tests/xattr-single-run.sh
@@ -144,10 +144,12 @@ exit_or_not()
 ################################################################################
 f_usage()
 {
-    echo "usage: `basename ${0}` [-c] [-o output_log_dir] <-d <device>> <mountpoint path>"
+    echo "usage: `basename ${0}` [-c] [-o output_log_dir] <-d <device>> <-b <block size>> <-C <cluster size>> <mountpoint path>"
     echo "	 -c enable the combination test for inline-data and inline-xattr."
     echo "       -o output directory for the logs"
     echo "       -d specify the device which has been formated as an ocfs2 volume."
+    echo "	 -b block size."
+    echo "	 -C cluster size."
     echo "       <mountpoint path> path of mountpoint where the ocfs2 volume will be mounted on."
     exit 1;
 
@@ -160,11 +162,13 @@ f_getoptions()
                 exit 1
          fi
 
-	 while getopts "cho:d:" options; do
+	 while getopts "cho:d:b:C:" options; do
                 case $options in
 		c ) COMBIN_TEST="1";;
                 o ) LOG_OUT_DIR="$OPTARG";;
                 d ) OCFS2_DEVICE="$OPTARG";;
+		b ) BLOCKSIZE="$OPTARG";;
+		C ) CLUSTERSIZE="$OPTARG";;
                 h ) f_usage
                     exit 1;;
                 * ) f_usage
@@ -1064,15 +1068,25 @@ trap ' : ' SIGTERM
 
 f_setup $*
 
+if [ "$BLOCKSIZE" != "NONE" ];then
+	bslist="$BLOCKSIZE"
+else
+	bslist="512 1024 2048 4096"
+fi
+
+if [ "$CLUSTERSIZE" != "NONE" ];then
+	cslist="$CLUSTERSIZE"
+else
+	cslist="4096 32768 1048576"
+fi
+
 START_TIME=${SECONDS}
 echo "=====================Single node xattr testing starts: `date`=====================" |tee -a ${RUN_LOG_FILE}
 echo "=====================Single node xattr testing starts: `date`=====================" >> ${DETAIL_LOG_FILE}
 
-#for BLOCKSIZE in 512 1024 2048 4096
-for BLOCKSIZE in 512 4096
+for BLOCKSIZE in $(echo "$bslist")
 do
-#        for CLUSTERSIZE in 4096 32768 1048576
-        for CLUSTERSIZE in 4096 1048576
+	for CLUSTERSIZE in $(echo "$cslist")
         do
                 echo "++++++++++xattr tests with \"-b ${BLOCKSIZE} -C ${CLUSTERSIZE}\"++++++++++" |tee -a ${RUN_LOG_FILE}
                 echo "++++++++++xattr tests with \"-b ${BLOCKSIZE} -C ${CLUSTERSIZE}\"++++++++++">>${DETAIL_LOG_FILE}
-- 
2.6.6
