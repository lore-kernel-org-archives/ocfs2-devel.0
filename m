Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31453D75
	for <ocfs2-devel@lists.linux.dev>; Thu, 14 Mar 2024 07:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710401643; cv=none; b=PqJGKXPoWJ0wju/Qlf5vSPfimte2YLM4fcL4aTgzXdZLyADlSMK6bTsAkAoYVkl07HS4h9pG/JebfbDWi6cWjMxy9l16mEPYK0kfrk2aK4EHp+v3FQWCsSVjM+YCqED5tV0nIlE9SsOyGRxqQ0BxQKDUsWCwfk0sO1aZpk5wOgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710401643; c=relaxed/simple;
	bh=WVahKm95UIi6kDu0P9mj8A+ZU9j6PAm/mBTQQB/n4/w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hz26mVo4zBgX+Cyf36T2HtzbTICidpi4ZCdfhtveYcYWTHpblWwhFs4p0P+sSV5GoJboPA+tqYOSDrGfyN/FtOlszWN7CyOdpo44PKo5vFuTuIXRMD5Z6oA++97F5bdRG43rY9BUSP/DSosMsARY+YsmNMGFZSzS3MFA9Mv8Ugs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HVu3s6RZ; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HVu3s6RZ"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d459a0462fso8501891fa.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 14 Mar 2024 00:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710401639; x=1711006439; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yq4wrfyXLVY1l1oC48FR8XY1DaA08xV1r6/I8pMeikk=;
        b=HVu3s6RZu63VhA23qRAmYrQXKr+zGd3NPmzb8wvjqk3wiWNwPPQv/ebDGNuRbeUj8N
         jplMnk/SL4Sju/j0Y1QJnLl91DyUnIvFZUAysH8dHuWxpBGGEVJQ/f2k8OYGvUNFP8Re
         FcRp4ExH629bQToiSZrJVBxLHq0E4G81IBggF+8Adtc6fOHOqNSwJ4EWDsGHJfVghjAC
         Q6o3oeYjoHapkeY2GGxWsT0vJqLfEZm13IBiKmRMfdb+bgReb9Q4it5WRri8pTWQryv8
         c7VTvloec3CnEtriS+SXudiY8EP/r3dQE/uhZPhp8ff/vkyFxkS0YJpzasGm04wLvnjz
         hW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710401639; x=1711006439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yq4wrfyXLVY1l1oC48FR8XY1DaA08xV1r6/I8pMeikk=;
        b=ZXgo3mEOoHJ22Uhx1AlhT3Sxm8UJ9pCh12CPGyb1bm7u0Hpnl6G6DGVd2FWXvpVDnw
         HviBQvd3fX1+duB0vAsVM7sD5klZc2rLAIQ4k11v1bXYd3toDYHwautwJZYjk0YtWqII
         pRkd/RnRDFpPBV6syJ/DeHT0u5qvfSMkvePPLKANXsprrt3TiHfvD89AuQKihR87kjDS
         SW6739novE+Sw53Evm7PJIm6dLsLFuXhtTXyyRaZSFryWLKHV2L0H55QBTY2BgtLllKo
         9zTkdQBpp3/k/r1O2Wwrou0uQ5afTpqc8jwWItSDk46hwwVIJurAT4CfWaohJb/5mFA1
         MPKg==
X-Forwarded-Encrypted: i=1; AJvYcCUIQJcFjDV5ronckuQnaldHjCjTDv8CCy7E4A/pM8DulhMRlZmDH+VqGrlCsM7E0dW0V47EHz9THShHFcTKEwWBwi+S0GLS1a49KVE=
X-Gm-Message-State: AOJu0YyIBy6de9qeQ8Ryw4tqmq9th6bMuOStluglzNFkHPp3APq3Q8ZU
	lijYd8RYfvKJnD48kbB4ZMdmU+LeB3oUtMAMApnEom9M+VsrnhualKJKvaeK4yY=
