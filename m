From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 18 Aug 2009 14:19:07 +0800
Subject: [Ocfs2-devel] [PATCH 06/41] ocfs2: Add caching info for refcount
	tree.
In-Reply-To: <4A8A47DF.8020707@oracle.com>
References: <4A8A47DF.8020707@oracle.com>
Message-ID: <1250576382-27080-6-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

refcount tree should use its own caching info so that when
we downconvert the refcount tree lock, we can drop all the
cached buffer head.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 fs/ocfs2/refcounttree.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index a923535..eb0f4a0 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -26,6 +26,13 @@
 #include "super.h"
 #include "buffer_head_io.h"
 #include "blockcheck.h"
+#include "refcounttree.h"
+
+static inline struct ocfs2_refcount_tree *
+cache_info_to_refcount(struct ocfs2_caching_info *ci)
+{
+	return container_of(ci, struct ocfs2_refcount_tree, rf_ci);
+}
 
 static int ocfs2_validate_refcount_block(struct super_block *sb,
 					 struct buffer_head *bh)
@@ -97,3 +104,55 @@ static int ocfs2_read_refcount_block(struct ocfs2_caching_info *ci,
 
 	return rc;
 }
+
+static u64 ocfs2_refcount_cache_owner(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	return rf->rf_blkno;
+}
+
+static struct super_block *
+ocfs2_refcount_cache_get_super(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	return rf->rf_sb;
+}
+
+static void ocfs2_refcount_cache_lock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	spin_lock(&rf->rf_lock);
+}
+
+static void ocfs2_refcount_cache_unlock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	spin_unlock(&rf->rf_lock);
+}
+
+static void ocfs2_refcount_cache_io_lock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	mutex_lock(&rf->rf_io_mutex);
+}
+
+static void ocfs2_refcount_cache_io_unlock(struct ocfs2_caching_info *ci)
+{
+	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
+
+	mutex_unlock(&rf->rf_io_mutex);
+}
+
+static const struct ocfs2_caching_operations ocfs2_refcount_caching_ops = {
+	.co_owner		= ocfs2_refcount_cache_owner,
+	.co_get_super		= ocfs2_refcount_cache_get_super,
+	.co_cache_lock		= ocfs2_refcount_cache_lock,
+	.co_cache_unlock	= ocfs2_refcount_cache_unlock,
+	.co_io_lock		= ocfs2_refcount_cache_io_lock,
+	.co_io_unlock		= ocfs2_refcount_cache_io_unlock,
+};
-- 
1.6.2.rc2.16.gf474c
