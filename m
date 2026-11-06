Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963712;
	b=n6SB0DpYLzfGQdLYj4ZHxJWuHbgJKhm0iVpbMO8pVd2rAaAiNIUt9yO4CG6+j1gpq6uB
	 qWyj5NI3P7ggQgV6qpmfzyrpuP+fbgZZ/Gh/NLcLPBsJzzT2C26toFRpQpSdHjVMiRQAo
	 CE3lMr18rUWEupE5D67YyVcvCa5mLFjQdvXKikK8aUQ4G2W6mU8GOWjXzSwxJPxLPzNeG
	 ehOXKBbL4L7whRb27ziiT/9nwmxgId/kSxWmi2rXp2fKqvhjPS/SEGrJP2Jon3R1aJKxR
	 ey8xWQG3N/XLxw2/B6fcr44aOBqrDf05ApNw4nDyicjJVWr/VJ6wUq36KRoX02tuYBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963712;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wXb0GXyopzIAevJI4IHfeJICZevtzJ1G9faTYp+IM0M=;
	b=SsLbLMkQ4+6xsEXGS4EVlcwz43Wn9vhpE4ai8kKjOlVbGsyFfP1nXADbpyIEmTreFeIy
	 Gse6wSxbBJhv+WLH0lMGgbwGQQ22DAiCNkVB4Z0neyr3C4QVjvglV3NyH1v0bnMQnPsfQ
	 C0TujaANEE7hihpHfmtEILqX0thC9+BJFeKFHTXmtyHZmLOcETkepCQKC5j77AxOmsaF2
	 qDWGrvDhWDogASGHRVTEH7tqRP8Wpp2yWJbiJLugiC+cGFTfxu1kYs96ofAkfakeXcvi3
	 JznRz0xgLcyCfbYkFkG7EmecJ0ZUwV4Sc+iUOXvRGMB094liGrfMg5IAzYb0ML9oBWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TJr9bfWk;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C73E606D81F
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C73E606D81F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TJr9bfWk
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963708; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=wXb0GXyopzIAevJI4IHfeJICZevtzJ1G9faTYp+IM0M=;
	b=TJr9bfWkkwxLzIcEPLkSaXvoFfEKknk38aQSIpe/YAca5y+hIop7dHRNRqARM1qzRRpFQYxpI+S0Seu6DQ0DpP+WRIo43SLeZozHdqumnS/u5YuWsea7sqR2GZWawtACw0bscSzxYx5g4Z07ycfiNMhn4CWMhyJrJBBB/lj/wAo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBd-4-_1793963707;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBd-4-_1793963707 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:07 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 09/31] ocfs2: abstract the dinode DIO orphaned slot check
Date: Fri,  6 Nov 2026 19:14:36 +0800
Message-Id: <20261106111458.1467464-10-joseph.qi@linux.alibaba.com>
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

Fold the OCFS2_DIO_ORPHANED_FL guarded i_dio_orphaned_slot range test
into a predicate, mirroring the orphaned slot one.  The flag test stays
inside it for the same reason: the slot field is only meaningful while
the inode is DIO orphaned.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fd9613a95802..17d546a9245d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -124,6 +124,13 @@ static bool ocfs2_dinode_has_bad_orphaned_slot(struct super_block *sb,
 		le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots;
 }
 
+static bool ocfs2_dinode_has_bad_dio_orphaned_slot(struct super_block *sb,
+						   struct ocfs2_dinode *di)
+{
+	return (le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
+		le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots;
+}
+
 static bool ocfs2_valid_inode_mode(umode_t mode)
 {
 	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
@@ -1628,8 +1635,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
-	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+	if (ocfs2_dinode_has_bad_dio_orphaned_slot(sb, di)) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_dio_orphaned_slot));
-- 
2.39.3

