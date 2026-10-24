Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792854620;
	b=y3zuDsKf5n19t3jiyUiMHMBC54IJxR43cPVIzbl0KsrY464wGYeDWZvALsv+ewHfS2uO
	 gf2hx39UgmdPY6pTeAr1RaqjJSpjRlm9IeSwJ7iWySS/FB1HS6VNyKHDTT9lh3IuRk1dc
	 JJX+5wOigPWv2UekiO+qu2lzhJ5MQW6bFgfCc1wrmOlH9SZEPPP+CjJ2BqDIc13Zu6MsQ
	 BEizXnD5Th5QGTBgT1FFKBq9kOYC6yrDnEcGYm+JdbIId0IwYORTnf7eN5RVL1Ip4T3aO
	 sSpCNG6mCWMniNwjSz5g5IZBYGEQyksICHbfGGwWFEUy7XcoS4pu6G6tuwbtdtzZ2rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792854620;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9JDFRrI5Zm8lm4r9xZObuGaRC6mhGOsAjpj/UhYTsMY=;
	b=NNW+HI3wVuQ+j2wCYaZtr3XHzamCdB4oKDshWw0qqJW6ninihYl3kDyNxqS43fKrhTcH
	 ASIm+v8rHcJbOF8ACJSfaCk3Yz19lJSY6Lh9nL59sWBJPNM0nybFpE49ThVHUqNM/1yIy
	 aN0SH4NP6kKDbCl30J14kR7cAAtkxXbadDzhOcndmivJqmD0yoXLxkNnFt5WVZCvNgdF/
	 hKXie5Hg/iET5SFbE9pjJo5mmrdcq7pqxwOc3Gtw7IS2ysLQBJTMg1z37FukJ1eDNa5xz
	 QsbGMphL8FCYbH56zoamT1KGARKAI5eVAy4AW48F9JtFscahAdtXB2DXXyqIZh7llmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="pQCPx/zO";
	arc=none smtp.remote-ip=115.124.30.130
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88F8606A31A
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 15:10:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E88F8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=pQCPx/zO
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792854616; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=9JDFRrI5Zm8lm4r9xZObuGaRC6mhGOsAjpj/UhYTsMY=;
	b=pQCPx/zOPNczKiQ6N2hBvIjRNugCiaN8+wzOQ6BUptAyl5vI9Eu4IXDEA9R2e7H0tfc+TtqDzG1/zPMtAs1LKpIpbt8IQ2mq0TXH9H5az1HSIRtKCld8ds0gesHTwbTXySCDHZJBKObsADlKKfezrjP+blcrmtO62GCYYRUWyCc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDONeQ2_1792854614;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDONeQ2_1792854614 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Oct 2026 23:10:14 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] ocfs2: find the xattr entry again after defragmenting a bucket
Date: Sat, 24 Oct 2026 23:10:08 +0800
Message-Id: <20261024151012.1059683-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261024151012.1059683-1-joseph.qi@linux.alibaba.com>
References: <20261024151012.1059683-1-joseph.qi@linux.alibaba.com>
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

ocfs2_xattr_set_entry_bucket() hands loc.xl_entry to ocfs2_xa_set() twice:
once for the bucket as it stands, and, if that reports -ENOSPC, once more
after ocfs2_defrag_xattr_bucket() has packed the name/value pairs down.

Defragmenting ends by sorting the entry array on xe_name_hash.  Buckets
are kept sorted, so the sort only permutes entries that share a hash, but
lib/sort.c is an unstable heapsort and it does permute them.  loc.xl_entry
is an address inside xh_entries[], so afterwards it denotes whichever
entry landed in that slot rather than the one the search found.

The second ocfs2_xa_set() then works on the wrong entry.  Nothing on that
path compares the entry's name with xi->xi_name, so what happens depends
on how the two entries compare in size: ocfs2_xa_reuse_entry() trips its
BUG_ON() when the padded name sizes differ, and otherwise the new value is
written into the neighbouring attribute's value slot while the attribute
being set is left untouched.  setxattr() reports success either way.

Remember the entry's hash before defragmenting and look the entry up
again afterwards, the way ocfs2_xattr_bucket_find() does.  An entry that
cannot be found again means the bucket no longer holds what the search
found, so fail with -EFSCORRUPTED rather than writing through the stale
pointer.

Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index bb5b12924e1b..d6d07116ce97 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6052,13 +6052,18 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
 					struct ocfs2_xattr_search *xs,
 					struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int ret;
+	int ret, found = 0;
+	u16 xe_index;
+	u32 name_hash;
 	struct ocfs2_xa_loc loc;
 
 	trace_ocfs2_xattr_set_entry_bucket(xi->xi_name);
 
 	ocfs2_init_xattr_bucket_xa_loc(&loc, xs->bucket,
 				       xs->not_found ? NULL : xs->here);
+	/* Defragmenting below may move this entry, so remember its hash. */
+	name_hash = loc.xl_entry ? le32_to_cpu(loc.xl_entry->xe_name_hash) : 0;
+
 	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (!ret) {
 		xs->here = loc.xl_entry;
@@ -6077,6 +6082,29 @@ static int ocfs2_xattr_set_entry_bucket(struct inode *inode,
 		goto out;
 	}
 
+	/*
+	 * ocfs2_defrag_xattr_bucket() sorts the entries by name hash and
+	 * lib/sort.c is not stable, so entries sharing a hash may have traded
+	 * slots.  Look the entry up again before writing through it.
+	 */
+	if (loc.xl_entry) {
+		ret = ocfs2_find_xe_in_bucket(inode, xs->bucket,
+					      xi->xi_name_index, xi->xi_name,
+					      name_hash, &xe_index, &found);
+		if (ret) {
+			mlog_errno(ret);
+			goto out;
+		}
+		if (!found) {
+			mlog(ML_ERROR, "xattr entry not found in bucket %llu after defrag\n",
+			     (unsigned long long)bucket_blkno(xs->bucket));
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
+		loc.xl_entry = &bucket_xh(xs->bucket)->xh_entries[xe_index];
+		xs->here = loc.xl_entry;
+	}
+
 	ret = ocfs2_xa_set(&loc, xi, ctxt);
 	if (!ret) {
 		xs->here = loc.xl_entry;
-- 
2.39.3

