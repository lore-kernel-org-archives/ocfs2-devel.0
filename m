From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:30 +0800
Subject: [Ocfs2-devel] [PATCH 12/17] Add two cluster-aware parameters:
	cluster stack and cluster name
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-13-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

With pacemaker as cluster stack, single node test always fail on
mkfs in some testcases. On suse OS, we use pcmk plugin as default
cluster stack. But in single node test, some testcases format ocfs2
volume as local filesystem. In such case, o2cb plugin is used. If
the next testcase want to format the volume with multiple slots, it
will fail because mkfs.ocfs2 cannot shift from o2cb to pcmk
automatically.

This patch should be merged into suse branch, without affecting
other OS release only using o2cb.

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/backup_super/test_backup_super.sh         | 27 ++++++--
 .../discontig_bg_test/activate_discontig_bg.sh     | 12 ++--
 programs/discontig_bg_test/discontig_runner.sh     | 36 ++++++-----
 programs/inline-data/multi-inline-run.sh           | 13 ++--
 programs/inline-data/single-inline-run.sh          | 10 ++-
 programs/mkfs-tests/mkfs-test.sh                   | 46 ++++++++-----
 programs/python_common/multiple_run.sh             | 22 ++++---
 programs/python_common/o2tf.sh                     | 16 ++++-
 programs/python_common/single_run-WIP.sh           | 75 ++++++++++++++--------
 programs/reflink_tests/multi_reflink_test_run.sh   | 12 +++-
 programs/reflink_tests/reflink_test_run.sh         |  8 ++-
 programs/tunefs-test/tunefs-test.sh                | 11 ++--
 programs/xattr_tests/xattr-multi-run.sh            | 15 ++++-
 programs/xattr_tests/xattr-single-run.sh           | 13 ++--
 14 files changed, 215 insertions(+), 101 deletions(-)

diff --git a/programs/backup_super/test_backup_super.sh b/programs/backup_super/test_backup_super.sh
index 530109e..05da3e7 100755
--- a/programs/backup_super/test_backup_super.sh
+++ b/programs/backup_super/test_backup_super.sh
@@ -169,7 +169,8 @@ function test_mkfs()
 	msg1="debugfs should be sucess"
 
 	blkcount=`expr $vol_byte_size / $blocksize`
-	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M ${DEVICE} $blkcount
+	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M \
+ --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} ${DEVICE} $blkcount
 	#first check whether mkfs is success
 	echo "ls //"|${DEBUGFS_BIN} ${DEVICE}|grep global_bitmap
 	exit_if_bad $? 0 $msg $LINENO
@@ -186,7 +187,8 @@ function test_mkfs()
 
 	${DD_BIN} if=/dev/zero of=$DEVICE bs=4096 count=3
 	clear_backup_blocks
-	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M ${DEVICE} $blkcount
+	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M \
+		--cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} ${DEVICE} $blkcount
 	#first check whether mkfs is success
 	echo "ls //"|${DEBUGFS_BIN} ${DEVICE}|grep global_bitmap
 	exit_if_bad $? 0 $msg1 $LINENO
@@ -217,7 +219,8 @@ function test_fsck()
 	${DD_BIN} if=/dev/zero of=$DEVICE bs=4096 count=3
 	clear_backup_blocks
 
-	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M ${DEVICE} $blkcount
+	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M \
+ --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} ${DEVICE} $blkcount
 	#corrupt the superblock
 	${DD_BIN} if=/dev/zero of=${DEVICE} bs=$blocksize count=3
 	${FSCK_BIN} -fy ${DEVICE}	#This should failed.
@@ -247,7 +250,8 @@ function test_tunefs_resize()
 	clear_backup_blocks
 
 	#mkfs a volume with no backup superblock
-	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M ${DEVICE} $blkcount
+	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M \
+		    --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} ${DEVICE} $blkcount
 
 	local bpc=`expr $clustersize / $blocksize`
 	local blkcount=`expr $blkcount + $bpc`
@@ -283,7 +287,8 @@ function test_tunefs_add_backup()
 	clear_backup_blocks
 
 	#mkfs a volume with no backup superblock supported
-	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M --no-backup-super ${DEVICE} $blkcount
+	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M --no-backup-super \
+ --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} ${DEVICE} $blkcount
 
 	#We can't open the volume by backup superblock now
 	echo "ls //"|${DEBUGFS_BIN} ${DEVICE} -s 1|grep global_bitmap
@@ -327,7 +332,8 @@ function test_tunefs_refresh()
 
 	local old_vol_name="old_ocfs2"
 	local new_vol_name="new_ocfs2"
-	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M -L $old_vol_name ${DEVICE} $blkcount
+	echo "y" |${MKFS_BIN} -b $blocksize -C $clustersize -N 4  -J size=64M -L $old_vol_name \
+		--cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} ${DEVICE} $blkcount
 	check_vol $old_vol_name
 
 	#change the volume name
@@ -365,7 +371,8 @@ function volume_small_test()
 
 	# Since tunefs will return 0, we need to grep
 	# the output of stderr and find what we want.
-	echo "y" |${MKFS_BIN} -b 1K -C 4K ${DEVICE} -N 4 --no-backup-super $tmp_block_count
+	echo "y" |${MKFS_BIN} -b 1K -C 4K ${DEVICE} -N 4 --no-backup-super $tmp_block_count \
+ --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME}
 	err=`${TUNEFS_BIN} --backup-super ${DEVICE} 2>&1`
 	echo $err|grep "too small to contain backup superblocks"
 	exit_if_bad $? 0 "tunefs.ocfs2" $LINENO
@@ -465,6 +472,12 @@ do
 	"--log-dir="*)
 		LOG_DIR="${1#--log-dir=}"
 		;;
+	"--cluster-stack="*)
+		CLUSTER_STACK="${1#--cluster-stack=}"
+		;;
+	"--cluster-name="*)
+		CLUSTER_NAME="${1#--cluster-name=}"
+		;;
 	"--with-fsck="*)
 		FSCK_BIN="${1#--with-fsck=}"
 		;;
diff --git a/programs/discontig_bg_test/activate_discontig_bg.sh b/programs/discontig_bg_test/activate_discontig_bg.sh
index 6b4e07f..d44d479 100755
--- a/programs/discontig_bg_test/activate_discontig_bg.sh
+++ b/programs/discontig_bg_test/activate_discontig_bg.sh
@@ -21,6 +21,8 @@ fi
 
 DEVICE=
 MOUNT_POINT=
+CLUSTER_STACK=
+CLUSTER_NAME=
 WORK_PLACE=
 WORK_PLACE_DIRENT=ocfs2-activate-discontig-bg-dir
 TUNEFS_BIN="`which sudo` -u root `which tunefs.ocfs2`"
@@ -69,7 +71,7 @@ function f_usage()
 {
     echo "usage: `basename ${0}` [-t type] [-r resv_size] [-b blocksize] \
 [-c clustersize] [-l label] [-m mpi_hosts] [-a access_method] <-d device> \
-[-o logdir] <mount point> "
+[-o logdir] <-s cluster stack> <-n cluster name> <mount point>"
     exit 1;
 
 }
@@ -80,8 +82,8 @@ function f_getoptions()
 		f_usage;
 		exit 1
 	fi
-	
-	while getopts "hd:o:b:c:t:r:l:m:a:" options; do
+
+        while getopts "hd:o:b:c:t:r:l:m:a:s:n:" options; do
 		case $options in
 		d ) DEVICE="$OPTARG";;
 		o ) LOG_DIR="$OPTARG";;
@@ -93,6 +95,8 @@ function f_getoptions()
 		a ) MPI_ACCESS_METHOD="$OPTARG";;
 		m ) MULTI_TEST=1
 		    MPI_HOSTS="$OPTARG";;
+                s ) CLUSTER_STACK="$OPTARG";;
+                n ) CLUSTER_NAME="$OPTARG";;
 		h ) f_usage
 			exit 1;;
 		* ) f_usage
