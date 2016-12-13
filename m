From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:35 +0800
Subject: [Ocfs2-devel] [PATCH 17/17] discontig bg: give single and multiple
	node test different log file name
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-18-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/discontig_bg_test/discontig_runner.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/programs/discontig_bg_test/discontig_runner.sh b/programs/discontig_bg_test/discontig_runner.sh
index 182ca3a..f3a69f5 100755
--- a/programs/discontig_bg_test/discontig_runner.sh
+++ b/programs/discontig_bg_test/discontig_runner.sh
@@ -164,8 +164,13 @@ function f_setup()
 	LOG_DIR=${LOG_DIR:-$DEFAULT_LOG_DIR}
 	${MKDIR_BIN} -p ${LOG_DIR} || exit 1
 	
-	RUN_LOG_FILE="`dirname ${LOG_DIR}`/`basename ${LOG_DIR}`/`date +%F-%H-\
-%M-%S`-discontig-bg-run.log"
+	if [ -n "${MULTI_TEST}" ];then
+		RUN_LOG_FILE="`dirname ${LOG_DIR}`/`basename ${LOG_DIR}`/`date +%F-%H-\
+%M-%S`-discontig-bg-multiple-run.log"
+	else
+		RUN_LOG_FILE="`dirname ${LOG_DIR}`/`basename ${LOG_DIR}`/`date +%F-%H-\
+%M-%S`-discontig-bg-single-run.log"
+	fi
 	LOG_FILE="`dirname ${LOG_DIR}`/`basename ${LOG_DIR}`/`date +%F-%H-\
 %M-%S`-discontig-bg.log"
         PUNCH_LOG_FILE="`dirname ${LOG_DIR}`/`basename ${LOG_DIR}`/`date +%F-%H-\
-- 
2.6.6
