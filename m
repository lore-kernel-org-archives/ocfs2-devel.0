Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C79B25EF87
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Dec 2025 03:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764732907; cv=none; b=iYfrPDYht0vHmfOG+GJOTtF/FkGk4Md3ekEv/s4bE/LSfzuuq0aVdLMrtDsGd1njibO/8NHiOwqmSpon2XiIVm8bmaX6VUdMbqwMZFMsV2jDMCI4Oz0ds/arSsfaHBzQQhpW9oRJ2Qmyt+bV6DuzlNDcg2zSkNmytREpTXtNEk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764732907; c=relaxed/simple;
	bh=fdMndDgTF+A9n+UBpNoipNqBq8uuKKrAV7NtFlIWdaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMTR3JKFWa8ksnfGs+E9MtGSlfv8oOeLo4uFwh9qeoS6QPe2XG4civv0kYzJVbvDUDyPdRNYhofBP65oso1CbNEw+xnvugKte4s4XrFFkMuWb1X6V1fGlhE14NIovahB93KpMl22K8wec7cQYT4xBJ2p5ZOELpMdnxU+c6mp4D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q6aXOmGN; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q6aXOmGN"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7291af7190so963365466b.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 02 Dec 2025 19:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764732904; x=1765337704; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iwyhtRTBkaUWy6Yg2USZjLwPMatXi771DBXNb73X/Kw=;
        b=Q6aXOmGNyMqJUdfjZIfwHUeRq5ERMXVsDrmVE5TMI3kasLwy1ZhqVxliJoo9neDG4L
         tJn3kppG+f3M6Da6CiXRM8nT7c9SiAzEVvOS+T5mKBZDnexD+7l1TwaXVTpPPs2SYaQL
         kHw3uOq10B6cWf80ts0XvhxnYdeV7EvvIWUDrT8ObHZW8PXQWXVZxN2Wo4z3ibvbCBDH
         dA3o+on3TnaO4jH8LUnMhJi3sHSZx+VE0VfHTKUJDI9faiv8iyGiOr1bzM1T0j1KhPY+
         lcqMBy98EekZQEikM3hS8GoCHTrXwwjwmI4YvL7/m/ZiIoMHSXmBQoAsIuIUd6LEDer4
         Xzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764732904; x=1765337704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iwyhtRTBkaUWy6Yg2USZjLwPMatXi771DBXNb73X/Kw=;
        b=Ts9c9gEGG6Ip7uCWqfLBBl46auV832dcOMcSLg4AkZBQSoJp06SXFx1i3Bv4s/2gWs
         wqy+wzJtYkd+XQ8SoTKiCo45fTgQ8wsJXLnh5pf1a3LSvHpuFhmRXu5cohYdUmlFDwGC
         9y/PDJNuv01OKBqRl/2YAwszs64Fof1R9IYULVZ0RCUZ6goS9fGI7mBgLle5oenX4f+R
         E4xp5eXYVNNKshbYt5opzHJPVslCVckuqqJEFrN9A9VJOH1RTqPMgeJvxS3thJO4p13E
         QoAjN5gwfM3SMlPY4WoynLexPq985ZcsJ41rT/mZuy1Y/nX3LwoEZibX7VhUEjY97+f+
         ixWg==
X-Gm-Message-State: AOJu0Yz8Q1isoq4aNvoVt2mBILu+YZcU0EK9N4hB1c4sXpSWqdmwUJJJ
	C2BSMFlzmCIYyzMOadvrLlVuqTVpWNomC1XhrAtOxYs9aLOppdqt3lsU
