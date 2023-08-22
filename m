Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A1F7F
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Aug 2023 03:03:43 +0000 (UTC)
Received: from dggpemm500017.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RVDfF0h8Wz1L9Dy;
	Tue, 22 Aug 2023 11:02:13 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 22 Aug 2023 11:03:40 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 22 Aug
 2023 11:03:40 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
To: <ocfs2-devel@lists.linux.dev>
CC: <mark@fasheh.com>, <jlbec@evilplan.org>, <joseph.qi@linux.alibaba.com>,
	<tytso@mit.edu>, <yi.zhang@huawei.com>, <jack@suse.cz>,
	<yangyingliang@huawei.com>
Subject: [PATCH -next] jbd2,ocfs2: fix wrong pointer pass to PTR_ERR()
Date: Tue, 22 Aug 2023 11:00:18 +0800
Message-ID: <20230822030018.644419-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected

Fix wrong pointer pass to PTR_ERR() if jbd2_journal_init_inode() fails.

Fixes: c279913275eb ("jbd2: jbd2_journal_init_{dev,inode} return proper error return value")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/ocfs2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 90af6c47161d..ce215565d061 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -910,7 +910,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 	j_journal = jbd2_journal_init_inode(inode);
 	if (IS_ERR(j_journal)) {
 		mlog(ML_ERROR, "Linux journal layer error\n");
-		status = PTR_ERR(journal);
+		status = PTR_ERR(j_journal);
 		goto done;
 	}
 
-- 
2.25.1

