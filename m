Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66BD374E5B
	for <ocfs2-devel@lists.linux.dev>; Mon, 27 Jul 2026 06:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785133101; cv=none; b=G2dd4DH1399wvPLf8leqG6VXLnZC3pFRhce4UXHBix5ESPYGJ31c9MagvLq2rTyC9m860aivNYdEIfiNgAubpMRqu3M8m3gfdQ2d7PfCGt+x4d62B8vZmGZoZeempZbSgQovyFGdOPvjxFGIPmrF5CqRKKUGTiASSUxGFGQ6Zl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785133101; c=relaxed/simple;
	bh=Nom/uJlB5mS32zLlSCGx+3XZweqwJfdcl2EJOkURqCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dfx98cc7tRRZVLWFTRh88wLpVn98q7U/nUxPG4uXJGgVSuf5+IDly6SOk2dM6rUpRqEzzmP6iBiRwb8iJJ3JTuWU482QltbTixJqWoTcIFyVa9f/jJz1jX/S/kK5ysYoVdk8qnL5WVxQlMzvktQkN2L+zRY/oycRY7QmqbzCAPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RWKsvPN3; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RWKsvPN3"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-69fe1df830fso183059a12.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 26 Jul 2026 23:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785133098; x=1785737898; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pn8R1NWzCGlmgtBf8lR7KtIs+B4L1O9UT3Ln46xCebI=;
        b=RWKsvPN3U35jK/TK3aSSvU4vw2nFk1429Sjn3MWJRSPutHMGJGWfbh+bzH7TP/oWEO
         fWgXVQ8PYTo+Vp/okZ42T6ON9ik6Zz6sfeuFKVntOWgSx9ibanNotX6Ew0TLm7Ew7eJW
         ob77XiBvnACzre2cvL5DSgTfwd90wdJ6m+mp0Q81eRVoLT//hcGf1zKEzCcFEq5nd+X0
         gfbV4woRHAFX8sLsZ3idqqWmNj7nO7ODousMyC5xwqJ/rn7TSx/jhtgOLIwnIYj6naZX
         Hl8FdSSOZDMS8sktQc1/yK3br2cmGDaJyC0a32mUHyGvPHxlyyoyEpkXp2G63VHufQ3n
         fRMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785133098; x=1785737898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Pn8R1NWzCGlmgtBf8lR7KtIs+B4L1O9UT3Ln46xCebI=;
        b=b9NZNIjKbM2UP0ODbxh+YILO2j43ZK9a10ddOYEbklfY1CVXB2yBnorGqBOT/kNTT/
         RBta7JrVoW3NzKUGEBpWPcb/ZpSKZ+LHocxFMrdituhWS1pPqe0Vi1wjlFYunhmT8FIr
         DYm+W6R0WBtKsgd112eDvxRFtBlyGJQ9eCsHw1MxtZCUfp1zZPYjrKk+RcZ4ohdOaoX4
         NTWRkyUBkp8o1JGsCdeVOdQU8esEzZiC9h3N4QNbyqQeECX2zvCCzJzWCS0Byg/eqAEQ
         CLKcEprgl9QaJ717wyblD7alMFS0LwpbKd31nBZ2xA5nkeYF5XI7sxHdQEQyi0i9+rOB
         AKIw==
X-Forwarded-Encrypted: i=1; AHgh+RoTYTkcHehnamr1lzVXdO3hUWTFQcC9348VavymYYXtGkIvPLhp3vHs9NSsJTnH8mTTlK5Ft0qtH4+1RQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx923b/WhFaH0teBEH58qIaQ4bsAmEuKjH9gUuDGWQNzyB6/dTR
	xpkxjtXclZldCATTgAQpvBYW4rMypFo4hA7Mqi0x1Y5Z32Zxv3QOT/t+wq0zqG9c7cM=
X-Gm-Gg: AR+sD13aVU3H6UzNjxtq4SAE5T7wyCmvrtHxVpZMx3uvDFoCdwzCuaCmKMHMopbgbae
	jTyXNuXU5nff7pMIiEfBUUIWSSgV4d7mUjFWF96nNOEh88h60bMtaVzhq3kBB8hp8LEzbZ2jas8
	9ehOvmr68W3rjvuJ+WWlwaDJ2tAkEL7eBP2YEFZdjkPucOkKKUxpAmIt2DnlJUNmOOHTjx9AjKK
	dtT7kalhMeh0QxySHbRv5s6MiG7FSvJ/MFxZk/JH0MLHcXe0RmIQw5+Cchk/0G6W9aRhyZVtk6o
	c4456sHbsk1173BVTJ3wqQNJoVjoBYNKUkS7xmgvdWdT7m2aesZT5Pbko7moflS+LTCSfXY7nZJ
	KUD79sVs5/lPLObqH+jXaADUQRbkcOQTGotIUJnI4cMkE2zZGFR3d9AwwCJQmZIadEKJxb8n9d8
	cL1fk=
