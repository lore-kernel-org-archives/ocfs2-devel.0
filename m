From: Eric Ren <zren@suse.com>
Date: Tue, 13 Dec 2016 13:29:23 +0800
Subject: [Ocfs2-devel] [PATCH 05/17] Trivial: fix checking empty return value
In-Reply-To: <1481606975-13186-1-git-send-email-zren@suse.com>
References: <1481606975-13186-1-git-send-email-zren@suse.com>
Message-ID: <1481606975-13186-6-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We now get the below error even if "reserve space"
testcase succeeds:
	"Error in log_end()"
This is because we passed Nil to log_end.

Signed-off-by: Eric Ren <zren@suse.com>
---
 programs/python_common/single_run-WIP.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/programs/python_common/single_run-WIP.sh b/programs/python_common/single_run-WIP.sh
index 99f24cc..d474463 100755
--- a/programs/python_common/single_run-WIP.sh
+++ b/programs/python_common/single_run-WIP.sh
@@ -781,6 +781,7 @@ run_reserve_space()
 				done
 
 				do_umount ${mountpoint}
+				RC=$?
 
 				log_end ${RC}
 			done
-- 
2.6.6
