Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A65D39DBF2
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 09:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781601109; cv=none; b=hZLazSCvhnXeDfFhLfT4JDrWkGm72XeAvbAT5RGDWQ2EYXnTIHwg709qHcZV2Qsxw/2RHuDlKYWh03I4+z7iny4bb6oZEdGuxpkErf6ssm0XOaztNGSJmDGEcoPMHBvWhefHX4vX9aIvuxteK+2seHvj1j8e/U7quIZt5yGXXhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781601109; c=relaxed/simple;
	bh=3LJt+LSK1sZ57a5Kkyte8gqfOjqyrb/1cGpUli8kadk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aAX0Le6IoqBiV7jtJiU6e0aUJouN+GpA5+oeRvMT8OgFC24A8hNo0bD6YyuPGZzQIPyxt3X2YJgyxwKr4l69wJQ5w9qoWK41G6YxWAC6k57K/0g5131R7TYdEC0FG8Aw37CBSe54p5L9wGqFtInrmwJXtLgoNgu6yMtaFbXLQ98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RZMpdhHM; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RZMpdhHM"
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2c0c1e0b0faso26520405ad.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 02:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781601108; x=1782205908; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=969kMUbkVT05WgfEQRYRfiiI8z5qsjO5mKnI2RAlyQI=;
        b=RZMpdhHMGnx/8d6g4KhtavCd7eq8dQJi2Hs9WnTBielXQ9NaE9FabHBc9GANJeGt5F
         ECsA/+BxOJOyaOnyIWRlhUIsvTcOfSzJrsKMpJINa2i69XCMFT2gA3tMuREnwGwKw752
         ll1hgEMWGceZjorfxr1T4yRK8jK4ugfOg5kManYuRIwV9dq3VtXqnKjzaFJVj1uyF0ZG
         5fkxa23P52RS/Z+PQ+M6Esgbge7x8rvie4CKxCXzf+c7evePLmEyRRuZm5NA8Z86JCBH
         iDYMVAA3x+GZfGxVcFOMOnP4Asgh9hLscrXv/W32MICg74n4qaeXUB3s8Om2fByQAzOR
         DdEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781601108; x=1782205908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=969kMUbkVT05WgfEQRYRfiiI8z5qsjO5mKnI2RAlyQI=;
        b=gsiCDh2RdXIEo591BWV4yz8Vpd+DxAudGRxjDc2Hu9rGRMl3mCOkM4D1idBGiAg1h2
         zV1vLPpd2UmHSZevwGKjhVKX5875mxRDCCeMhpiuu17tO8lelK8+Vg8skM8hzzMvHtOB
         QYgk1beHjyeGt9lE71QvwVmjameszKHj8NI7eq/aUhY2qdVJv6jrjSLMLGyHXpOXBd4w
         SbF+sJvrSSOYH+Npi0/+kcnsnYNctL2/qohCl3BM/NXrF0GrJzSdg2xd4UTkinYfvBVh
         7L1RuTyfEbMwDbQDmn6r7KlOTmPRAQ6gJd9tTIMvu+iHFSWdv/+5X79NBYr4oHVfc1UF
         qu2g==
X-Gm-Message-State: AOJu0YxrPsBBXPoNb6YssG3eF3ABpxy+7IQKkZzVhUPr8K/HJu21uZIf
	VitpLegEY32otnPsKnQn1sqsbc9uzOmEj4eeWZZ5qBuF+7fUHD5Tr6l83X4Q6gHXk3brVA==
X-Gm-Gg: Acq92OExRbIuJoJfkHyqgzhhzybsaomHQOLCntkQetaTQoSRbraJtOV7Y5EEAErEdZc
	tObt5eWTKdnUo5ZCQnRpiVPvrIziZ2rXpyWLG4JnPSv+1l0ero9lPg11mAV7ugx1xSOxXt2c4ub
	AQ1uRshwkb2NnzxlX6kT5Z2bJ629eEaqtadixvDKrqMzWqLQwVeHi4F/XqgPemkPpLEjtYU1FDy
	0rTk7h27Z8gIgV9wGs02Ilq0uJa12ugnksNkJ1Nlt3b/I/aQO1h+XCN+yguWIZoXVsL9I2QX0PH
	9w6K+VuISQUVeBa0Rd5gm9OFmyaYLifCEy1RVgfgqVo1Csitozq2f3L8uw8ufChq881n4d9AHp/
	wQ/pjUXDEASpEXmdMSPqvmekVC0Dy8l3OV1f4caLjvESIyFqw8hUS2w+vF5waV+NLirxOdWHldz
	Ar0kVtTumK5AETiVpqFWZHDmvJpnxvk2bpkCFaBgXdNWHWZVaNzK6ATrOHz6vQc+xflLWQWIE6W
	88AAQ==
