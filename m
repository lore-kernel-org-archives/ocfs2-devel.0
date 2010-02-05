From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  5 Feb 2010 15:41:24 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Fix printing of lockname
In-Reply-To: <1265413284-17330-1-git-send-email-sunil.mushran@oracle.com>
References: <1265413284-17330-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <1265413284-17330-2-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The debug call printing the name of the lock resource was chopping
off the last character. This patch fixes the problem.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdebug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index f18afe9..7b4d1c1 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -97,12 +97,12 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 {
 	struct list_head *iter2;
 	struct dlm_lock *lock;
-	char buf[DLM_LOCKID_NAME_MAX];
+	char buf[DLM_LOCKID_NAME_MAX+1];
 
 	assert_spin_locked(&res->spinlock);
 
 	stringify_lockname(res->lockname.name, res->lockname.len,
-			   buf, sizeof(buf) - 1);
+			   buf, sizeof(buf));
 	printk("lockres: %s, owner=%u, state=%u\n",
 	       buf, res->owner, res->state);
 	printk("  last used: %lu, refcnt: %u, on purge list: %s\n",
-- 
1.6.3.3
