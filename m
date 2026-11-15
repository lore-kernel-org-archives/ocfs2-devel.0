Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794757231;
	b=YgAk6vyycsAcv2o4NzBaDLlDAMKIL6rujFycOwhkeBMrSO4+gaB1r9LFw6dAzxUJETQS
	 mU/eVo64QPOGsxlvfDuXx1uPu8WP9hPfeoNI2rfhYR+cofxkzi1OBU979gaA0dRyKXYFZ
	 N4GXfw1rqZz7iRpwCl6arLre6AuqQ7e/QF5/10SkLWHvNJuCRhTUYOBkpM8sD3eDztSFg
	 ojqxWTJmQ9YxQjOGGC/1NZJkH6NcjtnTvqfGEKhhXX5OKV89oFy4T+sb39KxA5Ah8dRvr
	 va4XlSXyh+gq8SX5XomtcKzAnKI5/vKF85Bt7k8JbS26u68fcwHq6YsMgz8SDTjdcdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794757231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ErK0DhGPoN6AMkphEoKsbtXWHONPX5ypGWn26lM2sI=;
	b=hl/DorlutGw8gFlhmz3m/p0ehCBYpa96INIpmN7I2GCa2VGynsagKSQZ0ktGK8s08AlD
	 h/Xd/LqRLvC1btdkOFDbcXhIAf6AV4fM/xQfjfVUE4Juf84jlkdcPIe5zgUkD4mJyKjVh
	 lanw89zfyabxg4vjM0pFQqPfS2oJWxHMUDggWlkijhNtfufAbyVo9nnxfB6KHB7moPE2T
	 l9YV/gzPFz1RE8bGFiqqc3/3bAzKSvwK+JSen1/zUjxHAcR+v9RHvNl1xZQ17P1jTyyFy
	 du11g3PZUJ7sT7KeQtm3z1NVTFxBwrfg/n2FSt8jua2dY87w+MuhZ8rYGPCzKmZ+q0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ReGLKv9t;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3957606A331
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 15:40:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3957606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ReGLKv9t
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb609d9bf4so2535595e9.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 07:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794757228; x=1795362028; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4ErK0DhGPoN6AMkphEoKsbtXWHONPX5ypGWn26lM2sI=;
        b=ReGLKv9thBHS/WgzLq4FmJroKVzltFVUZ0++xnQBDaPJk15j+1irpjYtrrpKa0X1Tm
         Fv/Q8+que199K5th25aS6RiXJ2jNqzHji4bc3b68d0lSRobifdY1EbERj/aK6R36Suy3
         1UxEVAA6PNKLyx3SGS7/17gdFvyt9iryx1ryMx8c1Pe1b74w/zC2ssQxsoJw0o0XA3mN
         Ba3JAP2HnkY6j+J+CEex0jdEJHuiUoMslNly3upYXCCBZYIoSiHw/EMXuju8vKVD6qdp
         gzpS6eU+8Tp4ajeHnLjXQmPSR1AIpADlKK/yIcbvFeyg2j1ls02Lgwb8kdPWgvu/e0W9
         5Tnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794757228; x=1795362028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4ErK0DhGPoN6AMkphEoKsbtXWHONPX5ypGWn26lM2sI=;
        b=yf1PjXqOiS9kBTecjVysQnDPCuEeh8QZCzhhbZC1kmh0oeAROqP6jfWBiobOAv9vQj
         LWCiQe3dI6gVfvXXE9LUgcnV4lJFAacETc6rECeuJnRESfVhovShK5ICm4Z92X63o1DB
         CaHFnNkKRYixdXRp76+M7eEkCsuo3VqJ3wd1Once8hQo+A2K+dqpIbW2J+/szupOYEWI
         ecy7m6ExhMvKMU2x+7O0YGXfLDSrASuSdONBIYlFDRHod6BtyWPF4RnTbdn0CaErQk+o
         dnuS/WSDygolw2xy73rz33DDvSQ+wZdphz3uFQPO7wGBnHA2tEfVcF3+xQaY1rvFa+yb
         PH3w==
X-Forwarded-Encrypted: i=1; AL+hErHMZt1PA/6P3LdZ8w+H/mH8twFCae6VTyXM72bhVdrW0VRuIkEIAYoP5CpafidUDzhzN/CcdSVo7wyQMA==@lists.linux.dev
X-Gm-Message-State: APuU4Z9DZhKXGHV/EO+YAZCdvcAXq3eNVC/W5O+rGJQ9U+aMqP9HwCvo
	BtNVD3QrQWOoaSGo/ln0ULgGD6jVr+DN6fnU8lByGjYpswNDeVOs+6wgfH7Zfjaws6Y=
