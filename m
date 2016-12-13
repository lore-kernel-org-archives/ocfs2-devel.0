From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:29 +0800
Subject: [Ocfs2-devel] [PATCH 11/17] discontig bg: make blocksize and
	clustersize as parameters
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-12-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add "-b blocksize" and "-c clustersize" as optional parameters.
It will keep the original behavior if we don't specify their
values.

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/discontig_bg_test/discontig_runner.sh | 51 +++++++++++++++++---------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/programs/discontig_bg_test/discontig_runner.sh b/programs/discontig_bg_test/discontig_runner.sh
index bb6a53e..1d94be3 100755
--- a/programs/discontig_bg_test/discontig_runner.sh
+++ b/programs/discontig_bg_test/discontig_runner.sh
@@ -64,7 +64,8 @@ MPI_BTL_IF_ARG=
 ################################################################################
 function f_usage()
 {
-    echo "usage: `basename ${0}` <-d device> [-o logdir] [-m multi_hosts] [-a access_method] <mount point>"
+    echo "usage: `basename ${0}` <-d device> [-o logdir] [-m multi_hosts] [-a access_method] \
+[-b block_size] [-c cluster_size] <mount point>"
     exit 1;
 
 }
@@ -76,13 +77,15 @@ function f_getoptions()
 		exit 1
 	fi
 	
-	while getopts "hd:o:m:a:" options; do
+	while getopts "hd:o:m:a:b:c:" options; do
 		case $options in
 		d ) DEVICE="$OPTARG";;
 		o ) LOG_DIR="$OPTARG";;
 		a ) MPI_ACCESS_METHOD="$OPTARG";;
 		m ) MULTI_TEST=1
 		    MPI_HOSTS="$OPTARG";;
+                b ) BLOCKSIZE="$OPTARG";;
+                c ) CLUSTERSIZE="$OPTARG";;
 		h ) f_usage
 			exit 1;;
 		* ) f_usage
@@ -209,7 +212,7 @@ function f_inodes_test()
 	local filename=
 
 	f_LogMsg ${LOG_FILE} "Activate inode discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t inode -r 200 -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t inode -r 200 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -292,7 +295,7 @@ function f_inodes_test()
 	f_exit_or_not ${RET}
 
 	f_LogMsg ${LOG_FILE} "[*] Activate inode discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t inode -r 4096 -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t inode -r 4096 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -420,7 +423,7 @@ function f_extents_test()
 	local inc=
 
 	f_LogMsg ${LOG_FILE} "[*] Activate extent discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r 2048 -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r 2048 -b ${BLOCKSIZE}-c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -552,7 +555,7 @@ function f_extents_test()
 function f_inline_test()
 {
 	f_LogMsg ${LOG_FILE} "[*] Activate inode discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t inode -r 1024 -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t inode -r 1024 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -622,7 +625,7 @@ function f_inline_test()
 function f_xattr_test()
 {
 	f_LogMsg ${LOG_FILE} "[*] Activate extent discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r 10240 -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r 10240 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -705,7 +708,7 @@ function f_refcount_test()
 	local inc=
 
 	f_LogMsg ${LOG_FILE} "[*] Activate extent discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -883,7 +886,7 @@ function f_refcount_test()
 function f_dxdir_test()
 {
 	f_LogMsg ${LOG_FILE} "[*] Activate inode discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t extents -r 2048 -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t extents -r 2048 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -965,7 +968,7 @@ function f_multi_inodes_test()
 {
 
 	f_LogMsg ${LOG_FILE} "Activate inode discontig-bg on ${DEVICE}"
-	${DISCONTIG_ACTIVATE_BIN} -t inode -r 800 -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	${DISCONTIG_ACTIVATE_BIN} -t inode -r 800 -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -1014,8 +1017,8 @@ function f_multi_extents_test()
 	local filename=
 
 	f_LogMsg ${LOG_FILE} "Activate extents discontig-bg on ${DEVICE}"
-	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT}"
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -1070,8 +1073,8 @@ function f_multi_xattr_test()
 	local remain_space=1024
 
 	f_LogMsg ${LOG_FILE} "Activate extents discontig-bg on ${DEVICE}"
-	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT}"
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -1136,8 +1139,8 @@ function f_multi_refcount_test()
 	local remain_space=1024
 
 	f_LogMsg ${LOG_FILE} "Activate extents discontig-bg on ${DEVICE}"
-	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT}"
-	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b $BLOCKSIZE -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
+	f_LogMsg ${LOG_FILE} "CMD: ${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT}"
+	${DISCONTIG_ACTIVATE_BIN} -t extent -r ${remain_space} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -d ${DEVICE} -o ${LOG_DIR} -l ${LABELNAME} -m ${MPI_HOSTS} -a ${MPI_ACCESS_METHOD} ${MOUNT_POINT} >>${LOG_FILE} 2>&1
 	RET=$?
 	f_exit_or_not ${RET}
 
@@ -1255,13 +1258,25 @@ trap 'echo -ne "\n\n">>${RUN_LOG_FILE};echo  "Interrupted by Ctrl+C,Cleanuping\
 
 f_setup $*
 
+if [ -z ${BLOCKSIZE} ];then
+       bslist="512 4096"
+else
+       bslist=${BLOCKSIZE}
+fi
+
+if [ -z ${CLUSTERSIZE} ];then
+       cslist="4096 8192"
+else
+       cslist=${CLUSTERSIZE}
+fi
+
 f_LogRunMsg ${RUN_LOG_FILE} "=====================Discontiguous block group test starts:  `date`\
 =====================\n"
 f_LogMsg ${LOG_FILE} "=====================Discontiguous block groups tests start:  `date`\
 ====================="
 
-for BLOCKSIZE in 512 4096;do
-	for CLUSTERSIZE in 4096 8192;do
+for BLOCKSIZE in $(echo "$bslist");do
+	for CLUSTERSIZE in $(echo "$cslist");do
 		f_LogRunMsg ${RUN_LOG_FILE} "<- Running test with ${BLOCKSIZE} \
 bs and ${CLUSTERSIZE} cs ->\n"
 		f_LogMsg ${LOG_FILE} "<- Running test with ${BLOCKSIZE} bs \
-- 
2.6.6
