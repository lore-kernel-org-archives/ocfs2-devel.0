From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:32 +0800
Subject: [Ocfs2-devel] [PATCH 14/17] Fix openmpi warning by specifying
	proper slot number
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-15-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The warning message as below:

"
There are not enough slots available in the system to satisfy the 4
slots
that were requested by the application:
  ./xattr-multi-test

  Either request fewer slots for your application, or make more slots
  available
  for use.
"

outputs when specifying a rank number for openmpi more than "mkfs"
slots.

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/python_common/multiple_run.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/programs/python_common/multiple_run.sh b/programs/python_common/multiple_run.sh
index 3e52eff..74c3531 100755
--- a/programs/python_common/multiple_run.sh
+++ b/programs/python_common/multiple_run.sh
@@ -368,7 +368,7 @@ run_xattr_test()
 	local logdir=${LOG_DIR}/multi-xattr-test
 
 	LogRunMsg "xattr-test"
-	${BINDIR}/xattr-multi-run.sh -r 4 -f ${NODE_LIST} -a ssh -o ${logdir} \
+	${BINDIR}/xattr-multi-run.sh -r ${SLOTS} -f ${NODE_LIST} -a ssh -o ${logdir} \
 -d ${DEVICE} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
 	LogRC $?
 }
@@ -378,7 +378,7 @@ run_inline_test()
 	local logdir=${LOG_DIR}/multi-inline-test
 
 	LogRunMsg "inline-test"
-	${BINDIR}/multi-inline-run.sh -r 2 -f ${NODE_LIST} -a ssh -o ${logdir} \
+	${BINDIR}/multi-inline-run.sh -r ${SLOTS} -f ${NODE_LIST} -a ssh -o ${logdir} \
 -d ${DEVICE} -b ${BLOCKSIZE} -c ${CLUSTERSIZE} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >> ${LOGFILE} 2>&1
 	LogRC $?
 }
@@ -389,7 +389,7 @@ run_reflink_test()
 
 	LogRunMsg "reflink-test"
 	LogMsg "reflink 'data=ordered' mode test"
-	${BINDIR}/multi_reflink_test_run.sh -r 4 -f ${NODE_LIST} -a ssh -o \
+	${BINDIR}/multi_reflink_test_run.sh -r ${SLOTS} -f ${NODE_LIST} -a ssh -o \
 ${logdir} -d ${DEVICE} -s ${CLUSTER_STACK} -n ${CLUSTER_NAME} ${MOUNT_POINT} >> ${LOGFILE} 2>&1 || {
 	RET=$?
 	LogRC $RET
-- 
2.6.6