X-Received: by 2002:a05:6402:321b:b0:697:f628:e20e with SMTP id 4fb4d7f45d1cf-69fc115d52cmr1697510a12.4.1785133098049;
        Sun, 26 Jul 2026 23:18:18 -0700 (PDT)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f2951f0afsm2583300a91.16.2026.07.26.23.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 23:18:16 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 2/4] ocfs2: switch dio read path from buffer_head to iomap
Date: Mon, 27 Jul 2026 14:17:58 +0800
Message-ID: <20260727061802.18485-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727061802.18485-1-heming.zhao@suse.com>
References: <20260727061802.18485-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch migrates the DIO read path from the legacy buffer_head
infrastructure to the modern and more efficient iomap framework.

The rw cluster-lock level is not stashed in iocb->private: iomap DIO owns
that field (it stores a bio there for polled I/O and unconditionally
clears it before calling ->end_io), so any side-channel packed into
iocb->private is corrupted and would trip the end_io lock-state check.
Instead the unlock level is encoded by which iomap_dio_ops is passed -
ocfs2_iomap_dio_ops_pr (PRMODE) or ocfs2_iomap_dio_ops_ex (EXMODE) - and
the *_iter() functions use the split __iomap_dio_rw() + iomap_dio_complete()
API so they can determine unambiguously, from the return value, whether the
completion handler already dropped the lock (real I/O, sync or -EIOCBQUEUED)
or whether the caller must drop it (no I/O issued, or buffered fallback).

Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/Kconfig    |   1 +
 fs/ocfs2/aops.c     | 113 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/file.c     |  57 ++++++++++++++++++----
 fs/ocfs2/ocfs2.h    |   3 ++
 fs/ocfs2/ocfs2_fs.h |   3 ++
 5 files changed, 167 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index 2514d36cbe01..bf1678a5eb01 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -7,6 +7,7 @@ config OCFS2_FS
 	select CRC32
 	select QUOTA
 	select QUOTA_TREE
+	select FS_IOMAP
 	select FS_POSIX_ACL
 	select LEGACY_DIRECT_IO
 	help
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 08df5e3b5196..12f5f2e3530a 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
@@ -2556,6 +2557,118 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 				    ocfs2_dio_end_io, 0);
 }
 
+static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+{
+	int ret;
+	struct ocfs2_map_block map;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	u8 blkbits = inode->i_blkbits;
+
+	if ((offset >> blkbits) > OCFS2_MAX_LOGICAL_BLOCK)
+		return -EINVAL;
+
+	/*
+	 * Calculate the first and last logical blocks respectively.
+	 */
+	map.lblk = offset >> blkbits;
+	map.len = min_t(loff_t, (offset + length - 1) >> blkbits,
+			OCFS2_MAX_LOGICAL_BLOCK) - map.lblk + 1;
+	map.flags = 0;
+
+	if (flags & IOMAP_WRITE) {
+		/* todo */
+	} else {
+		down_read(&oi->ip_alloc_sem);
+		ret = ocfs2_map_blocks(inode, &map, 0);
+		up_read(&oi->ip_alloc_sem);
+	}
+
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Before returning to iomap, let's ensure the allocated mapping
+	 * covers the entire requested length for atomic writes.
+	 */
+	if (flags & IOMAP_ATOMIC) {
+		if (map.len < (length >> blkbits)) {
+			WARN_ON_ONCE(1);
+			return -EINVAL;
+		}
+	}
+
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = (u64)map.lblk << blkbits;
+	iomap->length = (u64)map.len << blkbits;
+
+	if (map.pblk == 0) {
+		iomap->type = IOMAP_HOLE;
+		iomap->addr = IOMAP_NULL_ADDR;
+	} else {
+		if (map.flags & OCFS2_MAP_UNWRITTEN) {
+			iomap->type = IOMAP_UNWRITTEN;
+		} else if (map.flags & OCFS2_MAP_MAPPED) {
+			iomap->type = IOMAP_MAPPED;
+		} else {
+			WARN_ON_ONCE(1);
+			return -EIO;
+		}
+		iomap->addr = (sector_t)map.pblk << blkbits;
+	}
+
+	if (map.flags & OCFS2_MAP_NEW)
+		iomap->flags |= IOMAP_F_NEW;
+
+	return 0;
+}
+
+const struct iomap_ops ocfs2_iomap_ops = {
+	.iomap_begin	= ocfs2_iomap_begin,
+};
+
+/*
+ * Direct I/O completion. Like the old ocfs2_dio_end_io(), we use the rw_lock
+ * DLM lock to protect io on one node from truncation on another, and drop it
+ * here once the io has completed. iomap_dio_complete() always calls this,
+ * including on the buffered-fallback (-ENOTBLK) path, so the rw_lock taken in
+ * ocfs2_file_{read,write}_iter() is released exactly once.
+ */
+static int ocfs2_iomap_dio_end_io(struct kiocb *iocb, ssize_t size, int error,
+				  int level)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	/*
+	 * iomap_dio_complete() calls us even when no I/O was issued because the
+	 * mapping bounced us back to buffered I/O (reported as size == 0 and
+	 * error == 0). In that case leave the rw_lock held so
+	 * ocfs2_file_{read,write}_iter() keeps it for the buffered retry and
+	 * releases it in its own cleanup path.
+	 */
+	if (size == 0 && error == 0)
+		return 0;
+
+	ocfs2_rw_unlock(inode, level);
+	return error;
+}
+
+static int ocfs2_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
+				int error, unsigned int flags)
+{
+	if (error)
+		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
+				 (long long)size, error);
+
+	error = ocfs2_iomap_dio_end_io(iocb, size, error, 0);
+
+bail:
+	return error;
+}
+
+const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr = {
+	.end_io = ocfs2_dio_end_io_r_pr,
+};
 const struct address_space_operations ocfs2_aops = {
 	.dirty_folio		= block_dirty_folio,
 	.read_folio		= ocfs2_read_folio,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d6e977ba6565..a0b3883216bc 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -9,6 +9,7 @@
 
 #include <linux/capability.h>
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -2374,6 +2375,19 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 	return ret;
 }
 
