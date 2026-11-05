Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793863191;
	b=xFhPrMf8SpXz3zJJqZgpOuXekM18aFKt+saOkhBfPa81QHy7YegW07a4Mv6pQ+yhII8H
	 wiogrvLbYSmP74/m07FS3V8pJ2EaMDuHZiieD9rtiPThvHUJMMePOJTZuuu7hKsk/VoA5
	 5HGbbxVxncZp5HNAeWFplpJk47x5GbZzSmT3RcWtmIWw/iO82+he3my/M4Znzkq758Lqg
	 sawc+NlPg/UPv8U6B79uzGP0o4GqJpJNUekla8q42kCc9SYQ31x2LRktN+Rw6YWWzKoKU
	 DRr7PE4BZDeXw16BMUXZETj8kKZb6yR3FUkY/8PEpxt1hxZKOiTtKvVZ3URSzSOy+Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793863191;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cHMbV2zg8MXNADyUaZnJxbTn8EhphwjmisxIPlTEbaA=;
	b=3FnnOqgsRfbYj/UTHG+GLYqPOL1S9WDWJeC/uOKp3RtrU0H3bLCD7o6ROVG1b4adN+9G
	 NqHRso0zAsGbITV2D1VkHT/1c7wv0C4s2ybglNNNts/9c5cz8oqq7bLeGsNT0Z+BpxiDh
	 jR0+QuRnFnyv8m0EqNY2xs3hu/KEDbwAX7Xx2NhrBBZqp6cbQGQzyZZ50e3YgfoWFkZQ/
	 u1eu3F8ZfCfky2RFuUG7y+RtZPoowN5NIROGjqdaxsWObi7zZFqVveF0vEWWMwUFN93jS
	 Jryzzx9OD8+SVFFueliPn8Z8o0ieyAuXmHhTEh4Sjn6ykmX4t0+TJfCyZVO91RSI+tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CqVev7qm;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7260606A326
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 07:19:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7260606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=CqVev7qm
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4af520023fdso4244205e9.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 04 Nov 2026 23:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793863189; x=1794467989; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cHMbV2zg8MXNADyUaZnJxbTn8EhphwjmisxIPlTEbaA=;
        b=CqVev7qmshaygxgxAIlmlSn5hVtzrJwSkbR/d+bo9LCCCAi5ta+sfyoZnhcb46qz1n
         g4n4vNOQqlb/+ySUBIXj2sH0U3bYdnn9tliKfa+A698XBLgCXNJYlmWMdBUr/93Bb+AT
         QtTzMmQHFDO4yZAP63aUr3JlSTUgnWEnIw5KwajYPxpdtjd46/up4hBU0lKsGfRhOr1W
         OHDZiobVVh8a9mEKoyuw3GGvPfCYxyJD/jh235mmHLQ+B2dk6BylT05PoaXV9kThPurT
         BQC6uMi+62YuQlp8Y9sYGNH+6g+371412LbIlePNx1z4ik6ZPm7Kvk65ovDFmLnwHm8Z
         ydOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793863189; x=1794467989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cHMbV2zg8MXNADyUaZnJxbTn8EhphwjmisxIPlTEbaA=;
        b=CEj3D/LKESVnTUotlHrYZY8X929KWeVlxX/Kk+aIJi5h3P28VthRERRaTMPwWAOyMb
         Ke+0+e8PpDF9NrXppIf9TGpVxKGX2bFfoBMqThDY+fNUjZz4nwI4+zkep6Y50EzKzT4Q
         HUoHCuEbQj/gnt0WHJYWK/U7YxElCRt10e9nERZy+UMVzXI6uTN+XiaU53swF2t5wbv3
         K+iv5vvDv/5kbSfmbWuhMquIje0b4kxrXAd/2Ajug5lhBqFrtF3tA9Xy+opf8stNBkIh
         dlw4Hq55yqzybwPsLrrsYVB23iE81ryG1iI0y02iFO+WvIbcCgr5j0y5XRMI7WMXD8SD
         6foA==
