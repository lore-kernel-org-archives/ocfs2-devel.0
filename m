Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E243A3BD22F
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Aug 2026 11:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787743627; cv=none; b=OapULtJSOWITZcnWtuOmU1aEcYlJiuLz6wWBLz2jXKZLxI3uVKfTZlK/8QWLAGgV0KQ4T4vN5EHNUktqwHBa+3AAk4D1hHbhlFSV5C5lVsvEtn4po2tHLjrwwR+99OkPBfbV9WxYhRyjgk4+LNd6sByygzEloH7Pmlh74ViQ3Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787743627; c=relaxed/simple;
	bh=s1bpfHAoV4q7svo1G8Dub+T+J3GSTFYM9W7lcFnT7f8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y/uxCJ3n9JZqAX7fGrf/HZOjY3VMW3ZzzOML08+P4n59knkDyt1fD6i1DdJt6olxUsOuXwnRS4OPtYD1glLVcGrJtU/Ic1YICoPqNgiKWANPTnTLnAHEkmhkNU4VGx8d9cQ1LiqPYYg1CcD1Ww4LTLCxaO4IGXcmqvhWJd/rSiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZGtNPNb+; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZGtNPNb+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787743621; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Bg0aphhePImq/b57myxGee9of8t2ClKfW3QiHxc+y7E=;
	b=ZGtNPNb+deKuckISNb7wL8labl6XZXWRmtQYR/IlpXkdYG22zGedKhgCrGAqqhuujbaAZ65W10tGjr1HVbmJXjtL5reKnd0hJcyeEm6ggTP6J4fak2VmHqLJwTYLILyH05mvtkUOMovqiQ5g6ADY9zZWKiX836SkRKj+nQR5vyI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X9gmVso_1787743619;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X9gmVso_1787743619 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 26 Aug 2026 19:27:00 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] ocfs2: fix deadlock in inline-data truncate transactions
Date: Wed, 26 Aug 2026 19:26:59 +0800
Message-Id: <20260826112659.246574-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updating an inode xattr can cause an ABBA deadlock with inline file
truncation:

  ocfs2_truncate_file()
    down_write(&oi->ip_alloc_sem)
    ocfs2_truncate_inline()
      ocfs2_start_trans()

  ocfs2_xattr_set()
    ocfs2_start_trans()
    ocfs2_xattr_ibody_set()
      down_write(&oi->ip_alloc_sem)

