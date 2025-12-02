Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A684C268C42
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 02:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764644116; cv=none; b=ThaaTWSo22R/sH2m3kxz4Szz0+9IvgrKEWUhali5Tv6w8ZB3FMI7Dum0mox4E8Lb3wERKuiyhRXBaCbP8L4L0GUmFhhmqqdNAyX/2/dw4+z2RYaNTmpQknGC2kWl1QpyTdb/dKu7X0h93L+u3yI7LnqOFjYcjX4TpBAywYbpGAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764644116; c=relaxed/simple;
	bh=6TE2HUpeK9/p5Oe8sl55fy3ZoUpHm+tEKb2p1rwdkx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjhRXtVuuHUNpNjQnzRxfrHUtH8U5qdgAUYwQFIUcBl07tZdeKwYxSo8AxcYii/J2mE1oNpJ8ntcsx0DtUpJa+YVMyw/Nb+R2dhEpvtMM1jHbA7nQXIXiJXhdjt99srjx1wE9zxzHnwTBRlE3zvak9VJfs9i9dfzCajUlQDusrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jt6/Foh1; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jt6/Foh1"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b75c7cb722aso719343366b.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 18:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764644113; x=1765248913; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uC+t59n21CznoXcEjngOT4MWhyxt5TEuRrsntvhQ9qc=;
        b=jt6/Foh1+ZXn4unozNQ0syL6fYdU181LdHQQm+5teyJlsQM7f5ycrjHwXSOkTIpmjR
         51/sflnI1NqYIDqM6wnj02Vd86WM3fZ7XMXREuAq+GD5fFplakQq3aIW4pFTRzO/4wvW
         2TScU+13oZPRtbc1lAhjDVvuSMyCEkC2gEe7eF5pf8UjCwGhSxKyFaUQSnTdLX52WChu
         Rm2ilplwMYQCEHEbzRchnvWg7Tf7voUdS6zsL+x4+bRXZyRkbo95W245dnzt5gDOFqfV
         dVcSAqlIHUuY93J0dIMi6znj4f6LRlGfA6D2d0bUYQotazt7ipwvCTruzTyE++Sc8Lpy
         uRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764644113; x=1765248913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uC+t59n21CznoXcEjngOT4MWhyxt5TEuRrsntvhQ9qc=;
        b=PKerR54Kgq8nEZS70ny8G9hG9f9SLTQVcmPSjUpHV9Ixsrrf6DpvHpxUE6oRc+eanh
         stK3nFXNpHov2mj/bhIjHPOE/f53i/1CndiwwPQfcZs5vA5rP6qhpEU/0Q2g66TZpi0e
         bpWKV85DhoFgjbJTZFiYdccTAkIM6L05g8cNmCWVyjGPxeQz3PDcWvnS9eAeotOcmffi
         4K6enhACWwB10UpxssiBXPxfaIG4wQ2X+MLUN773Clv35fgFktJX6vaT0WLsuSypiU4E
         mGqwOrRV5kb6bHwW3+L/PLgheJ38f7IZAR9Z2bbKHacmSx56GFmpgTvbkV0jBFpxzoHr
         f9lg==
X-Gm-Message-State: AOJu0YwLCoGOpHMJPXdFp7uR9yabRJApf4fgTdHHT4qtLviQ76Eh9Cy5
	PTy+yPdiP91RhSpRcjYh2dyngA5m5PhuQCHIYIUqdugy7M/DxjNPZzL2
X-Gm-Gg: ASbGnctzrHDjrXF3a5bIcNqy9sANpR1jRIRXyVzoilMl4ooO8dXWPQEykR8IkDetikz
	XEH4eicI60GZtO6LxMu0WWWLpedwNXBuieoUt6i9qbO/ZET+eYLkKs5sh76LtGDnhfMYTwnDleH
	RI7Xt/wiq/X6wahEaSkWg9Jun420/ZK8ln8Ifh7IFJlRzSJvyHQCZFIewGtBfN52EyKKqB30d4K
	LayunpUbfaNiWSBewJrcxhYycJxhGGJyQd+slZeTkZ6OKIcULjnm11mdpruWF6dYSukJ2durZV8
	rJhsK9ou5DGorQvbm43iNhAuXZMxQt4iqAQhalkfn21UdoLGzxq4siE3p/wJnEWeNMfaz5zpk9t
	0b3zFuQr/xg1Y7hZPP7eBXcXC5hA7j1CHfUv72xwGQTnPF7RzEfTtf3A0zN1wN3YwQxFR6bvgf3
	1BJkkmsHuRQQM=
X-Google-Smtp-Source: AGHT+IEFOdz8BzOj8tNRbqye1kGjf4IsI+adnN5hUAskVI/2vC2mt3SuGrxPP9gpI9yCDY2nB6uE2Q==
X-Received: by 2002:a17:907:3f14:b0:b71:5079:9702 with SMTP id a640c23a62f3a-b76715ab943mr4128691266b.21.1764644112869;
        Mon, 01 Dec 2025 18:55:12 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:8eee:b306:2d20:a328])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64751062261sm15753978a12.33.2025.12.01.18.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:55:11 -0800 (PST)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Subject: [PATCH v3 2/2] ocfs2: Convert remaining read-only checks to ocfs2_emergency_state
