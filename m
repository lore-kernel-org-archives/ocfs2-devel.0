Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAA0376A1E
	for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 09:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378071; cv=none; b=tdW4uHelnMA816ZY4uailD4xiP3jyVvCjSdXHvVNVOLKEf3WiNPxqenUxhls7cXkNMnke5kj/zso+x58TRTuhwrfLJlMc8exzQJOfHcG8DBzOJWQpq5/D2P9l5y4kosUDd2mAEAMAji4lJgoN+OwdC0EyQl/uY1qFNIR3pRIKYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378071; c=relaxed/simple;
	bh=am5CR7Zite+SVUPcoxrsq4l87Hr1S/ZIDo1eDV7e52k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P3vDpYK25p1QFCJGEJwOnJAtRoxFQTQ5rywtCdMqV95k/k444Ly1ZZnZ/g89m6X9ccbFDU5dAI28kqwQfwoNWA3eMwcLS8wVt6drtI5lahxpSS8OdOUYLXN2tn8/G1LbNshssemCeBotOreXUAhm7IPMSmheq3kneDU2xwOG+iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KM+KPC2w; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KM+KPC2w"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-37dfcc2767eso142187a91.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 25 Jun 2026 02:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782378068; x=1782982868; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzMHPanavVvphKDY3mtvgcMdK84jQDGy51gO5WmreGs=;
        b=KM+KPC2wQXSeNq5H6IID9+78J7YiogPA/I4MyUmS/TodINFsiXJQXDLywZ+bBnhJyK
         ymT6jGPAiztZNPQIqFENyXWvp8Q+dbuOM9sEWbjfyHdjvLiRvoneBW1XDUpdSUYbdCR6
         dtfS5bmb/7M3ABxQXT6sIa1ISDoyEiW1Yzbu1aIyJhLBk0/4e1CjBVmMR/1POgjjlP6B
         qXnl4vNh8meytxlUgm2R94Txg5rzeS5o7jvNHV2JoNVtpQKhpNo3Cisn1ae0Exd1kZEv
         0lB3Vc68etmq9lHqmiy7EVW+Sajr5KKKhdM2Q0AHixTGHE193oDxKAwwz3zgDPLfKqDa
         9jEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378068; x=1782982868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JzMHPanavVvphKDY3mtvgcMdK84jQDGy51gO5WmreGs=;
        b=WPndCCkBsq9yI7bPVxSWS7Tr2erf1J/Aolc6weOAHqznJCLCKTYS+wujyrkUspsmmy
         bRaA5RnefNellvGBiuEL3U8RvsaMebNePfyCnJr0nXVb1hnolx7rvi/22DfCyI2UTySn
         17iwRBNDrwcPfIMAJ/xFk82JNFjSb8oW23uB7diI5skrCnDENWfaAcdhTCowmqRolKia
         45KjHs8Gvk+gXOiZmMVpDbamvp1nnyBf92RHRlbdA96kwtwMRAnaIRne+d1KPr+Dh/Pg
         dTvQU2t5TJzG6CyUD2x1qi/P6QUMkgUVYMQ1S/trV/6R6UR52uPRkljk3j7rQ0Xcw/gO
         gbHQ==
X-Gm-Message-State: AOJu0Yzl+nVm0RsoUF+fqdeqUfscVqMndvgfEBsgbj39Pplsi3oBKlNp
	sNxGnDBE+l9pNV+ZWCG8EHnjb3yzHUx9IM0FKNOBLMLImUDbaNW2XiRh8PWaSI/v
X-Gm-Gg: AfdE7cndS/0sVwUQj3wN4ZJw7DJ8q5AbwZMGIWwhyZn3tRJQPSKxps+WGcnF128em7N
	vlqWHNod6wlz7IsM76LucbjXjKZ0+cK9ohTJeIXFlVHA5B3f2aUWqLVGGtDjwirhMH39sRfbca2
	iDAlDsS1i7BCxi9JJdHOQwcw3rCpgIpzIg1psF0aFozvNp8eAYtxEkWPP7SoIvc9cFCvZHtk3LN
	4YjKcXT1eAOREl5TitRKcoiT+D+9Eun8/1j0WpfvfAh3pUPzrjZ0CHoP2kGvnqhy5N7nq47tiGZ
	AjPd4XEz9H3ZKsFhIf45Y8eqesaSjXnQtPMtFetWXJ6gQPNfkxrDf7vx6WMiZOj8l/MHGHA2A/E
	bdyFmE8OmcHr8yiMkgBD63dd3sxwueMAMt6ygM8PouNTxIb40vGeBSk+KlGXoioXHHIiOY7qGyV
	ajAxUUAg4cImPE4C/93A==
