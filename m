Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5F42727EE
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Nov 2025 00:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763425675; cv=none; b=XWmLMAYiEmIOny0s/iGyy4xdkwEK6e9+i6S7ecG7Ua3zBhNx8HAXYgOnFkNeDA0E0DkuWu7RP4BSlsMwKMFG5nMkSDJpkLSahpHZSmAcZFZ6p/jaGe/hZ+/W9VKPcQXY2DDaP9z9gVqnfBhsfjxZajkCV2wnEUcB1S8GwDDcNIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763425675; c=relaxed/simple;
	bh=XwQdHva/FhCqWzVeN2j1jp/bViRFcs+OvOOWLOMc7II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ/9CTFb1H5in8Ftc2U2ps0po/Q14NHahy8V7IHOlhfoGZLWT2WBKlNdG1mSpmWWFKBCxYtKd1zM7Ugd+JS106BVtCwDJx8BAkBQ/ovz5ovO+MjyhPVJ2skH/rP4OAibz405AGaBheBRKhwwaUVGIUUn+vppSbkYkqgD5tdZWoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CKVkmnZQ; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CKVkmnZQ"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b728a43e410so797212966b.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 16:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763425672; x=1764030472; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rt4dq7ItByAk2pC7B8R1HF5wkZzUmgIJnRllhICTu3g=;
        b=CKVkmnZQYGB1bVrmwSJKHuaIqaikTlnNyL7eikyX9sAcOZEcq23D+IYcswIKxy9aQZ
         TLtZawjw4yvnxRp1K0KWs5pW4gDtyZow/hT2nD7L6rx3JU3R8lFdaqb5yf8Z1wUqr9bj
         9MA3sPFiR7P7gSvp1NLS+6hM4Y2StL+QTaKbn1NcPiZUKka4FcD6HuEoJZ5IXQTevLUZ
         bXwgc1ZDTpesVL4K7/fSrT0NHQswPoONI+XFSeskTHfL74YVXperBCRROqH04ncT/+MT
         vfqLQVfIk79VxY/EQTdo5DdL6rmnstvWJtpos7sZeqJZoUfsT/pDUFNoJMzCD7yT8b6p
         decw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763425672; x=1764030472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rt4dq7ItByAk2pC7B8R1HF5wkZzUmgIJnRllhICTu3g=;
        b=KtBAOj2gNUt+h8BRMotzXou7+Okgsum5MLgbagz5ePJZ359a/pimbWqZXmSnSesiL5
         xS4DV0RCfqjkazqcY3OAXBFqpwTfzs/K0Psd9GE0me+5w6qcVtMkJTWILDtLSOBgRp5d
         31idCUjlyVPr8JA62K7WDVt3Z6fpH5tFY7tSDqiRhjYdfuy+Ijs2+RziukfvwlmKxa0C
         QWPWlnQZB7zHHulxJpYb6P8NXGgmJSd6HhK0vWeFHJrwUprB+7PmsRj9g5O7uuMie8ne
         sGGe/O3aMPGrDj1EbWXtJK4yZ0OKpx/ihjIcNCmFyc0xQkxUUKYyAqpJyC4qbftmeHim
         hcCQ==
X-Gm-Message-State: AOJu0Yy4DqP3YyG1XZQV9SdDHCvZ00pwBnSV9U8NWcJPemOVkCjw+ga3
	8h9po1zlq61hQVu9IlMYiQ4uaVYrbPDvQ52JMJwMpI+SPCArxtF4CRRi
X-Gm-Gg: ASbGnctEwW1hEEBWmZab4O9AsbZRQHzsDR3t+o1wt9b2Wae87IMvnlZDHdar4NHMEVY
	qux99aTVXqWk+mRau1b6iv3KXoMF3XyK9H/c6kLj3RSUDlap69SVWol7UyzkF+QzQPCRmKRX2/o
	grGWtGZSJVeBUNgl1X0LG3iKlz2Qi2T8cIENdk8sdcL0eNgzyVNyn8e3p5G8n7V/KBkPEaH+TQT
	C/cKCshp4UrOrKhpNpK2IF/mo6v1lG6bN/P0rGpQaIBBXRpnp0ryGvHy1qTgD3Rz8VtOyxRmkv8
	sPsTZJtTPdz5+CcFGS436C6ZS7aNyOhbKbHYjiSsWZBwiu3ZxI3IKi2EtKNtOhHvgyJWZEzTdHt
	R3CprC/YG3fajgszS3gAmj/TxsjptlsZn5HwbH3sx17TyCFGLZmRQwtxfH7YuYDb/7cErMm8+rP
	A/
