Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961264;
	b=4Dst7k5Ib2FuObxdMgpjbmUUxLXUU3bfdvLAqRgHNoV46ud3zsa8jj9/vYFS/KvqZuap
	 2jsZ6UfVNCpTX/4uUJj4bYUaCI//OHGAHQa2T/BCM/z5fSTvZWF6hdb6dV5qgtrdeXio1
	 /xgOdKn6x0r6SZOVK0RY0uzD1/LnOUOQ0jgUqOxwnSxKa/4JpeBw8QM0e4RVb9e9c5mGn
	 PDsCT8rA1wQSiKtGpfacElxC7cbrTrfbWUn7AyW2BA5YB96Q7fRln7iQ+w8ROfwEkSODt
	 oVEiMMkJyHrRjjx4a9tnNiybzDH2NsjL/zHsonezKXqjEyr7jK82yHBN6vKpo+htl4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961264;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cuPC0kgLzO2z2UfN+weWuu+GakFka648VI/LcGLIzL4=;
	b=ybT2NUxJUTCrRtc5oqqFYswvjxApYgjxDJiNGS5zyG+LlOZm0ZkFVrazLJ5nNlYaVfyv
	 I8xlfs9k7rssvYapBDPR3jdbnxvR67jnzp4grD/eZPeXVH2Vi9FF8hwhI1GhRYP/ZrSvg
	 +1dTF6f3FD59p+rvy4BXkpyOPcsReJduGWrrEir6v8rAzKmPDZn9S6WtUhx44WYAmDqk3
	 g+rrxuz0gLMFD/s5HWof6/lTSUOTOUlJsOGey+ApzF+ZpjAs0pXHwu/XRXjtbKbbtXJFA
	 IqCSNF4Leo9QioUyd4B9JLfaZ3UFqVJHLp+BeLG0SobGznHeg6/jttW4QQ/C01VlMKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=OibgkOmT;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD352606A334
	for <ocfs2-devel@lists.linux.dev>; Wed, 18 Nov 2026 00:21:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD352606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=OibgkOmT
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb76bb36c7so218425e9.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 17 Nov 2026 16:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794961262; x=1795566062; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cuPC0kgLzO2z2UfN+weWuu+GakFka648VI/LcGLIzL4=;
        b=OibgkOmTNZWSd/APzEVIRjx4wjXLmiSR4JPcUCCpr0m4vBToEvCVt4NftIFTz74zYR
         gSkyZkNg8wxHIcRTwXG9lvxGpjyyzrM1whYtVwbzE0FsrmJWaFX3Vld7iEIjroLw/bJ8
         5KMAayP2OHSiVZf8n24GAl24aMFYwKARwAyxteBtqVkY2ZTjxlCw7NJSPzFPfPZAEAsv
         OMTR6ln8rhlIb5RxxqDr2/rK4VGH7JeXCLggMM5e+rnjOA/AJ4kwBXkuuoGB2ab6sxB9
         k4ZIkf5A7eRlFwgsv1dsRwgmrFd6GHRiAZHgfBIOjx16H7i7M3HPUt9RcABEhepZhxet
         Dl4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794961262; x=1795566062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cuPC0kgLzO2z2UfN+weWuu+GakFka648VI/LcGLIzL4=;
        b=C63htCG3HtkUlHex6cKQZJ2yjNXTJrLJnbDTvJQXM+r8QoO29HcuTqRvJxxCmDBqE/
         lpejVbBa1acFgWknEM4C+f2n/6MwwAl346H0U4vu1kRqPNhm73mcsKUliUCf/fnRPk7n
         nugNBR/MoMw+Whjlt3i9kDJKZ9dKlWTQ7FxE5KJ2i5Js0DvkzviHppTPS2DFsxUIn4jY
         dlZT5u/WtsEqLtUu9m4lwXkPJGJyQBOcBjPJJPaUJlhacsh9dkVv/5duS7HWppPstQMm
         GFvDVkJ2kuv/SMRNjM9/8DjX/CRSTvgIn99YsFKKWPqx9Xeh5GtMMaj5VG+BHT/hW37h
         aFTQ==
X-Forwarded-Encrypted: i=1; AL+hErEAvpdaglReGd/9Cy+yCPGa0p5PPllsXkyanh+Ru5hpqVsukiZZIk2WEWUYtuklhW5WQrzH7BNo/IyrHw==@lists.linux.dev
X-Gm-Message-State: APuU4Z95S1HPWvt6B7gdLzrMaM5TRm5eKXUk6HgPdkDWPIleD+ozZtG5
	B8FnUfbcETVXD68FVCYBqyw7JCDIRfB1EQ6gjEz/P/DG6wfYpELYMUEhYu4PqLq8ZRk=
X-Gm-Gg: AYBFou2AUK5ZNcBvH5GgLyil/AQRKaF8csBM9QdogWE3tNohVJEDH6yLgN4XNosKyNO
	uFVdzygHzx0hMDMHhyIYgkHkEd5oQJJV94kJWOs8oNoN0IkEU0jfZQ1Vk1/SAeUaM0UhVoTToAt
	pHjqM7bc175BPsMB8BC5S6TrHMzgMUbUTy758sUYRGwYWhCnfGmu96XuuGfKG9ozlItUfyV+42z
	B4+QH09iCzCgUPe/wz/VsapOBYl5ezIvP2vMEsmGFCaMeV0J5bF2r9JLykLQ+daPsfN+oLkUCIn
	pF1Vp6uBKlmTUieSo3lJmvwUUBqD1T+Rp4QRQBljNF6KPaaSS4ZONMyo8xICfOMU0Rt3IRS75aK
	svTSuO0rY+NdY/4ebq10Q6VV9R/ix5sSEPRImO3vTG2P+MfqhG25tv7OHIZZG90U7oOWfV2R4hZ
	aKhFFuNlP/yhmc3YH94QTsiSAL6bK8RZYUf3YPIgqo/yw0L2A6Mb8qZIM8itp/Aiy3iI2RVY+wn
	ml3nYcb2lqfSIm08+VCJtlpuIdXRtVPB738HTKjHFZbEZlN642xu9qr2zVzVDOBPhK6hL+TFZcw
	7qvuXtnY71/01ru+NC/fIFBqGM/HJxks37dmmUQtkg8=
X-Received: by 2002:a05:600c:3541:b0:4bb:68ed:a356 with SMTP id 5b1f17b1804b1-4bb7d706b4cmr14595125e9.1.1794961262043;
        Tue, 17 Nov 2026 16:21:02 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447da7e0sm2373481c88.9.2026.11.17.16.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:21:01 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RESEND RFC PATCH v7 1/3] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Wed, 18 Nov 2026 08:20:47 +0800
Message-ID: <20261118002050.9019-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261118002050.9019-1-heming.zhao@suse.com>
References: <20261118002050.9019-1-heming.zhao@suse.com>
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
and performant iomap framework, introduces ocfs2_map_blocks() to replace
the legacy, high-overhead buffer_head based block mapping routines.

In addition, OCFS2_MAP_* flags are defined to bridge OCFS2 internal block
mapping flags with the iomap API requirements.

Subsequent iomap integration patches will build on this core block mapping
routine. The implementation draws inspiration from ext4_map_blocks().

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
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

