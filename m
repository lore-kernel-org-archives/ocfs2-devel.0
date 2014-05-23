From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 23 May 2014 18:02:28 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix incorrect i_size of global bitmap
 inode after resize
Message-ID: <537F1CB4.7000803@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ocfs2 cluster size may be 1MB, which has 20 bits. When resize, the
input new clusters is mostly the number of clusters in a group
descriptor(32256).
Since the input clusters is defined as type int, so it will overflow
when shift left 20 bits and then lead to incorrect global bitmap
i_size.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
---
 fs/ocfs2/resize.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 822ebc1..4261c74 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -157,7 +157,7 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,

 	spin_lock(&OCFS2_I(bm_inode)->ip_lock);
 	OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
-	le64_add_cpu(&fe->i_size, new_clusters << osb->s_clustersize_bits);
+	le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
 	spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
 	i_size_write(bm_inode, le64_to_cpu(fe->i_size));

@@ -569,7 +569,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)

 	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
 	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
-	le64_add_cpu(&fe->i_size, input->clusters << osb->s_clustersize_bits);
+	le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
 	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
 	i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));

-- 
1.8.4.3