X-Gm-Gg: AYBFou0QozuaIrpTUKHA4oTfDpQ2BXy5PcYHJfSZjw894FYcefGKcKgBPUfNoABEGoy
	eUx6l1gklcK9wIXvB4LRvw15hcDNmj0wqKVv96Yck41w9zr1YH6GRCJM5HtnYrtJkZiPP3qIskV
	KtIeSO2qI1Px/n6cTI4SwKy/GX0Z0SXNx8zZUayiqas0t7RZZHMFohFdqIpLIjQ+OYUhYdKKek+
	bReYkL0dOTuWazcO6yft7+gIX1lZtlOBwM5JMJkGM8AFb6haBEvY9B8jaIvQiesi1IzLGp0O+DG
	ZqhUxmynZg+kjkIkJzX3tTU6h2dKy/9wIEMDeTWDE8ZhFZEXbXC5vPjXaAWUwirIPHyA27+Ad/x
	NGToQlPi6KMurVs9xJAe1I5bGWWSkgchxMU1h09X08mb+Ueos6zhPwohOe9jZ/SExxyGPCj1ZDz
	mgP3PUgRJEHAE4ZyYc0twz/+c0Aylg2fPbsfc/eDftXh4QI8XBbkasxxrOhP31kSGw4ZVpmAymJ
	GxTVLlfXC6QXl6YEnrThncBYpZoTDYoqgkR1QLjTSvAUY+u2O0nNM6AMvYkWMfb5rY0hIm3n+V+
	qQeWwWzw//qys7m0eY2VzAZqMo6RCwpWVELblJU17OKH01u72M2lX2WFulmniDr6gg==
X-Received: by 2002:a05:600d:644d:20b0:4a1:b027:99ef with SMTP id 5b1f17b1804b1-4bb55a3f05cmr136007195e9.2.1794757228191;
        Sun, 15 Nov 2026 07:40:28 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379558231eesm25648733eec.12.2026.11.15.07.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 07:40:27 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v6 2/3] ocfs2: switch DIO read path from buffer_head to iomap
Date: Sun, 15 Nov 2026 23:40:10 +0800
Message-ID: <20261115154013.9379-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261115154013.9379-1-heming.zhao@suse.com>
References: <20261115154013.9379-1-heming.zhao@suse.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Migrates the DIO read path from the legacy buffer_head infrastructure
to the modern and more efficient iomap framework.

Under the current code, ocfs2 holds a cluster lock during DIO via
ocfs2_iocb_set_rw_locked(), and releases the cluster lock in
ocfs2_dio_end_io() via ocfs2_iocb_clear_rw_locked(). The lock level is
stashed in iocb->private.

However, iomap DIO owns that field (it stores a bio there for polled I/O
and unconditionally clears it before calling ->end_io). Any side-channel
state packed into iocb->private is corrupted, which trips the end_io
lock-state check.

Instead, encode the unlock level by passing distinct iomap_dio_ops methods
(ocfs2_iomap_dio_ops_pr for PRMODE or ocfs2_iomap_dio_ops_ex for EXMODE).
Additionally, the *_iter() functions use the split __iomap_dio_rw() +
iomap_dio_complete() API so they can determine unambiguously, from the
return value, whether the completion handler already dropped the lock
(real I/O, sync or -EIOCBQUEUED) or whether the caller must drop it
(no I/O issued, or buffered fallback).

The new function ocfs2_iomap_begin() performs a similar role to
ocfs2_get_block(). While ocfs2_get_block() retrieves only one block per
call, ocfs2_iomap_begin() can handle multiple blocks at once. Limit the
map offset and length in ocfs2_iomap_begin() to OCFS2_MAX_LOGICAL_BLOCK
to avoid overflow issues.

Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/Kconfig |  1 +
 fs/ocfs2/aops.c  | 97 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/aops.h  |  4 ++
 fs/ocfs2/file.c  | 60 +++++++++++++++++++++++++-----
 4 files changed, 150 insertions(+), 12 deletions(-)

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
index 28a13246e9fa..6158ab6515ad 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
@@ -39,6 +40,9 @@
 
 #define OCFS2_DIO_MARK_EXTENT_BATCH 200
 
+int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
+		    int flags);
+
 static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
@@ -126,6 +130,19 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
+static int ocfs2_lock_map_blocks(struct inode *inode,
+				 struct ocfs2_map_block *map, int flags)
+{
+	int ret = 0;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+
+	down_read(&oi->ip_alloc_sem);
+	ret = ocfs2_map_blocks(inode, map, flags);
+	up_read(&oi->ip_alloc_sem);
+
+	return ret;
+}
+
 /* ocfs2 never allocates in this function */
 int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 		    int flags)
