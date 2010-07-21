From: Jiaju Zhang <jjzhang.linux@gmail.com>
Date: Wed, 21 Jul 2010 16:28:00 +0800
Subject: [Ocfs2-devel] [PATCH] Fix the nested PR lock calling issue
Message-ID: <20100721082800.GA23840@linux-jjzhang>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

This is an attempt to fix the bug 
https://bugzilla.novell.com/show_bug.cgi?id=614332
(also http://oss.oracle.com/bugzilla/show_bug.cgi?id=1278)

The full log is available at comment #54 of bug 614332 at Novell
bugzilla. Simply speaking, it should be nested PR lock calling issue.
The calling sequence should be:

node1       node2

            gr PR
              |
              V
PR(EX) -> BAST: OCFS2_LOCK_BLOCKED
              |
              V
            rq PR
              |
              V
            wait = 1

Since we have already had the granted PR lock from the beginning, we
may not need to request the PR lock again. 

Patch attached below. Review and comments are highly appreciated;)

Thanks,
Jiaju

Signed-off-by: Jiaju Zhang <jjzhang@suse.de>
Cc: Joel Becker <Joel.Becker@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Tiger Yang <tiger.yang@oracle.com>
---
 fs/ocfs2/acl.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/acl.c b/fs/ocfs2/acl.c
index da70229..0354af1 100644
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -152,7 +152,7 @@ static struct posix_acl *ocfs2_get_acl(struct inode *inode, int type)
 	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
 		return NULL;
 
-	ret = ocfs2_inode_lock(inode, &di_bh, 0);
+	ret = ocfs2_read_inode_block(inode, &di_bh);
 	if (ret < 0) {
 		mlog_errno(ret);
 		acl = ERR_PTR(ret);
@@ -161,8 +161,6 @@ static struct posix_acl *ocfs2_get_acl(struct inode *inode, int type)
 
 	acl = ocfs2_get_acl_nolock(inode, type, di_bh);
 
-	ocfs2_inode_unlock(inode, 0);
-
 	brelse(di_bh);
 
 	return acl;