X-Received: by 2002:a17:903:2bcb:b0:2bc:8f9a:3642 with SMTP id d9443c01a7336-2c4114a22d3mr202719215ad.16.1781601107901;
        Tue, 16 Jun 2026 02:11:47 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c4328a43c9sm127502645ad.41.2026.06.16.02.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 02:11:46 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	rollkingzzc@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>
Subject: [PATCH v3 2/2] ocfs2: validate external xattr entries when reading metadata
Date: Tue, 16 Jun 2026 17:11:32 +0800
Message-Id: <20260616091132.3990054-3-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260616091132.3990054-1-rollkingzzc@gmail.com>
References: <20260616091132.3990054-1-rollkingzzc@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Cen Zhang <zzzccc427@gmail.com>

ocfs2_validate_xattr_block() checks the xattr block header before the
block reaches higher-level xattr users, but it does not verify that a
non-indexed block's xh_count and entry offsets fit inside the block.
Indexed buckets likewise reach list/get consumers after ECC without an
entry-bounds check.

Move the non-indexed external xattr entry checks into
ocfs2_validate_xattr_block(). Validate indexed bucket entries
immediately after bucket ECC verification in ocfs2_read_xattr_bucket(),
because buckets do not pass through ocfs2_validate_xattr_block().
The bucket entry table is still bounded by the first bucket block; the
name/value offsets are then checked against the bucket block they target.

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
 fs/ocfs2/xattr.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index caff7ae7291e..46c34d7f17e6 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -390,6 +390,9 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 	return rc;
 }
 
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno);
+
 /* Read the xattr bucket at xb_blkno */
 static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 				   u64 xb_blkno)
@@ -408,6 +411,8 @@ static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 		spin_unlock(&OCFS2_SB(bucket->bu_inode->i_sb)->osb_xattr_lock);
 		if (rc)
 			mlog_errno(rc);
+		else
+			rc = ocfs2_validate_xattr_bucket(bucket, xb_blkno);
 	}
 
 	if (rc)
@@ -551,6 +556,71 @@ int ocfs2_validate_inode_xattr(struct super_block *sb, struct ocfs2_dinode *di)
 					    inline_size, "inline xattr");
 }
 
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno)
+{
+	struct super_block *sb = bucket->bu_inode->i_sb;
+	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
+	size_t blocksize = sb->s_blocksize;
+	size_t bucket_size = blocksize * bucket->bu_blocks;
+	u16 xattr_count = le16_to_cpu(xh->xh_count);
+	size_t max_entries;
+	int i;
+
+	if (bucket_size < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: storage size %zu is too small\n",
+				   (unsigned long long)blkno, bucket_size);
+
+	max_entries = (blocksize - sizeof(*xh)) /
+		      sizeof(struct ocfs2_xattr_entry);
+	if (xattr_count > max_entries)
+		return ocfs2_error(sb,
+				   "Invalid xattr bucket %llu: entry count %u exceeds maximum %zu\n",
+				   (unsigned long long)blkno, xattr_count,
+				   max_entries);
+
+	for (i = 0; i < xattr_count; i++) {
+		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
+		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
+		size_t block_off = name_offset >> sb->s_blocksize_bits;
+		size_t block_offset = name_offset % blocksize;
+		size_t value_offset;
+
+		if (name_offset >= bucket_size || block_off >= bucket->bu_blocks)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d name block is out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (xe->xe_name_len > blocksize - block_offset)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d name crosses block boundary\n",
+					   (unsigned long long)blkno, i);
+
+		value_offset = block_offset + OCFS2_XATTR_SIZE(xe->xe_name_len);
+		if (value_offset > blocksize)
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d value starts out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (ocfs2_xattr_is_local(xe)) {
+			if (le64_to_cpu(xe->xe_value_size) >
+			    blocksize - value_offset)
+				return ocfs2_error(sb,
+						   "Invalid xattr bucket %llu: entry %d value is out of bounds\n",
+						   (unsigned long long)blkno,
+						   i);
+		} else if (sizeof(struct ocfs2_xattr_value_root) >
+			   blocksize - value_offset) {
+			return ocfs2_error(sb,
+					   "Invalid xattr bucket %llu: entry %d value root is out of bounds\n",
+					   (unsigned long long)blkno, i);
+		}
+	}
+
+	return 0;
+}
+
 static int ocfs2_validate_xattr_block(struct super_block *sb,
 				      struct buffer_head *bh)
 {
@@ -596,6 +666,16 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
 				   le32_to_cpu(xb->xb_fs_generation));
 	}
 
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
+		size_t storage_size = sb->s_blocksize -
+			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
+
+		return ocfs2_validate_xattr_entries(sb, bh->b_blocknr,
+						    &xb->xb_attrs.xb_header,
+						    storage_size,
+						    "xattr block");
+	}
+
 	return 0;
 }
 
-- 
2.43.0
