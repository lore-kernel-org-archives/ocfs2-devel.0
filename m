From: Fabian Frederick <fabf@skynet.be>
Date: Fri, 12 Jun 2015 18:59:10 +0200
Subject: [Ocfs2-devel] [PATCH 1/1 linux-next] ocfs2: use swap() in
	ocfs2_double_lock()
Message-ID: <1434128351-10617-1-git-send-email-fabf@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Fabian Frederick <fabf@skynet.be>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/namei.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index a150748..af9c4c8 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1116,8 +1116,6 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 	int inode1_is_ancestor, inode2_is_ancestor;
 	struct ocfs2_inode_info *oi1 = OCFS2_I(inode1);
 	struct ocfs2_inode_info *oi2 = OCFS2_I(inode2);
-	struct buffer_head **tmpbh;
-	struct inode *tmpinode;
 
 	trace_ocfs2_double_lock((unsigned long long)oi1->ip_blkno,
 				(unsigned long long)oi2->ip_blkno);
@@ -1148,13 +1146,8 @@ static int ocfs2_double_lock(struct ocfs2_super *osb,
 				(oi1->ip_blkno < oi2->ip_blkno &&
 				inode2_is_ancestor == 0)) {
 			/* switch id1 and id2 around */
-			tmpbh = bh2;
-			bh2 = bh1;
-			bh1 = tmpbh;
-
-			tmpinode = inode2;
-			inode2 = inode1;
-			inode1 = tmpinode;
+			swap(bh2, bh1);
+			swap(inode2, inode1);
 		}
 		/* lock id2 */
 		status = ocfs2_inode_lock_nested(inode2, bh2, 1,
-- 
2.4.2
