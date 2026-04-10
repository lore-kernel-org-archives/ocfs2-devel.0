Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245C728F935
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 11:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775820767; cv=none; b=sEQU9CPr5gLHlR2SLaF3drB6bj+7QcSj94VVGe9nx7tSIHU2pF9koCZ7IyveNkcEgJE/IuaEak43d4VeDImxOn2SsQgpRJ8xzJhas3VZcNl4zpNF3wC/UI5WxV+EaVNEpxvQWxdAT13B20bE0XzIa40cgR8cOFSaerUM2pEOqr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775820767; c=relaxed/simple;
	bh=gEMS2xJaq0V9sKvSwwHi1qTBNP3yVwG104j5DDh1vEo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WS08lGH/RUdjHfWQtk9mUXfIa0PyISK9MaOeAkPg3/JxQpsal9OYv02PSfGtT2NMGw+/3yi/EqVjiv+xhLri94QuwWusZ6axs6EpUR16+W+jTOILywNPe+5rIOoFgmNDyWM7PUR02Jq3UQpY8tD+0/uZRZPFpsCHyqYBdRmumyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aaLQy7ns; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aaLQy7ns"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c76b6abdb73so1400497a12.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 10 Apr 2026 04:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775820765; x=1776425565; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6IT1BRZSlVlVJq8P6hsnpqwDmmBbMY+acQe50ucgs78=;
        b=aaLQy7nsD12HsYpoRfjv1SttSJz5VuwTRVrzvJaiWUg3reQRe1yTettEp/NURQItgM
         ckjsCXwZIqL1EO3G1e4jtUd9VAPzRHgEl/Ll2akxQmrLX30ROEHJLIEsNYzyPyhLo9kQ
         baZSjDW4UtdGZN3uf1v100AFLpahS2WxV5NHnDk9envXSzdZ5FQWBTbJqn76GCbdbrL+
         mZk3koHeiVTz3+Kv9Zr/tDynC2Fbe3SEBp6FdyJLdm6xWTDw5YBASzkSLXxx2l8uUEtD
         o2GAaaHsZjCcB7gl5XUlVbQqZGWZM7YkCAm1dzUik3Yq3DkbTRqqZkyQWgT+RiXfz49L
         y8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775820765; x=1776425565;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IT1BRZSlVlVJq8P6hsnpqwDmmBbMY+acQe50ucgs78=;
        b=Tj6mcRy0z6qqGZh7WIZVcfHemx0FM6IE/X9WTwKYnWxsmxwLOR0eRz4AstDqH5fdHQ
         BXXdSXybgh7BJGuDvKZMY8yaAoRuFn3Cko/PK7O4RhbPHAMJAztxB7k+Wc+e6lqo9dRs
         pJbjaZjcEOoZ6QDN1n6YmSgu8zIkiH5xEGE/MRHNvO8/eFM44XpwXTYwXtd7pI1nmm0Z
         qu3/cZ9FhZ5cUUAFDRBx3rwO8jfUsSUDb9cdUd49d7/WNYU/W85U2xdgUAADluNZalmr
         DPauPX8k4kR16RFz1jLGjdgKzPtKQOByLMiVxajuADoyriwwPdZck6+wyEjmgKErf//0
         7V1A==
X-Gm-Message-State: AOJu0YyMmrFrMUxeWyVJtIHdimaOY4a5Zs//+M46GH28AttpshwGLWjl
	9PNsaralDYgCoUxSuUaulHGMmgsvNyqaY1WaEJJDk07vMLvhYSQ84iwc
X-Gm-Gg: AeBDietA9PcfvYrvy9sa5psmfLfwXW11soKAI7YBUr0PPSYO153yULA5STL3CJBxr9o
	imlYSC9WJ/SOaga5KlLVGbhXzQz8IUwrV5lkWPDWjog0mFDJW5L9xnlFQmXc0Y61Rv6ACdlf1fa
	a4ee8s7c7E3L2xWlqZpWS4n7driSujQyH+ihTFRwOkLtuQms+n2a7GHOS4YJwljelq9BewS9KbU
	BZNyEZ+q5ZYsGHqofgIgHl4vc1smzWU4IWh3R2qsv/7vMnUvEkJvwQShTHix+CbxVyNf3UkcdeL
	V4Ypu/xduYYi375eKAPDEoqNtre5/mljROyIxU2Hi1O2b3bRBVL/kKH2NkBhQIgquc5JvrpgsqB
	pqQDQKqcLWavsgeQpVnH02KEd+gmJJuDfCWgri409DXJw6kP0T4ncGcqC6NJehakAdFHUc+PhfB
	mA/nQEauzAvmIT0QwiuK+kClJOL8Xcl9RE2+sJP61KSqsUbaVX+efXiTOhRum3DIFIUTJiZQ==
X-Received: by 2002:a05:6a20:7494:b0:39b:9644:6e93 with SMTP id adf61e73a8af0-39fe3c748demr3594487637.6.1775820765183;
        Fri, 10 Apr 2026 04:32:45 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7921a3e6d2sm2109875a12.32.2026.04.10.04.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 04:32:44 -0700 (PDT)
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
Subject: [PATCH v2] ocfs2: validate inline dir size during inode reads
Date: Fri, 10 Apr 2026 19:32:29 +0800
Message-ID: <20260410113229.4092277-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A crafted inline-data directory can store i_size larger than id_count.
Once such a dinode is instantiated, readdir walks past data->id_data
and KASAN reports:

