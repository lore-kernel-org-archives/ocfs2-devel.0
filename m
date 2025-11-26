Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4F32DD60E
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Nov 2025 11:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764157477; cv=none; b=I/fl1yi/rNop5qpMV9bg46IhivBbw8mlLuzBrlmPDm73j6lQ8OMr05An3rmYI/wg2rWA/2Y6jNQ74uay5NBW7g65BIsf/D6E5qQRud3F8dCHyKB4MYBHS6P6Di60GN2LH0QIFDRhVH2cjgpN0aVB6jTYFwQ5VhLpewks95GhhDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764157477; c=relaxed/simple;
	bh=PovGOu+ng2ff7batpOmbwC5wyvQBlTfjHOgS/NSXJaI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B1X6DCoSqzRGYkAUjpuMudHq0PKfxSJIpoxjavlec8SFDUu30zlMEhIcX8hJIfUAC5uNfKDTUldVUn8OzdrhW3xwil9RQ6S7djbBh4JchUzeopFksAOblQbldIS06oAzvVybUVmSEpadm542AJJEmSdP4VyR3sdzMTq07g60loY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qAIFz2ld; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qAIFz2ld"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764157468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+sOOZHFPAZ3S4mQVgj3ivWqQgtNn2xlRIdwQR8B/Ksc=;
	b=qAIFz2ld3oxQGp/rOe+MnbPgDjm9iLvNnHUzdua13vvBWmos1EymY0rDK2GQsfW929XEdL
	QTcOAYkZCZcLqAa2Do4gUyDU4LbUvgkHMYGtndIKA6CgT5NklJ74oqdqVKA/MUbqjcNGv8
	nMZd9fCroNStOnrz8kyqJzVyKEylMcg=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: Replace deprecated strcpy with strscpy
Date: Wed, 26 Nov 2025 12:44:15 +0100
Message-ID: <20251126114419.92539-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

strcpy() has been deprecated [1] because it performs no bounds checking
on the destination buffer, which can lead to buffer overflows. Replace
it with the safer strscpy().  No functional changes.

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/ocfs2/alloc.c               |  5 +++--
 fs/ocfs2/cluster/nodemanager.c |  3 ++-
 fs/ocfs2/dir.c                 | 10 +++++-----
 fs/ocfs2/namei.c               |  3 ++-
 fs/ocfs2/stackglue.c           |  3 ++-
 fs/ocfs2/suballoc.c            |  3 ++-
 6 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 162711cc5b20..c1bd531955bc 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -10,6 +10,7 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/highmem.h>
 #include <linux/swap.h>
 #include <linux/quotaops.h>
