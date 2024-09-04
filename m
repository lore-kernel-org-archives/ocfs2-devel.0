Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D41FBF0
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Sep 2024 02:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725415801; cv=none; b=k0XxfMKHVXAM1/va3qe0mVqsKRrOqlRhNRwhdeNo2Hzdt393JetcOER595KjPlMDkAXV3xY4/jhMA6FlsJfh2meUCQyNjEkWDKBB3eA/Yu0z2mA/1aS4mD2DgIsHx/QQtFCrWVn8Zuhpx86tYQ2/4lQT9ONiC0XLGXAy6kpIzU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725415801; c=relaxed/simple;
	bh=n5bTpT5frNM9Jwcxv3Nosmu7yeUu+JDDIUU+YjUDCDY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aIOr8zK3fUdMfAgczgSu61ysC+YzDY6B+QTRu7rXGUiCb0p+uMlT3iGPsfVD/ztIxNfS6NMiv+MCxR47g5MmiIHb24RSw85jjVxnl8Ot9fpCvTYrQ8ns3Aasd6nlyf48iC8fCb5pzs76cf7zqKLOKRLKS7m4aWqE9szoryChvp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=a1vAexCN; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="a1vAexCN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725415791; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ryfGgkG71Erc80lluxJYGk+3yB5pONNaisoQGI5POVw=;
	b=a1vAexCNUB/6Wseg8Zg1bCLxrWPvY8IUdAJbrxFtFYvMkR7IHAn4v7vpK4wafktIuo/6qF/lT/DYpCpGiRJ8RQIbYQHDwirg7s1ecE43j/5WyndqpTSZtMliUbaHi10UwNtPJPzBqCW6oD3KBej8F35GndgqgmUVtA78qorv41c=
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WEEqKxH_1725415790)
          by smtp.aliyun-inc.com;
          Wed, 04 Sep 2024 10:09:51 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: cancel dqi_sync_work before freeing oinfo
Date: Wed,  4 Sep 2024 10:09:49 +0800
Message-Id: <20240904020949.1685198-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_global_read_info() will schedule dqi_sync_work. So any error
occurs after it, we have to cancel this delayed work first before
freeing oinfo, otherwise it will trigger the following warning with
CONFIG_DEBUG_OBJECTS_* enabled:

ODEBUG: free active (active state 0) object: 00000000d8b0ce28 object type: timer_list hint: qsync_work_fn+0x0/0x16c

Link: https://syzkaller.appspot.com/bug?extid=f7af59df5d6b25f0febd
Reported-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Tested-by: syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Fixes: 171bf93ce11f ("ocfs2: Periodic quota syncing")
Cc: stable@vger.kernel.org
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/quota_local.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 8ce462c64c51..ebe0dbc8db4a 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -782,6 +782,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 		if (locked)
 			ocfs2_inode_unlock(lqinode, 1);
 		ocfs2_release_local_quota_bitmaps(&oinfo->dqi_chunk);
+		cancel_delayed_work_sync(&oinfo->dqi_sync_work);
 		kfree(oinfo);
 	}
 	brelse(bh);
-- 
2.39.3