@@ -325,7 +329,7 @@ function f_activate_discontig()
 	
 	f_LogRunMsg ${RUN_LOG_FILE} "[*] Mkfs device ${DEVICE}:"
         f_mkfs ${LOG_FILE} ${BLOCKSIZE} ${CLUSTERSIZE} ${LABELNAME} ${SLOTS} \
-${DEVICE} "refcount,xattr,metaecc,discontig-bg" ${JOURNALSIZE} ${ORIG_VOLUME_SIZE_BK}
+${DEVICE} "refcount,xattr,metaecc,discontig-bg" ${JOURNALSIZE} ${ORIG_VOLUME_SIZE_BK} ${CLUSTER_STACK} ${CLUSTER_NAME}
         RET=$?
         f_echo_status ${RET}| tee -a ${RUN_LOG_FILE}
         f_exit_or_not ${RET}
diff --git a/programs/discontig_bg_test/discontig_runner.sh b/programs/discontig_bg_test/discontig_runner.sh
index 1d94be3..3be39c8 100755
--- a/programs/discontig_bg_test/discontig_runner.sh
+++ b/programs/discontig_bg_test/discontig_runner.sh
@@ -19,6 +19,8 @@ fi
 
 DEVICE=
 MOUNT_POINT=
+CLUSTER_STACK=
+CLUSTER_NAME=
 WORK_PLACE=
 WORK_PLACE_DIRENT=ocfs2-discontig-bg-test
 DISCONTIG_ACTIVATE_BIN="${BINDIR}/activate_discontig_bg.sh"
@@ -65,7 +67,7 @@ MPI_BTL_IF_ARG=
 function f_usage()
 {
     echo "usage: `basename ${0}` <-d device> [-o logdir] [-m multi_hosts] [-a access_method] \
-[-b block_size] [-c cluster_size] <mount point>"
+[-b block_size] [-c cluster_size] <-s cluster stack> <-n cluster name> <mount point>"
     exit 1;
 
 }
@@ -77,7 +79,7 @@ function f_getoptions()
 		exit 1
 	fi
 	
-	while getopts "hd:o:m:a:b:c:" options; do
+	while getopts "hd:o:m:a:b:c:s:n:" options; do
 		case $options in
 		d ) DEVICE="$OPTARG";;
 		o ) LOG_DIR="$OPTARG";;
@@ -86,6 +88,8 @@ function f_getoptions()
 		    MPI_HOSTS="$OPTARG";;
                 b ) BLOCKSIZE="$OPTARG";;
                 c ) CLUSTERSIZE="$OPTARG";;
+                s ) CLUSTER_STACK="$OPTARG";;
+                n ) CLUSTER_NAME="$OPTARG";;
 		h ) f_usage
 			exit 1;;
 		* ) f_usage
@@ -212,7 +216,7 @@ function f_inodes_test()
 	local filename=
 
 	f_LogMsg ${LOG_FILE} "Activate inode discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t inode -r 200 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t inode -r 200 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -295,7 +299,7 @@ function f_inodes_test()
 	f_exit_or_not ${RET}
 
 	f_LogMsg ${LOG_FILE} "[*] Activate inode discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t inode -r 4096 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t inode -r 4096 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -423,7 +427,7 @@ function f_extents_test()
 	local inc=
 
 	f_LogMsg ${LOG_FILE} "[*] Activate extent discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r 2048 -b ${BLOCKSIZE}-c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r 2048 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -555,7 +559,7 @@ function f_extents_test()
 function f_inline_test()
 {
 	f_LogMsg ${LOG_FILE} "[*] Activate inode discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t inode -r 1024 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t inode -r 1024 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -625,7 +629,7 @@ function f_inline_test()
 function f_xattr_test()
 {
 	f_LogMsg ${LOG_FILE} "[*] Activate extent discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r 10240 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r 10240 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -708,7 +712,7 @@ function f_refcount_test()
 	local inc=
 
 	f_LogMsg ${LOG_FILE} "[*] Activate extent discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -886,7 +890,7 @@ function f_refcount_test()
 function f_dxdir_test()
 {
 	f_LogMsg ${LOG_FILE} "[*] Activate inode discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t extents -r 2048 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t extents -r 2048 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -968,7 +972,7 @@ function f_multi_inodes_test()
 {
 
 	f_LogMsg ${LOG_FILE} "Activate inode discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t inode -r 800 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t inode -r 800 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -1017,8 +1021,8 @@ function f_multi_extents_test()
 	local filename=
 
 	f_LogMsg ${LOG_FILE} "Activate extents discontig-bg on ${DEVICE}"
-	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT}"
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -1073,8 +1077,8 @@ function f_multi_xattr_test()
 	local remain_space=1024
 
 	f_LogMsg ${LOG_FILE} "Activate extents discontig-bg on ${DEVICE}"
-	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT}"
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -1139,8 +1143,8 @@ function f_multi_refcount_test()
 	local remain_space=1024
 
 	f_LogMsg ${LOG_FILE} "Activate extents discontig-bg on ${DEVICE}"
-	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT}"
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
diff --git a/programs/inline-data/multi-inline-run.sh b/programs/inline-data/multi-inline-run.sh
index 0a2ffa5..f7b0bf8 100755
--- a/programs/inline-data/multi-inline-run.sh
+++ b/programs/inline-data/multi-inline-run.sh
@@ -50,6 +50,8 @@ DATA_LOG_FILE=
 DIRS_LOG_FILE=
 RUN_LOG_FILE=
 MOUNT_POINT=
+CLUSTER_STACK=
+CLUSTER_NAME=
 OCFS2_DEVICE=
 OCFS2_UUID=
 
@@ -126,7 +128,7 @@ exit_or_not()
 ################################################################################
 f_usage()
 {
-    echo "usage: `basename ${0}` [-r MPI_ranks] <-f MPI_hosts> [-a access_method] [-o output] <-d <device>> <-b blocksize> -c <clustersize> <mountpoint path>"
+    echo "usage: `basename ${0}` [-r MPI_ranks] <-f MPI_hosts> [-a access_method] [-o output] <-d <device>> <-b blocksize> -c <clustersize> <-s <cluster-stack>> <-n <cluster-name>> <mountpoint path>"
     echo "       -r size of MPI rank"
     echo "       -a access method for process propagation,should be ssh or rsh,set ssh as a default method when omited."
     echo "       -f MPI hosts list,separated by comma,e.g -f node1.us.oracle.com,node2.us.oracle.com."
@@ -134,9 +136,10 @@ f_usage()
     echo "       -d device name used for ocfs2 volume"
     echo "	 -b block size"
     echo "	 -c cluster size"
+    echo "       -s cluster stack"
+    echo "       -n cluster name"
     echo "       <mountpoint path> path of mountpoint where the ocfs2 volume will be mounted on."
     exit 1;
-
 }
 
 f_getoptions()
@@ -146,7 +149,7 @@ f_getoptions()
                 exit 1
          fi
 
-         while getopts "o:hd:r:a:f:b:c:" options; do
+         while getopts "o:hd:r:a:f:b:c:s:n:" options; do
                 case $options in
 		a ) MPI_ACCESS_METHOD="$OPTARG";;
 		r ) MPI_RANKS="$OPTARG";;
@@ -155,6 +158,8 @@ f_getoptions()
                 d ) OCFS2_DEVICE="$OPTARG";;
 		b ) BLOCKSIZE="$OPTARG";;
 		c ) CLUSTERSIZE="$OPTARG";;
+		s ) CLUSTER_STACK="$OPTARG";;
+		n ) CLUSTER_NAME="$OPTARG";;
                 h ) f_usage
                     exit 1;;
                 * ) f_usage
