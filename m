Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A328379EE1
	for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 09:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378796; cv=none; b=J744Fp5mLX2D8NHSWjYfThOeQX33eOOIgv3QnlDtQz337LigEvbU4o5PZirppjaAVcBTKP5Kk/SINmTl7E+z18i8cM1Ksl3oTGH9kqGbD3Bc3ZVsmD++ekMpJFLGJugSoyfpCQKomzmmR/Qa55HXYRnesqjzwTYtMec/xaeQ8tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378796; c=relaxed/simple;
	bh=9910rDOdgntu/IdL/bzHysNcQGCMg3BxBboAi+zYMeo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c8n3yvf78hkH/Iqgy0GC1nC8OCHthUUOSlUUN6NUKHtWUZUr2EUUO2V9bdT3oFPEEUqGCWVUwFi90X5RfmksegDy7hj05XkG9YAT0a5jaHrTzvsVH0BtQWmAb7uhfL0pf0rrQ4ESycrG/ezeNVaiiO4H8X8KiiZeIK+N0b9wvNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HfeJ0pCh; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HfeJ0pCh"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c7e8eea816so2649195ad.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 02:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782378795; x=1782983595; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqPfV+tCqNEZnFIAUu2y2M5HYLqzWY3lJT6vyiF2WMo=;
        b=HfeJ0pChi/Q6kVSDtHYhmcdiGcPLz1c3l8fLDWzC3WFh2UwBdO9YA1tu4u08qgsfp+
         8ePoS48q/li3a6GeHg/pdSRs/deQExi/fgmnt6IXZrvHYQKhASP8sFK9feYX3lfijx1v
         coDMWO7Pbcafr3zkxz7mYcrkGoUhzbB8TG3mNjg51O4oDMEHfN0b1tlv0XIRMgBO8zCp
         Mz/Wi/LRcqPR19BcfyNCc9panR1iwoNyKFthvl8Zh1irGIggsVHfaaRiZjwZ3C2ab/PP
         uTU5AaX8nMpSajS1OWJoLPvfRJ/C+Up3/RtaYPZ4eofnvNq+J9b5Es6sXm93deKUBKId
         LzJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378795; x=1782983595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NqPfV+tCqNEZnFIAUu2y2M5HYLqzWY3lJT6vyiF2WMo=;
        b=TUFsHi7wNg3Ytskmh5BdlXN8sbSbdqS3EnmSZB+eVux4lTdbVYqwtOI9Qt7atjftpD
         sTXV5nCr6KJX39OAAgU1hjhyDZnVmae3ra9ys58JrePY4jVkn+58srDbKLy6lbcqBJYQ
         u1lXB9nvGzC/AQcW5R409l4WYXSyj6GzgKBKFlny0RElpOc+75gzFC6qs0wupO5qGiYk
         oZUCwcyDB0b9CUOHDqsTg7NbiEu2i8HObH4DYEjnyXhZdTYpItRWcMMnkcoSTrwTf8UP
         o8YmYG+ICb0bx6MLeqZeW8SuVXahkgMsAfggV8fyMgeyUTuR8D+ulyjRNAMh3aZdQ8A4
         8zMA==
X-Gm-Message-State: AOJu0YySmpGEqmV1Lls/bHqRgpA/Kir+UoIZt0H6QZQ1tNnimW0mpR/8
	TW+1/4Rvyd+7MPLMhZo0k2/EAPBvGRkEPPLc03Xv3qS/wINI4rRQ02PJ
X-Gm-Gg: AfdE7clCuP2yWfpWWhyPA5lgJiohNFelqV0p2dv+cefv5IRH3KQRD+MOcqh6DTbEW6t
	wda7Q7RJiiEcq2ePsfrS+U7wqkA410OFdfPIgUqUasi8bQEbdlc9KwRCzSodizpLacpWips1MzG
	Q5fMEZNthQDtV+SrF7bVlL9cNVWBjvwx4tXlt+kXwj1KviFFMEoWHuT4186Icj5brbnTqLEl5hu
	2dZYL8Qm/JlTJKt00VHjufGc4GHRed9g4jMxujV9iHytVS/H63KJw35ciCH2VFZrxScoQD3G+BW
	WupvXFMQZMKmLuC/txCq53R2J7UAYPPC9XCS+qI/qjZW1d3lyZWMrHtewhDDlb9W5z65tM+C04A
	ngEVoOv9eATNzwJMWTvix7DieBlH1Epnmmen+JQ8mPlC34MCNGduduZ9IoUGqy5z7gVNJ5yE1Xy
	pPQ5TGlRU=
X-Received: by 2002:a17:902:e78d:b0:2bf:13af:b077 with SMTP id d9443c01a7336-2c7fcf9ee27mr14520995ad.14.1782378794595;
        Thu, 25 Jun 2026 02:13:14 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f5ac899esm16205485ad.7.2026.06.25.02.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:13:14 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zzzccc427@gmail.com
Subject: [PATCH v6 2/2] ocfs2: validate external xattr entries when reading metadata
Date: Thu, 25 Jun 2026 17:13:03 +0800
Message-Id: <20260625091303.234624-3-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260625091303.234624-1-zzzccc427@gmail.com>
References: <20260625091303.234624-1-zzzccc427@gmail.com>
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

Reuse the xattr entry validator for non-indexed external xattr blocks
and indexed buckets at metadata read time.  The enum entry type selects
the storage geometry: non-indexed blocks use the xattr block payload,
while buckets keep the entry table bounded by the first bucket block and
check name/value offsets against the bucket block they target.

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
 fs/ocfs2/xattr.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index b6f00926849d..cb0775d526b8 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -396,6 +396,13 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 	return rc;
 }
 
+static int ocfs2_validate_xattr_entries(struct super_block *sb, u64 blkno,
+					struct ocfs2_xattr_header *xh,
+					enum ocfs2_xattr_entry_type type,
+					size_t storage_size);
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno);
+
 /* Read the xattr bucket at xb_blkno */
 static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 				   u64 xb_blkno)
@@ -414,6 +421,8 @@ static int ocfs2_read_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 		spin_unlock(&OCFS2_SB(bucket->bu_inode->i_sb)->osb_xattr_lock);
 		if (rc)
 			mlog_errno(rc);
+		else
+			rc = ocfs2_validate_xattr_bucket(bucket, xb_blkno);
 	}
 
 	if (rc)
@@ -515,6 +524,11 @@ static int ocfs2_validate_xattr_block(struct super_block *sb,
 				   le32_to_cpu(xb->xb_fs_generation));
 	}
 
+	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED))
+		return ocfs2_validate_xattr_entries(sb, bh->b_blocknr,
+						    &xb->xb_attrs.xb_header,
+						    OCFS2_XATTR_BLOCK, 0);
+
 	return 0;
 }
 
@@ -1119,6 +1133,17 @@ int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
 					    inline_size);
 }
 
+static int ocfs2_validate_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
+				       u64 blkno)
+{
+	struct super_block *sb = bucket->bu_inode->i_sb;
+
+	return ocfs2_validate_xattr_entries(sb, blkno, bucket_xh(bucket),
+					    OCFS2_XATTR_BUCKET,
+					    sb->s_blocksize *
+					    bucket->bu_blocks);
+}
+
 static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
 					   struct ocfs2_dinode *di,
 					   struct ocfs2_xattr_header **header)
-- 
2.43.0
