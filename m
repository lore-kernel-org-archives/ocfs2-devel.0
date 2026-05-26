Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CA63988FA
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 03:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779766856; cv=none; b=KW+2Gh3BAgPyY9c2r6ZIOmN+nRkWroLtiUEyKCJl2kp8PJR9afxU3N8BXfwVtmLDP5/S6dw9zmCIc0F2Zksd6uJKRJH924v84cSVS9Zq+yFeK2rPaQ4Li50UkIkoOMaMud1TWrc9dL6lqsWzEHbbnQ4nD86vdWuF1ctKsrKyq8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779766856; c=relaxed/simple;
	bh=r/9uQGIuxgfJKceoBZqKIV0CbcdboVg17mN45GYbt/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kzOEP2moCTg7XNDz2c/2fMWxBmDyun8x7RBe86a9yIXcrUetioJJSBU1OrwOlyo3t7Ng8Rcjqh9Kzt3KBpPJ85IOi15MTVKo1PgfHl+OW0B2J6WixcKiPUyKlqW621BaE4wLdNMZkuZ3kHq4J7bgj5IY35jBqT9E2qv6h3omIDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mE2Fit63; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mE2Fit63"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-83659d38e38so4049442b3a.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 20:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779766855; x=1780371655; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWQAcKuwNSNN2NHv7UPykDIiUbHsif5rVuCPtYRfJI4=;
        b=mE2Fit63rNqyIU4r/k584Ia32RZ5VvEHlhmVtbf4qPr28jTFWkKF99RLgV5WA0R9AY
         UmpHjTjArovsV1gX3odvJn8bh3H7fi+ISan5yGHAXJcLvfkptSJIbCBojaohO9ZeviFe
         7WQMOka+nIPCLlPDmmX+ny65UkROjdWyswfsvU6yDmcFDwv8GpA++4y/9ZKKxqOZb/pI
         Yx/93cNgrkJypZo3sflKXxvL7FtY6P9n/XRwW/d6EJdyNZgmAX6s247pmQSvBepst6HS
         LwX1T0/Rwa9ftfDtbyu7IMqG8YqnrRUWPJou1FEtI4lTiHzEceYNLR1ckEwxyatvzwVo
         2Y+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779766855; x=1780371655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mWQAcKuwNSNN2NHv7UPykDIiUbHsif5rVuCPtYRfJI4=;
        b=B9eGArpn0bnSshONXOkv9AagIwJL+C6XEcTNP8gynM3NrHnguPK6VD1enS10CHwUaF
         IVrIvF88t8KE8WbxcqjkQdwl+jBJ+YuxXZspjkpbiWiHknEHhQAGGFjDLgJliL9DavHx
         rVQCStFk3uXoZc4kS2x01ZlOKRv0BXHvc12sLShlH0k9z6Uchw3n99CNTM0i8ljbTnrd
         iRlwLDWuET6h3hb1lpvfr5AoL0hNXodO1qv+hjI1ZM4b+UzUpNPSyFlNxVXCsBCamfo+
         +Xo8I/bt4rb8DynCjy+Ea3l/LLD72tTA9CJdOnt7NvM9YLljgk4yybUTimCgYP8dit9d
         YxnQ==
X-Gm-Message-State: AOJu0Yw/LCYmuciW2sQlBpw5dYDG/GQzbkW2uSdW1bXSG9VKsUrldL4g
	FS5P/9NsgfUNQ0UXFhcS1kQxWA/SKsIpGGemdJOcdEnpTR+LCZ/AlI6v
