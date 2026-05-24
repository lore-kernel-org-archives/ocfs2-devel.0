Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48A42DF142
	for <ocfs2-devel@lists.linux.dev>; Sun, 24 May 2026 11:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779621176; cv=none; b=JHhd4E9caDsyjIv1QkmwQyIBOnQz0DTAsxsuI7jr1vp0BRNva/xg9ZrIW7Ji6X8XJP9vkbGeMNlfwr/qlL9/+dz8obIf3tPhaHQ8BpaHi/nbnSWpF9KsyVm4yank8ncTxH9zQQw3IMWqQrn1j/8mlYFtpz8B87O9hgmklD/mY/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779621176; c=relaxed/simple;
	bh=4tvDwghhruJnwW+KIFndh8/AMEcv5bqMEBFh746RF7A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KMMn/VhiICSr6tmxPVso6ls8k0+vt2ph54VLOKnXItN/VhrxuQULqg7N1fQRc9R/FTHv6FwcwPeM1FE4pwBIjhtM4EcaitsGVWfdZbLH58uwg1l0F2AvwOwm9/B39qLWVtsXic2iGpd0UTTeGlUI7orxfeo9LuglB2nmUA0z1FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ovWcLeTw; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ovWcLeTw"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2baca4df358so54160005ad.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 24 May 2026 04:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779621174; x=1780225974; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4eRCxHTPnuxCw9MHGgN9K9wcCi9yFosS3jwwOOptvNA=;
        b=ovWcLeTwPTR8tuhm7m5ljWqfn3Tmr7b/UdkYEmCZDQ9MtbRHAMx/P6mLZDMx8uirI6
         /XzeRxLxo75tTO5zKMGrf79h1b3rlSF922PXuqm5zQwvXTjEWMQFaOGZ5S6R9aYa0OC/
         ORY1lZFSKbQtv/8XdTk7t6s5h9k7t7M2UPHdhKsz9T/Tx8dJqAXSAIESD/3098cR82Gq
         80DA+wyNOY0Jfz/4VziBGjjSOS9rX1euqboQiiwK0nUh81pAdHO7rKbNK2KSKkwdpcxl
         +Y+SJbLIpLCzc+AC4SYLn7Re8UyD6/TozNhVRQjY4oW+O8x0lgEgChMqxjuRGe4Os5h/
         inyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779621174; x=1780225974;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4eRCxHTPnuxCw9MHGgN9K9wcCi9yFosS3jwwOOptvNA=;
        b=BX+dkQlju6kUJE5jqGcxhMUGWBSvhReQdZ0XvOk5vdOtf8e2fiwWu8g19nL2FNovOp
         Htk/SEYRSvJNURIDterzeWeCxeKE3J5Hz/aEa5VskZzLCsFDo1uIr4mUI/yobboQVMYR
         UJwXaAcy9mXlYQMMwKOWNmj3V23pQ7IU2HtDKI0nqPAcJUycrbwbX+ntTyWjFNNXm6fU
         J1NWKgI2LSV1hlBVKp0rvqikf07goR3VkdCYjOqlpVJtyNKmZZBLtcmwWhlAMVb1r6Xo
         T+5dmWeuOM4hnzBE0Dozg0XFlIwWqlPin0wQFPgAerHAqty+DQ++PcT/3OMYl166f+SG
         dyRQ==
X-Gm-Message-State: AOJu0YwfnpoVJXkROu7UFL3dJUWn3bG8RUXJkn6N2p4C9xygNUM1iekt
	RDxBbGndwaytUWaOjKKwyQPXXfn495PQ86F7uxGPpp+SNDk5/w1sa3Pb
X-Gm-Gg: Acq92OEHR7q/69xnMP0YYmidadEVId3PbW9T1DA3R1tBkM0tNRSNcq03XDyrdcKkQ9a
	1L/eVTxwn82aHda63rNiFe6h/LUIOQ8ag6l1q3JY8iEGYE/W/90R9+gOB43Yg7MJthqwyLNCuhq
	yHz6M3nF2DuUpxxdvrzeasLxnNuOMLODGCHGohtUrUN6HZihQ97jRlnmB75iR8UYE8UfetSnVY5
	tyqMWSCFgGuS4xEfohfSQhe87N51BFWgZD8FQLayc4qgCmDvmpW+w1+tCGPT6CQQW+pS7Tq0lQs
	3zd1iLUZ02atDfsiTIvCw3ffg/bCcwEM1SWaNJZsJ7+Ybkz5+PVT8No9zt/nAKqG9fxFjQCpqv2
	el8epZrnJcuItOy8dR6V6CxahNDAEOmQbMD9RwtPn3caP2DllDaTJ8+kzU36cU+JEwOdvsGAPc/
	UsHxR9y6cDiWjHmaq9XDKMveKhuz1PUd8=
