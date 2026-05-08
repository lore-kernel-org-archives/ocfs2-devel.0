Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951E837A4AF
	for <ocfs2-devel@lists.linux.dev>; Fri,  8 May 2026 08:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778230784; cv=none; b=G9ZUzLEFLw4UKbaX5c6RHiJxrczIviaKADI/oAgrepPIeCK6+gs34r7Rp/JzdcQj78BYaXv0xzNUqJq+SkEafCr2QZ5HYK8P+GcDARIN0IIIBheYzuBRUPPjMn+wIIuF7cCm+HIGvd3ag8pAX6zaY9YPA/7uChUE6LDj9zBCRRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778230784; c=relaxed/simple;
	bh=D6IA2R9w6FO3pMYFRfXfz3ryYo0/dfTfvU1usz5XE9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSPHkkR7n/obEvnNCJ3c4gUX+wp5PZURtGbrs6w9IvC6vQMgTQkof+9Fzmbxep6vMh4sFRwCrAcklLFPEwXoPu8xwTYkkLvJbpMPzGqJr90bXJnYe+oljdlYT7nQ7CnPC0vJ3/k1gyHFuJlthie35xL/bd4tC73g3IDReHbfHJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qlka2bMZ; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qlka2bMZ"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2aaed195901so8964755ad.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 08 May 2026 01:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778230783; x=1778835583; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AjVbr/NOmM7hKB0cr1i4CxCGjBAPx4CaOHs0zMtPvmM=;
        b=Qlka2bMZWM5MYAY34GDzZY31eEjdVUJC04BWV6fF3jk/dzfc5pAdsZAG97hl0D/yrZ
         MkoBLcWbMjyVpgeE2G7bLVUQs0OYzEUN9ygAtR5pyIoWUR8feaLAsQcOdWg8RsS9F3mj
         XpFGYsxu2ef8rNKsZ3GLap/nMQxoTyaf0XQZNbngBQlSUB70KqCfjbXJmrzKAKL3/Fwf
         E+sEDlCHrGjGtkejTfbT3yl5icnI8ZeZrF3gu1yVcQ6D7Us/8jnTxKU4XT02tAAJ56X7
         VGImWosdEOl8YCuZDDdvE/NkEk2+rAzg0TPhNTQVLZh3Yce8kbCGW9KQYy4vGklDEGzw
         1fnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778230783; x=1778835583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AjVbr/NOmM7hKB0cr1i4CxCGjBAPx4CaOHs0zMtPvmM=;
        b=CvniCWptRhxlB4zjqMewrLtw3L9xDFyBe+9UC3ufwQIyLE8H+5L6q0C/8vqgY1eMEB
         DuTqVSC3LpB9HxnIW5oUEsHrL4eGP9QD/UtihkoGOmqgAWsee2CI2AEZoXTF2HUBvNzD
         q2zBxbmSj/SvUbwrnoxUNIKE0h+dZCujNW0d9nA/uk4Fn6iUTXJqg+miiEwRJlCiEe4N
         PWFDekWXZmnM0Xl3+WKFTs+GvY2ntvetg1fPM/rIhupa2HWH5EbnSEIth/7iP5pzAvU8
         C+8dQB2b2OWW2uFXCHgGgtJJYK6rGhlu8jUFu/bUgbu/QcXLz57kCxvmmLTVgK4dtssK
         WufA==
X-Gm-Message-State: AOJu0YxznUSxaYRVnA9btY8xn+pqgxjKuvVuSZlEbA9si/EFODMz1nEf
	Tvxim0zpbTVgu8brm+2LCHHh9BDNS7VONmCsr1/w1IpI5sisAk2ONF8o
X-Gm-Gg: Acq92OE6KZ0Odfp/U23t7v0ucqDWOcCDTc4urN1/DREmPGv4i/HlcAjuxX8/IE7LjDZ
	HqS8gaR3T9zoQIveYvdn8qSW9RJunsm+Y+9iCNTHXHpfCVvDY6FrANiPTcA85dxhCxNbDT8RC91
	K5vhVF73dlexy/tVAD4xi+0CZ2sHy7OUlzt6rH/+360l2g5QKTNnqj6QWQw86IQmo/UJbBnZ7lr
	jgzRY00EWgJeL7riUJ4OH5UGuXEXdRqwpQO2N2oUKkIAddSSippOpucYOJMGf4rMlkmUzxjLexS
	MW0HRcslD48C7s71kt+c7PvS4nssqAzCNUPjvQiiRgYJvgjbDKp/FAMsOQv9eGAcYpPo/NFG4ZV
	7+TLaPbZMRjAapdKD83WRErJwYwm6TSnqKS0TgnN1ipJ/dfHHIII32LRyUPq850XUdBytFlRwkA
	Iq2H7ucbgzbPWd7e7vU5mOIvgCJ8VvjAFEq+9NTFCL7KGdXwjjQ+PX/hUU8GYYXPJODxW10EtQW
	W+pY0Kijur0FsNn5YIVMUiXw2aTjsjs621Z
X-Received: by 2002:a17:903:3c2b:b0:2b4:689a:e411 with SMTP id d9443c01a7336-2ba794b80ddmr124847195ad.22.1778230782711;
        Fri, 08 May 2026 01:59:42 -0700 (PDT)
