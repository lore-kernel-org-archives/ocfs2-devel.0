Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B2A3DEAF7
	for <ocfs2-devel@lists.linux.dev>; Thu, 23 Apr 2026 08:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776934575; cv=none; b=PIkngP3ktA87K8dfSzQtsdwjnUy7dYjhBnA6DibMUgHxyoLVmzYKsSxAO6IUSNbdYGziQb9r43pCbTTz/dwDBhnCXyF1gEW3Pj/3FCWUQ8wK1SWsPh8YlSrqVegw3ssxCRI0sgvZeyE+o6dxo0BJ3weYp5p2+8w4TJ1k7r0hbE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776934575; c=relaxed/simple;
	bh=oRtsLvscJH40c3kDBF1xAYyriuHOuV10psBdRWoiw/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UGX1KYda4VTz19pvnKCVspIqfvX+32nYcONO41CRASTAhFWhGqf9UDGl2FlHZn2d8VwoMRCaUU4VxhYDp5FsiDGam/CAk+7UoxUGiikgGQqG75EfGf2YeFQcAISjuCqyKvzFRRlFh7UVOp+b4AFMcq0qP1HGDMRn/XtjDKY+Kgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ozclCtlM; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ozclCtlM"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35da1af3e10so6046822a91.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 23 Apr 2026 01:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776934574; x=1777539374; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OgKN8yTSWGcVCu/iEvMhp75Cmz8v3eId3itEiRRQJ7Q=;
        b=ozclCtlMOq/XG2i5S4BpeRpJaRLvlVdRda/YotmY1i80QaAnOGz4GJPYNwRCayb4VI
         C0gM0W6kqSHJxVypBHQmsVcuM/GNmI6wLr7qlMgIxK5PC9SV0F1bqlNm+inhGEndA316
         wWgLR7Eqa3AOSsAvn6iirHf3adcBSDGA+L8jOqE4lFYb0971VdyWR+AXXfEmyK6wequX
         IMWRGnikSygLqzT/FL1svItMqpy8b0lYPqwPCwg3yo4+cr0XEdggTnxGW/lOHydCXrHT
         q56ZtRKSwzNVSkA/OcFq2a8vKkBsQkaoB+dSEsn6L1LDnhPm+a8iHRbE1RoiwmI7dXuK
         lCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776934574; x=1777539374;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OgKN8yTSWGcVCu/iEvMhp75Cmz8v3eId3itEiRRQJ7Q=;
        b=Mt2UB92BLhS4t84Rt7WsB1UCWWoX4C1A+CGkN4JEiB+CBcrsE1YPT3qthnXVOylFg+
         3bJ5LkBlWkUE4HjqahSbGVujG04KPrpOCiXU1SFeIKGL2QQUYRYe/7DtBKMVlBltiuNB
         /mtJQnB0zulUMP9R/DC7Mt84DUxA1g8tca9ThcfLTiGZvcIM8INhNF7d6u/dnqghmmti
         pwlCHHdGYo1p/Cxa3yYWmDpVbQkMY2G9kSc9quDWrmYWVeeNxJ5WPKPpdzfazIiX/CQI
         N7tfV05EoAk0VOiSSVOE2NybUF+DEKUsxno18Q8ZSIGkJHdEl48nXuXCds4vexYsenyh
         lLXw==
X-Gm-Message-State: AOJu0YwGKwyBwnUfSepYLPlioK+lWEB1up2D3UZTQ2wn+5UL4wY56UGQ
	XS1xpfChw1twuHdoI/Nr1jsv6Ry8ND0Y2bGfwVOVc5Lky44bUxRTzyOA
X-Gm-Gg: AeBDies/6Xim9F1+lJUXW9C/6hRAolKlp3sdxBeMcVubCCeFyVEg2mwSuF6CXhEvaJM
	u3IARzKhOWlPN5aABcGp6Z5Db1RUMKSP/8y3ei4yTEJg0tOYqMrJBAl/SgV7W2MaQu7X/9nOi73
	VGgqHuCy+6iMZNsA6DscD4EhnorCkyvsdBL0ok8eotEOzBDdQoLlbmcx3/UZDf1+yjoHMfxpWPW
	favUdEJmLTZTwYfStA0iVPg/c50jR+LLx4VTX/7zPgiYo+cZjyENFsZOlXiKVWklnpj55srWmLC
	5QoNH8JHLgGqJZPyQVlTorsIdNhJj01Y3iEW1uszonVtZzpy9f4ZA3TY159hhzTyvy7WCK/GyXm
	+6WcOl8ob6pfYjlMVsxKC25izKLc8ry0jzBvr/V4VRBiB9Y4KqmrHi7F6LEqCG34xIbkQ5jFiGF
	tWU/H8CAVHYWvYLV0mk5hQ5QWwjUMcxVNya5/JCeyPzG2zA1Tyf1NhudiWv3ZObnocpudPNYNHE
	CUNdT7N2w==
