Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAC116EB7B
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jun 2024 10:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719398700; cv=none; b=YPvGxj5SUzpGFXAen7XrFRJK1q6wbCQ+qCSzFbikCwQlDfWkb98df57fqAuevwEr6L963itHgvq5xvujIQcruq/mi/t26YuScca2hGwFrXz7rYyY3rNrxMjrTGt26p05TzpR6qcg8DiHuCwvIfg35dIREpxhPa4YiYDcu9Cub28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719398700; c=relaxed/simple;
	bh=j6vVOEK+WbSCcV1Jm6wI/JYpVsnXelrK7VuqgEoIYok=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qCQJISOdjnhd+4i8/gla0IKvr/O1yLJgVP5ubpUurrA72bHuLsrmjQ7wR3H327yRN5QUpfcs12jyDG5GjtstltSkCXmvfRBgP3DBPoK4LtQKNiGL3R3jzuxW/LPTueNrW7z8rNC9t3C4Zi9QwIcRkcWdeK0XXrdPN45x96ycBd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=erQgD+WP; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="erQgD+WP"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-70679845d69so2542402b3a.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jun 2024 03:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719398698; x=1720003498; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EPnfwEoEvdOF73aMkRu2ov0xRqxHds2zuOavYyGpzlo=;
        b=erQgD+WPp7vgOZxjxmxQI8nvMjmsao+DTcIVdKA774QcwYz3OSXiMyWCrY8BZMNzqr
         XM+lMYx5fgx4Vyml6mLO0SO6S0liu8wKMC7LVgCTTwNb05XY45mSr/r7gSfmSDkLnlIx
         1Pl0OodYdOeTjUKHO67gkC3NsconwuGm3sUCFFODe4RQmzX/sA4uHjae2oZosaFAdXaw
         IJ04kPAErGZhqropd+ryBttasZb54aqUK6mxsNvhstWRUCnHd0dy/4LJfxPdCQOi0hjt
         XdAGEJ2IJzjZX3wnP3EXTJZduXNAxBnc2bsx+n9Ei71O4DYSqJJtNow/xZB8OCqtDjMF
         4szA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719398698; x=1720003498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EPnfwEoEvdOF73aMkRu2ov0xRqxHds2zuOavYyGpzlo=;
        b=MMGNn8wMlKZGatdt6SFWJOIrcYWDOzwLErozjxWo1Y6RXDtRfFwOUIzyHtVaso/lm/
         kgAULFoyhYPkFHkMixH4r+UgREijy5e/kMVrNbnL/h9LvUH59O231nTPYfpQucMU5vtM
         0Dp8o0gy4m8y8L+O0S7c7FYAWU7aH97P4MLccXWVzTfv0AxelBbeV/X3OOdTErgOURy4
         RC0FyAYYMiBnVFc4aCW0QaZwHvWxIJQ+qCHe3frwoH4zL4D2KPANyoKVdX5FE29/Bxf1
         icCCj/sRPW3Q6chW0e2a7EGRnc8opUf/YE56ztI2nsPQWKuy6kgzP5fQqEitoNJWMXRd
         GDSA==
X-Gm-Message-State: AOJu0YwhSWFAwNAR/ETOTqZ21/KtSf2GdOPNGbCRX+EmaU5h6NVFWLlU
	NhA7KxLq8t8FxCWOB/ukawJiAdIpHNFed/ZWmAIgPfCYb/K1pvaNHsXvnlAHKnY=
X-Google-Smtp-Source: AGHT+IFLe7EXkuL+PpNGFikaxeyFUj8VwVmIU2bjmYtv3RCMjn8JqpUgz50Io2n0RewKQvEqqyORuA==
X-Received: by 2002:aa7:92c2:0:b0:705:c029:c9a7 with SMTP id d2e1a72fcca58-706745b6d61mr9185298b3a.15.1719398697570;
        Wed, 26 Jun 2024 03:44:57 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7069d65dfc7sm2625180b3a.133.2024.06.26.03.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:44:57 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Subject: [PATCH v6] ocfs2: add bounds checking to ocfs2_check_dir_entry()
Date: Wed, 26 Jun 2024 18:44:33 +0800
Message-Id: <20240626104433.163270-1-llfamsec@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds sanity checks for ocfs2_dir_entry to make sure all members of
ocfs2_dir_entry don't stray beyond valid memory region.

