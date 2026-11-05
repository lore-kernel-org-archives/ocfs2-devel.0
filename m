Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872199;
	b=Ty+Icq6cTy6SiunK3g/LXZtB2bz1+4KOe9xySGi7392IFLLWXqNRmhrt22HnINx5hWDv
	 rdpt1bcveVl5y0UxD1WHJDcz8Pbhqs13NnKY6fwU2sewcc0IgW9R9jQ19b7bzPORcx5SP
	 +8ZceKyT2xMofARIKaIu/sa0JeF5+dDQgLKBObwp00suEtup/Dr6CXi885AC/lWIccj3F
	 JEgMvNVfK770pfrAT5ly/IjpBsnZfB/NOASdaONCOka3Cdn/WN+zrAGBC8EJ2AxbSyFfo
	 zmGUE9H2qkH1GGfIdlXZWph8yLOd9mAMgwVwofK8QtTBvJ4GehngQoNTKHgoQ8W4G7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872199;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Faq+vA1ovxpomooz3Pw/+r3eKvjA2OnbkTJGJwqbl4M=;
	b=hwtSwba5af4rj8F29dflxrvqRuYeov3adBKfnW5epd/gt84wM9FCawI2sSJQ9SRh5xEX
	 R39PyI6bkgvsMcQsCHFTUSjFe/c4OlcOxuVPfOrGoRfISsNo/L6qvT3VketwPE+UGT7LP
	 gYPnlLfxLjnYMQ+C5PkmPDgJ4R2zqiQmCjPBNtD+AE0WDRRabpSfkRcf5+PGV5r96Uu/L
	 6TSa0/u5FrWms5FQPwoswhyopoEIabP+5UcORYBA3xMNQbSaR8lx7VNOMIDLf+ac0O8Kp
	 1TYEq0Ri6svDwh2q7oC/pfUhpwJFnLrNmSwLimVrcyqmTv7sA0l5C7W1MQ3JOcDA6dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=aglyuJIw;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F52560A5BD2
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F52560A5BD2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=aglyuJIw
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872196; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Faq+vA1ovxpomooz3Pw/+r3eKvjA2OnbkTJGJwqbl4M=;
	b=aglyuJIwutURUgqNbXgK6Y4z28ZInpDndfmCExo6avgvYSgsUimA3/CUZyXDZ9leQwkl51uXjJlwyjZGFl+yUkDNlNgrgcfJjnBBGg7/mV7rPmbgFAtE2OigbxXro0RTjqr8QlGbaFLTgan8esH0boRus9iiZLmUBKtmVCiikcA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8K794_1793872195;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8K794_1793872195 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:55 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 30/30] ocfs2: check extent list dinodes in online filecheck
Date: Thu,  5 Nov 2026 17:49:26 +0800
Message-Id: <20261105094926.3203416-31-joseph.qi@linux.alibaba.com>
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
index 0f7391c9f30b..97bc75db71aa 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2193,6 +2193,37 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
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

