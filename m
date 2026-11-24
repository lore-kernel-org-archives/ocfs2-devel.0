Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795534002;
	b=ZKvqakb/f2vRN27k72XaPjyA3S4557uNcq8PIYBkFO0Oc97390vJGJfZb9qM09sa7kz3
	 Q6Jr+H6SoLPFrK9kijJTaIjNCHsfqJkqft8Pw5sXfikfxFBBgoEPveL9r3zHBa0F85miQ
	 n5KreBs59vjZA/cfNPRqRJB/S9HEPNVyxexbp9Crn7qRWTcuoKst09UM4rniY8+YtHBgo
	 Etf+5b+s70xmKkf+qnHczZ7LINIOw+VKEZK8otxVcz7bANf8NJrUAxrxebJAuQp2BpCqw
	 Ne04ZsStau7xsJDfOQX7o0m02AdxFU5UrDo75wpdLdXTfRmL4p3gbsMbf3ZUiVN4UCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795534002;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3XfKcymPSGYY/hb4/CxUw8ruovTcqp8sS67S+DyuBX4=;
	b=KntY5VHCO0Prb83W+Fq4xa0D785lkMVzxxV54S+ls3hL+Kwi+GiZkBZw5irwEI1lsUgh
	 7xXLGRNu5j7pS7nlZbZJNx6iDOn24Qgr5e7QWQ/bYfRpXeKuQarVPnZykkqmkLV8Rdb/d
	 MD/GIKvLJBNE+3GimLaE/CRKYoRf13PoK6D2v3rrSp2Ei9+BDN3x5k9tq0mA/smWKBGe5
	 TCO8pn+4RB2JZR7GDMzCQYvKnYqCNh4a9c/FwV5b7X4BOgp3Bcfih9v0vy7KJAJqmoH0F
	 QE6KgdBni4XkPeieSmIKtjJzvD0oK1wamz7q8PSClE+j7AcGM9tniZqHKCQzoz2ebVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=glkjlNQH;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DC9606A32A
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 15:26:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5DC9606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=glkjlNQH
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c5187b42a2dso25412366b.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 07:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795534000; x=1796138800; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3XfKcymPSGYY/hb4/CxUw8ruovTcqp8sS67S+DyuBX4=;
        b=glkjlNQHc+ZAJp82FBwKKDHHZqrE+l/hqhNMkazg7AfSNTOB3lDd1BsqJXfyzVneXq
         CecVMlOrvGbJsH17s+zquIqT/abCZbY4czG8RnouneH7MnbL+vQ8KfTZZA3A0AlbvJ6l
         DY6BFNs5d2woFx2i47weOOZzA6fs/sXTcsR+74NOjSnnMI8Qqxz1Ku5JARo8qQbRIzL1
         AjB6rJ7xR2I4NdgP8puwt6P7MjAx9uczAzfowFsggd77grVk78xZceR0lvIc+TKp61DI
         9rFFKfgS1+BGd1W6uCwAOKmWcycw4fy8uhMH8VgVBbRy5hCxdpz7CQ2xujI4scj3h4I+
         KQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795534000; x=1796138800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3XfKcymPSGYY/hb4/CxUw8ruovTcqp8sS67S+DyuBX4=;
        b=jouElTneKYrXXSlxFu1aTnROhIuvw38Xm88iSy8TQYrP6MTQF9bKduKI0y3BmN0r1Y
         A9KsmO/qbwTwsd0z4INbdoNbbQDLMgq8B92pt1N53MuB1lJot2vSndcyq9ZO3HTwc06g
         T77gculcBROiKJP6YbJ/+7vxilgIyfuYv500T+TWu4KiBepslqtidkG48+ukC0GMJZSV
         WnC8HB1xmTlul7BgnkBJ1BiuRSwAxUrz8SZdgLDu3OpeJhd36VPyWHRI67dpLut+FEHy
         1kzdpLGxzO19nhFFMk25q6nCK9Vof3b0/F9bPGPq0M7AYPXtM9IKkq1xqEQCFJvKUhGT
         smDw==
X-Forwarded-Encrypted: i=1; AL+hErE0mv3/3ZrKOknsc1XLJf4hSZ9+yRhvbxH2W312lej4zqHMiTFR0d0/ozrp7wdYxeUDncaUAPVsLZ1yNg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+XPC2iSpxKsP5Xe7+m8IwaH0OdFcTyhhjkJGJmirUQhSHj41H9
	aB0mgPSzYW6CS0EGKyir8fah4oWEeX/dGOOMxaYyhjbBJHvPVVSUNEXOq2nJ1WTy7jo=
X-Gm-Gg: AZFdTZevXyugjRwj5aC/AQsuXewh1xsS2I6YdvnBEFQNso2qMaZksx3sCqf1wUPyJ8a
	uIbDSjA6OHd6BgAoI6eiQIqbE6ThAAqpJDZeVmGZMvpb5bz5RZyDBRv4Dl/8LxsNVNT70gr8GMA
	YVFQGG3aNnYTa/u0jC2b9KczXUzOugDTYZPBhHzxWBzdiXdRT63rXGxgwxJcV30iAPHDkrrLXKk
	D98jBoLpCLBhGai7jWf8M1S5cIQT9B/4Tef4Xgpf9efMm4wXttOsKIHlQShwg1e7kR7BHFZlmsQ
	WbcQxezddUs2kXnMEc2PkQyASG1dpnM6yJxdlRohRqPjxRGQGhoe9JAekFWEqZXjo5v9A1ygl8b
	SMzUqzeMHiLxb67/wHc1eEHi8BroHMNP9UIzqJyRm/QCTaXYc9ih6dqMXKksgBImAv5ADBZbjmB
	mc3W6BssrDUJP6Q4ZV0Q0AWk1HoWVBMPVkHopKIbjQCmy9BqV7BquyN7j+uR6qLUPq4MUr1iuYU
	AAOeCJkheC15sK18aDEP6jclUunsoVesD1WKH1FWYYBUVvanAhmF2SFE969LpR7UquLwhM2nHhA
	13E3nZiI55r5Ge+le7tiXKhOqF/YvNJ2EGjZbTd9Y3KWSv/LlUvommdwEm7FcYPF
X-Received: by 2002:a17:906:68d5:b0:c51:4fd:1aef with SMTP id a640c23a62f3a-c513a50ab80mr1185344966b.2.1795534000041;
        Tue, 24 Nov 2026 07:26:40 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d0575d9sm7182425a12.25.2026.11.24.07.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 07:26:39 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v11 2/3] ocfs2: switch DIO read path from buffer_head to iomap
Date: Tue, 24 Nov 2026 23:26:20 +0800
Message-ID: <20261124152623.7838-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261124152623.7838-1-heming.zhao@suse.com>
References: <20261124152623.7838-1-heming.zhao@suse.com>
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
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
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

