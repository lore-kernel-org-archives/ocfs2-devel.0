From: Eric Ren <zren@suse.com>
Date: Wed, 14 Oct 2015 23:20:47 +0800
Subject: [Ocfs2-devel] [PATCH] dlm: make dlm_posix_lock comply with posix
	file lock semanteme
In-Reply-To: <1444836047-8020-1-git-send-email-zren@suse.com>
References: <1444836047-8020-1-git-send-email-zren@suse.com>
Message-ID: <1444836047-8020-2-git-send-email-zren@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Posix file lock semanteme expects that waiting processes that request
a conflicting lock on file can be interrputed by signals like SIGALRM.
But, dlm_posix_lock puts waiting process into "Disk Sleep" status.
This failed ocfs2 test suits for posix file lock.

Replacing wait_event_killable with wait_event_interruptible can fix
this issue.

Signed-off-by: Eric Ren <zren@suse.com>
Acked-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/plock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 5532f09..88f1036 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -145,7 +145,7 @@ int dlm_posix_lock(dlm_lockspace_t *lockspace, u64 number, struct file *file,
 	send_op(op);
 
 	if (xop->callback == NULL) {
-		rv = wait_event_killable(recv_wq, (op->done != 0));
+		rv = wait_event_interruptible(recv_wq, (op->done != 0));
 		if (rv == -ERESTARTSYS) {
 			log_debug(ls, "dlm_posix_lock: wait killed %llx",
 				  (unsigned long long)number);
-- 
2.1.4
