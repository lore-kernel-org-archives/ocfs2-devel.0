Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641CB37B014
	for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 09:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378072; cv=none; b=BFozDuyht0GjlSDv/AxmCdSUdwkeOSZhq84peVrJbKzhp77Ie0s3/PMx+0urdKS/6kADFd2Wyudv7TmBjNXW4Yqs3l6I6+5G/KXZ3wKwJEVFIqDTvFJgImv0Ylt2XiDDq7j2u9b4hH7Ws4q5IHdW/CWlS7ENDdczKDnfJDb33Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378072; c=relaxed/simple;
	bh=9910rDOdgntu/IdL/bzHysNcQGCMg3BxBboAi+zYMeo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QWQJoB/mhV+xZtdIhhW9DlEZodec5M8WBlyxqtWFUFewOxNnEpUeX8/R8MHye8voqx9/VlKjKtDS5ibBlo013KBQRb6dF0YkabbvECG1lRjBpjYyD/9EPVVN7/dsTF3NS26gqIIS0o6FMWzhiBMGFszZiXIQauLFE4svjbNahT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DVofr5RJ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DVofr5RJ"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c7ee3952ebso14934275ad.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 02:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782378071; x=1782982871; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqPfV+tCqNEZnFIAUu2y2M5HYLqzWY3lJT6vyiF2WMo=;
        b=DVofr5RJkxnOhJLj1xIvzGQm8YT/iWb/kJq0vcfiSSrAjUN5HJA4DQg0vqZbh/vZ2e
         1XC7dhELQceVplQCdJ8SGG60KwnVoObEc1B2wWtmd8DnFZqzOD37AF+oF6d0unDCJD+R
         6mxIpa9ticcbUOyKwhS4CzqXgh2+pUwA8c6vg/LDlMlHlBjrEdY9Jglh0RPply6toqeA
         iRu4GRIqRVaiY1zz4kIfyRGkfHhzlj0/yCDcIOjGWNjfZZs98APndX+fQSjKW/AiDOEM
         JAgnTPfe7/OQaxE9wpHPxsNfo3/fKqWdlL7uvDHLQc0gU2R+D3Eu6az43NxsoSQN0wmi
         pomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378071; x=1782982871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NqPfV+tCqNEZnFIAUu2y2M5HYLqzWY3lJT6vyiF2WMo=;
        b=Sb/PXMWFCHotyXsxkylyffnMVLudxQl7xpKy8oK35LK0iRRLfDJObXXDfypUIPaNwV
         AXLdKgVLEyhYIz8Jb1npL6kR73Ac0MLdvid/fkbdYDgB9eklDPOuhIxg+lImZ9/NmcqJ
         k6yzVA23T6ekbmXZgJPOE7IqoOM1G8idOZt1oEqHL3i/EBIby+QGN5n4hHIy2HRP8M9m
         ZJhL7wN0tXPMzT/Wf5i7Y1JbRWtAkLR3t91HXUzpPpkERBV/fhqdhOQpSLIU36TSVVdb
         3kuthXcCAa4Ogy3nYRFzm2dpkhWPgHA0rRMYkhRu93V+JYLwkmWxtl9LL5jQLEA2LJnd
         KPJw==
X-Gm-Message-State: AOJu0YxVze7Fn5Tl6q2tK+M2V8fAWu8olJtcPzSvw8ZdH+pfgOeZQRb8
	bp6+w0y6IMod3ePbilQoB0eag4A4M7FqYG8yyuL84+NXKZhyGfhUjttI
X-Gm-Gg: AfdE7ckP+K4U2Jr8iMtar+dpB8thWPdzo6zKflapH/d9UvFn3XmfuLmml1qbLlth75K
	8YND8ef17P0FymZvX1VU9R3C+oE8vnyA0wbrwB8jOsgjUGZbsr76V+rcGbjEXckeyeHObUPhquG
	Z5XevKngAEhs5xvG1Mmoag5jvOJaFYQgb/oKVHr/juzBDGrYfiaMbX461TpoUE/pDPT5qRFs5EL
	0OoVdbQmd06/q3nRb1P7tewbYXKi5WFIBuB/gY7ZMVwuwUWs75FC6X2AEBhkw+JfPG6I4HWIyl+
	phbg0u3wxk1w50IfJPWc4QzQZPPT23FHCnn8Ix2SV70DEKM6L4brgoIbzI2xHmo50apnVavOH7U
	3vpQKYxd3ewSSyfiy8bwEFBNY/1qHERmOXrKYTbw/a3u+uIK54RBF4BX5d7aYCwHYG75LDK1JhC
	ZplorKpiU=
X-Received: by 2002:a17:902:e741:b0:2c7:9b3e:3987 with SMTP id d9443c01a7336-2c7fc890ac0mr16734415ad.25.1782378070529;
        Thu, 25 Jun 2026 02:01:10 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f6518bb1sm15365715ad.84.2026.06.25.02.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:01:10 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zzzccc427@gmail.com
Subject: [PATCH v5 2/2] ocfs2: validate external xattr entries when reading metadata
Date: Thu, 25 Jun 2026 17:01:00 +0800
Message-Id: <20260625090100.202881-3-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260625090100.202881-1-zzzccc427@gmail.com>
References: <20260622130332.2094018-1-zzzccc427@gmail.com>
 <20260625090100.202881-1-zzzccc427@gmail.com>
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
