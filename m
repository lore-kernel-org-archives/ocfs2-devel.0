Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872186;
	b=FKfU8VqD/VwP0wBDgOP319yMl9vF8LeRu+o9tf7iL2SeoZ0Dl/67eBGKNwUIqiMmaUm0
	 //c5H/NnIM2wJIQq4EmHZm1Pc2mUHV0zwx1eh6PTtX2P/BaD8O0Zk4VIxbh54EJuDGw3k
	 PLigUjkg7C5THehNSBl6PjfkY7iBYAwfdMzdk7xNfOFeaENSfwrAzIfapMYijJayJUVOb
	 dzg4v7qX+B6ROml1bYHbowsJ4rD48fRypNyJD9n+vAg583x2VsPIYSnK3ZyaSSXVQ+9Gy
	 +kwdrh+sEHNTQpPUHiGPJbDQ625gt+nf98jE8JXaL2j3x0llPtjl/NVDZoHdJGW/Q1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872186;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Kj+IrsHv6uypmyJsZPGLhfg1J8Psmd0imHUPlr558Kc=;
	b=ACmA4GTmK9Kgfg2676w4HrQi3RD5aozbTkjpOedFLSItTVcLDGzomLT5Od1SdpXaP5Fa
	 NFpk2FZDMFMtySWrLPheAOu8F+OPwWLIsFSKi0rPo/Efnl6flcx2lve39yed/8K40Mym2
	 7uzYb+OEezDcVM7hVfutQ+qlRQK+EIslU4PJAKLaK1BNFa4hTAJJCIVqepbsQOvvOmQBW
	 hg8sM6niCzZRdoa1d+tAAWkxmKyYYKGbOsnTCvCnRCrTCh79C2AhVpVjy1Y+CBUI9m4zx
	 F2ydvHkDVjtIoeypogfH7YdIcHrNdNmRA9DvdOP/a5dAcAe8N45WPM8KAncMz4wRQKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QvFHU1a4;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F876082BE8
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75F876082BE8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=QvFHU1a4
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872176; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Kj+IrsHv6uypmyJsZPGLhfg1J8Psmd0imHUPlr558Kc=;
	b=QvFHU1a4kdBqsaWluCR1uIHCrzFcOZS56VrKC707aPwYV499zgMXmgrnoKXDBwF/3vIEjC90XEwY10aD1wcfkupaKMU6p5AFI31R6gqEOVLA3SlvWB9Krhq7dcNEyq89OTzwMCD4z3y86XEo2KQavHkWAZB5s8Hj/A9ewCVO+CM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8K71J_1793872175;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8K71J_1793872175 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:36 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 09/30] ocfs2: abstract the inline data dinode guard and cluster check
Date: Thu,  5 Nov 2026 17:49:05 +0800
Message-Id: <20261105094926.3203416-10-joseph.qi@linux.alibaba.com>
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

Introduce ocfs2_dinode_has_inline_data() for the OCFS2_INLINE_DATA_FL
test that selects the id2.i_data union arm, and
ocfs2_dinode_has_inline_clusters() for the rule that an inline-data
inode must not also have allocated clusters.

The guard stays above the sub-checks: reading id_count or i_clusters
against the wrong id2 arm would produce false positives on valid inodes.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 8c23170bb595..96e4d5c5bfa8 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -154,6 +154,16 @@ static bool ocfs2_dinode_has_size_without_clusters(struct super_block *sb,
 	return !ocfs2_sparse_alloc(OCFS2_SB(sb)) && S_ISREG(mode);
 }
 
+static bool ocfs2_dinode_has_inline_data(struct ocfs2_dinode *di)
+{
+	return le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL;
+}
+
+static bool ocfs2_dinode_has_inline_clusters(struct ocfs2_dinode *di)
+{
+	return le32_to_cpu(di->i_clusters) != 0;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1715,10 +1725,10 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 	if (rc)
 		goto bail;
 
-	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
+	if (ocfs2_dinode_has_inline_data(di)) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
-		if (le32_to_cpu(di->i_clusters)) {
+		if (ocfs2_dinode_has_inline_clusters(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode %llu: %u clusters\n",
 					 (unsigned long long)bh->b_blocknr,
-- 
2.39.3

