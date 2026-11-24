Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795496120;
	b=UttEWIU2S0tzdCT/H29ArvtElXyJD8Kgd+wp+KCBHfnf4UmteR7sClh1yCEDOu6tjWQX
	 P1WduYjENvPWg0KEGXI+qDU7AnLP/sVQCGKF54gj/6kyChmvHnCYBBU8upnCF+cMd2RJ/
	 lAnJbKIE17ItPK9/DJXyQoeI/48IUNRPK6ob65Dkay1S0fGXOe7o6PoAGSnScR/1RHiFW
	 uJaEUQGH6x0bwYXLu8FPvFkYQE8rd7UTMj8cRnBVJjt1PAEMijhsiIX91s4OdPK4JWbRW
	 3JweeY4k10nANb+c0LZ9ro9vkubBIuCKBWBtMwl/zZb9FpcexNyGL/saUQUcd5ipnAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795496120;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Celfs8LSnrkldLwOFBBOONK7+cP38BXmYZ0QAvOgR+A=;
	b=MGHn5dPqK6PC9yOCZ/8g60ob50te9IJ2iruSJTes0uq+sPZSmaJmX8LPGV8k4tZbeXzK
	 W7dIqhDbFTNkGzER8w0IpTBYH5DYoX+r1fhUwPSdpZb2LNOY/HnKjFc0Rz4rGmacZvpV/
	 uMYscDfRd0/HGjd556URdi9CW/DTVG1heDfDL/hBSLoGmRXfDabuuID7tEDJqKIuAkK5O
	 oPo3uFlOxA6VVqolGmBJafPv9NSJGf5mtXGkQ+XTvsdN8sHSGBg+j29XYKV9VtMndZXc2
	 jFAAeS7KBxJCd8RV5YY4I41i7Hiu6ulCzX+XHsFcyjXMoAUkL7iEv+WhYn+Vg8+OlHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FY06umPq;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A44606A322
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 04:55:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99A44606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=FY06umPq
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c3fae9338f0so54258866b.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 20:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795496118; x=1796100918; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Celfs8LSnrkldLwOFBBOONK7+cP38BXmYZ0QAvOgR+A=;
        b=FY06umPq9vYZw9uklRVXC/pMMl79VgGlzfr2BjKdxOqy4K1AP8Iozi31wjFhG7rXcj
         7+syxpaZgbXF5/8u71p+g1JhQKTf94lHElJzxvnFXEYlrlFvTOwL7oB0mx/glE/g/Cpd
         V35zRF93Dk8quFdc141qSVVHo+6zx2rPqfal5uPvp6tEAJ9DQMhhARqP6OoSXDC21l1l
         98PDcxjX2W73yIvoo65D3uVmdc/kZrDTN0IZW5fi/Vmwix+E0aZmiBcSx79EhZCQaAT6
         AUWGZcJIn83mx9PQA89DOiQAQcFNc9BqmNvZuXFQVmRxaqNgRl7au115l/vt19CjXzLZ
         7Bow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795496118; x=1796100918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Celfs8LSnrkldLwOFBBOONK7+cP38BXmYZ0QAvOgR+A=;
        b=GU8Hm98grUE4xqcbtJp+LLFic0VtdVaruAqC3QIE+kA/496boUKZVeQVikfIKX43id
         XaTf5quXbBlzfZqh/nJ+Hfw67lLDRYcpyzKKmlWQkaJPnUCEJAeUHQZLwF3NPNh92vat
         7B3U5Wbxll7B9dOFWsCgOJrf/gEXWdVZTSaNYoLp4t2GtRultB9204GXc1/eRYyKLjbb
         nZ/U679sjOSt7YnQBXcBTC0fVQvcEJdyn86gBupSpRFtgGF6aeqiek6+S6/pIgu6car2
         ZAv5OGmpdsNAGkxPNzwFlcaHsy3SJmqIJtCZKfR+jInRPN875DhMSvvW7OAVdL8hgX2m
         TkGQ==
X-Forwarded-Encrypted: i=1; AL+hErGLnIWJUoNVftdrqVgci+DjlLv+UeLbHw6p/d1facRfCSIiras0v5nQSFfjXnMQP3rJrXGC6OdoMarwXQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z8qFBArJJ6ELNnQOeQJmxFPI5KD8bxHlhxOs4Qt3U1IWOsTz2K7
	9Us1vVXuTdXYCFXWkOQYZPB/FH0DUiy16r+xxvcnfmttjECJcPNdDjociCCjgt6Tjk0=
