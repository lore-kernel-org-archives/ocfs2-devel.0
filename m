Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7371EB2F
	for <ocfs2-devel@lists.linux.dev>; Tue, 17 Jun 2025 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750123930; cv=none; b=MNYyVnBPjIOI22+LCMJ0miQO4Bg2Qra5tIiUUUGyzY04fhazEIEFuOQ3Dd717/rOvdkpAFx2srw6QGevH6j2/fV5zZsvFS6uNNSilbwNqj1rQMeAxGWlItmM0XhVtjr6IwtdMNcTWG9rRbTGswf+aFO/aLNcFLzv32xHwFzlY2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750123930; c=relaxed/simple;
	bh=c3rnSQ8qzh586vqOQyofBBqwBvt5+OMWLozqQdqHF6A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YcvrX+/XjvRjT+BSHy9hOv7Ro1Ylsc81ngvIyKTnca4hohuNDVhWaapc5LRl9y2l/22+JfGDLWm/3b6W01XNF5fV+8h7ak4fSUDy2pm1Su8w+LzDnFFHa6vO9WW4qDZxgi7pPQzv+pl1/uYsRS1sqnPB58WHrwfUQ4Xj8sSoWoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bLq4n2yhQzdbhy;
	Tue, 17 Jun 2025 09:28:09 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 71DAD1403D3;
	Tue, 17 Jun 2025 09:32:03 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Jun 2025 09:32:03 +0800
Received: from huawei.com (10.175.101.6) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 17 Jun
 2025 09:32:02 +0800
From: Long Li <leo.lilong@huawei.com>
To: <mark@fasheh.com>, <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>
CC: <ocfs2-devel@lists.linux.dev>, <leo.lilong@huawei.com>,
	<yangerkun@huawei.com>, <lonuxli.64@gmail.com>
Subject: [PATCH] ocfs2: remove redundant NULL check in rename path
Date: Tue, 17 Jun 2025 09:25:34 +0800
Message-ID: <20250617012534.3458669-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemn100013.china.huawei.com (7.202.194.116)

The code checks newfe_bh for NULL after it has already been dereferenced
to access b_data. This NULL check is unnecessary for two reasons:

1. If ocfs2_inode_lock() succeeds (returns >= 0), newfe_bh is guaranteed
   to be valid.
2. We've already dereferenced newfe_bh to access b_data, so it must be
   non-NULL at this point.

Remove the redundant NULL check in the trace_ocfs2_rename_over_existing()
call to improve code clarity.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/ocfs2/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 99278c8f0e24..26bc59c3a813 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1452,8 +1452,8 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 		newfe = (struct ocfs2_dinode *) newfe_bh->b_data;
 
 		trace_ocfs2_rename_over_existing(
-		     (unsigned long long)newfe_blkno, newfe_bh, newfe_bh ?
-		     (unsigned long long)newfe_bh->b_blocknr : 0ULL);
+		     (unsigned long long)newfe_blkno, newfe_bh,
+		     (unsigned long long)newfe_bh->b_blocknr);
 
 		if (S_ISDIR(new_inode->i_mode) || (new_inode->i_nlink == 1)) {
 			status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
-- 
2.39.2

