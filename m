From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:31:32 +0100
Subject: [Ocfs2-devel] [PATCH 07/10] quota: Export dquot_alloc() and
	dquot_destroy() functions
In-Reply-To: <1227623495-16708-6-git-send-email-jack@suse.cz>
References: <y> <1227623495-16708-1-git-send-email-jack@suse.cz>
	<1227623495-16708-2-git-send-email-jack@suse.cz>
	<1227623495-16708-3-git-send-email-jack@suse.cz>
	<1227623495-16708-4-git-send-email-jack@suse.cz>
	<1227623495-16708-5-git-send-email-jack@suse.cz>
	<1227623495-16708-6-git-send-email-jack@suse.cz>
Message-ID: <1227623495-16708-7-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

These are default functions for creating and destroying quota structures
and they should be used from filesystems.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c               |    6 ++++--
 include/linux/quotaops.h |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 6f7df91..c724586 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -413,10 +413,11 @@ out_dqlock:
 	return ret;
 }
 
-static void dquot_destroy(struct dquot *dquot)
+void dquot_destroy(struct dquot *dquot)
 {
 	kmem_cache_free(dquot_cachep, dquot);
 }
+EXPORT_SYMBOL(dquot_destroy);
 
 static inline void do_destroy_dquot(struct dquot *dquot)
 {
@@ -668,10 +669,11 @@ we_slept:
 	spin_unlock(&dq_list_lock);
 }
 
-static struct dquot *dquot_alloc(struct super_block *sb, int type)
+struct dquot *dquot_alloc(struct super_block *sb, int type)
 {
 	return kmem_cache_zalloc(dquot_cachep, GFP_NOFS);
 }
+EXPORT_SYMBOL(dquot_alloc);
 
 static struct dquot *get_empty_dquot(struct super_block *sb, int type)
 {
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index f491394..21b781a 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -31,6 +31,8 @@ int dquot_is_cached(struct super_block *sb, unsigned int id, int type);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),
 		      unsigned long priv);
+struct dquot *dquot_alloc(struct super_block *sb, int type);
+void dquot_destroy(struct dquot *dquot);
 
 int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_alloc_inode(const struct inode *inode, qsize_t number);
-- 
1.6.0.4