@@ -173,8 +190,11 @@ int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 		}
 	}
 
+	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
+
 	if (!ocfs2_sparse_alloc(osb)) {
-		if (map->pblk == 0) {
+		/* detected a hole (unallocated extent) in a file */
+		if (map->pblk == 0 && map->pblk < past_eof) {
 			err = -EIO;
 			mlog(ML_ERROR,
 			     "iblock = %llu p_blkno = %llu blkno=(%llu)\n",
@@ -189,8 +209,6 @@ int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 		}
 	}
 
-	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
-
 	if (create && (map->lblk >= past_eof))
 		map->flags |= OCFS2_MAP_NEW;
 
@@ -2534,6 +2552,79 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 				    ocfs2_dio_end_io, 0);
 }
 
+static int ocfs2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
+{
+	int ret;
+	struct ocfs2_map_block map;
+	u8 blkbits = inode->i_blkbits;
+	u64 max_lblk = (inode->i_sb->s_maxbytes - 1) >> blkbits;
+
+	if ((offset >> blkbits) > max_lblk)
+		return -EINVAL;
+
+	/*
+	 * Calculate the first and last logical blocks respectively.
+	 */
+	map.lblk = offset >> blkbits;
+	map.len = min_t(loff_t, (offset + length - 1) >> blkbits,
+			max_lblk) - map.lblk + 1;
+	map.flags = 0;
+
+	if (flags & IOMAP_WRITE) {
+		return -EOPNOTSUPP;
+	}
+
+	ret = ocfs2_lock_map_blocks(inode, &map, 0);
+	if (ret < 0)
+		return ret;
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
+static int ocfs2_dio_end_io_r_pr(struct kiocb *iocb, ssize_t size,
+				int error, unsigned int flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	if (error)
+		mlog_ratelimited(ML_ERROR, "Direct IO failed, bytes = %lld errno:%d",
+				 (long long)size, error);
+
+	ocfs2_rw_unlock(inode, 0);
+
+	return error;
+}
+
+const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr = {
+	.end_io = ocfs2_dio_end_io_r_pr,
+};
 const struct address_space_operations ocfs2_aops = {
 	.dirty_folio		= block_dirty_folio,
 	.read_folio		= ocfs2_read_folio,
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 8dd6edd7c1a1..2fe3b39e02f7 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -7,6 +7,10 @@
 #define OCFS2_AOPS_H
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
+
+extern const struct iomap_ops ocfs2_iomap_ops;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
 
 int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 82c88fa8e98f..39f4fa924351 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -9,6 +9,7 @@
 
 #include <linux/capability.h>
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -2399,6 +2400,26 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 	return ret;
 }
 
+static bool ocfs2_should_use_dio(struct kiocb *iocb, struct iov_iter *iter,
+				struct inode *inode)
+{
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+
+	/*
+	 * Fallback to buffered I/O if we see an inode without
+	 * extents.
+	 */
+	if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL)
+		return false;
+
+	/* Fallback to buffered I/O if we do not support append dio. */
+	if (iocb->ki_pos + iter->count > i_size_read(inode) &&
+	    !ocfs2_supports_append_dio(osb))
+		return false;
+
+	return true;
+}
+
 static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 				    struct iov_iter *from)
 {
@@ -2588,7 +2609,8 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	if (!direct_io && nowait)
 		return -EOPNOTSUPP;
 
-	ocfs2_iocb_init_rw_locked(iocb);
+	if (!iov_iter_count(to))
+		return 0; /* skip atime */
 
 	/*
 	 * buffered reads protect themselves in ->read_folio().  O_DIRECT reads
@@ -2606,8 +2628,6 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 			goto bail;
 		}
 		rw_level = 0;
-		/* communicate with ocfs2_dio_end_io */
-		ocfs2_iocb_set_rw_locked(iocb, rw_level);
 	}
 
 	/*
@@ -2628,17 +2648,39 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	}
 	ocfs2_inode_unlock(inode, lock_level);
 
-	ret = generic_file_read_iter(iocb, to);
+	if (direct_io && ocfs2_should_use_dio(iocb, to, inode)) {
+		/*
+		 * Use the split iomap DIO API so we can tell who owns the
+		 * rw_lock on return; reads always hold it at PR level, dropped
+		 * by ocfs2_iomap_dio_end_io_pr(). Call it directly rather than
+		 * through generic_file_read_iter(): iomap advances iocb->ki_pos
+		 * itself, so the generic helper would advance ki_pos twice.
+		 */
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
+			rw_level = -1;
+		}
+		/* never fall back to buffered read */
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
-- 
2.55.0

