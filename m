Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D0B369D6D
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Jun 2026 12:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780316185; cv=none; b=YPdp61sL7c5VggXwiKob3QhqKs6NfMvTJapoHiOXT32UxatHb4ZXh47Whb+LNoNaTqcjcLd8WyfeQEa6oubZBGMEbZjG4qZuVLqtayuwldw2Myk5Ggs9KkPGC9CMuoUXKn43NzbD8kIKjM7uYK+IFOwX6mBvOfx1rPZtaXCuYjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780316185; c=relaxed/simple;
	bh=Wl9SPVp/U9kRBGvvfgUE/sqcpqQZizeY1e2C9XyOyHk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aDxHp4N/E27I9xichtxXG30zmoIHdywL8krvmcfrkuTJye3GUCBLkc0O6HzqjWHQ4CCs/OHsEwq8NBjPvKR/O7ekXWMBo4S5AxOCRuSpPMBw6cFWhly9DGYv4rT0UGd8reS+y4qtySLZXcX3T1GarQGNpEMNoNPOM9EuDYDCDL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=t36J8J6+; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="t36J8J6+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780316179; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=QFk2SP9bJAhzH8EQK/tTrhTt4JRpzPGWw9un4dl9lPc=;
	b=t36J8J6+N5e6dzd2CtIVqy1JMzQQ8bqL58CVFSscYUjkdRoxlVSJnxlLRdxgjithHYVhG1F8tuT4V0Y42Ac23gVbI8So3jpPJa/UAtqrrxUpHh7E/S5Sb+buRBnnlHGRRKqX0O95dGRzRMEem+UBRtOhiu5HfIU+qBXnen4EKDY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X4-wEix_1780316178;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X4-wEix_1780316178 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Jun 2026 20:16:18 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Ginger <ginger.jzllee@gmail.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: fix race between ocfs2_control_install_private() and ocfs2_control_release()
Date: Mon,  1 Jun 2026 20:16:18 +0800
Message-Id: <20260601121618.1263346-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move atomic_inc(&ocfs2_control_opened) and the handshake state update
inside ocfs2_control_lock to close a race window where
ocfs2_control_release() can observe ocfs2_control_opened dropping to
zero (resetting ocfs2_control_this_node and running_proto) while
ocfs2_control_install_private() is about to bump the counter and mark
the connection valid.

Fixes: 3cfd4ab6b6b4 ("ocfs2: Add the local node id to the handshake.")
Reported-by: Ginger <ginger@gmail.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/stack_user.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 5803f1dee679..91e19d33847c 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -327,18 +327,14 @@ static int ocfs2_control_install_private(struct file *file)
 		ocfs2_control_this_node = p->op_this_node;
 		running_proto.pv_major = p->op_proto.pv_major;
 		running_proto.pv_minor = p->op_proto.pv_minor;
-	}
-
-out_unlock:
-	mutex_unlock(&ocfs2_control_lock);
-
-	if (!rc && set_p) {
-		/* We set the global values successfully */
 		atomic_inc(&ocfs2_control_opened);
 		ocfs2_control_set_handshake_state(file,
 					OCFS2_CONTROL_HANDSHAKE_VALID);
 	}
 
+out_unlock:
+	mutex_unlock(&ocfs2_control_lock);
+
 	return rc;
 }
 
-- 
2.39.3