X-Received: by 2002:a17:903:98f:b0:2c7:fe1e:1ebf with SMTP id d9443c01a7336-2c7fe1e20e7mr12462125ad.23.1782378068096;
        Thu, 25 Jun 2026 02:01:08 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f6518bb1sm15365715ad.84.2026.06.25.02.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:01:07 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zzzccc427@gmail.com
Subject: [PATCH v5 1/2] ocfs2: validate inline xattrs during inode block validation
Date: Thu, 25 Jun 2026 17:00:59 +0800
Message-Id: <20260625090100.202881-2-zzzccc427@gmail.com>
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

ocfs2_validate_inode_block() verifies a dinode before OCFS2 users walk
metadata from it, but inline xattr metadata is still checked only in
operation-specific consumers.  The existing ibody lookup helper validates
inline header placement and entry count, but inode block validation does
not reject entry name/value bounds.

Add a shared xattr entry validator and call it from inode block
validation for inline xattrs.  Keep the operation paths on their existing
header/count lookup checks; the full entry bounds check now runs when the
inode block is validated at read time.

Reject corrupted inline xattr metadata before ocfs2_xattr_ibody_get() or
listxattr() can walk past the inline storage.

Validation reproduced this kernel report:
BUG: KASAN: use-after-free in ocfs2_xattr_find_entry+0x5a/0x170
Read of size 2 at addr ffff8881242a2000 by task python3/529
Call Trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  kasan_report+0xe0/0x110
  ocfs2_xattr_find_entry+0x5a/0x170
  ocfs2_xattr_get_nolock+0x20a/0x820
  ocfs2_xattr_get+0x10c/0x1e0
  __vfs_getxattr+0xe2/0x130
  vfs_getxattr+0x185/0x1b0

Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/ocfs2/inode.c |   4 ++
 fs/ocfs2/xattr.c | 169 +++++++++++++++++++++++++++++++++++++++++++----
 fs/ocfs2/xattr.h |   2 +
 3 files changed, 162 insertions(+), 13 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 662dbc845b8b..815bf3f659da 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1608,6 +1608,10 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	rc = ocfs2_validate_inode_xattr(sb, bh->b_blocknr, di);
+	if (rc)
+		goto bail;
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index fcddd3c13acd..b6f00926849d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -68,6 +68,12 @@ struct ocfs2_xattr_bucket {
 	int bu_blocks;
 };
 
+enum ocfs2_xattr_entry_type {
+	OCFS2_XATTR_IBODY,
+	OCFS2_XATTR_BLOCK,
+	OCFS2_XATTR_BUCKET,
+};
+
 struct ocfs2_xattr_set_ctxt {
 	handle_t *handle;
 	struct ocfs2_alloc_context *meta_ac;
@@ -950,41 +956,178 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
 	return result;
 }
 
