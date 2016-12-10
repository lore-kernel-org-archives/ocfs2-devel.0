From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Sat, 10 Dec 2016 12:43:54 -0800
Subject: [Ocfs2-devel] [PATCH 09/11] ocfs2: fix bad pointer cast
In-Reply-To: <148140257493.24628.6724911560073347399.stgit@birch.djwong.org>
References: <148140257493.24628.6724911560073347399.stgit@birch.djwong.org>
Message-ID: <148140263401.24628.3507306487755083457.stgit@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

generic/188 triggered a dmesg stack trace because the dio completion
was casting a buffer head to an on-disk inode, which is whacky.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 3c531f1..3372d82 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2317,7 +2317,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 			mlog_errno(ret);
 	}
 
-	di = (struct ocfs2_dinode *)di_bh;
+	di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
 