X-Received: by 2002:a17:90b:5865:b0:35e:27ec:dea with SMTP id 98e67ed59e1d1-36140493410mr29092717a91.23.1776934573535;
        Thu, 23 Apr 2026 01:56:13 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-361410a7ab7sm24885673a91.10.2026.04.23.01.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 01:56:13 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH] ocfs2: validate external xattr value roots before reuse
Date: Thu, 23 Apr 2026 16:55:20 +0800
Message-ID: <20260423085520.2180830-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted image can make setxattr() trip over:

kernel BUG at fs/ocfs2/xattr.c:743!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_xattr_extend_allocation+0x5d1/0x850 fs/ocfs2/xattr.c:743
Call Trace:
 ocfs2_xattr_value_truncate+0x50f/0x700 fs/ocfs2/xattr.c:864
 ocfs2_xa_value_truncate+0xd4/0x1f0 fs/ocfs2/xattr.c:1915
 ocfs2_xa_reuse_entry fs/ocfs2/xattr.c:2097 [inline]
 ocfs2_xa_prepare_entry fs/ocfs2/xattr.c:2141 [inline]
 ocfs2_xa_set+0x21d8/0x30a0 fs/ocfs2/xattr.c:2251
 ocfs2_xattr_block_set+0x296/0x770 fs/ocfs2/xattr.c:2985
 __ocfs2_xattr_set_handle+0x301/0xdb0 fs/ocfs2/xattr.c:3387
 ocfs2_xattr_set+0x1447/0x2610 fs/ocfs2/xattr.c:3650
 ocfs2_xattr_trusted_set+0x37/0x50 fs/ocfs2/xattr.c:7336
 __vfs_setxattr+0x14f/0x1c0 fs/xattr.c:200
 __vfs_setxattr_noperm+0x10b/0x5c0 fs/xattr.c:234
 __vfs_setxattr_locked+0x172/0x240 fs/xattr.c:295
 vfs_setxattr+0x167/0x390 fs/xattr.c:321
 do_setxattr+0x13c/0x180 fs/xattr.c:636
 filename_setxattr+0x16b/0x1c0 fs/xattr.c:665
 path_setxattrat+0x1d8/0x280 fs/xattr.c:713
 __do_sys_setxattr fs/xattr.c:747 [inline]
 __se_sys_setxattr fs/xattr.c:743 [inline]
 ...

[CAUSE]
Exact-match xattr lookup validates only the entry pointer and name
bytes. It does not validate the embedded ocfs2_xattr_value_root that
sits behind a non-local xattr entry.

ocfs2_xa_reuse_entry() therefore accepts a corrupt on-disk value root,
feeds its xr_clusters/xr_list into ocfs2_xattr_value_truncate(), and
can reach ocfs2_add_clusters_in_btree() with a tree state that violates
the allocator's assumptions. When that happens,
ocfs2_xattr_extend_allocation() sees RESTART_META in a path that
assumes only RESTART_TRANS is possible and fires BUG_ON().

[FIX]
Add a validator for external xattr value roots and run it at the
exact-match lookup boundary, before the found entry is handed to
xs->here.

The new check rejects corrupt non-local xattr entries whose embedded
value root does not fit in the storage region or whose fixed root
extent-list invariants are broken. This stops the bad metadata before
setxattr() can reuse it and reach the BUG_ON().

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
No Fixes tag is added because this is a defensive read-side validation
for long-standing metadata assumptions rather than a single-commit
regression.
---
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 86cfd4c2adf9..88f1a979d734 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -237,6 +237,81 @@ static int namevalue_size_xe(struct ocfs2_xattr_entry *xe)
 	return namevalue_size(xe->xe_name_len, value_len);
 }
 
