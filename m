Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A76E1BD9D0
	for <ocfs2-devel@lists.linux.dev>; Sun, 31 May 2026 13:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780233413; cv=none; b=Mijxt6b1nq1GoolvG6BWvjS6qZL6Lb4D83JxdCoXGUC98bJq7ONLi5VMpAm8dYSi4QuA2V/bHmIk+tEwKtaLo8+OcPbNKryZtvBaHvlaofbF7gcI3T2IF9kaWjdcNfkS69xyOaEvpxhdN5I0bjDHC/Znyes9dITOehvNrXX7TIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780233413; c=relaxed/simple;
	bh=hHkUWnykRMnYqkkFtMRvUXNAtq/xVuTphwBeiPpcjrk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lR7OrTIZzsRLSQhZwVU7Aaci6B4K0byNczqROLmw0appJO1id/ZAOLJ+llIo+NlgIuY2qyLgfUaTWsE0LoD4r8Wvw72j5M7zKcuQLM2bflpFWaMrtKyNDm9KeBcNm+ejB+qiY+4vlWTwo/irvlkIubwgbUUypDO+y9VaZobq29s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=J5vuH/Ix; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="J5vuH/Ix"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780233406; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=uClhD2qkjhCHrTWlrk62ItmQxyKP3gzB67snBT42Rp4=;
	b=J5vuH/Ix1MtJ5EV4Tq+A6LjZDIjTuSdEE8HZ0e+xr7e3TTUSGRj10fzDo+icQzexo1ZEVFOwJUgN6/u0J5UpVnCmO3IWmpGLiTK9cvecpKvzroSbNI9iXEm406wgTp4NnE32MhoMt5LGmYCMhjdyPb0rAmMLWbcJQVd1Au/XyJw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X3tm8Ar_1780233405;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3tm8Ar_1780233405 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 31 May 2026 21:16:46 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
Date: Sun, 31 May 2026 21:16:45 +0800
Message-Id: <20260531131645.3650299-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During unmount, ocfs2_journal_shutdown() frees the journal and sets
osb->journal to NULL. Later, when VFS evicts remaining cached inodes,
ocfs2_evict_inode() -> ocfs2_clear_inode() -> ocfs2_checkpoint_inode()
-> ocfs2_ci_fully_checkpointed() dereferences osb->journal, causing a
NULL pointer dereference.

Fix this by adding a NULL check for osb->journal in
ocfs2_checkpoint_inode(). If the journal is NULL, it has already been
fully flushed and destroyed during shutdown, so there is nothing to
checkpoint.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Farhad Alemi <farhad.alemi@berkeley.edu>
---
 fs/ocfs2/journal.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 6397170f302f..f8b3b2a3d630 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -196,6 +196,9 @@ static inline void ocfs2_checkpoint_inode(struct inode *inode)
 	if (ocfs2_mount_local(osb))
 		return;
 
+	if (!osb->journal)
+		return;
+
 	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
 		/* WARNING: This only kicks off a single
 		 * checkpoint. If someone races you and adds more
-- 
2.39.3

