Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9416C155C82
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 04:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765773535; cv=none; b=U3mYMdkG6tnXdMqCyR4nZ3ZqNDUnJcdGig8ZqOi+uay1rNPoK1gCpR8uVJyaWsYGwRHWFvvEaUs5WII6CoFv0MaZ9XetxmajHWTWB5AOQQidgBKkPIHPLJeE4QxGWKvFA6hU1gu+lB+Xa2Up+hOvIxubK0JfdqG7j6ufFtKiibU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765773535; c=relaxed/simple;
	bh=nJNd9Ou7Omz7pz6u8AfGHA1bP0OMNFyFZacoqBCjWgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTNiXphVt15AbQz4/LzBLDDFXqBtNGFqq8nMtb3alvNR1EQijOE8MgY/JjlDIgmW95RVK6VF5S46iYsLmtXm/aKhw1hZq9C7ROvrIJhPf4NfdOLRcXjkqvgO4V1ZH2KqlzJzFl15J/99RGBJ37Bwb5djtCZ/mHDoMdnNAzaJOlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LaPkaeqk; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LaPkaeqk"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-bcfd82f55ebso1015565a12.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 20:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765773533; x=1766378333; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6B4tYlC7+ZDmua1aPfbzXm6ixP0KYAZOB24RqxDWzY=;
        b=LaPkaeqkXg9C7fZp+XTFHguaHpPNTEAuQBpNfrlrSn8mGhoxuyD3NFV0q1WUy+zaxN
         rGzlsTKW3GKOuf2kroO8c/ck2/JWMwaH/UN0vVEXAuJIpM5g0DcUDfz82phTIjRV9veW
         ejhrs++vsPpkDY8+Qr9Jt+OEQMre7XfYWosl4AaU4AK7kOAawxeTqoPh9ItapYaae2+I
         FU0OoOJUCDcO43lWbUcQXIOZ9wdJCf31Y+QpTD/XyxNfjyPWUwfVQsP/3XPrqwGuEPiw
         cvjFt9Y9U9XpRErs0Qxs0nkcWpzYPK8A66Ei+sU8cspe+wRr0R2AdQIaZecAXWxZ53gI
         VqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765773533; x=1766378333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y6B4tYlC7+ZDmua1aPfbzXm6ixP0KYAZOB24RqxDWzY=;
        b=e6bBQ5U+fJ2pqbUKGP5vxbJCyZ+mgvRB4IorJsoZ4pN3pBsTB/col5shn+/+ddn6D5
         RDFVszc/nJpwe3Ft/3fjBZC9TCdKte1acXSjb+q+b1cxX8pP1ky7n0ft9O0Z3uzp7CII
         MzqkXC1ziyrQprCBm6Lmoex+5RQf+gcKbFpfgFJI3VPJMivdw7s9A9w2lxvFkz/SySzo
         Pgy7aVPOQWf6AXN53CY9kwdJKWOmbtRCno3aRvODdTzNhmDimktjypoO4h6JaXVPicen
         kHIu0WBJVh3rK88RZzRHgvKS0VyYESbEc++B35MaReHx0rlDi8z+CsvMeu0H6HttrpWn
         YDEw==
X-Forwarded-Encrypted: i=1; AJvYcCVfiRzu2TJK56e6zevaRIqhQg1v23fIeTjh8hvnyAJZREzY56BmTtIXMDdhGE8F8iDkZOrX4+kc+mnm9g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxvENHZ2arNO4G1hGpYEmthtSPE2gDNPtXChGjEBVEeJipctKOH
	nrwVgqCT/e2RxZwjdyWejW+el3pPuTnnHWWqLgbvtHba55fUxp3D8+ec
X-Gm-Gg: AY/fxX5z67AIMb1BEnMFRbnA0OOVJiDwLBjdXjYxqYytJMUE7GN3UJz9mGfH/2sfaix
	V1zfdcFhqdPnDls7c5R1NJehOkZv+9WAtBIJh35aAQX+e6p37UHLBbLTVSQowjt4ajzKlIqz74x
	sA89qAQfAuGLabwqfjPScWDNFoi+yNW0UOg7AlgYtJzrXzIe5g01d9F2thsvBU3JJPiQgK7ryZ3
	oiZUdBQvfyzXDFY2YW99L9lYHwe3VNLPBqeVJJ44B/fuV1Svqn21yDa3UhQ8Q7Ijs4FYwsq/zs6
	qj57m77cFtuNeFSoYK7A9C9KporgkPLb0xBNBWrOII7rc5ECoM1MHxWK3RJCqTKEDmLOwFcSx3L
	JliW03602Aj1aYadu2DwIASdfnOOFSR7doiMdOxiYGxHG5weDBgYXVIK0+QNXI8e9GDylLSm85o
	zXJ9eeLKwzvIaQiOY2XNbHoSv1Hs79iz9PZxUMCSjMmgk+y3OV
X-Google-Smtp-Source: AGHT+IEBO1hQRk7zuEFadE7UPfyKQh3bvCHOrIcv9PTeATIzINZPQLJ38nN/Ooq7qRC6XnaaPwUSAQ==
X-Received: by 2002:a17:903:22d1:b0:295:134:9ae5 with SMTP id d9443c01a7336-29f24eb0207mr70985085ad.24.1765773532710;
        Sun, 14 Dec 2025 20:38:52 -0800 (PST)
Received: from localhost.localdomain ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29efeea93fbsm98964885ad.83.2025.12.14.20.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 20:38:52 -0800 (PST)
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: syzbot+c818e5c4559444f88aa0@syzkaller.appspotmail.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	mark@fasheh.com,
	heming.zhao@suse.com
Cc: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	Prithvi Tambewagh <activprithvi@gmail.com>
Subject: Syzbot test for ocfs2: Add validate function for slot map blocks
Date: Mon, 15 Dec 2025 10:08:10 +0530
Message-ID: <20251215043813.9536-1-activprithvi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
References: <66eb6a0e.050a0220.115905.001b.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 24172e0d79900908cf5ebf366600616d29c9b417

Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
---
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

