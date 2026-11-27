Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795750407;
	b=XS2ROE5Du2HWzy9EbpgO3L6pZ6RUO8vByQ2o9lD2izunI5ADNJ92Helj3zKDbTuY+2h2
	 SbYegD45uMVxuFoDttiR+Y7g3ff41P0rRVmYewkDBJmP1WnTR3gQNklAAHZPnvYinHYiC
	 wi8ZJwH0F3L6IQh2thTfwDGgm2IoAO8Z56MLV7cbcsf18i0jlzxhoUlrq9OSSufq32DmU
	 qzTFaWtDrWi4FRPSycBrt+Fro4p0ZQc1J6nmoZEh5mTFD+IIk+yEVi6EeB7beXWhYXCx5
	 kP7SiRiT4rZY45Dhg4I3tpmTjtFoyBwSal2FExUEQ745fZEaoTR7ZguCV0JL8hJYC7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795750407;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
	b=E/f3vpCMA93QbOPkvybkEx6yrH+T5RGBAGneDGia7aS1IIhtBF+iBza9PowMy9ZbD7Mc
	 3Vt0VNgG/eRJGNcjNoSnL7QXoEwrocQ7snpK2y8lQ9kqPw9+l1o6z4U4EBTpzr5YZoLQq
	 eXQzmi3zgFRQ/kAwj/ahz4dIzeViqZyCUO4hrPm33KcEQQY/gWNZ2J6lDET0lLNOkxA0y
	 P1vwd8z1iWFqh8aY22Uybk9HkpntvH25gmcFp8P30eLRmj6Yw5HflP8BxLfnmBd81uEaI
	 gcufgeJPsACTsHmUP4UgQI3QMQ32pjkkR4T5nE/3tgG+xBpYro7nOUF3/xx5PaAsukA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bGDXlmGP;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E86C606A32A
	for <ocfs2-devel@lists.linux.dev>; Fri, 27 Nov 2026 03:33:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E86C606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bGDXlmGP
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c499b5be0f1so106911366b.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 26 Nov 2026 19:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795750406; x=1796355206; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
        b=bGDXlmGPL3gynepwI1OL3RsdZSLBNO3IOm5y5xlX0SRbLlp5xLctbL+EXnCgG4BRtL
         juoGxyUw0qY6ORlvOZ8+VR8KpdCZMHYM/GNA/SIRJDhXVNS2MEReQ1kKldra3lhomZeu
         Uzx9Kj6IOTzi9LQsTpCkM1m0DQ7IIb1kUDQMP6GqpGmoz0eEijhcY7rsgpgY6/vS4IP7
         SwwGzyOMHsrYvYiafbGbKXCNlzHnYx7KoX+pM41vrWKpUjfcUtripdByYQ4t94tvblP4
         VUXxCWfZpTWKirp4sEBfyStea+Y0xy0xMESxEf7EdQgnSvwRCWzPX0BAdB75xGEbfaHa
         lL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795750406; x=1796355206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
        b=27aA9azAEcY3xdT4lEmak0PcvTpiOQHqnTyTcaF1KwTjCkU+4wHfH3606dXHlPWSvL
         DD8n7BujiC9sn/0FBi5L9Am0QrL3hySkGEE5di5DegNV8dpyRjJJ62G4hUO2d5Z/W/VX
         pNaM+2sU2mJCaJ2rsWYcG38vYtUW5dy4D5XdYezYPga6ookUdPuezSu3igfVQ1vjMh5P
         TN8w5u4FnFuUV6s2mHAjqMfIvNE7/Bsvp8EJ26WU2wpwvv2p2oVNy072r3r7qOrkirud
         x6xekXCxYHCaLcGdX601BJ8GOK/DZVFSAbesEg0K5wXOEQQHMTiO1cJb/ijgyVLqlr+5
         /uRQ==
