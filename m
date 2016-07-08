From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 8 Jul 2016 14:23:41 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: improve recovery performance
In-Reply-To: <1467858288-4159-1-git-send-email-junxiao.bi@oracle.com>
References: <1467858288-4159-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20160708142341.5d8c3ab794e89cc981267391@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu,  7 Jul 2016 10:24:48 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Journal replay will be run when do recovery for a dead node,
> to avoid the stale cache impact, all blocks of dead node's
> journal inode were reload from disk. This hurts the performance,
> check whether one block is cached before reload it can improve
> a lot performance. In my test env, the time doing recovery was
> improved from 120s to 1s.

So since v1 you did this (unchangelogged bugfix!):

--- a/fs/ocfs2/journal.c~ocfs2-improve-recovery-performance-v2
+++ a/fs/ocfs2/journal.c
@@ -1194,6 +1194,7 @@ static int ocfs2_force_read_journal(stru
 
 			brelse(bh);
 			bh = NULL;
+			p_blkno++;
 		}
 
 		v_blkno += p_blocks;


I suppose this is a bit neater?

--- a/fs/ocfs2/journal.c~ocfs2-improve-recovery-performance-v2-fix
+++ a/fs/ocfs2/journal.c
@@ -1172,14 +1172,12 @@ static int ocfs2_force_read_journal(stru
 			goto bail;
 		}
 
-		for (i = 0; i < p_blocks; i++) {
+		for (i = 0; i < p_blocks; i++, p_blkno++) {
 			bh = __find_get_block(osb->sb->s_bdev, p_blkno,
 					osb->sb->s_blocksize);
 			/* block not cached. */
-			if (!bh) {
-				p_blkno++;
+			if (!bh)
 				continue;
-			}
 
 			brelse(bh);
 			bh = NULL;
@@ -1194,7 +1192,6 @@ static int ocfs2_force_read_journal(stru
 
 			brelse(bh);
 			bh = NULL;
-			p_blkno++;
 		}
 
 		v_blkno += p_blocks;
_