@@ -212,7 +217,7 @@ f_do_mkfs_and_mount()
 {
 	echo -n "Mkfsing device(-b ${BLOCKSIZE} -C ${CLUSTERSIZE}): "|tee -a ${RUN_LOG_FILE}
 
-	echo y|${MKFS_BIN} --fs-features=inline-data -b ${BLOCKSIZE} -C ${CLUSTERSIZE} -N 4 -L ocfs2-inline-test ${OCFS2_DEVICE} ${BLOCKNUMS}>>${RUN_LOG_FILE} 2>&1
+	echo y|${MKFS_BIN} --fs-features=inline-data -b ${BLOCKSIZE} -C ${CLUSTERSIZE} --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} -N 4 -L ocfs2-inline-test ${OCFS2_DEVICE} ${BLOCKNUMS}>>${RUN_LOG_FILE} 2>&1
 
 	RET=$?
 	echo_status ${RET} |tee -a ${RUN_LOG_FILE}
diff --git a/programs/inline-data/single-inline-run.sh b/programs/inline-data/single-inline-run.sh
index 89b2f4c..92a0317 100755
--- a/programs/inline-data/single-inline-run.sh
+++ b/programs/inline-data/single-inline-run.sh
@@ -105,11 +105,13 @@ exit_or_not()
 ################################################################################
 f_usage()
 {
-    echo "usage: `basename ${0}` [-o output] <-b blocksize> <-c clustersize> <-d <device>> <mountpoint path>"
+    echo "usage: `basename ${0}` [-o output] <-b blocksize> <-c clustersize> <-d <device>> <-s <cluster stack>> <-n <cluster name>> <mountpoint path>"
     echo "       -o output directory for the logs"
     echo "       -b blocksize"
     echo "       -c clustersize"
     echo "       -d device name used for ocfs2 volume"
+    echo "       -s cluster stack"
+    echo "       -n cluster name"
     echo "       <mountpoint path> path of mountpoint where the ocfs2 volume will be mounted on."
     exit 1;
 
@@ -122,12 +124,14 @@ f_getoptions()
                 exit 1
          fi
 
-         while getopts "o:hd:b:c:" options; do
+         while getopts "o:hd:b:c:s:n:" options; do
                 case $options in
                 o ) LOG_OUT_DIR="$OPTARG";;
                 d ) OCFS2_DEVICE="$OPTARG";;
                 b ) BLOCKSIZE="$OPTARG";;
                 c ) CLUSTERSIZE="$OPTARG";;
+		s ) CLUSTER_STACK="$OPTARG";;
+                n ) CLUSTER_NAME="$OPTARG";;
                 h ) f_usage
                     exit 1;;
                 * ) f_usage
@@ -174,7 +178,7 @@ f_do_mkfs_and_mount()
 {
 	echo -n "Mkfsing device:"|tee -a ${RUN_LOG_FILE}
 
-	echo y|${MKFS_BIN} --fs-features=inline-data -b ${BLOCKSIZE} -C ${CLUSTERSIZE} -N 4 ${OCFS2_DEVICE} ${BLOCKNUMS} >>${RUN_LOG_FILE} 2>&1
+	echo y|${MKFS_BIN} --fs-features=inline-data --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} -b ${BLOCKSIZE} -C ${CLUSTERSIZE} -N 4 ${OCFS2_DEVICE} ${BLOCKNUMS} >>${RUN_LOG_FILE} 2>&1
 	RET=$?
 	echo_status ${RET} |tee -a ${RUN_LOG_FILE}
 	exit_or_not ${RET}
diff --git a/programs/mkfs-tests/mkfs-test.sh b/programs/mkfs-tests/mkfs-test.sh
index 67299ac..2a3f4b7 100755
--- a/programs/mkfs-tests/mkfs-test.sh
+++ b/programs/mkfs-tests/mkfs-test.sh
@@ -3,12 +3,14 @@
 # mkfs_test -o <outdir> -d <device> -b <blocksize> -c <clustersize>
 #
 usage() {
-    echo "usage: ${MKFS_TEST} -o <outdir> -d <device> -m <mountpoint> -b <blocksize> -c <clustersize>"
+    echo "usage: ${MKFS_TEST} -o <outdir> -d <device> -m <mountpoint> -b <blocksize> -c <clustersize> -s <cluster-stack> -n <cluster-name>"
     echo "       -o output directory for the logs"
     echo "       -d device"
     echo "       -m mountpoint"
     echo "       -b blocksize"
     echo "       -c clustersize"
+    echo "       -s cluster stack"
+    echo "       -n cluster name"
     exit 1
 }
 
@@ -107,8 +109,8 @@ do_fsck() {
 }
 
 do_mkfs() {
-    if [ "$#" -lt "5" ] ; then
-        echo "do_mkfs(): blocksize clustersize device volsize out"  |tee -a ${LOGFILE}
+    if [ "$#" -lt "7" ] ; then
+        echo "do_mkfs(): blocksize clustersize device volsize out cluster-stack cluster-name"  |tee -a ${LOGFILE}
         exit 1
     fi
 
@@ -117,11 +119,13 @@ do_mkfs() {
     D=$3
     V=$4
     O=$5
+    S=$6
+    N=$7
 
-    echo ${MKFS} -b ${B} -C ${C} ${D} ${V} >> ${LOGFILE}
+    echo ${MKFS} -b ${B} -C ${C} ${D} ${V} --cluster-stack=${S} --cluster-name=${N} >> ${LOGFILE}
     echo -n "mkfs ..... " |tee -a ${LOGFILE}
-    echo ${MKFS} -b ${B} -C ${C} ${D} ${V} >> ${O}
-    ${MKFS} -x -F -b ${B} -C ${C} -N 1 -J size=4M ${D} ${V} >> ${O} 2>&1
+    echo ${MKFS} -b ${B} -C ${C} ${D} ${V} --cluster-stack=${S} --cluster-name=${N} >> ${O}
+    ${MKFS} -x -F -b ${B} -C ${C} -N 1 -J size=4M ${D} ${V} --cluster-stack=${S} --cluster-name=${N} >> ${O} 2>&1
     echo "OK" |tee -a ${LOGFILE}
     echo "" >> ${O}
 }
@@ -260,7 +264,7 @@ mntdir=
 blocksize=
 clustersize=
 OPTIND=1
-while getopts "d:i:o:m:c:b:" args
+while getopts "d:i:o:m:c:b:s:n:" args
 do
   case "$args" in
     o) outdir="$OPTARG";;
@@ -268,6 +272,8 @@ do
     m) mntdir="$OPTARG";;
     b) blocksize="$OPTARG";;
     c) clustersize="$OPTARG";;
+    s) cluster_stack="$OPTARG";;
+    n) cluster_name="$OPTARG";;
   esac
 done
 LOGFILE=${outdir}/mkfs-test.log
@@ -290,6 +296,16 @@ if [ -z "${mntdir}" ]; then
     usage ;
 fi
 
+if [ -z "${cluster_stack}" ]; then
+    echo "invalid cluster stack: ${cluster_stack}" |tee -a ${LOGFILE}
+    usage ;
+fi
+
+if [ -z "${cluster_name}" ]; then
+    echo "invalid cluster name: ${cluster_name}" |tee -a ${LOGFILE}
+    usage ;
+fi
+
 echo "create logdir ${outdir}" |tee -a ${LOGFILE}
 mkdir -p ${outdir}
 
@@ -326,7 +342,7 @@ do
 	fi;
 
         echo "Test ${testnum}: -b ${blks} -C ${clusts}" |tee -a ${LOGFILE}
-        do_mkfs ${blks} ${clusts} ${device} ${numblks} ${OUT}
+        do_mkfs ${blks} ${clusts} ${device} ${numblks} ${OUT} ${cluster_stack} ${cluster_name}
         verify_sizes ${blks} ${clusts} ${numblks} ${OUT}
         do_fsck ${OUT}
         testnum=$[$testnum+1]
