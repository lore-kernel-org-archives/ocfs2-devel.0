Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709817;
	b=YIhabYrYLF1cDHDLB2Ct8B2hQ7A6KjfMMNwyUMNi6h2za7+T2T+L0Du/Zn9VDqsRAeQ+
	 EAwP6RFBknMyFOSemGVrbyoIxnrJ544smqQ12RA8j0lAqfbHruySaYY5mfCB2ZCMLfrGR
	 VXKG6N+ztg1XbIXSlmuDJ/9zx0TWmVndgkOc3tYvUivKabOuPxuq0KMbgYMkfMirLZRAx
	 bVrD5DcBGREYjvbdp7nmMm/EAhYUvoGgTAGhdkCZ/RHBnv+DsnoMJXJUhlNq0C+iQz1uD
	 a0bvM2+6GvANMF9+EQwbi3QWl3pXlHZJPZehQxLjzQJIKACULl+1tvAGpB5cCakiQOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709817;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b/+luqkMAEnlkgfPQRPwQL87VckoHmCLbb+li852IoU=;
	b=IbBLZw5PzJQXN3UnOw6WRxO9rmqYwM2iHfo3RAiz2e4U++gRams0BN/LHN0Ng2UwZGyW
	 ywFVmB6GR5JOH2iSryBj9rpvh9246PgKaJc51PXHE2gFk8/uy5Ds9kqVfHy3cpVMBYiIY
	 C8i5ghZmOS4Pyu1mgU7FCohX0MzuaeNIKcvBTC1MN04vQeyxieIhlDAmoIgJS79bVyGFq
	 KTMuAvPlz5Z/FSLPoOhYUA4h6iDvbciuSwgHLVmUPZiebFGESAVEu8EVlSyoS9AMwvrr0
	 FDxZBPWnTr/nMrP0d/o2rYek9VcboqFEt5J/xhI1jxANZOyoFIWb6pgGU8tDn7YNrgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Ai04yJnX;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC1A606D80F
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Nov 2026 12:43:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7EC1A606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Ai04yJnX
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a78ec32fadso9644265e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Nov 2026 04:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793709816; x=1794314616; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b/+luqkMAEnlkgfPQRPwQL87VckoHmCLbb+li852IoU=;
        b=Ai04yJnXaiDRh/LKMK+C3djN3fmRt9byb/lO5IKoLb6md5ncTEshcyRB5sL6ZVZC7l
         ujcopG8t+izajchUO+jSg225ULVzQJFzEDCiCG0M90q5ZwFln/RnegkU4InKOGMwcGsr
         EuLb/McvpN3kenNNN2kLC8t360dbLH6s0dMKGWbYy5lZxF5x8ozRJ8+ElCW5bsPnCK65
         ziDZmML6MtsE5RwJEZ8mfvHb9gvBzZIF4624moycNQNrEpsYiVzEMNyWEZkXD8TLG9RE
         HhMzGagpe7xz5yA7DgimE62NPwt8kRydm2kIvvBhIEkjnbjxXTooQtmRXKRw6SjMSJDy
         YxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793709816; x=1794314616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b/+luqkMAEnlkgfPQRPwQL87VckoHmCLbb+li852IoU=;
        b=F2I8FiuE0AWVSZ3fUJKb/u1MqtHzKI93JRyQ2CtD16w6mqR7WytBvLG42h/7gWsSg3
         ypo/P4xrqDHZUugMOUhsvt1Pgan0pnVy1bf29oQ7Y5880qhte9Eklfkoi5Vwd3+cOuK5
         QIJrNayS9aXMPIbo5O7Jz7gOYdT2xOLZK8QsPN87GHFm2TSHBli3gDSUxr0U24g9AFSN
         NZJhwresJCBaRVgnQ1sYXWodZIxcB20TeeTPddRriyz979jR4dEqOvpU9TlSLMSavymk
         f2EfyZmgTX5LT7BqgzkJZZNq9RdcP2GgRA2J8bIaM4z31AkrtM9zRHfqVrMc5cRIAip9
         bP6Q==
