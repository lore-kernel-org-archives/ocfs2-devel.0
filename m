Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DAD1A294
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 06:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775198319; cv=none; b=Y16RCxL9wWu3BQOl1EESMjWPmCwIOdEziuU5yAOpCtAeATuCiYCJWbI6Rpuy0TsVwUpbzH+96F3Hm/tCfva2szU11YeD+qMbqHgjBXXcpXyvOzpk6li/A8x0zOpusPaMOTtdfTH26G9n3CjN6AMJc8ytT1qeUua+vY9IwV6tJv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775198319; c=relaxed/simple;
	bh=7NJ6oPdGPCNR4R5/GVwFHaenmmpI1wijNmDntROcIVo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jmb6yxJ9aXDGfDW6lbHWYvKM//Zsghyd2rneDhSqhRevJCtj7NuEhMrcNAGoZvJ3JnfwayLadAtuH1yROmOMIVH+J3MwpoEAINSkndXpQYFjvHbhFtsyalPkpyZnTgW4N+xs73kmHMypYYtPu0p+rM4ItioE1I4xkOaxEahM2r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VoCl+MfU; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VoCl+MfU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775198311; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=3xxYMFlLxgYHb8T3vhoSfT7sWTgGvWULQaB67rGbH2w=;
	b=VoCl+MfUhJ1pBbGapnP1R4Bk+vJssoIXccYBq2GzI7h8P1+qoxLpg24IOa+87aNEACCtCJZISniBAbCWFjh1AaAv1ZIPCMx48AlMWrHO08RPKajMK/MSkOXOqSm4CbUPWhxcFyQcVAd2rV8TbbxQe/Y/a6KpyqBcyyH0gshylXg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X0JJmWZ_1775198310;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0JJmWZ_1775198310 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 14:38:31 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: fix out-of-bounds write in ocfs2_write_end_inline
Date: Fri,  3 Apr 2026 14:38:30 +0800
Message-Id: <20260403063830.3662739-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KASAN reports a use-after-free write of 4086 bytes in
ocfs2_write_end_inline, called from ocfs2_write_end_nolock during a
copy_file_range splice fallback on a corrupted ocfs2 filesystem mounted
on a loop device. The actual bug is an out-of-bounds write past the
inode block buffer, not a true use-after-free. The write overflows into
an adjacent freed page, which KASAN reports as UAF.

The root cause is that ocfs2_try_to_write_inline_data trusts the
on-disk id_count field to determine whether a write fits in inline
data. On a corrupted filesystem, id_count can exceed the physical
maximum inline data capacity, causing writes to overflow the inode
block buffer.

Call trace (crash path):

   vfs_copy_file_range (fs/read_write.c:1634)
     do_splice_direct
       splice_direct_to_actor
         iter_file_splice_write
           ocfs2_file_write_iter
             generic_perform_write
               ocfs2_write_end
                 ocfs2_write_end_nolock (fs/ocfs2/aops.c:1949)
                   ocfs2_write_end_inline (fs/ocfs2/aops.c:1915)
                     memcpy_from_folio     <-- KASAN: write OOB

So add id_count upper bound check in ocfs2_validate_inode_block() to
alongside the existing i_size check to fix it.

Reported-by: syzbot+62c1793956716ea8b28a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=62c1793956716ea8b28a
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 03a51662ea8e..a2ccd8011706 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1505,6 +1505,16 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 			goto bail;
 		}
 
+		if (le16_to_cpu(data->id_count) >
+		    ocfs2_max_inline_data_with_xattr(sb, di)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(data->id_count),
+					 ocfs2_max_inline_data_with_xattr(sb, di));
+			goto bail;
+		}
+
 		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
-- 
2.39.3

