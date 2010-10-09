From: Tristan Ye <tristan.ye@oracle.com>
Date: Sat,  9 Oct 2010 19:26:42 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Handle O_DIRECT writes with
	coherency option.
In-Reply-To: <1286623602-7559-1-git-send-email-tristan.ye@oracle.com>
References: <1286623602-7559-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <1286623602-7559-2-git-send-email-tristan.ye@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Change the default behavior to take the EX lock for all writes,
both buffered and O_DIRECT, then also allow concurrent O_DIRECT
writes by recognizing "coherency=buffered" option.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
---
 fs/ocfs2/file.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 9a03c15..22710a0 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2255,14 +2255,40 @@ relock:
 		have_alloc_sem = 1;
 	}
 
-	/* concurrent O_DIRECT writes are allowed */
-	rw_level = !direct_io;
+	/* 
+	 * concurrent O_DIRECT writes are allowed with
+	 * mount_option "coherency=buffered".
+	 */
+	if (direct_io) {
+		rw_level = !(osb->s_mount_opt & OCFS2_MOUNT_COHERENCY_BUFFERED);
+	} else
+		rw_level = !direct_io;
+
 	ret = ocfs2_rw_lock(inode, rw_level);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out_sems;
 	}
 
+	/*
+	 * O_DIRECT writes with "coherency=full" need to take EX cluster
+	 * inode_lock to guarantee coherency.
+	 */
+	if ((direct_io) &&
+	    !(osb->s_mount_opt & OCFS2_MOUNT_COHERENCY_BUFFERED)) {
+		ret = ocfs2_inode_lock(inode, NULL, 1);
+		if (ret < 0) {
+			mlog_errno(ret);
+			goto out_sems;
+		}
+		
+		/*
+		 * Safe to drop the inode_lock immediately since we're just
+		 * telling other nodes to flush their cache.
+		 */
+		ocfs2_inode_unlock(inode, 1);
+	}
+
 	can_do_direct = direct_io;
 	ret = ocfs2_prepare_inode_for_write(file->f_path.dentry, ppos,
 					    iocb->ki_left, appending,
-- 
1.5.5
