Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D94225408
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 18:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765824392; cv=none; b=KBsyA8RWMlSfutWMmKeGcpuLvBBf/QWcOl8u/zDXJxJtkbcLWefvHtXIaPtr9SU/GFTEEBA31+NWAZAECsp88iadKs2+qkdHys5AmUBMbHE3VpzZ6URg1NlUoYH2MHR+RMvV3WdQHscQzLdVHDJe2/Y3G7fleX8zH4NACxC43Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765824392; c=relaxed/simple;
	bh=rXKDAwDaGJawhQ8dUhZSGN3gqkdAL1GpjLf21JyUd2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iUBMlhC8yHK3av1tQDh4/O4l/npbf2ciuhnTx54g+nTHDXXIOL46Vren2Ej9jrTmHjBbtRmf33VIbcmeixz+lqoumrmG06A/n8AQx2LqZWlL3ztP/cxIrrpysP3s2NJiwARzBZHQ0mIJAli+24kDa2IvsChUkjDuBxDLDQcCkdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f04IM4qh; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f04IM4qh"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7b6dd81e2d4so3738315b3a.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 10:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765824390; x=1766429190; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=so5tlyJR9to0BdTSCEFt4jR4nZcyYj14BTL5CiJJyXw=;
        b=f04IM4qh7eJKxYyr9DgR0lQEYEOi/1t/KMWLUKve7cpXbd5KW/cThDylGynxPZOghl
         PGMGCvlCd4DusL1g3a2+n3x+rTwyv7d215Ii5EftvsL898TeV8UOrilsDi7f1pGDGffe
         KHPgX09ioYaQMAXpIp65czkp+ZequF50E1/f2yiYIu2GHtMQ1dBQYBNd59gYR+/yUTYJ
         h/v2eZymnv2XSf+bxBLn+ICmWFZCf5tsWYTigvuVTmVGAF+oPoAKWpY/CWa/s0jsUDVh
         Keerlz+gKjRWGyEUueNldw8EjwlwGDjKwTb6cOzm5t5hrkDlweENDsVIqOs1EeDahLoz
         Wruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765824390; x=1766429190;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=so5tlyJR9to0BdTSCEFt4jR4nZcyYj14BTL5CiJJyXw=;
        b=kD5yZPmheYEw9yB9G+zt0uIzJN1Ev7sxIhb++aAl45RIo+vRKKGmQ23cj9HJb26zu0
         xlWD2EBfjX2BqaqCptpc7nhWb4TuQJKXp8KV9JF2fPiOIOJTsk6jrWKxXa55Jx/JbpP2
         sOcdNQNu3A3VbTKJKUXt8LvosFJRhKIQ2b/IDWfXAy1630tqfywBsTbrojxBDmu/5+Tk
         QcsjM127mgrS1su3Z0K+3ARjVIxcLynNKo6czFTwAZfPDjFd6pOiceRqbnth5ys7Rgdr
         xPGN9kKN9fwKd+7OAAkX2yCQ1ne9gBSwcVndYWnknfbNezqHshahCDylqM+3hvD9vcOa
         vwBg==
X-Gm-Message-State: AOJu0YwKJVBz10ADIUhTZl9jFOmKwUaWdEfdQaCu0rPHEtdRQrAZ+bln
	xZNhKxQcTfRCFYmq390cGkW46sP3mBKaQ/QLRiNePQv3OPRsmClnhyql
X-Gm-Gg: AY/fxX5g+qYG5c2vWgC6qoJy1XdXZPCu2iLYcX5LN01dboAgVgHpWYDaRT5iMjQy/g9
	GuKEB1Wd4AfYwok0GXIvaVEM4cvYS5wqOaOi+teV+tIH/6S+GJHFlt9Qu+uyu+/CRLK4iulrkMG
	9VQTtTYkzq/7WLvc0NCGCBqNJYirAg8TWsjyeKG2e3I8wNPBwF+UPc7hda+88xDDPz9INS5tuea
	Cs7LsrOyIV4dhrya8ubrcJ7BFzgFdchIeGPMVhccudfWfUTrIHmfcoYYmuXOSDmURlrs3NH+wKN
	neRmliCmTByj24dHEtIG99frQMTE37h0Qg1cAjVw+0wHiJApX0SJMse+Nz2OG6YXp2wEDNMAG2T
	SGwcIcCJZBt19oan9Ux4TY6qXkd5V0KFR8y9dbaJUJx7UP+sIK3xDKmwKJnZcQ8I/Yz/EZxk6zk
	QcKbwNEJ6A1Oh5N7/sYoP/Fs+Nhe0=
X-Google-Smtp-Source: AGHT+IGu6ea6lc8otFEMzkERQIvMyATBlenq1D78I8JVDiZScI5uemRxzsl4ZB4dFPjwQC5mO4tCcQ==
X-Received: by 2002:a05:6a00:8c11:b0:783:9b67:e96a with SMTP id d2e1a72fcca58-7f664d05098mr11417784b3a.0.1765824390440;
        Mon, 15 Dec 2025 10:46:30 -0800 (PST)
