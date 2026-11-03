Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714184;
	b=3fKpKv99HzsxNMKiJLhsv+8MX5W/4TBqa6s/+5tusH/DAs7o2kNRIClQpxt4wAuT7rog
	 uMoCihW6jSn8IfhV1d3IDIXN0v5QTTgj80YRyPshd0AkT1OBm3/OWcMGn8IxxP6veM3rj
	 9aDkbEBNDizLDnyBUeOf/5uetE47zixIGEcpYoDJ3nxv43HUZ9Z23WubOQjc1M5fquV3Q
	 nm/6XyoRxTlqJJCSiLqenI/G1UrmOhaEhl8y1vPzLUOX2zQaoDtTbxbbZo444lINec73x
	 TGOwsh61CboYP/r4ZXLeTERO3VyB0JKOHCIPqtTzWXEGk+Dpsjgux2ZP2bOYswaBzNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714184;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NiPvFH8SVoF37ApvoIXLuqpxHr1PY9KAcpyY1hM4Tws=;
	b=VDhVAbGTwqiem8fwcOFy11kO8XpbVsmrzxhA+jnxBnzxakbFtgieiTfpCwMNt57GmvgJ
	 0vlzQMZKZNqooFIP/BH7G3A3jAHIhPfZFxn8TJpRmZzvYeHOH8kVqrOOhm0diNvtxuHmL
	 HZeYTdNwYh0t7ZweShk7013p8CqJrtuyPh5I1UP1vzjjBCLkKzafqj3xlskJtUh7OuqdO
	 TG80pHMtq21E6O5qm0QOIwH0GIPgOwTm1n3N4q6u3UyOC2XMDQ/YLYO1bU/aDWEF2KMli
	 iFokQMJtAzzvSK/nRdAz1ovMAWuvskfdNMeCsWToYAHGp9qvmpR9Wq9LKA1jMofwoyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bqbSVdiA;
	arc=none smtp.remote-ip=209.85.218.43
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542A5606A338
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Nov 2026 13:56:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 542A5606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=bqbSVdiA
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c40aa03a96fso80034466b.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 03 Nov 2026 05:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793714183; x=1794318983; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NiPvFH8SVoF37ApvoIXLuqpxHr1PY9KAcpyY1hM4Tws=;
        b=bqbSVdiAl89Df/W42iIHSsbG1sa0PW2YVHerjUAvN3BnjOiVWe92NUO+DKQ0dFWOpO
         IzRi2ROwtCACVkFocaSipoKZvBEJ21xFAEPcFCEz78Hdh08XuZc4BCe43V94K4lf2CbZ
         uT+XjjUMVBz1rlteEmiZS2AIRLpM5TefWrsZhMVaq1PPvM9keEN1Ze77Lzhb/d8HvlCA
         5wfhLECn/NifcsI1UL4h4Vm2GOh+25pF94KtzYH0JWqBFfWG+1KmZzlGazbie8nVbk4l
         Z2fa21QAlH4SSJnIyxbWi6G8GlihH35wh2TNiyzI9Aissidfug06KNgckiLQ1ONy82mX
         8vHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793714183; x=1794318983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NiPvFH8SVoF37ApvoIXLuqpxHr1PY9KAcpyY1hM4Tws=;
        b=UNELSflJ0XZbY9C/Pd/PTBbHe1vS38LmSij3JrJUue5qCEFvAyDeYkPlYI1TO7GDuT
         WAw4fzq70SchuGyuip6C0mbzmxGG/+t4qnmGGX5xGiCh6zRyaDDa6rVPh3fPngXqICa3
         kJe7TSYzZjAajbnm3By0PDEpYaNCFE1KeeX/60AKD7pwqaJZx0MShzke4iCoTUSTLfj2
         1iTp2ix3a8N9cNn9T0LScsjY4MfbOC9goT29D1jkf0woy7I1vx8Iz+mv5qtCRSd3Z9lk
         OWkiteA4bG/MZ+iwKY2njIcaurdDfX1yY4XCccpMOoyrrzKJG3NnJGnPj+pMYNGe6CRK
         dhdQ==
X-Forwarded-Encrypted: i=1; AKwUvBy9cNr6wZmTCLz4yGuFvA0x97DP/pE37uHDFvPhFcl4MgVBLIfupEuKLKCI9RoLchJv85jXGudyfdvm2A==@lists.linux.dev
X-Gm-Message-State: APuU4Z/ez99qztCp1cNE4xQCZLSI1D8q44kt61cUGBY+dVcHvMX/F1WA
	q/iN1KLpb7wR/tbVoaXU24Fy2LGIp56PbmziAlmW5wUjCel04yGXEnuh+xQaAw32k4A=
X-Gm-Gg: AYBFou3iOWSbVB5xemTMf5Asqkin6VjzlQYFtwUEHOZGtLiDejvSzPqUnVm7r5VOc7A
	N4ZzB94rDuOwHj7Ju36vMWW+WIWLhH3qTlNcbcyyVoXdQbYjpASsB4UyD734mPqhOLVtkgzDiaw
	g73XXEVVvEV3kz28UX5HU1+KeSJ0KnxeB6ANZDPyE0MIylkUo/DV5LVdi8Waa0ACnNRJaVSJ9EV
	7MWvoZ5f1C1lGiWi+DIfEwaD28zpH8Ay/ITsV2DadjzKS/c/KVOH8E3FwyG7vqCVQf5zyoMUjL3
	CDWr+umIgldRS5o5IRv9g3Q3uzoK/dl+/iK6nIFNHgHLD5ASlSPN3h0XTO+HQBhrh3iYidFPfD1
	8r5XxkRVfpmwkZj4h9cIXLqKqkgGSTeCYXxzThnXaKq59d2hRHyDokKyD9vJsw4kByYU3MDv+hc
	5WX7m1J+Bn5rOOMQ6jBG6c+t12jci9b2Y18XXmnsDEtSPgt5neV0XMpEZoaRwhwRimk08nNkVRY
	5C/tvUn6uzZBriZzVOVNfZfyMsngkcAv4wnIBNm9EKSMUTTqHpeY18kAuFTbCK/9oskoGxU1S3u
	zRok6XQhkMV8yI+pSbr3+VvWQyauURo0b4L5hL1TTgA=
X-Received: by 2002:a17:906:f15:b0:c43:f1ab:167c with SMTP id a640c23a62f3a-c4ca7970666mr1074813466b.1.1793714182680;
        Tue, 03 Nov 2026 05:56:22 -0800 (PST)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac13ef1a16sm39629747c88.1.2026.11.03.05.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:56:21 -0800 (PST)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	jlbec@evilplan.org,
	hch@lst.de
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 1/4] ocfs2: Add new ocfs2_map_blocks() to introduce iomap feature
Date: Tue,  3 Nov 2026 21:56:00 +0800
Message-ID: <20261103135605.22943-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103135605.22943-1-heming.zhao@suse.com>
References: <20261103135605.22943-1-heming.zhao@suse.com>
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
index 733ceda79ca1..1e2e4fe90abc 100644
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
index e3bb3cc0b25a..7c75def1ef4c 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -514,7 +514,51 @@ struct ocfs2_super
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