@@ -366,7 +382,7 @@ if [ -f ${OUT} ]; then
 fi;
 echo "Test ${testnum}: -T datafiles" |tee -a ${LOGFILE}
 echo -n "mkfs ..... " |tee -a ${LOGFILE}
-${MKFS} -x -F -b 4K -C 4K -N 2 -T datafiles ${device} 262144 >${OUT} 2>&1
+${MKFS} -x -F -b 4K -C 4K -N 2 -T datafiles ${device} --cluster-stack=${S} --cluster-name=${N} 262144 >${OUT} 2>&1
 echo "OK" |tee -a ${LOGFILE}
 echo -n "verify ..... " |tee -a ${LOGFILE}
 ${DEBUGFS} -R "ls -l //" ${device} >>${OUT} 2>&1
@@ -393,7 +409,7 @@ do
     fi;
     echo "Test ${testnum}: -J size=${jrnlsz}M" |tee -a ${LOGFILE}
     echo -n "mkfs ..... " |tee -a ${LOGFILE}
-    ${MKFS} -x -F -b 4K -C 4K -N 2 -J size=${jrnlsz}M ${device} 262144 >${OUT} 2>&1
+    ${MKFS} -x -F -b 4K -C 4K -N 2 -J size=${jrnlsz}M ${device} --cluster-stack=${S} --cluster-name=${N} 262144 >${OUT} 2>&1
     echo "OK" |tee -a ${LOGFILE}
     echo -n "verify ..... " |tee -a ${LOGFILE}
     ${DEBUGFS} -R "ls -l //" ${device} >>${OUT} 2>&1
@@ -422,7 +438,7 @@ do
     fi;
     echo "Test ${testnum}: -N ${slots}" |tee -a ${LOGFILE}
     echo -n "mkfs ..... " |tee -a ${LOGFILE}
-    ${MKFS} -x -F -b 4K -C 4K -N ${slots} -J size=4M ${device} 262144 >${OUT} 2>&1
+    ${MKFS} -x -F -b 4K -C 4K -N ${slots} -J size=4M ${device} --cluster-stack=${S} --cluster-name=${N} 262144 >${OUT} 2>&1
     echo "OK" |tee -a ${LOGFILE}
     echo -n "verify ..... " |tee -a ${LOGFILE}
     ${DEBUGFS} -R "stats" ${device} >>${OUT} 2>&1
@@ -448,7 +464,7 @@ fi;
 echo "Test ${testnum}: -L mylabel" |tee -a ${LOGFILE}
 label="my_label_is_very_very_very_long_to_the_point_of_being_useless"
 echo -n "mkfs ..... " |tee -a ${LOGFILE}
-${MKFS} -x -F -b 4K -C 4K -N 1 -L ${label} ${device} 262144 >${OUT} 2>&1
+${MKFS} -x -F -b 4K -C 4K -N 1 -L ${label} ${device} --cluster-stack=${S} --cluster-name=${N} 262144 >${OUT} 2>&1
 echo "OK" |tee -a ${LOGFILE}
 echo -n "verify ..... " |tee -a ${LOGFILE}
 ${DEBUGFS} -R "stats" ${device} >${OUT} 2>&1
@@ -473,7 +489,7 @@ fi;
 echo "Test ${testnum}: --fs-features=inline-data" |tee -a ${LOGFILE}
 label="Oracle_Home"
 echo -n "mkfs ..... " |tee -a ${LOGFILE}
-${MKFS} --fs-features=inline-data -x -F -b 4K -C 4K -N 2 -L ${label} ${device} 262144 >>${OUT} 2>&1
+${MKFS} --fs-features=inline-data -x -F -b 4K -C 4K -N 2 -L ${label} ${device} --cluster-stack=${S} --cluster-name=${N} 262144 >>${OUT} 2>&1
 echo "OK" |tee -a ${LOGFILE}
 echo -n "verify ..... " |tee -a ${LOGFILE}
 ${DEBUGFS} -R "stats" ${device} >>${OUT} 2>&1
@@ -499,7 +515,7 @@ fi;
 echo "Test ${testnum}: Default option for sparse file support" |tee -a ${LOGFILE}
 label="Oracle_Home"
 echo -n "mkfs ..... " |tee -a ${LOGFILE}
-${MKFS} -x -F -b 4K -C 4K -N 2 -L ${label} ${device} 262144 >>${OUT} 2>&1
+${MKFS} -x -F -b 4K -C 4K -N 2 -L ${label} ${device} --cluster-stack=${S} --cluster-name=${N} 262144 >>${OUT} 2>&1
 echo "OK" |tee -a ${LOGFILE}
 echo -n "verify ..... " |tee -a ${LOGFILE}
 ${DEBUGFS} -R "stats" ${device} >>${OUT} 2>&1
@@ -533,7 +549,7 @@ then
 fi
 echo "Test ${testnum}: bitmap_cpg change" |tee -a ${LOGFILE}
 echo -n "mkfs ..... " |tee -a ${LOGFILE}
-${MKFS} -x -F -b ${blocksz} -C ${clustsz} -N 2 ${device} ${blkcount} >${OUT} 2>&1
+${MKFS} -x -F -b ${blocksz} -C ${clustsz} -N 2 ${device} --cluster-stack=${S} --cluster-name=${N} ${blkcount} >${OUT} 2>&1
 echo "OK" |tee -a ${LOGFILE}
 
 #consume the whole volume and then delete all the files.
diff --git a/programs/python_common/multiple_run.sh b/programs/python_common/multiple_run.sh
index b2d5800..3e52eff 100755
--- a/programs/python_common/multiple_run.sh
+++ b/programs/python_common/multiple_run.sh
@@ -43,6 +43,8 @@ REMOTE_UMOUNT_BIN="${BINDIR}/remote_umount.py"
 NODE_LIST=
 DEVICE=
 MOUNT_POINT=
+CLUSTER_STACK=
+CLUSTER_NAME=
 KERNELSRC=
 
 ACCESS_METHOD="ssh"
@@ -73,7 +75,7 @@ set -o pipefail
 f_usage()
 {
     echo "usage: `basename ${0}` <-k kerneltarball> [-b blocksize] [-c clustersize] <-n nodes> [-i nic] \
-[-a access_method] [-o logdir] <-d device> [-t testcases] <mountpoint path>"
+[-a access_method] [-o logdir] <-d device> [-t testcases] [-s stack name] [-C cluster name] <mountpoint path>"
     echo "       -k kerneltarball should be path of tarball for kernel src."
     echo "       -n nodelist,should be comma separated."
     echo "       -b blocksize."
@@ -83,6 +85,8 @@ f_usage()
     echo "       -a access method for mpi execution,should be ssh or rsh"
     echo "       -d device name used for ocfs2 volume."
     echo "       -t sepcify testcases to run."
+    echo "       -s cluster stack."
+    echo "       -C cluster name."
     echo "       <mountpoint path> path of mountpoint where test will be performed."
     echo 
     echo "Eaxamples:"
@@ -99,7 +103,7 @@ f_getoptions()
 		exit 1
 	fi
 
-	while getopts "n:d:i:a:o:b:c:k:t:h:" options; do
+	while getopts "n:d:i:a:o:k:b:c:t:s:C:h:" options; do
 		case $options in
 		n ) NODE_LIST="$OPTARG";;
 		d ) DEVICE="$OPTARG";;
@@ -110,6 +114,8 @@ f_getoptions()
 		c ) CLUSTERSIZE="$OPTARG";;
 		k ) KERNELSRC="$OPTARG";;
 		t ) TESTCASES="$OPTARG";;
+		s ) CLUSTER_STACK="$OPTARG";;
+		C ) CLUSTER_NAME="$OPTARG";;
 		h ) f_usage
 		    exit 1;;
                 * ) f_usage
