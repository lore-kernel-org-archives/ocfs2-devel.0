Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BC922D781
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 04:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779683755; cv=none; b=LB2GWw2uf18EbEjUrunaKA8Q4jLFbx/OUoV5qZUiu8aLna4ZSSKWOAYAnENVcbkiGJi7c6+xh73qGa6uI53i29npvcYQ1Qk/gEMzxeW9wEbw73eiREu+DIZvfC6cS9iRZHSWC8+iiHuX23lWounV1nqR3e00zhSGcKEDyoIG3cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779683755; c=relaxed/simple;
	bh=gQsRo3iqzqlhOMl8TOCmYp8xkP7uaa89ggkFUFiA8VQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e7ttF8X6PC1L08GPLmQrm15YHmReTkDxxN9RcwsTkZq60KD2NNMnMr+pjJiGUJXXtujZS4f9ynCiwAqhzk1E/o1FZ3jn3wgkczixvevjNjmfbv7/du0rJpS9jIlccZ8oKuq7tGYQ8HBPV6/6+JyvCK/J/65BXPlMnFM6wCnqct8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eWR3Jq9a; arc=none smtp.client-ip=209.85.215.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eWR3Jq9a"
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-c802803ac17so3797143a12.1
        for <ocfs2-devel@lists.linux.dev>; Sun, 24 May 2026 21:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779683753; x=1780288553; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yz6cdVLfYLd/SoaE/veikxzZGD0OMEWp/JawDQCY8i4=;
        b=eWR3Jq9ajiP0dq0lb752qCZ59AnghSZw0pIqXq3H4nnUGAav3UsQZzUv7h1Oi21uqX
         GWu1QLbvnFsUEASmb8uvvKFir9mJc1hsoSf6NJefT1lopfILLFTFpIl7D9E4A+4o0rAr
         6pVw707Wn23FobLFWHMGfV9N+q4dLYC6DI8Mt4IKiOLigqME/HXqkDSz2UySr3bYXibp
         JC2kQu1tAeiWBr1CZB8gHBlXOdK7EskjvJL9hbvyy3Txjiuo7tqzOBLo68iOT7Jcsxlp
         1GCCQqfTX8G8IdLUxAirLmzbO4MBHxPWURQcAtgxvIFzcz0fxJXro3BKahXQX8nNjC1h
         quGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779683753; x=1780288553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yz6cdVLfYLd/SoaE/veikxzZGD0OMEWp/JawDQCY8i4=;
        b=d7lXKOgfTJPUxbvZFZJmk3zWUZHaJb7QmGoEc4ChRPloIplz4sK6HpcZt1crnZL1cn
         OVHLT64e1jLD8PuiE2vkTVHpnR5BUtqJSrbC70a14bQa8nj1f5jgjUaOZPtNM05qr+ys
         wS7h0tc2FZlFMr1QPToIWibQwbuY0uCpRNhuPcyXHzo4VaS9tfxeHq5goEw8/eIJ/rQh
         yEPvMbDJv3H/rF3OljHxQPbPm9wwcpYsqi/0AAmUmEtJXtNlinqfc1pXBrKcE7WpeaIT
         oo2YvCRYJuDSIzmn/U0rO6AA5OWykrWaaeLaNy5jrM59pZnr2tpa8PDp6qdcg+ON6DjB
         Bwdg==
X-Gm-Message-State: AOJu0YxwwXRveoZ6mdzRxbeIPvo7pXpB08FxUKCL968ni8jKVcUe9VTA
	h8l8B9g64UJU7GJHeDkz3wleIwyhbxmD+hUofGj1H9TIl9iA/NmRkq6O
X-Gm-Gg: Acq92OErd7vJM7k7oiNI2YDBNyn3eNQ+e1khzZYXwyZy+r3AMvH8pWkN70uR1HgXs0p
	Qd0ELRq5hIQNtdo6tGC52pUfeGgvNhxj4sfi4rJqXGVbbgyLSoWSPcveZ0rcqRl95YpNqDq3ver
	rr/16/3HRyw4mopSgW1OY6K1YqrwEtJ+GDaYees5ekV61OwoHHhmfZh4cpydeFUmk7sK0D8cQwe
	14iMHG/nFka9rkPzRXElnz6ihSg7OEoy0fJdEZhY6DIIeHbjZI+ro6k6crK2rVAFzQdr/+XtkZn
	S1vHmdhDWcsyy067AC7UhpagiQv1TwWRfmcVSODLDsO2KmzsCXwE3Am3G9Aw/lwLud78bHZ6gb8
	udrC8Ev4JfGRdytZzFuhps4Y9+1prsGVzRkGOAvJMEqY3hS7RCaDoE6tONYBTxm1a6e7r/guniP
	Xb7eA/RMLE1TE3nOJtthgkv3lwKzQ1EE8=
