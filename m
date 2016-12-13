From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:28 +0800
Subject: [Ocfs2-devel] [PATCH 10/17] Multiple run: make blocksize and
	clustersize as parameters
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-11-git-send-email-zren@suse.com>
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
 programs/inline-data/multi-inline-run.sh         | 24 ++++++++++++++++----
 programs/python_common/multiple_run.sh           | 28 +++++++++++++++++++-----
 programs/reflink_tests/multi_reflink_test_run.sh | 28 ++++++++++++++++++------
 programs/xattr_tests/xattr-multi-run.sh          | 24 ++++++++++++++++----
 4 files changed, 83 insertions(+), 21 deletions(-)

diff --git a/programs/inline-data/multi-inline-run.sh b/programs/inline-data/multi-inline-run.sh
index 1d51443..0a2ffa5 100755
--- a/programs/inline-data/multi-inline-run.sh
+++ b/programs/inline-data/multi-inline-run.sh
@@ -126,12 +126,14 @@ exit_or_not()
 ################################################################################
 f_usage()
 {
-    echo "usage: `basename ${0}` [-r MPI_ranks] <-f MPI_hosts> [-a access_method] [-o output] <-d <device>> <mountpoint path>"
+    echo "usage: `basename ${0}` [-r MPI_ranks] <-f MPI_hosts> [-a access_method] [-o output] <-d <device>> <-b blocksize> -c <clustersize> <mountpoint path>"
     echo "       -r size of MPI rank"
     echo "       -a access method for process propagation,should be ssh or rsh,set ssh as a default method when omited."
     echo "       -f MPI hosts list,separated by comma,e.g -f node1.us.oracle.com,node2.us.oracle.com."
     echo "       -o output directory for the logs"
     echo "       -d device name used for ocfs2 volume"
+    echo "	 -b block size"
+    echo "	 -c cluster size"
     echo "       <mountpoint path> path of mountpoint where the ocfs2 volume will be mounted on."
     exit 1;
 
@@ -144,13 +146,15 @@ f_getoptions()
                 exit 1
          fi
 
-         while getopts "o:hd:r:a:f:" options; do
+         while getopts "o:hd:r:a:f:b:c:" options; do
                 case $options in
 		a ) MPI_ACCESS_METHOD="$OPTARG";;
 		r ) MPI_RANKS="$OPTARG";;
 		f ) MPI_HOSTS="$OPTARG";;
                 o ) LOG_OUT_DIR="$OPTARG";;
                 d ) OCFS2_DEVICE="$OPTARG";;
+		b ) BLOCKSIZE="$OPTARG";;
+		c ) CLUSTERSIZE="$OPTARG";;
                 h ) f_usage
                     exit 1;;
                 * ) f_usage
@@ -327,9 +331,21 @@ trap ' : ' SIGTERM
 
 f_setup $*
 
-for BLOCKSIZE in 512 1024 4096
+if [ -n "$BLOCKSIZE" ];then
+	bslist="$BLOCKSIZE"
+else
+	bslist="512 1024 4096"
+fi
+
+if [ -n "CLUSTERSIZE" ];then
+	cslist="$CLUSTERSIZE"
+else
+	cslist="4096 32768 1048576"
+fi
+
+for BLOCKSIZE in $(echo "$bslist")
 do
-	for CLUSTERSIZE in  4096 32768 1048576
+	for CLUSTERSIZE in $(echo "$cslist")
 	do
 		echo "++++++++++Multiple node inline-data test with \"-b ${BLOCKSIZE} -C ${CLUSTERSIZE}\"++++++++++" |tee -a ${RUN_LOG_FILE}
 		echo "++++++++++Multiple node inline-data test with \"-b ${BLOCKSIZE} -C ${CLUSTERSIZE}\"++++++++++">>${DATA_LOG_FILE}
diff --git a/programs/python_common/multiple_run.sh b/programs/python_common/multiple_run.sh
index 9e2237a..b2d5800 100755
--- a/programs/python_common/multiple_run.sh
+++ b/programs/python_common/multiple_run.sh
@@ -72,10 +72,12 @@ set -o pipefail
 ################################################################################
 f_usage()
 {
-    echo "usage: `basename ${0}` <-k kerneltarball> <-n nodes> [-i nic] \
+    echo "usage: `basename ${0}` <-k kerneltarball> [-b blocksize] [-c clustersize] <-n nodes> [-i nic] \
 [-a access_method] [-o logdir] <-d device> [-t testcases] <mountpoint path>"
     echo "       -k kerneltarball should be path of tarball for kernel src."
     echo "       -n nodelist,should be comma separated."
+    echo "       -b blocksize."
+    echo "       -c clustersize."
     echo "       -o output directory for the logs"
     echo "       -i network interface name to be used for MPI messaging."
     echo "       -a access method for mpi execution,should be ssh or rsh"
@@ -97,13 +99,15 @@ f_getoptions()
 		exit 1
 	fi
 
-	while getopts "n:d:i:a:o:k:t:h:" options; do
+	while getopts "n:d:i:a:o:b:c:k:t:h:" options; do
 		case $options in
 		n ) NODE_LIST="$OPTARG";;
 		d ) DEVICE="$OPTARG";;
 		i ) INTERFACE="$OPTARG";;
 		a ) ACCESS_METHOD="$OPTARG";;
 		o ) LOG_DIR="$OPTARG";;
