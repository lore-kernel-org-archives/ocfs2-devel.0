Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A065C377A99
	for <ocfs2-devel@lists.linux.dev>; Fri, 24 Jul 2026 05:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784870788; cv=none; b=FOYoddHCI2GsG0ZgQ0/zhNXBTLdUbgs32UgCuwZ++TwZuHOSmzm97AWDwU8IKAZPt2n6IvRJJKjYwUll8ki0a/+BeSdEn/Uyn1j/5OQMyJxRmILblpI3vfzVdWlk2NdoQYfDfHPU/t/j7wyV+6nmof2JMEzV/PZlHxj7af/YPQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784870788; c=relaxed/simple;
	bh=yjb7uNeu9nk0CCHhWm8CBHiMC90e7KWwlWhJhM5vdKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YasyixDNMu4+mSyjrN5Xcx8wPkOilIMPMaGeTxrGl4YvPrhZk8Bwl0uqTjMZzf6+YIBUbvgvc32GmvtV3wdESqgxrGBO8UQw9hFqrAzY3EHHmF3N7qGPCk8Gc4nHg041tO7Hc3KfFw2gBazsyMnCry+xXLA+MZbjUujyQNCnOLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d9xnZCHl; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d9xnZCHl"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c160875e029so327566b.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Jul 2026 22:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784870781; x=1785475581; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4m6NM9wCOH7d51FTZtl6TONkYtjIEhm3jkykjODihBs=;
        b=d9xnZCHlEIosYzrQRAxsfWcvmmiV24odKclLHMsz0qrSC6aJ3m1s/nhLyi46gaAKrf
         Hxkcqh//+G3wBtLdmvbDp2Ji6ugpdoBCPbtT9z0yF7fI8jaSm/mt4qYmHxrqiDcDeAbb
         VQHBJbkMYeBiDLc4cmxDzSGIGeW0BqrUovJPhQ+JdRDWRxDhMyGMj7tAzV+LZrCpJdKv
         mmYT1U+xA02R9Z3jVyh3+HY9cWq7iHG5VPR5Jm0LR74UmwJCBLLAaYimw+GrejxcZzBk
         cOaD0FacSJkH/MXzVBJnlvqqpJBuzdoxh2gJ1xQ7JMRx2mKyqNzfAyfJJ8mn0pWot4Bz
         xJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784870781; x=1785475581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4m6NM9wCOH7d51FTZtl6TONkYtjIEhm3jkykjODihBs=;
        b=NppfwXbp0QTQ3J7Lu7kOCmk9AzOQ+NnzSN81LLy4V+RJ+Bo+sCX8d/T7gl8izqm7Gz
         TaQDuXdXh46WBK1ktlUOdgphA2eNrmiTnD+qFF9nVvAHXdeIj1xnzT8gYQPOmJw4Swlk
         YrcNawKxUD25UlJ5Lboe+S5d84j1IF5UaB1mD3rXRa7FR7XD36KlP+3OgxDVBLvONM+R
         ohucueYcMk/2QKwDQwPmdi2UdyeyZS8wjrxoeXvp6UX7u/qf4JNhi/Ij814S+7Ez43p4
         W3f7mQ4owY8s6a3/Yu+eE161rs74ZknItEQcOjLYPvxz2TLVaOzjQn1t4ccK/0D2R92z
         n4Nw==
X-Forwarded-Encrypted: i=1; AHgh+RpXZHQv1JSv7ZUl88XpHzqHsFYFyBp8I/EyefG+jLqaWfqKJAXMWSutWQgIouPLWo5ayquv+VsB9puXnA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxE9jYh0XxZrzFHfcS0haAWRwzRw6epqh8oVtMsev6v/S9Dd+2w
	xzwNJab11jSocPYTGK2hj6XHwNR+pPgQXOrJ0Rb5HlRJi4NtUhXMe2L2hUgQrd7WrYE=
X-Gm-Gg: AR+sD11Qq4EeEIZvkiWtErLoqe+rkwUjlQgNgar7miXg7LEf0RB45I+R1cM/CfT5a+H
	0RujsrQb83ln6DHOrP/VgSHE1eRHP8/UOFntBY6h9K23+w73Jx8M1SbHyJd0vu559Tyz3kDMBk1
	78AsFpGvufkPGjvBsYBaDKYx8KyMJAhuE2wmYGwLu0V1ZKwgRG//l4+E9EOKlt1SUg+ZPQj/sg4
	dTMJDfntdQ9IVZiOvpG2xEa/vBZ+xJEwVta8JVcdqDouHX/VxavV1ll/sp/l69/qHNnf6UCxddQ
	YxfGU5+yIlKqd3x3kGVCrh0J1pLlyjpm2WnT5BbGSD3X6mOlsBR9FXjZivMnWVP1boyZu81HFyC
	wbJA6D15yr/QEB2GvEqhKjKxHAIOWOf0iScvhnQizKu0rf8jX+eEt79C5U/330iPOBOTKPrsiu6
	yNje0=
