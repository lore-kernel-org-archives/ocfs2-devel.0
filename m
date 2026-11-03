Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709812;
	b=LHEQ6szGclR0t4Z4yCygo5zs5DM0KcR2ItZ6cU8glDP/F2s82rkx8tzM4wjDc6qt9+Ua
	 /b+owctFeNzCDHb8pU0+Cyp8jh3JjUQKoLoaw1kuSiqJ51NIvjPzrPsU27lAo1+7+8PUh
	 VceNKw5WoWHHkkLUy5uZiFZKS3pide5IaJpy4/ReaX++u+xVi0XiYFpQ/UyRRj3wPZ/rV
	 srZlxC7GzzgWrwDvvXDgAsWiDcTQtetziagO7Jf3ywkczXOpG39k2rE65vXCdCib9+Zld
	 Ea5i41ps88ev0uN3cytsn7cg8IYbtsHGbyXTl3yNi3y6eQPIhWco5no37V+cT7TM00Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709812;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DCLd7TRXzCn3mL5Wl/Pe+4SxUHjku1pitRL5m10Az5A=;
	b=TqOAocefTNTfjqSNKnGIPfoRlxzn3aPUsMoussWCnAGdgQzQxMqmNXKvU/IORYq0cokM
	 UdtJI80Mpc3q+zoiR+qrbjRCTb5QobF9UPNNcN2h+ttx6gxpi6KaSFjOjN/RlbNV4eLCm
	 FKLtTMD+K0J3PEqUD4oE0CbqmDP8o6DwMa//nxB/Qs+b/+oIXSJroYT2xXrpIGmnRgu2o
	 +XrhZi5C0gcPXcBPdOMUpM7E4OnvpR+YLeKfJ/WaJ0Pi2dgFG5kuI8dnoXoy+g2h9kjfG
	 y4dnk/MTn49hA8O3FvpNsQ5zR5x1EllPrng66V3U0e4jz53ztfDBsvkQYoxG1DMVV7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=APbHsCLD;
	arc=none smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C79606A324
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Nov 2026 12:43:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7C79606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=APbHsCLD
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6aa77d4d968so1063992a12.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Nov 2026 04:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793709810; x=1794314610; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DCLd7TRXzCn3mL5Wl/Pe+4SxUHjku1pitRL5m10Az5A=;
        b=APbHsCLDy8Du7MVcFwAe5q0xwzJDdOedsuYHRX1qUzQSqZADgCXgC1DdTV+IhkA5TT
         KxmLx9pq7VpnVBQYGRnW3VfbEaXCP75Oq1uYWsP1OT1yJ8th/iLmGS+xDvWGZA2953Qs
         lqsFkwDgsuQWxGjC9I0FX6BcIX9BE6WQhAvyhjt05fEtmgXaNbaEa0cmiDTeMwO0b0sG
         GPzOU65aZHboJuZTaL+qJ4fOi5IzOQnBaeS8Ldw6+GZdvepoGnKrnpgIQBR5AiFhSJKT
         c7zebnmDZjtvgWUfNIlG2TrjuBB7AROJBGOMZPG+FcTAGEfDvcwdIKX2P3qf74Siu1SB
         WJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793709810; x=1794314610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DCLd7TRXzCn3mL5Wl/Pe+4SxUHjku1pitRL5m10Az5A=;
        b=0JEAmA9XCXAPbf6x8P3JeMiytCv1l1PrVaBPKPBR0a84uKR606lbk0GaV+pCZtj+YE
         rC7s8mCWH+dJ/H4iUjzMDN7z+/hlir/tyMr1fy3EYST8gi8GY5fz74/9ZDixKb7A+LCX
         eaC7fW9vNesYL69nmBdsEnfKxO+JGuS+pVpoUsbi5CCY3cRsddFp5dA67zLCAbemOLRJ
         Ki+xa5rFH8O5WMXpqHoaSLyPhw5KIoWouJPdbCl+fHfSrnkm6N5Ycd4slXBL5MzIytPk
         I7ZZ4MtGtFym30JFS+RNbAxkA0/QNxumUBqCKhIqd2wzhyJPYawfAjk+xXEe+BfjmfeE
         VplA==
X-Forwarded-Encrypted: i=1; AKwUvByPBBG6NbfQIuF4f9vxgOjv5zgIS8+GN00bEg/tbJqTJITCVbYsmE/EeSrr9lpi7a+3Z+hISwwpe9dHIg==@lists.linux.dev
X-Gm-Message-State: APuU4Z+CTG//DgMWruBaRGTzLnfuBvekQk+uO1punavAErsvMGYA/WwA
	EcxpH+T9EA/A95Htp5Cu51MQdSoRRBT9gJV5TYU0//F4OYuT12Jb4/0C6SjdtsbHN/M=
