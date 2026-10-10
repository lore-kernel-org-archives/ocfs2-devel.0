Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D283F6C59
	for <ocfs2-devel@lists.linux.dev>; Sat, 10 Oct 2026 11:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791632103; cv=none; b=kbkxUxPpMo5vFxPptzqEPrX8GvylVXxTDtqmti4tHFCjmJP/PKGgLS/PyV0pcgH6HhFhXPFf40do4IU5Jz8uP5S7Pp/+OUNB0/I5E97StxXwhEr1tnfGA6c8aPE7lzojsBUsfULqSvgRGtX/WB17bar4cnwdoK0kdNatxd9zbB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791632103; c=relaxed/simple;
	bh=B99KnPN/7xYgYntt8eZ7nJ7Q76CN7TBguueIFuAJTjc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U4/hpq+r2p8AmPaNCsh3oCSwXDDpj+J3c1XCiTJNoH7vyhLpVxKfMkuVnbIIvZTklwUwVYRXoQ0lOb9lPjOa+bT41Ya0lVobV7El0TDfLVDNwGFZ7rRreGFHCUzxQ/4Zw+b7cL3E3CccAq0+NBITBvQk47WwtGAI4tr0bl9sdOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BqNjecLN; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BqNjecLN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791632097; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=6r75Xmi6BGgtmpo/6izmWjnHot9i/l26y5JlgzSSZjk=;
	b=BqNjecLNgQQg+O+MjSoijl/fZV+EzCfbRmhRKmeq+JCpQM0g6FoSX79yNmADuxzYjD5L6BHxHH1Od01KAJsSN+61Qf/Sp/8PE4mWODvoMLF1MyeFubWvgO9BiPCh+5VZrmZyhIftocGaJwWzOOobTluc/ztllxK/BS5JEbfCjkU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XCW3a.m_1791632096;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCW3a.m_1791632096 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 10 Oct 2026 19:34:56 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ocfs2: reserve value tree metadata when moving an xattr into the inode
Date: Sat, 10 Oct 2026 19:34:53 +0800
Message-Id: <20261010113454.1420939-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261010113454.1420939-1-joseph.qi@linux.alibaba.com>
References: <20261010113454.1420939-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_calc_xattr_set_need() charges no metadata for the case where an
xattr living in an xattr block or bucket moves back into the inode:

        if (old_in_xb) {
                if (ocfs2_xattr_can_be_in_inode(inode, xi, xis)) {
                        clusters_add += new_clusters;
                        credits += ...;
                        if (!ocfs2_xattr_is_local(xe))
                                credits += ocfs2_calc_extend_credits(...);
                        goto out;
                }
        }

The credits for extending a value tree are there but the matching blocks
are not, so meta_add stays 0, ocfs2_init_xattr_set_ctxt() skips
ocfs2_reserve_new_metadata_blocks() and ctxt->meta_ac is left NULL.

This is the shape commit 0cdc7dde00ec ("ocfs2: fix missing metadata
reservation for large xattrs") fixed for the xattr block case, and it is
reached the same way: namevalue_size() charges a value larger than
OCFS2_XATTR_INLINE_SIZE as only OCFS2_XATTR_ROOT_SIZE, so
ocfs2_xattr_can_be_in_inode() accepts a new value that will be stored
outside.  ocfs2_xa_prepare_entry() installs a value root from def_xv and
grows it, and once the cluster allocator is fragmented enough to need a
second extent ocfs2_add_clusters_in_btree() finds the root full with no
meta_ac at all and answers RESTART_META.
ocfs2_xattr_extend_allocation() turns that into -ENOSPC, or into a
BUG_ON() without that commit, and ocfs2_xa_cleanup_value_truncate() takes
its !orig_clusters arm, dropping the entry and leaking the clusters
already handed out until fsck.ocfs2 reclaims them.

Reserve for the value tree here too.  The entry moves back into the
inode rather than into a new xattr block, so unlike the create side of
meta_guess this needs no block of its own.

Fixes: 78f30c314a74 ("ocfs2/xattr: Reserve meta/data at the beginning of ocfs2_xattr_set.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 801d3d311115..53ba52381112 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3480,6 +3480,14 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 				credits += ocfs2_calc_extend_credits(
 							inode->i_sb,
 							&def_xv.xv.xr_list);
+			/*
+			 * A value too big to stay inline is only charged as
+			 * OCFS2_XATTR_ROOT_SIZE above, so it can still need a
+			 * value tree of its own.  No xattr block is allocated
+			 * on this path, so the tree is all we reserve for.
+			 */
+			if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
+				meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
 			goto out;
 		}
 	}
-- 
2.39.3

