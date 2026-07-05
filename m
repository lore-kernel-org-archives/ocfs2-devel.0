Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1B927B50F
	for <ocfs2-devel@lists.linux.dev>; Sun,  5 Jul 2026 02:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783220005; cv=none; b=Y33WwTLSxn3rAiwQtsIDcOh8/YVfHeCZj0fPsqzPOvdvobC3n6dNsssuasfz+jyF87nH35mbF8hvACmfP2ipa9h9wCEYsoMnoRfwY9t/g5/Jz1tNz9OO92+gLYfyNO9R8o2CaGtk1gHUnwbhm2OgnwLLZchbh6BOeOLmvkfIC5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783220005; c=relaxed/simple;
	bh=XEK36qBq2IpL2H+HrmC//ajSUB207Haaxm3E0Pzih7c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lU+e65leqIKD9H8CSmnMrk2c++QIvfflkwDtMNsPUWCQYbc53ji29cIiOv9569TG0mQFXNR2gU6/kMqm4Z56DBy9/VH/6CBuAPy1Lj5aIi0gdh2vPzOXvK/rbLmZOF/BhT9RecAyT2sSMpYHTsDdGDizurhJgI97iZ2vMSTtrvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mf29Wrb9; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mf29Wrb9"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c88cc025f54so1174975a12.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 04 Jul 2026 19:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783220003; x=1783824803; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZwAX1ZN395zmoLg6cQyDC1uji9N88Kvypjg/r2X0TS0=;
        b=Mf29Wrb9tCVMRcPod0xHNP1C6XjrclBu14wAGyr0+uIvaxnVip2R5wE+U+uthxhQQr
         FmaZ40FrNUP7CK2VSLxbaAyDTGXDY3S4+vkjGBR6N1Wdfk5OP4DJSN9FLM3g91gGGdj9
         3zu678Ksg0rMOzSE9LJoMARCLU7w5TPUWpPIYhCneJIh6B+JUpshWi7P7B5gmqobmo4f
         9dDhDfEH+rBqzx6E62+UYYfPoaPpUPg23WGILoLExXZX4AXWmRss/EzYVzKV26ySG908
         hLDFSumvj0D/B+Ib6BystMPRDxsI9eqx1FQQ1XXZgaOMhlc4qc959dgNCk2Bo6CboEzB
         PI0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783220003; x=1783824803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZwAX1ZN395zmoLg6cQyDC1uji9N88Kvypjg/r2X0TS0=;
        b=kHYdvMFWpPbasvky+APjnkvKg4rPjY9kGHz/UfB1PE/XzqljYb4xmqt77xHkCbzzdt
         byUooM9HrnEyV7JrAnvHgAqgeebXxS43TbtAQfscoPT81ftzG2TxOpw1zOx8NjLR6nHX
         jtfYbZh/FFB+l/wL788Iv22JN48cMFaMkCSl/qyuvA116aASSE2OgEx5cqiQcHQOdBgI
         Ar/ryoWE4KBVVASq/XYKlSdf1nAulZlHCYHSnKLBvp9Prgu+0ruvWEHaz1MggcaRGamc
         M505vlz/FjpM3UjTsPWuLk14vsbRuDJYGzPFJrOWZyW2KQx8f3NhYMVmsd3lF3eZ/jZZ
         ZjIQ==
X-Gm-Message-State: AOJu0YwGrYWDGURmfxcxXPHRjvwQsgIm7P5SYEy/YIagJzGKe5bdYBFS
	r+1WvediMN0iUB2kL4WWRSgngSEQL/+AvpAbxLZwDguJXV3icNjC36Bh
X-Gm-Gg: AfdE7cl9bDEAAaEVlTfYW9M+7s7jmWT7696tKrHOyBfs8ly1/QF+2k96nyVUpGOOWIB
	AX32U60aMpUfsIdHjm+E0J8nsWptAQy8NZT9Eo1JRuvEiYPTCh18NVCK4deDdqGNsEAks3sO0iI
	LhkR8JROrNHYHjRQBnFbZBpd3lGfbF8VpgGd8jImPB9fMpbRKZYd+1v1Nfurz0ZC6DFGLlZT8ZE
	z5gh21EZE3F2QyNOcor2dRCmsfQLKlUnj/xHrp4eD5s1+oOfehC/Wp8EeuX5xnkyGzipObRx5ZB
	Zrfq305gxYuQyvsEa4r5nKtnBUxK234xz2hZXehDKZhfBRehfUDeU8211YN67WiwsCFjDQQoTUe
	uHZoKtahl3OhQd2+PORSYUdZkAR4eRhJBQaN5MImtqiHg6dyZG+s7DxCMGaSr9alWoIuTsVnWvK
	gVg9yh5BU=
X-Received: by 2002:a05:6300:6182:b0:3bf:6f30:1ccd with SMTP id adf61e73a8af0-3c03e504735mr5321584637.42.1783220003333;
        Sat, 04 Jul 2026 19:53:23 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8bd30ca5sm4253679a12.0.2026.07.04.19.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 19:53:22 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zzzccc427@gmail.com
