Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA24340407
	for <ocfs2-devel@lists.linux.dev>; Sat,  5 Sep 2026 14:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788618113; cv=none; b=W7yF1UehJWgrKNB5d90BalMkEnve3drxNL95bua/51zzU2aNS7wwXHyOcG95SaRZ96Og8JfVUxopjLiTx5oh3xP/6vmi2mW4266Mu0u4HFxNBd+LDabzMgqYiGbIim4WCh5MBF1j4SI+SCkvzRsKh2ckwWP90k/CQ1az+DgRtwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788618113; c=relaxed/simple;
	bh=SIlCr51/auC7Sp8chzQ0ArUdM+AuimYybi45skKoIe4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TvFHpLBbBiLJ2HKMfQZDXt+gkIdzY74qAWvPdxYTSEFdT590GNiFmdZUvqORBeDNwZLgXXJbQA2QqX2643DVHEURr1OaLnrZvFFJypneAA6Wy7lAscJa7BVAu+zj5TDWJ+oMqPYJp2g5LvSJqEogmQE0kWy8NITExitOljbXWbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=UTZcBDm3; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="UTZcBDm3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788618107; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=TVwhRNvy/HV9VkVJ4nd304E0UptVn3L60FUa76POIT4=;
	b=UTZcBDm39XZmGznOjxQr+KU6JmRPimsjKAU8oMeDBjEoSMznvYRtvkYApqFsqxaDw+9zk66H/jjz9DOUNEHKpqPgMZsr4dyg9h3MtdP6n0qU7J6UmQKyD2plTEAme48Qnrfm5qUuiDCfw4Rz/HLmwHRKViBSwFg30fi+Ph5iKx0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XALEF0N_1788618105;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XALEF0N_1788618105 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 05 Sep 2026 22:21:45 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ocfs2: validate dl_blkno and dl_fs_generation of dir index leaf blocks
Date: Sat,  5 Sep 2026 22:21:44 +0800
Message-Id: <20260905142144.2869105-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260905142144.2869105-1-joseph.qi@linux.alibaba.com>
References: <20260905142144.2869105-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_dx_leaf() checks the checksum, the signature and the
entry list counts, but it never checks dl_blkno or dl_fs_generation.
The inode, extent block, xattr block, refcount block and dir index root
validators all check the on-disk block number against bh->b_blocknr and
the generation against the superblock, and both dir index leaf fields
are documented as "Must match super block".

Without the checks, a stale dir index leaf block left on the device from
a previously formatted filesystem at the same physical block number can
pass validation as long as its signature, entry counts and checksum
match.  Its index entries would then be used in the new filesystem
context.

Both fields are written unconditionally when a leaf block is formatted
in ocfs2_dx_dir_format_cluster(), from the live superblock generation
and the real block number, so a correctly formatted filesystem cannot
trip the new checks.  The leaf block number read back here comes from
on-disk dir index root extent records.

Reject dir index leaf blocks whose dl_blkno or dl_fs_generation does not
match, like the dir index root validator does.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dir.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 329680b46227..55c4a305a282 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -733,6 +733,18 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
 		return ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
 				   7, dx_leaf->dl_signature);
 
+	if (le64_to_cpu(dx_leaf->dl_blkno) != bh->b_blocknr)
+		return ocfs2_error(sb,
+				   "Dir Index Leaf # %llu has an invalid dl_blkno of %llu\n",
+				   (unsigned long long)bh->b_blocknr,
+				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno));
+
+	if (le32_to_cpu(dx_leaf->dl_fs_generation) != OCFS2_SB(sb)->fs_generation)
+		return ocfs2_error(sb,
+				   "Dir Index Leaf # %llu has an invalid dl_fs_generation of #%u\n",
+				   (unsigned long long)bh->b_blocknr,
+				   le32_to_cpu(dx_leaf->dl_fs_generation));
+
 	if (le16_to_cpu(dx_leaf->dl_list.de_count) !=
 	    ocfs2_dx_entries_per_leaf(sb))
 		return ocfs2_error(sb,
-- 
2.39.3