+		b ) BLOCKSIZE="$OPTARG";;
+		c ) CLUSTERSIZE="$OPTARG";;
 		k ) KERNELSRC="$OPTARG";;
 		t ) TESTCASES="$OPTARG";;
 		h ) f_usage
@@ -359,7 +363,7 @@ run_xattr_test()
 
 	LogRunMsg "xattr-test"
 	${BINDIR}/xattr-multi-run.sh -r 4 -f ${NODE_LIST} -a ssh -o ${logdir} \
--d ${DEVICE} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
+-d ${DEVICE} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
 	LogRC $?
 }
 
@@ -369,7 +373,7 @@ run_inline_test()
 
 	LogRunMsg "inline-test"
 	${BINDIR}/multi-inline-run.sh -r 2 -f ${NODE_LIST} -a ssh -o ${logdir} \
--d ${DEVICE} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
+-d ${DEVICE} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
 	LogRC $?
 }
 
@@ -479,6 +483,18 @@ trap ' : ' SIGTERM
 
 f_setup $*
 
+if [ -n "$BLOCKSIZE" ];then
+	bslist="$BLOCKSIZE"
+else
+	bslist="512 1024 4096"
+fi
+
+if [ -n "$CLUSTERSIZE" ];then
+	cslist="$CLUSTERSIZE"
+else
+	cslist="4096 32768 1048576"
+fi
+
 STARTRUN=$(date +%s)
 ${ECHO} "`date` - Starting Multiple Nodes Regress test" > ${LOGFILE}
 
@@ -498,8 +514,8 @@ for tc in `${ECHO} ${TESTCASES} | ${SED} "s:,: :g"`; do
 		run_reflink_test
 	fi
 
-	for BLOCKSIZE in 512 1024 4096;do
-		for CLUSTERSIZE in 4096 32768 1048576;do
+	for BLOCKSIZE in $(echo "$bslist");do
+		for CLUSTERSIZE in $(echo "$cslist");do
 			${ECHO} "Tests with \"-b ${BLOCKSIZE} -C ${CLUSTERSIZE}\"" | \
 				${TEE_BIN} -a ${LOGFILE}
 			if [ "$tc"X = "write_append_truncate"X -o "$tc"X = "all"X ]; then
diff --git a/programs/reflink_tests/multi_reflink_test_run.sh b/programs/reflink_tests/multi_reflink_test_run.sh
index 682ea71..3dc0c68 100755
--- a/programs/reflink_tests/multi_reflink_test_run.sh
+++ b/programs/reflink_tests/multi_reflink_test_run.sh
@@ -90,12 +90,14 @@ set -o pipefail
 function f_usage()
 {
     echo "usage: `basename ${0}` [-r MPI_Ranks] <-f MPI_Hosts> \
-[-a access method] [-o logdir] <-d <device>> [-W] [-A] <mountpoint path>"
+[-a access method] [-o logdir] <-d <device>> <-b block size> <-c cluster size> [-W] [-A] <mountpoint path>"
     echo "       -r size of MPI rank"
     echo "       -a access method for mpi execution,should be ssh or rsh"
     echo "       -f MPI hosts list,separated by comma"
     echo "       -o output directory for the logs"
     echo "       -d specify the device"
+    echo "	 -b block size"
+    echo "	 -c cluster size"
     echo "       -i Network Interface name to be used for MPI messaging."
     echo "       -W enable data=writeback mode"
     echo "       -A enable asynchronous io testing mode"
@@ -110,7 +112,7 @@ function f_getoptions()
                 exit 1
          fi
 
-	 while getopts "o:d:i:r:f:WAha:" options; do
+	 while getopts "o:d:i:r:f:WAha:b:c:" options; do
                 case $options in
 		r ) MPI_RANKS="$OPTARG";;
                 f ) MPI_HOSTS="$OPTARG";;
@@ -118,6 +120,8 @@ function f_getoptions()
                 d ) DEVICE="$OPTARG";;
 		a ) MPI_ACCESS_METHOD="$OPTARG";;
 		i ) INTERFACE="$OPTARG";;
+		b ) BLOCKSIZE="$OPTARG";;
+		c ) CLUSTERSIZE="$OPTARG";;
 		W ) MOUNT_OPTS="data=writeback";;
 		A ) AIO_OPT=" -A ";;
                 h ) f_usage
