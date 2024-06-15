Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23F1D517
	for <ocfs2-devel@lists.linux.dev>; Sat, 15 Jun 2024 04:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718426494; cv=none; b=VyZxHf5dLgf8S9MTe74846/JFpwZfw2+VfASsJXbBl1cbe7lFBFrRcje4frx0oxU6L+WlfgSFdLe5lRxWeMxuc3flTF3WPbaXiFM4yCW89uVD/r/o/+I4wVdE/g/oR7kA7U/yZ6qArNQxSWlTymAHW1m14fDUu9+YN9bRgufhSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718426494; c=relaxed/simple;
	bh=nnG008XucAwMIBozxKm8eao5EgKqYwo3b5qQD7lvDqo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Yp3TxDWBi6d57tsHuBXfwUPxS3JHWz3ZRLkWg80MqX6df4ey1Js7YzDZWATQUP35iT0yDPh6XV51CSyI725dSbrs8fBZ4omaJeInAwfQNNyBH4hOzUQLLcpbGVXQ24aHCcz/6JXCA+Hr27i5QaTHF2wu1JXHb/FkwTWppNxhDrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PvvuhT7w; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PvvuhT7w"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2c315b569c8so2389747a91.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 14 Jun 2024 21:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718426491; x=1719031291; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=huYgPzt4Ltdk8fjpFI08caL99Ag7McmC8V+Aauu+28o=;
        b=PvvuhT7w5gL0tkQ8dUKYkQ9eATpIVbBhBtt8oCSwrDX5YucmH3BhyNNlxkuOz8MT+y
         LIqFYNDtprXlb1gDIiNPUUW1CZbG9cY8UxQHGn83Pcxutkc/aChOw8eO4g8byzn1cokE
         ABibfRqW4NoASFC4P0zp0/eF9d6WcMasEdUu6FGamEG9Ea0bLW3/hax8GYTv7a2Tydq/
         35YzD1+s0wcPRYf3/VuXeo/zUGyjso06APS/XD8VZTrdc6vnQNhOO8mEXlwKUhliVcdS
         QC0WJkhBpVzQw9rleLIWDt69RGBhrOFtWO+UWDC5avvdJZ63uYfhumb6106izBxDjfvP
         WSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718426491; x=1719031291;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=huYgPzt4Ltdk8fjpFI08caL99Ag7McmC8V+Aauu+28o=;
        b=A3bvhPzEDCfTEaYnPkkFbB6uYo3ucXCnS/++oQIuykw++jbKe4nq+v0yd/SLktmD9D
         0k8JwmVZywQUyu8HKDCSl9b7omLY9jqg7j8Kxl62DuancAssj/wQakk3BjkbE8NwHemq
         WMK+TdI4B3W2jBraD8zX5bf0+la0KQtJh3XSX4viRnop3izvYrc7W196qMaYRKke1G/t
         JSKGC00cCCEAEEEA7kG/+a0Svktfb//MSAZOjOnr3GEe1oTW3AH43yX/UvY9z9jQApC8
         p6nZNPR5cGh8gqqnPKSR9Gvr+nIrnkdD5eB86xxxWpqsN2QrSyjVDhJEvyjNG/yMFqi0
         UPzA==
X-Gm-Message-State: AOJu0YxbuyuRhC7IGCX+FsGkFGP+2grCuztnN6ewL1/jRPQvBcvGjnVF
	tPS3R2RpVmmw8yj46wb7LAMlp5FcX2S+4Lyft7CFmamVBgtjsjQH1sfa9HR/GEU=
X-Google-Smtp-Source: AGHT+IHbHyZyRTZfcHfYEuB8LDXSrNliEsECHehbmN9c3krf4imGAFllO7pTVqShK28V8jyokaW2eg==
X-Received: by 2002:a17:90a:7d17:b0:2c3:1f27:e7e2 with SMTP id 98e67ed59e1d1-2c4dbe3be05mr4289203a91.40.1718426490949;
        Fri, 14 Jun 2024 21:41:30 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75ed69csm7240860a91.14.2024.06.14.21.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 21:41:30 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com
Subject: [PATCH v3] ocfs2: add bounds checking to ocfs2_check_dir_entry()
Date: Sat, 15 Jun 2024 12:41:07 +0800
Message-Id: <20240615044107.135012-1-llfamsec@gmail.com>
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
 fs/ocfs2/dir.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d620d4c53c6f..ada97ac6e2ea 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -294,13 +294,14 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
  * bh passed here can be an inode block or a dir data block, depending
  * on the inode inline data flag.
  */
-static int ocfs2_check_dir_entry(struct inode * dir,
-				 struct ocfs2_dir_entry * de,
-				 struct buffer_head * bh,
+static int ocfs2_check_dir_entry(struct inode *dir,
+				 struct ocfs2_dir_entry *de,
+				 struct buffer_head *bh, char *buf, unsigned int size,
 				 unsigned long offset)
 {
 	const char *error_msg = NULL;
 	const int rlen = le16_to_cpu(de->rec_len);
+	const unsigned long next_offset = ((char *) de - buf) + rlen;
 
 	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
@@ -308,6 +309,11 @@ static int ocfs2_check_dir_entry(struct inode * dir,
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
@@ -352,16 +358,16 @@ static inline int ocfs2_search_dirblock(struct buffer_head *bh,
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
+			if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes, offset)) {
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
@@ -1635,7 +1641,7 @@ int __ocfs2_add_entry(handle_t *handle,
 		/* These checks should've already been passed by the
 		 * prepare function, but I guess we can leave them
 		 * here anyway. */
-		if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start, size, offset)) {
 			retval = -ENOENT;
 			goto bail;
 		}
@@ -1774,7 +1780,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode *inode,
 		}
 
 		de = (struct ocfs2_dir_entry *) (data->id_data + ctx->pos);
-		if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
+		if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data->id_data,
+					   i_size_read(inode), ctx->pos)) {
 			/* On error, skip the f_pos to the end. */
 			ctx->pos = i_size_read(inode);
 			break;
@@ -1867,7 +1874,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode *inode,
 		while (ctx->pos < i_size_read(inode)
 		       && offset < sb->s_blocksize) {
 			de = (struct ocfs2_dir_entry *) (bh->b_data + offset);
-			if (!ocfs2_check_dir_entry(inode, de, bh, offset)) {
+			if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_data,
+						   sb->s_blocksize, offset)) {
 				/* On error, skip the f_pos to the
 				   next block. */
 				ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
@@ -3359,7 +3367,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 	while (de_buf < limit) {
 		de = (struct ocfs2_dir_entry *)de_buf;
 
-		if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, di_bh, de_buf, i_size_read(dir), offset)) {
 			ret = -ENOENT;
 			goto out;
 		}
@@ -3441,7 +3449,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
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

