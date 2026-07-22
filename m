Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F598288AD
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 12:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724584; cv=none; b=r7HEGCFJZGqcwLFS9aP+51zE7tOhiKlro6GWUkFUJ+AqFh1oIKNpu10KSsG3IrX83ypamxkI0oB6piRlNXYKJcTNpMAlYEJokCXGfGpmVoQIN3q4WdLDTC71n84qQXRWsIFjm1205xAcFjsUerFA5+73Oc6XLoBoEFamUgCYSYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724584; c=relaxed/simple;
	bh=83qqL9QaHl68BIuBD49IV/hhUYTFYLjlIYe2Z5E+xlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oKgo8JUNPw/173AumUP7ZFZu0JD5bGUC5a9o23ruOGIxzSdIi3MwFlpIZqiBHFq8nrQzW6FnjliwUY+ogJBMm0/gtucTz+Mqtw8VXcY69qLGnRbGLo43QLKeMRykRgQTSYMMM3oxjfZ1Teu4FfluS3wbFDzW1y4utVQvQbBn3zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=q1I2IbWu; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="q1I2IbWu"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784724577; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=UbcvKoanBvsJ2FJe5h8pWBVsZaTGcDaSpk9vsfukem4=;
	b=q1I2IbWuXFCREyVOOvrk9lbHc6aGUEab2kVpLSAOOLNxSBi2jwsOLdaVpvEl/epU1GQEa004qN89kxDUn/sy8pXSiD2VM4mw7yxzvXdSzrDk/VnPEXdrAhoZ76DWY9zda21SGpAsxusd56AaPQHIyg4gkPZ0MgHfo7ju1B3b9uY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X7dKx4Q_1784724576;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7dKx4Q_1784724576 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jul 2026 20:49:36 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] ocfs2: cluster: fix o2hb_dependent_users leak on pin failure
Date: Wed, 22 Jul 2026 20:49:33 +0800
Message-Id: <20260722124933.430554-4-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260722124933.430554-1-joseph.qi@linux.alibaba.com>
References: <20260722124933.430554-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In o2hb_region_inc_user(), o2hb_dependent_users is incremented
unconditionally before calling o2hb_region_pin().  If the pin fails,
the counter is never decremented and any partially-pinned regions are
never unpinned, since the caller does not call o2hb_region_dec_user()
on error.

The leaked counter causes subsequent o2hb_region_inc_user() calls to
skip pinning entirely (the > 1 check), leaving heartbeat regions
unprotected.

Fix by rolling back on failure: call o2hb_region_unpin(NULL) to release
any partially-pinned regions and decrement o2hb_dependent_users to
restore the pre-increment state.

Fixes: 58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/cluster/heartbeat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index b9395835523e2..c25aa2ff3ebc2 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -2499,8 +2499,13 @@ static int o2hb_region_inc_user(const char *region_uuid)
 		goto unlock;
 
 	if (bitmap_weight(o2hb_quorum_region_bitmap,
-			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
+			  O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF) {
 		ret = o2hb_region_pin(NULL, false);
+		if (ret) {
+			o2hb_region_unpin(NULL);
+			o2hb_dependent_users--;
+		}
+	}
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
-- 
2.39.3

