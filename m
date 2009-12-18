From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 18 Dec 2009 10:24:54 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add reflinked file's inode to inode
	hash eariler.
In-Reply-To: <4B2AE488.8070602@oracle.com>
References: <4B2AE488.8070602@oracle.com>
Message-ID: <1261103095-8324-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We used to add reflinked file's inode to inode hash when
we add it to the dest dir. But actually there is a race.
Consider the following sequence.
1. reflink happens and create the inode in orphan dir.
2. reflink thread is scheduled out because of some io.
3. recovery begins to work and calls ocfs2_recover_orphans.
   It calls ocfs2_iget and get a new inode and i_count = 1.
   It calls iput then and delete inode. the buffer's
   uptodate state is cleared.

This patch move insert_inode_hash to the create function so
that it can be found by step 3 and prevented from deleting
because i_count > 1.

This resolves the bug
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1183.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index f010b22..5ac4d52 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2136,6 +2136,7 @@ int ocfs2_create_inode_in_orphan(struct inode *dir,
 	if (status < 0)
 		mlog_errno(status);
 
+	insert_inode_hash(inode);
 leave:
 	if (status < 0 && did_quota_inode)
 		vfs_dq_free_inode(inode);
@@ -2284,7 +2285,6 @@ int ocfs2_mv_orphaned_inode_to_new(struct inode *dir,
 		goto out_commit;
 	}
 
-	insert_inode_hash(inode);
 	dentry->d_op = &ocfs2_dentry_ops;
 	d_instantiate(dentry, inode);
 	status = 0;
-- 
1.5.4.4