X-Gm-Gg: AZFdTZf/PfztMqvJBbnlIWEGzvkzIO6sNCEGsYzcuVIvwbKoeEhBBrVqNtIf9fBF7iq
	t2J6WWjwXKesKnouUaUhYrpMxbkfZ62UlxwiPRj/WzFwRpUp05iak26UTp2HEH2n1P7mcZjU7Ms
	k05TQha9hzZoyrCURMRomGPntomPH4etXhuEBVymX7KSD/6CSpD13iMpsb+NWKqehSlCnMXq6U3
	xVkQepa/Rcqr4iV7vKLXWaOph4nYb5ULtjlWP40gh0gKVxcigIo//NnV/mzNOvJoirQxaH3diwM
	BhVciJ9ZlgoSz4P/Usz9cgK6SXgAH9w0BcdBAbBIjnjU+56yZdGmoUdB5ytu3qUlQaFNx2iAx+2
	aHadEgBPO0KLgFPuLWIcOTKVMf31yDeu84o7TUUZveWirmHnpP2Ul7ryrOgAcOLpOOBvrui2Cxg
	XaVzI7gGQPhtfbdkSi7FWNl9ecfZ+hFmPO+kQtZY48PQxN8YVwB6/mJUhL6vzriZ7xon7sahC+9
	p4LcOWgK9verxRZhhFqQjTHYVKK0bM1A/KfZ7JjsZfO/aN5hWs/ZaRkQIiGFCEWJL9AnFnnI7Qd
	xsljs8SSI7UAu9LjPoUKl3FMKhc8G4ktflQyDiO7vMchG6il6rlKTjU7cv3CDhyV
X-Received: by 2002:a17:907:7081:b0:c40:5ee3:8694 with SMTP id a640c23a62f3a-c513a84b292mr947796866b.4.1795496117906;
        Mon, 23 Nov 2026 20:55:17 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe23sm20989085a91.15.2026.11.23.20.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 20:55:16 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v10 2/3] ocfs2: switch DIO read path from buffer_head to iomap
Date: Tue, 24 Nov 2026 12:54:58 +0800
Message-ID: <20261124045501.10281-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261124045501.10281-1-heming.zhao@suse.com>
References: <20261124045501.10281-1-heming.zhao@suse.com>
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
e.g.: ocfs2_iomap_dio_ops_r_pr ocfs2_iomap_dio_ops_w_pr for PRMODE or
ocfs2_iomap_dio_ops_w_ex for EXMODE. Also note that the ops_w_{pr|ex} are
defined in the next patch.

Additionally, the *_iter() functions use the split __iomap_dio_rw() +
iomap_dio_complete() API so they can determine unambiguously, from the
return value, whether the completion handler already dropped the lock
(real I/O, sync or -EIOCBQUEUED) or whether the caller must drop it
(no I/O issued, or buffered fallback).

The new function ocfs2_iomap_begin() performs a similar role to
ocfs2_get_block(). While ocfs2_get_block() retrieves only one block per
call, ocfs2_iomap_begin() can handle multiple blocks at once.

Co-developed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/Kconfig |   1 +
 fs/ocfs2/aops.c  | 107 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/ocfs2/aops.h  |   5 +++
 fs/ocfs2/file.c  |  60 ++++++++++++++++++++++----
 4 files changed, 161 insertions(+), 12 deletions(-)

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
index 64fcf6eb3d89..21cdc5c29331 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
@@ -126,6 +127,19 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
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
@@ -171,8 +185,11 @@ int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 			map->flags |= OCFS2_MAP_MAPPED;
 	}
 
+	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
+
 	if (!ocfs2_sparse_alloc(osb)) {
-		if (map->pblk == 0) {
+		/* detected a hole (unallocated extent) in a file */
+		if (map->pblk == 0 && map->lblk < past_eof) {
 			err = -EIO;
 			mlog(ML_ERROR,
 			     "iblock = %llu p_blkno = %llu blkno=(%llu)\n",
@@ -187,8 +204,6 @@ int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
 		}
 	}
 
-	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
-
 	if (create && (map->lblk >= past_eof))
 		map->flags |= OCFS2_MAP_NEW;
 
@@ -2532,6 +2547,92 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
+int ocfs2_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			    struct iomap *srcmap)
+{
+	int ret;
+
+	if (iomap->length) {
+		ret = iomap_iter_continue(iter, iomap, srcmap, 0);
+		if (ret <= 0)
+			return ret;
+	}
+
+	ret = ocfs2_iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
+				iomap, srcmap);
+	return ret < 0 ? ret : 1;
+}
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
+
 const struct address_space_operations ocfs2_aops = {
 	.dirty_folio		= block_dirty_folio,
 	.read_folio		= ocfs2_read_folio,
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 8dd6edd7c1a1..72de1e764a57 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -7,6 +7,11 @@
 #define OCFS2_AOPS_H
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
+
+extern const struct iomap_dio_ops ocfs2_iomap_dio_ops_r_pr;
+int ocfs2_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			    struct iomap *srcmap);
 
 int ocfs2_map_folio_blocks(struct folio *folio, u64 *p_blkno,
 			  struct inode *inode, unsigned int from,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 82c88fa8e98f..e309ff9a56e5 100644
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
+		 * by ocfs2_iomap_dio_ops_r_pr(). Call it directly rather than
+		 * through generic_file_read_iter(): iomap advances iocb->ki_pos
+		 * itself, so the generic helper would advance ki_pos twice.
+		 */
+		struct iomap_dio *dio;
+
+		dio = __iomap_dio_rw(iocb, to, ocfs2_iomap_next,
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