X-Google-Smtp-Source: AGHT+IHbPTzC++vYW1PNYT+XNUrR0XWaelQIGCursP7vShYf7Z57mwzqvfPjMbQKvsQuZVQF69THzw==
X-Received: by 2002:a2e:9c82:0:b0:2d3:a45c:4394 with SMTP id x2-20020a2e9c82000000b002d3a45c4394mr550430lji.31.1710401639045;
        Thu, 14 Mar 2024 00:33:59 -0700 (PDT)
Received: from c73.suse.cz ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id w19-20020a170902c79300b001dd0a41447fsm904132pla.233.2024.03.14.00.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 00:33:58 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: joseph.qi@linux.alibaba.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH] ocfs2: fix journal protection issues
Date: Thu, 14 Mar 2024 15:33:53 +0800
Message-Id: <20240314073353.11489-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch resolves 3 journal-related issues:
1. ocfs2_rollback_alloc_dinode_counts() forgets to provide journal
   protection for modifying dinode.
2. ocfs2_block_group_alloc() & ocfs2_group_add() forget to provide
   journal protection for writing fe->i_size.
3. adjusted journal_dirty scope for ocfs2_update_last_group_and_inode().
   This adjustment ensures that only content requiring protection is
   included in the journal.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/move_extents.c |  2 +-
 fs/ocfs2/resize.c       |  7 +++----
 fs/ocfs2/suballoc.c     | 25 +++++++++++++++++--------
 fs/ocfs2/suballoc.h     |  3 ++-
 4 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 1f9ed117e78b..a631f9cf0c05 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -687,7 +687,7 @@ static int ocfs2_move_extent(struct ocfs2_move_extents_context *context,
 	ret = ocfs2_block_group_set_bits(handle, gb_inode, gd, gd_bh,
 					 goal_bit, len);
 	if (ret) {
-		ocfs2_rollback_alloc_dinode_counts(gb_inode, gb_bh, len,
+		ocfs2_rollback_alloc_dinode_counts(handle, gb_inode, gb_bh, len,
 					       le16_to_cpu(gd->bg_chain));
 		mlog_errno(ret);
 	}
diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index d65d43c61857..2c7e3548ae82 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -143,15 +143,14 @@ static int ocfs2_update_last_group_and_inode(handle_t *handle,
 		le32_add_cpu(&cr->c_free, -1 * backups);
 		le32_add_cpu(&fe->id1.bitmap1.i_used, backups);
 	}
+	le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
+	ocfs2_journal_dirty(handle, bm_bh);
 
 	spin_lock(&OCFS2_I(bm_inode)->ip_lock);
 	OCFS2_I(bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
-	le64_add_cpu(&fe->i_size, (u64)new_clusters << osb->s_clustersize_bits);
 	spin_unlock(&OCFS2_I(bm_inode)->ip_lock);
 	i_size_write(bm_inode, le64_to_cpu(fe->i_size));
 
-	ocfs2_journal_dirty(handle, bm_bh);
-
 out_rollback:
 	if (ret < 0) {
 		ocfs2_calc_new_backup_super(bm_inode,
@@ -551,12 +550,12 @@ int ocfs2_group_add(struct inode *inode, struct ocfs2_new_group_input *input)
 	le32_add_cpu(&fe->id1.bitmap1.i_used,
 		     (input->clusters - input->frees) * cl_bpc);
 	le32_add_cpu(&fe->i_clusters, input->clusters);
+	le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
 
 	ocfs2_journal_dirty(handle, main_bm_bh);
 
 	spin_lock(&OCFS2_I(main_bm_inode)->ip_lock);
 	OCFS2_I(main_bm_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
-	le64_add_cpu(&fe->i_size, (u64)input->clusters << osb->s_clustersize_bits);
 	spin_unlock(&OCFS2_I(main_bm_inode)->ip_lock);
 	i_size_write(main_bm_inode, le64_to_cpu(fe->i_size));
 
diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 166c8918c825..e1168db659df 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -727,17 +727,16 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
 					le16_to_cpu(bg->bg_free_bits_count));
 	le32_add_cpu(&fe->id1.bitmap1.i_total, le16_to_cpu(bg->bg_bits));
 	le32_add_cpu(&fe->i_clusters, le16_to_cpu(cl->cl_cpg));
-
+	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
+					     le32_to_cpu(fe->i_clusters)));
 	ocfs2_journal_dirty(handle, bh);
+	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
 
 	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
 	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
-	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
-					     le32_to_cpu(fe->i_clusters)));
 	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
 	i_size_write(alloc_inode, le64_to_cpu(fe->i_size));
 	alloc_inode->i_blocks = ocfs2_inode_sector_count(alloc_inode);
-	ocfs2_update_inode_fsync_trans(handle, alloc_inode, 0);
 
 	status = 0;
 
@@ -1601,19 +1600,28 @@ int ocfs2_alloc_dinode_update_counts(struct inode *inode,
 	return ret;
 }
 
-void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
+void ocfs2_rollback_alloc_dinode_counts(handle_t *handle,
+				       struct inode *inode,
 				       struct buffer_head *di_bh,
 				       u32 num_bits,
 				       u16 chain)
 {
+	int ret;
 	u32 tmp_used;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *) di_bh->b_data;
 	struct ocfs2_chain_list *cl;
 
+	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
+				      OCFS2_JOURNAL_ACCESS_WRITE);
+	if (ret < 0) {
+		mlog_errno(ret);
+		return;
+	}
 	cl = (struct ocfs2_chain_list *)&di->id2.i_chain;
 	tmp_used = le32_to_cpu(di->id1.bitmap1.i_used);
 	di->id1.bitmap1.i_used = cpu_to_le32(tmp_used - num_bits);
 	le32_add_cpu(&cl->cl_recs[chain].c_free, num_bits);