X-Received: by 2002:a05:6a21:328d:b0:39f:94cb:1bc with SMTP id adf61e73a8af0-3b328c7026fmr12459556637.1.1779683752880;
        Sun, 24 May 2026 21:35:52 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85202a789dsm6389453a12.9.2026.05.24.21.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 21:35:52 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH v2] ocfs2: reject oversized group bitmap descriptors
Date: Mon, 25 May 2026 12:35:47 +0800
Message-Id: <20260525043547.4160868-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_gd_parent() only bounds bg_bits against the parent
allocator's chain geometry. A malicious descriptor can still claim a
bg_size/bg_bits pair that exceeds the bitmap bytes that physically fit in
the group descriptor block, so later bitmap scans and bit updates can run
past bg_bitmap.

Use ocfs2_group_bitmap_size() for the allocator inode's bitmap layout and
reject descriptors whose bg_size or bg_bits exceed that capacity. Keep the
existing chain geometry check so both the on-disk bitmap layout and the
allocator metadata must agree before the descriptor is used.

Validation reproduced this kernel report:
KASAN use-after-free in _find_next_bit+0x7f/0xc0
Read of size 8
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xd0/0x630
  _find_next_bit+0x7f/0xc0
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x188/0x2f0
  kasan_report+0xe4/0x120
  ocfs2_find_max_contig_free_bits+0x35/0x70 (fs/ocfs2/suballoc.c:1375)
  ocfs2_block_group_set_bits+0x472/0x4b0 (fs/ocfs2/suballoc.c:1457)
  ocfs2_cluster_group_search+0x16b/0x440 (fs/ocfs2/suballoc.c:1624)
  ocfs2_bg_discontig_fix_result+0x1ef/0x230 (fs/ocfs2/suballoc.c:1786)
  ocfs2_search_chain+0x8f8/0x10a0 (fs/ocfs2/suballoc.c:1886)
  get_page_from_freelist+0x70e/0x2370
  lock_release+0xc6/0x290
  do_raw_spin_unlock+0x9a/0x100
  kasan_unpoison+0x27/0x60
  __bfs+0x147/0x240
  get_page_from_freelist+0x83d/0x2370
  ocfs2_claim_suballoc_bits+0x38c/0xe70 (fs/ocfs2/suballoc.c:2041)
  sched_domains_numa_masks_clear+0x70/0xd0
  check_irq_usage+0xe8/0xb70
  __ocfs2_claim_clusters+0x18d/0x4c0 (fs/ocfs2/suballoc.c:2497)
  check_path+0x24/0x50
  rcu_is_watching+0x20/0x50
  check_prev_add+0xfd/0xd00
  ocfs2_add_clusters_in_btree+0x17d/0x810 (fs/ocfs2/alloc.c:4793)
  __folio_batch_add_and_move+0x1f5/0x3d0
  ocfs2_add_inode_data+0xd9/0x120 (fs/ocfs2/file.c:537)
  filemap_add_folio+0x105/0x1f0
  ocfs2_write_begin_nolock+0x29f7/0x2f80 (fs/ocfs2/aops.c:1625)
  ocfs2_read_inode_block+0xb5/0x110 (fs/ocfs2/inode.c:1757)
  down_write+0xf5/0x180
  ocfs2_write_begin+0x180/0x240 (fs/ocfs2/aops.c:1861)
  __mark_inode_dirty+0x758/0x9a0
  inode_to_bdi+0x41/0x90
  balance_dirty_pages_ratelimited_flags+0xf8/0x1d0
  generic_perform_write+0x252/0x440
  mnt_put_write_access_file+0x16/0x70
  file_update_time_flags+0xe4/0x200
  ocfs2_file_write_iter+0x80a/0x1320 (fs/ocfs2/file.c:2372)
  lock_acquire+0x184/0x2f0
  ksys_write+0xd2/0x170
  apparmor_file_permission+0xf5/0x310
  read_zero+0x8d/0x140
  lock_is_held_type+0x8f/0x100

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
v2:
Use !ocfs2_is_cluster_bitmap() to choose the allocator bitmap layout, as
suggested by Joseph Qi.
Pass the allocator inode through the resize descriptor check so the helper
is used there too.

 fs/ocfs2/resize.c   |  2 +-
 fs/ocfs2/suballoc.c | 33 ++++++++++++++++++++++++++++-----
 fs/ocfs2/suballoc.h |  2 +-
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index 6375d5035972..2432c9670f30 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -388,7 +388,7 @@ static int ocfs2_check_new_group(struct inode *inode,
 		(struct ocfs2_group_desc *)group_bh->b_data;
 	u16 cl_bpc = le16_to_cpu(di->id2.i_chain.cl_bpc);
 
-	ret = ocfs2_check_group_descriptor(inode->i_sb, di, group_bh);
+	ret = ocfs2_check_group_descriptor(inode, di, group_bh);
 	if (ret)
 		goto out;
 
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index d284e0e37252..8b106bb4fe95 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -225,14 +225,22 @@ static int ocfs2_validate_gd_self(struct super_block *sb,
 	return 0;
 }
 
-static int ocfs2_validate_gd_parent(struct super_block *sb,
+static int ocfs2_validate_gd_parent(struct inode *inode,
 				    struct ocfs2_dinode *di,
 				    struct buffer_head *bh,
 				    int resize)
 {
+	struct super_block *sb = inode->i_sb;
 	unsigned int max_bits;
+	unsigned int max_bitmap_bits;
+	unsigned int max_bitmap_size;
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
+	max_bitmap_size = ocfs2_group_bitmap_size(sb,
+						  !ocfs2_is_cluster_bitmap(inode),
+						  OCFS2_SB(sb)->s_feature_incompat);
+	max_bitmap_bits = max_bitmap_size * 8;
+
 	if (di->i_blkno != gd->bg_parent_dinode) {
 		do_error("Group descriptor #%llu has bad parent pointer (%llu, expected %llu)\n",
 			 (unsigned long long)bh->b_blocknr,
@@ -240,6 +248,20 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
 			 (unsigned long long)le64_to_cpu(di->i_blkno));
 	}
 
+	if (le16_to_cpu(gd->bg_size) > max_bitmap_size) {
+		do_error("Group descriptor #%llu has bitmap size %u but physical max of %u\n",
+			 (unsigned long long)bh->b_blocknr,
+			 le16_to_cpu(gd->bg_size),
+			 max_bitmap_size);
+	}
+
+	if (le16_to_cpu(gd->bg_bits) > max_bitmap_bits) {
+		do_error("Group descriptor #%llu has bit count %u but physical max of %u\n",
+			 (unsigned long long)bh->b_blocknr,
+			 le16_to_cpu(gd->bg_bits),
+			 max_bitmap_bits);
+	}
+
 	max_bits = le16_to_cpu(di->id2.i_chain.cl_cpg) * le16_to_cpu(di->id2.i_chain.cl_bpc);
 	if (le16_to_cpu(gd->bg_bits) > max_bits) {
 		do_error("Group descriptor #%llu has bit count of %u\n",
@@ -266,11 +288,12 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
  * This version only prints errors.  It does not fail the filesystem, and
  * exists only for resize.
  */
-int ocfs2_check_group_descriptor(struct super_block *sb,
+int ocfs2_check_group_descriptor(struct inode *inode,
 				 struct ocfs2_dinode *di,
 				 struct buffer_head *bh)
 {
 	int rc;
+	struct super_block *sb = inode->i_sb;
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
 	BUG_ON(!buffer_uptodate(bh));
@@ -288,7 +311,7 @@ int ocfs2_check_group_descriptor(struct super_block *sb,
 	} else
 		rc = ocfs2_validate_gd_self(sb, bh, 1);
 	if (!rc)
-		rc = ocfs2_validate_gd_parent(sb, di, bh, 1);
+		rc = ocfs2_validate_gd_parent(inode, di, bh, 1);
 
 	return rc;
 }
@@ -372,7 +395,7 @@ static int ocfs2_read_hint_group_descriptor(struct inode *inode,
 			goto free_bh;
 	}
 
-	rc = ocfs2_validate_gd_parent(inode->i_sb, di, tmp, 0);
+	rc = ocfs2_validate_gd_parent(inode, di, tmp, 0);
 	if (rc)
 		goto free_bh;
 
@@ -399,7 +422,7 @@ int ocfs2_read_group_descriptor(struct inode *inode, struct ocfs2_dinode *di,
 	if (rc)
 		goto out;
 
-	rc = ocfs2_validate_gd_parent(inode->i_sb, di, tmp, 0);
+	rc = ocfs2_validate_gd_parent(inode, di, tmp, 0);
 	if (rc) {
 		brelse(tmp);
 		goto out;
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index bcf2ed4a8631..b6ce3c6aa4a2 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -188,7 +188,7 @@ u64 ocfs2_which_cluster_group(struct inode *inode, u32 cluster);
  * and then checking it with this function.  This is only resize, really.
  * Everyone else should be using ocfs2_read_group_descriptor().
  */
-int ocfs2_check_group_descriptor(struct super_block *sb,
+int ocfs2_check_group_descriptor(struct inode *inode,
 				 struct ocfs2_dinode *di,
 				 struct buffer_head *bh);
 /*
-- 
2.43.0

