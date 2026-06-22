Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FB63AFD1F
	for <ocfs2-devel@lists.linux.dev>; Mon, 22 Jun 2026 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782133426; cv=none; b=lLu9keRPxHJjnmGQPEOb/LCad9OxLLu7yHbtgm/S8WUDgtfKTKZxKeOIVHvYfK6VfPVXlJd1VC+P56hPXdmSzEcTdaTunt2Y0TRY5d0IU4uhlFQktTeg4+/2trLNxGQejbMC/AI3hWfF1JjhYi2UFj8h+7gs6W8+H0TM5XCS+qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782133426; c=relaxed/simple;
	bh=bVon15wOa2aL9wqkydJrWMTomive7VVBvU7Bz6UdY4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t2tmZZkMkEmwYQR/4ZTHV0XQt8+bbr78LFxZPXTk+dDxdSlQsIbVudqjykDhH1CSl4H3hlg3/qM3a1IFs5MxAbLfG1eVXK9Bu69Aqfmt4mfabDKiBWgnx4nM7tRKmwITyHDdR8bKYNLGfzs57mOr6zlCL2jlTXL5LljX+pzC5dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RbLa6ijp; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RbLa6ijp"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-36b9ec98144so2913166a91.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 22 Jun 2026 06:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782133421; x=1782738221; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzDUeVtJRnFTQjoY9bBajtviJo63PoGZcW0Wq1nkiSo=;
        b=RbLa6ijp2tpaur8POfic2A1u0A67nLX6UmcqIBPyoYp+wzh2oDv+mDP+rDjJv8UcUY
         Ibz9qk+SEIxLntYNKZ7r3GIicpzgZQ9+sWWlelU59t7TG0o7xJtsxqShQJMAQEBBGOyL
         V+aLiMt9Odbs+KtTdQiPlprAlayRHh57zG0Q+nK/TQtchG02celiI38xdqA3dFHknz5L
         FgBir/7Jv3I5cgCNsiOlTgkLCTx5Vy0iVNXYYB+u53uMnDppLtLKWnLTlOnda3d6Rhd1
         CUSgOskjM7eIKAIH14xsNBvqPN7TtSOPLBieDQ1S5p18QNok5Tkhqyq6ZcdZbRYJLsxb
         yNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782133421; x=1782738221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hzDUeVtJRnFTQjoY9bBajtviJo63PoGZcW0Wq1nkiSo=;
        b=gn8ENi7RSNxXlkVzEMFm9pdVJ1M2Cg81VjrQG/joAcVmcLqHnP3lkiQ1G45EgUgiYG
         4n6xpc71k4624cXL0tV1uXBlA0hFAgdk9R5v8/OTHhRQA1RoR3WLxkfC/jIynG3MwGes
         83Vp4mUxAYWA2wWNmxXgs3+Lj8SlFHiwMeYLsjVH5BuBr+hrxhRdAbjVmmkeNduv8Wqe
         zpQwoRF1c4I5h/NwV3C+/tlF0SZCBFmGT7+u/RIAVCOkgw+l3OM6nk5XhgY3sL60sDp3
         Ej/pnE4RukbUPA03628Jhfxnp57YVBAA7jVUdqRkYscHQf1Z1S9U0y2jCczZde0gflG6
         XQpA==
X-Gm-Message-State: AOJu0YwFYGTkEDS06nk1AiqljMwOeNXjbAv+Guu0RwdaMlWYVn12zkR8
	KTgLl8xAzNTMCiZOLaNaAFzysMofJNuH/Gf5+A5Dre/PbUtnEW43GFFX
X-Gm-Gg: AfdE7cnI8DJf2fy76SvN7Lyy7UM7udP9yym3UA2dIEJ/Bj027w+3UxHB/snBwPqxJkQ
	oMKlw7IudetaGqRUzT6yzljD+uKdxU5wztkvmM3eSLZUpxYI2a+UtMVlb+KJVF9VPH6+sCb32Rm
	Jp92e3rhUfPXsXHrCOokpKC2Gm3O60gixJnihOhnoo3AaRkUpdSQw7TPoU5e5qH40OP/+G6l+kT
	j3iAGbTscJ8njNXylsuqK5Q7btszlviJwJnWkSEnbRtUUv06wPcB4IqB7PRPD+NYBOVpPeJBEEV
	1UvP3H/x10yuKvxZRM+kYQOxZdSfDRcVGhjvlGCAM0oegV3OW/97jq6YShZUM5PuV5iW+tjtidg
	1S6DXo18N3ZxIF5Yuwm0WfiETebGEbvE4lJvEG8A8MtyhEBFVkkmA/CK4rTkCOxLLKVOzx9bP36
	EaOVQOXqw=
X-Received: by 2002:a17:902:f688:b0:2c6:6926:8968 with SMTP id d9443c01a7336-2c742b1c878mr98218485ad.20.1782133420911;
        Mon, 22 Jun 2026 06:03:40 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743fd6420sm78895885ad.70.2026.06.22.06.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 06:03:40 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] ocfs2: validate inline xattrs during inode block validation
Date: Mon, 22 Jun 2026 21:03:31 +0800
Message-Id: <20260622130332.2094018-2-zzzccc427@gmail.com>
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

ocfs2_validate_inode_block() verifies a dinode before OCFS2 users walk
metadata from it, but inline xattr metadata is still checked only in
some consumers. The current ibody helper validates the inline header
placement and entry count before deriving the header from
i_xattr_inline_size, but it does not reject entry name/value bounds from
inode block validation.

