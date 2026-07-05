Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D1226F2A0
	for <ocfs2-devel@lists.linux.dev>; Sun,  5 Jul 2026 02:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783220004; cv=none; b=W6P36vLjHoWL8aNG18IiDoRC/Yy6I0n2GxOxv9fKXEbd+tE0C0+qytem7Vw2GrC3nW3bwsOkz3pH+cWwubjyj7XyKkosFCy/PeR6/ok59tepTbqvfZ1cP0xoW0WLrsFOgF4IR5KTb66PGMsSMlIrShQEy3q2tRQtAuKe6+WVL38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783220004; c=relaxed/simple;
	bh=8uw1hcjuhZI+frJMRrQ/82wwOdUpAPEqjUdRrd2ZArc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QFg3lojsMAn5rEUzsfpZdWhiex9fLBEuMr3Uhiy9VX1MU+4nmaTeRD+MuFknOt2TT1yyIt1kiis7UgLqxYxl8H6geYc1HigtyTSKf/GhawrXdPbANv0sW3OLbrErl4DyXjm9kQS0L4+ywEK0pGylzPhGJDk3lG1FMjmIeQlHdZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HAKzD2zI; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAKzD2zI"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-847a5528b33so903570b3a.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 04 Jul 2026 19:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783220000; x=1783824800; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9BFKQS5Hoo1UKGdannPcfOtCqVmG55CXJXvYTzK0mTI=;
        b=HAKzD2zIhT1QLU80v1YeB1LtR5ofx97kEeLjQVnDC6dGUS2i0OV+Ln9E8FwQAj0Wv1
         aOnJTZJbDPV+WxQ6skWpCeh3GpcFyywyisIfya3c2HU8trhPySawRR9nBwfbldBtoWgY
         R6eAP++/JBkx7f0MXxFQh8/q9tsbyk52nHn6uJ3pABx+N4BVGoRKZHoVPi6ejETf9qr5
         7sYEsZuAAbHeSkE8cvpA3IbYyNAbw+H/qzCqiTr3RbqqfiZfQ/bCob4IAtAfP1KFtepo
         x3jr30Fo5KjDjsh5mjTV8xUm3HwAZvTHnjiYz4Roq/UdoM2cuTXjb0IPK37LIOraOWRN
         HnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783220000; x=1783824800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9BFKQS5Hoo1UKGdannPcfOtCqVmG55CXJXvYTzK0mTI=;
        b=hCPTMDccdWBUBYYQXqmJ/akaYRGhhv0Nmp/8eLJuUKrPTn8DlMjriOmCPN/8BE67xs
         m/Tat3doszFUUI8UZz3H4l9GtDiJBPqrIPcvj/K7K9X8+eeqqNgWWyfJszwx//AdZu7/
         PCkaerQHguT7QZJZauTLsgsW6/rpALFJYXQBe3lGrrst2W0Es++QSJVuX8o9gJKPvj4n
         9/45t7ucoaoU+O2hIMByWBMTneCL/GbJ+C9vcojD2IyzFLlmrbkYTGN9giOBoth/nfEO
         e4zpbocUlxGWTVrRWo+Nve+kreOFUeYxXOtLhfcVNu+cgNy55IjfxiK982Hk2YaNT7ls
         L3bw==
X-Gm-Message-State: AOJu0Yy4DnnoSFUfCiUIy5OOzHcZR3WBLwWhzgJBnbUKcnDxrSdlrpw+
	C2CbrdPvasbbMWn7/xOvJu8QUzMReKCeqedsKokYPyNu3O5zV3K9nIe+
