Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568433AFCE1
	for <ocfs2-devel@lists.linux.dev>; Mon, 22 Jun 2026 13:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782133428; cv=none; b=p/IlLCBcUsUglq3jK+BWcRVj36X7Cq/3vbmtvVQX6eyVQQ3g+x7pQKSOD80RYzXT6f0WA1y/WTQalXf9Uxirs6bDx9h62ukxYRDYcrOwJrMAvoCTB24zvsm203D3zY50D0yy87gtwUW/MeROQ2QMlYgPPUVH07BRvNVyFEMQqh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782133428; c=relaxed/simple;
	bh=M0XZvJqWNfwGrcd0WsBNoEzSRV1QGvz3NJH5XZ3Gir8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G0dfQhWAO1eDQmmDW01mSmyzJT9xSPmtxHeCIlix/2xg5iNvZyGkebYPiO6PKIxhTFEKFsP82kHX3MRMBs0eYdpl8+UcQ5FKt0N2ulDsXf+n4Q2D1NJAR5lOxoOvrfR3CXkglrSPRae6SCFvLa9ofpKU5+/OMNQSqOV87TcxbuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BSlcSFN2; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BSlcSFN2"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-37cae9b7536so2522653a91.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 22 Jun 2026 06:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782133424; x=1782738224; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSk0/WQjsb78f8Lzzg7Zyxxk0xSQ7idbJ8adIcT9Oyk=;
        b=BSlcSFN2ogC+QTErXhuJPKM/IzuqtgjVWX7tW4MwrAHQ5OGEU3RW+pO7Sase+3LJa0
         V2CF/CFnYTOo29YP8GzWZDUMCsv3QrJAN7s71IHEDojBTRMU+6yz63kLE1Zb6TvhaDTv
         x8mbXQGQlU7G10oVg3g4UWpfzavEEnT+AZ7Ibd9UjIeyj4qX5eTqK/d1glWcQ8yvDUIx
         OGK6enpuPTh6zUCbQnH+Q0wjZmNta7WVlGvSwRSWkP834BZmb8VF5n6lcY+FEjIBfISS
         ClYpav5GhBd7EEzGH9T24WRrfPVw/y6+WCF3ko4sZTLPwF/AdBYq6klv9twgWSk4atL6
         1DZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782133424; x=1782738224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JSk0/WQjsb78f8Lzzg7Zyxxk0xSQ7idbJ8adIcT9Oyk=;
        b=CPaFi8TwRCugkfAYQFkPCI9GSQ3W36eqOrH1b2HZdVfbgPRbhlph87ZCe52k+Metx/
         ZHUSzrLfS9SJQny1aQpRRRfJQEkQK6ggnxWZj9jZggEHJu21Tb3I+AO5OfMGfW1nJxbB
         dvxvgdcvNFyGQiBcCrONSgJNtKCqnplPBohXoVA4bPO9Lz2K49pz2gGdhvKQQdmrtsm/
         sUVBbqmiaQ7CYXMrRPapeYEBq+VkB/jHmg7bhmRCVsqZW8exn2KAiL/AoQxEz3IJvPCe
         ms+zCexW0Q1w6XYWhzSDVzs1yNivDFQoHo6fvTYtCdiQEkxtpk9qdclYg7oWFKgyQyPr
         jFrA==
X-Gm-Message-State: AOJu0YzZ2MGIhAq6MYuHw30QKddOk0jh+7jxTX64PbrqdSTNG9jKpdfJ
	DSR8V8ecESlGjkyBzipRA1B8nYxU/FMGzjAxBPold2YOrcmtpa0wRle2
X-Gm-Gg: AfdE7cm7KlACRrH3W76g4stz48GQVCEW+SSNOWbQbH/MUcZiTfV1PuRj3x9xLBpT+Vy
	L/LPv/VREnNuZK+RHo8XG4t7QDsCMlsxVnkQZbYtb+QTDOINoaklcDTKhGUoQECjRmy7E3ABR8K
	Oq/OuZVDw99fnPGd1eNGv8WvhAubFD7FqYx+OZJma0u2+w5N/ZZ8rNQAYoWzQ6LEsUm3750UtaV
	3j6S2+3kW3olMaZ5uU+ohoMTvmQiCmBxhciR2Ga5IchGJjKyp6rL0wDCQDgiHt1FIf0QgbA3YZ3
	C8PI+pSAknvwebt4/X3y5CyQs3oQ/YjA5G2uZJmigicUDmIf+Oj095ekd4CjvZ6kwgY2BISmeK7
	CXN0UlRKEgsZB9M7EIxHKvGYV6TqQvAG1CbV4rgRZAnViqa2SqGK03f2J7zYK6HDxJJn69/Z+qN
	Pzt43w1Ic=
X-Received: by 2002:a17:902:db04:b0:2c1:6020:7398 with SMTP id d9443c01a7336-2c718f5fa6bmr153097095ad.12.1782133423813;
        Mon, 22 Jun 2026 06:03:43 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743fd6420sm78895885ad.70.2026.06.22.06.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 06:03:43 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] ocfs2: validate external xattr entries when reading metadata
Date: Mon, 22 Jun 2026 21:03:32 +0800
Message-Id: <20260622130332.2094018-3-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260622130332.2094018-1-zzzccc427@gmail.com>
References: <20260622130332.2094018-1-zzzccc427@gmail.com>
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
 fs/ocfs2/xattr.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 00900e65634d..8147d5c5f293 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -390,6 +390,13 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 	return rc;
 }
 
+static int ocfs2_validate_xattr_entries(struct super_block *sb, u64 blkno,
+					struct ocfs2_xattr_header *xh,
+					size_t storage_size,
+					const char *where);
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno);
+
 /* Read the xattr bucket at xb_blkno */
 static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 				   u64 xb_blkno)
@@ -408,6 +415,8 @@ static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 		spin_unlock(&OCFS2_SB(bucket->bu_inode->i_sb)->osb_xattr_lock);
 		if (rc)
 			mlog_errno(rc);
+		else
+			rc = ocfs2_validate_xattr_bucket(bucket, xb_blkno);
 	}
 
 	if (rc)
@@ -509,6 +518,16 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
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
 
@@ -1042,6 +1061,71 @@ int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
 	return ocfs2_validate_xattr_ibody_header(sb, blkno, di, NULL);
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
 static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
 					   struct ocfs2_dinode *di,
 					   struct ocfs2_xattr_header **header)
-- 
2.43.0