@@ -280,7 +286,7 @@ run_common_testcase()
 
 	LogMsg "Mkfs device ${DEVICE}:"
 	f_mkfs ${LOGFILE} ${BLOCKSIZE} ${CLUSTERSIZE} ${LABELNAME} ${SLOTS} \
-${DEVICE} ${FEATURES} ${JOURNALSIZE} ${BLOCKS}
+${DEVICE} ${FEATURES} ${JOURNALSIZE} ${BLOCKS} ${CLUSTER_STACK} ${CLUSTER_NAME}
         RET=$?
         f_exit_or_not ${RET}
 
@@ -363,7 +369,7 @@ run_xattr_test()
 
 	LogRunMsg "xattr-test"
 	${BINDIR}/xattr-multi-run.sh -r 4 -f ${NODE_LIST} -a ssh -o ${logdir} \
--d ${DEVICE} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
+-d ${DEVICE} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
 	LogRC $?
 }
 
@@ -373,7 +379,7 @@ run_inline_test()
 
 	LogRunMsg "inline-test"
 	${BINDIR}/multi-inline-run.sh -r 2 -f ${NODE_LIST} -a ssh -o ${logdir} \
--d ${DEVICE} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
+-d ${DEVICE} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
 	LogRC $?
 }
 
@@ -384,14 +390,14 @@ run_reflink_test()
 	LogRunMsg "reflink-test"
 	LogMsg "reflink 'data=ordered' mode test"
 	${BINDIR}/multi_reflink_test_run.sh -r 4 -f ${NODE_LIST} -a ssh -o \
-${logdir} -d ${DEVICE} ${MOUNT_POINT} >> ${LOGFILE} 2>&1 || {
+${logdir} -d ${DEVICE} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >> ${LOGFILE} 2>&1 || {
 	RET=$?
 	LogRC $RET
 	return $RET
 }
 #	LogMsg "reflink 'data=writeback' mode test"
 #	${BINDIR}/multi_reflink_test_run.sh -r 4 -f ${NODE_LIST} -a ssh -o \
-#${logdir} -W -d ${DEVICE} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
+#${logdir} -W -d ${DEVICE} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
 	LogRC $?
 }
 
@@ -415,7 +421,7 @@ run_lvb_torture_test()
 
 	LogMsg "Mkfs device ${DEVICE}:"
 	f_mkfs ${LOGFILE} ${BLOCKSIZE} ${CLUSTERSIZE} ${LABELNAME} ${SLOTS} \
-${DEVICE} ${FEATURES} ${JOURNALSIZE} ${BLOCKS}
+${DEVICE} ${FEATURES} ${JOURNALSIZE} ${BLOCKS} ${CLUSTER_STACK} ${CLUSTER_NAME}
         RET=$?
         f_exit_or_not ${RET}
 
diff --git a/programs/python_common/o2tf.sh b/programs/python_common/o2tf.sh
index a7e8b49..a6c7ba1 100755
--- a/programs/python_common/o2tf.sh
+++ b/programs/python_common/o2tf.sh
@@ -145,12 +145,18 @@ function f_mkfs()
 	#${7} specify fs features
 	#${8} specify journal size
 	#${9} specify volume size
+	#${10} specify cluster stack
+	#${11} specify cluster name
 
 	local slot_opts=""
+        local cluster_stack=""
+        local cluster_name=""
 	if [ "${5}" == "0" ];then
 		slot_opts="-M local"
 	else
 		slot_opts="-N ${5}"
+                cluster_stack="--cluster-stack=${10}" #cluster stack
+                cluster_name="--cluster-name=${11}" #cluster name
 	fi
 	
 	local journal_opts=""
@@ -170,12 +176,16 @@ function f_mkfs()
 	local L=${4} #volume name
 	local D=${6} #device name
 	local O=${7} #fs featuers
+	local S=${10} #cluster stack
+	local N=${11} #cluster name
 	
-	shift 9
+	shift 11
 	R=${1} #Reserved options
 	
-        f_LogMsg ${logfile} "${MKFS_BIN} --fs-features=${O} -b ${B} -C ${C} -L ${L} ${slot_opts} ${journal_opts} ${R} ${D} ${blocks}"
-        echo "y"|${MKFS_BIN} --fs-features=${O} -b ${B} -C ${C} -L ${L} ${slot_opts} ${journal_opts} ${R} ${D} ${blocks}>>${logfile} 2>&1
+        f_LogMsg ${logfile} "${MKFS_BIN} --fs-features=${O} ${cluster_stack} ${cluster_name} \
+-b ${B} -C ${C} -L ${L} ${slot_opts} ${journal_opts} ${R} ${D} ${blocks}"
+        echo "y"|${MKFS_BIN} --fs-features=${O} ${cluster_stack} ${cluster_name} \
+-b ${B} -C ${C} -L ${L} ${slot_opts} ${journal_opts} ${R} ${D} ${blocks}>>${logfile} 2>&1
         RET=$?
 
         if [ "${RET}" != "0" ];then
diff --git a/programs/python_common/single_run-WIP.sh b/programs/python_common/single_run-WIP.sh
index c7bbfdf..5c174f0 100755
--- a/programs/python_common/single_run-WIP.sh
+++ b/programs/python_common/single_run-WIP.sh
@@ -886,7 +886,7 @@ run_reserve_space()
 run_inline_data()
 {
 	log_message "run_inline_data" $@
-        if [ "$#" -lt "5" ]; then
+        if [ "$#" -lt "7" ]; then
                 echo "Error in run_inline_data()"
                 exit 1
         fi
@@ -896,9 +896,11 @@ run_inline_data()
 	mountpoint=$3
 	blocksize=$4
 	clustersize=$5
+	cluster_stack=$6
+	cluster_name=$7
 
 	log_start "inline_data_test" 
-	single-inline-run.sh  -o ${logdir} -d ${device} -b ${blocksize} -c ${clustersize} ${mountpoint}
+	single-inline-run.sh  -o ${logdir} -d ${device} -b ${blocksize} -c ${clustersize} -s ${cluster_stack} -n ${cluster_name} ${mountpoint}
 	RC=$?
 	log_end ${RC}
 }