X-Received: by 2002:a17:903:3c6b:b0:2ae:450c:951e with SMTP id d9443c01a7336-2beb070376fmr115585275ad.17.1779621174121;
        Sun, 24 May 2026 04:12:54 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58b387dsm67366115ad.50.2026.05.24.04.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 04:12:53 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] ocfs2: reject oversized group bitmap descriptors
Date: Sun, 24 May 2026 19:12:48 +0800
Message-Id: <20260524111248.1429884-1-rollkingzzc@gmail.com>
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

Add a physical-cap check based on ocfs2_group_bitmap_size() for the
parent allocator type and reject descriptors whose bg_size or bg_bits
exceed that capacity. Keep the existing chain geometry check so both the
on-disk bitmap layout and the allocator metadata must agree before the
descriptor is used.

Validation reproduced this kernel report:
KASAN use-after-free in _find_next_bit+0x7f/0xc0
Read of size 8
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xd0/0x630 (?:?)
  _find_next_bit+0x7f/0xc0 (?:?)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x188/0x2f0 (?:?)
  kasan_report+0xe4/0x120 (?:?)
  ocfs2_find_max_contig_free_bits+0x35/0x70 (fs/ocfs2/suballoc.c:1375)
  ocfs2_block_group_set_bits+0x472/0x4b0 (fs/ocfs2/suballoc.c:1457)
  ocfs2_cluster_group_search+0x16b/0x440 (fs/ocfs2/suballoc.c:86)
  ocfs2_bg_discontig_fix_result+0x1ef/0x230 (fs/ocfs2/suballoc.c:1786)
  ocfs2_search_chain+0x8f8/0x10a0 (fs/ocfs2/suballoc.c:1886)
  get_page_from_freelist+0x70e/0x2370 (?:?)
  lock_release+0xc6/0x290 (?:?)
  do_raw_spin_unlock+0x9a/0x100 (?:?)
  kasan_unpoison+0x27/0x60 (?:?)
  __bfs+0x147/0x240 (?:?)
  get_page_from_freelist+0x83d/0x2370 (?:?)
  ocfs2_claim_suballoc_bits+0x38c/0xe70 (fs/ocfs2/suballoc.c:96)
  sched_domains_numa_masks_clear+0x70/0xd0 (?:?)
  check_irq_usage+0xe8/0xb70 (?:?)
  __ocfs2_claim_clusters+0x18d/0x4c0 (fs/ocfs2/suballoc.c:2497)
  check_path+0x24/0x50 (?:?)
  rcu_is_watching+0x20/0x50 (?:?)
  check_prev_add+0xfd/0xd00 (?:?)
  ocfs2_add_clusters_in_btree+0x17d/0x810 (fs/ocfs2/suballoc.c:?)
  __folio_batch_add_and_move+0x1f5/0x3d0 (?:?)
  ocfs2_add_inode_data+0xd9/0x120 (fs/ocfs2/suballoc.c:?)
  filemap_add_folio+0x105/0x1f0 (?:?)
  ocfs2_write_begin_nolock+0x29f7/0x2f80 (fs/ocfs2/suballoc.c:3043)
  ocfs2_read_inode_block+0xb5/0x110 (fs/ocfs2/suballoc.c:?)
  down_write+0xf5/0x180 (?:?)
  ocfs2_write_begin+0x180/0x240 (fs/ocfs2/suballoc.c:?)
  __mark_inode_dirty+0x758/0x9a0 (?:?)
  inode_to_bdi+0x41/0x90 (?:?)
  balance_dirty_pages_ratelimited_flags+0xf8/0x1d0 (?:?)
  generic_perform_write+0x252/0x440 (?:?)
  mnt_put_write_access_file+0x16/0x70 (?:?)
  file_update_time_flags+0xe4/0x200 (?:?)
  ocfs2_file_write_iter+0x80a/0x1320 (fs/ocfs2/suballoc.c:?)
  lock_acquire+0x184/0x2f0 (?:?)
  ksys_write+0xd2/0x170 (?:?)
  apparmor_file_permission+0xf5/0x310 (?:?)
  read_zero+0x8d/0x140 (?:?)
  lock_is_held_type+0x8f/0x100 (?:?)

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
---
 fs/ocfs2/suballoc.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index d284e0e37252..a4a2b87a45fe 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -231,8 +231,16 @@ static int ocfs2_validate_gd_parent(struct super_block *sb,
 				    int resize)
 {
 	unsigned int max_bits;
+	unsigned int max_bitmap_bits;
+	unsigned int max_bitmap_size;
+	int suballocator;
 	struct ocfs2_group_desc *gd = (struct ocfs2_group_desc *)bh->b_data;
 
+	suballocator = le64_to_cpu(di->i_blkno) != OCFS2_SB(sb)->bitmap_blkno;
+	max_bitmap_size = ocfs2_group_bitmap_size(sb, suballocator,
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
-- 
2.43.0

