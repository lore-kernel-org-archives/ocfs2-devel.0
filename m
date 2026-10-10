Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C94649502A
	for <ocfs2-devel@lists.linux.dev>; Sat, 10 Oct 2026 11:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791632106; cv=none; b=WBJzY9GlV3TzaixLlblBhP63IgYYsIvK77Av+bEWC2TDso79wApi73jYKGwOhOmgUB/ndd2eaK0UKgn4tk30KvPdlaOv6pPfBkKU/TBrg14/q85M34i7AZD/6t6CFm9KyOut5I/qjOkRUMYhlbgib4R2cWh2L9mquFfEUMw9dt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791632106; c=relaxed/simple;
	bh=Cg5mCzt/hW79x+I0fsioFxlT+xGRUmBWzAoHYDvxHsA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h1LJ4foziLlcLjHNQAUSWbMyWjNe2IxiSCgFmM/TByBKKMHcjnK31c5DMH+FvZOgA8mv3mOrqgsVdL0c8v5v9EuXtAm9yAjicjhMS6Oqx7Bad7UkOQYbVFdIVWgKrU4uGRGmtjqEJ0fAPSzbI08D9CcRBmJy34qB2AvuqOxRKTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qk4hORj3; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qk4hORj3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791632095; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=sK4dtcbofZF3FuLwJx1LpRB27s1U3PUs5dDgjdQ5nMM=;
	b=qk4hORj3fkbVdiR8qkYnJgxfamy/ls2gpZK1ujmJukTDIdqdwsmyiAJFQxcmJCqZjPqK7lvkLBsJUbDaVZft5vu/E1r3bR7lRWCk9dNXHqK6X4HvBW8rDxxI/5Z/dxFwLHs69ubcAdYOcsTY7RKmu/G9HdgLfyk7MwWwYD6qc2M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XCW0FZ._1791632094;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCW0FZ._1791632094 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 10 Oct 2026 19:34:55 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ocfs2: fix metadata reservation for xattr value trees
Date: Sat, 10 Oct 2026 19:34:51 +0800
Message-Id: <20261010113454.1420939-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_calc_xattr_set_need() reserves too little metadata for a new xattr
value's extent tree on three paths.  The reservation cannot be topped up
once the transaction has started, so ocfs2_add_clusters_in_btree() gives
up with RESTART_META when the value root fills and nothing is left.
ocfs2_xattr_extend_allocation() turns that into -ENOSPC, after
ocfs2_xa_cleanup_value_truncate() has dropped the entry and leaked the
clusters already handed out; before commit 0cdc7dde00ec ("ocfs2: fix
missing metadata reservation for large xattrs") it was a BUG_ON()
instead.  It takes a fragmented cluster allocator to get there, since
the first extent always fits in the root.

Patch 1 fixes the create side of meta_guess: commit 3ed2be719eb9 ("ocfs2:
allow for more than one data extent when creating xattr") replaced the
block reserved for the new xattr block with the two the value tree needs
instead of adding them together.

Patch 2 fixes the arm that moves an xattr back into the inode, which
charges credits for a value tree but no metadata for one.

Patch 3 drops a second copy of the same reservation on the path that
falls through to meta_guess.  That one is cleanup rather than a fix and
is not for stable, and it must not be backported without patch 1: the
duplicate it removes is what currently covers the shortfall patch 1
fixes.

Based on linux-next-20261008.

Joseph Qi (3):
  ocfs2: reserve metadata for a new xattr block and its value tree
  ocfs2: reserve value tree metadata when moving an xattr into the inode
  ocfs2: reserve xattr value tree metadata only once

 fs/ocfs2/xattr.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

-- 
2.39.3

