From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 22 Apr 2010 14:40:28 +0800
Subject: [Ocfs2-devel] [PATCH 14/17] ocfs2: Add ocfs2_gd_is_discontig.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <1271918431-8135-14-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add ocfs2_gd_is_discontig so that we can test whether
a group descriptor is discontiguous or not.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/ocfs2_fs.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index 67bb8a7..b5b3cb7 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -1574,5 +1574,11 @@ static inline void ocfs2_set_de_type(struct ocfs2_dir_entry *de,
 	de->file_type = ocfs2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
 }
 
+static inline int ocfs2_gd_is_discontig(struct ocfs2_group_desc *gd)
+{
+	return ((offsetof(struct ocfs2_group_desc, bg_bitmap) + gd->bg_size ==
+		offsetof(struct ocfs2_group_desc, bg_list)) &&
+		gd->bg_list.l_next_free_rec);
+}
 #endif  /* _OCFS2_FS_H */
 
-- 
1.5.5
