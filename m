From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:31 +0800
Subject: [Ocfs2-devel] [PATCH 13/17] Save punch_hole details into logfile
	for debugging convenience
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-14-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/discontig_bg_test/discontig_runner.sh | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/programs/discontig_bg_test/discontig_runner.sh b/programs/discontig_bg_test/discontig_runner.sh
index 3be39c8..4c13adb 100755
--- a/programs/discontig_bg_test/discontig_runner.sh
+++ b/programs/discontig_bg_test/discontig_runner.sh
@@ -41,6 +41,7 @@ DEFAULT_LOG_DIR=${O2TDIR}/log
 LOG_DIR=
 RUN_LOG_FILE=
 LOG_FILE=
+PUNCH_LOG_FILE=
 
 BLOCKSIZE=
 CLUSTERSIZE=
@@ -162,6 +163,8 @@ function f_setup()
 %M-%S`-discontig-bg-run.log"
 	LOG_FILE="`dirname ${LOG_DIR}`/`basename ${LOG_DIR}`/`date +%F-%H-\
 %M-%S`-discontig-bg.log"
+        PUNCH_LOG_FILE="`dirname ${LOG_DIR}`/`basename ${LOG_DIR}`/`date +%F-%H-\
+%M-%S`-punch-hole.log"
 
 }
 
@@ -529,7 +532,7 @@ function f_extents_test()
 	recs_in_blk=$(((${BLOCKSIZE}-64)/16))
 	while :;do
 		if [ "$((${RANDOM}%2))" -eq "0" ];then
-			${PUNCH_HOLE_BIN} -f ${filename} -s ${offset} -l $((${CLUSTERSIZE}*${recs_in_blk})) >>/dev/null 2>&1 || {
+			${PUNCH_HOLE_BIN} -f ${filename} -s ${offset} -l $((${CLUSTERSIZE}*${recs_in_blk})) >>${PUNCH_LOG_FILE} 2>&1 || {
 				f_LogMsg ${LOG_FILE} "Punch hole at offset:${offset} failed."
 				return 1
 			}
@@ -798,13 +801,13 @@ function f_refcount_test()
 	fi
 	while :;do
 		if [ "$((${RANDOM}%2))" -eq "0" ];then
-			${PUNCH_HOLE_BIN} -f ${orig_filename} -s ${offset} -l ${CLUSTERSIZE} >>/dev/null 2>&1 || {
+			${PUNCH_HOLE_BIN} -f ${orig_filename} -s ${offset} -l ${CLUSTERSIZE} >>${PUNCH_LOG_FILE} 2>&1 || {
 				f_LogMsg ${LOG_FILE} "Punch hole at offset:${offset} failed on ${orig_filename}."
 				return 1
 			}
 		fi
 		if [ "$((${RANDOM}%2))" -eq "1" ];then
-			${PUNCH_HOLE_BIN} -f ${ref_filename} -s ${offset} -l ${CLUSTERSIZE} >>/dev/null 2>&1 || {
+			${PUNCH_HOLE_BIN} -f ${ref_filename} -s ${offset} -l ${CLUSTERSIZE} >>${PUNCH_LOG_FILE} 2>&1 || {
 				f_LogMsg ${LOG_FILE} "Punch hole at offset:${offset} failed on ${ref_filename}."
 				return 1
 			}
@@ -822,14 +825,14 @@ function f_refcount_test()
 	recs_in_blk=$(((${BLOCKSIZE}-64)/16))
 	while :;do
 		if [ "$((${RANDOM}%2))" -eq "0" ];then
-			${PUNCH_HOLE_BIN} -f ${orig_filename} -s ${offset} -l $((${CLUSTERSIZE}*${recs_in_blk})) >>/dev/null 2>&1 || {
+			${PUNCH_HOLE_BIN} -f ${orig_filename} -s ${offset} -l $((${CLUSTERSIZE}*${recs_in_blk})) >>${PUNCH_LOG_FILE} 2>&1 || {
 				f_LogMsg ${LOG_FILE} "Punch hole at offset:${offset} failed on ${orig_filename}."
 				return 1
 			}
 		fi
 
 		if [ "$((${RANDOM}%2))" -eq "1" ];then
-			${PUNCH_HOLE_BIN} -f ${ref_filename} -s ${offset} -l $((${CLUSTERSIZE}*${recs_in_blk})) >>/dev/null 2>&1 || {
+			${PUNCH_HOLE_BIN} -f ${ref_filename} -s ${offset} -l $((${CLUSTERSIZE}*${recs_in_blk})) >>${PUNCH_LOG_FILE} 2>&1 || {
 				f_LogMsg ${LOG_FILE} "Punch hole at offset:${offset} failed on ${ref_filename}."
 				return 1
 			}
-- 
2.6.6
