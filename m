From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:24 +0800
Subject: [Ocfs2-devel] [PATCH 06/17] multi_mmap: make log messages go to
	right place
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-7-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The option "--logfile" is missing now. Thus, log
messages go into "o2t.log", which is a apparent
mistake.

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/python_common/multiple_run.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/programs/python_common/multiple_run.sh b/programs/python_common/multiple_run.sh
index c4a7da9..2e0ec72 100755
--- a/programs/python_common/multiple_run.sh
+++ b/programs/python_common/multiple_run.sh
@@ -339,7 +339,7 @@ run_multi_mmap_test()
 	local testfile=${workplace}/multi_mmap_test_file
 
 	run_common_testcase "multi_mmap" "sparse,unwritten,inline-data" \
-"${BINDIR}/run_multi_mmap.py -i 20000 -I ${INTERFACE} -n ${NODE_LIST} -c -b 6000 --hole -f ${testfile}"
+"${BINDIR}/run_multi_mmap.py -i 20000 -I ${INTERFACE} -l ${logfile} -n ${NODE_LIST} -c -b 6000 --hole -f ${testfile}"
 }
 
 run_create_racer_test()
-- 
2.6.6
