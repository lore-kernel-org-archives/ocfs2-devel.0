From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:26 +0800
Subject: [Ocfs2-devel] [PATCH 08/17] multiple node: pass cross_delete the
	right log file
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-9-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Pass cross_delete the right log file. However, openmpi should
log into config.LOGFILE,  because other remote nodes only have
this common log file.

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/cross_delete/cross_delete.py  | 4 ++--
 programs/python_common/multiple_run.sh | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/programs/cross_delete/cross_delete.py b/programs/cross_delete/cross_delete.py
index ec3097c..1694d51 100755
--- a/programs/cross_delete/cross_delete.py
+++ b/programs/cross_delete/cross_delete.py
@@ -305,7 +305,7 @@ o2tf.OpenMPIInit(DEBUGON, ','.join(nodelist), logfile, 'ssh')
 		cmdline = os.path.join(config.BINDIR, 'crdel_gen_files.py')
 	ret = o2tf.openmpi_run( DEBUGON, nproc, str('%s -s %s -l %s -t %s' % \
 		(cmdline, stagedir,
-		options.logfile,
+		config.LOGFILE,
 		tarfile) ),
 		','.join(nodelist),
 		'ssh',
@@ -324,7 +324,7 @@ o2tf.OpenMPIInit(DEBUGON, ','.join(nodelist), logfile, 'ssh')
 	else:
 		cmdline = os.path.join(config.BINDIR, 'crdel_del_files.py')
 	ret = o2tf.openmpi_run( DEBUGON, nproc, str('%s -s %s -l %s ' % \
-		(cmdline, stagedir, options.logfile) ),
+		(cmdline, stagedir, config.LOGFILE) ),
 		','.join(nodelist),
 		'ssh',
 		options.interface,
diff --git a/programs/python_common/multiple_run.sh b/programs/python_common/multiple_run.sh
index 4340c40..9e2237a 100755
--- a/programs/python_common/multiple_run.sh
+++ b/programs/python_common/multiple_run.sh
@@ -318,7 +318,7 @@ run_cross_delete_test()
 	local workplace=${MOUNT_POINT}/cross_delete_test
 
 	run_common_testcase "cross_delete" "sparse,unwritten,inline-data" \
-"${BINDIR}/cross_delete.py -c 1 -i ${INTERFACE} -d ${workplace} -n ${NODE_LIST} -t ${KERNELSRC}"
+"${BINDIR}/cross_delete.py -c 1 -l ${logfile} -i ${INTERFACE} -d ${workplace} -n ${NODE_LIST} -t ${KERNELSRC}"
 }
 
 run_write_append_truncate_test()
-- 
2.6.6