@@ -174,7 +178,7 @@ ${MOUNT_POINT}`"
 			f_usage;
 		} 
 		MPI_BTL_IF_ARG="-mca btl_tcp_if_include ${INTERFACE}"   
-	fi;
+	fi
 	MPI_RANKS=${MPI_RANKS:-$DEFAULT_RANKS}
 
 	LOG_DIR=${LOG_DIR:-$DEFAULT_LOG_DIR}
@@ -372,16 +376,26 @@ trap 'echo -ne "\n\n">>${RUN_LOG_FILE};echo  "Interrupted by Ctrl+C,Cleanuping\
 
 f_setup $*
 
+if [ -n "$BLOCKSIZE" ];then
+	bslist="$BLOCKSIZE"
+else
+	bslist="512 1024 2048 4096"
+fi
+
+if [ -n "$CLUSTERSIZE" ];then
+	cslist="$CLUSTERSIZE"
+else
+	cslist="4096 32768 1048576"
+fi
+
 START_TIME=${SECONDS}
 f_LogRunMsg ${RUN_LOG_FILE} "=====================Multi-nodes refcount tests \
 start:  `date`=====================\n"
 f_LogMsg ${LOG_FILE} "=====================Multi-nodes refcount tests \
 start:  `date`====================="
 
-#for BLOCKSIZE in 512 1024 2048 4096;do
-#	for CLUSTERSIZE in  4096 32768 1048576;do
-for BLOCKSIZE in 4096;do
-	for CLUSTERSIZE in 1048576;do
+for BLOCKSIZE in $(echo "$bslist");do
+	for CLUSTERSIZE in $(echo "$cslist");do
 		f_LogRunMsg ${RUN_LOG_FILE} "<- Running test with ${BLOCKSIZE} \
 bs and ${CLUSTERSIZE} cs ->\n"
                 f_LogMsg ${LOG_FILE} "<- Running test with ${BLOCKSIZE} \
diff --git a/programs/xattr_tests/xattr-multi-run.sh b/programs/xattr_tests/xattr-multi-run.sh
index 7b0f7e0..0a4f464 100755
--- a/programs/xattr_tests/xattr-multi-run.sh
+++ b/programs/xattr_tests/xattr-multi-run.sh
@@ -145,13 +145,15 @@ exit_or_not()
 ################################################################################
 f_usage()
 {
-    echo "usage: `basename ${0}` [-r MPI_Ranks] <-f MPI_Hosts> [-a access method] [-o output] [-i interface] <-d <device>> <mountpoint path>"
+    echo "usage: `basename ${0}` [-r MPI_Ranks] <-f MPI_Hosts> [-a access method] [-o output] [-i interface] <-d <device>> <-b blocksize> <-c clustersize> <mountpoint path>"
     echo "       -r size of MPI rank"
     echo "       -a access method for process propagation,should be ssh or rsh,set ssh as a default method when omited."
     echo "       -f MPI hosts list,separated by comma,e.g -f node1.us.oracle.com,node2.us.oracle.com."
     echo "       -o output directory for the logs"
     echo "       -i Network Interface name to be used for MPI messaging."
     echo "       -d specify the device which has been formated as an ocfs2 volume."
+    echo "	 -b block size."
+    echo "	 -c cluster size."
     echo "       <mountpoint path> path of mountpoint where the ocfs2 volume will be mounted on."
     exit 1;
 
@@ -163,7 +165,7 @@ f_getoptions()
                 exit 1
          fi
 
-	 while getopts "o:d:r:f:a:h:i:" options; do
+	 while getopts "o:d:r:f:a:h:i:b:c:" options; do
                 case $options in
 		r ) MPI_RANKS="$OPTARG";;
                 f ) MPI_HOSTS="$OPTARG";;
@@ -171,6 +173,8 @@ f_getoptions()
                 d ) OCFS2_DEVICE="$OPTARG";;
 		a ) MPI_ACCESS_METHOD="$OPTARG";;
 		i ) INTERFACE="$OPTARG";;
+		b ) BLOCKSIZE="$OPTARG";;
+		c ) CLUSTERSIZE="$OPTARG";;
                 h ) f_usage
                     exit 1;;
                 * ) f_usage
@@ -467,13 +471,25 @@ trap ' : ' SIGTERM
 
 f_setup $*
 
+if [ -n "$BLOCKSIZE" ];then
+	bslist="$BLOCKSIZE"
+else
+	bslist="512 4096"
+fi
+
+if [ -n "$CLUSTERSIZE" ];then
+	cslist="$CLUSTERSIZE"
+else
+	cslist="4096 1048576"
+fi
+
 START_TIME=${SECONDS}
 echo "=====================Multiple nodes xattr testing starts: `date`=====================" |tee -a ${RUN_LOG_FILE}
 echo "=====================Multiple nodes xattr testing starts: `date`=====================" >> ${LOG_FILE}
 
-for BLOCKSIZE in 512 4096
+for BLOCKSIZE in $(echo "$bslist")
 do
-        for CLUSTERSIZE in  4096 1048576
+	for CLUSTERSIZE in $(echo "$cslist")
         do
                 echo "++++++++++xattr tests with \"-b ${BLOCKSIZE} -C ${CLUSTERSIZE}\"++++++++++" |tee -a ${RUN_LOG_FILE}
                 echo "++++++++++xattr tests with \"-b ${BLOCKSIZE} -C ${CLUSTERSIZE}\"++++++++++">>${LOG_FILE}
-- 
2.6.6
