From: Tao Ma <tao.ma@oracle.com>
Date: Thu,  8 Jul 2010 11:11:11 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Remove the redundant cpu_to_le64.
Message-ID: <1278558671-18125-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_block_group_alloc, we set c_blkno by bg->bg_blkno.
But actually bg->bg_blkno is already changed to little endian
in ocfs2_block_group_fill. So remove the extra cpu_to_le64.

Reported-by: Marcos Matsunaga <Marcos.Matsunaga@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/suballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 8e881b5..3b8f85b 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -618,7 +618,7 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 		     le16_to_cpu(bg->bg_free_bits_count));
 	le32_add_cpu(&cl->cl_recs[alloc_rec].c_total,
 		     le16_to_cpu(bg->bg_bits));
-	cl->cl_recs[alloc_rec].c_blkno  = cpu_to_le64(bg->bg_blkno);
+	cl->cl_recs[alloc_rec].c_blkno = bg->bg_blkno;
 	if (le16_to_cpu(cl->cl_next_free_rec) < le16_to_cpu(cl->cl_count))
 		le16_add_cpu(&cl->cl_next_free_rec, 1);
 
-- 
1.7.1.571.gba4d01