X-Gm-Gg: AYBFou0Fxj5e4eSaF2tL7TVb5XGviZJRYRXtIUOKMNR1VwNuicGxuyRYDv3n0Rpfqcc
	RNUQadJ/UP2+LF/CfQW7jnJi0RNjjmUP5SolSQof5iTq93dn1VEZO3XYqzr7YT5OO78shzU9M5F
	qufuvg8L1WdIrQ3aa83ztGb2ywLSPima43FxOnJvcYlVRzre3AQkmEASGf+EEnc1iOoxw+bw52+
	Nq/mUxYPlcg6S/ddblq5iW1U+1Ewfxa1KbbBXUxU6iFbHFqB/FCZ13U5HusT2VyxcAq8zdziGQw
	IPWBlzXohPJ6x9JxxikO95Hxw/CV/JMD2EFR3SFf0aCu/nl5i2PlIuyj3ht6KrgmY0YHVOnyp9w
	OQV0j/gVTslU3mkgRHsP1MQgMQEioiB2wzKAyzTa7XWFtLGOIF0q+6plqHng7wJbkznVsyaHVj8
	5vSViNW0NlgT0yXe7D3/N7Cf+R9uoYpVRD75Q7z2kFE9m77qQDlihRpvYh6W1d1A7AGRvswYD2+
	UIcp0+lSno2TsP/Hq4755RAd0e/QNStVAkrFIMEJ1aaWXWNop141glgmmH0kgrzY5fpOWo4yZBS
	9tqbLpBZBlr5lSrffu1hLMRViqp5+Y9/B7KLy4M5rME=
X-Received: by 2002:a05:6402:a585:10b0:6b3:9a81:dd24 with SMTP id 4fb4d7f45d1cf-6b4d337beefmr10190624a12.1.1793709810165;
        Tue, 03 Nov 2026 04:43:30 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c8460acsm4365014a91.7.2026.11.03.04.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 04:43:29 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 1/4] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Tue,  3 Nov 2026 20:43:05 +0800
Message-ID: <20261103124310.21143-2-heming.zhao@suse.com>
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

As part of migrating OCFS2 DIO read/write code paths towards the modern
and performant iomap framework, here introduces ocfs2_map_blocks() to
replace the legacy, high-overhead buffer_head based block mapping
routines.

In addition, OCFS2_MAP_* flags are defined to gridge OCFS2 internal block
mapping flags with the iomap API requirements.

Subsequent iomap integration patches will build on this core block mapping
routine. The implementation draws inspiration from ext4_map_blocks().

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/aops.c           | 79 +++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/aops.h           |  2 +
 fs/ocfs2/buffer_head_io.c | 12 ------
 fs/ocfs2/ocfs2.h          | 46 ++++++++++++++++++++++-
 4 files changed, 126 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 4acdbb70882c..c612244690a1 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -126,6 +126,85 @@ static int ocfs2_lock_get_block(struct inode *inode, sector_t iblock,
 	return ret;
 }
 
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
+	map->flags = 0;
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
+	 * ocfs2 never allocates in this function - the only time we
+	 * need to use MAP_NEW is when we're extending i_size on a file
+	 * system which doesn't support holes, in which case MAP_NEW
+	 * allows __block_write_begin() to zero.
+	 *
+	 * If we see this on a sparse file system, then a truncate has
+	 * raced us and removed the cluster. In this case, we clear
+	 * the buffers dirty and uptodate bits and let the buffer code
+	 * ignore it as a hole.
+	 */
+	if (create && map->pblk == 0 && ocfs2_sparse_alloc(osb)) {
+		map->flags &= ~(OCFS2_MAP_DIRTY | OCFS2_MAP_UPTODATE);
+		goto bail;
+	}
+
+	if (p_blkno) {
+		if (ext_flags & OCFS2_EXT_UNWRITTEN) {
+			map->flags |= OCFS2_MAP_UNWRITTEN;
+		} else {
+			/* Treat the unwritten extent as a hole for zeroing purposes. */
+			map->flags |= OCFS2_MAP_MAPPED;
+		}
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
diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 7bfe377af2df..493f2209cca5 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -23,18 +23,6 @@
 #include "buffer_head_io.h"
 #include "ocfs2_trace.h"
 
-/*
- * Bits on bh->b_state used by ocfs2.
- *
- * These MUST be after the JBD2 bits.  Hence, we use BH_JBDPrivateStart.
- */
-enum ocfs2_state_bits {
-	BH_NeedsValidate = BH_JBDPrivateStart,
-};
-
-/* Expand the magic b_state functions */
-BUFFER_FNS(NeedsValidate, needs_validate);
-
 int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 		      struct ocfs2_caching_info *ci)
 {
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 62cad6522c7a..88fe985e87c9 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -509,7 +509,51 @@ struct ocfs2_super
 	struct ocfs2_filecheck_sysfs_entry osb_fc_ent;
 };
 
-#define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
+/*
+ * Bits on bh->b_state used by ocfs2.
+ *
+ * These MUST be after the JBD2 bits.  Hence, we use BH_JBDPrivateStart.
+ */
+enum ocfs2_state_bits {
+	BH_NeedsValidate = BH_JBDPrivateStart,
+};
+
+/* Expand the magic b_state functions */
+BUFFER_FNS(NeedsValidate, needs_validate);
+
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
+/* useless? #define OCFS2_MAP_BOUNDARY		BIT(BH_Boundary) */
+/* useless? #define OCFS2_MAP_DELAYED		BIT(BH_Delay) */
+#define OCFS2_MAP_DIRTY			BIT(BH_Dirty)
+#define OCFS2_MAP_UPTODATE		BIT(BH_Uptodate)
+#define OCFS2_MAP_NEEDS_VALIDATE	BIT(BH_NeedsValidate)
+#define OCFS2_MAP_DEFER_COMPLETION	BIT(BH_Defer_Completion)
+#define OCFS2_MAP_FLAGS		(OCFS2_MAP_NEW | OCFS2_MAP_MAPPED |\
+				 OCFS2_MAP_UNWRITTEN |\
+				 OCFS2_MAP_DIRTY | OCFS2_MAP_UPTODATE |\
+				 OCFS2_MAP_NEEDS_VALIDATE |\
+				 OCFS2_MAP_DEFER_COMPLETION)
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

