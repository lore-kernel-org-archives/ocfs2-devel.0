Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963721;
	b=5FvExPIRMOvsF6iZN0VSGKFCL6R0oQDsztHcaI8E/xg914kJYhCFBwFO5QHMGdpCnBsY
	 HVlmars7kdmC31eEu6UZ2/A9xXgYjNWQbTgycuaH99vKJWuw280F0vcdY6F8MEFYlaERM
	 ptYh8pQym0e82LtSFbochIlWf7PKxd3VyA6AIU2HLLKpoWkAIx9IKOfGK/qMSGFa/Mn/O
	 rmP5uU3nsQfxbxK7eXG8punnHIxpCcyukHpi2W6m0uJLASHSHMI9TlV/cb0JNNdk3UKNT
	 AHxLWA8GSyLCqeFMFvFEpfTUDvstnWTSSaJxIpxJspvPtUMrqTL5/2OH9VnmnDtW/og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963721;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ht3jRqYuLjrDEVEoazEJ37O5hdHUFkQk2/v/rACxvps=;
	b=ktezvNsGwUggdMljlIqB0ZvRJZ5TXbnMD05rFikwj6CzZOc09/wm6dx5UL7EbSVh5bbI
	 56lpcLZFSK9CMIZGxCJT7My8pyGtZS/ylVx8H0HjHuRWHsvuSa0D7PuzkD8+uTqfpOjjA
	 4UzV2ZAkNdTlArlhhqhSIJSzbSUsLWAca4eCfuYbGjFdLQvnMNJv7d3Ztiri47OKd8Xgr
	 FyemT0+kWMr6aXWLX2zxwk8RsWtWbz4Dwv3cBefj9p358OeDtKIcl+koBhmJRXDm8nymL
	 IB9R3EGes9hyCOG0abZmHpjJzLHbdezXyH7su7/pD1DnBTYHyZWFas769EV9iu3JGww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QZuD1gyW;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27DA6083626
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C27DA6083626
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QZuD1gyW
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963712; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Ht3jRqYuLjrDEVEoazEJ37O5hdHUFkQk2/v/rACxvps=;
	b=QZuD1gyWqMI8RIRLIsJa6vTrd1Gvr9b6o6gEvFVKfuGBTGDj9vM3SlpiaiQGIOMhwpDrfaIzaq03sQfh6p4SsBZT/O/t4aljEREdNBnBb6R1LWIN9W33KH4BotLYLI68/Ez9OHon+Lq7iuS68eicr2EciEDiqOX2/m/3WQM83FU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBf71o_1793963710;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBf71o_1793963710 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:11 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 13/31] ocfs2: abstract the fast symlink dinode guard and size check
Date: Fri,  6 Nov 2026 19:14:40 +0800
Message-Id: <20261106111458.1467464-14-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
References: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
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

Introduce ocfs2_dinode_is_fast_symlink() for the S_ISLNK with no
allocated clusters test that selects the id2.i_symlink union arm, and
ocfs2_dinode_has_oversized_fast_symlink() for the i_size bound.

The guard is deliberately not shared with the similar test inside
ocfs2_dinode_has_extents(), which additionally requires a non-zero
i_size.  A zero-length, zero-cluster symlink currently falls through to
the extent list checks, and reusing one predicate for both would change
that.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8e867f6f394a..bf27925dd5c8 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -192,6 +192,21 @@ static bool ocfs2_dinode_has_inline_size_over_count(struct ocfs2_dinode *di)
 	return le64_to_cpu(di->i_size) > le16_to_cpu(di->id2.i_data.id_count);
 }
 
+/*
+ * Unlike the similar test in ocfs2_dinode_has_extents(), this does not require
+ * a non-zero i_size: a zero-length fast symlink is still validated here.
+ */
+static bool ocfs2_dinode_is_fast_symlink(struct ocfs2_dinode *di)
+{
+	return S_ISLNK(le16_to_cpu(di->i_mode)) && !le32_to_cpu(di->i_clusters);
+}
+
+static bool ocfs2_dinode_has_oversized_fast_symlink(struct super_block *sb,
+						    struct ocfs2_dinode *di)
+{
+	return le64_to_cpu(di->i_size) >= ocfs2_fast_symlink_chars(sb);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1784,12 +1799,11 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
-	if (S_ISLNK(le16_to_cpu(di->i_mode)) &&
-	    !le32_to_cpu(di->i_clusters)) {
+	if (ocfs2_dinode_is_fast_symlink(di)) {
 		int max_inline = ocfs2_fast_symlink_chars(sb);
 		u64 i_size = le64_to_cpu(di->i_size);
 
-		if (i_size >= max_inline) {
+		if (ocfs2_dinode_has_oversized_fast_symlink(sb, di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: fast symlink i_size %llu exceeds max %d\n",
 					 (unsigned long long)bh->b_blocknr,
-- 
2.39.3