X-Gm-Gg: Acq92OFyyBag/Hn28HjivFz/4nHJSzlZcfxpIjZ4crjeNd49hvOrCVUjYiJ7dxntahR
	TRxM9NjL0+jlPfBudxeKiyEmOexHRaI+/OqMyXOVLqAu/Ubtxh6kPBVMXL5Pq9at2yzMvTj72MB
	YZc9kZL1KZU1r4DOziTNz5JxKL35XZYzXRCEK5K70QsCzW4UJhlol6KI6FETDNzVtEBJHCBxNLv
	Cru1RKB5thxaduGsfWcc6yYn+Oby6eUwlOFP/udNsTNQo2Awcpy2L5AAmdv2KJVKV+wtjxIYET2
	XYsnlg3LuJD9jN4XdV6yjS5HUJ6QHPncjdWEyGhfrmpYruR1yvPMxE0r/tQM1qhe+YamJ2jeNsS
	eKWbKRl9qiS3OqrC+YwCJl6QRNwZ6e+3LjNLc+4NFKKcBpQwxa+9n12e6Jl9XJ99fqX9rAGkLAT
	3HS5DHDH8+kS7ZrPM85irC5Wb/7z3BGZA=
X-Received: by 2002:a05:6a00:4292:b0:83e:b125:ff30 with SMTP id d2e1a72fcca58-8415f2d6d66mr15592082b3a.7.1779766854540;
        Mon, 25 May 2026 20:40:54 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ff3e00sm12368478b3a.54.2026.05.25.20.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 20:40:54 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH v2 2/2] ocfs2: validate listxattr entry bounds
Date: Tue, 26 May 2026 11:40:40 +0800
Message-Id: <20260526034040.3602377-3-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526034040.3602377-1-rollkingzzc@gmail.com>
References: <20260526034040.3602377-1-rollkingzzc@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

listxattr() trusts xh_count and the on-disk name offsets in the xattr
storage it walks. A corrupted inline xattr area, non-indexed xattr block
or indexed bucket can therefore push the walk past the entry array or
make it read name bytes from outside the local xattr storage.

Validate the entry count against the storage that actually backs the
walk before iterating it, and reject names that extend past that local
storage. For non-indexed external xattr blocks, use the bytes from
xb_attrs.xb_header to the end of the block, so the count check matches
the real xattr storage. For indexed buckets, validate xh_count against
the full 4K bucket storage and reject names that select an invalid
bucket block or cross the end of that block before bucket_block() is
used.

This makes listxattr() fail with -EFSCORRUPTED instead of walking
corrupted xattr metadata.

Validation reproduced this kernel report:
KASAN use-after-free in ocfs2_xattr_list_entries+0xd7/0x190
RIP: 0033:0x42086b
Read of size 1
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xce/0x630 (?:?)
  ocfs2_xattr_list_entries+0xd7/0x190 (fs/ocfs2/xattr.c:937)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x19f/0x330 (?:?)
  kasan_report+0xe0/0x110 (?:?)
  ocfs2_listxattr+0x3f6/0x610 (fs/ocfs2/xattr.c:1050)
  vfs_listxattr+0x4c/0xa0 (?:?)
  listxattr+0x90/0xe0 (?:?)
  path_listxattrat+0xed/0x220 (?:?)
  do_user_addr_fault+0x65a/0x890 (?:?)
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)

Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
Fixes: 0c044f0b24b9 ("ocfs2: Add xattr bucket iteration for large numbers of EAs")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
 fs/ocfs2/xattr.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index eabfaa02d8b8..66f5f9da2b3c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -925,14 +925,54 @@ static int ocfs2_xattr_list_entry(struct super_block *sb,
 	return 0;
 }
 
