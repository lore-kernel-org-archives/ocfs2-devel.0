From: Fabian Frederick <fabf@skynet.be>
Date: Tue, 8 Apr 2014 22:09:34 +0200
Subject: [Ocfs2-devel] [PATCH 1/1] fs/ocfs2/super.c: Use
 OCFS2_MAX_VOL_LABEL_LEN and strlcpy
Message-ID: <20140408220934.0db1da0682cdeff131c3b2d8@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com

Replace strncpy(size 63) by defined value.

Cc: Andrew Morton <akpm@linuxfoundation.org>
Cc: ocfs2-devel at oss.oracle.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a7cdd56..5dee292c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2292,8 +2292,8 @@ static int ocfs2_initialize_super(struct super_block *sb,
 		goto bail;
 	}
 
-	strncpy(osb->vol_label, di->id2.i_super.s_label, 63);
-	osb->vol_label[63] = '\0';
+	strlcpy(osb->vol_label, di->id2.i_super.s_label,
+		OCFS2_MAX_VOL_LABEL_LEN);
 	osb->root_blkno = le64_to_cpu(di->id2.i_super.s_root_blkno);
 	osb->system_dir_blkno = le64_to_cpu(di->id2.i_super.s_system_dir_blkno);
 	osb->first_cluster_group_blkno =
-- 
1.8.4.5