+static int ocfs2_validate_xv_root(struct inode *inode,
+				  struct ocfs2_xattr_entry *xe,
+				  void *base,
+				  void *end)
+{
+	char *nameval = base + le16_to_cpu(xe->xe_name_offset);
+	struct ocfs2_xattr_value_root *xv;
+	struct ocfs2_extent_list *el;
+	struct ocfs2_extent_rec *rec;
+	u16 tree_depth, count, next_free;
+	u32 clusters, expected_clusters, rec_clusters;
+	u64 last_eb_blk;
+
+	if (nameval + OCFS2_XATTR_SIZE(xe->xe_name_len) +
+	    OCFS2_XATTR_ROOT_SIZE > (char *)end)
+		return ocfs2_error(inode->i_sb,
+				   "Inode %llu has corrupt xattr value root bounds\n",
+				   (unsigned long long)OCFS2_I(inode)->ip_blkno);
+
+	xv = (struct ocfs2_xattr_value_root *)(nameval +
+					      OCFS2_XATTR_SIZE(xe->xe_name_len));
+	el = &xv->xr_list;
+	tree_depth = le16_to_cpu(el->l_tree_depth);
+	count = le16_to_cpu(el->l_count);
+	next_free = le16_to_cpu(el->l_next_free_rec);
+	clusters = le32_to_cpu(xv->xr_clusters);
+	expected_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
+						     le64_to_cpu(xe->xe_value_size));
+	last_eb_blk = le64_to_cpu(xv->xr_last_eb_blk);
+
+	if (count != 1)
+		return ocfs2_error(inode->i_sb,
+				   "Inode %llu has invalid xattr value root count %u\n",
+				   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				   count);
+
+	if (next_free != 1)
+		return ocfs2_error(inode->i_sb,
+				   "Inode %llu has invalid xattr value root index %u\n",
+				   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				   next_free);
+
+	if (tree_depth >= OCFS2_MAX_PATH_DEPTH)
+		return ocfs2_error(inode->i_sb,
+				   "Inode %llu has invalid xattr value root depth %u\n",
+				   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				   tree_depth);
+
+	if (!!last_eb_blk != !!tree_depth)
+		return ocfs2_error(inode->i_sb,
+				   "Inode %llu has inconsistent xattr value root last_eb %llu at depth %u\n",
+				   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				   (unsigned long long)last_eb_blk,
+				   tree_depth);
+
+	if (!clusters || clusters != expected_clusters)
+		return ocfs2_error(inode->i_sb,
+				   "Inode %llu has invalid xattr value root clusters %u (expected %u)\n",
+				   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				   clusters, expected_clusters);
+
+	rec = &el->l_recs[0];
+	rec_clusters = ocfs2_rec_clusters(el, rec);
+	if (!le64_to_cpu(rec->e_blkno) || le32_to_cpu(rec->e_cpos) ||
+	    !rec_clusters || rec_clusters != clusters)
+		return ocfs2_error(inode->i_sb,
+				   "Inode %llu has corrupt xattr value root record (%u, %u, %llu) for %u clusters\n",
+				   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+				   le32_to_cpu(rec->e_cpos), rec_clusters,
+				   (unsigned long long)le64_to_cpu(rec->e_blkno),
+				   clusters);
+
+	return 0;
+}
+
 
 static int ocfs2_xattr_bucket_get_name_value(struct super_block *sb,
 				     struct ocfs2_xattr_header *xh,
@@ -1098,7 +1173,7 @@ static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
 {
 	struct ocfs2_xattr_entry *entry;
 	size_t name_len;
-	int i, name_offset, cmp = 1;
+	int i, name_offset, cmp = 1, ret;
 
 	if (name == NULL)
 		return -EINVAL;
@@ -1121,6 +1196,11 @@ static int ocfs2_xattr_find_entry(struct inode *inode, int name_index,
 				return -EFSCORRUPTED;
 			}
 			cmp = memcmp(name, (xs->base + name_offset), name_len);
+			if (!cmp && !ocfs2_xattr_is_local(entry)) {
+				ret = ocfs2_validate_xv_root(inode, entry, xs->base, xs->end);
+				if (ret)
+					return ret;
+			}
 		}
 		if (cmp == 0)
 			break;
@@ -3790,6 +3870,8 @@ static int ocfs2_find_xe_in_bucket(struct inode *inode,
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
 	size_t name_len = strlen(name);
 	struct ocfs2_xattr_entry *xe = NULL;
+	char *block;
+	char *block_end;
 	char *xe_name;
 
 	/*
@@ -3821,8 +3903,15 @@ static int ocfs2_find_xe_in_bucket(struct inode *inode,
 		}
 
 
-		xe_name = bucket_block(bucket, block_off) + new_offset;
+		block = bucket_block(bucket, block_off);
+		block_end = block + inode->i_sb->s_blocksize;
+		xe_name = block + new_offset;
 		if (!memcmp(name, xe_name, name_len)) {
+			if (!ocfs2_xattr_is_local(xe)) {
+				ret = ocfs2_validate_xv_root(inode, xe, block, block_end);
+				if (ret)
+					break;
+			}
 			*xe_index = i;
 			*found = 1;
 			ret = 0;
-- 
2.43.0