Extend the shared ibody helper with name/value bounds checks and call it
from ocfs2_validate_inode_block(). Keep the get/list paths using the same
helper before they derive pointers from i_xattr_inline_size so callers
with an already-loaded dinode still get the same corruption check.

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
 fs/ocfs2/xattr.c | 112 +++++++++++++++++++++++++++++++++++++----------
 fs/ocfs2/xattr.h |   2 +
 3 files changed, 95 insertions(+), 23 deletions(-)

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
index fcddd3c13acd..00900e65634d 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -950,39 +950,105 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
 	return result;
 }
 
-static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
-					   struct ocfs2_dinode *di,
-					   struct ocfs2_xattr_header **header)
+static int ocfs2_validate_xattr_entries(struct super_block *sb, u64 blkno,
+					struct ocfs2_xattr_header *xh,
+					size_t storage_size,
+					const char *where)
 {
-	u16 xattr_count;
+	u16 xattr_count = le16_to_cpu(xh->xh_count);
 	size_t max_entries;
+	int i;
+
+	if (storage_size < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid %s in block %llu: storage size %zu is too small\n",
+				   where, (unsigned long long)blkno,
+				   storage_size);
+
+	max_entries = (storage_size - sizeof(*xh)) /
+		      sizeof(struct ocfs2_xattr_entry);
+	if (xattr_count > max_entries) {
+		return ocfs2_error(sb,
+				   "Invalid %s in block %llu: entry count %u exceeds maximum %zu\n",
+				   where, (unsigned long long)blkno,
+				   xattr_count, max_entries);
+	}
+
+	for (i = 0; i < xattr_count; i++) {
+		struct ocfs2_xattr_entry *xe = &xh->xh_entries[i];
+		size_t name_offset = le16_to_cpu(xe->xe_name_offset);
+		size_t value_offset;
+
+		if (name_offset > storage_size ||
+		    xe->xe_name_len > storage_size - name_offset)
+			return ocfs2_error(sb,
+					   "Invalid %s in block %llu: entry %d name is out of bounds\n",
+					   where, (unsigned long long)blkno, i);
+
+		value_offset = name_offset + OCFS2_XATTR_SIZE(xe->xe_name_len);
+		if (value_offset > storage_size)
+			return ocfs2_error(sb,
+					   "Invalid %s in block %llu: entry %d value starts out of bounds\n",
+					   where, (unsigned long long)blkno, i);
+
+		if (ocfs2_xattr_is_local(xe)) {
+			if (le64_to_cpu(xe->xe_value_size) >
+			    storage_size - value_offset)
+				return ocfs2_error(sb,
+						   "Invalid %s in block %llu: entry %d value is out of bounds\n",
+						   where,
+						   (unsigned long long)blkno,
+						   i);
+		} else if (sizeof(struct ocfs2_xattr_value_root) >
+			   storage_size - value_offset) {
+			return ocfs2_error(sb,
+					   "Invalid %s in block %llu: entry %d value root is out of bounds\n",
+					   where, (unsigned long long)blkno, i);
+		}
+	}
+
+	return 0;
+}
+
+static int ocfs2_validate_xattr_ibody_header(struct super_block *sb, u64 blkno,
+					     struct ocfs2_dinode *di,
+					     struct ocfs2_xattr_header **header)
+{
+	struct ocfs2_xattr_header *xh;
 	u16 inline_size = le16_to_cpu(di->i_xattr_inline_size);
 
-	if (inline_size > inode->i_sb->s_blocksize ||
+	if (inline_size > sb->s_blocksize ||
 	    inline_size < sizeof(struct ocfs2_xattr_header)) {
-		ocfs2_error(inode->i_sb,
-			    "Invalid xattr inline size %u in inode %llu\n",
-			    inline_size,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		return -EFSCORRUPTED;
+		return ocfs2_error(sb,
+				   "Invalid inode %llu: xattr inline size %u\n",
+				   (unsigned long long)blkno, inline_size);
 	}
 
-	*header = (struct ocfs2_xattr_header *)
-		((void *)di + inode->i_sb->s_blocksize - inline_size);
+	xh = (struct ocfs2_xattr_header *)
+		((void *)di + sb->s_blocksize - inline_size);
+	if (header)
+		*header = xh;
 
-	xattr_count = le16_to_cpu((*header)->xh_count);
-	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
-		      sizeof(struct ocfs2_xattr_entry);
+	return ocfs2_validate_xattr_entries(sb, blkno, xh, inline_size,
+					    "inline xattr");
+}
 
-	if (xattr_count > max_entries) {
-		ocfs2_error(inode->i_sb,
-			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
-			    xattr_count, max_entries,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		return -EFSCORRUPTED;
-	}
+int ocfs2_validate_inode_xattr(struct super_block *sb, u64 blkno,
+			       struct ocfs2_dinode *di)
+{
+	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL))
+		return 0;
 
-	return 0;
+	return ocfs2_validate_xattr_ibody_header(sb, blkno, di, NULL);
+}
+
+static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
+					   struct ocfs2_dinode *di,
+					   struct ocfs2_xattr_header **header)
+{
+	return ocfs2_validate_xattr_ibody_header(inode->i_sb,
+						OCFS2_I(inode)->ip_blkno,
+						di, header);
 }
 
 int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
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