The xattr set path starts the merged transaction before the
inode-body xattr helper acquires ip_alloc_sem, reversing the
ip_alloc_sem -> transaction order used by the allocation and truncate
paths.  The transaction merge in commit 85db90e77806 ("ocfs2/xattr:
Merge xattr set transaction.") introduced this ordering.

Fix it by acquiring ip_alloc_sem once in ocfs2_xattr_set(), before
xattr preparation, allocation reservations and ocfs2_start_trans(),
and removing the per-helper acquisition from ocfs2_xattr_ibody_find(),
ocfs2_xattr_ibody_set() and ocfs2_xattr_create_index_block().  These
helpers now assert via lockdep that the caller holds ip_alloc_sem.

ocfs2_xattr_set_handle(), which only sets initial ACL or security
xattrs on unpublished inodes inside the create transaction, takes
ip_alloc_sem under a dedicated lockdep subclass so that the assertions
hold without creating a transaction -> ip_alloc_sem cycle against the
ip_alloc_sem -> transaction order.  The inode is unpublished, so the
acquisition can never contend.

This keeps the established ip_alloc_sem -> transaction order and makes
the locking unconditional, so lockdep can verify a single plain
ordering instead of conditional acquisitions.

Fixes: 85db90e77806 ("ocfs2/xattr: Merge xattr set transaction.")
Cc: ZhengYuan Huang <gality369@gmail.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 79 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 53 insertions(+), 26 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index e955126e4d7d..143d6f75f9c9 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2941,6 +2941,9 @@ static int ocfs2_xattr_has_space_inline(struct inode *inode,
  *
  * Find extended attribute in inode block and
  * fill search info into struct ocfs2_xattr_search.
+ *
+ * The inline free-space check races with truncate and allocation, so
+ * callers must hold ip_alloc_sem for writing.
  */
 static int ocfs2_xattr_ibody_find(struct inode *inode,
 				  int name_index,
@@ -2952,13 +2955,13 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
 	int ret;
 	int has_space = 0;
 
+	lockdep_assert_held_write(&oi->ip_alloc_sem);
+
 	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
 		return 0;
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
-		down_read(&oi->ip_alloc_sem);
 		has_space = ocfs2_xattr_has_space_inline(inode, di);
-		up_read(&oi->ip_alloc_sem);
 		if (!has_space)
 			return 0;
 	}
@@ -3039,6 +3042,7 @@ static int ocfs2_xattr_ibody_init(struct inode *inode,
  *
  * Set, replace or remove an extended attribute into inode block.
  *
+ * Callers must hold ip_alloc_sem for writing.
  */
 static int ocfs2_xattr_ibody_set(struct inode *inode,
 				 struct ocfs2_xattr_info *xi,
@@ -3049,16 +3053,17 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_xa_loc loc;
 
+	lockdep_assert_held_write(&oi->ip_alloc_sem);
+
 	if (inode->i_sb->s_blocksize == OCFS2_MIN_BLOCKSIZE)
 		return -ENOSPC;
 
-	down_write(&oi->ip_alloc_sem);
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)) {
 		ret = ocfs2_xattr_ibody_init(inode, xs->inode_bh, ctxt);
 		if (ret) {
 			if (ret != -ENOSPC)
 				mlog_errno(ret);
-			goto out;
+			return ret;
 		}
 	}
 
@@ -3068,13 +3073,10 @@ static int ocfs2_xattr_ibody_set(struct inode *inode,
 	if (ret) {
 		if (ret != -ENOSPC)
 			mlog_errno(ret);
-		goto out;
+		return ret;
 	}
 	xs->here = loc.xl_entry;
 
-out:
-	up_write(&oi->ip_alloc_sem);
-
 	return ret;
 }
 
@@ -3718,6 +3720,18 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
 	return ret;
 }
 
+/*
+ * ip_alloc_sem subclass for inodes being initialized before publication.
+ * ocfs2_xattr_set_handle() runs inside the create transaction, so taking
+ * ip_alloc_sem there adds a transaction -> ip_alloc_sem order that would
+ * form a lockdep cycle with the ip_alloc_sem -> transaction order used
+ * elsewhere, if not for this separate subclass.  The inode is unpublished
+ * so the acquisition can never contend.
+ */
+enum {
+	OCFS2_IP_ALLOC_SEM_UNPUBLISHED = 1,
+};
+
 /*
  * This helper is only for setting initial ACL or security xattrs on an inode
  * that is still unpublished, unhashed, and unattached to a dentry.
@@ -3779,6 +3793,13 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 	xis.inode_bh = xbs.inode_bh = di_bh;
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
+	/*
+	 * The inode is unpublished and cannot contend, but take the
+	 * semaphore anyway so the helpers' lockdep assertions hold.
+	 */
+	down_write_nested(&OCFS2_I(inode)->ip_alloc_sem,
+			  OCFS2_IP_ALLOC_SEM_UNPUBLISHED);
+
 	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
 	if (ret)
 		goto cleanup;
@@ -3791,6 +3812,7 @@ int ocfs2_xattr_set_handle(handle_t *handle,
 	ret = __ocfs2_xattr_set_handle(inode, di, &xi, &xis, &xbs, &ctxt);
 
 cleanup:
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	brelse(xbs.xattr_bh);
 	ocfs2_xattr_bucket_free(xbs.bucket);
 
@@ -3859,30 +3881,38 @@ int ocfs2_xattr_set(struct inode *inode,
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	down_write(&OCFS2_I(inode)->ip_xattr_sem);
+	/*
+	 * The allocation and truncate paths take ip_alloc_sem before
+	 * starting a transaction, so take it here before xattr
+	 * preparation, allocation reservations and ocfs2_start_trans()
+	 * to keep that order.  The xattr helpers below no longer take
+	 * it themselves.
+	 */
+	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 	/*
 	 * Scan inode and external block to find the same name
 	 * extended attribute and collect search information.
 	 */
 	ret = ocfs2_xattr_ibody_find(inode, name_index, name, &xis);
 	if (ret)
-		goto cleanup;
+		goto out_free_ac;
 	if (xis.not_found) {
 		ret = ocfs2_xattr_block_find(inode, name_index, name, &xbs);
 		if (ret)
-			goto cleanup;
+			goto out_free_ac;
 	}
 
 	if (xis.not_found && xbs.not_found) {
 		ret = -ENODATA;
 		if (flags & XATTR_REPLACE)
-			goto cleanup;
+			goto out_free_ac;
 		ret = 0;
 		if (!value)
-			goto cleanup;
+			goto out_free_ac;
 	} else {
 		ret = -EEXIST;
 		if (flags & XATTR_CREATE)
-			goto cleanup;
+			goto out_free_ac;
 	}
 
 	/* Check whether the value is refcounted and do some preparation. */
@@ -3893,7 +3923,7 @@ int ocfs2_xattr_set(struct inode *inode,
 						   &ref_meta, &ref_credits);
 		if (ret) {
 			mlog_errno(ret);
-			goto cleanup;
+			goto out_free_ac;
 		}
 	}
 
@@ -3904,7 +3934,7 @@ int ocfs2_xattr_set(struct inode *inode,
 		if (ret < 0) {
 			inode_unlock(tl_inode);
 			mlog_errno(ret);
-			goto cleanup;
+			goto out_free_ac;
 		}
 	}
 	inode_unlock(tl_inode);
@@ -3913,7 +3943,7 @@ int ocfs2_xattr_set(struct inode *inode,
 					&xbs, &ctxt, ref_meta, &credits);
 	if (ret) {
 		mlog_errno(ret);
-		goto cleanup;
+		goto out_free_ac;
 	}
 
 	/* we need to update inode's ctime field, so add credit for it. */
@@ -3931,6 +3961,7 @@ int ocfs2_xattr_set(struct inode *inode,
 	ocfs2_commit_trans(osb, ctxt.handle);
 
 out_free_ac:
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	if (ctxt.data_ac)
 		ocfs2_free_alloc_context(ctxt.data_ac);
 	if (ctxt.meta_ac)
@@ -3939,7 +3970,6 @@ int ocfs2_xattr_set(struct inode *inode,
 		ocfs2_schedule_truncate_log_flush(osb, 1);
 	ocfs2_run_deallocs(osb, &ctxt.dealloc);
 
-cleanup:
 	if (ref_tree)
 		ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
@@ -4544,6 +4574,10 @@ static void ocfs2_xattr_update_xattr_search(struct inode *inode,
 	xs->here = &xs->header->xh_entries[i];
 }
 
+/*
+ * Caller must hold ip_alloc_sem for writing, since a new xattr block
+ * is allocated and the xattr block header is rewritten.
+ */
 static int ocfs2_xattr_create_index_block(struct inode *inode,
 					  struct ocfs2_xattr_search *xs,
 					  struct ocfs2_xattr_set_ctxt *ctxt)
@@ -4559,19 +4593,14 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	struct ocfs2_xattr_tree_root *xr;
 	u16 xb_flags = le16_to_cpu(xb->xb_flags);
 
+	lockdep_assert_held_write(&oi->ip_alloc_sem);
+
 	trace_ocfs2_xattr_create_index_block_begin(
 				(unsigned long long)xb_bh->b_blocknr);
 
 	BUG_ON(xb_flags & OCFS2_XATTR_INDEXED);
 	BUG_ON(!xs->bucket);
 
-	/*
-	 * XXX:
-	 * We can use this lock for now, and maybe move to a dedicated mutex
-	 * if performance becomes a problem later.
-	 */
-	down_write(&oi->ip_alloc_sem);
-
 	ret = ocfs2_journal_access_xb(handle, INODE_CACHE(inode), xb_bh,
 				      OCFS2_JOURNAL_ACCESS_WRITE);
 	if (ret) {
@@ -4633,8 +4662,6 @@ static int ocfs2_xattr_create_index_block(struct inode *inode,
 	ocfs2_journal_dirty(handle, xb_bh);
 
 out:
-	up_write(&oi->ip_alloc_sem);
-
 	return ret;
 }
 
-- 
2.39.3

