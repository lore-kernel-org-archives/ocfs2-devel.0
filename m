Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADE21E3DED
	for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 19:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765740078; cv=none; b=MXhUmEUyOfU0bgLjBn4a12178YbI6Cyc1V1SLQcbf+u3rpW5Q3/loOxLyByvBe3et2q675wUZumn6Yu5/Qj5Ke4G1JvFH+QrOgLamj5y1hxSlzgTn8JHjDpn3lBssEeHdzs6lXQngeNjAtqkHC1HgzdvRgg4VbeI7srgP9lyXws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765740078; c=relaxed/simple;
	bh=voWHtzGyyQ4i/nihJE2JfMu0Lojaz5C7oHMPpeDmQRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJkZA0oMO+u8/WlMthAkBbKr+0H0qBYOZ4suEFTcMw1AMDbvISt7H/itzQe+ktj2/pB8768N1dm6PBMGiDcIWa0U4qxFjSX90tBNUm4Ev4jYgz6zLVqSD04VJ1hB9cXf22CkWuIqEU6omsguUBJSpmglhPYK6ETVum9ml3BLsuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W4thl96b; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W4thl96b"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a0833b5aeeso23491395ad.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 14 Dec 2025 11:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765740076; x=1766344876; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohALeonmct0k8sTTIiNiaXuDw6b1dfKBRkVVMQZ57eY=;
        b=W4thl96bP8H0bU3Ar68TVmUDNQjrUItf1wT7U5v3SsHttm8xtraEfoE4378E8S3Q7v
         zaEBeSD7SepM/g8zzRXtsm15UCj2sZPqaK2jDi0brKPXaNANCOf8G/cay73P8XzIpYDG
         gYGUKtfDOM3bG/iYE7tGrny4/UaYdXEk/cwOB3cXkfDg6E8ANQAKlwD+PPTvu2u4jiqB
         QlxWuWlSljxTOdb3TE/3/EgATCQzSiIBCmqDCZh02h8NBxOr3LRzdBqUqkBh2zRc/COt
         OmrSyrurRz55igRj8DUvrIs0bTaU0ngDnBnqwXINlZhzNd2YgmoRZciTgt1VTHdK/xlO
         wI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765740076; x=1766344876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ohALeonmct0k8sTTIiNiaXuDw6b1dfKBRkVVMQZ57eY=;
        b=w0Sss8hpQox9WjIeeCXA4LztFgUTjcBDGb4ZVcv6FQ21Icpg3vc1NZGUiAVwYN6dAi
         dnF17RC5m1PuDSIwBPSEWiDBBBfYl9J+67zZ58tYeexq5G+sppWZuyWWvaI/ebh9wdIk
         z5msijYoYcQl5BgEK4wxseB76yWzm1It0eVc00byneVHX1hab/p1jV3SQK0j3Sz0NAaq
         2mUTHjHjdVxGRxp5Bl9YmzAYtLaALpO2jLkgRy0pUeVFMR66QokOkEy4Plak2iManE0H
         fgakVl19cftP5+S6JxaIbapGdtc54Sc1ycB4v6OBrFy3mdoMbA658XdWPGjU0t6s9LBI
         skoA==
X-Forwarded-Encrypted: i=1; AJvYcCWSREiZyvt7v+Um2nq3gZzR4cwJglBVYR476hUvYdA/oSszXVOIMc8k2aGaieDb5MxU27x5Tepsx1O36A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzOnwDmcLsP8vYc61vp12NoUABv/bmZ7NGz7SZCxKFMu8k9BgoW
	tx93QWMM7RL0tEsaJKE9JHhEmgnp3121zmlf4OHcEfymUdUDzllUG0XI
X-Gm-Gg: AY/fxX4h0unhnj/c1N7/6GwWrSMCPmBuPEH/3Y5X/zb7ZaIuEmaJjyYvf5y9x2WqB6I
	hZ2CYijKInw5D2oRXxatBVt6XSu7jglzxyYizVGRfX9TkjEzwX0UkVlr8rw5Tc1PQr15FmQuj1u
	upDI38+5XiX/xatbbPEXLjiABSL0YmpALaz3FvDl124Jkj7e/P/epTB3gNf+pkwTG3/blgkjpzd
	DPKbGEImNYsFdVV305GJ1/1soiTOkxqJ6z3ypOtzfuincJCJUkygE6rjEbXFtOhdZwLBfBi9hCA
	LoCjcJt22VjNUh4yF5/v71p15w0tbeusoGOLPGuBmGB86RExQbqpoAPKyWvXZdqhbVtbRtratKk
	ibZpsssO8bZs3/yrfZuf7Kucj+0jz8TJ49gzvmwArcyqXYQD8phR04PGdT9lJ02S6FmAm427XB/
	V13Asuo6mPzj/esnM0c1W/kB9vc/Y=
X-Google-Smtp-Source: AGHT+IEgfLdkgnXffwooQeZ/JBqvZU8UTJed2XGZQ4yNpFdQRqlDg9IAkhMdjh5m/yhJsMIYDGe4jQ==
X-Received: by 2002:a17:903:1aa8:b0:29e:9387:f2b7 with SMTP id d9443c01a7336-29f23de5f93mr77422945ad.11.1765740076299;
        Sun, 14 Dec 2025 11:21:16 -0800 (PST)
Received: from localhost.localdomain ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a09afe20e5sm42502775ad.26.2025.12.14.11.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 11:21:15 -0800 (PST)
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
Subject: Syzbot test for v3: ocfs2: fix kernel BUG in ocfs2_write_block
Date: Mon, 15 Dec 2025 00:50:28 +0530
Message-ID: <20251214192047.34811-1-activprithvi@gmail.com>
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
index e544c704b583..40e5e95fd375 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -44,6 +44,9 @@ struct ocfs2_slot_info {
 static int __ocfs2_node_num_to_slot(struct ocfs2_slot_info *si,
 				    unsigned int node_num);
 
+static int ocfs2_validate_slot_map_block(struct super_block *sb,
+					  struct buffer_head *bh)
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

