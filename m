Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226938;
	b=QImPWmPsgmmm0UXZ3LPV+rEa22a4ehakdlHILWzEUUO3VtdawEK34nAHBW7Oi6MjQMNy
	 b3a/79YvKLtW1rbIMJQQyIOsKt1KUzI3vpm08UCsQssB1wt02l7QUKyTMlsPIZ6w78UHE
	 z07y9lJ5pOh/Gj5FCqcUMc2timmFo2E/Up+8CE+Rm6Ln9Abhc7nT+1cl50QakhSzRPn77
	 qifr5bcQGzv0+btRrXAmkVrunLxrat98R3VRZ34bVE8PNZtFNWCKJGGKGZdVSb6FAwWD4
	 yhK7BcWTVIhCti3sEHWJ4e4VPOyR6QJhLDMkZDokggBAn58qMPy4m9UzF/majHGeR/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226938;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n1U+v1AX0RoVc8L9Vi913aUxmEmfx6/zWXKDqaiz3X0=;
	b=J/EgArl5VY+1ag4eaxYEf0dcmgqurqc11qVJJnQxJnL6FuRybvuGOqN03CmZiDR94qJ3
	 FXf9MFUuhVchzxMPHSZoTnzbLd8T/8VaYlHh1q38+46iHUVyOXTBRWgNosYfsS7sStkbh
	 yx+qsxleXoGTGZuqETkzipWR3VBpQdC0PwnAfzDlfJombYGH6ugCk7vLG4CPhC5tMcK3S
	 MsPIf7C+Btzb0j2gzlO6CAgXFOtVDim9X8MpV+Lkk4QNDRfeeuBRdeliHhvERLcQjYAg1
	 vGO8a8nSClVy4tlQuUGaneLLBejqPiobkqlDKiYGHhXh2sCiUfCiQUzhMDZKiENoUvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gvn0tX1s;
	arc=none smtp.remote-ip=115.124.30.130
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8B7606D82A
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E8B7606D82A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gvn0tX1s
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226933; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=n1U+v1AX0RoVc8L9Vi913aUxmEmfx6/zWXKDqaiz3X0=;
	b=gvn0tX1sC2la+JAAy63KWxbXdbhjRzl0L605uJM6wi642+4sgFqSQ8jgXImbS8CV+fjRNOxWVc80gtkUcO9ubkQRRWXTTsl0rhOkGubSB7VM51djluYfoLnXQt83EvAXgJCoQXM+ZtxmgBZWRqNvF12FZyFHV5dTS+IvylfybmU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOZNnc_1794226932;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOZNnc_1794226932 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:12 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 27/31] ocfs2: check inline data dinodes in online filecheck
Date: Mon,  9 Nov 2026 20:21:17 +0800
Message-Id: <20261109122121.21473-28-joseph.qi@linux.alibaba.com>
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

Wire the inline-data guard and its three sub-checks into the filecheck
validator: allocated clusters on an inline inode, an id_count beyond the
space available in the inode block, and an i_size beyond id_count.

The size-without-clusters check now needs an explicit goto bail.  It
previously fell through to the bail label because it was the last check;
with checks following it, a later failure would overwrite its INVALIDINO
code and report the wrong reason.

The id_count maximum stays a signed int in the message.
ocfs2_max_inline_data_with_xattr() subtracts the unvalidated
i_xattr_inline_size and can go negative on small block sizes.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 1ae42ac245cb..e01c3078d974 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2105,6 +2105,40 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 			     (unsigned long long)bh->b_blocknr,
 			     (unsigned long long)le64_to_cpu(di->i_size));
 		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
+	if (ocfs2_dinode_has_inline_data(di)) {
+		struct ocfs2_inline_data *data = &di->id2.i_data;
+
+		if (ocfs2_dinode_has_inline_clusters(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: %u clusters\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le32_to_cpu(di->i_clusters));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_oversized_inline_data(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: inline data id_count %u exceeds max %d\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(data->id_count),
+			     ocfs2_max_inline_data_with_xattr(sb, di));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_inline_size_over_count(di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)le64_to_cpu(di->i_size),
+			     le16_to_cpu(data->id_count));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
 	}
 
 bail:
-- 
2.39.3

