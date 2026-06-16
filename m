Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EFF41B375
	for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 09:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781601105; cv=none; b=GlbSyMrrUE6ZiTiOvgLeCg1DKGd3I3seYSMcArjFkhNGnqFfEeMsF6iwCF0GAHYazuXQHiKA5BjfbJ4xscWDnbK5ZwMVvAjC8pTxBf+xDlpcpCURMiitYUmknkC+e0x7jIIT8MRTVlv5S7OmWyaS5v6OT5ejqoLm0q096sYVbTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781601105; c=relaxed/simple;
	bh=DcxEgghvzNfjMZsuJW0EvNN7dEv/ktJ2r9GNVhvzH9Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dY0EEXzfKqtLCraFRlqM3yW/sQsrh6ct4GihhJzrBovNWPed01w1WMukPPydR3k0meTIhn9D2tU7vyLIgBFcXDJ079K2ZHhEy1vua3DH6RYDdTyWqJZuj6TlSbbGs2yIjHBRWkVrsYo9nPD9qGwysLcbufKf7ipHNqd7nD36BJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dHWzf2RS; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dHWzf2RS"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2bf30d530bdso42492025ad.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 16 Jun 2026 02:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781601104; x=1782205904; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vajeine3tDHsQmVN/u6jgppiHsGvf9YH+vObZaPTS9A=;
        b=dHWzf2RSJNpj7yorfiKRIrHpNRW63DlcQ+EwK3ElDp42xfw/chGUghLDww3/Od3Az/
         yhscqM6YSafTcxeJKCARKHcMUNPLilQOqUeOBitPpmH2tqhaagL8aXHXWpg0PCes6OZL
         /HfbVVVpQf6/iMt/++xHyujT1xh+9U52mwgO7cl5kAOqTFy6SncOOvDKGBbm1FiEgPKl
         3W/JTnBHr79YS2dna5O2LhA9/3X29rfKpAZqfb8fMoVq7SbxFKwetP+OpM0MLWCfMy5l
         BGKXHZ84uYybBj0x5c3tIr5S2rlcTzipLVm6ITTkPJm1RICylRllsCtM5zQ+Ufw34xDF
         iLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781601104; x=1782205904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vajeine3tDHsQmVN/u6jgppiHsGvf9YH+vObZaPTS9A=;
        b=hDMksQ2uL50f6xW+Xm80j0K2jRc/DhcDKwZDBwa46wMR49tYAS7G19L5xtv8yOViNM
         k6KFnkWbprYGDzA15kYrS3fxVijR8sVlUh5zBdUlNuczMIBm1zrSCt9TStxH99il3Pls
         /Wvy/qvcHHzIr+7NhJOBVAP9RcveHyyndEIEdQUVOUe2QCQf1plj7mBjjTNpZ18uu8w2
         PVZBpD93tty8Y5oPBEUtCMTjFn2fcKDSi4kCN1O7NJw8RA2/erz2YxAAoLfddlZA0ft4
         2YeUCuiXAxOlowyxCpqrSS4ZQwJS7jtvaBABAf6+X8kC3mNjfvnMJIDVoFs/wkf1fbPA
         j2rQ==
X-Gm-Message-State: AOJu0Ywe4NwwIcCKqe9WEvELz/hT6jecvFCxuREPl/0jMlps1fSQng7Z
	bCvMQTRWXaG8Y8zM/2jId78uRtCQTtojEbzXvvnA5e9j6GlmG4bSQeb5
