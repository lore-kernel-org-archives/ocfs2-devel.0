Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434FB347BDC
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 03:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779764656; cv=none; b=sRKs+2p/b26loTHk3hFU2KyewIoVnm8LNeQvQsYj6lBlDT2oMDkeClV8YNFSQjh8wj2fnuzezf2kYk4uxsMO1Xcis69HVd9WgVhNJ6V4652dkvKG2pU2EG4CY0e+N07Deza9Lr2gyngNSJ8M1JSBQrL3Ja0u2n+A8+crrPZx6PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779764656; c=relaxed/simple;
	bh=3f/xnpBSxLXvpY95FOp0t4xCg9dSW7Crb3ZsQUcV+N0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oygQCSutJSyUI7PEzXTfpUABPKIYMy/TwNsPP7En6gZhRY9xhewy7KXT2edE/JzMAuLVTjSRG+zX8hMHdeSBdlORcB/XfneQvdNEhYviIyFCBgAvE4/dg9lCu2wQWE0HpneR2zvR5Ohr2zXHXegMrBYjoOjxGxIf26VRvvs3ebs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tIRHYT73; arc=none smtp.client-ip=209.85.216.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tIRHYT73"
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-36aa4ae1f11so1277302a91.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 20:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779764654; x=1780369454; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qoIGoKEMhSuMea9Hea11vj3uGCwnMsdPSgMywizP6Hg=;
        b=tIRHYT73k9vuji/yRmiBwsxDARYIkcY/3O0nHVwsQU/pEWxrmYLbDchIkh5VQb7iaP
         jcrMao9awpbJWu+G7MRMQ8El+F6IM2UUYQ9THNZUn7hJL7MhWyS/+C641B+gySuzm47g
         N/5uvoXZEgrQ5EeL0yf2lo6lpUFmzhz8apHPbrSumcIV57p4tXnh7hU7WLdOG88DrLHS
         rGwYOUQC+ZORgzI+MWeh8zcIeov3KDn+h7e/Bki1fYnvE5FxDwEDjQubFQPnYiVrnwGW
         SvFi1vqfRhFHrUFLHxAPqdfzmpuaN+5fjBeokPu8Kt/UiFBicV0SvZxBY0mixRBDDfGO
         FkfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779764654; x=1780369454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qoIGoKEMhSuMea9Hea11vj3uGCwnMsdPSgMywizP6Hg=;
        b=oS8uo/ZS+OUNhWSCXXzRtHf4SXSoka7cDRgBmpBsrkln5SliekvKeBYBkiae75ORqy
         m1xobC3vXCrRfAzJupTnbUvgRBf8SagxgX16kV10kDwkE0+JESNUr65GGfg9rdrZ9rE5
         eXLrd3nUs/iiMlKi+vB5X+X6JBId5/ViQQRveH29K/y5QNyoR3oVSv6ljEtGsibrXtZa
         lLsOCPhycuKcNsN8oZV9WHsEgq/aU/7Sm9OVmrybvIn2hp+QiDlDMN/hTyzbUqRjh/0o
         6I/1UmKKBlqiHzCbE1+52juOBp1HG9jzdi2bOnqCGuJuFKLfKuMeAb4V562lp02NNFAv
         Kegw==
X-Gm-Message-State: AOJu0Yy5tq4hFVxkgtgEdmGxVAbfL8Qjl6NSPwgw47mZwsIHXP6IGa5U
	aOPQP1JxFg4RSRKCznrRYoO+qXQGc9VjuRLGZ2tvnM9aI/Mq05k7fQbJ
X-Gm-Gg: Acq92OEOAxr0mBEMFdVw3YeMXux4qu8i0tnDPbAx1A8/28ZGjHMCuCsLanFiqqs2MUZ
	QV+A4hLGI6OsLWJd/jYFA22uYJvuLhTMXYjIoHB8i1jr/AsbOi0MMY8soKS0AsrhFIPpCWtA41x
	++rTcMviFxLreDsfdVxyjDYYq5hTL/Z13PNrBEkpqoWXXaU+FxR/krepDp9o7tThTLVnwhkPfw9
	vhzMSY8T+dTBep4BbnmdzNdk43kcW7R5k44oSCn0geDKLq0qXdNH55JhaUDGmUV9gXkPJ/eBM4j
	EPOCRQ70yWp39uF/UJw09UlfJqo4KUCmpBCq9UmHvbRSf9b3BKSAU0zEMZVThDm1F6iqEvkt3Ji
	MlvRN5UXMjXyoCb8jHVugQ+MHPF572DDxLnrGm0aHA3XPucIogJYrLgmalBoF+oz5TJ6VGqASHh
	jcmDoazo0OoOSXqHtaqaVlhcbLZ3jlL6s=
X-Received: by 2002:a17:90b:1b47:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-36a671e9069mr16051008a91.0.1779764654324;
        Mon, 25 May 2026 20:04:14 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a72c4cd92sm11414288a91.10.2026.05.25.20.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 20:04:13 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH 0/2] ocfs2: validate xattr metadata bounds
