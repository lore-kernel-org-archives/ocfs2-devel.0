Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A6713AA5E
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 06:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718693701; cv=none; b=XmzHZ+R39PSOkP/VrrdfBnKYm2CiMRlJxHvKDTNhuYhNT1GhczBaRJ2Z3a+saE0fVx9Onkyd6GiLZUtEdwLcITihC+YfFGiJ70ZD7pQjvVGZ2BZd2Cy9bER2HJqvFpLtequx7en0ZQIFNlTGSdDVYsD3BvuHUcaCFPSF3+R7TgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718693701; c=relaxed/simple;
	bh=Fi4yRZfIMI7i9ED/Dn/bmKFJCCyWJ3zo2K21GSbOLcs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n9L16Di82sZom3okVBnOXu8KhZJaTW4hGYiMn4pTZ7ZzSuS/QuPdYCuAZyoV6iQizMXFcP19c9pW7MHVLvpU8QL/BNA/hC/imM32bemkpLyEaNEncpQcVgeAcqWzfCM6i2Pshep1XxGVmDJcuiaTgjkLOGLStZ7f4JTHY9wAUHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ktJZU2Fg; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ktJZU2Fg"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f44b594deeso47844395ad.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 23:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718693699; x=1719298499; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n6Kf7MvErZAKNc8FP5zmZTrLliCAvLskrMeB5vHaY8I=;
        b=ktJZU2FgHzT9QI64tlbP1lgaKQbFR2wK98L+E3b6K9ekdXNPp3WTwxd+9/a+USrMg4
         wW2TJ/vS5y36wH+I0DqTlpMQpe1/sDL710gmIXXaUUGPYG9uc8WQkcTOINt9bFbPhsUH
         txYB53cSV5hb5KwRXH0ykajSz9EjIyignlBNlq0wrVFUNeOKqSeG4iVKnIohm2x1QOQB
         QxwOEXP3ngC2ICmI50YCqVLykFXK1i7IChbWmynqGCOunhZdFgGvZ018m3RzJvRc9jks
         rHHFYJLJ1WwXPaa+Et1rm96AYgqDKwrQFCVYqOpZLWSfnF4HNGlCEgyDzNXQowsHrgZl
         iNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718693699; x=1719298499;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n6Kf7MvErZAKNc8FP5zmZTrLliCAvLskrMeB5vHaY8I=;
        b=GtxxXRAQnxP5IvPfOz5OLBZM+rZFSSyDEycvXJwjOYDlJgLkfiVU0Crf+FSt9H87vR
         RQIPyMAMn1WdqERrOBfEn2u2MocPhSxQ7SRJP+5vLW75952hQrwjDEhvlHvFrWU5pljO
         q+UWiIcwbysgmLkiHVn+Kt7Z5a8omZ4AdNbwRJQJqGxolKLL0EKaROusR5Zk977WWK1M
         qAUaXWwtttKBHRZ6SlrdYW99/YmrJQTbcdI8anlZ5sBGa4f20C3ScRg853fAl5rLaUl4
         va/3tz7Cn6J9CogC+aI4Txwp6QT0Ad6WQeNqVe9N7QQogb8N/KOx2YfiUzrAEagbWToS
         9NNA==
X-Gm-Message-State: AOJu0Yw2WV0eC7e1vZRkQL5Y6ghwx2NZr7nvj/jy5K/Nt/w4pduSWu9u
	F5VCXyJYk61+ZSqsHC4RuN/77BohZn33YJHLJD9od5yOK4pRUzDOJkUB+Hx/1pQ=
X-Google-Smtp-Source: AGHT+IF0DHPqapeaRCwkBZvd3+iXSmb3O6Oy0ISflZqvr4xWpmfu+xVcjHyTRtuW5vYkcpDFmk6LkA==
X-Received: by 2002:a17:902:f685:b0:1f9:9691:7b9a with SMTP id d9443c01a7336-1f996917e61mr7771635ad.1.1718693699008;
        Mon, 17 Jun 2024 23:54:59 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f497a1sm89886925ad.283.2024.06.17.23.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 23:54:58 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com
Subject: [PATCH v5] ocfs2: add bounds checking to ocfs2_check_dir_entry()
Date: Tue, 18 Jun 2024 14:54:27 +0800
Message-Id: <20240618065427.143612-1-llfamsec@gmail.com>
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
 fs/ocfs2/dir.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d620d4c53c6f..cdd92b4f9bf1 100644
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
@@ -308,6 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
 		error_msg = "rec_len % 4 != 0";
 	else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
 		error_msg = "rec_len is too small for name_len";
+	else if (unlikely(next_offset > size))
+		error_msg = "directory entry overrun";
+	else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
+		 next_offset != size)
+		error_msg = "directory entry too close to end";
 	else if (unlikely(
 		 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksize))
 		error_msg = "directory entry across blocks";
@@ -352,16 +360,16 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
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
+			if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, offset)) {
 				ret = -1;
 				goto bail;
 			}
@@ -1138,7 +1146,7 @@ static int __ocfs2_delete_entry(handle_t *handle, struct inode *dir,
 	pde = NULL;
 	de = (struct ocfs2_dir_entry *) first_de;
 	while (i < bytes) {
-		if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
+		if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, i)) {
 			status = -EIO;
 			mlog_errno(status);
 			goto bail;
@@ -1635,7 +1643,7 @@ int __ocfs2_add_entry(handle_t *handle,
 		/* These checks should've already been passed by the
 		 * prepare function, but I guess we can leave them
 		 * here anyway. */
-		if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start, size, offset)) {
 			retval = -ENOENT;
 			goto bail;
 		}
@@ -1774,7 +1782,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 		}
 
 		de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
-		if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
+		if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
+					   i_size_read(inode), ctx->pos)) {
 			/* On error, skip the f_pos to the end. */
 			ctx->pos = i_size_read(inode);
 			break;
@@ -1867,7 +1876,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 		while (ctx->pos < i_size_read(inode)
 		       && offset < sb->s_blocksize) {
 			de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
-			if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
+			if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
+						   sb->s_blocksize, offset)) {
 				/* On error, skip the f_pos to the
 				   next block. */
 				ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
@@ -3339,7 +3349,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 	struct super_block *sb = dir->i_sb;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 	struct ocfs2_dir_entry *de, *last_de = NULL;
-	char *de_buf, *limit;
+	char *first_de, *de_buf, *limit;
 	unsigned long offset = 0;
 	unsigned int rec_len, new_rec_len, free_space;
 
@@ -3352,14 +3362,15 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
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
+		if (!ocfs2_check_dir_entry(dir, de, di_bh, first_de, i_size_read(dir), offset)) {
 			ret = -ENOENT;
 			goto out;
 		}
@@ -3441,7 +3452,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
 			/* move to next block */
 			de = (struct ocfs2_dir_entry *) bh->b_data;
 		}
-		if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blocksize, offset)) {
 			status = -ENOENT;
 			goto bail;
 		}
-- 
2.34.1

