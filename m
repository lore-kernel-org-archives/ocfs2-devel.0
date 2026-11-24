Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795496116;
	b=EdwUOcLrSbRnGNlHtSRh/aOx0X2kshgJBTImJwiESPXkeWexPJ+PfdIwZOkcrCCAR54M
	 Xq5DkciCmNRXgpTnTcjwydLt75RY+sozdGjOV4f1gLFYuBwdpIVSjm5RsOUgVKTYltTMw
	 kRl4OsVeHJUEl9S8HA6+ykcMN96URDHVpxJyEE4BhG2R+NGDqsNav7aIgaKw8u138t21+
	 tP5WLbysdy83Tm/vg1L1SRE307JcaVjz0y87Gq633EqvLIAw14Hs8ORqQOZ0ZYmGm/cHg
	 AW+G/jAy/p0BxRfDT832sf/MEnPMLe5iKhxpLwKjpzI1uUBz46chxOZsBKojxvjPdHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795496116;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
	b=4c2HAlulmcN710pTwvUWwUDzpmPLhBVQ1dVK0KG79BSOdUEbVktzXZl2gfMcJTuW4f/0
	 RWJLNaPTtaPi5dQ5XIbsbq19Od0k9TBGZlVheX29YXBNA98+GVmVhmy9KwLIl8i1pe5rK
	 faXzWiyeNz5J0okJhnWJuyjjC/fZqlriOuNOLRadHMt0QKI9HRxHBaITeRCe9OoOYGnwR
	 qgq3pga0ZhBPsGGJDgJIGk992YENNb2tZdXlq2niSHJ5DHS6Y6UFsllpQ/FvQ7GVCBUfD
	 U2qljlqS3pK9W9fy270gsHwyErUW3Mt4Ax9hOHmBfiTxSrurEpDuz3qTb7pWOpvk3Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ctr0R0co;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A426E606A322
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 04:55:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A426E606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ctr0R0co
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b896db8f9bso325421a12.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 20:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795496114; x=1796100914; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
        b=ctr0R0co8Gq28/2MlFyhIH2MDPMkogmh+csnUC2bMa40WkRc57qLFsOT7ad36x7WxM
         Mt26EMFJw2OyrQSqhtmt6vOTvo93Q1Ea8K+VgviUkfRcKS5ttlsShlshNF2Fbr8zrDtg
         cfAHuIbX9rk/Vg3aOeZbz/go6+2PgV54szg0ETI3owst2xaEwpzkp72PfgjW9sMnpNy4
         XHpCRF1KDTOSxcTjuKLDLqNplgO4Z7eHlFV6d5u8ACqDx7FjgvwL+oV8CzyOksnCWg0H
         VBDb4UtU/4V5v0jRHBl/rgiSROdPydG7Df/5YUdlgrhd6yhahggoiFt1uC83WSymWzyC
         bjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795496114; x=1796100914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
        b=1rjfYod183t2byt8TlWVx3lTGlK6I948xn9fwLX20ng3vqHTYlXyVbS7VRma72WiQt
         kFG+Frshw1a6ettN1s64SMyQgG+VYH2/h6qrJSPVXSZElnFBn9zJLWM3E2kDQqFLbJVA
         gvevavEDABZWxq5Htd1dbeEI4iRuL2RUFXXdRsera2r8TO7hp0zxlnAVR0HOaE/VkHhh
         oaiGjMAW/C1P5sqoHnEBTpzqOUSs0l2KWxa8wUBD/wfZOVZsy8qVVZCJj6NmHBSGclcV
         VcHqUfRrKFyGWfYXS8/5RohS+Cf/Ln1uBVVUGRN0G7uj0a7p3UneWMOM0pyJJSG7gDqo
         4B0A==
X-Forwarded-Encrypted: i=1; AL+hErFpQK0XpjzF0k+kcc/0j2NJP/3WRJ783/ucdCDLpUQc4LdC7OEkBmtMpAPqfvNXffLnGM0WsjaQgx5dcw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/odDCVIU8gIObJu9GL3RZTP7Jf6T545K0X+k7HVXAXi0oVTFp+
	IEqId26d3pfCPX9mcJpMS6Bo7Dvy46s5FtZdOtqH/yT1S0GD4j5MtHRh+GEt8xOMgXsORMHBEYk
	3X+coye8=
X-Gm-Gg: AZFdTZd91AUMdgg6tjUEZPUakhVnrPXTFgdnnnZ/+KNZwWzCsVtiPHhCi5dm7HsOQ8L
	3c3DS3A1ZbWyR+aAgbzHWlHqpipeMoMLY575YZm7LI5ZlncNyx4143YInYGgGm3Rvr9OEUM3iyH
	drMnmMsD7c1P0IqEN/wsqDgFMtgf31AkBtYT7aOH9MjGegNNqEX5LHbQfnJzJXok/Xiy2o1qyZp
	scxGVxReP1ZqR7428zMVPkL4AEi854o+kI+VjjqWsgE6UH46H4FI3TRAg3d0BfDdyEWGzITJahO
	KHj1iQSppYiwHogI88zqpBGnhgPI3S+ajNxh3yFE+QwyFtiklxtyXWNYIZxrnvS3dPNZbqjHJKK
	paYRQxI35qZz4NCeySG/8SATHZPQPFN74gwaekmom0ytVHCXQx01ZDXAo5apWy9J+3HI8Ga+OVS
	aFqhugsk63VsRpnLMdQ4i4k9WBnBNBhKb/BECHpHZ4jbsWy3KNM/RJ9bxPfC0d5+2UQ/kqvzYRw
	fVBcXMX0wEXdIQPRkCVT1n9+7jxpp4hx+Xw5zE7TH3mEMoeeO/A+ffbqjhJZmVslNe+xuQo2ILD
	CMyNxPSw4AcLbkTHDHg4S/Opqsa2oO8ATYyL2VGAekA=
X-Received: by 2002:a17:906:3513:b0:c51:3808:8026 with SMTP id a640c23a62f3a-c513a53d964mr993256066b.3.1795496113042;
        Mon, 23 Nov 2026 20:55:13 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe23sm20989085a91.15.2026.11.23.20.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 20:55:12 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v10 1/3] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Tue, 24 Nov 2026 12:54:57 +0800
Message-ID: <20261124045501.10281-2-heming.zhao@suse.com>
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

