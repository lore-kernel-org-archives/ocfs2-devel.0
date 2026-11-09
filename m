Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226927;
	b=R8Tjn09pdwrY7thRJ+OA6zXwaS2PhwVW7u2X82aLLWsLd9GWhfy7T83BXR1L8U5anU8M
	 jH0wnUM64X35GhTUdlwl1lG5tOoAy9EtNvCnceDQhKnWkxsZOvXUPvtWM1ByEAMUyjF5G
	 T2+1OmbU2O7S6rn4HuaYvU2jkNvyVSi96lsGDAXLh4rZFXX0G+p7fDlERGUHdHyB4VXeK
	 1RRDtFY4DcLE8Iq8SHS7E3ghI2JBVXquIBCf5k3fJmKop0xjuIQedWZ3HoIRyEW1MGdET
	 Bk0Gz6mRlnIrqLWbVolB19csLfE4EZ+BrLIgQYgtmlRovzNPolDPJsGcInyIKMowl9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226927;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KWODd5koLgvTh8Hk6ZficFCm6r0AUkm1kFgtpaqzk7g=;
	b=sZ9kAqYr6JbsuaFglqMaGIan0tCZg/wlTWI+5L0xyzsycKYE+GesN95qz3l/JqoWMqYH
	 aklkflivfYar77wbmTXcgz1dKAjogiSSkt1oHGSy5PEm1VIn1yLb8ao+NzE9k7BPM/VNy
	 HEemWgKigtV6YGgZsmAQjxXkVVCEAYiARx+9lWvQTqqpUfOknpC8CDdYW0xmLBHzCBKwb
	 0fA1U2dFo8SwcI2vRBGl3uO6NVwcZPgbSBX7jA1dX8LYzyyqGqBDM1AluXg159eFvcV0M
	 yEM2A3f5NNcI3c1dD8mWV20oXtLdmBYjTuXAqeMLYts/IWD9Qjv6FZ55Bz7N3AOIZFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SY9Qbkfj;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A414E606A338
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A414E606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SY9Qbkfj
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226923; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=KWODd5koLgvTh8Hk6ZficFCm6r0AUkm1kFgtpaqzk7g=;
	b=SY9QbkfjWQLHQK3ICWX0zXgKaTR7PFRvfuG41POoG0alAgKgOcfGZg5W6mm7VCoRslx1gYBSGQNeBfl8fNUgO+2qf+46QKtayu2h9QTGnbrt7XnXzcAREhOQiKe0UHbPTG093n1bbBg1yJmEh7CK5d0QDlKs5cMYNfmP9Y6BVDQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8at-_1794226922;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8at-_1794226922 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:02 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 16/31] ocfs2: abstract the chain list next free record check
Date: Mon,  9 Nov 2026 20:21:06 +0800
Message-Id: <20261109122121.21473-17-joseph.qi@linux.alibaba.com>
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

