Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963726;
	b=0U3J70z/OGfY4j0a8x29cCvpUiEQ4c2ejfdeXpApaLGHCvKPvy5O69kGsXFRKBJ0XTO5
	 ff1zzBrHjaoeEOHWtwzae39jj+8AspC6cAo5YMF6U/IiWt/RyXeFoaGY7hEFvGbE4/kGK
	 xsqFnQYcV3sjMnEzfiZgP3MGeeXeP5y77qrKtkpXvzeEyTBTP3SoQA7W3G23p2d9Cdn8F
	 x2cQXBXxbPA541iAbJt3EO9HIBk7CUuSK/G15/TRR+odC5nYNRHZL2kwPH6Pdeviim5Su
	 QHZSiUJFoeVIOXnzKP4DN01Mf1TunwOAFVY/wUicAQs3qKaTybjyF/xbaeXCNf8Fn1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963726;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nSoExF9u7rDYtXlhgYfrk5sitZuzd2CCQt8usBL9iqM=;
	b=21kry9JMgUVCtx94amcH7bXHj22XQAL0jOhU2ofEE8us/o18/uZ29wOKGZMP0Tu3eONi
	 qx/TZhgaHhWJ/lPi55h00FsHAI66zHnCe3F1ysaaawwtfCyLsqT7riqkNdRL+32+1q9Il
	 pb0DTZrCF/S8Fa9zfdgCVwPZANTp2rMjI1ofwH3f2NvlM3A56CcQJlIS5fED7yCp4dKzO
	 TZ9JHv4gUKjC9tqVhMlowQz/wA/0JOrM+PG5E3jNzbkx1CLTsylM3/Q/XjrOZRzQZ3T4/
	 I8rZ8VrZlYcrL0xI1tvE6s3CYKiiAa5ppOyFfRGyRR0EfLQ0i3DVoCP/ZlYq6rxoB/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="wCGlz/yZ";
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD8C60A5BD4
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAD8C60A5BD4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wCGlz/yZ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963723; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=nSoExF9u7rDYtXlhgYfrk5sitZuzd2CCQt8usBL9iqM=;
	b=wCGlz/yZla8SwoRmtcWJA0GgTyIl+Ek9Timg8lPx77LkzWtWs+q9DTNStBfKDsi3oDN3931yugsAUyz+YsQJ+Msp19lByOVGfv8+POsmOroTX5YCdwe6QWDFQjTsQjzh38T4aJQneHlN5KbK8mgpExnn683VTwypl3UHPPeo21I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBf74N_1793963721;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBf74N_1793963721 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:22 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 25/31] ocfs2: check dinode suballoc bit in online filecheck
Date: Fri,  6 Nov 2026 19:14:52 +0800
Message-Id: <20261106111458.1467464-26-joseph.qi@linux.alibaba.com>
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

Wire the suballoc bit range predicate into the filecheck validator.  A
suballocator group bitmap lives in a single block, so a bit at or beyond
ocfs2_suballoc_bits_per_block() can never be valid; accepting it would
later trip the BUG_ON() in _ocfs2_free_suballoc_bits() when the inode is
deleted.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index a70415f31aa4..2709c139ecff 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2047,6 +2047,15 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_bad_suballoc_bit(sb, di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: suballoc bit %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_suballoc_bit));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
-- 
2.39.3