+	ocfs2_journal_dirty(handle, di_bh);
 }
 
 static int ocfs2_bg_discontig_fix_by_rec(struct ocfs2_suballoc_result *res,
@@ -1717,7 +1725,8 @@ static int ocfs2_search_one_group(struct ocfs2_alloc_context *ac,
 	ret = ocfs2_block_group_set_bits(handle, alloc_inode, gd, group_bh,
 					 res->sr_bit_offset, res->sr_bits);
 	if (ret < 0) {
-		ocfs2_rollback_alloc_dinode_counts(alloc_inode, ac->ac_bh,
+		ocfs2_rollback_alloc_dinode_counts(handle,
+					       alloc_inode, ac->ac_bh,
 					       res->sr_bits,
 					       le16_to_cpu(gd->bg_chain));
 		mlog_errno(ret);
@@ -1851,7 +1860,7 @@ static int ocfs2_search_chain(struct ocfs2_alloc_context *ac,
 					    res->sr_bit_offset,
 					    res->sr_bits);
 	if (status < 0) {
-		ocfs2_rollback_alloc_dinode_counts(alloc_inode,
+		ocfs2_rollback_alloc_dinode_counts(handle, alloc_inode,
 					ac->ac_bh, res->sr_bits, chain);
 		mlog_errno(status);
 		goto bail;
@@ -2165,7 +2174,7 @@ int ocfs2_claim_new_inode_at_loc(handle_t *handle,
 					 res->sr_bit_offset,
 					 res->sr_bits);
 	if (ret < 0) {
-		ocfs2_rollback_alloc_dinode_counts(ac->ac_inode,
+		ocfs2_rollback_alloc_dinode_counts(handle, ac->ac_inode,
 					       ac->ac_bh, res->sr_bits, chain);
 		mlog_errno(ret);
 		goto out;
diff --git a/fs/ocfs2/suballoc.h b/fs/ocfs2/suballoc.h
index 9c74eace3adc..0c56ddce0752 100644
--- a/fs/ocfs2/suballoc.h
+++ b/fs/ocfs2/suballoc.h
@@ -75,7 +75,8 @@ int ocfs2_alloc_dinode_update_counts(struct inode *inode,
 			 struct buffer_head *di_bh,
 			 u32 num_bits,
 			 u16 chain);
-void ocfs2_rollback_alloc_dinode_counts(struct inode *inode,
+void ocfs2_rollback_alloc_dinode_counts(handle_t *handle,
+			 struct inode *inode,
 			 struct buffer_head *di_bh,
 			 u32 num_bits,
 			 u16 chain);
-- 
2.35.3

