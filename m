From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 01 Dec 2016 16:55:01 -0800
Subject: [Ocfs2-devel] [PATCH 6/8] ocfs2: always unlock when completing dio
	writes
In-Reply-To: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
References: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
Message-ID: <148064010137.14039.7690158840871777809.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

Always unlock the inode when completing dio writes, even if an error
has occurrred.  The caller already checks the inode and unlocks it
if needed, so we might as well reduce contention.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/aops.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)


diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 136a49c..3c531f1 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2392,13 +2392,10 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
 	int level;
 	int ret = 0;
 
-	if (bytes <= 0)
-		return 0;
-
 	/* this io's submitter should not have unlocked this before we could */
 	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
 
-	if (private)
+	if (bytes > 0 && private)
 		ret = ocfs2_dio_end_io_write(inode, private, offset, bytes);
 
 	ocfs2_iocb_clear_rw_locked(iocb);
