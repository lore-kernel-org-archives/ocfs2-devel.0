From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 30 Jan 2012 23:16:28 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] o2dlm: fix NULL pointer dereference in
	o2dlm_blocking_ast_wrapper
Message-ID: <1327994188-3373-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

A tiny race between BAST and unlock message causes the NULL dereference.

A node sends an unlock request to master and receives a response. Before
processing the response it receives a BAST from the master. Since both requests
are processed by different threads it creates a race. While the BAST is being
processed, lock can get freed by unlock code.

This patch makes bast to return immediately if lock is found but unlock is
pending. The code should handle this race. We also have to fix master node to
skip sending BAST after receiving unlock message.

Below is the crash stack

BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
IP: [<ffffffffa015e023>] o2dlm_blocking_ast_wrapper+0xd/0x16
[<ffffffffa034e3db>] dlm_do_local_bast+0x8e/0x97 [ocfs2_dlm]
[<ffffffffa034f366>] dlm_proxy_ast_handler+0x838/0x87e [ocfs2_dlm]
[<ffffffffa0308abe>] o2net_process_message+0x395/0x5b8 [ocfs2_nodemanager]
[<ffffffffa030aac8>] o2net_rx_until_empty+0x762/0x90d [ocfs2_nodemanager]
[<ffffffff81071802>] worker_thread+0x14d/0x1ed

Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
---
 fs/ocfs2/dlm/dlmast.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index 3a3ed4b..1281e8a 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -386,8 +386,9 @@ int dlm_proxy_ast_handler(struct o2net_msg *msg, u32 len, void *data,
 		head = &res->granted;
 
 	list_for_each(iter, head) {
+		/* if lock is found but unlock is pending ignore the bast */
 		lock = list_entry (iter, struct dlm_lock, list);
-		if (lock->ml.cookie == cookie)
+		if ((lock->ml.cookie == cookie) && (!lock->unlock_pending))
 			goto do_ast;
 	}
 
-- 
1.5.4.3