@@ -927,7 +929,7 @@ run_dx_dir()
 run_xattr_test()
 {
 	log_message "run_xattr_test" $@
-        if [ "$#" -lt "5" ]; then
+        if [ "$#" -lt "7" ]; then
                 echo "Error in run_xattr_test()"
                 exit 1
         fi
@@ -937,9 +939,11 @@ run_xattr_test()
 	mountpoint=$3
 	blocksize=$4
 	clustersize=$5
+	cluster_stack=$6
+	cluster_name=$7
 
 	log_start "xattr_test" 
-	xattr-single-run.sh -c -o ${logdir} -d ${device} -b ${blocksize} -C ${clustersize} ${mountpoint}
+	xattr-single-run.sh -c -o ${logdir} -d ${device} -b ${blocksize} -C ${clustersize} -s ${cluster_stack} -n ${cluster_name} ${mountpoint}
 	RC=$?
 
 	log_end ${RC}
@@ -948,7 +952,7 @@ run_xattr_test()
 run_reflink_test()
 {
 	log_message "run_reflink_test" $@
-        if [ "$#" -lt "5" ]; then
+        if [ "$#" -lt "7" ]; then
                 echo "Error in run_reflink()"
                 exit 1
         fi
@@ -958,17 +962,19 @@ run_reflink_test()
 	mountpoint=$3
 	blocksize=$4
 	clustersize=$5
+	cluster_stack=$6
+	cluster_name=$7
 
 	#ordered mount option
 	log_start "reflink_test" "ordered"
-	reflink_test_run.sh -o ${logdir} -d ${device} -b ${blocksize} -c ${clustersize} ${mountpoint} || {
+	reflink_test_run.sh -o ${logdir} -d ${device}  -b ${blocksize} -c ${clustersize} -s ${cluster_stack} -n ${cluster_name} ${mountpoint} || {
 		RC=$?
 		log_end ${RC}
 	}
 
 	#writeback mount option
 	#log_start "reflink_test" "writeback"
-	#reflink_test_run.sh -W -o ${logdir} -d ${device} -b ${blocksize} -c ${clustersize} ${mountpoint}
+	#reflink_test_run.sh -W -o ${logdir} -d ${device} -b ${blocksize} -c ${clustersize} -s ${cluster_stack} -n ${cluster_name} ${mountpoint}
 	RC=$?
 	log_end ${RC}
 }
@@ -997,7 +1003,7 @@ run_filecheck_test()
 run_mkfs()
 {
 	log_message "run_mkfs" $@
-        if [ "$#" -lt "5" ]; then
+        if [ "$#" -lt "7" ]; then
                 echo "Error in run_mkfs()"
                 exit 1
         fi
@@ -1007,9 +1013,11 @@ run_mkfs()
 	mountpoint=$3
 	blocksize=$4
 	clustersize=$5
+	cluster_stack=$6
+	cluster_name=$7
 
 	log_start "mkfs_test"
-	mkfs-test.sh -o ${logdir} -d ${device} -m ${mountpoint} -b ${blocksize} -c ${clustersize}
+	mkfs-test.sh -o ${logdir} -d ${device} -m ${mountpoint} -b ${blocksize} -c ${clustersize} -s ${cluster_stack} -n ${cluster_name}
 	RC=$?
 	log_end ${RC}
 }
@@ -1017,7 +1025,7 @@ run_mkfs()
 run_tunefs()
 {
 	log_message "run_tunefs" $@
-        if [ "$#" -lt "5" ]; then
+        if [ "$#" -lt "7" ]; then
                 echo "Error in run_tunefs()"
                 exit 1
         fi
@@ -1027,9 +1035,11 @@ run_tunefs()
 	mountpoint=$3
 	blocksize=$4
 	clustersize=$5
+	cluster_stack=$6
+	cluster_name=$7
 
 	log_start "tunefs_test"
-	tunefs-test.sh -o ${logdir} -d ${device} -m ${mountpoint} -b ${blocksize} -c ${clustersize}
+	tunefs-test.sh -o ${logdir} -d ${device} -m ${mountpoint} -b ${blocksize} -c ${clustersize} -s ${cluster_stack} -n ${cluster_name}
 	RC=$?
 	log_end ${RC}
 }
@@ -1037,7 +1047,7 @@ run_tunefs()
 run_backup_super()
 {
 	log_message "run_backup_super" $@
-        if [ "$#" -lt "4" ]; then
+        if [ "$#" -lt "6" ]; then
                 echo "Error in run_backup_super()"
                 exit 1
         fi
@@ -1046,9 +1056,11 @@ run_backup_super()
 	device=$2
 	blocksize=$3
 	clustersize=$4
+	cluster_stack=$5
+	cluster_name=$6
 
 	log_start "backup_super_test"
-	test_backup_super.sh --log-dir=${logdir} --block-size=${blocksize} --cluster-size=${clustersize} ${device}
+	test_backup_super.sh --log-dir=${logdir} --block-size=${blocksize} --cluster-size=${clustersize} --cluster-stack=${cluster_stack} --cluster-name=${cluster_name} ${device}
 	RC=$?
 	log_end ${RC}
 }
@@ -1061,11 +1073,13 @@ run_backup_super()
 
 usage()
 {
-	${ECHO} "usage: ${APP} [-k kerneltarball] -m mountpoint -l logdir -d device [-t testcases] [-b blocksize] [-c clustersize]"
+	${ECHO} "usage: ${APP} [-k kerneltarball] -m mountpoint -l logdir -d device [-t testcases] [-b blocksize] \
+[-c clustersize] [-s cluster-stack] [-n cluster-name]"
 	exit 1
 }
 
-while getopts "d:m:k:l:t:b:c:h:?" args
+
+while getopts "d:m:k:l:t:b:c:s:n:h?" args
 do
 	case "$args" in
 		d) DEVICE="$OPTARG";;
@@ -1075,11 +1089,12 @@ do
 		t) TESTCASES="$OPTARG";;
 		b) BLOCKSIZE="$OPTARG";;
 		c) CLUSTERSIZE="$OPTARG";;
-    		h) usage;;
+		s) CLUSTER_STACK="$OPTARG";;
+		n) CLUSTER_NAME="$OPTARG";;
+		h) usage;;
     		?) usage;;
   	esac
 done
-
 if [ -z ${DEVICE} ] ; then
 	${ECHO} "ERROR: No device"
 	usage
@@ -1096,6 +1111,16 @@ elif [ ! -d ${MOUNTPOINT} ] ; then
 	exit 1
 fi
 
+if [ -z ${CLUSTER_STACK} ] ; then
+	${ECHO} "ERROR: No cluster stack"
+	usage
+fi
+
+if [ -z ${CLUSTER_NAME} ] ; then
+	${ECHO} "ERROR: No cluster name"
+	usage
+fi
+
 if [ -z ${OUTDIR} ]; then
 	${ECHO} "ERROR: No logdir"
 	usage
@@ -1134,7 +1159,7 @@ ${ECHO} "Output log is ${LOGFILE}"
 for tc in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 
 	if [ "$tc"X = "create_and_open"X -o "$tc"X = "all"X ];then
-		run_create_and_open ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
+		run_create_and_open ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE} ${CLUSTER_STACK} ${CLUSTER_NAME}
 	fi
 
 	if [ "$tc"X = "directaio"X -o "$tc"X = "all"X ];then
@@ -1184,7 +1209,7 @@ for tc in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 	fi
 
 	if [ "$tc"X = "mmap"X -o "$tc"X = "all"X ];then
-		run_mmap ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
+		run_mmap ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE} ${CLUSTER_STACK} ${CLUSTER_NAME}
 	fi
 
 	if [ "$tc"X = "reserve_space"X -o "$tc"X = "all"X ];then
@@ -1192,15 +1217,15 @@ for tc in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 	fi
 
 	if [ "$tc"X = "inline"X -o "$tc"X = "all"X ];then
-		run_inline_data ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
+		run_inline_data ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE} ${CLUSTER_STACK} ${CLUSTER_NAME}
 	fi
 
 	if [ "$tc"X = "xattr"X -o "$tc"X = "all"X ];then
-		run_xattr_test ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
+		run_xattr_test ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE} ${CLUSTER_STACK} ${CLUSTER_NAME}
 	fi
 
 	if [ "$tc"X = "reflink"X -o "$tc"X = "all"X ];then
-		run_reflink_test ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
+		run_reflink_test ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE} ${CLUSTER_STACK} ${CLUSTER_NAME}
 	fi
 
 	if [ "$tc"X = "filecheck"X ];then
@@ -1210,15 +1235,15 @@ for tc in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 # For tools test.
 
 	if [ "$tc"X = "mkfs"X -o "$tc"X = "all"X ];then
-		run_mkfs ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
+		run_mkfs ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE} ${CLUSTER_STACK} ${CLUSTER_NAME}
 	fi
 
 	if [ "$tc"X = "tunefs"X -o "$tc"X = "all"X ];then
-		run_tunefs ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE}
+		run_tunefs ${LOGDIR} ${DEVICE} ${MOUNTPOINT} ${BLOCKSIZE} ${CLUSTERSIZE} ${CLUSTER_STACK} ${CLUSTER_NAME}
 	fi
 
 	if [ "$tc"X = "backup_super"X -o "$tc"X = "all"X ];then
-		run_backup_super ${LOGDIR} ${DEVICE} ${BLOCKSIZE} ${CLUSTERSIZE}
+		run_backup_super ${LOGDIR} ${DEVICE} ${BLOCKSIZE} ${CLUSTERSIZE} ${CLUSTER_STACK} ${CLUSTER_NAME}
 	fi
 
 done