Date: Tue,  2 Dec 2025 05:54:58 +0300
Message-ID: <1f329fa8f8b0496ecb88c6c48174ca3d8e339f8d.1764643790.git.eraykrdg1@gmail.com>
In-Reply-To: <cover.1764643790.git.eraykrdg1@gmail.com>
References: <cover.1764643790.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To centralize error checking, follow the pattern of other filesystems
like ext4 (which uses `ext4_emergency_state()`), and prepare for
future enhancements, this patch introduces a new helper function:
`ocfs2_emergency_state()`.

The purpose of this helper is to provide a single, unified location
for checking all filesystem-level emergency conditions. In this
initial implementation, the function only checks for the existing
hard and soft read-only modes, returning -EROFS if either is set.

This provides a foundation where future checks (e.g., for fatal error
states returning -EIO, or shutdown states) can be easily added in
one place.

This patch also adds this new check to the beginning of
`ocfs2_setattr()`. This ensures that operations like `ftruncate`
(which triggered the original BUG) fail-fast with -EROFS when the
filesystem is already in a read-only state.

Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
---
v2:
 - Use `unlikely()` for status check
---
 fs/ocfs2/buffer_head_io.c |  4 ++--
 fs/ocfs2/file.c           | 17 ++++++++++-------
 fs/ocfs2/inode.c          |  3 +--
 fs/ocfs2/move_extents.c   |  5 +++--
 fs/ocfs2/resize.c         |  8 +++++---
 fs/ocfs2/super.c          |  2 +-
 6 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 8f714406528d..61a0f522c673 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -434,8 +434,8 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 	BUG_ON(buffer_jbd(bh));
 	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
-		ret = -EROFS;
+	ret = ocfs2_emergency_state(osb);
+	if (unlikely(ret)) {
 		mlog_errno(ret);
 		goto out;
 	}
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 253b4f300127..540b35ec02e2 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -179,8 +179,9 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
+	ret = ocfs2_emergency_state(osb);
+	if (unlikely(ret))
+		return ret;
 
 	err = file_write_and_wait_range(file, start, end);
 	if (err)
@@ -209,7 +210,7 @@ int ocfs2_should_update_atime(struct inode *inode,
 	struct timespec64 now;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return 0;
 
 	if ((inode->i_flags & S_NOATIME) ||
@@ -1949,8 +1950,9 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	handle_t *handle;
 	unsigned long long max_off = inode->i_sb->s_maxbytes;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
+	ret = ocfs2_emergency_state(osb);
+	if (unlikely(ret))
+		return ret;
 
 	inode_lock(inode);
 
@@ -2713,8 +2715,9 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
 		return -EINVAL;
 	if (!ocfs2_refcount_tree(osb))
 		return -EOPNOTSUPP;
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
+	ret = ocfs2_emergency_state(osb);
+	if (unlikely(ret))
+		return ret;
 
 	/* Lock both files against IO */
 	ret = ocfs2_reflink_inodes_lock(inode_in, &in_bh, inode_out, &out_bh);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..b7dad049cfa3 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1586,8 +1586,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 	trace_ocfs2_filecheck_repair_inode_block(
 		(unsigned long long)bh->b_blocknr);
 
-	if (ocfs2_is_hard_readonly(OCFS2_SB(sb)) ||
-	    ocfs2_is_soft_readonly(OCFS2_SB(sb))) {
+	if (unlikely(ocfs2_emergency_state(OCFS2_SB(sb)))) {
 		mlog(ML_ERROR,
 		     "Filecheck: cannot repair dinode #%llu "
 		     "on readonly filesystem\n",
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 86f2631e6360..9d2a2d054aa1 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -898,8 +898,9 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
+	status = ocfs2_emergency_state(osb);
+	if (unlikely(status))
+		return status;
 
 	inode_lock(inode);
 
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index b0733c08ed13..ae30ae67e220 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -276,8 +276,9 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	u32 first_new_cluster;
 	u64 lgd_blkno;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
+	ret = ocfs2_emergency_state(osb);
+	if (unlikely(ret))
+		return ret;
 
 	if (new_clusters < 0)
 		return -EINVAL;
@@ -466,7 +467,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	u16 cl_bpc;
 	u64 bg_ptr;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	ret = ocfs2_emergency_state(osb);
+	if (unlikely(ret))
 		return -EROFS;
 
 	main_bm_inode = ocfs2_get_system_file_inode(osb,
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 53daa4482406..c6019d260efc 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2487,7 +2487,7 @@ static int ocfs2_handle_error(struct super_block *sb)
 		rv = -EIO;
 	} else { /* default option */
 		rv = -EROFS;
-		if (sb_rdonly(sb) && (ocfs2_is_soft_readonly(osb) || ocfs2_is_hard_readonly(osb)))
+		if (sb_rdonly(sb) && ocfs2_emergency_state(osb))
 			return rv;
 
 		pr_crit("OCFS2: File system is now read-only.\n");
-- 
2.43.0

