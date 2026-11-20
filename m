Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795154438;
	b=ZwID6gFuHkFnLLqcJOgRzvsnBZxa1okXL/b1hFGECyFzYDDdJJFRIqm5haqnPi5e+d8g
	 9NxnqBZXjXvfabfnSmK7BBRFBqQTGGMTZsaQKf7sYkIvA57sQsrj5pRv7Hj6E4fH1zUg3
	 yOHmUW/BWbrQ9qOc+5dddsCWRGgDrv6ZpTzVRZcaCm2qP9pjvg/s9Wyk5fNmSSDvLlRPg
	 ZlMtYC57r0lflFr84fQD5Ke2BwMCO4zLwtkUVn9VlGCI67oKzJN9e426dFXFoI+dMz9/g
	 aBMq5nhRY5K4f2YIbC8zF2UqogjXEzXIArVjIUReP3z8N3EjXSaeulQ8gBELSQuw4Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154438;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rUyy27CJUnZIa9LpRbxAASJ4+j2mMS5ZredWIhdQm0Q=;
	b=24WChfyL9Oa+reClQHv6Ykrt0EF2G3an1jHFX9jcKcuQCZZXl2Ney3mBcuCqg3Mr4KwQ
	 Xc+vHcvJ6n5otC+NmdcD7Wm1lPCtBPXzMc5Bv+w8tSCra+mexKudZxnMqjwX1ctKRRPQB
	 2YEA4nSFHBQ2DYp68dorPPSjjYaojaqcx18BEQcNdOJewew5EUTL5esYFfIUp3NRUQuqF
	 yLRdo8ZNSOiI+W+4uBUzUgKmGfskgdyZN54HIqAsrLt9csfTw7Cc+DN4Zp1EybRFLkK14
	 wqdtJEVeq4Agl1PIR1ZRYRH75AISFUccS3nPWrQ/s1p3Y9ReTPq/oItibxGWGJfBJwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Cx2uOrp+;
	arc=none smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5645A606A326
	for <ocfs2-devel@lists.linux.dev>; Fri, 20 Nov 2026 06:00:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5645A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Cx2uOrp+
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c5062bcb857so5450666b.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 19 Nov 2026 22:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795154436; x=1795759236; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rUyy27CJUnZIa9LpRbxAASJ4+j2mMS5ZredWIhdQm0Q=;
        b=Cx2uOrp+NUExq5kcZIfsNl4m8A7YlpBjoKnLx882XXXzKg/E61cu7VEM4SRs8xSX2+
         qjZCjg0uzB82y96gejvZLEfvJJLecEvtX/OiRlVmWztCt3ZYYEC+7VVAX1ec2gq9pkU0
         NhYX7+Ir/wY5uwbW0gF1b6UEsMJazgsXWj1Vvb5hdbkPk/qdOc2pUJuepVtc+KofKoj1
         8+3ZOnySezZftggz8k9vcqnmHMpOm4sxgkROL3lYXKlkisT4LeAnMUbIItk+bWqyqLvt
         VCvbxQZfRV5TZvUnK3V2Li8dzmc0QYvELhFSoT+zObkhJt1s0b4q/obsDlHRdgeOwi2i
         fi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795154436; x=1795759236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rUyy27CJUnZIa9LpRbxAASJ4+j2mMS5ZredWIhdQm0Q=;
        b=ew3ag9aMx2qKJXwaMxEDozQp92bFjB2OFvoKBcLCt/kwuv+pOkspnXyVKpqPKQDnN6
         /TsMubBnzAcWa/DuWPNQDYJsZd/+Pvqm59uOE2zFV9hHMioS4eBRv+B5bQmpOIxkChtZ
         CMMsCyXNxUL/H25zcP44gZGPSQZ/gAiYY3wk81isIp89NiByV7GFtzycW4LNltRv8gZR
         K/JJ4AoJ+oczQpPAgHINicOuG073JMNhy+JxbnPzbLchYkA9wkF3dh/DT8HLittOlCww
         OfAgcQhEvo0jJEZ8lUCtrApZqnF5rRE/0cMl8eledlv3dTPxgCKhMYlP+xpCs/p02vL9
         k8/A==
X-Forwarded-Encrypted: i=1; AL+hErGDmFQbCEive8+s4ADbAJG9OyYGpB2cdmLdJeGREXRF2hesbupit64JZBGqAoP4/EJG5T720ORFUm4Akg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8SXVa3i3w4frii29U8K3pcWCf5w6slonheqFE2VybtVMa9HMOI
	zod6XGjd2OpkudYg9n+yErsVOX7U6zsl7T16t28HYJHbzPf/fSUOE6KlSoqnEUSPrOI=
X-Gm-Gg: AYBFou0Di3vxeSQoBKcFjhK70cCg2nn+16Q5O0Gnmhyfpb8l638TTRGvBF2TzIfQy8g
	oB5Kqo9+8QMpbsyshQqyUHYzSDMzKXZDeDZQHvjxD2QvWm2e2+QPbnetBVWdKLXvVlzy46BeEeF
	Srs9eOSb1TG4gkaS62KWuTbWh59FNY/C5g92kJnakDutLOWKOJgQbMi2SlsybIc2e4mcyWgJoiL
	IUYBDUCxYYac5zekkly1O32jYVsI27uqHKTf+E1+JUlONFThrXpS2ACkZEfo/jZJym829j752+9
	PohVMe3H06SrYgCAIHdsjkARVbIVtZ+chaql7yO+MAKMxhQu5g4CkX8NDdlM+gb+V1nMoAePi9L
	YZQcc1Zo8DzX7TWt2oy2WhBfOPDLKKioK1UvmMn9cHKVwgfxlI0iYnxJTIxQp6FGxcAHGELazMZ
	cDrgysdB0ykmX4WtCOIDEnL+sdysm5xrRRbqtjq0oWpbbbIxX2WYHGuCZ6bv9/JoyoQmsoULgpP
	WFS18UBqhCbDgAx12hBaXv9gH1Wqknru7iSZ0RyzBydg7j/m23oOvkGChL0zBrGwbS/CAiDRT2t
	Om6l2ToL0nIBrSCJaNwG89/LqipgaWSor0A5OM29Ivo=
X-Received: by 2002:a17:906:811:b0:c51:356c:2657 with SMTP id a640c23a62f3a-c513a567c14mr180349666b.3.1795154435687;
        Thu, 19 Nov 2026 22:00:35 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f571sm918597b3a.34.2026.11.19.22.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 22:00:34 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v9 2/3] ocfs2: switch DIO read path from buffer_head to iomap
Date: Fri, 20 Nov 2026 14:00:12 +0800
Message-ID: <20261120060014.12087-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261120060014.12087-1-heming.zhao@suse.com>
References: <20261120060014.12087-1-heming.zhao@suse.com>
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

