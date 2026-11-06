Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963732;
	b=4Bo1EgD0WTbs0P7BnzXLiFd4qQwK/NJcQjcCUnk82q9nd41AmuyIlKo6qcXk//nFd/vH
	 ezY5mVDgCI3av30UKxzNlJlaNvZ97Ijryew9V28XLeWnqsAhNYucFtKL3vrN+VN5VumSd
	 lkb3naATWgqgszt9zW8KGtYag+YJbsk0e1AebmYw7zyNTwBBh7a/tHOaqIic/wIC6AACY
	 ISPbTndz+paERSbnlGllif2nAIPRZdC+SnNgJj3DO7Uk7CoHzJ9CSTACPEsVcvi3ywmXU
	 o+Y3Q4M+Pz0DSCxGUOWGPEbOkS1c2xkfGGyWaSB4vWpjucm3htmdatTZEM+Z6GctaeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963732;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=p9HDBJnn1eQ0/AK6EF8W6NIrJwKqMxPtpyUQ3JrmvsQ=;
	b=Mk5J+0zwWpD8TG9Fql9rCnhzPh9jIgVgmQy8omL+s2u3+YtZPEjdqiSGrgPFSOIhEUXK
	 pPnDJ89GLNaYnddKF6FFp3SXhI3Yee1brHI5BDAYVwNcd/xUmGygC0i++qlhjQJK3eXpe
	 nrUgZzy3GBME6wFINRQamCmUlDZJjJBpWY97jKGEC3ZCGS8NZEpI7IsyDaJnXZ0grI0SZ
	 pntgbGlMcgrH1M7QAlNXonuHvBQ3XlLRXZhng3PfrUS87I8sd/0AlaG8OVjvdAxL6hSYv
	 aWu4xolrPhmXb7yjkzHjAqoK9bv9QnsVLwERMcmXlTqSLlFUT/lxuIVi/yCNcW17T+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=v7cf6mR4;
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D498460705CE
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D498460705CE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=v7cf6mR4
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963728; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=p9HDBJnn1eQ0/AK6EF8W6NIrJwKqMxPtpyUQ3JrmvsQ=;
	b=v7cf6mR4qWcbx5YVua0McAI9NroFEJZms2yaUlZl5XZpd+qzrp2qic74cyi9eFxeb5ePRFKfKNgxUQwLAG9fOvCwTbt8srbOdmB4i/CCSS1FyD3J5jvBtG3ZXHxm7L/BoDei4hVTyt0/YC8tFrqKKR+bobD/qIwQdevqSkJVRV0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBf75m_1793963727;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBf75m_1793963727 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:27 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 31/31] ocfs2: check extent list dinodes in online filecheck
Date: Fri,  6 Nov 2026 19:14:58 +0800
Message-Id: <20261106111458.1467464-32-joseph.qi@linux.alibaba.com>
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

Wire the extent list guard and its three sub-checks into the filecheck
validator: a zero l_count, an l_count beyond ocfs2_extent_recs_per_inode(),
and an l_next_free_rec beyond l_count.

This brings the filecheck validator to parity with
ocfs2_validate_inode_block() for every dinode check except the inline
xattr one.  ocfs2_validate_inode_xattr() calls ocfs2_error() through its
helpers in xattr.c, so sharing it would mean threading a reporting flag
down into that file; it is deliberately left out.

The l_next_free_rec predicate is already used by the repair path, which
fixes that field, so a repair of it now revalidates cleanly.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ff46daf02509..ea2e2d2589d7 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2204,6 +2204,37 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_extents(di)) {
+		struct ocfs2_extent_list *el = &di->id2.i_list;
+		u16 count = le16_to_cpu(el->l_count);
+		u16 next_free = le16_to_cpu(el->l_next_free_rec);
+
+		if (ocfs2_dinode_has_zero_extent_count(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: extent list l_count is zero\n",
+			     (unsigned long long)bh->b_blocknr);
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_oversized_extent_count(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: extent list l_count %u exceeds max %u\n",
+			     (unsigned long long)bh->b_blocknr, count,
+			     ocfs2_extent_recs_per_inode(sb));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_bad_extent_next_free(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: extent list l_next_free_rec %u exceeds l_count %u\n",
+			     (unsigned long long)bh->b_blocknr, next_free, count);
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+	}
+
 bail:
 	return rc;
 }
-- 
2.39.3

