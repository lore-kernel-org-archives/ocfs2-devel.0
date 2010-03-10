From: Mark Fasheh <mfasheh@suse.com>
Date: Tue,  9 Mar 2010 18:29:05 -0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: allocation reservations
In-Reply-To: <1268188148-5253-1-git-send-email-mfasheh@suse.com>
References: <1268188148-5253-1-git-send-email-mfasheh@suse.com>
Message-ID: <1268188148-5253-2-git-send-email-mfasheh@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This patch improves Ocfs2 allocation policy by allowing an inode to
reserve a portion of the local alloc bitmap for itself. The reserved
portion (allocation window) is advisory in that other allocation
windows might steal it if the local alloc bitmap becomes
full. Otherwise, the reservations are honored and guaranteed to be
free. When the local alloc window is moved to a different portion of
the bitmap, existing reservations are discarded.

Reservation windows are represented internally by a red-black
tree. Within that tree, each node represents the reservation window of
one inode. An LRU of active reservations is also maintained. When new
data is written, we allocate it from the inodes window. When all bits
in a window are exhausted, we allocate a new one as close to the
previous one as possible. Should we not find free space, an existing
reservation is pulled off the LRU and cannibalized.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 Documentation/filesystems/ocfs2.txt |    3 +
 fs/ocfs2/Makefile                   |    1 +
 fs/ocfs2/cluster/masklog.c          |    1 +
 fs/ocfs2/cluster/masklog.h          |    1 +
 fs/ocfs2/localalloc.c               |   55 ++-
 fs/ocfs2/ocfs2.h                    |    5 +
 fs/ocfs2/reservations.c             |  939 +++++++++++++++++++++++++++++++++++
 fs/ocfs2/reservations.h             |  159 ++++++
 fs/ocfs2/suballoc.h                 |    2 +
 fs/ocfs2/super.c                    |   25 +
 10 files changed, 1185 insertions(+), 6 deletions(-)
 create mode 100644 fs/ocfs2/reservations.c
 create mode 100644 fs/ocfs2/reservations.h

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index c58b9f5..412df90 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -80,3 +80,6 @@ user_xattr	(*)	Enables Extended User Attributes.
 nouser_xattr		Disables Extended User Attributes.
 acl			Enables POSIX Access Control Lists support.
 noacl		(*)	Disables POSIX Access Control Lists support.
+resv_level=4	(*)	Set how agressive allocation reservations will be.
+			Valid values are between 0 (reservations off) to 8
+			(maximum space for reservations).
diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
index 600d2d2..b1cd7fc 100644
--- a/fs/ocfs2/Makefile
+++ b/fs/ocfs2/Makefile
@@ -29,6 +29,7 @@ ocfs2-objs := \
 	mmap.o 			\
 	namei.o 		\
 	refcounttree.o		\
+	reservations.o		\
 	resize.o		\
 	slot_map.o 		\
 	suballoc.o 		\
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index 1cd2934..a56147a 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -115,6 +115,7 @@ static struct mlog_attribute mlog_attrs[MLOG_MAX_BITS] = {
 	define_mask(ERROR),
 	define_mask(NOTICE),
 	define_mask(KTHREAD),
+	define_mask(RESERVATIONS),
 };
 
 static struct attribute *mlog_attr_ptrs[MLOG_MAX_BITS] = {NULL, };
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 9b4d117..af1a610 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -118,6 +118,7 @@
 #define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
 #define ML_NOTICE	0x0000000200000000ULL /* setn to KERN_NOTICE */
 #define ML_KTHREAD	0x0000000400000000ULL /* kernel thread activity */
+#define	ML_RESERVATIONS	0x0000000800000000ULL /* ocfs2 alloc reservations */
 
 #define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
 #define MLOG_INITIAL_NOT_MASK (ML_ENTRY|ML_EXIT)
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index ac10f83..e3c185a 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -52,7 +52,8 @@ static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc);
 
 static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 					     struct ocfs2_dinode *alloc,
-					     u32 numbits);
+					     u32 numbits,
+					     struct ocfs2_alloc_reservation *resv);
 
 static void ocfs2_clear_local_alloc(struct ocfs2_dinode *alloc);
 
@@ -262,6 +263,8 @@ void ocfs2_shutdown_local_alloc(struct ocfs2_super *osb)
 
 	osb->local_alloc_state = OCFS2_LA_DISABLED;
 
+	ocfs2_resmap_uninit(&osb->osb_la_resmap);
+
 	main_bm_inode = ocfs2_get_system_file_inode(osb,
 						    GLOBAL_BITMAP_SYSTEM_INODE,
 						    OCFS2_INVALID_SLOT);
