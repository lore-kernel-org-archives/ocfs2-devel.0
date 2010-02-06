From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri,  5 Feb 2010 17:55:56 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Fix printing of lockname
Message-ID: <1265421356-18250-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The debug call printing the name of the lock resource was chopping
off the last character. This patch fixes the problem.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
---
 fs/ocfs2/dlm/dlmdebug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index f18afe9..75efd45 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -102,7 +102,7 @@ void __dlm_print_one_lock_resource(struct dlm_lock_resource *res)
 	assert_spin_locked(&res->spinlock);
 
 	stringify_lockname(res->lockname.name, res->lockname.len,
-			   buf, sizeof(buf) - 1);
+			   buf, sizeof(buf));
 	printk("lockres: %s, owner=%u, state=%u\n",
 	       buf, res->owner, res->state);
 	printk("  last used: %lu, refcnt: %u, on purge list: %s\n",
-- 
1.6.3.3