diff --git a/programs/reflink_tests/multi_reflink_test_run.sh b/programs/reflink_tests/multi_reflink_test_run.sh
index 3dc0c68..22923a0 100755
--- a/programs/reflink_tests/multi_reflink_test_run.sh
+++ b/programs/reflink_tests/multi_reflink_test_run.sh
@@ -70,6 +70,8 @@ LOG_FILE=
 
 MOUNT_OPTS=
 AIO_OPT=
+CLUSTER_STACK=
+CLUSTER_NAME=
 
 DEFAULT_RANKS=4
 MPI_RANKS=
@@ -90,7 +92,7 @@ set -o pipefail
 function f_usage()
 {
     echo "usage: `basename ${0}` [-r MPI_Ranks] <-f MPI_Hosts> \
-[-a access method] [-o logdir] <-d <device>> <-b block size> <-c cluster size> [-W] [-A] <mountpoint path>"
+[-a access method] [-o logdir] <-d <device>> <-b block size> <-c cluster size> <-s <cluster stack>> <-n <cluster name>> [-W] [-A] <mountpoint path>"
     echo "       -r size of MPI rank"
     echo "       -a access method for mpi execution,should be ssh or rsh"
     echo "       -f MPI hosts list,separated by comma"
@@ -101,6 +103,8 @@ function f_usage()
     echo "       -i Network Interface name to be used for MPI messaging."
     echo "       -W enable data=writeback mode"
     echo "       -A enable asynchronous io testing mode"
+    echo "       -s cluster stack"
+    echo "       -n cluster name"
     echo "       <mountpoint path> specify the mounting point."
     exit 1;
 
@@ -112,7 +116,7 @@ function f_getoptions()
                 exit 1
          fi
 
-	 while getopts "o:d:i:r:f:WAha:b:c:" options; do
+	 while getopts "o:d:i:r:f:WAha:b:c:s:n:" options; do
                 case $options in
 		r ) MPI_RANKS="$OPTARG";;
                 f ) MPI_HOSTS="$OPTARG";;
@@ -124,6 +128,8 @@ function f_getoptions()
 		c ) CLUSTERSIZE="$OPTARG";;
 		W ) MOUNT_OPTS="data=writeback";;
 		A ) AIO_OPT=" -A ";;
+		s ) CLUSTER_STACK="$OPTARG";;
+		n ) CLUSTER_NAME="$OPTARG";;
                 h ) f_usage
                     exit 1;;
                 * ) f_usage
@@ -195,7 +201,7 @@ function f_runtest()
 {
 	f_LogRunMsg ${RUN_LOG_FILE} "[*] Mkfs device ${DEVICE}:"
 	f_mkfs ${LOG_FILE} ${BLOCKSIZE} ${CLUSTERSIZE} ${LABELNAME} ${SLOTS} \
-${DEVICE} "refcount,xattr" ${JOURNALSIZE} ${BLOCKS}
+${DEVICE} "refcount,xattr" ${JOURNALSIZE} ${BLOCKS} ${CLUSTER_STACK} ${CLUSTER_NAME}
 	RET=$?
 	f_echo_status ${RET}| tee -a ${RUN_LOG_FILE}
 	f_exit_or_not ${RET}
diff --git a/programs/reflink_tests/reflink_test_run.sh b/programs/reflink_tests/reflink_test_run.sh
index d09a8f0..f415185 100755
--- a/programs/reflink_tests/reflink_test_run.sh
+++ b/programs/reflink_tests/reflink_test_run.sh
@@ -101,6 +101,8 @@ function f_usage()
 [-v verify_log] [-W] [-A] [-o logdir] <-d device> <-b blocksize> <-c clustersize> <mountpoint path>"
         echo "       -o output directory for the logs"
         echo "       -d block device name used for ocfs2 volume"
+	echo "	     -s cluster stack"
+	echo "	     -n cluster name"
         echo "       -W enable data=writeback mode"
 	echo "       -A enable asynchronous io testing mode"
 	echo "       -D enable destructive test,it will crash the testing node,\
@@ -119,7 +121,7 @@ function f_getoptions()
                 exit 1
          fi
 
-         while getopts "o:WDAhd:a:p:v:b:c:" options; do
+         while getopts "o:WDAhd:a:p:v:b:c:s:n:" options; do
                 case $options in
                 o ) LOG_DIR="$OPTARG";;
                 d ) DEVICE="$OPTARG";;
@@ -131,6 +133,8 @@ function f_getoptions()
 		v ) VERI_LOG="$OPTARG";;
 		b ) BLOCKSIZE="$OPTARG";;
 		c ) CLUSTERSIZE="$OPTARG";;
+		s ) CLUSTER_STACK="$OPTARG";;
+		n ) CLUSTER_NAME="$OPTARG";;
                 h ) f_usage;;
                 * ) f_usage;;
                 esac
@@ -422,7 +426,7 @@ ${WORK_PLACE} -v ${VERI_LOG} >>${LOG_FILE} 2>&1
 
 	f_LogRunMsg ${RUN_LOG_FILE} "[*] Mkfs device ${DEVICE}:"
 	f_mkfs ${LOG_FILE} ${BLOCKSIZE} ${CLUSTERSIZE} ${LABELNAME} ${SLOTS} \
-${DEVICE} "refcount,xattr" ${JOURNALSIZE} ${BLOCKS}
+${DEVICE} "refcount,xattr" ${JOURNALSIZE} ${BLOCKS} ${CLUSTER_STACK} ${CLUSTER_NAME}
 	RET=$?
 	f_echo_status ${RET}| tee -a ${RUN_LOG_FILE}
 	f_exit_or_not ${RET}
diff --git a/programs/tunefs-test/tunefs-test.sh b/programs/tunefs-test/tunefs-test.sh
index 0fc3da3..ea5439d 100755
--- a/programs/tunefs-test/tunefs-test.sh
+++ b/programs/tunefs-test/tunefs-test.sh
@@ -167,8 +167,8 @@ function test_summary()
 Set_Volume_For_Test()
 {
 	LogMsg "tunefs_test : Initializing volume for test"
-        echo "y"| ${MKFS_BIN} ${FS_FEATURES} -b ${BLOCKSIZE} -C ${CLUSTERSIZE} -L ${LABEL1} -N ${NNODES1} \
-	        -J size=${JOURNAL1} ${2} ${DEVICE} ${1} 2>&1 >> ${MKFSLOG}
+        echo "y"| ${MKFS_BIN} ${FS_FEATURES} --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} \
+-b ${BLOCKSIZE} -C ${CLUSTERSIZE} -L ${LABEL1} -N ${NNODES1} -J size=${JOURNAL1} ${2} ${DEVICE} ${1} 2>&1 >> ${MKFSLOG}
 	Check_Volume;
 }
 #
@@ -237,7 +237,8 @@ Test_Query()
 	(( ++NUM_OF_TESTS ))
 #	Set_Volume_For_Test ${BLKCNT1} --fs-feature-level=default
 	echo "y"| ${MKFS_BIN} -b ${BLOCKSIZE} -C ${CLUSTERSIZE} -L ${LABEL1} -N ${NNODES1} \
-		-J size=${JOURNAL1} --fs-feature-level=default ${DEVICE} ${BLKCNT1} 2>&1 >> ${MKFSLOG}
+-J size=${JOURNAL1} --fs-feature-level=default --cluster-stack=${CLUSTER_STACK} \
+--cluster-name=${CLUSTER_NAME} ${DEVICE} ${BLKCNT1} 2>&1 >> ${MKFSLOG}
 	CURRENT_TEST="Test Query";
 	QRY1="Blks=%B\nClus=%T\nSlot=%N\nRoot=%R\nSysd=%Y\nFclg=%P\n";
 	QRY2="Labl=%V\nUuid=%U\n";
@@ -661,7 +662,7 @@ TUNEFS_TEST=`basename $0`
 bindir=`basename ${0}`
 LOG_DIR=`basename ${bindir}`
 
