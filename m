From: Jan Kara <jack@suse.cz>
Date: Fri, 21 Aug 2009 19:23:55 +0200
Subject: [Ocfs2-devel] [PATCH 05/17] ocfs2: Use __generic_file_aio_write
	instead of generic_file_aio_write_nolock
In-Reply-To: <1250875447-15622-1-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
Message-ID: <1250875447-15622-6-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com

Use the new helper. We have to submit data pages ourselves in case of O_SYNC
write because __generic_file_aio_write does not do it for us. OCFS2 developpers
might think about moving the sync out of i_mutex which seems to be easily
possible but that's out of scope of this patch.

CC: ocfs2-devel at oss.oracle.com
CC: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 62442e4..1c71f0a 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1870,8 +1870,7 @@ relock:
 			goto out_dio;
 		}
 	} else {
-		written = generic_file_aio_write_nolock(iocb, iov, nr_segs,
-							*ppos);
+		written = __generic_file_aio_write(iocb, iov, nr_segs, ppos);
 	}
 
 out_dio:
@@ -1879,18 +1878,21 @@ out_dio:
 	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
 
 	if ((file->f_flags & O_SYNC && !direct_io) || IS_SYNC(inode)) {
-		/*
-		 * The generic write paths have handled getting data
-		 * to disk, but since we don't make use of the dirty
-		 * inode list, a manual journal commit is necessary
-		 * here.
-		 */
-		if (old_size != i_size_read(inode) ||
-		    old_clusters != OCFS2_I(inode)->ip_clusters) {
+		ret = filemap_fdatawrite_range(file->f_mapping, pos,
+					       pos + count - 1);
+		if (ret < 0)
+			written = ret;
+
+		if (!ret && (old_size != i_size_read(inode) ||
+		    old_clusters != OCFS2_I(inode)->ip_clusters)) {
 			ret = jbd2_journal_force_commit(osb->journal->j_journal);
 			if (ret < 0)
 				written = ret;
 		}
+
+		if (!ret)
+			ret = filemap_fdatawait_range(file->f_mapping, pos,
+						      pos + count - 1);
 	}
 
 	/* 
-- 
1.6.0.2
