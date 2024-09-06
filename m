Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3BE3B1A2
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Sep 2024 06:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725603088; cv=none; b=P2vCelf+NyRFwLjWo1Egcn0qAQpF8+zo5Z/Yenulzc/TDKrrPLyG19mctb7M8XGgY688WpPcc8n37sAtWxYpB1nV2QX/ADAqtf82qWMpkRXbSn7zfLvmmn/Tcphddq+Lo7YpNypbwSbrxG+K8oGaDOLn7kbYsUm5GUQLpi4IIq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725603088; c=relaxed/simple;
	bh=K78PYUFONTfEITddSCw6nEhhXa9wKVvpLBx95UcM/F4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o/PKQt+07ss0MQnUmbBVt1U+fRxx6gm6Wbdpwo1dR2VrObrx5dLDhvFmlxliunOSwXW21xEtZb+mXB72uXuH1E+tEGwP1nEsGnVW/mZCiQBFnZo2ahuoM4Hs+FhbR4JkOBT0fYFqOoM5Byp3mZ/UZc8IFg/iNE6UPzsGN3hRNnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4X0Qhs0rXrz20mQ4;
	Fri,  6 Sep 2024 14:06:21 +0800 (CST)
Received: from kwepemf500003.china.huawei.com (unknown [7.202.181.241])
	by mail.maildlp.com (Postfix) with ESMTPS id 2B7891A016C;
	Fri,  6 Sep 2024 14:11:20 +0800 (CST)
Received: from huawei.com (10.175.112.208) by kwepemf500003.china.huawei.com
 (7.202.181.241) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Sep
 2024 14:11:19 +0800
From: Zhang Zekun <zhangzekun11@huawei.com>
To: <mark@fasheh.com>, <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
	<ocfs2-devel@lists.linux.dev>
CC: <chenjun102@huawei.com>, <zhangzekun11@huawei.com>
Subject: [PATCH] ocfs2: Remove unused declartion in header file
Date: Fri, 6 Sep 2024 13:57:42 +0800
Message-ID: <20240906055742.105024-1-zhangzekun11@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemf500003.china.huawei.com (7.202.181.241)

The definition of ocfs2_global_read_dquot() has been removed since
commit fb8dd8d78014 ("ocfs2: Fix quota locking"). Let's remove the
empty declartion

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
---
 fs/ocfs2/quota.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index ebb5c99f490e..788a8de922a4 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -97,7 +97,6 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
 			  const char *data, size_t len, loff_t off);
 int ocfs2_global_read_info(struct super_block *sb, int type);
 int ocfs2_global_write_info(struct super_block *sb, int type);
-int ocfs2_global_read_dquot(struct dquot *dquot);
 int __ocfs2_sync_dquot(struct dquot *dquot, int freeing);
 static inline int ocfs2_sync_dquot(struct dquot *dquot)
 {
-- 
2.17.1

