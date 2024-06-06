Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A0219D898
	for <ocfs2-devel@lists.linux.dev>; Thu,  6 Jun 2024 06:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717656929; cv=none; b=muw1NSjUvmrlJiVXgSSK2Zm1JY4RWGiOAKr1jtq3NLZ4cJQDrW85m1+R8lsZe6eLcARsnqo9er5iFD+4D67R4GsDf7iQGVlUA/ZtjZ0RNYDLytnl+4kq+O9kMakVIqgevg++n8ntTz0lr0tN3gcQl8up88uT4/YtKKBcW5nrEs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717656929; c=relaxed/simple;
	bh=h2P2Qlu89EH330ZcrvNCBrHYI0f+Kv0Mt2T3ALCMJeM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WANPLwG3XhaUGHMqeN7kmY2LzlqksOQVopcCNLSzf0U1kcV1QDPc+yWzFvZL1I36hITBUUwj0pjNVjVPPryTtIxiGkqijM683B0YH70oYxz9QSUTFFMyCegpV+IR31y7R7LiDHAo05PTCys9aZk2BAUG4XiR201fk++pkIZ49I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hF/vkBBL; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hF/vkBBL"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-652fd0bb5e6so486948a12.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 05 Jun 2024 23:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717656927; x=1718261727; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=spLDjCPQWlGrMTyIFjNSOgZJP+06NZf9SmzKRrhODqU=;
        b=hF/vkBBLSOZaE0s66e/KtSKkSLd1qv0fUH/9E1tsq8z5mninm3z9hdDMwBcXBuA0bM
         9TOA2KMyBUK6zc2VfHAvYZUPnMlJyD1EEDSaJGveQGOCcwU/0mJ+gFPmn6evPRgx0KO7
         pHrCofLYky4Kc0kOpkWyxLvX4ZS1YabooxzrFNH26G065TNh9hkOk6DaaakqR22H8J53
         b4Jtfd/a5wW04SrPvIGvx/kILDCrLXWN7Ow3Wz2w5VOy+yg7WLexIKtJFS/sS09Ktzc5
         UNWL/9JdpfvU/Bl4Xn2IYPMnNBg/0yJlEzMhGOWuOwnuYg1jopjf5dixgG19KLYmW70J
         9z/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717656927; x=1718261727;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=spLDjCPQWlGrMTyIFjNSOgZJP+06NZf9SmzKRrhODqU=;
        b=Wd7bYfS3yMVXRtxI0f27Lhv7jxzlmFCnihZdqQ8SzZr9NfZ71uFZpjetL2EHJCZwdd
         v9Cd08DKZ0RFVOETHWqDMcEVMf5d/8wze8FWXHCGyfXj2rg4dFDYLOSImsWq/ciFh2RV
         vPaCBNOhmVZCEk/MF926EpfeCRCIJr4WNzwKuKLaaFSl4unr5svmihNxZ0VM6Wv8M7KA
         hPF1a9mvswy7hUvTamSmZlRnreCcXWGpl6SU2CgYFzjyP2NZXNiBfVEbRp+JXkv49jpK
         BG+aqdB1qfWJTnf1Q53jpzlzUu0zr1NOqPjCAsWYkwxQz/HLQ9smuwdLaEff5rTK7gSy
         w/4A==
X-Gm-Message-State: AOJu0YwT/MjgkAg6/Nn8eF49QVy3mnLFwAKDtWPecqkUfle1azk6DY1Y
	Gf7Cz47ojuiNHBjtdlxli638HOGVLjk2/iAXKjS1QgfsbCbB10H46jhpHGowGwk=
X-Google-Smtp-Source: AGHT+IH6THWzeDtJAwFWkuG4KHkSk2LDSrc3CbOturZoT7gNAAV5d6UIe8PVpS03N3n49l99Lu3EUA==
X-Received: by 2002:a17:902:ce91:b0:1f4:9b2a:b337 with SMTP id d9443c01a7336-1f6a5a01fd0mr61380645ad.3.1717656926610;
        Wed, 05 Jun 2024 23:55:26 -0700 (PDT)
Received: from localhost.localdomain ([47.238.252.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd81bd71sm6758775ad.304.2024.06.05.23.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 23:55:26 -0700 (PDT)
From: lei lu <llfamsec@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com
Subject: [PATCH] ocfs2: add bounds checking to ocfs2_check_dir_entry()
Date: Thu,  6 Jun 2024 14:54:55 +0800
Message-Id: <20240606065455.94846-1-llfamsec@gmail.com>
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
index d620d4c53c6f..85966385d134 100644
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
+			if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes offset)) {
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

