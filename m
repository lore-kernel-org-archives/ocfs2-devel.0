From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 13 Jul 2009 11:38:58 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] fails ocfs2_get_block() immediately when
	hit -EIO
Message-ID: <200907130340.n6D3eBcx019309@rgminet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

  fails ocfs2_get_block() immediately when hit -EIO

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/ocfs2/aops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index a10c989..9dfdf46 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -195,6 +195,7 @@ static int ocfs2_get_block(struct inode *inode, sector_t iblock,
 			     (unsigned long long)i_size_read(inode),
 			     OCFS2_I(inode)->ip_clusters);
 			dump_stack();
+			goto bail;
 		}
 
 		past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
-- 
1.6.2.5
