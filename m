Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EB91946BC
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 11:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718624451; cv=none; b=nSB1Mi8zTKaO5V4ChY+PmMyjxYGMBW7qd/q+i1v51xQHFr9ndxssK3aWKcm5X5ZpyBNpoVNWORO5tgfD9356PtkwsQN5XWnTHkEU6TpZxtvRqs1KbvgCSEJ8g8MArR3Ou6YWleuMNdrTqlidGxVya/4/5+gJXdsvB3MFxGIkZ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718624451; c=relaxed/simple;
	bh=61kDRcGBHIlay+ZivN71LrEF+p5LOzJ0ArLi/sqUGuc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tif2XuENBEV0yWEHbib51HlsvHSc4XgDucy4IHOkXvH83RG4mB3++SOZAVA93Ucm3bboiYvBauU5/GDGnbN4SiReJX4Ed7wS+akZgA7Q188vYEgYGlk1YoUnp4tFdLNM0sUck5dP4l7tjuy2tGlKMjhc7d9Z8IfnG6eeGg1b6g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=einOcS/S; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="einOcS/S"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7ebe508fa34so205813739f.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 04:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718624449; x=1719229249; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0gW1o0nvqKgGKLwdBEW/71SlYODvDmPcJus59fHnE2k=;
        b=einOcS/SnkkfnKN1lxbF9hUCXxPGXFNlH346KdKwA8nLlwwOZxR/djEyhiF3QaRmoc
         e7gKjx75YhXMnhV5yhXJZ2/EqPGLreQs6GUooDeF95BeUs51+dIEVQz38T7Z66wASFDr
         Ofdo3DPNgaaUD5qlsmFyjk2tjGev29p7PJfCY6uB73xTB0rWh2+IPVlWAD46BMJU30vo
         WNV/+TRO58uXkXLmkF3X0CL/w9mRKGXOcaXqHGbUxIpkUZAdoF3uNN5X5knfQDyjLj9l
         O3WiWQC5W6gd81wFT09Qrf4P+gJgwYctyx7Em1K4ZBiQk2r+0GPGI15xALQUNMJWjHoY
         /HgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718624449; x=1719229249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0gW1o0nvqKgGKLwdBEW/71SlYODvDmPcJus59fHnE2k=;
        b=fsLKQoi6uC1BXHL4Xm8BRGdZUoKMwl8hOmUA6YfXC9hjvsl4vuLMhWqj/ScNj3CvY8
         VZj03v9dLhiFepLRnIfNhqOSM9l19hogP+hgPIuTnxbHGuQ+4ab8snsW/I4PuuNpYAo3
         mi0ZdHOUYXKhP4wFy3JKgzVAtVDqCxaY+KPIu1Yw3XSJslMmmF5vjkM75V4YV3Au+X9c
         lWYBSWrhxpoODXFAHXVM2efhPPEjqRxPGHXbKueguC6ohLlLhR8dV+Zmn0RRFvQf5Cdx
         tPVVxe3THiUMV0L/M22g4vLFW+8DFgG5755/zjtZUvLklsMNPd9o5KBu/W7lCyfrJRpA
         b5Qw==
X-Gm-Message-State: AOJu0YyJIacCgCBNDk+7kps4516uri7RWz7xg86OszK5MjJYHGYjqNi0
	atZjEZcqzNKZI4GMQvZYHuGA9OsbuKQ/BQeowbfHQ36FnBEUtuyfQVYFzZR0jac=
X-Google-Smtp-Source: AGHT+IFw9+VNUyzvwsCXmwED2Qx+vFzDvJP/8pfoL+3dmap0DJ05Zp62uXwkFSxA6oLMqpt297W3FA==
X-Received: by 2002:a05:6602:482:b0:7eb:6e1e:8882 with SMTP id ca18e2360f4ac-7ebeb631097mr1281130939f.13.1718624449294;
        Mon, 17 Jun 2024 04:40:49 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb3cdc6sm7172493b3a.138.2024.06.17.04.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 04:40:48 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	joseph.qi@linux.alibaba.com
Cc: heming.zhao@suse.com
Subject: [PATCH v4] ocfs2: add bounds checking to ocfs2_check_dir_entry()
Date: Mon, 17 Jun 2024 19:40:27 +0800
Message-Id: <20240617114027.139982-1-llfamsec@gmail.com>
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
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dir.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d620d4c53c6f..562f61daf77d 100644
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
+			if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes, offset)) {
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
@@ -3359,7 +3369,7 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 	while (de_buf < limit) {
 		de = (struct ocfs2_dir_entry *)de_buf;
 
-		if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
+		if (!ocfs2_check_dir_entry(dir, de, di_bh, de_buf, i_size_read(dir), offset)) {
 			ret = -ENOENT;
 			goto out;
 		}
@@ -3441,7 +3451,7 @@ static int ocfs2_find_dir_space_el(struct inode *dir, const char *name,
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