X-Forwarded-Encrypted: i=1; AKwUvBwQ/6dYjLPO9WU60eOU2e+0agagX0BsQak0RrZNRXnl+WteSOQpCV13ACHKCKDto61Y6aMA5QzvGn0Mzg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+5nengC+ZIfjkpGJTRBMT61EWDauysOYP44ZkqoBDiGjRu++sY
	mdBEMRrORZYV6/VVSeM2oG3RQCEa/po2PlJ+1zOtx+hYoWK49hXZrV576dTD9b1V2rc=
X-Gm-Gg: AYBFou2c7yA4+cUf0oTNmvofsBHtMe66A6Y7T1oGPd7e6UKXzftWw1Wmgg2l5smd7vy
	vWn7a55WFqYaJYaj8AoQIcIq2KaGF6u6QGE7Mz+p/a4Fm3rPn9mLNbDWrHSeTzf51DjfHcKSSIu
	B1Xk+ConeIrbGQWEdxeWYb9U+s08olBmMkqyHDE7faAt644xldT1hudkQ9SuWkkMpesKhvogvdc
	HR7e+O6wxDX0gE2bHAV0AMCW6Kgs95Qzz5ii1aDhY5HbsGbmgRldgD53UtVr2sZMYmMadSnWHKG
	0aR2kk33eZcVJUEjcju7rjZOVS+T01adnAmcYB4Cz4tfmKM1juGj5ly2elvV2ObfPorgtNfMDJA
	1JhIRAG61U9IDWu2niNeRqFnfffx+w3WaH9yACLUA9NQ/2Xu4/uFsJrDylGwza/K54OVRtm+U9S
	WB3IljcEfRCkmt19n1uAjjjM6GKmZDtYJZqXUV7TfdCE1iCVh/9I0coOYtiOUJ7kfMn2yNR60tx
	cu9wjPEPmYPPpniBuiG3uNMnNuKgcE2s1wRz02G5YWeu3WZWvSqbZnnb9RJIoXVLuIoxCwL9kl5
	8dCf07BltoFcv0ZCRI1+Sv7NvLr4epws3NUa/nJbpUXhDIm+ggZBblAGBanquTIe
X-Received: by 2002:a05:600c:2604:b0:4a1:b027:99ef with SMTP id 5b1f17b1804b1-4ac16acfa8emr221721405e9.2.1793709815868;
        Tue, 03 Nov 2026 04:43:35 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c8460acsm4365014a91.7.2026.11.03.04.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 04:43:34 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 2/4] ocfs2: switch DIO read path from buffer_head to iomap
Date: Tue,  3 Nov 2026 20:43:06 +0800
Message-ID: <20261103124310.21143-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103124310.21143-1-heming.zhao@suse.com>
References: <20261103124310.21143-1-heming.zhao@suse.com>
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
 fs/ocfs2/Kconfig    |   1 +
 fs/ocfs2/aops.c     | 111 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/file.c     |  63 +++++++++++++++++++++----
 fs/ocfs2/ocfs2.h    |   3 ++
 fs/ocfs2/ocfs2_fs.h |   3 ++
 5 files changed, 171 insertions(+), 10 deletions(-)

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
index c612244690a1..da53abe59ea0 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
@@ -2541,6 +2542,116 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
index d6e977ba6565..0ad4f08eb3e4 100644
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
@@ -2598,17 +2610,48 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
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
+			if (ret != 0)
+				rw_level = -1;
+		}
+		/*
+		 * A 0 result means the mapping bounced us back to buffered I/O
+		 * (e.g. inline data); the rw_lock is still held. Go to the
+		 * buffered path rather than re-entering direct I/O.
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
index 88fe985e87c9..58ad6f570536 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -550,6 +550,9 @@ struct ocfs2_map_block {
 	unsigned int flags;
 };
 
+extern const struct iomap_ops ocfs2_iomap_ops;
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
+
 /* Flags used by ocfs2_map_blocks() */
 #define OCFS2_GET_BLOCKS_CREATE	(0x0001)
 
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index c501eb3cdcda..fe1b80531c45 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -314,6 +314,9 @@
  */
 #define OCFS2_CLUSTER_O2CB_GLOBAL_HEARTBEAT	(0x01)
 
+/* Max logical block we can support */
+#define OCFS2_MAX_LOGICAL_BLOCK	(0xFFFFFFFF)
+
 struct ocfs2_system_inode_info {
 	char	*si_name;
 	int	si_iflags;
-- 
2.55.0

