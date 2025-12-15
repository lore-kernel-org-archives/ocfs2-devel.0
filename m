Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D6330BF4B
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 17:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765818975; cv=none; b=uIIxm5HwfQf/IvX5GmQJ94pdpmTsJAwMnzX5D2nwwVSJKeG1RO+Wk/ES+lPIHHijU4V+z//mRCMsvZ7DC3sPTLOUn9gvujqRpfUxc/6RXZ9vIiE0a0MNlry3ouwLidtYGXpy4cgerk8Zn8yY9EYBYX8PD/KhwA8o7NFKjllP3qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765818975; c=relaxed/simple;
	bh=4E1RLh20vUnXpJM8xXQePiEKbAsimlazzE0n0ov0zLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0eX4vVMRszicGQ/CJ0HwxLk1/0LTRN5WCiBQV6FjX58Fk0R2O7C7ldO6ne6F+AiufUQjPJ5YI9RaR64wYWDe11SPgnEk8aIOm2aZyMm3dKAr6tRM11K3Ddc44pAaIyGDD8cPM0ZGsYQYvhtwIjCQQp+yeAFJff9ouPEatOKhtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wjuy4Ctl; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wjuy4Ctl"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so3031848b3a.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 09:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765818973; x=1766423773; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sB0WrPgrivBwldjuemVg8CdaZRg8zxWb4J+FefiXafc=;
        b=Wjuy4CtlKsM88hfaR7ZmHlSn0gS8/DW2+nL8p7vrdA5MBh1s/jgabi/AF6Jx1sAikk
         GZavI4ueD9IIqbGSZ8qEXkeCS4z/I8fnOjy00/z7ZwsnS/V+9G/PrtQI42uvTswqPShl
         6Tc2gojzxeBkIxLmGjVdTUSoLY7MZ5lz12H5P8xv6mAAsJVhJtEs/fBHjHC01cqd/r0b
         +e+mKGKILlt2gCvGvMdVvq7Og+5drXL7IzoAvBUfN1r34E1FikzEpiJy/9QIr4+JgeTL
         uT9TC5PosEyoe6qhaMiFDDZamYYr+mtumZ0TlpK0GuA42E9Lgl/hzlq9hE9dlvmfx3Z9
         lyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765818973; x=1766423773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sB0WrPgrivBwldjuemVg8CdaZRg8zxWb4J+FefiXafc=;
        b=sUYIH7hLNYTKwIpROom2eTDHDMNb+os/GsJc+vz2eg9Y6NgRNc9LvhD5yZF4j0/1Qe
         VurbbFv9WxJyEdciercXS5n17XA6RYJTYJafAOmzbbqA8cMi5g61YCvYTiiwX18fwzWy
         +hiBRfnpHUVYqTAzkbTS5EKYULFlT/iIPuspxsMHfo1lMS59JG4fQjC0yYE5CrBmzzu2
         gLa0djvmFsTDhBmrwkvDkJIbcLzyVLvD/S9ia4/fBbprDskrMcgihXpb14CIVSWZP2K5
         MZRqWoQNLOiNXAXX/HrYZEu/fIqnycxFwWxO3Jmshn7cPThIkQ3sOyuKjAKyysDEvayk
         +l3A==
X-Forwarded-Encrypted: i=1; AJvYcCXF2TMSjcrS456mAfSyxoCadHqh2GKsl/g1rq+hHdn6fVAZ4P90hostdsh+hEA7Ja8IkdnlP4C1WNEz6A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwbjyosGnBtCuqpSCzGPfHxZ6YoGtn+fX87Kz2ChPztQI7azpl1
	xKyh+TIpimiwjGU2zGgcs6ynSqxOBoGhvUiuJL8SHf0uKllY63VptfEW
X-Gm-Gg: AY/fxX7BtCfvjyrQkTnB1Jjq2OijySRCUfXt9/sutvA50EdLekyBsIdjuhY2LavLT1n
	Mu7ed4poHtC7cF46A7n2OfaLtErrFfrqXCe1/KjHWDuWrqldWhfweB2Nbl+KWbKLWUnSY6g94K0
	1Nep4kF7YLGDetxbN+zxWfIjs4DP57iifVrXYmHlb4XsBzs+rKIfIoVqrjbFh2RnP0HQfBRZEMQ
	yy1OhFSZe5P4FUThlOnx/HtpAK+ZPKeutPoe19oe6DG6Q4hMmPQkHT11qGJxErwBOdMMlSsb7oW
	RcdXDmWT68iMezpeMLfURQrXkjPAfP2DzFVTpNKqxs42n9/nU/W+3AzpaEkcbtJFdZ6Kmfwt4jV
	/W5O7wXgLYaSapa16YdEF21XqgypOEaVxxjw6U8fUThyOzoSw8E90HCNcYyMhl4HXCMbmcfypo0
	r8DuFkL2S0k3vKvWOf/ZZZJmS3FF1YaAeNpZcmYw==
X-Google-Smtp-Source: AGHT+IFi4/nBpsgKyClPoMclL32PLa/6jSk6itMt7sBO8Mz9wvl5fhO6q4G9z5INtIqkWuXVbUj02g==
X-Received: by 2002:a05:6a00:6c94:b0:7ae:8821:96dd with SMTP id d2e1a72fcca58-7f667b26d0cmr11687671b3a.24.1765818973019;
        Mon, 15 Dec 2025 09:16:13 -0800 (PST)
Received: from localhost.localdomain ([111.125.240.40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c237ee5fsm13150053b3a.4.2025.12.15.09.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 09:16:12 -0800 (PST)
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
Subject: Syzbot test for v4: ocfs2: Add validate function for slot map blocks
Date: Mon, 15 Dec 2025 22:46:01 +0530
Message-ID: <20251215171602.20574-1-activprithvi@gmail.com>
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

