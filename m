From: Jan Kara <jack@suse.cz>
Date: Thu, 20 Feb 2014 16:18:27 +0100
Subject: [Ocfs2-devel] [PATCH 2/6] ocfs2: Move dquot_initialize() in
	ocfs2_delete_inode() somewhat later
In-Reply-To: <1392909511-2933-1-git-send-email-jack@suse.cz>
References: <1392909511-2933-1-git-send-email-jack@suse.cz>
Message-ID: <1392909511-2933-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Move dquot_initalize() call in ocfs2_delete_inode() after the moment we
verify inode is actually a sane one to delete. We certainly don't want
to initialize quota for system inodes etc. This also avoids calling into
quota code from downconvert thread.

Add more details into the comment why bailing out from
ocfs2_delete_inode() when we are in downconvert thread is OK.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/inode.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b4baaefe4dd4..3b0d722de35e 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -804,11 +804,13 @@ static int ocfs2_inode_is_valid_to_delete(struct inode *inode)
 		goto bail;
 	}
 
-	/* If we're coming from downconvert_thread we can't go into our own
-	 * voting [hello, deadlock city!], so unforuntately we just
-	 * have to skip deleting this guy. That's OK though because
-	 * the node who's doing the actual deleting should handle it
-	 * anyway. */
+	/*
+	 * If we're coming from downconvert_thread we can't go into our own
+	 * voting [hello, deadlock city!] so we cannot delete the inode. But
+	 * since we dropped last inode ref when downconverting dentry lock,
+	 * we cannot have the file open and thus the node doing unlink will
+	 * take care of deleting the inode.
+	 */
 	if (current == osb->dc_task)
 		goto bail;
 
@@ -954,8 +956,6 @@ static void ocfs2_delete_inode(struct inode *inode)
 	if (is_bad_inode(inode) || !OCFS2_I(inode)->ip_blkno)
 		goto bail;
 
-	dquot_initialize(inode);
-
 	if (!ocfs2_inode_is_valid_to_delete(inode)) {
 		/* It's probably not necessary to truncate_inode_pages
 		 * here but we do it for safety anyway (it will most
@@ -964,6 +964,8 @@ static void ocfs2_delete_inode(struct inode *inode)
 		goto bail;
 	}
 
+	dquot_initialize(inode);
+
 	/* We want to block signals in delete_inode as the lock and
 	 * messaging paths may return us -ERESTARTSYS. Which would
 	 * cause us to exit early, resulting in inodes being orphaned
-- 
1.8.1.4
