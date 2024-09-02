Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01C638FB0
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Sep 2024 02:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725244610; cv=none; b=PFaq0Cl93AmypllXdr4ldfpo0Mw47Wvy9Ro94nszHcEwMy/h0PzhBquSTN5dVqI7HO6Vf2PQlTFuUwc+jC0wtC+4IyYsLgK1v2Cv1ITXwHTJVgMzQTj+eZxLuuSrMc3HbYE77J8TdWHqAItYFwc4dNsUgpNDRpQgBur52GG1hx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725244610; c=relaxed/simple;
	bh=Qi3mFAh46zqBBGRVdGNoLVmijtM0zQv73cyI6DOT1aE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QpZ6UcZ5MSZy7iZdg+6C8bcdjdTUB2/b31yiALoVRUEcuhUrQlkBEfmtrrzESxr4fOZbZJB5Z43Pr/XX9G035WBlGIOTLaw6i+wnBcpF+5Zk71Gp26SdgZAziL4J1k3Ke35jF5cnq54Cei7jy7/eVAGn7q0v237SDAqBX+k56vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VR+Y5Ve6; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VR+Y5Ve6"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725244599; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=y82yL1fAwzFCDuugYwNZGzR8FaXBJxRTSwco7Omtw9k=;
	b=VR+Y5Ve6rTMMFfhgSW+pe7pKFp8W+/3hkVRvx+qoUlZJBM/Vlo90PgUdEhFRTki5+R38niJknTAOI61p32je3VxSEGIynJJTHZZ5r1GnONW4LPATC+cI9ojkaiexqTk+f6vfAD2Kl6vfTTcymkItasrnSjyi4wrU1K5zX+0Ognw=
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WE1-ECs_1725244597)
          by smtp.aliyun-inc.com;
          Mon, 02 Sep 2024 10:36:38 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jlbec@evilplan.org,
	mark@fasheh.com,
	syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v5 1/2] ocfs2: remove unreasonable unlock in ocfs2_read_blocks
Date: Mon,  2 Sep 2024 10:36:35 +0800
Message-Id: <20240902023636.1843422-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240902023636.1843422-1-joseph.qi@linux.alibaba.com>
References: <20240902023636.1843422-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lizhi Xu <lizhi.xu@windriver.com>

There was a lock release before exiting, so remove the unreasonable unlock.

Reported-and-tested-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Cc: stable@vger.kernel.org # 4.20+
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/buffer_head_io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index cdb9b9bdea1f..e62c7e1de4eb 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -235,7 +235,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
-				ocfs2_metadata_cache_io_unlock(ci);
 				status = -ENOMEM;
 				mlog_errno(status);
 				/* Don't forget to put previous bh! */
-- 
2.39.3

