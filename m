Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872185;
	b=Wv9oVKCu8OK8YzrDvvHJahaLxHlIeEsoZIolXlRjnBJVNQfddJiE+Lcll3Q1KZo5+nOY
	 taUlKORBLTO8XAIrg12cwHKJUwCCPtk4DDydGApNi37TGXt2e0RSeqNLNZQdleJr0M0QV
	 FP234qHf/qmQU246g8JuSz/eVAuYU+r4h4m8hUdRwCay1YO6u8eUGbh2iFYFBHvcNHoVN
	 WF/ZeFGKWBTdXCVTyN2CADrkGR5SHQjKZpcJSJRwK4wLoefhRjCvm7t6Hb1SLAhowUVU3
	 pZGPopZ3LASRtcmrhRYRtMK8BMcgBY87uDPzG8+NHd3KyoYEdA2eURJ3amkDITZroDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872185;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kvjeYd4fqsT4ixPyNrODgPZ3f4+GoGEaruKu44ZzFgY=;
	b=afbcEDwH4d5Mp6Fsw92Alz0DyCWf8Bgbpah/JQR1R3rqWxo1v57+dTc8KVPt7YCnvm1l
	 QKRoJb/5m5Wt1YoRZgRnkJ7bx3eZrMyZko58xZlwvBbLCi+LDn9W4GwtR+TfmsFCrfxkb
	 CY5UP2EteOf3+nyj8RN11YFbcrBl6VBQz1rOK7C1VrK5SGC2ufH1IUx5BsysQJHm3IAQU
	 eTQ50zWuIKRfHw2eIBFC/9Quxs0IdEZPBl/96NKZ1BpXLKaYo5lAIhY63jv3u1jJhP9bw
	 kKG/kmrpQgLRiz9FDG/TKZOwLSh4/W6dz1+M1b3qNlJebGo86myYYWafJo5uh6KVdGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fPqhSKtc;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F036082BEA
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92F036082BEA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fPqhSKtc
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872182; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=kvjeYd4fqsT4ixPyNrODgPZ3f4+GoGEaruKu44ZzFgY=;
	b=fPqhSKtcRaoDLmcoHzWYoPhkZDh7jYRjRru9Hj9o3rUEluPsDk9aCVYVH9Gx0E74lZGyQpYqy6s65QHnIAV1/j7SSkXhP7k8DVU4pTq6qSdc3U8OdQ4KcMYML/x24lTCJfjGGPNYsgtmAOTSvPCjJsBwzos2JNal8f4rDM0NzdY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8K73U_1793872181;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8K73U_1793872181 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:41 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 15/30] ocfs2: abstract the chain list next free record check
Date: Thu,  5 Nov 2026 17:49:11 +0800
Message-Id: <20261105094926.3203416-16-joseph.qi@linux.alibaba.com>
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
index f3ee6491c141..88284a64cf49 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -228,6 +228,12 @@ static bool ocfs2_dinode_has_bad_chain_count(struct super_block *sb,
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
@@ -1852,7 +1858,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
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

