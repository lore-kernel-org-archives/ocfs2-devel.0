Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963731;
	b=qtopg+XmTALnF9WTt5fhpg6YDwhvzDGPGAqssoq9vdo3dyAvE1q3FV57+Pvc8uIq54Lc
	 NgNXDyJpheIy8hkdsHMZcQKFWyo81EslPmNS0mg65+g3S/CezeDqbXu4PN55S8y4Uln8p
	 k2MF2aTisZF4GCi9TV+tVBSmXbisDwXPTYLcLdvb8vw7Ed5LfgXW1SZiq8FsAgzmvPzhX
	 28jPiDj2TSQZ3Yql947IoD97Lhmo57AEsvqClV+3Os0wHbEQ669P1NLM2rsJ2sB+K1X9a
	 qJouWADPovgx9wXCZP21SXGTM87ZcJ8jjC4BC+u3cjweWxmgW1n9240I7KWCsbICV7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963731;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=M+pnnGcv2orTjveXNhR7L4lavMK4j0o0zvOh1N/TvuQ=;
	b=eO9Dp8/s5UbOp0yype9A5DwZmpePleFMXWGBKoWpFhe8Pn6DNd2JjsQTFG27CHeI3iX0
	 9EfW05B6lC+wQKFAbcCXKcBY2frGJbppgUpvW03GShmpol5o/Jxj/AEJhJzxA2ni1bvyv
	 DuFkI1QZbonsKJpffOnhjHfvOi7y5rzN2c4TMemfkeprCzADo9CCUY4Px/egqT6s+xepq
	 eenayg4BCUkndXB8xDRg8hYdhW5vnC/sZtB07s0hnklkqN0mOPfKN4Y/mymqyPuEfa0JO
	 IYmp5p0HUyqiAvOLlUZUFcHL0hkjZ4/EJULq0a9hgi/DcuvN5hdnz8fvTs0cMAU953w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=t3vUtper;
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75873606EE8C
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75873606EE8C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=t3vUtper
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963722; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=M+pnnGcv2orTjveXNhR7L4lavMK4j0o0zvOh1N/TvuQ=;
	b=t3vUtperHi0aEh7+OtzBKgXhK1LWwCsWyD3nfPypUUpMcxjgVuV4yNaB6Nlp6keO3EUQ1CWgYqPiWvFQJEKNlUusKx3AMJxpe24RTVGmhnamq5xS+MkreI2ZReHMksUeaqDxBH4lYdRU9IYBEWuaZqrrTLoHTDEavahOhlkjeko=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBVv.-_1793963721;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBVv.-_1793963721 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:21 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 24/31] ocfs2: check dinode suballoc slot in online filecheck
Date: Fri,  6 Nov 2026 19:14:51 +0800
Message-Id: <20261106111458.1467464-25-joseph.qi@linux.alibaba.com>
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

Wire both suballoc slot predicates into the filecheck validator.  An
OCFS2_INVALID_SLOT on a non-system inode and an out-of-range slot keep
their separate messages, so the log still distinguishes the two.

The range predicate excludes OCFS2_INVALID_SLOT, so system inodes
created by mkfs.ocfs2 from the global allocator are still accepted.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index d32be79151a8..a70415f31aa4 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2029,6 +2029,24 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_invalid_suballoc_slot(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc slot %u for non-system inode\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_out_of_range_suballoc_slot(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc slot %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_slot));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
-- 
2.39.3