@@ -498,7 +501,7 @@ static int ocfs2_local_alloc_in_range(struct inode *inode,
 	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
 	la = OCFS2_LOCAL_ALLOC(alloc);
 
-	start = ocfs2_local_alloc_find_clear_bits(osb, alloc, bits_wanted);
+	start = ocfs2_local_alloc_find_clear_bits(osb, alloc, bits_wanted, NULL);
 	if (start == -1) {
 		mlog_errno(-ENOSPC);
 		return 0;
@@ -664,7 +667,8 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 	alloc = (struct ocfs2_dinode *) osb->local_alloc_bh->b_data;
 	la = OCFS2_LOCAL_ALLOC(alloc);
 
-	start = ocfs2_local_alloc_find_clear_bits(osb, alloc, bits_wanted);
+	start = ocfs2_local_alloc_find_clear_bits(osb, alloc, bits_wanted,
+						  ac->ac_resv);
 	if (start == -1) {
 		/* TODO: Shouldn't we just BUG here? */
 		status = -ENOSPC;
@@ -687,6 +691,9 @@ int ocfs2_claim_local_alloc_bits(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	ocfs2_resmap_claimed_bits(&osb->osb_la_resmap, ac->ac_resv, start,
+				  bits_wanted);
+
 	while(bits_wanted--)
 		ocfs2_set_bit(start++, bitmap);
 
@@ -722,11 +729,15 @@ static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
 }
 
 static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
-					     struct ocfs2_dinode *alloc,
-					     u32 numbits)
+				     struct ocfs2_dinode *alloc,
+				     u32 numbits,
+				     struct ocfs2_alloc_reservation *resv)
 {
 	int numfound, bitoff, left, startoff, lastzero;
+	int local_resv = 0;
+	struct ocfs2_alloc_reservation r;
 	void *bitmap = NULL;
+	struct ocfs2_reservation_map *resmap = &osb->osb_la_resmap;
 
 	mlog_entry("(numbits wanted = %u)\n", numbits);
 
@@ -736,6 +747,30 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 		goto bail;
 	}
 
+	if (!resv) {
+		local_resv = 1;
+		ocfs2_resv_init_once(&r);
+		resv = &r;
+	}
+
+	numfound = numbits;
+	if (ocfs2_resmap_resv_bits(resmap, resv, local_resv,
+				   &bitoff, &numfound) == 0) {
+		if (numfound >= numbits)
+			numfound = numbits;
+		goto bail;
+	}
+
+	/*
+	 * Code error. While reservations are enabled, local
+	 * allocation should _always_ go through them.
+	 */
+	BUG_ON(osb->osb_resv_level != 0);
+
+	/*
+	 * Reservations are disabled. Handle this the old way.
+	 */
+
 	bitmap = OCFS2_LOCAL_ALLOC(alloc)->la_bitmap;
 
 	numfound = bitoff = startoff = 0;
@@ -772,10 +807,15 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 
 	if (numfound == numbits)
 		bitoff = startoff - numfound;
-	else
+	else {
+		numfound = 0;
 		bitoff = -1;
+	}
 
 bail:
+	if (local_resv)
+		ocfs2_resv_discard(resmap, resv);
+
 	mlog_exit(bitoff);
 	return bitoff;
 }
@@ -1096,6 +1136,9 @@ retry_enospc:
 	memset(OCFS2_LOCAL_ALLOC(alloc)->la_bitmap, 0,
 	       le16_to_cpu(la->la_size));
 
+	ocfs2_resmap_restart(&osb->osb_la_resmap, cluster_count,
+			     OCFS2_LOCAL_ALLOC(alloc)->la_bitmap);
+
 	mlog(0, "New window allocated:\n");
 	mlog(0, "window la_bm_off = %u\n",
 	     OCFS2_LOCAL_ALLOC(alloc)->la_bm_off);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 740f448..e0c6d5e 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -46,6 +46,7 @@
 /* For struct ocfs2_blockcheck_stats */
 #include "blockcheck.h"
 
+#include "reservations.h"
 
 /* Caching of metadata buffers */
 
@@ -346,6 +347,10 @@ struct ocfs2_super
 
 	u64 la_last_gd;
 
+	struct ocfs2_reservation_map	osb_la_resmap;
+
+	unsigned int	osb_resv_level;
+
 	/* Next three fields are for local node slot recovery during
 	 * mount. */
 	int dirty;
