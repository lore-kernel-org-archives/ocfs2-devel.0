Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A2C383994
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Sep 2026 09:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790070179; cv=none; b=lssWRwgKmT5AMj9SNQLK7wo6bcVx5eGnKPeziIlWG72/XgoIp/yG27haq2U37hNx0uzep6fFjOmMD6qr4Aiy2dbrPNFoRWC+V6tzwZmSt6SbCpgLtxaOkOLqS9trYPPXoeJdtgd5t6Hb9JL8TojUtDgXt1UvuYTzD39yp7A6OOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790070179; c=relaxed/simple;
	bh=AaASihTEQYwCAyh5a2S+J5KYvZ9GGtdH7JfCAqe9w90=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GvpOguNYGuIbqMNZwcC49T9J9MD6o592CTpep3WF82eqqIyUeX0ZQhP16zItzGh1Cegus1Tt+N9AaI/gshviVO82MZNNQ1PBIn58Ttmqi4/LMhlAN6kZCAP8vNZB7imaXuvVldw4SOh1gRP8TOSXx501LafgxvXapFvH59HSOXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Rb7rtLYm; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Rb7rtLYm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790070173; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=uLneeA5paIA9x2260zcT17b84b4Z2tmYBGdNdrue6J8=;
	b=Rb7rtLYm0dINrUbWwbofZQ8sKoZ8jYbX8h6UByG0T3Q197keTz/G0UergD6bd1cLg6iWwm8rH2PUpZ8LAzV1MBt9xrPtUUmgXjz1ntQihdcUIjSpFYXjJEWtkOKXZHOKfk8dwGd5+Wn06xxUppkg+ud8fBFukF7BCFmysfw1ndU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XBTMJTP_1790070172;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XBTMJTP_1790070172 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 22 Sep 2026 17:42:52 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: restore -ERANGE check in ocfs2_xattr_tree_list_index_block()
Date: Tue, 22 Sep 2026 17:42:52 +0800
Message-Id: <20260922094252.971631-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_xattr_list_entry() returns -ERANGE when the buffer handed in by
the caller is too small to hold the whole xattr name list.  That is the
normal listxattr(2) protocol, userspace simply retries with a larger
buffer, so it is not an ocfs2 error and must not be logged as one.

Commit a46fa684fcb700 ("ocfs2: Don't printk the error when listing too
many xattrs.") already knew this and silenced two sites, quoting

  (27738,0):ocfs2_iterate_xattr_buckets:3158 ERROR: status = -34
  (27738,0):ocfs2_xattr_tree_list_index_block:3264 ERROR: status = -34

The refactoring in commit 47bca4950bc40f ("ocfs2: Abstract ocfs2 xattr
tree extend rec iteration process.") then rewrote
ocfs2_xattr_tree_list_index_block() around the new
ocfs2_iterate_xattr_index_block() helper and dropped that guard, so the
second message has been emitted ever since:

  ocfs2_xattr_tree_list_index_block:4513 ERROR: status = -34

The exemption in ocfs2_iterate_xattr_buckets() survived because that
function was left alone, and the new helper does check for -ERANGE
itself, which is why only the outermost caller still logs it.

Restore the missing check.  Only the log line changes: -ERANGE is still
returned to the VFS untouched, so listxattr(2) behaves exactly as
before.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 25fb23cc00d2..590b8b63d684 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4521,7 +4521,8 @@ static int ocfs2_xattr_tree_list_index_block(struct inode *inode,
 	ret = ocfs2_iterate_xattr_index_block(inode, blk_bh,
 					      ocfs2_list_xattr_tree_rec, &xl);
 	if (ret) {
-		mlog_errno(ret);
+		if (ret != -ERANGE)
+			mlog_errno(ret);
 		goto out;
 	}
 
-- 
2.39.3

