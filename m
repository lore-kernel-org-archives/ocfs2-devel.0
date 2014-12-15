From: akpm at linux-foundation.org <akpm@linux-foundation.org>
Date: Mon, 15 Dec 2014 14:50:52 -0800
Subject: [Ocfs2-devel] [patch 01/15] o2dlm: fix NULL pointer dereference in
 o2dlm_blocking_ast_wrapper
Message-ID: <548f65cc.H/j1pyk6vZY5+tqu%akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

From: Srinivas Eeda <srinivas.eeda@oracle.com>
Subject: o2dlm: fix NULL pointer dereference in o2dlm_blocking_ast_wrapper

A tiny race between BAST and unlock message causes the NULL dereference.

A node sends an unlock request to master and receives a response.  Before
processing the response it receives a BAST from the master.  Since both
requests are processed by different threads it creates a race.  While the
BAST is being processed, lock can get freed by unlock code.

This patch makes bast to return immediately if lock is found but unlock is
pending.  The code should handle this race.  We also have to fix master
node to skip sending BAST after receiving unlock message.

Below is the crash stack

BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
IP: [<ffffffffa015e023>] o2dlm_blocking_ast_wrapper+0xd/0x16
[<ffffffffa034e3db>] dlm_do_local_bast+0x8e/0x97 [ocfs2_dlm]
[<ffffffffa034f366>] dlm_proxy_ast_handler+0x838/0x87e [ocfs2_dlm]
[<ffffffffa0308abe>] o2net_process_message+0x395/0x5b8 [ocfs2_nodemanager]
[<ffffffffa030aac8>] o2net_rx_until_empty+0x762/0x90d [ocfs2_nodemanager]
[<ffffffff81071802>] worker_thread+0x14d/0x1ed

[akpm at linux-foundation.org: coding-style fixes]
Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmast.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmast.c~o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper fs/ocfs2/dlm/dlmast.c
--- a/fs/ocfs2/dlm/dlmast.c~o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper
+++ a/fs/ocfs2/dlm/dlmast.c
@@ -385,8 +385,12 @@ int dlm_proxy_ast_handler(struct o2net_m
 		head = &res->granted;
 
 	list_for_each_entry(lock, head, list) {
-		if (lock->ml.cookie == cookie)
+		/* if lock is found but unlock is pending ignore the bast */
+		if (lock->ml.cookie == cookie) {
+			if (lock->unlock_pending)
+				break;
 			goto do_ast;
+		}
 	}
 
 	mlog(0, "Got %sast for unknown lock! cookie=%u:%llu, name=%.*s, "
_
