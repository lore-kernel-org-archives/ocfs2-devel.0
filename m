Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AF731AABF
	for <ocfs2-devel@lists.linux.dev>; Sat,  5 Sep 2026 14:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788618111; cv=none; b=m0nrQZVcsKa+7shHMhPjyaL378xJ8zhW27lqwXBknYsk54HuSnPicVZ/pkf0vS7WC/RHRFHfjnRZtqj4w8L0oRr+ChWX1x8tBH4tUudXbgldLTRu7jcrbdnKM9YMpDHB5JOeiZIOz5G0w91Os/4o8N1a7dTnsncgnYELKA11JHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788618111; c=relaxed/simple;
	bh=vIgELx8V9EpM6q6bW9oawocsbxvPE7RliyLEqUZHGo0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ob33DSR++N/ClrFSDgMJL/GAQB1uDkvdF8yJvoYxUCxiO+kFyxEmhewYLw08J/YrbG1CR/e9hDxdu7ochna0wn11WRmbT/Stqkh+q96tSMWfXGg9c/I3A473pf412GN+ls39ywEi3x+zwi0Xi9nc/HK0pWK/euOmFkIACEdh0ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gxT6ATp+; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gxT6ATp+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788618105; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=YdA9xKGt2dpmfNzslVVJbFYy7MgLlY6OWFrGvaFNhF8=;
	b=gxT6ATp+A7rtxa+tLsoGmlUyjHbtkpqyh3fhps9bxmac8sh3sp71EWQ++iUeRAWDqwYHyxKbbRtVHel5BNqh3qmnh2peUrcpH9O0Ja+gCKNGf/ZeYVCU2m7XEADIimpYxKJ5IRyAqjk++ASNqiaQnI1QgnDu/TDl/2PuWJoE+eE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XALEF09_1788618104;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XALEF09_1788618104 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 05 Sep 2026 22:21:44 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ocfs2: validate dr_fs_generation of dir index root blocks
Date: Sat,  5 Sep 2026 22:21:43 +0800
Message-Id: <20260905142144.2869105-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_dx_root() does not verify dr_fs_generation against the
superblock generation, unlike the extent and xattr block validators
which check h_fs_generation and xb_fs_generation respectively.  The
field is documented as "Must match super block".

Without the check, a stale dir index root block left on the device from
a previously formatted filesystem at the same physical block number can
pass validation as long as its signature, dr_blkno and checksum match.
Its index entries and suballocator information would then be used in
the new filesystem context.

Reject dir index root blocks whose dr_fs_generation does not match the
mounted filesystem, like the extent and xattr block validators do.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 6bb6aa133f01..329680b46227 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -613,6 +613,14 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 		goto bail;
 	}
 
+	if (le32_to_cpu(dx_root->dr_fs_generation) != OCFS2_SB(sb)->fs_generation) {
+		ret = ocfs2_error(sb,
+				  "Dir Index Root # %llu has an invalid dr_fs_generation of #%u\n",
+				  (unsigned long long)bh->b_blocknr,
+				  le32_to_cpu(dx_root->dr_fs_generation));
+		goto bail;
+	}
+
 	/*
 	 * Dir index root blocks are allocated from a per-slot suballocator,
 	 * so the slot must be in range.  Otherwise removing the index passes
-- 
2.39.3

