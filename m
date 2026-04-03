Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AD838C412
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 09:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775207298; cv=none; b=V/7D9bkQ+DXNZjOfbqpXYRSou66T2kmsv278zrWx1a5eUCsO7gZo38/8cqsvpvk0eNugT7pHjXrvCWa+abS8kvj0Scg5SN7/eQA0sgVP2DBRQ4I2CNe16TVeWeXROluOWrJM0aP/OpLzTasq8TOkLfZFud6uM8uMWg+LpAg6rNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775207298; c=relaxed/simple;
	bh=1S62142bTYfPOumsFslF2t1QjRSoZzuwBdjGTUQhpyY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q9ul5FqFUtmTdWKcv75Dr7cmy+U/GotKnYzR3obkDwGNZ38rzJ9SkirA11yYt3QlEZ3P2xfCl5SYNtUANwU5pRD5XiiWFcXc7WRiWqr1xxww2jO5YeyX3vMti03E7aI83b7yCdWeHKNxpBqsPI4YPLpVJ6mlcBIcycnXKuEp6f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MZfY9mUI; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MZfY9mUI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775207287; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=xWrwemNBl7XrecfOY+vjnq7eBphyhMoNrep2AfZ3TSk=;
	b=MZfY9mUIuEP3O5A2Wr8Flxa5fa2BnNfTqzjlPRBTeJOmxYc5jo0+5507xmw5lrjhcMqIaYwnThefC9/shXnBLf7ZKy4kq/h9pHAnbnxE0BuHfPt1bEKK5EgJbW63vhsJCZuVmaQ9ZuJxueN/7CHkolvUgmYYbgsFQ+x6eJ9k10s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X0JqO83_1775207285;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0JqO83_1775207285 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 17:08:06 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ocfs2: remove empty extent list check in ocfs2_dx_dir_lookup_rec()
Date: Fri,  3 Apr 2026 17:08:01 +0800
Message-Id: <20260403090803.3860971-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
References: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The full extent list check is introduced by commit 44acc46d182f, which
is to avoid NULL pointer dereference if a dirent is not found.

Reworking the error message to not reference rec. Instead, report
major_hash being looked up and l_next_free_rec, which naturally covers
both failure cases (empty extent list and no matching record) without
needing a separate l_next_free_rec == 0 guard.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dir.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 82e720c8ba32..d94595a49923 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -835,14 +835,6 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 		}
 	}
 
-	if (le16_to_cpu(el->l_next_free_rec) == 0) {
-		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has empty extent list at depth %u\n",
-				  inode->i_ino,
-				  le16_to_cpu(el->l_tree_depth));
-		goto out;
-	}
-
 	found = 0;
 	for (i = le16_to_cpu(el->l_next_free_rec) - 1; i >= 0; i--) {
 		rec = &el->l_recs[i];
@@ -855,10 +847,9 @@ static int ocfs2_dx_dir_lookup_rec(struct inode *inode,
 
 	if (!found) {
 		ret = ocfs2_error(inode->i_sb,
-				  "Inode %lu has bad extent record (%u, %u, 0) in btree\n",
-				  inode->i_ino,
-				  le32_to_cpu(rec->e_cpos),
-				  ocfs2_rec_clusters(el, rec));
+				  "Inode %lu has no extent record for hash %u in btree (next_free_rec %u)\n",
+				  inode->i_ino, major_hash,
+				  le16_to_cpu(el->l_next_free_rec));
 		goto out;
 	}
 
-- 
2.39.3