Signed-off-by: lei lu <llfamsec@gmail.com>
---
 fs/ocfs2/dir.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d620d4c53c6f..f0beb173dbba 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
  * bh passed here can be an inode block or a dir data block, depending
  * on the inode inline data flag.
  */
-static int ocfs2_check_dir_entry(struct inode * dir,
-				 struct ocfs2_dir_entry * de,
-				 struct buffer_head * bh,
+static int ocfs2_check_dir_entry(struct inode *dir,
+				 struct ocfs2_dir_entry *de,
+				 struct buffer_head *bh,
+				 char *buf,
+				 unsigned int size,
 				 unsigned long offset)
 {
 	const char *error_msg = NULL;
 	const int rlen = le16_to_cpu(de->rec_len);
+	const unsigned long next_offset = ((char *) de - buf) + rlen;
 
 	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
@@ -308,9 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
 		error_msg = "rec_len % 4 != 0";
 	else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
 		error_msg = "rec_len is too small for name_len";
-	else if (unlikely(
-		 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
-		error_msg = "directory entry across blocks";
+	else if (unlikely(next_offset > size))
+		error_msg = "directory entry overrun";
+	else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
+		 next_offset != size)
+		error_msg = "directory entry too close to end";
 
 	if (unlikely(error_msg != NULL))
 		mlog(ML_ERROR, "bad entry in directory #%llu: %s - "
@@ -352,16 +357,17 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
 	de_buf = first_de;
 	dlimit = de_buf + bytes;
 
-	while (de_buf < dlimit) {
+	while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
 
 		de = (struct ocfs2_dir_entry *) de_buf;
 
-		if (de_buf + namelen <= dlimit &&
+		if (de->name + namelen <= dlimit &&
 		    ocfs2_match(namelen, name, de)) {
 			/* found a match - just to be sure, do a full check */
-			if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
+			if (!ocfs2_check_dir_entry(dir, de, bh, first_de,
+						   bytes, offset)) {
 				ret = -1;
 				goto bail;
 			}
@@ -1138,7 +1144,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 	pde = NULL;
 	de = (struct ocfs2_dir_entry *) first_de;
 	while (i < bytes) {
-		if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
+		if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
 			status = -EIO;
 			mlog_errno(status);
 			goto bail;
@@ -1635,7 +1641,8 @@ int __ocfs2_add_entry(handle_t *handle,
 		/* These checks should've already been passed by the
 		 * prepare function, but I guess we can leave them
 		 * here anyway. */
-		if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start,
+					   size, offset)) {
 			retval = -ENOENT;
 			goto bail;
 		}
@@ -1774,7 +1781,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 		}
 
 		de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
-		if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
+		if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
+					   i_size_read(inode), ctx->pos)) {
 			/* On error, skip the f_pos to the end. */
 			ctx->pos = i_size_read(inode);
 			break;
@@ -1867,7 +1875,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 		while (ctx->pos < i_size_read(inode)
 		       && offset < sb->s_blocksize) {
 			de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
-			if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
+			if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
+						   sb->s_blocksize, offset)) {
 				/* On error, skip the f_pos to the
 				   next block. */
 				ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
@@ -3339,7 +3348,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 	struct super_block *sb = dir->i_sb;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_dir_entry *de, *last_de = NULL;
-	char *de_buf, *limit;
+	char *first_de, *de_buf, *limit;
 	unsigned long offset = 0;
 	unsigned int rec_len, new_rec_len, free_space;
 
@@ -3352,14 +3361,16 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 	else
 		free_space = dir->i_sb->s_blocksize - i_size_read(dir);
 
-	de_buf = di->id2.i_data.id_data;
+	first_de = di->id2.i_data.id_data;
+	de_buf = first_de;
 	limit = de_buf + i_size_read(dir);
 	rec_len = OCFS2_DIR_REC_LEN(namelen);
 
 	while (de_buf < limit) {
 		de = (struct ocfs2_dir_entry *)de_buf;
 
-		if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, di_bh, first_de,
+					   i_size_read(dir), offset)) {
 			ret = -ENOENT;
 			goto out;
 		}
@@ -3441,7 +3452,8 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 			/* move to next block */
 			de = (struct ocfs2_dir_entry *) bh->b_data;
 		}
-		if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize,
+					   offset)) {
 			status = -ENOENT;
 			goto bail;
 		}
-- 
2.34.1