X-Forwarded-Encrypted: i=1; AL+hErHvfDC84w9+5WILmqeXTZfRe0ADSFUBJsytZak9G9HLbOAswWj7P5gqaW631byx0L+bVt/OOSscWrKSYw==@lists.linux.dev
X-Gm-Message-State: APuU4Z+TtJ2LlWeAMCXznoXhjgmspT6UEHm4yQsSETOJNHt9hOYss2oo
	KfrFWORKhhLKBowO+dXqIhgo21ByETWTooQD144SYcX9rdgcdmrVXNcP8eFPFGK0bMc=
X-Gm-Gg: AZFdTZdZXjyRj+Jc2Pga8dBk+Wk0bzZo59Bisu36q3fyxoJ3z4d+m7f2bFqgZUR7sp0
	xyyKsoafQkJAsTycfSvROEotULx40fPqxboowyOvbzXY6/6ggYimAgEEbaL6dg3Lj3pd3yztMoL
	0rzmxNIF5Ul/DutkmDjCuTx1+HNAZEpUOdsL0l/HMDP3eR8jgjG5VDp52U6e+rC9W1HwEpsgRxL
	0/5hXbtJKQMPmnaQXDxqfyBFmzyG9XREa30jwovrkVaFqz9xlplhUaZS+gTjT75s+dzePbRXgey
	H2q0wfxnwWkiKK4yCYrV+YOCfprMCsGfigbsE0TYj6GxoesFbSsBHVxHBSVNDP4lOy6CizUJOul
	wj6gtUno/p7no/26c18UgmwKzK0kprbDC/E43dQ/mH8myR7MlzfRM8GT7rYaSqvrGM9DX3HO4M+
	PCEthCI5bsk3NyQ2lWzBXmlTO20lztvCSifFwYkxzCuOshkgNQoi0UufLiCurFJ+09kPLa8J604
	R1sehqUMgdHbI17BVsAQ3OxNCSmbLQsL6l4qhPxOMdW0XR6p7B7A459MFjc6MR7A35RZo7i03mf
	ejysQ9yLXqjLKrTONqPAQqzRUC4XEQwAI3uJZgz2vHs=
X-Received: by 2002:a17:906:26c5:b0:c51:3b84:6fb8 with SMTP id a640c23a62f3a-c513b84886cmr1663789566b.4.1795750405710;
        Thu, 26 Nov 2026 19:33:25 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d135e9sm38375797a91.4.2026.11.26.19.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 19:33:24 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v12.1 1/3] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Fri, 27 Nov 2026 11:33:10 +0800
Message-ID: <20261127033313.9169-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261127033313.9169-1-heming.zhao@suse.com>
References: <20261127033313.9169-1-heming.zhao@suse.com>
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

As part of migrating OCFS2 DIO read/write code paths towards the modern
and performant iomap framework, here introduces ocfs2_map_blocks() to
replace the legacy, high-overhead buffer_head based block mapping
routines.

In addition, OCFS2_MAP_* flags are defined to bridge OCFS2 internal block
mapping flags with the iomap API requirements.

Subsequent iomap integration patches will build on this core block mapping
routine. The implementation draws inspiration from ext4_map_blocks().

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/aops.c  | 70 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/aops.h  |  2 ++
 fs/ocfs2/ocfs2.h | 25 ++++++++++++++++-
 3 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4acdbb70882c..64fcf6eb3d89 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -126,6 +126,76 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