Date: Tue, 26 May 2026 11:04:08 +0800
Message-Id: <20260526030409.3506805-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This small series rejects corrupted OCFS2 xattr metadata before the
getxattr and listxattr paths walk filesystem-controlled inline, external
block, or indexed bucket storage.

Patch 1 validates the inline xattr header placement and entry count
before ocfs2_xattr_ibody_get() parses it. Patch 2 builds on that helper
and validates listxattr entry counts and name ranges against the storage
that backs each walk.

Both issues were reproduced with crafted OCFS2 images under KASAN.

Zhang Cen (2):
  ocfs2: validate inline xattr metadata in ocfs2_xattr_ibody_get
  ocfs2: validate listxattr entry bounds

 fs/ocfs2/xattr.c | 122 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 101 insertions(+), 21 deletions(-)

-- 
2.43.0

From 89ea62caaac9486558bf9cb933975d276a3e67c8 Mon Sep 17 00:00:00 2001
From: Zhang Cen <rollkingzzc@gmail.com>
Date: Sun, 24 May 2026 14:34:49 +0800
Subject: [PATCH 1/2] ocfs2: validate inline xattr metadata in
 ocfs2_xattr_ibody_get

ocfs2_xattr_ibody_get() derives xs->header from
di->i_xattr_inline_size and then immediately hands that header to
ocfs2_xattr_find_entry(). If a corrupted inode advertises a zero,
too-small, or too-large inline xattr size, the get path can place the
header at the end of the inode block or outside it before reading
xh_count and walking entries.

Reuse the inline xattr size and xh_count validation that the list path
already relies on before parsing the in-inode header on the get path.
Reject corrupted inline metadata with -EFSCORRUPTED instead of walking
past the inline area.

A crafted image can otherwise trigger:
BUG: KASAN: use-after-free in ocfs2_xattr_find_entry+0x5a/0x170

Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
 fs/ocfs2/xattr.c | 51 ++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 86cfd4c2adf9..eabfaa02d8b8 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -967,24 +967,17 @@ int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 	return 0;
 }
 
-static int ocfs2_xattr_ibody_list(struct inode *inode,
-				  struct ocfs2_dinode *di,
-				  char *buffer,
-				  size_t buffer_size)
+static int ocfs2_xattr_check_inline_xh(struct inode *inode,
+				       struct ocfs2_dinode *di,
+				       struct ocfs2_xattr_header **header)
 {
-	struct ocfs2_xattr_header *header = NULL;
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-	int ret = 0;
-	u16 xattr_count;
+	struct ocfs2_xattr_header *xh;
 	size_t max_entries;
 	u16 inline_size;
-
-	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
-		return ret;
+	u16 xattr_count;
 
 	inline_size = le16_to_cpu(di->i_xattr_inline_size);
 
-	/* Validate inline size is reasonable */
 	if (inline_size > inode->i_sb->s_blocksize ||
 	    inline_size < sizeof(struct ocfs2_xattr_header)) {
 		ocfs2_error(inode->i_sb,
@@ -994,12 +987,11 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
 		return -EFSCORRUPTED;
 	}
 
-	header = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize - inline_size);
-
-	xattr_count = le16_to_cpu(header->xh_count);
+	xh = (struct ocfs2_xattr_header *)
+		((void *)di + inode->i_sb->s_blocksize - inline_size);
+	xattr_count = le16_to_cpu(xh->xh_count);
 	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
-		       sizeof(struct ocfs2_xattr_entry);
+		      sizeof(struct ocfs2_xattr_entry);
 
 	if (xattr_count > max_entries) {
 		ocfs2_error(inode->i_sb,
@@ -1009,6 +1001,26 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
 		return -EFSCORRUPTED;
 	}
 
+	*header = xh;
+	return 0;
+}
+
+static int ocfs2_xattr_ibody_list(struct inode *inode,
+				  struct ocfs2_dinode *di,
+				  char *buffer,
+				  size_t buffer_size)
+{
+	struct ocfs2_xattr_header *header = NULL;
+	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	int ret = 0;
+
+	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
+		return ret;
+
+	ret = ocfs2_xattr_check_inline_xh(inode, di, &header);
+	if (ret)
+		return ret;
+
 	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
 
 	return ret;
@@ -1200,8 +1212,9 @@ static int ocfs2_xattr_ibody_get(struct inode *inode,
 		return -ENODATA;
 
 	xs->end = (void *)di + inode->i_sb->s_blocksize;
-	xs->header = (struct ocfs2_xattr_header *)
-			(xs->end - le16_to_cpu(di->i_xattr_inline_size));
+	ret = ocfs2_xattr_check_inline_xh(inode, di, &xs->header);
+	if (ret)
+		return ret;
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
-- 
2.43.0


From 1ff5a1fde2b2ed5cfacf6c2205bb2f139795aa68 Mon Sep 17 00:00:00 2001
From: Zhang Cen <rollkingzzc@gmail.com>
Date: Tue, 26 May 2026 10:56:57 +0800
Subject: [PATCH 2/2] ocfs2: validate listxattr entry bounds

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