X-Google-Smtp-Source: AGHT+IEexWh7CvuUtSk5yy3gOVy9n+9enrYCMgGW/NXI6iyxOLm5VeyJR2i1KkhzS5vQaeod62ruJg==
X-Received: by 2002:a17:906:3416:b0:b73:9e51:7f with SMTP id a640c23a62f3a-b739e5101c8mr470418866b.22.1763425671992;
        Mon, 17 Nov 2025 16:27:51 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d08:f72:eb64:1d0d:5855:afe7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fda8a86sm1172606466b.52.2025.11.17.16.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 16:27:51 -0800 (PST)
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
Subject: [PATCH 2/2] ocfs2: Convert remaining read-only checks to ocfs2_emergency_state
Date: Tue, 18 Nov 2025 03:26:46 +0300
Message-ID: <025589c07fd51a0693fffe8337184e14ec6d92bc.1763337347.git.eraykrdg1@gmail.com>
In-Reply-To: <cover.1763337347.git.eraykrdg1@gmail.com>
References: <cover.1763337347.git.eraykrdg1@gmail.com>
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
 fs/ocfs2/buffer_head_io.c |  4 ++--
 fs/ocfs2/file.c           | 17 ++++++++++-------
 fs/ocfs2/inode.c          |  3 +--
 fs/ocfs2/move_extents.c   |  5 +++--
 fs/ocfs2/resize.c         |  8 +++++---
 fs/ocfs2/super.c          |  2 +-
 6 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 8f714406528d..c43d4a58aa9a 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -434,8 +434,8 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
 	BUG_ON(buffer_jbd(bh));
 	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
-		ret = -EROFS;
+	ret = ocfs2_emergency_state(osb);
+	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 03a98985ac92..c299b73cf4ec 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -179,8 +179,9 @@ static int ocfs2_sync_file(struct file *file, loff_t start, loff_t end,
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
+	ret = ocfs2_emergency_state(osb);
+	if (ret < 0)
+		return ret;
 
 	err = file_write_and_wait_range(file, start, end);
 	if (err)
@@ -209,7 +210,7 @@ int ocfs2_should_update_atime(struct inode *inode,
 	struct timespec64 now;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	if (ocfs2_emergency_state(osb))
 		return 0;
 
 	if ((inode->i_flags & S_NOATIME) ||
@@ -1949,8 +1950,9 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	handle_t *handle;
 	unsigned long long max_off = inode->i_sb->s_maxbytes;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
+	ret = ocfs2_emergency_state(osb);
+	if (ret < 0)
+		return ret;
 
 	inode_lock(inode);
 
@@ -2713,8 +2715,9 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
 		return -EINVAL;
 	if (!ocfs2_refcount_tree(osb))
 		return -EOPNOTSUPP;
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
+	ret = ocfs2_emergency_state(osb);
+	if (ret < 0)
+		return ret;
 
 	/* Lock both files against IO */
 	ret = ocfs2_reflink_inodes_lock(inode_in, &in_bh, inode_out, &out_bh);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 415ad29ec758..dca8db61bc0f 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1586,8 +1586,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 	trace_ocfs2_filecheck_repair_inode_block(
 		(unsigned long long)bh->b_blocknr);
 
-	if (ocfs2_is_hard_readonly(OCFS2_SB(sb)) ||
-	    ocfs2_is_soft_readonly(OCFS2_SB(sb))) {
+	if (ocfs2_emergency_state(OCFS2_SB(sb))) {
 		mlog(ML_ERROR,
 		     "Filecheck: cannot repair dinode #%llu "
 		     "on readonly filesystem\n",
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 86f2631e6360..f586593b3a63 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -898,8 +898,9 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
+	status = ocfs2_emergency_state(osb);
+	if (status < 0)
+		return status;
 
 	inode_lock(inode);
 
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index b0733c08ed13..d9f5e1d065b4 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -276,8 +276,9 @@ int ocfs2_group_extend(struct inode * inode, int new_clusters)
 	u32 first_new_cluster;
 	u64 lgd_blkno;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
-		return -EROFS;
+	ret = ocfs2_emergency_state(osb);
+	if (ret < 0)
+		return ret;
 
 	if (new_clusters < 0)
 		return -EINVAL;
@@ -466,7 +467,8 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	u16 cl_bpc;
 	u64 bg_ptr;
 
-	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+	ret = ocfs2_emergency_state(osb);
+	if (ret < 0)
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

