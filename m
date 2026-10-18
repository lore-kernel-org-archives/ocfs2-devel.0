Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DD24C14EC
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 14:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792334024; cv=none; b=Ve1ALjsvLs3xfqI3CCfxhscDlcjjTU6D8Sux87gQ9zcOc+D65s+9Bz3UMG5kps6esDk4iYbcoB57GNX5CbN5l2g8oXlOm9gJeKkVNrq7D3O0/RqduHRqgYdlKLSKGaZNfnltDlARZ8+PLAypkQR0JZuyQtxXAgM2J4qBw+c/mZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792334024; c=relaxed/simple;
	bh=Z9ZsgEwTvl0zT2PhPzFBcW/Qkscp71jV7aHwCPs6T94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEooY0DCFaZ98rtQvUrRElqtuqa618BT7lx3ZLTheKfYQdsOn8yrspqBXLVvdDxv3yTvUGE1OvQMGS7+EmT8fXLEeB3qFEf/LMr2176j72azmLEobfNNb3yG83RhjnAThPgZ4GTQauoIOAUwelDBc7GQ51OdacaY5JSoPJ9TLic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SlUyWwhm; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SlUyWwhm"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1e6c19ee7so106585e9.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 07:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792334021; x=1792938821; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gc6TMqYlZH6lasap8voauKdOjroGVip48IsZ+L9oHlI=;
        b=SlUyWwhmSiuUyn2OZsy+D4XRpS3XjIA6V5sVkfgYGXBjpeUcQxWpo6UvsfmNbE1MVe
         0hzpRZ+JbS0nDoEMF/75X2vm7YuZIHJz8yAkut0jz1wEEV+PLisZDSud841oIt8oa9bR
         cTbYxeuiN+s4LLgPDRvDpk166fFQYj/HgwXhGAeJ788egtOiiAGLfAbXv70CI4ee9dqh
         w7G1rr/z5LZocJKzYqbqrKns5SvfxQCXHs8f8LTDrJ17g4PCbqki1oQeugofKRSUa4ww
         A7Q+DUYXh77pCjAHLikXuk+sxATF5LlvXeloY9dXePX8HTHVIXk+WY5N0Rf9MhEayJum
         BbyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792334021; x=1792938821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gc6TMqYlZH6lasap8voauKdOjroGVip48IsZ+L9oHlI=;
        b=gA4dJjZ56vuC6umKkrWtoGfu0DIA6XLHmLox4DojZvb9djFKZJUqXAMeXr7GaiNlob
         psAyrRm8gzqeUVw8InaAQmVGu4tC/cr37LqgW4rhPU8OD/HlRApBoOdApuBxhMk7Wd6N
         TLkRLlByZTmGJa5tbb75ElISCzSJjdI4z0MDujwwg18h4NyN9TVJKrTOOsLTNh+fNWeV
         bQStAkOMjUxTNf193pMDXaO+rb59QZvMPiD6b8SrkQRvO3HNSnI2aL+xiwy/gQKPuwbc
         IvQQxc5I9xF2SdoEvf5n2DWfjmQApFu9XjfazQT9NoisSVIBCAh4UNmnLIi3H43/7tMc
         FLgQ==
X-Forwarded-Encrypted: i=1; AKwUvBxYWxsWJg5cPh8dC5N8n2+Iast1BKnI2acydzkPA05t+UQk5OjeMafpoRZNmhOzUgtYyeNkuPkmC8YaQg==@lists.linux.dev
X-Gm-Message-State: AFq9FYIlbsJx4ToNYEebyeFxHZEXeJclnM0Sgz/qAKIpQLFmevsNsMJx
	xQW3TxYKJ2besW1lCnqOD943Tdr9svQ/I6mBGM5hJfku0fCQ3//eJepCgGktHjMFjjI=
X-Gm-Gg: AYBFou05VihgkC6djjEN/f5w0j7cE/LHG65tLM0KLAcuN1hlop2OXppnoOSXBAWTLHS
	RuMXDUXB9qzBD5FDk+N5TFyW8bth/COVkhuZdQSIoS/900BUU9eBU+8OurIYsG77TdqO6ExNEiB
	lVBxEGBM0Y6/3vDp+HqCl0ZcBx7XV6Oj1y6gO7YQGthx58EIDkfR9XjixGA61n4z5F42NvWm6y8
	OPObM9MTvKbYaQGLwJ/exlsA+Qs/v+A+1lwVU04RZML2aW+MNav2+wEV2A+E+jFCDC/cA4bfKEJ
	UyxmX+6WqiG8l4KU4n7ozZuwmsIoRXVo56hYjItrkH2KH5XFaxk7qF3HUMMC+LjMvqa/tkVV1LL
	aDOxkhDs/FTD2mu6S94ivRp4qBTeQWzd6hLT2JeVXq/z3dCuqdMfABBPZuV765cWR4r8tT3JJMC
	KBfr1hTLdXwWyi9ErkFW54fZ+KM7ttlep0x53YKBglFSXIXZW9zrTQDmoh9FoKDCb0Y4oZjZ0cC
	itn79qHdazU
X-Received: by 2002:a05:600c:c16a:b0:4a0:1973:f05a with SMTP id 5b1f17b1804b1-4a1d75f1ab3mr85882265e9.2.1792334021039;
        Sun, 18 Oct 2026 07:33:41 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac947928b4sm16339501a91.11.2026.10.18.07.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 07:33:38 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 2/4] ocfs2: switch DIO read path from buffer_head to iomap
Date: Sun, 18 Oct 2026 22:33:14 +0800
Message-ID: <20261018143319.22329-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261018143319.22329-1-heming.zhao@suse.com>
References: <20261018143319.22329-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
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
 fs/ocfs2/Kconfig    |   1 +
 fs/ocfs2/aops.c     | 111 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/file.c     |  57 +++++++++++++++++++----
 fs/ocfs2/ocfs2.h    |   3 ++
 fs/ocfs2/ocfs2_fs.h |   3 ++
 5 files changed, 165 insertions(+), 10 deletions(-)

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
index 3215e2dda2be..633d23dbbe09 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
@@ -2545,6 +2546,116 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
+		return -EOPNOTSUPP;
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
+	 * When iomap_dio_complete() calls us with size==0 and error==0, it
+	 * means the mapping bounced back to buffered I/O. In that case leave
+	 * the rw_lock ocfs2_file_{read,write}_iter() keeps it for the buffered
+	 * retry and releases it in its own cleanup path.
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
2.55.0