X-Forwarded-Encrypted: i=1; AKwUvBwsKW2zt31ONzXfbC3PWBV3b/UX1we53ShaToIysAKCGgu3uJekpFkgunLJ0dnZhHE1gwRrg8lCnkDMlg==@lists.linux.dev
X-Gm-Message-State: APuU4Z/BCs2xFSHCaVe2X/kXGo/YUjgJAaLGCtxAl5dpe3Rb3YJgdovZ
	hgdPvpgeEoi6EGWiJKGFSq2jC7wklYAiEPsG/BlsaMcw+/oNqthpRS8yrXanst5+31w=
X-Gm-Gg: AYBFou053zG87NokD4iu+0Kzskx4yi1zSZaVYFTiX+k/d+d7c7kgQXL9lX38MaCrz18
	LfNYsh2ymb6Y1B3IckitG5/DJ/k6IkBh4TET2oCZ31dGjCbYuEJKX4lBneJLWumXDls2xAJBU9u
	lLG2C2PmsTPYM3eKpza09ZAqvYxWCC9Ql++312mXMI93If2sh3jKC3ARZq2kA4TMzo36LQMUea6
	n0cYcZlcazGtfNgvRn874hYC0imm6UcdB73oNgUg1nEm6zvqzgX1+y44bQFXhadmDgD5hv9TX67
	MFwMpZIZKkiGiO/dE75MV5ARWI2vw3dVBVrUTteeVqS6mHLVD8UoYsT4ecn4prXU5BCsgO91T1k
	JIoMfp1n603Ucvwc7sSVqJ9uL8/V0tnysiVnBKmxzfx7vkiuFo31ABx+T2x1AVK/ZVL+u6G0TbZ
	wqiR4cRO0eQ9U7673NU7fi0bXPfIBtyjLVIKu20fvqql24gK9jnyXHneTH6nxxx81Y0OMftupAI
	+iAPeDdtt2S/xazcdWLlWm6x9Bu0H/s9Np4XK/5kBIS5ZTEnQH9pHQ55V/zZhyeQNaME5USe34F
	14NNUYMtHIFyY3a2k3V8g2fZux+sEQTZWzlg2g1Z0FE=
X-Received: by 2002:a05:600d:6505:20b0:4b2:3c81:103 with SMTP id 5b1f17b1804b1-4b23c8106abmr150432225e9.2.1793863189257;
        Wed, 04 Nov 2026 23:19:49 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245b86fbesm14687084c88.1.2026.11.04.23.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 23:19:48 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v5 2/4] ocfs2: switch DIO read path from buffer_head to iomap
Date: Thu,  5 Nov 2026 15:19:26 +0800
Message-ID: <20261105071930.16399-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261105071930.16399-1-heming.zhao@suse.com>
References: <20261105071930.16399-1-heming.zhao@suse.com>
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
 fs/ocfs2/aops.h     |   4 ++
 fs/ocfs2/file.c     |  62 +++++++++++++++++++++----
 fs/ocfs2/ocfs2_fs.h |   3 ++
 5 files changed, 172 insertions(+), 9 deletions(-)

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
index 0f7502de9b8d..8e4d31cb85db 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
@@ -2534,6 +2535,116 @@ static ssize_t ocfs2_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
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
index 82c88fa8e98f..a62cb68f246b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -9,6 +9,7 @@
 
 #include <linux/capability.h>
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -2399,6 +2400,19 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
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
@@ -2588,7 +2602,8 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	if (!direct_io && nowait)
 		return -EOPNOTSUPP;
 
-	ocfs2_iocb_init_rw_locked(iocb);
+	if (!iov_iter_count(to))
+		return 0; /* skip atime */
 
 	/*
 	 * buffered reads protect themselves in ->read_folio().  O_DIRECT reads
@@ -2606,8 +2621,6 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 			goto bail;
 		}
 		rw_level = 0;
-		/* communicate with ocfs2_dio_end_io */
-		ocfs2_iocb_set_rw_locked(iocb, rw_level);
 	}
 
 	/*
@@ -2628,17 +2641,48 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
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
+		if (ret == 0 && iocb->ki_pos < i_size_read(inode)) {
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

