From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 12 Oct 2009 16:03:25 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Move ocfs2_complete_reflink to the
	right place.v2
In-Reply-To: <4AD2E23E.7030204@oracle.com>
References: <4AD2E23E.7030204@oracle.com>
Message-ID: <1255334606-26180-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

As its name ocfs2_complete_reflink indicates, it should be called
after all the work for reflink is done, so move it after
ocfs2_reflink_xattrs.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 60287fc..9d439b2 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4013,10 +4013,6 @@ static int ocfs2_create_reflink_node(struct inode *s_inode,
 		goto out_unlock_refcount;
 	}
 
-	ret = ocfs2_complete_reflink(s_inode, s_bh, t_inode, t_bh, preserve);
-	if (ret)
-		mlog_errno(ret);
-
 out_unlock_refcount:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
@@ -4068,9 +4064,17 @@ static int __ocfs2_reflink(struct dentry *old_dentry,
 		ret = ocfs2_reflink_xattrs(inode, old_bh,
 					   new_inode, new_bh,
 					   preserve);
-		if (ret)
+		if (ret) {
 			mlog_errno(ret);
+			goto inode_unlock;
+		}
 	}
+
+	ret = ocfs2_complete_reflink(inode, old_bh,
+				     new_inode, new_bh, preserve);
+	if (ret)
+		mlog_errno(ret);
+
 inode_unlock:
 	ocfs2_inode_unlock(new_inode, 1);
 	brelse(new_bh);
-- 
1.6.2.rc2.16.gf474c