X-Received: by 2002:a05:6402:3222:b0:698:87ac:33a0 with SMTP id 4fb4d7f45d1cf-69f6a73aa84mr1591005a12.3.1784870780872;
        Thu, 23 Jul 2026 22:26:20 -0700 (PDT)
Received: from p15.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f039b1ce3sm898577a91.4.2026.07.23.22.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 22:26:19 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/3] ocfs2: switch dio read path from buffer_head to iomap
Date: Fri, 24 Jul 2026 13:25:56 +0800
Message-ID: <20260724052559.15409-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724052559.15409-1-heming.zhao@suse.com>
References: <20260724052559.15409-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch migrates the DIO read path from the legacy buffer_head
infrastructure to the modern and more efficient iomap framework.

One thing need to care: The generic iomap layer clears
`iocb->private` during its internal execution. To preserve the OCFS2
rw lock state across the DIO lifecycle, we leverage the top 2 bits
of `iocb->ki_flags` (`IOCB_OCFS2_RW_LOCK` and `IOCB_OCFS2_RW_LOCK_LEVEL`)
to safely carry the lock state into the `end_io` callback.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/Kconfig    |   1 +
 fs/ocfs2/aops.c     | 101 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/aops.h     |  24 +++++++++++
 fs/ocfs2/file.c     |  53 ++++++++++++++++++++---
 fs/ocfs2/ocfs2.h    |   3 ++
 fs/ocfs2/ocfs2_fs.h |   3 ++
 6 files changed, 179 insertions(+), 6 deletions(-)

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
index 08df5e3b5196..59d445dd61f6 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
@@ -2556,6 +2557,106 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
+	/* may use ocfs2_set_iomap() to replace all blow code */
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
+static int ocfs2_dio_read_end_io(struct kiocb *iocb, ssize_t size, int error,
+		unsigned int flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	int level;
+
+	if (error) {
+		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
+				 (long long)size, error);
+		goto bail;
+	}
+
+	BUG_ON(!ocfs2_iomap_iocb_is_rw_locked(iocb));
+
+	level = ocfs2_iomap_iocb_rw_locked_level(iocb);
+
+	/* sync dio unlock job done in .read_iter or .write_iter */
+	if (ocfs2_iomap_iocb_is_rw_locked(iocb))
+		ocfs2_rw_unlock(inode, level);
+
+	ocfs2_iocb_clear_rw_locked(iocb);
+	ocfs2_iomap_iocb_clear_rw_locked(iocb);
+bail:
+	return error;
+}
+
+const struct iomap_dio_ops ocfs2_dio_r_ops = {
+	.end_io = ocfs2_dio_read_end_io,
+};
 const struct address_space_operations ocfs2_aops = {
 	.dirty_folio		= block_dirty_folio,
 	.read_folio		= ocfs2_read_folio,
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 8dd6edd7c1a1..5966fa725135 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -74,4 +74,28 @@ enum ocfs2_iocb_lock_bits {
 #define ocfs2_iocb_rw_locked_level(iocb) \
 	test_bit(OCFS2_IOCB_RW_LOCK_LEVEL, (unsigned long *)&iocb->private)
 
+/*
+ * Since iomap clear iocb->private in some cases, we use iocb->ki_flags
+ * top 2-bit to store the rw lock state. Hope ki_flags never touch these 2-bit.
+ */
+#define IOCB_OCFS2_RW_LOCK		(1 << 30)
+#define IOCB_OCFS2_RW_LOCK_LEVEL	(1 << 31)
+static inline void ocfs2_iomap_iocb_set_rw_locked(struct kiocb *iocb, int level)
+{
+	iocb->ki_flags |= IOCB_OCFS2_RW_LOCK;
+	if (level)
+		iocb->ki_flags |= IOCB_OCFS2_RW_LOCK_LEVEL;
+	else
+		iocb->ki_flags &= ~IOCB_OCFS2_RW_LOCK_LEVEL;
+}
+
+#define ocfs2_iomap_iocb_is_rw_locked(iocb) \
+	(iocb->ki_flags & IOCB_OCFS2_RW_LOCK)
+#define ocfs2_iomap_iocb_init_rw_locked(iocb) \
+	(iocb->ki_flags &= ~(IOCB_OCFS2_RW_LOCK | IOCB_OCFS2_RW_LOCK_LEVEL))
+#define ocfs2_iomap_iocb_clear_rw_locked(iocb) \
+	(iocb->ki_flags &= ~IOCB_OCFS2_RW_LOCK)
+#define ocfs2_iomap_iocb_rw_locked_level(iocb) \
+	((iocb->ki_flags & IOCB_OCFS2_RW_LOCK_LEVEL) ? 1 : 0)
+
 #endif /* OCFS2_FILE_H */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d6e977ba6565..e879312ff86b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -9,6 +9,7 @@
 
 #include <linux/capability.h>
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -2374,6 +2375,29 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 	return ret;
 }
 
+static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
+				struct inode *inode)
+{
+	unsigned int dio_align = bdev_logical_block_size(inode->i_sb->s_bdev);
+
+	/*
+	 * Fallback to buffered I/O if we see an inode without
+	 * extents.
+	 */
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return false;
+
+	/*
+	 * Allow Direct I/O for any write requests aligned to the underlying
+	 * logical sector size (e.g., 512 bytes).
+	 */
+	if (IS_ALIGNED(iocb->ki_pos | iov_iter_alignment(iter), dio_align)) {
+		return true;
+	} else {
+		return false;
+	}
+}
+
 static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 				    struct iov_iter *from)
 {
@@ -2548,7 +2572,6 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 			filp->f_path.dentry->d_name.name,
 			to->nr_segs);	/* GRRRRR */
 
