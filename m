From: Jan Kara <jack@suse.cz>
Date: Thu,  4 Feb 2016 15:28:06 +0100
Subject: [Ocfs2-devel] [PATCH 2/3] quota_v2: Implement get_next_id() for V2
	quota format
In-Reply-To: <1454596087-6814-1-git-send-email-jack@suse.cz>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
Message-ID: <1454596087-6814-3-git-send-email-jack@suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>

Implement functions to get id of next existing quota structure in quota
file for quota tree based formats and thus for V2 quota format.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota_tree.c       | 67 +++++++++++++++++++++++++++++++++++++++++++--
 fs/quota/quota_v2.c         |  6 ++++
 include/linux/dqblk_qtree.h |  2 ++
 3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
index 58efb83dec1c..0738972e8d3f 100644
--- a/fs/quota/quota_tree.c
+++ b/fs/quota/quota_tree.c
@@ -22,10 +22,9 @@ MODULE_LICENSE("GPL");
 
 #define __QUOTA_QT_PARANOIA
 
-static int get_index(struct qtree_mem_dqinfo *info, struct kqid qid, int depth)
+static int __get_index(struct qtree_mem_dqinfo *info, qid_t id, int depth)
 {
 	unsigned int epb = info->dqi_usable_bs >> 2;
-	qid_t id = from_kqid(&init_user_ns, qid);
 
 	depth = info->dqi_qtree_depth - depth - 1;
 	while (depth--)
@@ -33,6 +32,13 @@ static int get_index(struct qtree_mem_dqinfo *info, struct kqid qid, int depth)
 	return id % epb;
 }
 
+static int get_index(struct qtree_mem_dqinfo *info, struct kqid qid, int depth)
+{
+	qid_t id = from_kqid(&init_user_ns, qid);
+
+	return __get_index(info, id, depth);
+}
+
 /* Number of entries in one blocks */
 static int qtree_dqstr_in_blk(struct qtree_mem_dqinfo *info)
 {
@@ -668,3 +674,60 @@ int qtree_release_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot)
 	return 0;
 }
 EXPORT_SYMBOL(qtree_release_dquot);
+
+static int find_next_id(struct qtree_mem_dqinfo *info, qid_t *id,
+			unsigned int blk, int depth)
+{
+	char *buf = getdqbuf(info->dqi_usable_bs);
+	__le32 *ref = (__le32 *)buf;
+	ssize_t ret;
+	unsigned int epb = info->dqi_usable_bs >> 2;
+	unsigned int level_inc = 1;
+	int i;
+
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = depth; i < info->dqi_qtree_depth - 1; i++)
+		level_inc *= epb;
+
+	ret = read_blk(info, blk, buf);
+	if (ret < 0) {
+		quota_error(info->dqi_sb,
+			    "Can't read quota tree block %u", blk);
+		goto out_buf;
+	}
+	for (i = __get_index(info, *id, depth); i < epb; i++) {
+		if (ref[i] == cpu_to_le32(0)) {
+			*id += level_inc;
+			continue;
+		}
+		if (depth == info->dqi_qtree_depth - 1) {
+			ret = 0;
+			goto out_buf;
+		}
+		ret = find_next_id(info, id, le32_to_cpu(ref[i]), depth + 1);
+		if (ret != -ENOENT)
+			break;
+	}
+	if (i == epb) {
+		ret = -ENOENT;
+		goto out_buf;
+	}
+out_buf:
+	kfree(buf);
+	return ret;
+}
+
+int qtree_get_next_id(struct qtree_mem_dqinfo *info, struct kqid *qid)
+{
+	qid_t id = from_kqid(&init_user_ns, *qid);
+	int ret;
+
+	ret = find_next_id(info, &id, QT_TREEOFF, 0);
+	if (ret < 0)
+		return ret;
+	*qid = make_kqid(&init_user_ns, qid->type, id);
+	return 0;
+}
+EXPORT_SYMBOL(qtree_get_next_id);
diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
index ed85d4f35c04..ca71bf881ad1 100644
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -304,6 +304,11 @@ static int v2_free_file_info(struct super_block *sb, int type)
 	return 0;
 }
 
+static int v2_get_next_id(struct super_block *sb, struct kqid *qid)
+{
+	return qtree_get_next_id(sb_dqinfo(sb, qid->type)->dqi_priv, qid);
+}
+
 static const struct quota_format_ops v2_format_ops = {
 	.check_quota_file	= v2_check_quota_file,
 	.read_file_info		= v2_read_file_info,
@@ -312,6 +317,7 @@ static const struct quota_format_ops v2_format_ops = {
 	.read_dqblk		= v2_read_dquot,
 	.commit_dqblk		= v2_write_dquot,
 	.release_dqblk		= v2_release_dquot,
+	.get_next_id		= v2_get_next_id,
 };
 
 static struct quota_format_type v2r0_quota_format = {
diff --git a/include/linux/dqblk_qtree.h b/include/linux/dqblk_qtree.h
index ff8b55359648..0de21e935976 100644
--- a/include/linux/dqblk_qtree.h
+++ b/include/linux/dqblk_qtree.h
@@ -15,6 +15,7 @@
 #define QTREE_DEL_REWRITE 6
 
 struct dquot;
+struct kqid;
 
 /* Operations */
 struct qtree_fmt_operations {
@@ -52,5 +53,6 @@ static inline int qtree_depth(struct qtree_mem_dqinfo *info)
 		entries *= epb;
 	return i;
 }
+int qtree_get_next_id(struct qtree_mem_dqinfo *info, struct kqid *qid);
 
 #endif /* _LINUX_DQBLK_QTREE_H */
-- 
2.6.2