+static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
+				struct inode *inode)
+{
+	/*
+	 * Fallback to buffered I/O if we see an inode without
+	 * extents.
+	 */
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return false;
+
+	return true;
+}
+
 static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 				    struct iov_iter *from)
 {
@@ -2548,7 +2562,6 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 			filp->f_path.dentry->d_name.name,
 			to->nr_segs);	/* GRRRRR */
 
-
 	if (!inode) {
 		ret = -EINVAL;
 		mlog_errno(ret);
@@ -2558,7 +2571,8 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	if (!direct_io && nowait)
 		return -EOPNOTSUPP;
 
-	ocfs2_iocb_init_rw_locked(iocb);
+	if (!iov_iter_count(to))
+		return 0; /* skip atime */
 
 	/*
 	 * buffered reads protect themselves in ->read_folio().  O_DIRECT reads
@@ -2576,8 +2590,6 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 			goto bail;
 		}
 		rw_level = 0;
-		/* communicate with ocfs2_dio_end_io */
-		ocfs2_iocb_set_rw_locked(iocb, rw_level);
 	}
 
 	/*
@@ -2598,17 +2610,42 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	}
 	ocfs2_inode_unlock(inode, lock_level);
 
-	ret = generic_file_read_iter(iocb, to);
+	if (direct_io && ocfs2_should_use_dio(iocb, to, inode)) {
+		struct iomap_dio *dio;
+
+		dio = __iomap_dio_rw(iocb, to, &ocfs2_iomap_ops,
+				&ocfs2_iomap_dio_ops_r_pr, 0, NULL, 0);
+		if (dio == NULL) {
+			/* No I/O issued; rw_lock still held. */
+			ret = 0;
+		} else if (IS_ERR(dio)) {
+			ret = PTR_ERR(dio);
+			if (ret == -EIOCBQUEUED)
+				rw_level = -1;
+		} else {
+			ret = iomap_dio_complete(dio);
+			if (ret != 0)
+				rw_level = -1;
+		}
+		/*
+		 * A 0 result means the mapping bounced us back to buffered I/O
+		 * (e.g. inline data); the rw_lock is still held. Clear
+		 * IOCB_DIRECT so generic_file_read_iter() takes the buffered
+		 * path rather than re-entering direct I/O.
+		 */
+		if (ret == 0) {
+			iocb->ki_flags &= ~IOCB_DIRECT;
+			ret = generic_file_read_iter(iocb, to);
+		}
+	} else {
+		iocb->ki_flags &= ~IOCB_DIRECT;
+		ret = generic_file_read_iter(iocb, to);
+	}
 	trace_generic_file_read_iter_ret(ret);
 
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !direct_io);
 
-	/* see ocfs2_file_write_iter */
-	if (ret == -EIOCBQUEUED || !ocfs2_iocb_is_rw_locked(iocb)) {
-		rw_level = -1;
-	}
-
 bail:
 	if (rw_level != -1)
 		ocfs2_rw_unlock(inode, rw_level);
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 095f7ae5dded..a775c1869293 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -549,6 +549,9 @@ struct ocfs2_map_block {
 	unsigned int flags;
 };
 
+extern const struct iomap_ops ocfs2_iomap_ops;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
+
 /* Flags used by ocfs2_map_blocks() */
 #define OCFS2_GET_BLOCKS_CREATE	(0x0001)
 
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c501eb3cdcda..000bd014acbd 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -314,6 +314,9 @@
  */
 #define OCFS2_CLUSTER_O2CB_GLOBAL_HEARTBEAT	(0x01)
 
+/* Max logical block we can support */
+#define OCFS2_MAX_LOGICAL_BLOCK	(0xFFFFFFFE)
+
 struct ocfs2_system_inode_info {
 	char	*si_name;
 	int	si_iflags;
-- 
2.54.0

