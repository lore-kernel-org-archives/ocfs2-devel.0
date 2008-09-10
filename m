From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 10 Sep 2008 01:48:13 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 regression fix
Message-ID: <20080910084813.GZ4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Tao Ma (1):
      ocfs2: Fix a bug in direct IO read.

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 506c24f..a53da14 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -594,7 +594,7 @@ static int ocfs2_direct_IO_get_blocks(struct inode *inode, sector_t iblock,
 		goto bail;
 	}
 
-	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)) && !p_blkno) {
+	if (!ocfs2_sparse_alloc(OCFS2_SB(inode->i_sb)) && !p_blkno && create) {
 		ocfs2_error(inode->i_sb,
 			    "Inode %llu has a hole at block %llu\n",
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