Subject: [PATCH v7 2/2] ocfs2: validate external xattr entries when reading metadata
Date: Sun,  5 Jul 2026 10:53:11 +0800
Message-Id: <20260705025311.3429854-3-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260705025311.3429854-1-zzzccc427@gmail.com>
References: <20260705025311.3429854-1-zzzccc427@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_xattr_block() checks the xattr block header before the
block reaches higher-level xattr users, but it does not verify that a
non-indexed block's xh_count and entry offsets fit inside the block.
Indexed buckets likewise reach list/get consumers after ECC without an
entry-bounds check.

Use the flat xattr entry validator for non-indexed external xattr
blocks, and use a bucket-specific validator for indexed buckets at
metadata read time. The bucket validator keeps the entry array bounded
by the first bucket block while checking name/value offsets against the
bucket block they target.

Reject corrupted external xattr metadata before listxattr() or
getxattr() can walk out-of-range entry arrays or name/value offsets.

Validation reproduced this kernel report:
BUG: KASAN: use-after-free in ocfs2_xattr_list_entries+0xd7/0x190
Read of size 1 at addr ffff88810a654007 by task ocfs2_xattr_lis/630
Call Trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  kasan_report+0xe0/0x110
  ocfs2_xattr_list_entries+0xd7/0x190
  ocfs2_listxattr+0x3f6/0x610
  listxattr+0x90/0xe0
  path_listxattrat+0xed/0x220
  do_syscall_64+0x115/0x6a0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
Fixes: 0c044f0b24b9 ("ocfs2: Add xattr bucket iteration for large numbers of EAs")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/xattr.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index ca76441625db..d23364c30e1a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -390,6 +390,12 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 	return rc;
 }
 
+static int ocfs2_validate_xattr_entries_flat(struct super_block *sb, u64 blkno,
+					     struct ocfs2_xattr_header *xh,
+					     size_t region_size);
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno);
+
 /* Read the xattr bucket at xb_blkno */
 static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 				   u64 xb_blkno)
@@ -408,6 +414,8 @@ static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 		spin_unlock(&OCFS2_SB(bucket->bu_inode->i_sb)->osb_xattr_lock);
 		if (rc)
 			mlog_errno(rc);
+		else
+			rc = ocfs2_validate_xattr_bucket(bucket, xb_blkno);
 	}
 
 	if (rc)
@@ -509,6 +517,22 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
 				   le32_to_cpu(xb->xb_fs_generation));
 	}
 
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		size_t region_offset =
+			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
+
+		if (bh->b_size < region_offset)
+			return ocfs2_error(sb,
+					   "Invalid xattr block %llu: block size %zu is too small\n",
+					   (unsigned long long)bh->b_blocknr,
+					   bh->b_size);
+
+		return ocfs2_validate_xattr_entries_flat(sb, bh->b_blocknr,
+							 &xb->xb_attrs.xb_header,
+							 bh->b_size -
+							 region_offset);
+	}
+
 	return 0;
 }
 
@@ -1068,6 +1092,79 @@ int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
 	return ocfs2_validate_xattr_entries_flat(sb, blkno, xh, inline_size);
 }
 
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno)
+{
+	struct super_block *sb = bucket->bu_inode->i_sb;
+	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
+	u16 xattr_count = le16_to_cpu(xh->xh_count);
+	size_t region_size = (size_t)sb->s_blocksize * bucket->bu_blocks;
+	size_t entries_limit = sb->s_blocksize;
+	size_t nv_limit = sb->s_blocksize;
+	size_t max_entries;
+	int i;
+
+	if (region_size < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: region size %zu is too small\n",
+				   (unsigned long long)blkno, region_size);
+
+	if (entries_limit < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: entries limit %zu is too small\n",
+				   (unsigned long long)blkno,
+				   entries_limit);
+
+	max_entries = (entries_limit - sizeof(*xh)) /
+		      sizeof(struct ocfs2_xattr_entry);
+
+	if (xattr_count > max_entries)
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: entry count %u exceeds maximum %zu\n",
+				   (unsigned long long)blkno,
+				   xattr_count, max_entries);
+
+	for (i = 0; i < xattr_count; i++) {
+		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
+		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
+		size_t block_off = name_offset >> sb->s_blocksize_bits;
+		size_t block_offset = name_offset % nv_limit;
+		size_t value_offset;
+
+		if (name_offset >= region_size || block_off >= bucket->bu_blocks)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d name is out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (xe->xe_name_len > nv_limit - block_offset)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d name crosses block boundary\n",
+					   (unsigned long long)blkno, i);
+
+		value_offset = block_offset + OCFS2_XATTR_SIZE(xe->xe_name_len);
+		if (value_offset > nv_limit)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d value starts out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (ocfs2_xattr_is_local(xe)) {
+			if (le64_to_cpu(xe->xe_value_size) >
+			    nv_limit - value_offset)
+				return ocfs2_error(sb,
+						   "Invalid xattr bucket %llu: entry %d value is out of bounds\n",
+						   (unsigned long long)blkno,
+						   i);
+		} else if (sizeof(struct ocfs2_xattr_value_root) >
+			   nv_limit - value_offset) {
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d value root is out of bounds\n",
+					   (unsigned long long)blkno, i);
+		}
+	}
+
+	return 0;
+}
+
 static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
 					   struct ocfs2_dinode *di,
 					   struct ocfs2_xattr_header **header)
-- 
2.43.0
