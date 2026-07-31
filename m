Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7F93C10A8
	for <ocfs2-devel@lists.linux.dev>; Fri, 31 Jul 2026 11:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785497673; cv=none; b=q9HK30ubur9dfyjm7LQ5Oitvc8OWSarviYYXVfuLZ2oXdg3ZEvEyBQzWlTajkFuRShyc8IMpM/pP2D1M/R61ocYSeZoEFbQ0gfPqSHJ4F/PDFrdmP+SZ2FkJIotVUMHE0a330Bbu31Rq7Ve5TKcPVmsWgddPr4Da2LsoJ7yI478=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785497673; c=relaxed/simple;
	bh=T9Vrmo9ZdnzFQxa1S+qEsu5huV4mHPrOxAS0P4YmSv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fz9PBXs/RWSOLSzlB76Oe3pvq60lzXAo0tPG7PDnDt80K/OFkd46dl8zNH9hyFa9CfPwu0Ve79AzfHjbopPabTszcp0DaI0C73VYR9Tvu5PxwVzDNol9XSohZfYLI0avj54mnG5FHaT376Q4mWL/EepS8rOldaDAhiJawxzLE5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qahLWNIZ; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qahLWNIZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785497667; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ZjSeuilpW/p8j/c+yLfn/2EG7zTxbHLbM4d+SvDUTyQ=;
	b=qahLWNIZ/sFsqZkXf2ENCTHvHSY8Rag9hARzX9lxL50/RwWU5xJJ7eTYhga9dNuNPua76ulzdsUmJjbYh2B/Hzz7osdDfjNGyq3bTVC4O2Y5zgqAPhqGjFfK+1bv7YTZsRP8YKK2gTT9JqGInlxEi55NEOLGhQHQts/GdT4FE/k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X87tv.T_1785497665;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X87tv.T_1785497665 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 31 Jul 2026 19:34:26 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: fix circular locking dependency in reflink
Date: Fri, 31 Jul 2026 19:34:25 +0800
Message-Id: <20260731113425.4130293-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Lockdep reports a possible deadlock involving ip_alloc_sem,
j_trans_barrier, and ip_xattr_sem:

  Chain exists of:
    &oi->ip_alloc_sem --> &journal->j_trans_barrier --> &oi->ip_xattr_sem

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&oi->ip_xattr_sem);
                                lock(&journal->j_trans_barrier);
                                lock(&oi->ip_xattr_sem);
   lock(&oi->ip_alloc_sem);

  *** DEADLOCK ***

ocfs2_reflink() and ocfs2_try_remove_refcount_tree() acquire
ip_xattr_sem before ip_alloc_sem.  This is the reverse of the
established system-wide ordering where ip_alloc_sem is outer:

  - Write paths (e.g. ocfs2_write_begin_nolock) hold ip_alloc_sem
    and call ocfs2_start_trans(), which takes j_trans_barrier.

  - ocfs2_mknod() calls ocfs2_start_trans() (j_trans_barrier) then
    ocfs2_init_acl(), which takes ip_xattr_sem on the parent dir.

Fix by swapping the lock order in both functions to acquire
ip_alloc_sem before ip_xattr_sem, consistent with the rest of the
codebase.

Fixes: 09bf27a00020 ("ocfs2: Implement ocfs2_reflink.")
Fixes: 8b2c0dba5159 ("ocfs2: Call refcount tree remove process properly.")
Reported-by: syzbot+e42eae29bba35810f43c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e42eae29bba35810f43c
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/refcounttree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index d9f22b4a2654..c734ce295bf0 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -955,8 +955,8 @@ int ocfs2_try_remove_refcount_tree(struct inode *inode,
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
-	down_write(&oi->ip_xattr_sem);
 	down_write(&oi->ip_alloc_sem);
+	down_write(&oi->ip_xattr_sem);
 
 	if (oi->ip_clusters)
 		goto out;
@@ -972,8 +972,8 @@ int ocfs2_try_remove_refcount_tree(struct inode *inode,
 	if (ret)
 		mlog_errno(ret);
 out:
-	up_write(&oi->ip_alloc_sem);
 	up_write(&oi->ip_xattr_sem);
+	up_write(&oi->ip_alloc_sem);
 	return 0;
 }
 
@@ -4292,12 +4292,12 @@ static int ocfs2_reflink(struct dentry *old_dentry, struct inode *dir,
 		goto out;
 	}
 
-	down_write(&OCFS2_I(inode)->ip_xattr_sem);
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
+	down_write(&OCFS2_I(inode)->ip_xattr_sem);
 	error = __ocfs2_reflink(old_dentry, old_bh,
 				new_orphan_inode, preserve);
-	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ocfs2_inode_unlock(inode, 1);
 	ocfs2_rw_unlock(inode, 1);
-- 
2.39.3

