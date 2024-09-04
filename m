Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AE613B295
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Sep 2024 07:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725433812; cv=none; b=MjFFUxR0tBzTtrHgBXoAoCQv19fv6Hfc530FbHqDI4ikLE3JQOIZHw5GeU+pYUQOJGDrQiD0HThCPTbue7ha2BoJeGI/u2Z2crFiwcVknTgE0clZb8NpRO4rftZM6n0x7zoeVfM5y4Q6BwSAvDK88JbUNlkSJM3Ii1tFEiVXUrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725433812; c=relaxed/simple;
	bh=FAsJlFuEXg96m3eEmDlt+U58YwVf+hRfLm45Q9DMBuI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I7X/cHZdrQ6OfsZilesxC+mX6/c/urgvctxbjatFAB1Qn1OSiYIqEEgnnrOsZ0BkrBMT/0Y+ByvUJDrKSzNzuXo7YL+TL0uLznHzw/V7q1xo5bgLfWKnJHshjt/VQDqoJrBoQN073oKrLX98iAr5D0oQBDCUVHJDtOGl2uq1aTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yj0xEcb9; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yj0xEcb9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725433806; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=vqyV76VlKKLAdbpgVAg9s1oydzR37v674r2y+KbzX3c=;
	b=yj0xEcb9GD8yTdM/DVkecTmvvBqYqGR9PDcQ11LBxFjR7IZ82INwGoS7wzRlAfCro+3IpHmHHZZ6mi+S1F20QLj2lXSQQN5NmLAUPLNK7OkAEPzWYaSa16fq7Mz4RyU1FGtFpfRtEcYg1eA7djc239x5+n6+0aydF2pwlPHkkCA=
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WEGYp4O_1725433804)
          by smtp.aliyun-inc.com;
          Wed, 04 Sep 2024 15:10:05 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Subject: [PATCH v2 1/2] ocfs2: cancel dqi_sync_work before freeing oinfo
Date: Wed,  4 Sep 2024 15:10:03 +0800
Message-Id: <20240904071004.2067695-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_global_read_info() will initialize and schedule dqi_sync_work at
the end, if error occurs after successfully reading global quota, it
will trigger the following warning with CONFIG_DEBUG_OBJECTS_* enabled:

ODEBUG: free active (active state 0) object: 00000000d8b0ce28 object type: timer_list hint: qsync_work_fn+0x0/0x16c

This blames there is an active delayed work when freeing oinfo in error
handling, so cancel dqi_sync_work first. BTW, return status instead of
-1 when .read_file_info fails.

Link: https://syzkaller.appspot.com/bug?extid=f7af59df5d6b25f0febd
Reported-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Tested-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Fixes: 171bf93ce11f ("ocfs2: Periodic quota syncing")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/quota_local.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 8ce462c64c51..73d3367c533b 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -692,7 +692,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	int status;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_quota_recovery *rec;
-	int locked = 0;
+	int locked = 0, global_read = 0;
 
 	info->dqi_max_spc_limit = 0x7fffffffffffffffLL;
 	info->dqi_max_ino_limit = 0x7fffffffffffffffLL;
@@ -700,6 +700,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	if (!oinfo) {
 		mlog(ML_ERROR, "failed to allocate memory for ocfs2 quota"
 			       " info.");
+		status = -ENOMEM;
 		goto out_err;
 	}
 	info->dqi_priv = oinfo;
@@ -712,6 +713,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	status = ocfs2_global_read_info(sb, type);
 	if (status < 0)
 		goto out_err;
+	global_read = 1;
 
 	status = ocfs2_inode_lock(lqinode, &oinfo->dqi_lqi_bh, 1);
 	if (status < 0) {
@@ -782,10 +784,12 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 		if (locked)
 			ocfs2_inode_unlock(lqinode, 1);
 		ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
+		if (global_read)
+			cancel_delayed_work_sync(&oinfo->dqi_sync_work);
 		kfree(oinfo);
 	}
 	brelse(bh);
-	return -1;
+	return status;
 }
 
 /* Write local info to quota file */
-- 
2.39.3