X-Gm-Gg: Acq92OHm9+IotjRwDfS3nwRxOtkTxB8XQgIojEq0S46aQSViT4c8Ugc8WXS3Ag1sd6L
	yj0rxKE81vwH96uJDIR5IVVq+O6iBaZd439PJG6HnX/Mzhu2coSQ/IWmTZQeYmQ940t8XpdN5tX
	VOuSD5uU+FIFzJzrjWUwY7f6VjC32txU/no0TlpeuYfCc90BlLZAT3hrIS17AYj11hD2wYZo8gL
	pIVHZO2jHNopmQEnCZTwBMh98wUxRz4oX6neqjQWuLXwCjdHnF0U1doO8dAhG/h3Isw4ngcUaSS
	hVf5Sdg0WB9doPrtLSp5naEujAV1NAdxpz2iRIFRyGpluXAFeKPbTz6zeA0ZV+bt5Vs+8zbpfzU
	r+mtfHn1iRqWiXyVp3sITKJ7HR+WeYphTlib7+mwV4Xu2ZUCoOQxowPG5+rRWGAys3jFaovX1rs
	voSRHKcTXmd9LXch3yMcE7eTTLLs76q2X7ywV6IrHwL8IuUs2Kpx38dsxjMyKRb0vztM21QYQS5
	8iUsw==
X-Received: by 2002:a17:902:ecc1:b0:2b7:abc0:3bd7 with SMTP id d9443c01a7336-2c6641b91f7mr165088905ad.9.1781601103647;
        Tue, 16 Jun 2026 02:11:43 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c4328a43c9sm127502645ad.41.2026.06.16.02.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 02:11:43 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	rollkingzzc@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>
Subject: [PATCH v3 1/2] ocfs2: validate inline xattrs during inode block validation
Date: Tue, 16 Jun 2026 17:11:31 +0800
Message-Id: <20260616091132.3990054-2-rollkingzzc@gmail.com>
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

ocfs2_validate_inode_block() verifies a dinode before OCFS2 users walk
metadata from it, but inline xattr metadata is still checked only in
some consumers. In particular, ocfs2_xattr_ibody_get() derives the
inline xattr header from i_xattr_inline_size before calling
ocfs2_xattr_find_entry().

Move the inline xattr size and entry bounds checks behind a shared
helper and call it from ocfs2_validate_inode_block(). Keep the get/list
paths using the same helper before they derive pointers from
i_xattr_inline_size so callers with an already-loaded dinode still get
the same corruption check.

Reject corrupted inline xattr metadata before ocfs2_xattr_ibody_get()
or listxattr() can walk past the inline storage.

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
 fs/ocfs2/xattr.c | 131 ++++++++++++++++++++++++++++++++++++++++--------------
 fs/ocfs2/xattr.h |   2 +
 3 files changed, 103 insertions(+), 34 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index a510a0eb1adc..e47d2c1befbe 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1494,6 +1494,10 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	rc = ocfs2_validate_inode_xattr(sb, di);
+	if (rc)
+		goto bail;
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 86cfd4c2adf9..caff7ae7291e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -464,6 +464,93 @@ static void ocfs2_xattr_bucket_copy_data(struct ocfs2_xattr_bucket *dest,
 	}
 }
 
