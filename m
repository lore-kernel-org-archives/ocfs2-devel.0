Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226921;
	b=J61ZL/ubkbfIp4XMO/Yiqypnz/iUIiNV3IMzeyhckcXi1mlG6rv9UhFX/9XNZsv5jqrZ
	 GvTcVjIPwf5i0zzixNnc/vv2pAi5/P7v42jlUGbxT+WO9Anwa5Adl1CYIWU+EhwfLt4VH
	 Xh2+XdldR0+uzeOyg+rOt5TrzWlzCIyUQdA/BYW9JUMlKtkgQgVQN4SmjO0t1CKNksJDA
	 9vDCcf5b+aR3EdnIC371fZa+NxHSMb+dj49Pt1mJgVjcGg5XA0cTE6VktLH68PvAmMY58
	 tTyhursHnB7jIYbkojN3HweYhfrCrUZ89+NZ5nxodNN8PCE9DlsH5W4sWAzK6PXaH1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226921;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WRQbLV9xK9j8db8LykabLsYxijEPAiJ3b/bGAaI2kjo=;
	b=qiQzqrB8f5BiYhw5qzUSQe1keW4mii2rQnuOlvvHRgbwwUhypmchghIqwLaOiBowIB+7
	 wsAuj0JMMm4rRROvoODF6woU4tMrniG0/mihRKT9s51czgSFjaV613E99CGfO6NGjYQY/
	 BdxQ6EiAwMtrQd1JlKEx8UzySWxDwZ7x6RvDon1o2WGDQw8hMlCWuxHV3RPYEc9pLqxsc
	 xMjAugPtGMpy7C0Qjhqf2APwUzIuPRvdJa6PVWPAipIYEgfj6tox5RxQxx1C7CECGV1le
	 7/PIE9nxl+QZvRY8gSKbYiUrVSxIVwDh23u8QmL/AvqKf7MqCWk8mRzYKy5dUArIM/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GhmQAK8v;
	arc=none smtp.remote-ip=115.124.30.131
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E12E606A33E
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:21:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E12E606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GhmQAK8v
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226911; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=WRQbLV9xK9j8db8LykabLsYxijEPAiJ3b/bGAaI2kjo=;
	b=GhmQAK8vSvnSW3GoRDjSUjfg1qiKpbk8hLpNbaoBwZ69T8EQi72AYGaFSv/0iILx0PtYVWyvaGiFeI4Xoujrvc2tbd1OqKv9TcghkyaWmZH3pBckxewsdjzmRPzs+uAyWxAn6TiLdXuVblD0ngsbnDgwdD9SVuDCIiUKC59AO6Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOZNgj_1794226910;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOZNgj_1794226910 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:21:50 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 03/31] ocfs2: abstract the dinode i_blkno mismatch check
Date: Mon,  9 Nov 2026 20:20:53 +0800
Message-Id: <20261109122121.21473-4-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
References: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
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

The same i_blkno against b_blocknr comparison is open-coded in
ocfs2_validate_inode_block(), ocfs2_filecheck_validate_inode_block() and
ocfs2_filecheck_repair_inode_block().  Fold it into a shared predicate.

Each call site keeps its own log message and return code: the normal
validator escalates through ocfs2_error(), filecheck reports
OCFS2_FILECHECK_ERR_BLOCKNO, and repair rewrites the field.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 209066321932..587fcea59f5a 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -82,6 +82,11 @@ static bool ocfs2_dinode_has_zero_nlink_or_mode(struct ocfs2_dinode *di)
 	return !ocfs2_read_links_count(di) || !di->i_mode;
 }
 
+static bool ocfs2_dinode_has_wrong_blkno(struct ocfs2_dinode *di, u64 blkno)
+{
+	return le64_to_cpu(di->i_blkno) != blkno;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1518,7 +1523,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		rc = ocfs2_error(sb, "Invalid dinode #%llu: i_blkno is %llu\n",
 				 (unsigned long long)bh->b_blocknr,
 				 (unsigned long long)le64_to_cpu(di->i_blkno));
@@ -1840,7 +1845,7 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 	} else if (rc)
 		goto bail;
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: i_blkno is %llu\n",
 		     (unsigned long long)bh->b_blocknr,
@@ -1945,7 +1950,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
 	}
 
-	if (le64_to_cpu(di->i_blkno) != bh->b_blocknr) {
+	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
 		mlog(ML_ERROR,
-- 
2.39.3