X-Gm-Gg: ASbGncszf6QN151/TNTGLwOl5x+QCEQodG9BAJYp1yJt9y9gh7R8zvKX4QT+JOFcMC3
	jNRG7OgOaBXDT8WuXHEBq6vKs5TWNS+38APO49OXyucQN1SoAiK7pJYum+eRlWP5vcEkzR1LexG
	3TqtVym8SEPk1HFR4sTCbr0ilmNLr7EED6vJL6V/Io3V+/+/a6DjPylNOwdJk4xWtIivquPhYZs
	EgfM1q6YPHzDCzg4vBYglVNzl+S0GyP+yg32rbf14fFtHvqqtH6yLorC+JAiZV/Vc5SI6MKQXM6
	GiSYJAPzUxX0C2iShR/QZA6EHSVl134VP7Yg7voXr3ep+PyumSsVkgLpcipIpCYVa3ZOmela73o
	b5H5n9iLZXF29jgMpmoMiTlaykNVIr1jK6+5kFlhf0BJGpO1pDtOMnhcRUzk7eHwUygeAdgF9Dk
	t0Q6QAdQ/UDpw=
X-Google-Smtp-Source: AGHT+IEfJ1b9D6DSDnVQN4BFiMAucDtE2252iyZZAxAfXSx1NUkd85Q56BXhPikb1L0Q4G8DpWp5Rw==
X-Received: by 2002:a17:906:c141:b0:b76:60ad:77f8 with SMTP id a640c23a62f3a-b79dc7344ffmr54434166b.48.1764732904302;
        Tue, 02 Dec 2025 19:35:04 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:acf7:8de5:59bc:44c3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5a4b757sm1658570066b.66.2025.12.02.19.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 19:35:04 -0800 (PST)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>,
	Albin Babu Varghese <albinbabuvarghese20@gmail.com>,
	Heming Zhao <heming.zhao@suse.com>
Subject: [PATCH v4 2/2] ocfs2: Convert remaining read-only checks to ocfs2_emergency_state
Date: Wed,  3 Dec 2025 06:34:26 +0300
Message-ID: <3421641b54ad6b6e4ffca052351b518eacc1bd08.1764728893.git.eraykrdg1@gmail.com>
In-Reply-To: <cover.1764728893.git.eraykrdg1@gmail.com>
References: <cover.1764728893.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the centralized `ocfs2_emergency_state()` helper is available,
refactor remaining filesystem-wide checks for `ocfs2_is_soft_readonly`
and `ocfs2_is_hard_readonly` to use this new function.

To ensure strict consistency with the previous behavior and guarantee
no functional changes, the call sites continue to explicitly return
-EROFS when the emergency state is detected. This standardizes the
check logic while preserving the existing error handling flow.

Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
---
v2:
 - Use `unlikely()` for status check
---
v4:
 - Ensure consistency with the previous behavior as requested
---
 fs/ocfs2/buffer_head_io.c | 2 +-
 fs/ocfs2/file.c           | 8 ++++----
 fs/ocfs2/inode.c          | 3 +--
 fs/ocfs2/move_extents.c   | 2 +-
 fs/ocfs2/resize.c         | 4 ++--
 fs/ocfs2/super.c          | 2 +-
 6 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 8f714406528d..701d27d908d4 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -434,7 +434,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 	BUG_ON(buffer_jbd(bh));
 	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
+	if (unlikely(ocfs2_emergency_state(osb))) {
 		ret = -EROFS;
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index ddca292944d7..732c61599159 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -179,7 +179,7 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	err = file_write_and_wait_range(file, start, end);
@@ -209,7 +209,7 @@ int ocfs2_should_update_atime(struct inode *inode,
 	struct timespec64 now;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return 0;
 
 	if ((inode->i_flags & S_NOATIME) ||
@@ -1949,7 +1949,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	handle_t *handle;
 	unsigned long long max_off = inode->i_sb->s_maxbytes;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	inode_lock(inode);
@@ -2713,7 +2713,7 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
 		return -EINVAL;
 	if (!ocfs2_refcount_tree(osb))
 		return -EOPNOTSUPP;
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	/* Lock both files against IO */
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
index 86f2631e6360..71025d7b2d4b 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -898,7 +898,7 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	inode_lock(inode);
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index b0733c08ed13..ac3ec2c21119 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -276,7 +276,7 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	u32 first_new_cluster;
 	u64 lgd_blkno;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
 		return -EROFS;
 
 	if (new_clusters < 0)
@@ -466,7 +466,7 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	u16 cl_bpc;
 	u64 bg_ptr;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (unlikely(ocfs2_emergency_state(osb)))
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

