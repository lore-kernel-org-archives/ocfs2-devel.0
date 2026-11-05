Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872192;
	b=Z6VygnrM1rtOVTIPw6FiGj0ATxIvgg7/LMcH/9w7PNgyv1l1cocVhoS9E6yUzCCFTZx0
	 FwoGTal7JhFiH/SuTUUrTpCCvg8qHtqiIyedWC1OXz72vZ/Y6jhxCCHLE5GQ6Pw6HrHUn
	 YtBRQQXutKwBg103va3QfOvWCY5rdYWhJWTqtECElZ2tJlRXVljFEnoNJUWIVHbm0oky6
	 37PAFtVv0htPiwgMemBUx05U8afKE/aTYzRkiql9YAfFre4JDOSf88e5tVVEpICBNOwqx
	 J3Jkj6JSvLJd/GGXeCBGaOt5LFgZFG7HqtEoIMSucEJOVWQ5tnfBBBNUgD0PVEEwkgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872192;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pNwCp6FYbUGEemztC9rmVjIbc8Y1IhgeIoQX1xvY078=;
	b=zH2V8X4YxFctKUCBoow2oWVfbEZvCIf03jfKC97ggBWAp9MlpM+QLzMnwHwUFZpgDvt9
	 CPmYbfgkiUvUTWStUixfMPYZ7UqtEbk7yeM/ULVOv1aVk5hW8Rbf055sLfb3F/Y4vniLc
	 KKPes9U3lky4BkF2iQt3MJw0bRxC4kmgoHBou74Lrt8fqcFlYNA0OQuteN+z7lSltd3XE
	 A3LomG1XFX0rkjxUtXHterVJnTldopLb4gdoI/jrMxSyqPdoazXSJXcf7/t5cu2yfgeyU
	 zAlMJUMf6PB0yfMtpnN7C0CKkQiN3aZcHNg0JA2sJLv1WHy5dAPblmyNfAKd7W6KA7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oPATTCHn;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF20608360C
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAF20608360C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oPATTCHn
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872188; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=pNwCp6FYbUGEemztC9rmVjIbc8Y1IhgeIoQX1xvY078=;
	b=oPATTCHnRvQ0+UzeahH4wTtGfaNZRWsE2Ql5sCYF38kDfWynPmfjxSigP7xPXiFxViILddeP8dp0unBg47OqnsGu8CwsSAe5R02aoKANl/W62VIGcg1n6TWs+IOa+mgIWkXumS4IlRYvx9xXopjf5LzxaRVfzKM8VwbIVii1X6A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8RZe3_1793872186;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8RZe3_1793872186 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:46 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 20/30] ocfs2: abstract the extent list next free record check
Date: Thu,  5 Nov 2026 17:49:16 +0800
Message-Id: <20261105094926.3203416-21-joseph.qi@linux.alibaba.com>
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

Fold the l_next_free_rec against l_count test into a predicate and use it
in both ocfs2_validate_inode_block() and
ocfs2_filecheck_repair_inode_block(), which open-coded the same
comparison.  Repair keeps its ocfs2_dinode_has_extents() guard, which
selects the id2.i_list union arm.

This completes the split of ocfs2_validate_inode_block()'s open-coded
conditions into ocfs2_dinode_has_*() predicates.  Every return code and
log message stayed at its call site, so the normal validator still
escalates through ocfs2_error() while filecheck reports its own
OCFS2_FILECHECK_ERR_* codes without touching the error handling state.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index f68f8a26e6ab..115aad1b8926 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -268,6 +268,12 @@ static bool ocfs2_dinode_has_oversized_extent_count(struct super_block *sb,
 		ocfs2_extent_recs_per_inode(sb);
 }
 
+static bool ocfs2_dinode_has_bad_extent_next_free(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->id2.i_list.l_next_free_rec) >
+		le16_to_cpu(di->id2.i_list.l_count);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1928,7 +1934,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 					 ocfs2_extent_recs_per_inode(sb));
 			goto bail;
 		}
-		if (next_free > count) {
+		if (ocfs2_dinode_has_bad_extent_next_free(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
 					 (unsigned long long)bh->b_blocknr, next_free, count);
@@ -2099,7 +2105,7 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 	}
 
 	if (ocfs2_dinode_has_extents(di) &&
-	    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
+	    ocfs2_dinode_has_bad_extent_next_free(di)) {
 		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
 		changed = 1;
 		mlog(ML_ERROR,
-- 
2.39.3