diff --git a/fs/ocfs2/reservations.c b/fs/ocfs2/reservations.c
new file mode 100644
index 0000000..728e753
--- /dev/null
+++ b/fs/ocfs2/reservations.c
@@ -0,0 +1,939 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * reservations.c
+ *
+ * Allocation reservations implementation
+ *
+ * Some code borrowed from fs/ext3/balloc.c and is:
+ *
+ * Copyright (C) 1992, 1993, 1994, 1995
+ * Remy Card (card at masi.ibp.fr)
+ * Laboratoire MASI - Institut Blaise Pascal
+ * Universite Pierre et Marie Curie (Paris VI)
+ *
+ * The rest is copyright (C) 2009 Novell.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/bitops.h>
+#include <linux/list.h>
+
+#define MLOG_MASK_PREFIX ML_RESERVATIONS
+#include <cluster/masklog.h>
+
+#include "ocfs2.h"
+
+#ifdef CONFIG_OCFS2_DEBUG_FS
+#define OCFS2_CHECK_RESERVATIONS
+#endif
+
+#define OCFS2_CHECK_RESERVATIONS
+
+
+DEFINE_SPINLOCK(resv_lock);
+
+#define	OCFS2_MIN_RESV_WINDOW_BITS	8
+#define	OCFS2_MAX_RESV_WINDOW_BITS	1024
+
+static unsigned int ocfs2_resv_window_bits(struct ocfs2_reservation_map *resmap)
+{
+	struct ocfs2_super *osb = resmap->m_osb;
+
+	/* 8, 16, 32, 64, 128, 256, 512, 1024 */
+	return 4 << osb->osb_resv_level;
+}
+
+static inline unsigned int ocfs2_resv_end(struct ocfs2_alloc_reservation *resv)
+{
+	if (resv->r_len)
+		return resv->r_start + resv->r_len - 1;
+	return resv->r_start;
+}
+
+static inline int ocfs2_resv_empty(struct ocfs2_alloc_reservation *resv)
+{
+	return !!(resv->r_len == 0);
+}
+
+static inline int ocfs2_resmap_disabled(struct ocfs2_reservation_map *resmap)
+{
+	if (resmap->m_osb->osb_resv_level == 0)
+		return 1;
+	return 0;
+}
+
+static void ocfs2_dump_resv(struct ocfs2_reservation_map *resmap)
+{
+	struct ocfs2_super *osb = resmap->m_osb;
+	struct rb_node *node;
+	struct ocfs2_alloc_reservation *resv;
+	int i = 0;
+
+	mlog(ML_NOTICE, "Dumping resmap for device %s. Bitmap length: %u\n",
+	     osb->dev_str, resmap->m_bitmap_len);
+
+	node = rb_first(&resmap->m_reservations);
+	while (node) {
+		resv = rb_entry(node, struct ocfs2_alloc_reservation, r_node);
+
+		mlog(ML_NOTICE, "start: %u\tend: %u\tlen: %u\tlast_start: %u"
+		     "\tlast_len: %u\n", resv->r_start,
+		     ocfs2_resv_end(resv), resv->r_len, resv->r_last_start,
+		     resv->r_last_len);
+
+		node = rb_next(node);
+		i++;
+	}
+
+	mlog(ML_NOTICE, "%d reservations found. LRU follows\n", i);
+
+	i = 0;
+	list_for_each_entry(resv, &resmap->m_lru, r_lru) {
+		mlog(ML_NOTICE, "LRU(%d) start: %u\tend: %u\tlen: %u\t"
+		     "last_start: %u\tlast_len: %u\n", i, resv->r_start,
+		     ocfs2_resv_end(resv), resv->r_len, resv->r_last_start,
+		     resv->r_last_len);
+
+		i++;
+	}
+}
+
+#ifdef OCFS2_CHECK_RESERVATIONS
+static int ocfs2_validate_resmap_bits(struct ocfs2_reservation_map *resmap,
+				      int i,
+				      struct ocfs2_alloc_reservation *resv)
+{
+	char *disk_bitmap = resmap->m_disk_bitmap;
+	unsigned int start = resv->r_start;
+	unsigned int end = ocfs2_resv_end(resv);
+
+	while(start <= end) {
+		if (ocfs2_test_bit(start, disk_bitmap)) {
+			mlog(ML_ERROR,
+			     "reservation %d covers an allocated area "
+			     "starting@bit %u!\n", i, start);
+			return 1;
+		}
+
+		start++;
+	}
+	return 0;
+}
+
+static void ocfs2_check_resmap(struct ocfs2_reservation_map *resmap)
+{
+	unsigned int off = 0;
+	int i = 0;
+	struct rb_node *node;
+	struct ocfs2_alloc_reservation *resv;
+
+	node = rb_first(&resmap->m_reservations);
+	while (node) {
+		resv = rb_entry(node, struct ocfs2_alloc_reservation, r_node);
+
+		if (i > 0 && resv->r_start <= off) {
+			mlog(ML_ERROR, "reservation %d has bad start off!\n",
+			     i);
+			goto bad;
+		}
+
+		if (resv->r_len == 0) {
+			mlog(ML_ERROR, "reservation %d has no length!\n",
+			     i);
+			goto bad;
+		}
+
+		if (resv->r_start > ocfs2_resv_end(resv)) {
+			mlog(ML_ERROR, "reservation %d has invalid range!\n",
+			     i);
+			goto bad;
+		}
+
+		if (ocfs2_resv_end(resv) > resmap->m_bitmap_len) {
+			mlog(ML_ERROR, "reservation %d extends past bitmap!\n",
+			     i);
+			goto bad;
+		}
+
+		if (ocfs2_validate_resmap_bits(resmap, i, resv))
+			goto bad;
+
+		off = ocfs2_resv_end(resv);
+		node = rb_next(node);
+
+		i++;
+	}
+	return;
+
+bad:
+	ocfs2_dump_resv(resmap);
+	BUG();
+}
+#else
+static inline void ocfs2_check_resmap(struct ocfs2_reservation_map *resmap)
+{
+
+}
+#endif
+
+void ocfs2_resv_init_once(struct ocfs2_alloc_reservation *resv)
+{
+	memset(resv, 0, sizeof(*resv));
+	INIT_LIST_HEAD(&resv->r_lru);
+}
+
+int ocfs2_resmap_init(struct ocfs2_super *osb,
+		      struct ocfs2_reservation_map *resmap)
+{
+	memset(resmap, 0, sizeof(*resmap));
+
+	resmap->m_osb = osb;
+	resmap->m_reservations = RB_ROOT;
+	/* m_bitmap_len is initialized to zero by the above memset. */
+	INIT_LIST_HEAD(&resmap->m_lru);
+
+	return 0;
+}
+
+static void ocfs2_resv_mark_lru(struct ocfs2_reservation_map *resmap,
+				struct ocfs2_alloc_reservation *resv)
+{
+	assert_spin_locked(&resv_lock);
+
+	if (!list_empty(&resv->r_lru))
+		list_del_init(&resv->r_lru);
+
+	list_add_tail(&resv->r_lru, &resmap->m_lru);
+}
+
+static void __ocfs2_resv_trunc(struct ocfs2_alloc_reservation *resv)
+{
+	resv->r_len = 0;
+	resv->r_start = 0;
+}
+
+static void ocfs2_resv_remove(struct ocfs2_reservation_map *resmap,
+			      struct ocfs2_alloc_reservation *resv)
+{
+	if (resv->r_inuse) {
+		list_del_init(&resv->r_lru);
+		rb_erase(&resv->r_node, &resmap->m_reservations);
+		resv->r_inuse = 0;
+	}
+}
+
+static void __ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
+				 struct ocfs2_alloc_reservation *resv)
+{
+	assert_spin_locked(&resv_lock);
+
+	__ocfs2_resv_trunc(resv);
+	/*
+	 * last_len and last_start no longer make sense if
+	 * we're changing the range of our allocations.
+	 */
+	resv->r_last_len = resv->r_last_start = 0;
+
+	ocfs2_resv_remove(resmap, resv);
+}
+
+/* does nothing if 'resv' is null */
+void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
+			struct ocfs2_alloc_reservation *resv)
+{
+	if (resv) {
+		spin_lock(&resv_lock);
+		__ocfs2_resv_discard(resmap, resv);
+		spin_unlock(&resv_lock);
+	}
+}
+
+static void ocfs2_resmap_clear_all_resv(struct ocfs2_reservation_map *resmap)
+{
+	struct rb_node *node;
+	struct ocfs2_alloc_reservation *resv;
+
+	assert_spin_locked(&resv_lock);
+
+	while ((node = rb_last(&resmap->m_reservations)) != NULL) {
+		resv = rb_entry(node, struct ocfs2_alloc_reservation, r_node);
+
+		__ocfs2_resv_discard(resmap, resv);
+	}
+}
+
+void ocfs2_resmap_restart(struct ocfs2_reservation_map *resmap,
+			  unsigned int clen, char *disk_bitmap)
+{
+	if (ocfs2_resmap_disabled(resmap))
+		return;
+
+	spin_lock(&resv_lock);
+
+	ocfs2_resmap_clear_all_resv(resmap);
+	resmap->m_bitmap_len = clen;
+	resmap->m_search_start = 0;
+	resmap->m_disk_bitmap = disk_bitmap;
+
+	spin_unlock(&resv_lock);
+}
+
+void ocfs2_resmap_uninit(struct ocfs2_reservation_map *resmap)
+{
+	/* Does nothing for now. Keep this around for API symmetry */
+}
+
+static void ocfs2_resv_insert(struct ocfs2_reservation_map *resmap,
+			      struct ocfs2_alloc_reservation *new)
+{
+	struct rb_root *root = &resmap->m_reservations;
+	struct rb_node *parent = NULL;
+	struct rb_node **p = &root->rb_node;
+	struct ocfs2_alloc_reservation *tmp;
+
+	assert_spin_locked(&resv_lock);
+
+	mlog(0, "Insert reservation start: %u len: %u\n", new->r_start,
+	     new->r_len);
+
+	while(*p) {
+		parent = *p;
+
+		tmp = rb_entry(parent, struct ocfs2_alloc_reservation, r_node);
+
+		if (new->r_start < tmp->r_start)
+			p = &(*p)->rb_left;
+		else if (new->r_start > ocfs2_resv_end(tmp))
+			p = &(*p)->rb_right;
+		else {
+			/* This should never happen! */
+			mlog(ML_ERROR, "Duplicate reservation window!\n");
+			BUG();
+		}
+	}
+
+	rb_link_node(&new->r_node, parent, p);
+	rb_insert_color(&new->r_node, root);
+	new->r_inuse = 1;
+
+	ocfs2_resv_mark_lru(resmap, new);
+
+	ocfs2_check_resmap(resmap);
+}
+
+static struct ocfs2_alloc_reservation *
+ocfs2_find_resv(struct ocfs2_reservation_map *resmap, unsigned int goal)
+{
+	struct ocfs2_alloc_reservation *resv;
+	struct rb_node *n = resmap->m_reservations.rb_node;
+
+	assert_spin_locked(&resv_lock);
+
+	if (!n)
+		return NULL;
+
+	do {
+		resv = rb_entry(n, struct ocfs2_alloc_reservation, r_node);
+
+		if (goal < resv->r_start)
+			n = n->rb_left;
+		else if (goal > ocfs2_resv_end(resv))
+			n = n->rb_right;
+		else
+			break;
+	} while (n);
+
+	return resv;
+}
+
+/**
+ * ocfs2_find_resv_lhs() - find the window which contains goal
+ * @resmap: reservation map to search
+ * @goal: which bit to search for
+ *
+ * If a window containing that goal is not found, we return the window
+ * which comes before goal. Returns NULL on empty rbtree or no window
+ * before goal.
+ */
+static struct ocfs2_alloc_reservation *
+ocfs2_find_resv_lhs(struct ocfs2_reservation_map *resmap, unsigned int goal)
+{
+	struct ocfs2_alloc_reservation *resv = NULL;
+	struct ocfs2_alloc_reservation *prev_resv = NULL;
+	struct rb_node *node = resmap->m_reservations.rb_node;
+	struct rb_node *prev = NULL;
+
+	assert_spin_locked(&resv_lock);
+
+	if (!node)
+		return NULL;
+
+	node = rb_first(&resmap->m_reservations);
+	while (node) {
+		resv = rb_entry(node, struct ocfs2_alloc_reservation, r_node);
+
+		if (resv->r_start <= goal && ocfs2_resv_end(resv) >= goal)
+			break;
+
+		/* Check if we overshot the reservation just before goal? */
+		if (resv->r_start > goal) {
+			resv = prev_resv;
+			break;
+		}
+
+		prev_resv = resv;
+		prev = node;
+		node = rb_next(node);
+	}
+
+	return resv;
+}
+
+static int ocfs2_resv_contains(struct ocfs2_alloc_reservation *resv,
+			       unsigned int cstart, unsigned int cend)
+{
+	unsigned int resv_end = ocfs2_resv_end(resv);
+
+	if (resv->r_start > cend)
+		return 0;
+	if (resv_end < cstart)
+		return 0;
+
+	return 1;
+}
+
+static struct ocfs2_alloc_reservation *
+ocfs2_find_resv_containing(struct ocfs2_reservation_map *resmap,
+			   unsigned int cstart,
+			   unsigned int cend)
+{
+	struct ocfs2_alloc_reservation *resv;
+	struct rb_root *root = &resmap->m_reservations;
+
+	assert_spin_locked(&resv_lock);
+
+	if (RB_EMPTY_ROOT(root)) {
+		mlog(0, "empty root\n");
+		return NULL;
+	}
+
+	resv = ocfs2_find_resv(resmap, cstart);
+	if (resv == NULL) {
+		mlog(0, "find_resv returns null");
+		return NULL;
+	}
+
+	mlog(0, "found resv range:(%u, %u)\n", resv->r_start, ocfs2_resv_end(resv));
+
+	if (!ocfs2_resv_contains(resv, cstart, cend)) {
+		mlog(0, "resv does not contain range: (%u, %u)\n", cstart, cend);
+		return NULL;
+	}
+
+	return resv;
+}
+
+/*
+ * We are given a range within the bitmap, which corresponds to a gap
+ * inside the reservations tree (search_start, search_len). The range
+ * can be anything from the whole bitmap, to a gap between
+ * reservations.
+ *
+ * The start value of *rstart is insignificant.
+ *
+ * This function searches the bitmap range starting at search_start
+ * with length csearch_len for a set of contiguous free bits. We try
+ * to find up to 'wanted' bits, but can sometimes return less.
+ *
+ * Returns the length of allocation, 0 if no free bits are found.
+ *
+ * *cstart and *clen will also be populated with the result.
+ */
+static int ocfs2_resmap_find_free_bits(struct ocfs2_reservation_map *resmap,
+				       unsigned int wanted,
+				       unsigned int search_start,
+				       unsigned int search_len,
+				       unsigned int *rstart,
+				       unsigned int *rlen)
+{
+	void *bitmap = resmap->m_disk_bitmap;
+	unsigned int best_start, best_len = 0;
+	int offset, start, found;
+
+	mlog(0, "Find %u bits within range (%u, len %u) resmap len: %u\n",
+	     wanted, search_start, search_len, resmap->m_bitmap_len);
+
+	found = best_start = best_len = 0;
+
+	start = search_start;
+	while((offset = ocfs2_find_next_zero_bit(bitmap, resmap->m_bitmap_len,
+						 start)) != -1) {
+		/* Search reached end of the region */
+		if (offset >= (search_start + search_len))
+			break;
+
+		if (offset == start) {
+			/* we found a zero */
+			found++;
+			/* move start to the next bit to test */
+			start++;
+		} else {
+			/* got a zero after some ones */
+			found = 1;
+			start = offset + 1;
+		}
+		if (found > best_len) {
+			best_len = found;
+			best_start = start - found;
+		}
+
+		if (found >= wanted)
+			break;
+	}
+
+	if (best_len == 0)
+		return 0;
+
+	if (best_len >= wanted)
+		best_len = wanted;
+
+	*rlen = best_len;
+	*rstart = best_start;
+
+	mlog(0, "Found start: %u len: %u\n", best_start, best_len);
+
+	return *rlen;
+}
+
+static void __ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
+				     struct ocfs2_alloc_reservation *resv,
+				     unsigned int goal, unsigned int wanted)
+{
+	struct rb_root *root = &resmap->m_reservations;
+	unsigned int gap_start, gap_end, gap_len;
+	struct ocfs2_alloc_reservation *prev_resv, *next_resv;
+	struct rb_node *prev, *next;
+	unsigned int cstart, clen;
+	unsigned int best_start = 0, best_len = 0;
+
+	/*
+	 * Nasty cases to consider:
+	 *
+	 * - rbtree is empty
+	 * - our window should be first in all reservations
+	 * - our window should be last in all reservations
+	 * - need to make sure we don't go past end of bitmap
+	 */
+
+	mlog(0, "resv start: %u resv end: %u goal: %u wanted: %u\n",
+	     resv->r_start, ocfs2_resv_end(resv), goal, wanted);
+
+	assert_spin_locked(&resv_lock);
+
+	if (RB_EMPTY_ROOT(root)) {
+		/*
+		 * Easiest case - empty tree. We can just take
+		 * whatever window of free bits we want.
+		 */
+
+		mlog(0, "Empty root\n");
+
+		clen = ocfs2_resmap_find_free_bits(resmap, wanted, goal,
+						   resmap->m_bitmap_len - goal,
+						   &cstart, &clen);
+
+		/*
+		 * This should never happen - the local alloc window
+		 * will always have free bits when we're called.
+		 */
+		BUG_ON(goal == 0 && clen == 0);
+
+		if (clen == 0)
+			return;
+
+		resv->r_start = cstart;
+		resv->r_len = clen;
+
+		ocfs2_resv_insert(resmap, resv);
+		return;
+	}
+
+	prev_resv = ocfs2_find_resv_lhs(resmap, goal);
+
+	if (prev_resv == NULL) {
+		mlog(0, "Goal on LHS of leftmost window\n");
+
+		/*
+		 * A NULL here means that the search code couldn't
+		 * find a window that starts before goal.
+		 *
+		 * However, we can take the first window after goal,
+		 * which is also by definition, the leftmost window in
+		 * the entire tree. If we can find free bits in the
+		 * gap between goal and the LHS window, then the
+		 * reservation can safely be placed there.
+		 *
+		 * Otherwise we fall back to a linear search, checking
+		 * the gaps in between windows for a place to
+		 * allocate.
+		 */
+
+		next = rb_first(root);
+		next_resv = rb_entry(next, struct ocfs2_alloc_reservation,
+				     r_node);
+
+		/*
+		 * The search should never return such a window. (see
+		 * comment above
+		 */
+		if (next_resv->r_start <= goal) {
+			mlog(ML_ERROR, "goal: %u next_resv: start %u len %u\n",
+			     goal, next_resv->r_start, next_resv->r_len);
+			ocfs2_dump_resv(resmap);
+			BUG();
+		}
+
+		clen = ocfs2_resmap_find_free_bits(resmap, wanted, goal,
+						   next_resv->r_start - goal,
+						   &cstart, &clen);
+		if (clen) {
+			best_len = clen;
+			best_start = cstart;
+			if (best_len == wanted)
+				goto out_insert;
+		}
+
+		prev_resv = next_resv;
+		next_resv = NULL;
+	}
+
+	prev = &prev_resv->r_node;
+
+	/* Now we do a linear search for a window, starting at 'prev_rsv' */
+	while (1) {
+		next = rb_next(prev);
+		if (next) {
+			mlog(0, "One more resv found in linear search\n");
+			next_resv = rb_entry(next,
+					     struct ocfs2_alloc_reservation,
+					     r_node);
+
+			gap_start = ocfs2_resv_end(prev_resv) + 1;
+			gap_end = next_resv->r_start - 1;
+			gap_len = gap_end - gap_start + 1;
+		} else {
+			mlog(0, "No next node\n");
+			/*
+			 * We're at the rightmost edge of the
+			 * tree. See if a reservation between this
+			 * window and the end of the bitmap will work.
+			 */
+			gap_start = ocfs2_resv_end(prev_resv) + 1;
+			gap_len = resmap->m_bitmap_len - gap_start;
+			gap_end = resmap->m_bitmap_len - 1;
+		}
+
+		clen = ocfs2_resmap_find_free_bits(resmap, wanted, gap_start,
+						   gap_len, &cstart, &clen);
+		if (clen == wanted) {
+			best_len = clen;
+			best_start = cstart;
+			goto out_insert;
+		} else if (clen > best_len) {
+			best_len = clen;
+			best_start = cstart;
+		}
+
+		if (!next)
+			break;
+
+		prev = next;
+		prev_resv = rb_entry(prev, struct ocfs2_alloc_reservation,
+				     r_node);
+	}
+
+out_insert:
+	if (best_len) {
+		resv->r_start = best_start;
+		resv->r_len = best_len;
+		ocfs2_resv_insert(resmap, resv);
+	}
+}
+
+static void ocfs2_cannibalize_resv(struct ocfs2_reservation_map *resmap,
+				   struct ocfs2_alloc_reservation *resv,
+				   unsigned int wanted)
+{
+	struct ocfs2_alloc_reservation *lru_resv;
+	unsigned int min_bits = ocfs2_resv_window_bits(resmap) >> 1;
+
+	/* Search the LRU for target to place resv in */
+
+	/*
+	 * How to search?
+	 *
+	 * By placement in LRU?
+	 *
+	 * By size?
+	 */
+
+	lru_resv = list_first_entry(&resmap->m_lru,
+				    struct ocfs2_alloc_reservation, r_lru);
+
+	/*
+	 * What do we do with the target once we've found it? Shrink?
+	 * Discard?
+	 *
+	 * Discard completely if size is less than or equal to some
+	 * threshold - say, 50% of window bits.
+	 *
+	 * Otherwise shrink in half and give right half to resv.
+	 */
+
+	mlog(0, "lru resv: start: %u len: %u end: %u\n", lru_resv->r_start,
+	     lru_resv->r_len, ocfs2_resv_end(lru_resv));
+
+	if (lru_resv->r_len <= min_bits) {
+		mlog(0, "Discard lru resv\n");
+		/*
+		 * Discard completely if size is less than or equal to some
+		 * threshold - say, 50% of window bits.
+		 */
+		resv->r_start = lru_resv->r_start;
+		resv->r_len = lru_resv->r_len;
+
+		__ocfs2_resv_discard(resmap, lru_resv);
+	} else {
+		unsigned int shrink = lru_resv->r_len / 2;
+
+		mlog(0, "shrink lru resv by %u\n", shrink);
+
+		lru_resv->r_len -= shrink;
+
+		resv->r_start = ocfs2_resv_end(lru_resv) + 1;
+		resv->r_len = shrink;
+	}
+
+	mlog(0, "Reservation now looks like: r_start: %u r_end: %u "
+	     "r_len: %u r_last_start: %u r_last_len: %u\n",
+	     resv->r_start, ocfs2_resv_end(resv), resv->r_len,
+	     resv->r_last_start, resv->r_last_len);
+
+	ocfs2_resv_insert(resmap, resv);
+}
+
+static void ocfs2_resv_find_window(struct ocfs2_reservation_map *resmap,
+				   struct ocfs2_alloc_reservation *resv,
+				   unsigned int wanted)
+{
+	unsigned int goal = 0;
+
+	BUG_ON(!ocfs2_resv_empty(resv));
+
+	/*
+	 * Begin by trying to get a window as close to the previous
+	 * one as possible. Using the most recent allocation as a
+	 * start goal makes sense.
+	 */
+	if (resv->r_last_len) {
+		goal = resv->r_last_start + resv->r_last_len;
+		if (goal >= resmap->m_bitmap_len)
+			goal = 0;
+	}
+
+	__ocfs2_resv_find_window(resmap, resv, goal, wanted);
+
+	/* Search from last alloc didn't work, try once more from beginning. */
+	if (ocfs2_resv_empty(resv) && goal != 0)
+		__ocfs2_resv_find_window(resmap, resv, 0, wanted);
+
+	if (ocfs2_resv_empty(resv)) {
+		/*
+		 * Still empty? Pull oldest one off the LRU, remove it from
+		 * tree, put this one in it's place.
+		 */
+		ocfs2_cannibalize_resv(resmap, resv, wanted);
+	}
+
+	BUG_ON(ocfs2_resv_empty(resv));
+}
+
+int ocfs2_resmap_resv_bits(struct ocfs2_reservation_map *resmap,
+			   struct ocfs2_alloc_reservation *resv,
+			   int tmpwindow, int *cstart, int *clen)
+{
+	unsigned int wanted = *clen;
+
+	if (resv == NULL || ocfs2_resmap_disabled(resmap))
+		return -ENOSPC;
+
+	spin_lock(&resv_lock);
+
+	/*
+	 * We don't want to over-allocate for temporary
+	 * windows. Otherwise, we run the risk of fragmenting the
+	 * allocation space.
+	 */
+	wanted = ocfs2_resv_window_bits(resmap);
+	if (tmpwindow || wanted < *clen)
+		wanted = *clen;
+
+	if (ocfs2_resv_empty(resv)) {
+		mlog(0, "empty reservation, find new window\n");
+
+		/*
+		 * Try to get a window here. If it works, we must fall
+		 * through and test the bitmap . This avoids some
+		 * ping-ponging of windows due to non-reserved space
+		 * being allocation before we initialize a window for
+		 * that inode.
+		 */
+		ocfs2_resv_find_window(resmap, resv, wanted);
+	}
+
+	BUG_ON(ocfs2_resv_empty(resv));
+
+	*cstart = resv->r_start;
+	*clen = resv->r_len;
+
+	spin_unlock(&resv_lock);
+	return 0;
+}
+
+static unsigned int
+	ocfs2_adjust_resv_from_alloc(struct ocfs2_reservation_map *resmap,
+				     struct ocfs2_alloc_reservation *resv,
+				     unsigned int start, unsigned int end)
+{
+	unsigned int next_inc = ocfs2_resv_end(resv) - start + 1;
+	unsigned int lhs = 0, rhs = 0;
+
+	BUG_ON(start < resv->r_start);
+
+	/*
+	 * Completely used? We can remove it then.
+	 */
+	if (ocfs2_resv_end(resv) <= end && resv->r_start >= start) {
+		__ocfs2_resv_discard(resmap, resv);
+		goto out;
+	}
+
+	if (end < ocfs2_resv_end(resv))
+		rhs = end - ocfs2_resv_end(resv);
+
+	if (start > resv->r_start)
+		lhs = start - resv->r_start;
+
+	/*
+	 * This should have been trapped above. At the very least, rhs
+	 * should be non zero.
+	 */
+	BUG_ON(rhs == 0 && lhs == 0);
+
+	if (rhs >= lhs) {
+		unsigned int old_end = ocfs2_resv_end(resv);
+
+		resv->r_start = end + 1;
+		resv->r_len = old_end - resv->r_start + 1;
+		mlog(0, "adjusted RHS\n");
+	} else {
+		resv->r_len = start - resv->r_start;
+		mlog(0, "adjusted LHS\n");
+	}
+
+out:
+
+	return next_inc;
+}
+
+void ocfs2_resmap_claimed_bits(struct ocfs2_reservation_map *resmap,
+			       struct ocfs2_alloc_reservation *resv,
+			       u32 cstart, u32 clen)
+{
+	unsigned int cend = cstart + clen - 1;
+	int search, used_resv = 0;
+
+	if (resmap == NULL || ocfs2_resmap_disabled(resmap))
+		return;
+
+	if (resv == NULL)
+		return;
+
+	spin_lock(&resv_lock);
+
+	mlog(0, "claim bits: cstart: %u cend: %u clen: %u r_start: %u "
+	     "r_end: %u r_len: %u, r_last_start: %u r_last_len: %u\n",
+	     cstart, cend, clen, resv->r_start, ocfs2_resv_end(resv),
+	     resv->r_len, resv->r_last_start, resv->r_last_len);
+
+	/*
+	 * Find all reservations which contain (cstart-clen). This
+	 * could potentially be multiple ones, depending on the
+	 * allocation.
+	 *
+	 * Each one needs to be adjusted. If the allocation overwrites
+	 * the whole window, we should just discard that reservation.
+	 *
+	 * If we hit the one passed in ('resv'), we treat it slightly
+	 * special by trying to extend it after adjustments have been
+	 * made.
+	 */
+
+	search = cstart;
+	while (search <= cend) {
+		struct ocfs2_alloc_reservation *r;
+		int inc;
+
+		/*
+		 * This will find us the leftmost resv containing any
+		 * bits between 'search' and 'cend'
+		 */
+		r = ocfs2_find_resv_containing(resmap, search, cend);
+		if (!r)
+			break;
+
+		inc = ocfs2_adjust_resv_from_alloc(resmap, r, search, cend);
+
+		/*
+		 * This will signal the next set of code that 'resv'
+		 * was used@least partially by the allocation.
+		 */
+		if (r == resv) {
+			used_resv = 1;
+			resv->r_last_start = search;
+			resv->r_last_len = inc;
+
+			/*
+			 * May have been discarded above from
+			 * ocfs2_adjust_resv_from_alloc().
+			 */
+			if (!ocfs2_resv_empty(resv))
+				ocfs2_resv_mark_lru(resmap, resv);
+		}
+
+		search += inc;
+	}
+
+	mlog(0, "Reservation now looks like: r_start: %u r_end: %u "
+	     "r_len: %u r_last_start: %u r_last_len: %u\n",
+	     resv->r_start, ocfs2_resv_end(resv), resv->r_len,
+	     resv->r_last_start, resv->r_last_len);
+
+	ocfs2_check_resmap(resmap);
+
+	spin_unlock(&resv_lock);
+}
diff --git a/fs/ocfs2/reservations.h b/fs/ocfs2/reservations.h
new file mode 100644
index 0000000..9f0fe3e
--- /dev/null
+++ b/fs/ocfs2/reservations.h
@@ -0,0 +1,159 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * reservations.h
+ *
+ * Allocation reservations function prototypes and structures.
+ *
+ * Copyright (C) 2009 Novell.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef	OCFS2_RESERVATIONS_H
+#define	OCFS2_RESERVATIONS_H
+
+#include <linux/rbtree.h>
+
+#define OCFS2_DEFAULT_RESV_LEVEL	4
+#define OCFS2_MAX_RESV_LEVEL	9
+#define OCFS2_MIN_RESV_LEVEL	0
+
+struct ocfs2_alloc_reservation {
+	struct rb_node	r_node;
+
+	unsigned int	r_start;	/* Begining of current window */
+	unsigned int	r_len;		/* Length of the window */
+
+	unsigned int	r_last_len;	/* Length of most recent alloc */
+	unsigned int	r_last_start;	/* Start of most recent alloc */
+	struct list_head	r_lru;	/* LRU list head */
+
+	int		r_inuse;	/* r_inuse is set when r_node
+					 * is part of an rbtree. */
+};
+
+struct ocfs2_reservation_map {
+	struct rb_root		m_reservations;
+	char			*m_disk_bitmap;
+
+	struct ocfs2_super	*m_osb;
+
+	/* The following are not initialized to meaningful values until a disk
+	 * bitmap is provided. */
+	u32			m_bitmap_len;	/* Number of valid
+						 * bits available */
+
+	unsigned int		m_search_start;	/* Records the end
+						 * location of our
+						 * most recent
+						 * allocation. */
+
+	struct list_head	m_lru;		/* LRU of reservations
+						 * structures. */
+
+};
+
+void ocfs2_resv_init_once(struct ocfs2_alloc_reservation *resv);
+
+/**
+ * ocfs2_resv_discard() - truncate a reservation
+ * @resmap:
+ * @resv: the reservation to truncate.
+ *
+ * After this function is called, the reservation will be empty, and
+ * unlinked from the rbtree.
+ */
+void ocfs2_resv_discard(struct ocfs2_reservation_map *resmap,
+			struct ocfs2_alloc_reservation *resv);
+
+
+/**
+ * ocfs2_resmap_init() - Initialize fields of a reservations bitmap
+ * @resmap: struct ocfs2_reservation_map to initialize
+ * @obj: unused for now
+ * @ops: unused for now
+ * @max_bitmap_bytes: Maximum size of the bitmap (typically blocksize)
+ *
+ * Only possible return value other than '0' is -ENOMEM for failure to
+ * allocation mirror bitmap.
+ */
+int ocfs2_resmap_init(struct ocfs2_super *osb,
+		      struct ocfs2_reservation_map *resmap);
+
+/**
+ * ocfs2_resmap_restart() - "restart" a reservation bitmap
+ * @resmap: reservations bitmap
+ * @clen: Number of valid bits in the bitmap
+ * @disk_bitmap: the disk bitmap this resmap should refer to.
+ *
+ * Re-initialize the parameters of a reservation bitmap. This is
+ * useful for local alloc window slides.
+ * 
+ * This function will call ocfs2_trunc_resv against all existing
+ * reservations. A future version will recalculate existing
+ * reservations based on the new bitmap.
+ */
+void ocfs2_resmap_restart(struct ocfs2_reservation_map *resmap,
+			  unsigned int clen, char *disk_bitmap);
+
+/**
+ * ocfs2_resmap_uninit() - uninitialize a reservation bitmap structure
+ * @resmap: the struct ocfs2_reservation_map to uninitialize
+ */
+void ocfs2_resmap_uninit(struct ocfs2_reservation_map *resmap);
+
+/**
+ * ocfs2_resmap_resv_bits() - Return still-valid reservation bits
+ * @resmap: reservations bitmap
+ * @resv: reservation to base search from
+ * @tempwindow: the reservation will immediately be discarded
+ * @cstart: start of proposed allocation
+ * @clen: length (in clusters) of proposed allocation
+ *
+ * Using the reservation data from resv, this function will compare
+ * resmap and resmap->m_disk_bitmap to determine what part (if any) of
+ * the reservation window is still clear to use. If resv is empty,
+ * this function will try to allocate a window for it.
+ *
+ * On success, zero is returned and the valid allocation area is set in cstart
+ * and clen.
+ *
+ * Returns -ENOSPC if reservations are disabled.
+ */
+int ocfs2_resmap_resv_bits(struct ocfs2_reservation_map *resmap,
+			   struct ocfs2_alloc_reservation *resv,
+			   int tmpwindow, int *cstart, int *clen);
+
+/**
+ * ocfs2_resmap_claimed_bits() - Tell the reservation code that bits were used.
+ * @resmap: reservations bitmap
+ * @resv: optional reservation to recalulate based on new bitmap
+ * @cstart: start of allocation in clusters
+ * @clen: end of allocation in clusters.
+ *
+ * Tell the reservation code that bits were used to fulfill allocation in
+ * resmap. The bits don't have to have been part of any existing
+ * reservation. But we must always call this function when bits are claimed.
+ * Internally, the reservations code will use this information to mark the
+ * reservations bitmap. If resv is passed, it's next allocation window will be
+ * calculated.
+ */
+void ocfs2_resmap_claimed_bits(struct ocfs2_reservation_map *resmap,
+			       struct ocfs2_alloc_reservation *resv,
+			       u32 cstart, u32 clen);
+
+#endif	/* OCFS2_RESERVATIONS_H */
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 8c9a78a..5eb7753 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -54,6 +54,8 @@ struct ocfs2_alloc_context {
 	u64    ac_last_group;
 	u64    ac_max_block;  /* Highest block number to allocate. 0 is
 				 is the same as ~0 - unlimited */
+
+	struct ocfs2_alloc_reservation	*ac_resv;
 };
 
 void ocfs2_free_alloc_context(struct ocfs2_alloc_context *ac);
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 755cd49..a6f9556 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -94,6 +94,7 @@ struct mount_options
 	unsigned int	atime_quantum;
 	signed short	slot;
 	unsigned int	localalloc_opt;