Received: from localhost.localdomain ([111.202.175.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm15526795ad.5.2026.05.08.01.59.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 08 May 2026 01:59:42 -0700 (PDT)
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
Subject: [PATCH 1/5] ocfs2: validate inline xattr header before ibody lookups
Date: Fri,  8 May 2026 16:59:10 +0800
Message-ID: <20260508085914.61647-2-gality369@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260508085914.61647-1-gality369@gmail.com>
References: <20260508085914.61647-1-gality369@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
mknodat() can read past the end of a dinode block when ACL inheritance
walks a corrupted inode-body xattr header. Another report shows the same
unchecked lookup later faulting in the VFS open path after create
returns a garbage status.

KASAN: use-after-free in
ocfs2_xattr_find_entry+0x37b/0x3a0 fs/ocfs2/xattr.c:1078
Read of size 2 at addr ffff88801c520300 by task syz.0.10/360

Trace:
 ...
 ocfs2_xattr_find_entry+0x37b/0x3a0 fs/ocfs2/xattr.c:1078
 ocfs2_xattr_ibody_get fs/ocfs2/xattr.c:1178 [inline]
 ocfs2_xattr_get_nolock+0x2ee/0x1110 fs/ocfs2/xattr.c:1309
 ocfs2_calc_xattr_init+0x716/0xac0 fs/ocfs2/xattr.c:628
 ocfs2_mknod+0x935/0x2400 fs/ocfs2/namei.c:333
 ocfs2_create+0x158/0x390 fs/ocfs2/namei.c:676
 vfs_create fs/namei.c:3493 [inline]
 vfs_create+0x445/0x6f0 fs/namei.c:3477
 do_mknodat+0x2d8/0x5e0 fs/namei.c:4372
 __do_sys_mknodat fs/namei.c:4400 [inline]
 __se_sys_mknodat fs/namei.c:4397 [inline]
 __x64_sys_mknodat+0xb6/0xf0 fs/namei.c:4397
 ...

Another report:
 BUG: unable to handle page fault for address: fffffbfff3e40ec0
 RIP: 0010:__d_entry_type include/linux/dcache.h:414 [inline]
 RIP: 0010:d_can_lookup include/linux/dcache.h:429 [inline]
 RIP: 0010:d_is_dir include/linux/dcache.h:439 [inline]
 RIP: 0010:path_openat+0xe2f/0x2ce0 fs/namei.c:4134

Trace:
 ...
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 __x64_sys_openat+0x15b/0x220 fs/open.c:1463
 ...

[CAUSE]
ocfs2_xattr_ibody_list() already validates the inline xattr size and
entry count, but ocfs2_xattr_ibody_get() and ocfs2_xattr_ibody_find()
still derive the inline header directly from di->i_xattr_inline_size and
then trust xh_count. A corrupted inline size or entry count can therefore
move the computed header outside the dinode block before get/find start
walking it. That can either make ocfs2_xattr_find_entry() dereference
xs->header->xh_count outside the block or make ocfs2_xattr_get_nolock()
bubble a garbage status back through ocfs2_calc_xattr_init() into the
create/open path.

[FIX]
Factor the existing ibody header geometry checks into a shared helper.
Use it in ocfs2_xattr_ibody_get() and ocfs2_xattr_ibody_find(), and have
ocfs2_xattr_ibody_list() reuse the same helper instead of open-coding
the validation. Reject corrupt ibody metadata with -EFSCORRUPTED before
the lookup path can walk bogus xattr geometry or return a garbage status.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
 fs/ocfs2/xattr.c | 82 +++++++++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 35 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 86cfd4c2adf9..3a5a17cdcf7e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -950,6 +950,41 @@ static int ocfs2_xattr_list_entries(struct inode *inode,
 	return result;
 }
 
+static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
+					   struct ocfs2_dinode *di,
+					   struct ocfs2_xattr_header **header)
+{
+	u16 xattr_count;
+	size_t max_entries;
+	u16 inline_size = le16_to_cpu(di->i_xattr_inline_size);
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
+	*header = (struct ocfs2_xattr_header *)
+		((void *)di + inode->i_sb->s_blocksize - inline_size);
+
+	xattr_count = le16_to_cpu((*header)->xh_count);
+	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
+		      sizeof(struct ocfs2_xattr_entry);
+
+	if (xattr_count > max_entries) {
+		ocfs2_error(inode->i_sb,
+			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
+			    xattr_count, max_entries,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 					 struct ocfs2_dinode *di)
 {
@@ -975,39 +1010,13 @@ static int ocfs2_xattr_ibody_list(struct inode *inode,
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
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &header);
+	if (ret)
+		return ret;
 
 	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
 
@@ -1200,8 +1209,9 @@ static int ocfs2_xattr_ibody_get(struct inode *inode,
 		return -ENODATA;
 
 	xs->end = (void *)di + inode->i_sb->s_blocksize;
-	xs->header = (struct ocfs2_xattr_header *)
-			(xs->end - le16_to_cpu(di->i_xattr_inline_size));
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &xs->header);
+	if (ret)
+		return ret;
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
@@ -2726,12 +2736,14 @@ static int ocfs2_xattr_ibody_find(struct inode *inode,
 
 	xs->xattr_bh = xs->inode_bh;
 	xs->end = (void *)di + inode->i_sb->s_blocksize;
-	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)
-		xs->header = (struct ocfs2_xattr_header *)
-			(xs->end - le16_to_cpu(di->i_xattr_inline_size));
-	else
+	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
+		ret = ocfs2_xattr_ibody_lookup_header(inode, di, &xs->header);
+		if (ret)
+			return ret;
+	} else {
 		xs->header = (struct ocfs2_xattr_header *)
 			(xs->end - OCFS2_SB(inode->i_sb)->s_xattr_inline_size);
+	}
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
-- 
2.43.0

