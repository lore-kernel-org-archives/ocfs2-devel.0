From: Jan Kara <jack@suse.cz>
Date: Wed,  2 Sep 2009 15:59:22 +0200
Subject: [Ocfs2-devel] [PATCH 12/16] ocfs2: Update syncing after splicing to
	match generic version
In-Reply-To: <1251899966-7316-1-git-send-email-jack@suse.cz>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
Message-ID: <1251899966-7316-13-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

Update ocfs2 specific splicing code to use generic syncing helper. The sync now
does not happen under rw_lock because generic_write_sync() acquires i_mutex
which ranks above rw_lock. That should not matter because standard fsync path
does not hold it either.

Acked-by: Joel Becker <Joel.Becker@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
CC: ocfs2-devel at oss.oracle.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/file.c |   27 ++++++---------------------
 1 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 6002273..221c5e9 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1993,31 +1993,16 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
 
 	if (ret > 0) {
 		unsigned long nr_pages;
+		int err;
 
-		*ppos += ret;
 		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
-		/*
-		 * If file or inode is SYNC and we actually wrote some data,
-		 * sync it.
-		 */
-		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
-			int err;
-
-			mutex_lock(&inode->i_mutex);
-			err = ocfs2_rw_lock(inode, 1);
-			if (err < 0) {
-				mlog_errno(err);
-			} else {
-				err = generic_osync_inode(inode, mapping,
-						  OSYNC_METADATA|OSYNC_DATA);
-				ocfs2_rw_unlock(inode, 1);
-			}
-			mutex_unlock(&inode->i_mutex);
+		err = generic_write_sync(out, *ppos, ret);
+		if (err)
+			ret = err;
+		else
+			*ppos += ret;
 
-			if (err)
-				ret = err;
-		}
 		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
 	}
 
-- 
1.6.0.2