+	unsigned int	resv_level;
 	char		cluster_stack[OCFS2_STACK_LABEL_LEN + 1];
 };
 
@@ -175,6 +176,7 @@ enum {
 	Opt_noacl,
 	Opt_usrquota,
 	Opt_grpquota,
+	Opt_resv_level,
 	Opt_err,
 };
 
@@ -201,6 +203,7 @@ static const match_table_t tokens = {
 	{Opt_noacl, "noacl"},
 	{Opt_usrquota, "usrquota"},
 	{Opt_grpquota, "grpquota"},
+	{Opt_resv_level, "resv_level=%u"},
 	{Opt_err, NULL}
 };
 
@@ -1026,6 +1029,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	osb->osb_commit_interval = parsed_options.commit_interval;
 	osb->local_alloc_default_bits = ocfs2_megabytes_to_clusters(sb, parsed_options.localalloc_opt);
 	osb->local_alloc_bits = osb->local_alloc_default_bits;
+	osb->osb_resv_level = parsed_options.resv_level;
 
 	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
 	if (status)
@@ -1286,6 +1290,7 @@ static int ocfs2_parse_options(struct super_block *sb,
 	mopt->slot = OCFS2_INVALID_SLOT;
 	mopt->localalloc_opt = OCFS2_DEFAULT_LOCAL_ALLOC_SIZE;
 	mopt->cluster_stack[0] = '\0';
+	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
 
 	if (!options) {
 		status = 1;
@@ -1429,6 +1434,17 @@ static int ocfs2_parse_options(struct super_block *sb,
 			mopt->mount_opt |= OCFS2_MOUNT_NO_POSIX_ACL;
 			mopt->mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
 			break;
+		case Opt_resv_level:
+			if (is_remount)
+				break;
+			if (match_int(&args[0], &option)) {
+				status = 0;
+				goto bail;
+			}
+			if (option >= OCFS2_MIN_RESV_LEVEL &&
+			    option < OCFS2_MAX_RESV_LEVEL)
+				mopt->resv_level = option;
+			break;
 		default:
 			mlog(ML_ERROR,
 			     "Unrecognized mount option \"%s\" "
@@ -1510,6 +1526,9 @@ static int ocfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 	else
 		seq_printf(s, ",noacl");
 
+	if (osb->osb_resv_level != OCFS2_DEFAULT_RESV_LEVEL)
+		seq_printf(s, ",resv_level=%d", osb->osb_resv_level);
+
 	return 0;
 }
 
@@ -2038,6 +2057,12 @@ static int ocfs2_initialize_super(struct super_block *sb,
 
 	init_waitqueue_head(&osb->osb_mount_event);
 
+	status = ocfs2_resmap_init(osb, &osb->osb_la_resmap);
+	if (status) {
+		mlog_errno(status);
+		goto bail;
+	}
+
 	osb->vol_label = kmalloc(OCFS2_MAX_VOL_LABEL_LEN, GFP_KERNEL);
 	if (!osb->vol_label) {
 		mlog(ML_ERROR, "unable to alloc vol label\n");
-- 
1.6.4.2
