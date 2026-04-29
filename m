Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDF038238C
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Apr 2026 02:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777430701; cv=none; b=Txh7vboZ7zfTKKlkydMaU3J8zCKRVxIK5af/HGWz4LlLz5DtNlzBZC3nksM1sDDAHMoJodoynmozvdcRxxpHxqRd3MmrgnccJzcKEdbz6O2BID5BTG/zw/EsJ4VnfxYJvbUCr5WxDJUzwl7ijOYR9RuofTBEuKHVJHJP9llvqT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777430701; c=relaxed/simple;
	bh=jkjvGECmr8w0pGv1jRD1kbmd0kHxeua93c+nvXlVex0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OFbVntELLkwlrwS+JHKu8HpwXzaS0IHtS1LaxNGGSKWlR4+ogObYz/xXVxhpU4Qb5cI9xmXwu5himk7ON48D7PYE+N6REdWnrbBbKoQagWfFOsrSwcJerSzt4R0FRrvuCSxiAjh222VDxX2hvueCmh1wxUAUL7rDRXCqqpnmICY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qzlt1aZ2; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qzlt1aZ2"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c76c60c7502so171197a12.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 28 Apr 2026 19:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777430699; x=1778035499; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XBG3Ln9sZf7gK1z4kykeX5M87aCaIiJ6hjyidiUZXBo=;
        b=qzlt1aZ2gdLAQKI+4wY5pGEPY15A6++N2FeaB4YsC4W5brXmDhu8zE14uxX7ZCQ5HV
         R5T2D32JrwWUBPw9H3DaiIQ7szC8UE4gEQRgjLuN4Kx1mUQyzW/dh4Wbyid8ECamDjtT
         Q0KVe0eM1pisiYAFVYoTmudsIiEtfpnRamNWuZhtx5HP0vvQehdsKQIh2bpT7SNnfzch
         OzpQDpkCA+923F3/w102j5e2eyGAFPnVJrvpphvBRmrHRQnsurZBnzsAfavVAo2Z7TY4
         V1yyC/b7BRSa+DlRbJDXd9VDnvSaPn76UQHHMVLyJKmj9BV3nmZR8cYJh81krmEich/z
         a/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777430699; x=1778035499;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XBG3Ln9sZf7gK1z4kykeX5M87aCaIiJ6hjyidiUZXBo=;
        b=Gkkjf062PgTPU7R/TPcKHBxKOy9eVdyd3jNHoweShJDIo8LEcyUhcS9N6c41VTK9Fl
         KD9DsTyA0L3MKEZ3qhY2Lq37mbNI/C6bF6ChEL+y35C1rGeZTA3tmhN5LV3zP/5QSPol
         p7UFdAm14Xbde2SSMoGHyysYysxh1t9SIuhv1LD094JaG0c1PEcv1OGnI3eTvCfglqnf
         6nqYLUsTKy71m14xGvdZPzdEZpNOIH1iMBTf68W71Lb9giNk8HrqhDEe+BNuG2hsfw8A
         /LbgQqiZR8sRQrJs7ni/v+OAPENPpw3dI4le17yYV+h+oKhzRNUIdEBJeM5zxPQsFhVM
         wNxw==
X-Gm-Message-State: AOJu0YxvsrCw8qPIR+DXproEJDPx6icJs39is+AHCduep66ouISZPrMe
	8Im7pIsGcGjxaw2j4Gzpyv8uVXS/v6+hUrAbkyr0WxiSt4wJWDtY9pKy
X-Gm-Gg: AeBDieuLhoBK9ZAjpRPBiLFHDytn2yt2eJDKzGI8Hsgh7lgoWrRcRRKN57M/c8J4et0
	vQM/URNms0s0fSIU13ZuI5UBWqkqdlcLJD7O6accv2aBYGSQqR1Wl6QQlPoJOnifq5fdO2wA2H3
	5BT6JZosckOiWdGSwaiCPiFordUjUdPYaGTP//aJu5t1GmlvCFQGW57I6Nbq/9jkR2FyA6a5Unm
	tpgYsXEeScuSTNztbo62C0a6s6xytaTEdKbEiEcD9frpiF0+j4lXZ6cFhtbgjxpL7b0keaAjioH
	AIIQnT3LQuU5JpHsvlwIrykd5IAF8CmntTkemW0ImjkWlutanms9tT4WxIeTCRtZWnyoMsrVgBi
	M/boX05JtWZ9U0WbHLUCQk21s0ijs1hObgeZ5+F4tjEksQ9Mz9GYPi6md1Fkgp5ZZm1VreRDg3J
	cSseDj3tarLxKD5XoVWCvXxP5PlMOFq7jXwbLBEbrfp7tZIq2n3V2Qm7yXKx4DA5mF5NFh7KsFP
	2zv5E6uYw==