Received: from localhost.localdomain ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c4aa91d0sm13244346b3a.32.2025.12.15.10.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 10:46:30 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	heming.zhao@suse.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v4] ocfs2: Add validate function for slot map blocks
Date: Tue, 16 Dec 2025 00:15:57 +0530
Message-ID: <20251215184600.13147-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the filesystem is being mounted, the kernel panics while the data
regarding slot map allocation to the local node, is being written to the
disk. This occurs because the value of slot map buffer head block
number, which should have been greater than or equal to
`OCFS2_SUPER_BLOCK_BLKNO` (evaluating to 2) is less than it, indicative
of disk metadata corruption. This triggers
BUG_ON(bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) in ocfs2_write_block(),
causing the kernel to panic.

This is fixed by introducing function ocfs2_validate_slot_map_block() to
validate slot map blocks. It first checks if the buffer head passed to it
is up to date and valid, else it panics the kernel at that point itself.
Further, it contains an if condition block, which checks if `bh->b_blocknr`
is lesser than `OCFS2_SUPER_BLOCK_BLKNO`; if yes, then ocfs2_error is
called, which prints the error log, for debugging purposes, and the return
value of ocfs2_error() is returned. If the if condition is false, value 0
is returned by ocfs2_validate_slot_map_block().

This function is used as validate function in calls to ocfs2_read_blocks()
in ocfs2_refresh_slot_info() and ocfs2_map_slot_buffers().

Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
v3->v4:
 - Remove if condition in ocfs2_validate_slot_map_block() which checks if 
   `rc` is zero
 - Update commit log message 

v3 link: https://lore.kernel.org/ocfs2-devel/tagu2npibmto5bgonhorg5krbvqho4zxsv5pulvgbtp53aobas@6qk4twoysbnz/T/#m6f357a93c9426c3d2f0c2d18d71f4c54601089ec

v2->v3:
 - Create new function ocfs2_validate_slot_map_block() to validate block 
   number of slot map blocks, to be greater then or equal to 
   OCFS2_SUPER_BLOCK_BLKNO
 - Use ocfs2_validate_slot_map_block() in calls to ocfs2_read_blocks() in
   ocfs2_refresh_slot_info() and ocfs2_map_slot_buffers()
 - In addition to using previously formulated if block in 
   ocfs2_validate_slot_map_block(), also check if the buffer head passed 
   in this function is up to date; if not, then kernel panics at that point
 - Update title of patch to 'ocfs2: Add validate function for slot map blocks'

v2 link: https://lore.kernel.org/ocfs2-devel/nwkfpkm2wlajswykywnpt4sc6gdkesakw2sw7etuw2u2w23hul@6oby33bscwdw/T/#m39bc7dbb208e09a78e0913905c6dfdfd666f3a05

v1->v2:
 - Remove usage of le16_to_cpu() from ocfs2_error()
 - Cast bh->b_blocknr to unsigned long long
 - Remove type casting for OCFS2_SUPER_BLOCK_BLKNO
 - Fix Sparse warnings reported in v1 by kernel test robot
 - Update title from 'ocfs2: Fix kernel BUG in ocfs2_write_block' to
   'ocfs2: fix kernel BUG in ocfs2_write_block'

v1 link: https://lore.kernel.org/all/20251206154819.175479-1-activprithvi@gmail.com/T/#mba4a0b092d8c5ba5b390b5d6a5c3ec7bc6caa6ae

 fs/ocfs2/slot_map.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index e544c704b583..ea4a68abc25b 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -44,6 +44,9 @@ struct ocfs2_slot_info {
 static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
 				    unsigned int node_num);
 
+static int ocfs2_validate_slot_map_block(struct super_block *sb,
+					  struct buffer_head *bh);
+
 static void ocfs2_invalidate_slot(struct ocfs2_slot_info *si,
 				  int slot_num)
 {
@@ -132,7 +135,8 @@ int ocfs2_refresh_slot_info(struct ocfs2_super *osb)
 	 * this is not true, the read of -1 (UINT64_MAX) will fail.
 	 */
 	ret = ocfs2_read_blocks(INODE_CACHE(si->si_inode), -1, si->si_blocks,
-				si->si_bh, OCFS2_BH_IGNORE_CACHE, NULL);
+				si->si_bh, OCFS2_BH_IGNORE_CACHE,
+				ocfs2_validate_slot_map_block);
 	if (ret == 0) {
 		spin_lock(&osb->osb_lock);
 		ocfs2_update_slot_info(si);
@@ -332,6 +336,24 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num)
 	return ocfs2_update_disk_slot(osb, osb->slot_info, slot_num);
 }
 
+static int ocfs2_validate_slot_map_block(struct super_block *sb,
+					  struct buffer_head *bh)
+{
+	int rc;
+
+	BUG_ON(!buffer_uptodate(bh));
+
+	if (bh->b_blocknr < OCFS2_SUPER_BLOCK_BLKNO) {
+		rc = ocfs2_error(sb,
+				 "Invalid Slot Map Buffer Head "
+				 "Block Number : %llu, Should be >= %d",
+				 (unsigned long long)bh->b_blocknr,
+				 OCFS2_SUPER_BLOCK_BLKNO);
+		return rc;
+	}
+	return 0;
+}
+
 static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 				  struct ocfs2_slot_info *si)
 {
@@ -383,7 +405,8 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 
 		bh = NULL;  /* Acquire a fresh bh */
 		status = ocfs2_read_blocks(INODE_CACHE(si->si_inode), blkno,
-					   1, &bh, OCFS2_BH_IGNORE_CACHE, NULL);
+					   1, &bh, OCFS2_BH_IGNORE_CACHE,
+					   ocfs2_validate_slot_map_block);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;

base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
-- 
2.43.0

