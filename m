Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA1F3203AA
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 05:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765776326; cv=none; b=MycyRB/qM4wunGX3DcwNmjMzB1GdQ1JW4DnM8ZrlHAkyq4WGXFKA/BGqHSiUGIg6zThR6B54FIfs2mCTTIfdlXzu9KVUZStZEKLyv1zmTrAET14C48p6mFbop4NYJMUN5SZAI6ZfMpLHkDUQbSE7l3dP0yDZMO0uBDYUvpPRhUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765776326; c=relaxed/simple;
	bh=4WohUcn53T/uQEEyf6y7BAhROophdwysksZvlgisaoU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gXLXpOu7gpLKZYmj5L4Tqg66Y5++WPUNnWddmMBVTFZYWbXug8FGsqNNFyZ/u7IstdCg87KO3iUX6lgwMKyPyvkOARYOD1xUsIILp+GV337SkvD/1h5JPKkrU0lJ4XLFy3DS+x01/keGyybViJKeFR3ULKD+Xfx3lY1gQTdhffk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dnMuzZQw; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dnMuzZQw"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-349bb6f9c86so4073577a91.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 21:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765776323; x=1766381123; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SyeYl+lpYngXeRFB+8S2RI9/QB/GCDHNJHtpaYarljI=;
        b=dnMuzZQwt+Nrvu0a4kUq0NgQfIuk2bAnPs3T/7f84Ro3ZbxC+yU64uvU1VkMJaKFVN
         uzAJmQKlWwejotxVqWvBvbBu6Wy4+hkifsxZ9aT+nktfDR2zOR1OZpo4ma/cJxb0ssHv
         hOLr/gGVesbl1Pq2t7+pI7elCVZoYOcHGR6IIp+3W6gHVUbyG0NfL+LG8nRYg+uGpJDX
         EdLjVzVlIrV76+u/9z/vmbVYt2t3xdkFDnlGgRP0/4VMsVIeUMLZkvTH9m5FOhW6e0xf
         5OZ3GM/FsjFOWbzIYQZwLNxvUg9BWWQuHOmjwygxLcCxlSlNe51Bl0kPQiLed78PSyHr
         7iRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765776323; x=1766381123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SyeYl+lpYngXeRFB+8S2RI9/QB/GCDHNJHtpaYarljI=;
        b=CElDOIza9aEmLzhgMBE3DVuzB6E2LTZEpt3Ry5ieOE/xzeW/I4m346X/OtQyIg9C9L
         Qsx9Y5HpSaU7K9yx8nbWNrJx/8h8G/n5ZoyJ8zLXVN8s8DExnfH//YmeNNypo49lojlQ
         qjejXCwZjuTFks0jVLWgMihl2JmmJa05yhJZaIyLvd7SlmmcBwpsPMBXWBGSajs3MFm7
         NhjZFq9nla4Xt9pmjswK4K4yA1ayoyrapxuhzYkhE++QsrSy7uVlsso242bNUiafy7nH
         XZae7O6NOQp2QMCJCMj8EuB/iLh1b1oL4nQPxk4pr+w8F24/qXcomAvONuP5r6S2fkiY
         odZg==
X-Forwarded-Encrypted: i=1; AJvYcCWsGXArjltvTdDkOOku8/aN5gTMdf/Y16oivXtKoUHi3Gp7j+VpDPBde4gw/XRQzpwfMmz7DjEjiC4bFA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwfpepAVJJ877yFZqBboQ2CSianvXQ/mPZC8fsL7mBPR0z+NldZ
	BZE/DiaCbcO/HuRO4P3SFXPIJprcicv11TsJ5vzWlqDDVngRl3rVUsQe
