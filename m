Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA0933B966
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Mar 2026 03:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772767346; cv=none; b=MkQ/e0Gr682C2xIHzMjLUmTx28MRRS1OhlEN9MbCD/xIGE/fCqhEMNqfTeUzCDoT2r7uCHX3gLc1N8jM2Kd3TpJFtP7ZAS9GqwT/qI4vHgs6xqdXe7Hq04dNkp32AEgffU/Oxw5lI/oC8TGUsiq0Bo/NuSwYyAzL4IPYvsHUaNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772767346; c=relaxed/simple;
	bh=A+xDJUL1TWrLhIxmHd74oCxuKNuYPBgKMoNkbWXqAY0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iQVA99xa7gC7L6uDxRN3GJ7UUUoXhKjOgkIsBbRRl4ga35jSYdIiM3/hR6I1sKWb1JWohoFJ82d676jI7TfxDwAPVLPVxIfiLqUwRB/nMJZ4/as+Yys6H8c9clNh7Hh0O+5NKnVD30fgCpDTBtoZ1LcdFKrBWbFEcwYfqxmo7rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rFXH0xvO; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rFXH0xvO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772767332; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=PfUkX1w3jrc5o7Mzm6+YwolLT5yQ2ddvBx4W2MxfGUs=;
	b=rFXH0xvO3Tn5uKbRI5udPkRp2NAlqI0GY7fNrRkFJ5wHIjvpmfWw0ye3zIR4vobQ+jWeRQKiFFG1l48yKr2/a/JL23AXKkGKl7TfMEnQihO7uTjAvEVel6FUJ39a/tGH6UJKmz7X1Y2oc3W8GueRLGKmYTHqzyfL7TGPiJGF0pQ=
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X-LqXC1_1772767331 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Mar 2026 11:22:12 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: fix possible deadlock between unlink and dio_end_io_write
Date: Fri,  6 Mar 2026 11:22:11 +0800
Message-Id: <20260306032211.1016452-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_unlink takes orphan dir inode_lock first and then ip_alloc_sem,
while in ocfs2_dio_end_io_write, it acquires these locks in reverse
order. This creates an ABBA lock ordering violation on lock classes
ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE] and
ocfs2_file_ip_alloc_sem_key.

Lock Chain #0 (orphan dir inode_lock -> ip_alloc_sem):
ocfs2_unlink
  ocfs2_prepare_orphan_dir
    ocfs2_lookup_lock_orphan_dir
      inode_lock(orphan_dir_inode) <- lock A
    __ocfs2_prepare_orphan_dir
      ocfs2_prepare_dir_for_insert
        ocfs2_extend_dir
	  ocfs2_expand_inline_dir
	    down_write(&oi->ip_alloc_sem) <- Lock B

Lock Chain #1 (ip_alloc_sem -> orphan dir inode_lock):
ocfs2_dio_end_io_write
  down_write(&oi->ip_alloc_sem) <- Lock B
  ocfs2_del_inode_from_orphan()
    inode_lock(orphan_dir_inode) <- Lock A

Deadlock Scenario:
  CPU0 (unlink)                     CPU1 (dio_end_io_write)
  ------                            ------
  inode_lock(orphan_dir_inode)
                                    down_write(ip_alloc_sem)
  down_write(ip_alloc_sem)
                                    inode_lock(orphan_dir_inode)

Since ip_alloc_sem is to protect allocation changes, which is unrelated
with operations in ocfs2_del_inode_from_orphan. So move
ocfs2_del_inode_from_orphan out of ip_alloc_sem to fix the deadlock.

Reported-by: syzbot+67b90111784a3eac8c04@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=67b90111784a3eac8c04
Fixes: a86a72a4a4e0 ("ocfs2: take ip_alloc_sem in ocfs2_dio_get_block & ocfs2_dio_end_io_write")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/aops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 17ba79f443ee..09146b43d1f0 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2294,8 +2294,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 		goto out;
 	}
 
-	down_write(&oi->ip_alloc_sem);
-
 	/* Delete orphan before acquire i_rwsem. */
 	if (dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
@@ -2308,6 +2306,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 			mlog_errno(ret);
 	}
 
+	down_write(&oi->ip_alloc_sem);
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
-- 
2.39.3

