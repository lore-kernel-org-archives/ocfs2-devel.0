From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:25 +0800
Subject: [Ocfs2-devel] [PATCH 07/17] lvb_torture: failed when pcmk is used
	as cluster stack
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-8-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This test case failed with "pcmk" stack. Output errors
like:
"rank 1: /dlm/ has no write permission."
"rank 1: o2dlm_initialize failed: -1485330936".

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/lvb_torture/lvb_torture.c     | 110 ++++++++++++++++++++++++++++++++-
 programs/python_common/multiple_run.sh |  12 +++-
 2 files changed, 117 insertions(+), 5 deletions(-)

diff --git a/programs/lvb_torture/lvb_torture.c b/programs/lvb_torture/lvb_torture.c
index 1459849..93a29ec 100644
--- a/programs/lvb_torture/lvb_torture.c
+++ b/programs/lvb_torture/lvb_torture.c
@@ -180,6 +180,101 @@ static void run_test(struct o2dlm_ctxt *dlm, char *lockid)
 	}
 }
 
+/*
+ * Copied from run_test(), this is a ugly but straightforward workaround.
+ * "fsdlm" is used when using pcmk as cluster stack, which only supports
+ * 32-bits lvb so far.
+ */
+static void run_test_fsdlm(struct o2dlm_ctxt *dlm, char *lockid)
+{
+	unsigned long long iter = 0;
+	unsigned long long expected, to_write = 0;
+	int ret;
+	unsigned int read, written;
+	errcode_t err;
+	enum o2dlm_lock_level level;
+	__u32 lvb;
+
+	while (iter < max_iter && !caught_sig) {
+		expected = iter;
+
+		if ((iter % num_procs) == rank)
+			level = O2DLM_LEVEL_EXMODE;
+		else
+			level = O2DLM_LEVEL_PRMODE;
+
+		if (level == O2DLM_LEVEL_PRMODE) {
+			ret = MPI_Barrier(MPI_COMM_WORLD);
+			if (ret != MPI_SUCCESS)
+				rprintf(rank, "read MPI_Barrier failed: %d\n", ret);
+			err = o2dlm_lock(dlm, lockid, 0, level);
+			if (err)
+				rprintf(rank, "o2dlm_lock failed: %d\n", err);
+
+			expected++;
+		} else {
+			err = o2dlm_lock(dlm, lockid, 0, level);
+			if (err)
+				rprintf(rank, "o2dlm_lock failed: %d\n", err);
+
+			ret = MPI_Barrier(MPI_COMM_WORLD);
+			if (ret != MPI_SUCCESS)
+				rprintf(rank, "read MPI_Barrier failed: %d\n", ret);
+			to_write = iter + 1;
+		}
+
+		err = o2dlm_read_lvb(dlm, lockid, (char *)&lvb, sizeof(lvb),
+				     &read);
+		if (err)
+			rprintf(rank, "o2dlm_read_lvb failed: %d\n", err);
+
+		lvb = be32_to_cpu(lvb);
+
+		if (level == O2DLM_LEVEL_PRMODE)
+			printf("%s: read  iter: %llu, lvb: %llu exp: %llu\n",
+			       hostname, (unsigned long long)iter,
+			       (unsigned long long)lvb,
+			       (unsigned long long)expected);
+		else
+			printf("%s: write iter: %llu, lvb: %llu wri: %llu\n",
+			       hostname, (unsigned long long)iter,
+			       (unsigned long long)lvb,
+			       (unsigned long long)to_write);
+
+		fflush(stdout);
+
+		if (lvb != expected) {
+			printf("Test failed! %s: rank %d, read lvb %llu, expected %llu\n",
+			       hostname, rank, (unsigned long long) lvb,
+			       (unsigned long long) expected);
+			MPI_Abort(MPI_COMM_WORLD, 1);
+		}
+
+		if (level == O2DLM_LEVEL_EXMODE) {
+			lvb = cpu_to_be32(to_write);
+
+			err = o2dlm_write_lvb(dlm, lockid, (char *)&lvb,
+					      sizeof(lvb), &written);
+			if (err)
+				rprintf(rank, "o2dlm_write_lvb failed: %d\n", err);
+			if (written != sizeof(lvb))
+				rprintf(rank, "o2dlm_write_lvb() wrote %d, we asked for %d\n", written, sizeof(lvb));
+		}
+
+		err = o2dlm_unlock(dlm, lockid);
+		if (err)
+			rprintf(rank, "o2dlm_unlock failed: %d\n", err);
+
+		/* This second barrier is not necessary and can be
+		 * commented out to ramp the test up */
+		ret = MPI_Barrier(MPI_COMM_WORLD);
+		if (ret != MPI_SUCCESS)
+			rprintf(rank, "unlock MPI_Barrier failed: %d\n", ret);
+
+		iter++;
+	}
+}
+
 static void clear_lock(struct o2dlm_ctxt *dlm, char *lockid)
 {
 	char empty[O2DLM_LOCK_ID_MAX_LEN];
@@ -363,8 +458,7 @@ int main(int argc, char *argv[])
 
         printf("%s: rank: %d, nodes: %d, dlm: %s, dom: %s, lock: %s, iter: %llu\n", hostname, rank, num_procs, dlmfs_path, domain, lockid, (unsigned long long) max_iter);
 
-	
-	if (access(dlmfs_path, W_OK) < 0) {
+	if (strcmp(dlmfs_path, "NULL") != 0 && access(dlmfs_path, W_OK) < 0) {
 		sleep(2);
 		rprintf(rank, "%s has no write permission.\n", dlmfs_path);
 		return EACCES;
@@ -380,6 +474,13 @@ int main(int argc, char *argv[])
 			rprintf(rank, "start_heartbeat failed\n");
 	}
 
+	/*
+	 * "pcmk" is used as cluster stack if "NULL"
+	 * is passed here
+	 */
+	if (strcmp(dlmfs_path, "NULL") == 0)
+	    dlmfs_path = NULL;
+
 	error = o2dlm_initialize(dlmfs_path, domain, &dlm);
 	if (error)
 		rprintf(rank, "o2dlm_initialize failed: %d\n", error);
@@ -391,7 +492,10 @@ int main(int argc, char *argv[])
 	if (ret != MPI_SUCCESS)
 		rprintf(rank, "prep MPI_Barrier failed: %d\n", ret);
 
-	run_test(dlm, lockid);
+	if (dlmfs_path)
+		run_test(dlm, lockid);
+	else
+		run_test_fsdlm(dlm, lockid);
 
 	error = o2dlm_destroy(dlm);
 	if (error)
diff --git a/programs/python_common/multiple_run.sh b/programs/python_common/multiple_run.sh
index 2e0ec72..4340c40 100755
--- a/programs/python_common/multiple_run.sh
+++ b/programs/python_common/multiple_run.sh
@@ -31,6 +31,7 @@ DD=`which dd`
 GREP=`which grep`
 AWK=`which awk`
 ECHO="`which echo` -e"
+O2CLUSTER="`which o2cluster`"
 
 SUDO="`which sudo` -u root"
 IFCONFIG_BIN="`which ifconfig`"
@@ -398,6 +399,7 @@ run_lvb_torture_test()
         local logfile=${logdir}/lvb_torture_${DATE}.log
         local workplace=${MOUNT_POINT}
 	local testfile=${workplace}/lvb_torture_test_file
+	local dlmfs_path="/dlm"
 
 	${MKDIR_BIN} -p ${logdir}
 	${CHMOD_BIN} -R 777 ${logdir}
@@ -427,9 +429,15 @@ ${DEVICE} ${FEATURES} ${JOURNALSIZE} ${BLOCKS}
 	local UUID="`${DEBUGFS_BIN} -R stats ${DEVICE} |grep UUID|cut -d: -f 2`"
 	local LOCK="`${DEBUGFS_BIN} -R 'encode lvb_torture_test_file' ${DEVICE}`"
 
-	LogMsg "Run lvb_torture, CMD: ${BINDIR}/run_lvb_torture.py -d /dlm/ -i 60000 \
+	#dlmfs_path should be "NULL" if cluster stack is "pcmk"
+	local stack="`${SUDO} ${O2CLUSTER} -r | ${AWK} -F',' '{printf $1}'`"
+	if [ "$stack" = "pcmk" ];then
+		dlmfs_path="NULL"
+	fi
+
+	LogMsg "Run lvb_torture, CMD: ${BINDIR}/run_lvb_torture.py -d ${dlmfs_path} -i 60000 \
 -H ${DEVICE} -l ${logfile} -n ${NODE_LIST} "${UUID}" "${LOCK}""
-	${SUDO} ${BINDIR}/run_lvb_torture.py -d /dlm/ -c 60000 -i ${INTERFACE} -l \
+	${SUDO} ${BINDIR}/run_lvb_torture.py -d ${dlmfs_path} -c 60000 -i ${INTERFACE} -l \
 ${logfile} -n ${NODE_LIST} "${UUID}" "${LOCK}" >> ${LOGFILE} 2>&1
 	LogRC $?
 
-- 
2.6.6