+/* ocfs2 never allocates in this function */
+int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
+		    int flags)
+{
+	int err = 0;
+	unsigned int ext_flags;
+	u64 max_blocks = map->len;
+	u64 p_blkno, count, past_eof;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	int create = flags & OCFS2_GET_BLOCKS_CREATE;
+
+	if (OCFS2_I(inode)->ip_flags & OCFS2_INODE_SYSTEM_FILE)
+		mlog(ML_NOTICE, "map_block on system inode 0x%p (%llu)\n",
+		     inode, inode->i_ino);
+
+	err = ocfs2_extent_map_get_blocks(inode, map->lblk, &p_blkno, &count,
+					  &ext_flags);
+	if (err) {
+		mlog(ML_ERROR, "get_blocks() failed, inode: 0x%p, "
+		     "block: %llu\n", inode, map->lblk);
+		goto bail;
+	}
+
+	if (max_blocks < count)
+		count = max_blocks;
+
+	map->pblk = p_blkno;
+	map->len = count;
+
+	/*
+	 * If we see this on a sparse file system, then a truncate has
+	 * raced us and removed the cluster. We treat this as a hole
+	 * and skip setting the iomap flags. The caller will set
+	 * iomap->type to IOMAP_HOLE.
+	 */
+	if (create && map->pblk == 0 && ocfs2_sparse_alloc(osb))
+		goto bail;
+
+	if (p_blkno) {
+		if (ext_flags & OCFS2_EXT_UNWRITTEN)
+			map->flags |= OCFS2_MAP_UNWRITTEN;
+		else
+			map->flags |= OCFS2_MAP_MAPPED;
+	}
+
+	if (!ocfs2_sparse_alloc(osb)) {
+		if (map->pblk == 0) {
+			err = -EIO;
+			mlog(ML_ERROR,
+			     "iblock = %llu p_blkno = %llu blkno=(%llu)\n",
+			     (unsigned long long)map->lblk,
+			     (unsigned long long)map->pblk,
+			     (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			mlog(ML_ERROR, "Size %llu, clusters %u\n",
+			     (unsigned long long)i_size_read(inode),
+			     OCFS2_I(inode)->ip_clusters);
+			dump_stack();
+			goto bail;
+		}
+	}
+
+	past_eof = ocfs2_blocks_for_bytes(inode->i_sb, i_size_read(inode));
+
+	if (create && (map->lblk >= past_eof))
+		map->flags |= OCFS2_MAP_NEW;
+
+bail:
+	return err;
+}
+
 int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create)
 {
diff --git a/fs/ocfs2/aops.h b/fs/ocfs2/aops.h
index 114efc9111e4..8dd6edd7c1a1 100644
--- a/fs/ocfs2/aops.h
+++ b/fs/ocfs2/aops.h
@@ -42,6 +42,8 @@ int ocfs2_size_fits_inline_data(struct buffer_head *di_bh, u64 new_size);
 
 int ocfs2_get_block(struct inode *inode, sector_t iblock,
 		    struct buffer_head *bh_result, int create);
+int ocfs2_map_blocks(struct inode *inode, struct ocfs2_map_block *map,
+		    int flags);
 /* all ocfs2_dio_end_io()'s fault */
 #define ocfs2_iocb_is_rw_locked(iocb) \
 	test_bit(0, (unsigned long *)&iocb->private)
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index e3bb3cc0b25a..b4583b3170e2 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -514,7 +514,30 @@ struct ocfs2_super
 	struct ocfs2_filecheck_sysfs_entry osb_fc_ent;
 };
 
-#define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
+/*
+ * Logical to physical block mapping, used by ocfs2_map_blocks()
+ *
+ * This structure is used to pass requests into ocfs2_map_blocks()
+ * as well as to store the information returned by ocfs2_map_blocks().
+ * It takes less room on the stack than a struct buffer_head.
+ */
+#define OCFS2_MAP_NEW			BIT(BH_New)
+#define OCFS2_MAP_MAPPED		BIT(BH_Mapped)
+#define OCFS2_MAP_UNWRITTEN		BIT(BH_Unwritten)
+#define OCFS2_MAP_FLAGS		(OCFS2_MAP_NEW | OCFS2_MAP_MAPPED |\
+				 OCFS2_MAP_UNWRITTEN)
+
+struct ocfs2_map_block {
+	u64 pblk; /* physical block# */
+	u64 lblk; /* logical block# */
+	u64 len;  /* number of block */
+	unsigned int flags;
+};
+
+/* Flags used by ocfs2_map_blocks() */
+#define OCFS2_GET_BLOCKS_CREATE	(0x0001)
+
+#define OCFS2_SB(sb)	((struct ocfs2_super *)(sb)->s_fs_info)
 
 /* Useful typedef for passing around journal access functions */
 typedef int (*ocfs2_journal_access_func)(handle_t *handle,
-- 
2.55.0

