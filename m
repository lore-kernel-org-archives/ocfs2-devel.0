From: Joel Becker <joel.becker@oracle.com>
Date: Thu,  9 Oct 2008 17:20:33 -0700
Subject: [Ocfs2-devel] [PATCH 5/6] ocfs2: Kill the last naked
	wait_on_buffer() for cached reads.
In-Reply-To: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
References: <1223598034-26284-1-git-send-email-joel.becker@oracle.com>
Message-ID: <1223598034-26284-6-git-send-email-joel.becker@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2's cached buffer I/O goes through ocfs2_read_block(s)().  dir.c had
a naked wait_on_buffer() to wait for some readahead, but it should
use ocfs2_read_block() instead.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dir.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 9202525..63f4839 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -304,14 +304,13 @@ restart:
 		}
 		if ((bh = bh_use[ra_ptr++]) == NULL)
 			goto next;
-		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh)) {
-			/* read error, skip block & hope for the best */
+		if (ocfs2_read_block(dir, block, &bh)) {
+			/* read error, skip block & hope for the best.
+			 * ocfs2_read_block() has released the bh. */
 			ocfs2_error(dir->i_sb, "reading directory %llu, "
 				    "offset %lu\n",
 				    (unsigned long long)OCFS2_I(dir)->ip_blkno,
 				    block);
-			brelse(bh);
 			goto next;
 		}
 		i = ocfs2_search_dirblock(bh, dir, name, namelen,
-- 
1.5.6.5
