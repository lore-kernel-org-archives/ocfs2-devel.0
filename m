Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872173;
	b=Fu8DAVrMfxIM7pQkERr4ZPkrBMwuE5KximQYU1WARYjOe/KbbLz8lXG/jmj28uX94KaF
	 C0XtAHlY4/qDJhTiPuMsLjfNPw9Pke9ezarPJgzDXiKFGtxOJ0HwY47TcYwLCsKfC2I7d
	 2jbAriJDXvyuZh/QwXkkopyW1xM7n3AiV4eAx4BeKNxMRrvOuYnC3+RSTgXIEiyeqDsXa
	 fl63cxwAJo9ZgWn0DGEXtXRDrKOa5zrSa3TVFN6D2kSc4qhzkDzgH0Bq9Bo2yt7e4Lh6D
	 KDmXV9iZoyrzRT/kGNpKSAp8nx8zNu13xLgwzBGea2nm7biE/jzIF5lPjXl5r4zMX4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872173;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4YVaVzbKkHTxyBM3D1q6R2QXC131lFlQY/+XFIGdWmM=;
	b=x8dsZzDoXsq/yWZCSGUxda5jEuKm0jRbhEQv91hLHaupUSOhAkRk2mTW1K+hO6SEJDfl
	 9o2xBzVsbuQzPgw+ZgMxOrs9cSdLfopSrKuFI6AaxMJApNn7lye7ophUUA5vw9lHqYdkX
	 Bi3SNSfOxp0k8iG5at1+lDRefkb7F1Xlx6P0TEQ7th3VCK2KZGRGfrTAphd6A1fIPtu80
	 BgWCqX5ZC2Cj9tgK80/9viQRub2a0GIJ99+5CohcTo0n1Yj0SbXD7qtSv/0WzA56MFPsX
	 uSkYzwd8hG2RiyMd3VyA0SemLZmB+LX2OWUjuM8GT/st+VfZtUIqASI3loZ9r71/BGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="c/IduCvX";
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6831606D804
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6831606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=c/IduCvX
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872169; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=4YVaVzbKkHTxyBM3D1q6R2QXC131lFlQY/+XFIGdWmM=;
	b=c/IduCvXS2T6fjxAvRWNB2xP3LvmXNM/YYZIj0G02I2nJQpGuocOoQPtNn7MN5zfBKOVPN5J9OjWWLx+qSqtFOkuZ0vQ3aQVf/tJmvQU8SvGM0KIoKbfXEsXd4nPmHI37wQcW92AK8gVXzuGSlGUB0ogA4Nm0cOlJ7rk4LxouGI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8K7-._1793872167;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8K7-._1793872167 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:28 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 01/30] ocfs2: abstract the zero nlink or mode dinode check
Date: Thu,  5 Nov 2026 17:48:57 +0800
Message-Id: <20261105094926.3203416-2-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
References: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_inode_block() open-codes the test for a dinode that has
no links or no mode.  Fold the condition into a predicate so it reads
like the neighbouring ocfs2_dinode_has_*() helpers, and so the filecheck
variant can share it.

Reuse ocfs2_read_links_count() rather than testing i_links_count and
i_links_count_hi separately.  OCFS2_LINKS_HI_SHIFT is 16 and both fields
are 16 bits wide, so the combined count is zero exactly when both raw
fields are zero.

The return code and the log message stay at the call site: filecheck
reports the same conditions with a different code and must not call
ocfs2_error().

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8bbebcafa7a1..bffd64e0a1c0 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -67,6 +67,11 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 						      struct buffer_head *bh);
 
+static bool ocfs2_dinode_has_zero_nlink_or_mode(struct ocfs2_dinode *di)
+{
+	return !ocfs2_read_links_count(di) || !di->i_mode;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1481,7 +1486,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
+	if (ocfs2_dinode_has_zero_nlink_or_mode(di)) {
 		mlog(ML_ERROR, "Invalid dinode #%llu: "
 			"Corrupt state (nlink = %u or mode = %u) detected!\n",
 		        (unsigned long long)bh->b_blocknr,
-- 
2.39.3

