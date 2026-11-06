Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963719;
	b=q2MBPxEj3V+KVLZeDupYnJsBhCk9h/E1VhJekrgBhH0SFVEWF6k4A5JMQMpaPQv6qq4Z
	 nQQpuN5saLR08Fw4jGesUW7HsFwkermpreV94gSAoCDWH5KBSp9T9cSOCKdbzUhyzy5D1
	 vWsgi6455NzFcfHIT+RVBasBm5dA4+tIW/ihLnVx7SkNoAojc+zSKHggocNidWzPstTzE
	 LztLKwYBwwANzRag3CIjPfme14yVe9vSBCT3Vn3Xi3rVMj22vsjXWWLMX49CibvFACuPd
	 /4vlLWqbVAZGP36OP/sTCPs9yIoVbquKELMrhTaJw2vkZWsNOLt9Lwo1SXjQvQncDWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963719;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KWODd5koLgvTh8Hk6ZficFCm6r0AUkm1kFgtpaqzk7g=;
	b=tAVrM+DP+rgZCCt4txs6mK1Jk3YEqWrasZ7+ShbS+ajCWX0CQHXddkEYKp+VWu/LQaSu
	 Hltv6uHsyk2Ujbsz5hxaFdRBhpcmkPLr9J5wEIZ0WhTiNhuhYYN1lvbiBRFe3e52uF1iQ
	 3A6XXwMPDBZBZ/ZpIfeiHUNz4i9rz8I0ooreJeF4N5CPwslNuyTnaSTiyDuvz6hHkbVrg
	 vh9dww8LAHKHJ23BHQeVRrCqm9aKOtxphwV/Sc1FGzaOAfaGOgTRH18SZMFcn3hRIcEqX
	 ZXjYSUyma+EsSukWL6YtxsGG5BhmE3wRdIYGH7MKg3+3Jm9jJAsBtuoA5Ykl/QLB+Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=l9YSKz3P;
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184636082BFD
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 184636082BFD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=l9YSKz3P
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963714; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=KWODd5koLgvTh8Hk6ZficFCm6r0AUkm1kFgtpaqzk7g=;
	b=l9YSKz3PVaTR0UFwp3A2AYnaoF0PAI8XKL43djJSgdnAO3uiGa/NuWx+0nu5zfK/UrDYRctNt/xsot/X9nis89qoSm6293QqrQjA9656i2hPMHMLdvgyEcDLWU6+iMOh9m1DQqYIx316ERW8vG+5AOF3ElqL434OHjfO/dcMCL0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBVuzB_1793963713;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBVuzB_1793963713 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:13 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 16/31] ocfs2: abstract the chain list next free record check
Date: Fri,  6 Nov 2026 19:14:43 +0800
Message-Id: <20261106111458.1467464-17-joseph.qi@linux.alibaba.com>
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

Fold the cl_next_free_rec against cl_count test into a predicate.

ocfs2_claim_suballoc_bits() in suballoc.c open-codes a similar test that
also rejects cl_next_free_rec == 0.  It is left alone because this
predicate is not equivalent to it.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 71aded2c88f7..0ad86aaa9ab3 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -238,6 +238,12 @@ static bool ocfs2_dinode_has_bad_chain_count(struct super_block *sb,
 		ocfs2_chain_recs_per_inode(sb);
 }
 
+static bool ocfs2_dinode_has_bad_chain_next_free(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->id2.i_chain.cl_next_free_rec) >
+		le16_to_cpu(di->id2.i_chain.cl_count);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1863,7 +1869,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 					 le16_to_cpu(cl->cl_count));
 			goto bail;
 		}
-		if (le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)) {
+		if (ocfs2_dinode_has_bad_chain_next_free(di)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list index %u\n",
 					 (unsigned long long)bh->b_blocknr,
 					 le16_to_cpu(cl->cl_next_free_rec));
-- 
2.39.3

