Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795533998;
	b=Ec2tjLEZ2VxElzcav6uKBgELI2wLKvqJWdCXLkJymBvbAe2i7sZCFj4/FxZVEiGNvZAX
	 R3RY34tQbkqVTIwwx8G9nWMaByMxxfa0IJNu05TwMqhRpQJtigZs/6lZwbscL1Dyd2cM5
	 gto59SGyvD0S/Dk8QqgzAYDPhjdTvx8nyfjwzmhtfS35+OfGzIBSzgVXdvV3DtX345E6b
	 C4mgeN8IO5uuvHv2zlRD+8icfjtjPn4GRt74uPlUK+F3UPfQLRo14vIpBub4/Hk97uxop
	 x12SDCy645n5GXj2VOQz+z1W/VByB6742Ol5VM6aDpo1RNfVdXPuP0cRDXhEBkq3iKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795533998;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
	b=Ig35HpfKVYF4pExEgG5sbHJFyAzGyQ0R0KEcHpxBLdG+V5yFmnz4vfWggugd7Eg34sN7
	 zPjusjnIHKzNcM38jrueU1QtGy3/zba7uP1k5s/kDutO9Ji8Qee7p5FaiTDW293mfdxYU
	 H1+AKrLCllJ+PhviZGzLHLGaHNHDGyG8NQrPehpHamyyXl5CLRVsoi4pPrfZaIGMh3SL6
	 j7Sc+8cqvAvqfV5pzHJnkD6AS17wT78CRTFpDPYVuRAu82L1nnLhmK0FxRBUoyK/Hoj4G
	 yjf+4XV8urb7KM8vqhld0DiUxLXyStL5grvZ9EuUY6+QMoK/pU4Lwde1FJ5kIgR7WtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=XpiFbMz8;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A007606A330
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 15:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A007606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=XpiFbMz8
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b896db8f9bso402009a12.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 07:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795533996; x=1796138796; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
        b=XpiFbMz8jwCcwEg400b5HwTjwSNM65tqbhjL7uPQLLQl3PL2Kg/qokfjwtznZm6O/0
         CACHEyEpMXVC3rAADiLDD+oL9mM4LMpq4WpBz/WQk5B/2I0W6Zo7P22nrngRm3oDtwk7
         bjAs9zs9eh5SD/7iPsxTW9XYKV32vjQer4Znq0fh7znoasjT59MyLSdBgxevD5S6cZzt
         CRLPA9VFC417WEkMcgmSoBsgQzAyIanMQv64bBSrmoS6EtgoBsqkNuehouY1FdeN9GjV
         z4ucEOoByMTWjncEy4I/LezzTaIM0HkK4ImCsxZt79Qgs8ABtr4dw1If3Pi4zQ+zLAbP
         L1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795533996; x=1796138796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lE2jr+C/a0Ay10r/FZq0822Qad9kjX+tBe/cryvO/EI=;
        b=Vcqka7CVwIt0+M0zv2kZFBTvCdnD7lRReM9a4nu4P6JOAOWLEi4h0cMR/UYYiG81Oo
         KYDrRLjRDBNx84lNQsU8jhlTZal6R6fNkqeskBTduI2xGu8gZvOjUXzq4AJ18QeUOxzR
         lUuOX3/Lb0SnUmOuILgiSPM5JCaDM5h4cC0JunLRMbqu9FDGYFYnnZ/iiyfoyoWo/9LU
         TRAQxD8TUnuKnnNHXe2aUV47QdE4c0p80okH8r0DduuTeXU4h3pFK5oWzsvCm+qXGzWk
         nYsyyNLWijnGFGybZqQbp6/tTX+dG/FYyOW9gy+XwDfXs53DHcVxbKbBvcgU1GWY60dr
         936g==
X-Forwarded-Encrypted: i=1; AL+hErGE3yiiyzl0ZxiEAlTFv/6bx8q0ILmP5lxxZoGVZktmSPSIKDgE4MFY+Z7SfH8QtWwHp8ljVPZQ7H7SzQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+qYap3wpXEggXvM8Y+VmsaWebyYNar9kQGFEdxJvX8DW9LtJdJ
	r4GKlG0OSD4n8SoptEcnOehMIUAgVCRGAbtuKNhaviyr/uNik7oEYul4XdBe5/PVIdg=
X-Gm-Gg: AZFdTZddSqDzJ/2nN0+Mx5u9n15F81+g96cngEwItGbbx3oe3CBCh5L0S+1FVQ9Fu/n
	rftesiUbABnIO7Pdksg7C1MvnNai4/tR792uGWML5/wnXGcHGR+M2JquzEPH8F/dSKJ18/AdzzQ
	TdVd17J7E4qaXHfs3eYdCF3YGg0DGLvhVuOo1uFfRUaUNZtGJNmkq3UzrvNPu1icFijD9GdwwEr
	+y6QKrs3ZdCCb0/5r0A17jgPyon3KE/R3sQpFx0coxz04nncYhhHnmdMF5qeIdANmSRHwdzGsmh
	uD67Y+9hl822e/uSWVSRtU882Ma0oSRfiOpedFwVxqGfdxUhFoYL78wEEpBZOjFs5WC/2FsU02r
	1AarYRCnlhhJXp9eD4RXbmrHOL2Rk0sa2Qnvk5Ts7/fJLaagR7iTi08AiidU5wAmbYJzsWf0WWt
	8qwMXA3CdbyVWx2H7LFJs+7riI9zeqvOZz78ozLhRVHGt8jzitQSlPRJdGG2AT6La5bzLFg7gPA
	/1zoGKEAjNymMGmfuXLN0tZQuPtZitF2+Lk6lVT5dJfARDtoiu3iESRL94hzNJLtbmfmFWT4eh7
	lUzJSJei0SNGW8GqDrze84WTd3c5ezmad/2wzIkkGmZgVscltIAuuJirOkyu9AgC
X-Received: by 2002:a05:6402:a545:10b0:6b4:2960:d381 with SMTP id 4fb4d7f45d1cf-6ba37c76e50mr9724605a12.1.1795533996409;
        Tue, 24 Nov 2026 07:26:36 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d0575d9sm7182425a12.25.2026.11.24.07.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 07:26:35 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v11 1/3] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Tue, 24 Nov 2026 23:26:19 +0800
Message-ID: <20261124152623.7838-2-heming.zhao@suse.com>
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