-
 	if (!inode) {
 		ret = -EINVAL;
 		mlog_errno(ret);
@@ -2558,26 +2581,37 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	if (!direct_io && nowait)
 		return -EOPNOTSUPP;
 
+	if (!iov_iter_count(to))
+		return 0; /* skip atime */
+
+	/*
+	 * the following two lines do the same thing. Once iomap completely
+	 * replaces buffer_head, we can remove ocfs2_iocb_init_rw_locked(),
+	 * ocfs2_iocb_clear_rw_locked() and ocfs2_iocb_rw_locked_level().
+	 */
 	ocfs2_iocb_init_rw_locked(iocb);
+	ocfs2_iomap_iocb_init_rw_locked(iocb);
 
 	/*
 	 * buffered reads protect themselves in ->read_folio().  O_DIRECT reads
 	 * need locks to protect pending reads from racing with truncate.
 	 */
 	if (direct_io) {
+		rw_level = 0;
 		if (nowait)
-			ret = ocfs2_try_rw_lock(inode, 0);
+			ret = ocfs2_try_rw_lock(inode, rw_level);
 		else
-			ret = ocfs2_rw_lock(inode, 0);
+			ret = ocfs2_rw_lock(inode, rw_level);
 
 		if (ret < 0) {
 			if (ret != -EAGAIN)
 				mlog_errno(ret);
 			goto bail;
 		}
-		rw_level = 0;
 		/* communicate with ocfs2_dio_end_io */
 		ocfs2_iocb_set_rw_locked(iocb, rw_level);
+		/* communicate with ocfs2_dio_read_end_io */
+		ocfs2_iomap_iocb_set_rw_locked(iocb, rw_level);
 	}
 
 	/*
@@ -2598,7 +2632,12 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	}
 	ocfs2_inode_unlock(inode, lock_level);
 
-	ret = generic_file_read_iter(iocb, to);
+	if (direct_io && ocfs2_should_use_dio(iocb, to, inode)) {
+		ret = iomap_dio_rw(iocb, to, &ocfs2_iomap_ops, &ocfs2_dio_r_ops, 0, NULL, 0);
+	} else {
+		iocb->ki_flags &= ~IOCB_DIRECT;
+		ret = generic_file_read_iter(iocb, to);
+	}
 	trace_generic_file_read_iter_ret(ret);
 
 	/* buffered aio wouldn't have proper lock coverage today */
@@ -2610,8 +2649,10 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	}
 
 bail:
-	if (rw_level != -1)
+	if (rw_level != -1) {
 		ocfs2_rw_unlock(inode, rw_level);
+		ocfs2_iomap_iocb_clear_rw_locked(iocb);
+	}
 
 	return ret;
 }
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 095f7ae5dded..9397947583fb 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -549,6 +549,9 @@ struct ocfs2_map_block {
 	unsigned int flags;
 };
 
+extern const struct iomap_ops ocfs2_iomap_ops;
+extern const struct iomap_dio_ops ocfs2_dio_r_ops;
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

