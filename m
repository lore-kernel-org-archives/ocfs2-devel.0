From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 18 Dec 2009 10:24:55 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Set i_nlink properly during reflink.
In-Reply-To: <4B2AE488.8070602@oracle.com>
References: <4B2AE488.8070602@oracle.com>
Message-ID: <1261103095-8324-2-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We create a file in orphan dir for reflink so that if there
is any error, we don't create any wrong dentry in the dir.
But actually the file in orphan dir should be i_nlink = 0
so that it can be replayed and freed successfully.

This patch first set i_nlink to 0 when creating the file in
orphan dir and then set it to 1(reflink now only works for
regular file) when we move it to the dest dir.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 5ac4d52..3e9b460 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2108,6 +2108,7 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 	}
 	did_quota_inode = 1;
 
+	inode->i_nlink = 0;
 	/* do the real work now. */
 	status = ocfs2_mknod_locked(osb, dir, inode,
 				    0, &new_di_bh, parent_di_bh, handle,
@@ -2268,6 +2269,8 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 	le32_add_cpu(&di->i_flags, -OCFS2_ORPHANED_FL);
 	di->i_orphaned_slot = 0;
+	inode->i_nlink = 1;
+	ocfs2_set_links_count(di, inode->i_nlink);
 	ocfs2_journal_dirty(handle, di_bh);
 
 	status = ocfs2_add_entry(handle, dentry, inode,
-- 
1.5.4.4