X-Gm-Gg: AfdE7cmvRpRcnjern2rhnOiuQe1nSM+1HiTSy6NiC5Q95atMiXnM2dyGa+zFCqWXqNN
	r+Pd6y2sHE5KPNtIl+/zYvTB7h3JQHNtAK6QMV7vqkbW33TZmoTjETdsynmYW4P7qEp3wjSLrhY
	tonTrSlott/qSFvgmTo0ecU21pS8PG4BMm7qRWvaaLBwJhfArXDbJWZY8EhT1A7duHTDdfNAUPx
	+Y9mlU7La+lsmrj/OnFC1bbFvHU2F3wMc3oiZTUuDCaQglCmGNzHYYag+cDF6B0zYYavZGjv8DR
	S6ADPvcy6XdtKfyGjZD0CO8kzoFL31gn2WJ5/9swHwy3c5aTyu4+s5xArMg6OnmAECuKcuPrFnT
	BG6GlnlVcWFge6kiDDcOJFboHz5BRzwM9Qsw4ig1dt1SiYkYrY/KXzWbEAgYBiBYGYCGl7V+Yzd
	O9ChVg79Q=
X-Received: by 2002:a05:6a20:9f96:b0:3bf:bde7:d679 with SMTP id adf61e73a8af0-3c03e572be8mr5375734637.40.1783220000347;
        Sat, 04 Jul 2026 19:53:20 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8bd30ca5sm4253679a12.0.2026.07.04.19.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 19:53:19 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zzzccc427@gmail.com
Subject: [PATCH v7 1/2] ocfs2: validate inline xattrs during inode block validation
Date: Sun,  5 Jul 2026 10:53:10 +0800
Message-Id: <20260705025311.3429854-2-zzzccc427@gmail.com>
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

ocfs2_validate_inode_block() verifies a dinode before OCFS2 users walk
metadata from it, but inline xattr metadata is still checked only in
operation-specific consumers. The existing ibody lookup helper validates
inline header placement and entry count, but inode block validation does
not reject entry name/value bounds.

Add a flat xattr entry validator and call it from inode block validation
for inline xattrs. Keep the operation paths on their existing
header/count lookup checks; the full entry bounds check now runs when
the inode block is validated at read time.

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
 fs/ocfs2/xattr.c | 118 +++++++++++++++++++++++++++++++++++++++++------
 fs/ocfs2/xattr.h |   2 +
 3 files changed, 111 insertions(+), 13 deletions(-)

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
index fcddd3c13acd..ca76441625db 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -950,41 +950,133 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
 	return result;
 }
 
-static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
-					   struct ocfs2_dinode *di,
-					   struct ocfs2_xattr_header **header)
+static int ocfs2_validate_xattr_entries_flat(struct super_block *sb, u64 blkno,
+					     struct ocfs2_xattr_header *xh,
+					     size_t region_size)
+{
+	u16 xattr_count = le16_to_cpu(xh->xh_count);
+	size_t entries_limit = region_size;
+	size_t nv_limit = region_size;
+	size_t max_entries;
+	int i;
+
+	if (region_size < sizeof(*xh))
+		return ocfs2_error(sb,
+				   "Invalid xattr in block %llu: region size %zu is too small\n",
+				   (unsigned long long)blkno, region_size);
+
+	max_entries = (entries_limit - sizeof(*xh)) /
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
+
+		if (name_offset > nv_limit ||
+		    xe->xe_name_len > nv_limit - name_offset)
+			return ocfs2_error(sb,
+					   "Invalid xattr in block %llu: entry %d name is out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		value_offset = name_offset + OCFS2_XATTR_SIZE(xe->xe_name_len);
+		if (value_offset > nv_limit)
+			return ocfs2_error(sb,
+					   "Invalid xattr in block %llu: entry %d value starts out of bounds\n",
+					   (unsigned long long)blkno, i);
+
+		if (ocfs2_xattr_is_local(xe)) {
+			if (le64_to_cpu(xe->xe_value_size) >
+			    nv_limit - value_offset)
+				return ocfs2_error(sb,
+						   "Invalid xattr in block %llu: entry %d value is out of bounds\n",
+						   (unsigned long long)blkno,
+						   i);
+		} else if (sizeof(struct ocfs2_xattr_value_root) >
+			   nv_limit - value_offset) {
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
+	return ocfs2_validate_xattr_entries_flat(sb, blkno, xh, inline_size);
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