-static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
-					   struct ocfs2_dinode *di,
-					   struct ocfs2_xattr_header **header)
+static int ocfs2_validate_xattr_entries(struct super_block *sb, u64 blkno,
+					struct ocfs2_xattr_header *xh,
+					enum ocfs2_xattr_entry_type type,
+					size_t storage_size)
+{
+	u16 xattr_count = le16_to_cpu(xh->xh_count);
+	size_t entry_storage_size = storage_size;
+	size_t max_entries;
+	int i;
+
+	switch (type) {
+	case OCFS2_XATTR_IBODY:
+		break;
+	case OCFS2_XATTR_BLOCK:
+		storage_size = sb->s_blocksize -
+			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
+		entry_storage_size = storage_size;
+		break;
+	case OCFS2_XATTR_BUCKET:
+		entry_storage_size = sb->s_blocksize;
+		break;
+	}
+
+	if (storage_size < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr in block %llu: storage size %zu is too small\n",
+				   (unsigned long long)blkno, storage_size);
+
+	if (entry_storage_size < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr in block %llu: entry storage size %zu is too small\n",
+				   (unsigned long long)blkno,
+				   entry_storage_size);
+
+	max_entries = (entry_storage_size - sizeof(*xh)) /
+		      sizeof(struct ocfs2_xattr_entry);
+
+	if (xattr_count > max_entries)
+		return ocfs2_error(sb,
+				   "Invalid xattr in block %llu: entry count %u exceeds maximum %zu\n",
+				   (unsigned long long)blkno,
+				   xattr_count, max_entries);
+
+	for (i = 0; i < xattr_count; i++) {
+		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
+		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
+		size_t value_offset;
+		size_t value_limit = storage_size;
+
+		if (type == OCFS2_XATTR_BUCKET) {
+			size_t block_offset;
+
+			if (name_offset >= storage_size)
+				return ocfs2_error(sb,
+						   "Invalid xattr in block %llu: entry %d name is out of bounds\n",
+						   (unsigned long long)blkno,
+						   i);
+
+			block_offset = name_offset % sb->s_blocksize;
+			if (xe->xe_name_len > sb->s_blocksize - block_offset)
+				return ocfs2_error(sb,
+						   "Invalid xattr in block %llu: entry %d name crosses block boundary\n",
+						   (unsigned long long)blkno,
+						   i);
+
+			value_offset = block_offset +
+				OCFS2_XATTR_SIZE(xe->xe_name_len);
+			value_limit = sb->s_blocksize;
+		} else {
+			if (name_offset > storage_size ||
+			    xe->xe_name_len > storage_size - name_offset)
+				return ocfs2_error(sb,
+						   "Invalid xattr in block %llu: entry %d name is out of bounds\n",
+						   (unsigned long long)blkno,
+						   i);
+
+			value_offset = name_offset +
+				OCFS2_XATTR_SIZE(xe->xe_name_len);
+		}
+
+		if (value_offset > value_limit)
+			return ocfs2_error(sb,
+					   "Invalid xattr in block %llu: entry %d value starts out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (ocfs2_xattr_is_local(xe)) {
+			if (le64_to_cpu(xe->xe_value_size) >
+			    value_limit - value_offset)
+				return ocfs2_error(sb,
+						   "Invalid xattr in block %llu: entry %d value is out of bounds\n",
+						   (unsigned long long)blkno,
+						   i);
+		} else if (sizeof(struct ocfs2_xattr_value_root) >
+			   value_limit - value_offset) {
+			return ocfs2_error(sb,
+					   "Invalid xattr in block %llu: entry %d value root is out of bounds\n",
+					   (unsigned long long)blkno, i);
+		}
+	}
+
+	return 0;
+}
+
+static int ocfs2_xattr_ibody_lookup_header_raw(struct super_block *sb,
+					       u64 blkno,
+					       struct ocfs2_dinode *di,
+					       struct ocfs2_xattr_header **header,
+					       u16 *inline_size_ret)
 {
+	struct ocfs2_xattr_header *xh;
 	u16 xattr_count;
 	size_t max_entries;
 	u16 inline_size = le16_to_cpu(di->i_xattr_inline_size);
 
-	if (inline_size > inode->i_sb->s_blocksize ||
+	if (inline_size > sb->s_blocksize ||
 	    inline_size < sizeof(struct ocfs2_xattr_header)) {
-		ocfs2_error(inode->i_sb,
-			    "Invalid xattr inline size %u in inode %llu\n",
-			    inline_size,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		ocfs2_error(sb,
+			    "Invalid inode %llu: xattr inline size %u\n",
+			    (unsigned long long)blkno, inline_size);
 		return -EFSCORRUPTED;
 	}
 
-	*header = (struct ocfs2_xattr_header *)
-		((void *)di + inode->i_sb->s_blocksize - inline_size);
+	xh = (struct ocfs2_xattr_header *)
+		((void *)di + sb->s_blocksize - inline_size);
 
-	xattr_count = le16_to_cpu((*header)->xh_count);
+	xattr_count = le16_to_cpu(xh->xh_count);
 	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
 		      sizeof(struct ocfs2_xattr_entry);
 
 	if (xattr_count > max_entries) {
-		ocfs2_error(inode->i_sb,
+		ocfs2_error(sb,
 			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
 			    xattr_count, max_entries,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			    (unsigned long long)blkno);
 		return -EFSCORRUPTED;
 	}
 
+	*header = xh;
+	if (inline_size_ret)
+		*inline_size_ret = inline_size;
+
 	return 0;
 }
 
+int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
+			       struct ocfs2_dinode *di)
+{
+	struct ocfs2_xattr_header *xh;
+	u16 inline_size;
+	int ret;
+
+	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL))
+		return 0;
+
+	ret = ocfs2_xattr_ibody_lookup_header_raw(sb, blkno, di, &xh,
+						  &inline_size);
+	if (ret)
+		return ret;
+
+	return ocfs2_validate_xattr_entries(sb, blkno, xh, OCFS2_XATTR_IBODY,
+					    inline_size);
+}
+
+static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
+					   struct ocfs2_dinode *di,
+					   struct ocfs2_xattr_header **header)
+{
+	return ocfs2_xattr_ibody_lookup_header_raw(inode->i_sb,
+						   OCFS2_I(inode)->ip_blkno,
+						   di, header, NULL);
+}
+
 int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 					 struct ocfs2_dinode *di)
 {
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 65e9aa743919..6b7589941315 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -43,6 +43,8 @@ int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
 			   struct ocfs2_alloc_context *);
 int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 					 struct ocfs2_dinode *di);
+int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
+			       struct ocfs2_dinode *di);
 int ocfs2_xattr_remove(struct inode *, struct buffer_head *);
 int ocfs2_init_security_get(struct inode *, struct inode *,
 			    const struct qstr *,
-- 
2.43.0