+static int ocfs2_xattr_list_corrupted(struct inode *inode)
+{
+	ocfs2_error(inode->i_sb, "corrupted xattr entries in inode %llu",
+		    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+	return -EFSCORRUPTED;
+}
+
+static int ocfs2_validate_xattr_list_entries(struct inode *inode,
+					     struct ocfs2_xattr_header *header,
+					     size_t storage_size)
+{
+	u16 xattr_count = le16_to_cpu(header->xh_count);
+	size_t max_entries;
+	int i;
+
+	if (storage_size < sizeof(*header))
+		return ocfs2_xattr_list_corrupted(inode);
+
+	max_entries = (storage_size - sizeof(*header)) /
+		      sizeof(struct ocfs2_xattr_entry);
+	if (xattr_count > max_entries)
+		return ocfs2_xattr_list_corrupted(inode);
+
+	for (i = 0; i < xattr_count; i++) {
+		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
+		size_t name_offset = le16_to_cpu(entry->xe_name_offset);
+
+		if (name_offset > storage_size ||
+		    entry->xe_name_len > storage_size - name_offset)
+			return ocfs2_xattr_list_corrupted(inode);
+	}
+
+	return 0;
+}
+
 static int ocfs2_xattr_list_entries(struct inode *inode,
 				    struct ocfs2_xattr_header *header,
+				    size_t storage_size,
 				    char *buffer, size_t buffer_size)
 {
 	size_t result = 0;
 	int i, type, ret;
 	const char *name;
 
+	ret = ocfs2_validate_xattr_list_entries(inode, header, storage_size);
+	if (ret)
+		return ret;
+
 	for (i = 0 ; i < le16_to_cpu(header->xh_count); i++) {
 		struct ocfs2_xattr_entry *entry = &header->xh_entries[i];
 		type = ocfs2_xattr_get_type(entry);
@@ -1013,15 +1053,18 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
 	struct ocfs2_xattr_header *header = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	int ret = 0;
+	u16 inline_size;
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
 		return ret;
 
+	inline_size = le16_to_cpu(di->i_xattr_inline_size);
 	ret = ocfs2_xattr_check_inline_xh(inode, di, &header);
 	if (ret)
 		return ret;
 
-	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
+	ret = ocfs2_xattr_list_entries(inode, header, inline_size,
+				       buffer, buffer_size);
 
 	return ret;
 }
@@ -1033,6 +1076,7 @@ static int ocfs2_xattr_block_list(struct inode *inode,
 {
 	struct buffer_head *blk_bh = NULL;
 	struct ocfs2_xattr_block *xb;
+	size_t storage_size;
 	int ret = 0;
 
 	if (!di->i_xattr_loc)
@@ -1048,7 +1092,10 @@ static int ocfs2_xattr_block_list(struct inode *inode,
 	xb = (struct ocfs2_xattr_block *)blk_bh->b_data;
 	if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
 		struct ocfs2_xattr_header *header = &xb->xb_attrs.xb_header;
+		storage_size = blk_bh->b_size -
+			offsetof(struct ocfs2_xattr_block, xb_attrs.xb_header);
 		ret = ocfs2_xattr_list_entries(inode, header,
+					       storage_size,
 					       buffer, buffer_size);
 	} else
 		ret = ocfs2_xattr_tree_list_index_block(inode, blk_bh,
@@ -4096,8 +4143,28 @@ static int ocfs2_list_xattr_bucket(struct inode *inode,
 	struct ocfs2_xattr_tree_list *xl = (struct ocfs2_xattr_tree_list *)para;
 	int i, block_off, new_offset;
 	const char *name;
+	size_t blocksize = inode->i_sb->s_blocksize;
+	u16 xattr_count = le16_to_cpu(bucket_xh(bucket)->xh_count);
+	size_t max_entries;
+
+	max_entries = (OCFS2_XATTR_BUCKET_SIZE -
+		       sizeof(struct ocfs2_xattr_header)) /
+		      sizeof(struct ocfs2_xattr_entry);
+	if (xattr_count > max_entries)
+		return ocfs2_xattr_list_corrupted(inode);
+
+	for (i = 0; i < xattr_count; i++) {
+		struct ocfs2_xattr_entry *entry = &bucket_xh(bucket)->xh_entries[i];
+		size_t name_offset = le16_to_cpu(entry->xe_name_offset);
+
+		block_off = name_offset >> inode->i_sb->s_blocksize_bits;
+		new_offset = name_offset % blocksize;
+		if (block_off >= bucket->bu_blocks ||
+		    entry->xe_name_len > blocksize - new_offset)
+			return ocfs2_xattr_list_corrupted(inode);
+	}
 
-	for (i = 0 ; i < le16_to_cpu(bucket_xh(bucket)->xh_count); i++) {
+	for (i = 0 ; i < xattr_count; i++) {
 		struct ocfs2_xattr_entry *entry = &bucket_xh(bucket)->xh_entries[i];
 		type = ocfs2_xattr_get_type(entry);
 
-- 
2.43.0

