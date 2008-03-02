From: Tao Ma <tao.ma@oracle.com>
Date: Sun Mar  2 18:53:06 2008
Subject: [Ocfs2-devel] [PATCH 1/1] Fix an endian bug in online resize.
In-Reply-To: <20080229213936.GE9349@ca-server1.us.oracle.com>
Message-ID: <20080303025302.GA14931@tma-pc1.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In ocfs2_group_add, 'cr' is of type 'ocfs2_chain_rec', so here is
a endian bug. Fix it.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/resize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 37835ff..8166968 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -597,7 +597,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 		memset(cr, 0, sizeof(struct ocfs2_chain_rec));
 	}
 
-	cr->c_blkno = le64_to_cpu(input->group);
+	cr->c_blkno = cpu_to_le64(input->group);
 	le32_add_cpu(&cr->c_total, input->clusters * cl_bpc);
 	le32_add_cpu(&cr->c_free, input->frees * cl_bpc);
 
-- 
1.5.3.GIT
