Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00163145B37
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Sep 2024 07:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725433812; cv=none; b=PyWBG3TiBJ6xYZAbogW3ovbFOCaY8I2C/Sgf1QNZnz8QhK1OTR7PUVVll6Anm1cWXeDOOnTqAjnlvbmeBHAE3P1DBozqvtacjuI6qtpATINqRbFJniLkm/kePrR4VyNXlCZLTE2MjwJPIxNdXu9hOJvhBPYa7SnFceDHNzEPNxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725433812; c=relaxed/simple;
	bh=IK2AXQQXSRoe5GvghYUGUQHYafXTtZO1zlW74qV+Gmk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ozAhpEwpeR/O17Ra/r9AarsDNrMIadU6LEFQoyH/zXUbcflIlVfVevj6qfmH94eQxBFQ54CHyZFCJhW72vF2pe6OVyHtgzqDJu+BBVpSTffEdh7rnK81Wsw3GfdRc+PGwLltKziQfaS1aM022x7Pc5j5sNLyVOc/cZr3FE4OD3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dQuOTG5/; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dQuOTG5/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725433807; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=bKXQi2i4DQrB3nUxPAC2yeO9u1Vwfp7rZSVNMM+WRbY=;
	b=dQuOTG5/DSidgh0HZWfqlj9p87o46NX+Eg/EJ2xXaBSnulih5qbDyVYXkTx/ky07JEZiw58QgPP4BTmrxJkHuNt5k6Lp3pJWrRJJ+QIoSKRfJPMqLI2KN3aSTznKVXFX+QvhAxg4IqkpBbWgOKBcLRNeXBX/zuKX9fTMmAtKZEU=
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WEGXgYI_1725433806)
          by smtp.aliyun-inc.com;
          Wed, 04 Sep 2024 15:10:07 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+f7af59df5d6b25f0febd@syzkaller.appspotmail.com
Subject: [PATCH v2 2/2] ocfs2: cleanup return value and mlog in ocfs2_global_read_info()
Date: Wed,  4 Sep 2024 15:10:04 +0800
Message-Id: <20240904071004.2067695-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240904071004.2067695-1-joseph.qi@linux.alibaba.com>
References: <20240904071004.2067695-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Return 0 instead of sizeof(ocfs2_global_disk_dqinfo) that .quota_read
returns in normal case.
Also cleanup mlog to make code more readable.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/quota_global.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index 0575c2d060eb..2b0daced98eb 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -371,12 +371,16 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 
 	status = ocfs2_extent_map_get_blocks(oinfo->dqi_gqinode, 0, &oinfo->dqi_giblk,
 					     &pcount, NULL);
-	if (status < 0)
+	if (status < 0) {
+		mlog_errno(status);
 		goto out_unlock;
+	}
 
 	status = ocfs2_qinfo_lock(oinfo, 0);
-	if (status < 0)
+	if (status < 0) {
+		mlog_errno(status);
 		goto out_unlock;
+	}
 	status = sb->s_op->quota_read(sb, type, (char *)&dinfo,
 				      sizeof(struct ocfs2_global_disk_dqinfo),
 				      OCFS2_GLOBAL_INFO_OFF);
@@ -404,12 +408,11 @@ int ocfs2_global_read_info(struct super_block *sb, int type)
 	schedule_delayed_work(&oinfo->dqi_sync_work,
 			      msecs_to_jiffies(oinfo->dqi_syncms));
 
-out_err:
-	return status;
+	return 0;
 out_unlock:
 	ocfs2_unlock_global_qf(oinfo, 0);
-	mlog_errno(status);
-	goto out_err;
+out_err:
+	return status;
 }
 
 /* Write information to global quota file. Expects exclusive lock on quota
-- 
2.39.3

