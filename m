Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1AF2561AB
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 02:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764642522; cv=none; b=n6FArAF1sovXArbIeE94Yfoa15phZVsONm10GdGeN9fdDJ2jjOu+oTyH7ra6KthXwm0PG4zgBCU9AoNYuQt+bjU8xXJ05+VzBC8xTcZxANqpkVF47ra8yeVQ9uSAAHmZ0bO7dVgr/zR5WXf73tSjsuOMmQhWtbXAqHtV9gzLRdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764642522; c=relaxed/simple;
	bh=MgHgOdT9qZmrqWaDJ6vI39jIfFk1PvNuXBvkcV/T1ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrpjhaBwYhjr2pIOmR0Z+Unf36UQSssqP4lM76oArxJzyomm5CPeL6JLShzqvhZZi8l4uSd4AySj1c3NrDLG6xW3HsbiJFGoB+/oU8tknzNMphIQ8iIKiPppQ3OkLTExM+em/OdOKKyYviCbwOF9ACAYpsq2vY3Oy4Vz8hFgfIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eipWmJvt; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eipWmJvt"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b737cd03d46so705583366b.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 18:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764642518; x=1765247318; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQ2oDLV4cZpatNcEIjIPlc1Sc1Sar/nw85oPIc+1RyE=;
        b=eipWmJvtI4mvL3bdF8xjHZNLNnK+RVA//cJEOsuPnb8qysMMfnMGZ+1hAvHIL3Z55G
         kUspP9FaqfxwFIMuMJLgQWj+BAQI4xCSRwfqjWxmtEY3H8H9BmeIjkBnQgJsEwTX7HMU
         qrXxniIU8ffeolOMiTBR6Y7m1L8IgR3jx1u9H0/uXMpeX0C0iX3bBbBhBfMrz5uFWrnQ
         ExUDiGkGvSuDnlUMYT7p26uiqPNUPKFyusU0O/+SP3TydsU2m8Cch6//XHc7Gc9Z0jIw
         Sm70Cm1Jhi4XkwayhApXnxBqHNlM8W9Gbk/Spr8fSlfx6T7V1iMDSI3cDcMqJtuYSGxr
         I+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764642518; x=1765247318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wQ2oDLV4cZpatNcEIjIPlc1Sc1Sar/nw85oPIc+1RyE=;
        b=Rkex4Al5QbEDfNqVRFtDlV1m+tBMmU3wci77HgqJFntgTkj6mn4OE6XHZJrbabDOEx
         xTyNIRoFQG1zvaKGDsAwQCVgWDzSHqUwtWJqhjeyqoKhor+cYzCIWS8ozLSLB2YW1mu+
         AdykxgcqWvEUv6ZCtVaFXY2HjawrbnGjIQhaRd4xp2zHw2c8qbR7fwb43ExMlcBk/vtr
         6JvWR6pLQef7UKry1iaJUNxgcmg0Iasu4i0ulk1l7jEjd7GcAs/RBirncUEJ0UtYOEwU
         dl/2koRbvsuER8XkDOZiaHAGLSYTSpseEhdnscp9V0UXE5s7m4xYJYtMGGTJLP51MrjC
         pb7w==
X-Gm-Message-State: AOJu0YzhjpPVLTDloEKn1C9RDJd9gTpxlyFH6sokquN8GbzDr9byqzQG
	iYjUg6nMWzHnXhyA6LD/0vMVOhr+T3UKrsWfb3iWpGByyRYW1hmC7u9+
X-Gm-Gg: ASbGncvLlToXfBX/UknurAIRZSvqCKNrySqO9hNim5iFmpwCFjyqtPpImGSjEpPEVD+
	M7m9LUIiRIv31E7xjEfHXPz4kDQUif8sT2PPo6oGd+mUPBG/as4pi98aWYn/NucEtWXvPgmwsNi
	uPyB8dPQx/5sNNG9KGdQAcFJziuQv3R61jl5tJJZRJsVAPWpRBL6UMsT5fjL/tABFHY3J2mA5fQ
	T/DdNdzOaZ+oPQls31CFc6LgEkX2GsIFX87lc7aPpO4wDUAJ5bNhB4ZWh4JoGDkKsg39aas1/0z
	HV3Ah9lvaNCZW4P9aIYOeEMRordfySjTwcXSyN1g3Zlpbnr8YcOsRDTXHJ2jwGB3Wt1S1edsZIt
	2hqoBNOp6SfGU8+rv17AP2+GJNP40810V9FnXaOBn6OPwQquHAK5nyeU5fbNzlbPuI+cSzC/bUQ
	LxGW4WY9Y81sE=
X-Google-Smtp-Source: AGHT+IGCszRVDYleRJKvnFGQRv7EOfuVmCw2RZqVylbDtwuPBAdE8WuTaR1mAvdzSDA38oLndQrJBw==
X-Received: by 2002:a17:907:747:b0:b76:379c:c3f2 with SMTP id a640c23a62f3a-b7671514f90mr4315543366b.1.1764642518154;
        Mon, 01 Dec 2025 18:28:38 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:8eee:b306:2d20:a328])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f59a6a5csm1398317766b.41.2025.12.01.18.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:28:37 -0800 (PST)
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
Subject: [PATCH v2 2/2] ocfs2: Convert remaining read-only checks to ocfs2_emergency_state
Date: Tue,  2 Dec 2025 05:28:02 +0300
Message-ID: <9211d6b037bfdb882667c71df6607595afc00246.1764640432.git.eraykrdg1@gmail.com>
In-Reply-To: <cover.1764640432.git.eraykrdg1@gmail.com>
References: <cover.1764640432.git.eraykrdg1@gmail.com>
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
 - Using `unlikely()` for status check
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