X-Gm-Gg: AY/fxX7jmPXhht+srl2KRTdYVaBVJ8Bc8ASJ5Gl+aRKC+Lv02moMEeUQZzYAECVEXL6
	5C7iPvDu6WZYMuA3zYXaZJ9lKwq8Il8zgpjsC4E7TptQWpe7ar9thw7chsqp2ShliZFXSba/Wfu
	Uw/pxKloKHyPJq3COWxopf/YxHQsc2eu3eCEJfDr/fYK6Rqe05H5vSYAqPM11/6A2lU7k+ftgvJ
	OuKRcj/fOpI9EHUi28MCMpqprLm/NRH3hG9PHxgkIQxqlsSV2ntVoElhha9P8Sbup3PpBmb4xyV
	ixIC9uLr5ZGezZRPdefxpu9bSugKaaMkToC78Z1fwnwpB8fBZ752cDOMBcczmibh2DQRkqUHXRr
	hySOnUuSdZdDe7S9Kfg0dJFLRqvyMq9igz75oetAn6f0BMrwBLQfoCncSB5cybQoSwPtSYZd3dR
	PYY2rmZTIuOMbv56dtu8LKNmQUTFiefBXPKyoNbw==
X-Google-Smtp-Source: AGHT+IGVBhhEJenk45D58KfOANg6YA1gEaTJXYAm9m5FyDU2UPChT5MOuTUtXkkNHjW1zxUFFDj2RQ==
X-Received: by 2002:a17:90b:5288:b0:343:5f43:933e with SMTP id 98e67ed59e1d1-34abd78fcaemr9259366a91.19.1765776323536;
        Sun, 14 Dec 2025 21:25:23 -0800 (PST)
Received: from localhost.localdomain ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2b9d9d6bsm11145324a12.24.2025.12.14.21.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 21:25:23 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	heming.zhao@suse.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v3] ocfs2: Add validate function for slot map blocks
Date: Mon, 15 Dec 2025 10:55:13 +0530
Message-ID: <20251215052513.18436-1-activprithvi@gmail.com>
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

This is fixed by introducing  function ocfs2_validate_slot_map_block() to
validate slot map blocks. It first checks if the buffer head passed to it
is up to date and valid, else it panics the kernel at that point itself.
Further, it contains an if condition block, which checks if `bh->b_blocknr`
is lesser than `OCFS2_SUPER_BLOCK_BLKNO`; if yes, then ocfs2_error is
called, which prints the error log, for debugging purposes, and the return
value of ocfs2_error() is returned. If the return value is zero. then error
code EIO is returned.

This function is used as validate function in calls to ocfs2_read_blocks()
in ocfs2_refresh_slot_info() and ocfs2_map_slot_buffers().
In addition, the function also contains

Reported-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c818e5c4559444f88aa0
Tested-by: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
v2->v3:
 - Create new function ocfs2_validate_slot_map_block() to validate block 
   number of slot map blocks, to be greater then or equal to 
   OCFS2_SUPER_BLOCK_BLKNO
 - Use ocfs2_validate_slot_map_block() in calls to ocfs2_read_blocks() in
   ocfs2_refresh_slot_info() and ocfs2_map_slot_buffers()
 - In addition to using previously formulated if block in 
   ocfs2_validate_slot_map_block(), also check if the buffer head passed 
   in this function is up to date; if not, then kernel panics at that point
 - Change title of patch to 'ocfs2: Add validate function for slot map blocks'

v2 link: https://lore.kernel.org/ocfs2-devel/nwkfpkm2wlajswykywnpt4sc6gdkesakw2sw7etuw2u2w23hul@6oby33bscwdw/T/#t

v1->v2:
 - Remove usage of le16_to_cpu() from ocfs2_error()
 - Cast bh->b_blocknr to unsigned long long
 - Remove type casting for OCFS2_SUPER_BLOCK_BLKNO
 - Fix Sparse warnings reported in v1 by kernel test robot
 - Update title from 'ocfs2: Fix kernel BUG in ocfs2_write_block' to
   'ocfs2: fix kernel BUG in ocfs2_write_block'

v1 link: https://lore.kernel.org/all/20251206154819.175479-1-activprithvi@gmail.com/T/
 fs/ocfs2/slot_map.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index e544c704b583..50ddd7f50f8f 100644
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
@@ -332,6 +336,26 @@ int ocfs2_clear_slot(struct ocfs2_super *osb, int slot_num)
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
+		if (!rc)
+			return -EIO;
+		return rc;
+	}
+	return 0;
+}
+
 static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 				  struct ocfs2_slot_info *si)
 {
@@ -383,7 +407,8 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 
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