BUG: KASAN: use-after-free in ocfs2_check_dir_entry.isra.0+0x31f/0x370 fs/ocfs2/dir.c:305
Read of size 2 at addr ffff8880088f0008 by task syz.0.1936/4656
Call Trace:
 ...
 ocfs2_check_dir_entry.isra.0+0x31f/0x370 fs/ocfs2/dir.c:305
 ocfs2_dir_foreach_blk_id+0x203/0xa70 fs/ocfs2/dir.c:1805
 ocfs2_dir_foreach_blk fs/ocfs2/dir.c:1933 [inline]
 ocfs2_readdir+0x4ba/0x520 fs/ocfs2/dir.c:1977
 wrap_directory_iterator+0x9c/0xe0 fs/readdir.c:65
 shared_ocfs2_readdir+0x29/0x40 fs/ocfs2/file.c:2822
 iterate_dir+0x276/0x9e0 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:410 [inline]
 __se_sys_getdents64 fs/readdir.c:396 [inline]
 __x64_sys_getdents64+0x143/0x2a0 fs/readdir.c:396
 ...

[CAUSE]
The inline-dir invariant i_size <= id_count is never validated when a
dinode is read. ocfs2_validate_inode_block() accepts the corrupted
metadata, then ocfs2_populate_inode() or ocfs2_refresh_inode() copies
that unchecked on-disk i_size into inode->i_size.

JBD2-managed buffers can also bypass ocfs2_validate_inode_block(), so
the same unchecked size can still reach ocfs2_populate_inode() and
ocfs2_refresh_inode() through those read paths.

[FIX]
Introduce a shared helper that validates inline directory i_size
against id_count. Call it from ocfs2_validate_inode_block() so corrupt
inline-dir dinodes are rejected in the cold metadata-read path, and add
matching guards in ocfs2_read_locked_inode() and ocfs2_inode_lock_update()
for the JBD2-managed buffer paths that skip the validator.

This blocks the corrupted metadata before it reaches VFS inode state
and keeps the hot readdir path unchanged.

Fixes: 23193e513d1c ("ocfs2: Read support for directories with inline data")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
v2:
- Move the validation from ocfs2_dir_foreach_blk_id() to inode read paths
- Add JBD2-managed buffer guards in ocfs2_read_locked_inode() and ocfs2_inode_lock_update()
- Reword the changelog to describe unchecked on-disk i_size rather than corrupted in-memory state
---
 fs/ocfs2/dlmglue.c |  5 +++++
 fs/ocfs2/inode.c   | 29 +++++++++++++++++++++++++++++
 fs/ocfs2/inode.h   |  2 ++
 3 files changed, 36 insertions(+)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 92a6149da9c1..69aaceeb76bc 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2363,6 +2363,11 @@ static int ocfs2_inode_lock_update(struct inode *inode,
 			goto bail_refresh;
 		}
 
+		/* JBD2-managed buffers can bypass ocfs2_validate_inode_block(). */
+		status = ocfs2_validate_inline_dir(inode->i_sb, oi->ip_blkno, fe);
+		if (status)
+			goto bail_refresh;
+
 		/* This is a good chance to make sure we're not
 		 * locking an invalid object.  ocfs2_read_inode_block()
 		 * already checked that the inode block is sane.
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..3c8a9b592d25 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -66,6 +66,26 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 					      struct buffer_head *bh);
 
+/* Inline directories must never advertise more data than id_count can hold. */
+int ocfs2_validate_inline_dir(struct super_block *sb, u64 blkno,
+			      struct ocfs2_dinode *di)
+{
+	struct ocfs2_inline_data *data = &di->id2.i_data;
+
+	if (!S_ISDIR(le16_to_cpu(di->i_mode)) ||
+	    !(le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL))
+		return 0;
+
+	if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count))
+		return ocfs2_error(sb,
+				   "Invalid dinode #%llu: inline dir i_size %llu exceeds id_count %u\n",
+				   (unsigned long long)blkno,
+				   (unsigned long long)le64_to_cpu(di->i_size),
+				   le16_to_cpu(data->id_count));
+
+	return 0;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -611,6 +631,11 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 			"Inode %llu: system file state is ambiguous\n",
 			(unsigned long long)args->fi_blkno);
 
+	/* JBD2-managed buffers can bypass ocfs2_validate_inode_block(). */
+	status = ocfs2_validate_inline_dir(inode->i_sb, args->fi_blkno, fe);
+	if (status)
+		goto bail;
+
 	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
 	    S_ISBLK(le16_to_cpu(fe->i_mode)))
 		inode->i_rdev = huge_decode_dev(le64_to_cpu(fe->id1.dev1.i_rdev));
@@ -1503,6 +1528,10 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	rc = ocfs2_validate_inline_dir(sb, bh->b_blocknr, di);
+	if (rc)
+		goto bail;
+
 	rc = 0;
 
 bail:
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index accf03d4765e..1d71648c1294 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -139,6 +139,8 @@ int ocfs2_mark_inode_dirty(handle_t *handle,
 
 void ocfs2_set_inode_flags(struct inode *inode);
 void ocfs2_get_inode_flags(struct ocfs2_inode_info *oi);
+int ocfs2_validate_inline_dir(struct super_block *sb, u64 blkno,
+			      struct ocfs2_dinode *di);
 
 static inline blkcnt_t ocfs2_inode_sector_count(struct inode *inode)
 {
-- 
2.49.0
