Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D511D79DF
	for <ocfs2-devel@lists.linux.dev>; Thu, 13 Jun 2024 02:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718245565; cv=none; b=O9/QEI9XQxtg1HodUJVWv5paRQkrbonCWuOPtaS7rxnRE7IY2ECO6pQArSCVBQC/S9Ol93cGjEP57V37oe+797vGQzUf7hmBUptNDmHGQBVO7tj70UQkHaVAYMKvjXxaIBxH53XTZBI21wsVhelAZDf3imBvAuCFmnoEvkJnoaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718245565; c=relaxed/simple;
	bh=AKp7XjIkKVqaHhUrvaYZ6QUo8h8xwX02DmZbAEkxrxQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VHP96THE8ou1s06QYLyUdyeTVvWKG0LeUerTm+R7JUFd50AiPrR6+ZHZOqaOzb/mxYj5Kq6vQLKYFCYawUR4aPzxaXdD/61RY8qMuYIRP5UUDEyMp+EVVvNaKz5znbFNxqRBZu4p8KsbI/QKu6VH8D6EiM9+lKyFFoLIWBKu1L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MfexpYUT; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MfexpYUT"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3d22368713aso277201b6e.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 12 Jun 2024 19:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718245563; x=1718850363; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S3efCUc2DqfhW+ogfPiSpA5/WSRriQXorfz/GF6CB80=;
        b=MfexpYUT6graIRKcBJCkCOP17qhk42J4jxdMWv04vRGBd8f75P8cwtt63BZ1NdXGz/
         4ilqBTMmrJJ2hx5Pm7gksaykCZqcDYrNabV5SuG95IzjCkNeRK643KvBDxBmY2q4OgUA
         sTEnGKnXwGuFOS74Es41HgyQNY1uXFK2+KvwDR0xI+fCV6wOBQwNi/tcPloIkp7y5i5F
         RKVXDw/A4QZIijVR0MUIEjBo79TeDHBlKRfoIX+MnEuw81Z7UagLramHq5H4XogbtVIN
         KNl5GJunFLafnJAiW85HQhKbCTlnlIEj/9MPkfu2uR6yWtH/RolYqUCtgsTAFefvz8Bn
         3bZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718245563; x=1718850363;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S3efCUc2DqfhW+ogfPiSpA5/WSRriQXorfz/GF6CB80=;
        b=QqBJzmxQOu7BoLV9/7Bcwawb6Kn5HOkww2TvWbViFR9RGhj5w+CQ0zBHw0larf95Hm
         9NDkk6u59dBjBeVp93Pf7jGXhdKeLQqfhjCj75PDq61HWjgd60MAB4NdS4io68r9nCjZ
         nexjXoqu4WawkfiOQPHAjdzdHBH04aSDiOUZ0Rv8HsuLUqHFEUZd+Gj+paQ7hWfaqMDG
         cO1S3Swlv6slp7xWJLLpJjJkG/8szHM3ile3yctNFGKBinZvFHzDrmYcb2Lg+Vmx2P0U
         aRMdyCRsY9fxdTyep5xzFspjQGk26DXaF9a6+LNWn4aMvm0Sm+gRjaQvuGucZWzyLknD
         qLvw==
X-Gm-Message-State: AOJu0YwHNUwcHa/P7/r/V8Eyk86giEIrAlT+PLo1/pUdPO1k3d6QLk0M
	B8HwpXq35O2SVzlplbe7aMkKQEzXRWbrB/cl9dnO1CUzVIN7s1VIIPL6Qc+X9oc=
X-Google-Smtp-Source: AGHT+IGLqLoHrWTzY9KNf0UQCB/P+WWMDBIKnkQfHUeV8TgsHcyhiG2hZjFWyXsQ0Qn5Xrl9t5SKJg==
X-Received: by 2002:a05:6808:2191:b0:3d2:308b:9bb4 with SMTP id 5614622812f47-3d23e0cfbb9mr3999083b6e.43.1718245562199;
        Wed, 12 Jun 2024 19:26:02 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb6b788sm253415b3a.164.2024.06.12.19.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 19:26:01 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com
Subject: [PATCH v2] ocfs2: add bounds checking to ocfs2_check_dir_entry()
Date: Thu, 13 Jun 2024 10:25:38 +0800
Message-Id: <20240613022538.121631-1-llfamsec@gmail.com>
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
index d620d4c53c6f..7aa4a5733993 100644
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
+						   i_size_read(inode), offset)) {
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
+		if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, sb->s_blocksize, offset)) {
 			status = -ENOENT;
 			goto bail;
 		}
-- 
2.34.1