-while getopts "d:o:m:b:c:" args
+while getopts "d:o:m:b:c:s:n:" args
 do
   case "$args" in
     o) LOG_DIR="$OPTARG";;
@@ -669,6 +670,8 @@ do
     m) MOUNT_POINT="$OPTARG";;
     b) BLOCKSIZE="$OPTARG";;
     c) CLUSTERSIZE="$OPTARG";;
+    s) CLUSTER_STACK="$OPTARG";;
+    n) CLUSTER_NAME="$OPTARG";;
   esac
 done
 
diff --git a/programs/xattr_tests/xattr-multi-run.sh b/programs/xattr_tests/xattr-multi-run.sh
index 0a4f464..2c13929 100755
--- a/programs/xattr_tests/xattr-multi-run.sh
+++ b/programs/xattr_tests/xattr-multi-run.sh
@@ -69,6 +69,8 @@ LOG_OUT_DIR=
 LOG_FILE=
 RUN_LOG_FILE=
 MOUNT_POINT=
+CLUSTER_STACK=
+CLUSTER_NAME=
 OCFS2_DEVICE=
 
 SLOTS=
@@ -145,7 +147,7 @@ exit_or_not()
 ################################################################################
 f_usage()
 {
-    echo "usage: `basename ${0}` [-r MPI_Ranks] <-f MPI_Hosts> [-a access method] [-o output] [-i interface] <-d <device>> <-b blocksize> <-c clustersize> <mountpoint path>"
+    echo "usage: `basename ${0}` [-r MPI_Ranks] <-f MPI_Hosts> [-a access method] [-o output] [-i interface] <-d <device>> <-b blocksize> <-c clustersize> <-s cluster-stack> <-n cluster-name> <mountpoint path>"
     echo "       -r size of MPI rank"
     echo "       -a access method for process propagation,should be ssh or rsh,set ssh as a default method when omited."
     echo "       -f MPI hosts list,separated by comma,e.g -f node1.us.oracle.com,node2.us.oracle.com."
@@ -154,10 +156,13 @@ f_usage()
     echo "       -d specify the device which has been formated as an ocfs2 volume."
     echo "	 -b block size."
     echo "	 -c cluster size."
+    echo "       -s cluster stack."
+    echo "       -n cluster name."
     echo "       <mountpoint path> path of mountpoint where the ocfs2 volume will be mounted on."
     exit 1;
 
 }
+
 f_getoptions()
 {
 	 if [ $# -eq 0 ]; then
@@ -165,7 +170,7 @@ f_getoptions()
                 exit 1
          fi
 
-	 while getopts "o:d:r:f:a:h:i:b:c:" options; do
+	 while getopts "o:d:r:f:a:h:i:b:c:s:n:" options; do
                 case $options in
 		r ) MPI_RANKS="$OPTARG";;
                 f ) MPI_HOSTS="$OPTARG";;
@@ -175,12 +180,16 @@ f_getoptions()
 		i ) INTERFACE="$OPTARG";;
 		b ) BLOCKSIZE="$OPTARG";;
 		c ) CLUSTERSIZE="$OPTARG";;
+		s ) CLUSTER_STACK="$OPTARG";;
+		n ) CLUSTER_NAME="$OPTARG";;
+
                 h ) f_usage
                     exit 1;;
                 * ) f_usage
                    exit 1;;
                 esac
         done
+
 	shift $(($OPTIND -1))
 	MOUNT_POINT=${1}
 }
@@ -256,7 +265,7 @@ f_do_mkfs_and_mount()
 {
         echo -n "Mkfsing device(-b ${BLOCKSIZE} -C ${CLUSTERSIZE}): "|tee -a ${RUN_LOG_FILE}
 
-        echo y|${MKFS_BIN} --fs-features=xattr -b ${BLOCKSIZE} -C ${CLUSTERSIZE} -N ${SLOTS} -L ${LABEL} ${OCFS2_DEVICE} ${BLOCKNUMS}>>${RUN_LOG_FILE} 2>&1
+        echo y|${MKFS_BIN} --fs-features=xattr -b ${BLOCKSIZE} -C ${CLUSTERSIZE} --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} -N ${SLOTS} -L ${LABEL} ${OCFS2_DEVICE} ${BLOCKNUMS}>>${RUN_LOG_FILE} 2>&1
 
         RET=$?
         echo_status ${RET} |tee -a ${RUN_LOG_FILE}
diff --git a/programs/xattr_tests/xattr-single-run.sh b/programs/xattr_tests/xattr-single-run.sh
index 1d3e8f7..93d85ac 100755
--- a/programs/xattr_tests/xattr-single-run.sh
+++ b/programs/xattr_tests/xattr-single-run.sh
@@ -144,12 +144,15 @@ exit_or_not()
 ################################################################################
 f_usage()
 {
-    echo "usage: `basename ${0}` [-c] [-o output_log_dir] <-d <device>> <-b <block size>> <-C <cluster size>> <mountpoint path>"
+    echo "usage: `basename ${0}` [-c] [-o output_log_dir] <-d <device>> <-b <block size>> \
+<-s <stack name>> <-c <cluster name>> <-C <cluster size>> <mountpoint path>"
     echo "	 -c enable the combination test for inline-data and inline-xattr."
     echo "       -o output directory for the logs"
     echo "       -d specify the device which has been formated as an ocfs2 volume."
     echo "	 -b block size."
     echo "	 -C cluster size."
+    echo "       -s cluster stack."
+    echo "       -n cluster name."
     echo "       <mountpoint path> path of mountpoint where the ocfs2 volume will be mounted on."
     exit 1;
 
@@ -162,13 +165,15 @@ f_getoptions()
                 exit 1
          fi
 
-	 while getopts "cho:d:b:C:" options; do
+	 while getopts "cho:d:b:C:s:n:" options; do
                 case $options in
 		c ) COMBIN_TEST="1";;
                 o ) LOG_OUT_DIR="$OPTARG";;
                 d ) OCFS2_DEVICE="$OPTARG";;
 		b ) BLOCKSIZE="$OPTARG";;
 		C ) CLUSTERSIZE="$OPTARG";;
+                s ) CLUSTER_STACK="$OPTARG";;
+                n ) CLUSTER_NAME="$OPTARG";;
                 h ) f_usage
                     exit 1;;
                 * ) f_usage
@@ -226,9 +231,9 @@ f_do_mkfs_and_mount()
 	echo -n "Mkfsing device:"|tee -a ${RUN_LOG_FILE}
 
 	if [ -z "${COMBIN_TEST}" ];then
-		echo y|${MKFS_BIN} --fs-features=xattr -b ${BLOCKSIZE} -C ${CLUSTERSIZE} -N 1 ${OCFS2_DEVICE} ${BLOCKNUMS}>>${RUN_LOG_FILE} 2>&1
+		echo y|${MKFS_BIN} --fs-features=xattr --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} -b ${BLOCKSIZE} -C ${CLUSTERSIZE} -N 1 ${OCFS2_DEVICE} ${BLOCKNUMS}>>${RUN_LOG_FILE} 2>&1
 	else
-		echo y|${MKFS_BIN} --fs-features=xattr,inline-data -b ${BLOCKSIZE} -C ${CLUSTERSIZE} -N 1 ${OCFS2_DEVICE} ${BLOCKNUMS}>>${RUN_LOG_FILE} 2>&1
+		echo y|${MKFS_BIN} --fs-features=xattr,inline-data --cluster-stack=${CLUSTER_STACK} --cluster-name=${CLUSTER_NAME} -b ${BLOCKSIZE} -C ${CLUSTERSIZE} -N 1 ${OCFS2_DEVICE} ${BLOCKNUMS}>>${RUN_LOG_FILE} 2>&1
 	fi
         RET=$?
         echo_status ${RET} |tee -a ${RUN_LOG_FILE}
-- 
2.6.6