X-Received: by 2002:a17:903:1988:b0:2ae:5ab4:f4c0 with SMTP id d9443c01a7336-2b988433716mr10313805ad.13.1777430699262;
        Tue, 28 Apr 2026 19:44:59 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b988772cabsm5895555ad.13.2026.04.28.19.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 19:44:58 -0700 (PDT)
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
Subject: [PATCH] ocfs2: validate inline xattr header before listxattr walks it
Date: Wed, 29 Apr 2026 10:44:34 +0800
Message-ID: <20260429024434.1472685-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
listxattr() can walk off the end of a dinode block when the inode-body
xattr header is corrupted:

BUG: KASAN: use-after-free in ocfs2_xattr_list_entry+0x1bd/0x370 fs/ocfs2/xattr.c:918
Read of size 13 at addr ffff88800ab5c0c0 by task syz.0.1231/3756

Call Trace:
 ...
 ocfs2_xattr_list_entry+0x1bd/0x370 fs/ocfs2/xattr.c:918
 ocfs2_xattr_list_entries+0x1e1/0x320 fs/ocfs2/xattr.c:938
 ocfs2_xattr_ibody_list fs/ocfs2/xattr.c:982 [inline]
 ocfs2_listxattr+0x4fb/0x980 fs/ocfs2/xattr.c:1044
 vfs_listxattr+0xb4/0x120 fs/xattr.c:493
 listxattr+0x76/0x170 fs/xattr.c:924
 filename_listxattr fs/xattr.c:958 [inline]
 path_listxattrat+0x137/0x320 fs/xattr.c:988
 __do_sys_listxattr fs/xattr.c:1001 [inline]
 ...

[CAUSE]
ocfs2_xattr_ibody_list() computes the inline xattr header from
di->i_xattr_inline_size and passes it straight to
ocfs2_xattr_list_entries(). If corruption inflates xh_count, the list
walk steps past the inline xattr area and eventually past the end of the
4K dinode block. The xe_type load in ocfs2_xattr_get_type() then reads
poisoned memory.

[FIX]
Validate di->i_xattr_inline_size before locating the header, then bound
xh_count by the number of ocfs2_xattr_entry records that fit inside the
claimed inline area. Reject corrupted metadata with ocfs2_error() and
-EFSCORRUPTED instead of iterating past the dinode block.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/xattr.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@
 static int ocfs2_xattr_ibody_list(struct inode *inode,
 				  struct ocfs2_dinode *di,
 				  char *buffer,
 				  size_t buffer_size)
 {
 	struct ocfs2_xattr_header *header = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	int ret = 0;
+	u16 xattr_count;
+	size_t max_entries;
+	u16 inline_size;
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
 		return ret;
 
+	inline_size = le16_to_cpu(di->i_xattr_inline_size);
+
+	if (inline_size > inode->i_sb->s_blocksize ||
+	    inline_size < sizeof(struct ocfs2_xattr_header)) {
+		ocfs2_error(inode->i_sb,
+			    "Invalid xattr inline size %u in inode %llu\n",
+			    inline_size,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EFSCORRUPTED;
+	}
+
 	header = (struct ocfs2_xattr_header *)
 		 ((void *)di + inode->i_sb->s_blocksize -
-		 le16_to_cpu(di->i_xattr_inline_size));
+		 inline_size);
+
+	xattr_count = le16_to_cpu(header->xh_count);
+	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
+		      sizeof(struct ocfs2_xattr_entry);
+	if (xattr_count > max_entries) {
+		ocfs2_error(inode->i_sb,
+			    "Invalid xattr entry count %u (max %zu) in inode %llu\n",
+			    xattr_count, max_entries,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EFSCORRUPTED;
+	}
 
 	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
 
 	return ret;
 }
-- 
2.43.0