@@ -1037,7 +1038,7 @@ static int ocfs2_create_new_meta_bhs(handle_t *handle,
 			memset(bhs[i]->b_data, 0, osb->sb->s_blocksize);
 			eb = (struct ocfs2_extent_block *) bhs[i]->b_data;
 			/* Ok, setup the minimal stuff here. */
-			strcpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
+			strscpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
 			eb->h_blkno = cpu_to_le64(first_blkno);
 			eb->h_fs_generation = cpu_to_le32(osb->fs_generation);
 			eb->h_suballoc_slot =
@@ -6744,7 +6745,7 @@ static int ocfs2_reuse_blk_from_dealloc(handle_t *handle,
 		/* We can't guarantee that buffer head is still cached, so
 		 * polutlate the extent block again.
 		 */
-		strcpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
+		strscpy(eb->h_signature, OCFS2_EXTENT_BLOCK_SIGNATURE);
 		eb->h_blkno = cpu_to_le64(bf->free_blk);
 		eb->h_fs_generation = cpu_to_le32(osb->fs_generation);
 		eb->h_suballoc_slot = cpu_to_le16(real_slot);
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 2f61d39e4e50..6bc4e064ace4 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/configfs.h>
@@ -590,7 +591,7 @@ static struct config_item *o2nm_node_group_make_item(struct config_group *group,
 	if (node == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	strcpy(node->nd_name, name); /* use item.ci_namebuf instead? */
+	strscpy(node->nd_name, name); /* use item.ci_namebuf instead? */
 	config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
 	spin_lock_init(&node->nd_lock);
 
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8c9c4825f984..53db86c6fe9c 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -136,7 +136,7 @@ static void ocfs2_init_dir_trailer(struct inode *inode,
 	struct ocfs2_dir_block_trailer *trailer;
 
 	trailer = ocfs2_trailer_from_bh(bh, inode->i_sb);
-	strcpy(trailer->db_signature, OCFS2_DIR_TRAILER_SIGNATURE);
+	strscpy(trailer->db_signature, OCFS2_DIR_TRAILER_SIGNATURE);
 	trailer->db_compat_rec_len =
 			cpu_to_le16(sizeof(struct ocfs2_dir_block_trailer));
 	trailer->db_parent_dinode = cpu_to_le64(OCFS2_I(inode)->ip_blkno);
@@ -2192,14 +2192,14 @@ static struct ocfs2_dir_entry *ocfs2_fill_initial_dirents(struct inode *inode,
 	de->name_len = 1;
 	de->rec_len =
 		cpu_to_le16(OCFS2_DIR_REC_LEN(de->name_len));
-	strcpy(de->name, ".");
+	strscpy(de->name, ".");
 	ocfs2_set_de_type(de, S_IFDIR);
 
 	de = (struct ocfs2_dir_entry *) ((char *)de + le16_to_cpu(de->rec_len));
 	de->inode = cpu_to_le64(OCFS2_I(parent)->ip_blkno);
 	de->rec_len = cpu_to_le16(size - OCFS2_DIR_REC_LEN(1));
 	de->name_len = 2;
-	strcpy(de->name, "..");
+	strscpy(de->name, "..");
 	ocfs2_set_de_type(de, S_IFDIR);
 
 	return de;
@@ -2357,7 +2357,7 @@ static int ocfs2_dx_dir_attach_index(struct ocfs2_super *osb,
 
 	dx_root = (struct ocfs2_dx_root_block *)dx_root_bh->b_data;
 	memset(dx_root, 0, osb->sb->s_blocksize);
-	strcpy(dx_root->dr_signature, OCFS2_DX_ROOT_SIGNATURE);
+	strscpy(dx_root->dr_signature, OCFS2_DX_ROOT_SIGNATURE);
 	dx_root->dr_suballoc_slot = cpu_to_le16(meta_ac->ac_alloc_slot);
 	dx_root->dr_suballoc_loc = cpu_to_le64(suballoc_loc);
 	dx_root->dr_suballoc_bit = cpu_to_le16(dr_suballoc_bit);
@@ -2433,7 +2433,7 @@ static int ocfs2_dx_dir_format_cluster(struct ocfs2_super *osb,
 		dx_leaf = (struct ocfs2_dx_leaf *) bh->b_data;
 
 		memset(dx_leaf, 0, osb->sb->s_blocksize);
-		strcpy(dx_leaf->dl_signature, OCFS2_DX_LEAF_SIGNATURE);
+		strscpy(dx_leaf->dl_signature, OCFS2_DX_LEAF_SIGNATURE);
 		dx_leaf->dl_fs_generation = cpu_to_le32(osb->fs_generation);
 		dx_leaf->dl_blkno = cpu_to_le64(bh->b_blocknr);
 		dx_leaf->dl_list.de_count =
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index c90b254da75e..4ec6dbed65a8 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -23,6 +23,7 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/highmem.h>
 #include <linux/quotaops.h>
 #include <linux/iversion.h>
@@ -568,7 +569,7 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 	ocfs2_set_links_count(fe, inode->i_nlink);
 
 	fe->i_last_eb_blk = 0;
-	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
+	strscpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
 	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
 	ktime_get_coarse_real_ts64(&ts);
 	fe->i_atime = fe->i_ctime = fe->i_mtime =
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index a28c127b9934..fca2fd07c881 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -10,6 +10,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/kmod.h>
@@ -670,7 +671,7 @@ static int __init ocfs2_stack_glue_init(void)
 {
 	int ret;
 
-	strcpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
+	strscpy(cluster_stack_name, OCFS2_STACK_PLUGIN_O2CB);
 
 	ocfs2_table_header = register_sysctl("fs/ocfs2/nm", ocfs2_nm_table);
 	if (!ocfs2_table_header) {
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 6ac4dcd54588..4b9d0ecd0981 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/highmem.h>
 
 #include <cluster/masklog.h>
@@ -372,7 +373,7 @@ static int ocfs2_block_group_fill(handle_t *handle,
 	}
 
 	memset(bg, 0, sb->s_blocksize);
-	strcpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
+	strscpy(bg->bg_signature, OCFS2_GROUP_DESC_SIGNATURE);
 	bg->bg_generation = cpu_to_le32(osb->fs_generation);
 	bg->bg_size = cpu_to_le16(ocfs2_group_bitmap_size(sb, 1,
 						osb->s_feature_incompat));
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