+static struct ocfs2_xattr_header *
+ocfs2_xattr_inline_header(struct super_block *sb, struct ocfs2_dinode *di)
+{
+	return (struct ocfs2_xattr_header *)((void *)di + sb->s_blocksize -
+					     le16_to_cpu(di->i_xattr_inline_size));
+}
+
+static int ocfs2_validate_xattr_entries(struct super_block *sb, u64 blkno,
+					struct ocfs2_xattr_header *xh,
+					size_t storage_size,
+					const char *where)
+{
+	u16 xattr_count = le16_to_cpu(xh->xh_count);
+	size_t max_entries;
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
+	if (xattr_count > max_entries)
+		return ocfs2_error(sb,
+				   "Invalid %s in block %llu: entry count %u exceeds maximum %zu\n",
+				   where, (unsigned long long)blkno,
+				   xattr_count, max_entries);
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
+int ocfs2_validate_inode_xattr(struct super_block *sb, struct ocfs2_dinode *di)
+{
+	struct ocfs2_xattr_header *xh;
+	u16 inline_size;
+
+	if (!(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_XATTR_FL))
+		return 0;
+
+	inline_size = le16_to_cpu(di->i_xattr_inline_size);
+	if (inline_size > sb->s_blocksize ||
+	    inline_size < sizeof(struct ocfs2_xattr_header))
+		return ocfs2_error(sb,
+				   "Invalid dinode %llu: xattr inline size %u\n",
+				   (unsigned long long)le64_to_cpu(di->i_blkno),
+				   inline_size);
+
+	xh = ocfs2_xattr_inline_header(sb, di);
+	return ocfs2_validate_xattr_entries(sb, le64_to_cpu(di->i_blkno), xh,
+					    inline_size, "inline xattr");
+}
+
 static int ocfs2_validate_xattr_block(struct super_block *sb,
 				      struct buffer_head *bh)
 {
@@ -956,9 +1043,7 @@ int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 	struct ocfs2_xattr_header *xh;
 	int i;
 
-	xh = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize -
-		 le16_to_cpu(di->i_xattr_inline_size));
+	xh = ocfs2_xattr_inline_header(inode->i_sb, di);
 
 	for (i = 0; i < le16_to_cpu(xh->xh_count); i++)
 		if (!ocfs2_xattr_is_local(&xh->xh_entries[i]))
@@ -975,40 +1060,15 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
 	struct ocfs2_xattr_header *header = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	int ret = 0;
-	u16 xattr_count;
-	size_t max_entries;
-	u16 inline_size;
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
 		return ret;
 
-	inline_size = le16_to_cpu(di->i_xattr_inline_size);
-
-	/* Validate inline size is reasonable */
-	if (inline_size > inode->i_sb->s_blocksize ||
-	    inline_size < sizeof(struct ocfs2_xattr_header)) {
-		ocfs2_error(inode->i_sb,
-			    "Invalid xattr inline size %u in inode %llu\n",
-			    inline_size,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		return -EFSCORRUPTED;
-	}
-
-	header = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize - inline_size);
-
-	xattr_count = le16_to_cpu(header->xh_count);
-	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
-		       sizeof(struct ocfs2_xattr_entry);
-
-	if (xattr_count > max_entries) {
-		ocfs2_error(inode->i_sb,
-			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
-			    xattr_count, max_entries,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		return -EFSCORRUPTED;
-	}
+	ret = ocfs2_validate_inode_xattr(inode->i_sb, di);
+	if (ret)
+		return ret;
 
+	header = ocfs2_xattr_inline_header(inode->i_sb, di);
 	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
 
 	return ret;
@@ -1199,9 +1259,12 @@ static int ocfs2_xattr_ibody_get(struct inode *inode,
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
 		return -ENODATA;
 
+	ret = ocfs2_validate_inode_xattr(inode->i_sb, di);
+	if (ret)
+		return ret;
+
 	xs->end = (void *)di + inode->i_sb->s_blocksize;
-	xs->header = (struct ocfs2_xattr_header *)
-			(xs->end - le16_to_cpu(di->i_xattr_inline_size));
+	xs->header = ocfs2_xattr_inline_header(inode->i_sb, di);
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
diff --git a/fs/ocfs2/xattr.h b/fs/ocfs2/xattr.h
index 65e9aa743919..51a1a8cb6244 100644
--- a/fs/ocfs2/xattr.h
+++ b/fs/ocfs2/xattr.h
@@ -35,6 +35,8 @@ extern const struct xattr_handler * const ocfs2_xattr_handlers[];
 ssize_t ocfs2_listxattr(struct dentry *, char *, size_t);
 int ocfs2_xattr_get_nolock(struct inode *, struct buffer_head *, int,
 			   const char *, void *, size_t);
+int ocfs2_validate_inode_xattr(struct super_block *sb,
+			       struct ocfs2_dinode *di);
 int ocfs2_xattr_set(struct inode *, int, const char *, const void *,
 		    size_t, int);
 int ocfs2_xattr_set_handle(handle_t *, struct inode *, struct buffer_head *,
-- 
2.43.0

