Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872192;
	b=PS5mEWKF+M0nJGme0okjeVqEgQUh31//fxumYOdNFeCRgCXV56xo3dDcxGE8J5CUi6Jw
	 49i6biJ71gKuB7fiKJnTk4eWxZwsKv20woGZLSjP0Nawfituh/Gyu8BXPZj0gwLAPJXKK
	 CQWnt57RMhbqDXma1ZmVr59wnKWdJUlIoi+/jaBPRdEdNHZ3NKyDruukGAxMXU1jtDOrg
	 Q4s3nW2kZqS2/IeD0R1OYPH5bRMtRT/0tN8BGa9alaO3wTvZaQGdTjJtNBzCFIjGcFifY
	 wLUNdwJ2IrqCVMNrqlqjDEw/SreIxLGiEWGs5ZONqt1TCpXVtb/Orgccq6V2XOudKlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872192;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JoB4W0U1N8S7kb+JyhF/wcdtf7y1w+y8O0idiiO+Ix4=;
	b=fOrytcR7HVSKCma505ZoEXCNbembx0N3jreOSNMd8YI8bJNFKA8hMJmLhoJTLfOh0EXp
	 PRMnXfQinjF/gPr2/mChY5QeT80LXC9ndqW+QbA1t+gbDj8G91TnP0YrB20gKQpJXluj3
	 +KFO8vgxhc2ROsX1n7EG2baycXbHrfqTSCzVlD1cnmA9NyOJ2gakPNbEIcOMpmkHiqpkD
	 JNxu3ARqtgg5R0BJuHDajVn7z0I0OB/f07VGA8lRXrMYl11pI2kR8Za7xpvXfDHgL66pU
	 5XFgZKPVpfVcmRtYtpxix2u1O5f/7KRxrc40V0AffSJvv5/6VJtBgBRQPBl2E/DJclw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fvhTHDSz;
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A197260A2605
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A197260A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fvhTHDSz
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872183; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=JoB4W0U1N8S7kb+JyhF/wcdtf7y1w+y8O0idiiO+Ix4=;
	b=fvhTHDSzSGZtpIaJ5FfuE2EBHOalvQFtGinyCgjVsZ/3mVwRmj3vnxsl7aKarIKYgz+rS1OSDtieSApUkzMxTPNhiwrlDl0T1K3GCsJzBYcnQUeQbJVGjSkSXHj5UYv8dJ3GX/vbcP31bMwzwRm0f30gHl3Ap1YVGnI00LKrzj0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8QR4f_1793872182;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8QR4f_1793872182 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:42 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 16/30] ocfs2: abstract the chain list bits per cluster check
Date: Thu,  5 Nov 2026 17:49:12 +0800
Message-Id: <20261105094926.3203416-17-joseph.qi@linux.alibaba.com>
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

Fold the cl_bpc test into a predicate that computes the expected bits per
cluster itself, and drop the u16 bpc local from
ocfs2_validate_inode_block().  No log message prints it, so keeping it at
the call site would leave an unused variable.

The two bitmap_blkno conditions are preserved: the global bitmap inode
itself is exempt from the bits-per-cluster check.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 88284a64cf49..7f3995ca771b 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -234,6 +234,16 @@ static bool ocfs2_dinode_has_bad_chain_next_free(struct ocfs2_dinode *di)
 		le16_to_cpu(di->id2.i_chain.cl_count);
 }
 
+static bool ocfs2_dinode_has_bad_chain_bpc(struct super_block *sb,
+					   struct ocfs2_dinode *di)
+{
+	u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits - sb->s_blocksize_bits);
+
+	return OCFS2_SB(sb)->bitmap_blkno &&
+		OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
+		le16_to_cpu(di->id2.i_chain.cl_bpc) != bpc;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1849,8 +1859,6 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 
 	if (ocfs2_dinode_has_chain_list(di)) {
 		struct ocfs2_chain_list *cl = &di->id2.i_chain;
-		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
-				sb->s_blocksize_bits);
 
 		if (ocfs2_dinode_has_bad_chain_count(sb, di)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
@@ -1864,9 +1872,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 					 le16_to_cpu(cl->cl_next_free_rec));
 			goto bail;
 		}
-		if (OCFS2_SB(sb)->bitmap_blkno &&
-		    OCFS2_SB(sb)->bitmap_blkno != le64_to_cpu(di->i_blkno) &&
-		    le16_to_cpu(cl->cl_bpc) != bpc) {
+		if (ocfs2_dinode_has_bad_chain_bpc(sb, di)) {
 			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
 					 (unsigned long long)bh->b_blocknr,
 					 le16_to_cpu(cl->cl_bpc));
-- 
2.39.3

