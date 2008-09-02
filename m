From: Tao Ma <tao.ma@oracle.com>
Date: Wed,  3 Sep 2008 01:57:14 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Fix a bug in direct IO read.
Message-ID: <1220378234-7298-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2 will become read-only if we try to read the bytes which pass
the end of i_size. This can be easily reproduced by following steps:
1. mkfs a ocfs2 volume with bs=4k cs=4k and nosparse.
2. create a small file(say less than 100 bytes) and we will create the file
   which is allocated 1 cluster.
3. read 8196 bytes from the kernel using O_DIRECT which exceeds the limit.
4. The ocfs2 volume becomes read-only and dmesg shows:
OCFS2: ERROR (device sda13): ocfs2_direct_IO_get_blocks:
Inode 66010 has a hole at block 1
File system is now read-only due to the potential of on-disk corruption.
Please run fsck.ocfs2 once the file system is unmounted.

So suppress the ERROR message.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 80fa3fc..259775e 100644
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
-- 
1.5.4.GIT
