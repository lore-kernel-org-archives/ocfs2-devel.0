Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521277;
	b=TuNhnXnQfnPFMtb+BIwCt8ESMVNG8hzrbxiDHfgFMVuOR9JNgYGvU812FJv3gKKyQN+H
	 fY6a9yNFEZzh4sz5G97I8VZwNDjmC9I22zhB7C05y+oahW4IXSFSEEHLv/U4AWosexn3D
	 /HUrivEw5DErcnkH/OvKglove5dV5xRVu5BfjmlMui9Yrnz+RaNBRFkhEwEyGOOR1q8B/
	 THdlodpBZ9HclphmyY+sgCQhhmKOxP54OtPQZiH8eQMucL3K3Lsl+y1UiMPDSNDDGN2iw
	 xxkOFx3kYmSNABPwtqH57kwUKBBUSGTCkd4l4XtIesM9VmBKMVl9kxriUzOFuKsvkQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521277;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6ltJ1pW0PzJoIGvio6joo7Ad0slsGETinD5fSZDgy8s=;
	b=Eo4DJ4GDa27va0f4mKnxpeOxyKS5q89t6MUlCHhKrUx9mDfm1mzaVETbadJfL10zgLki
	 ltXq6sAnd9O1K04fz0rlfWM5nHtFfxRlGaMKaLSQYNxWuzR4+YLuqXV9C8E0WqxY1tdiO
	 mnZeGaTVMiPsecUtf5zhibZ2wh64j588zNVmOKUQ09b8/pwW23hVh/aPGjkpSrUg6M4ET
	 NMytBi6bzKmwUOHjAF5Qh2/1Ez59wdVHGCURLL+eS6237n56Ta6XJhB/Vb6pVg6nDiZQy
	 P0YUHmosujEnyCGe6a4rf58B9YgmdvTyoKSXxK6rVBlvWlJZGSe4a/dDyc0IdHq0iNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="MyNVq/NR";
	arc=none smtp.remote-ip=115.124.30.113
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E409E606A68F
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 11:54:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E409E606A68F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=MyNVq/NR
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795521267; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=6ltJ1pW0PzJoIGvio6joo7Ad0slsGETinD5fSZDgy8s=;
	b=MyNVq/NR1NdDgfqv1B+X++xr6Y1lcHgbr4Y1rde0U09H1AIHaZ6HVRB63KetfP6B2dyNCVS4YenKUM38oDKXY+zAR9tRudy6kMJ4n+95Jg5PENoiimzOjD8Y4WMQUwqSl9DjiqTB4NyZePsGXHEWUD1uI+/4Vmefv22q03w6bKY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XFOMde4_1795521266;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XFOMde4_1795521266 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Nov 2026 19:54:26 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/3] ocfs2: check chain allocator clusters per group in online filecheck
Date: Tue, 24 Nov 2026 19:54:04 +0800
Message-Id: <20261124115404.2937581-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261124115404.2937581-1-joseph.qi@linux.alibaba.com>
References: <20261124115404.2937581-1-joseph.qi@linux.alibaba.com>
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

The online filecheck validator reports every dinode condition that
ocfs2_validate_inode_block() checks, with its own message and an
-OCFS2_FILECHECK_ERR_INVALIDINO code instead of ocfs2_error().

Add the clusters per group check there too, so a corrupt cl_cpg is
reported by the filecheck interface as well rather than only being
discovered when the suballocator extends the allocator.  As for the
other chain list conditions this is not repairable, so it reports
INVALIDINO and leaves the block untouched.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index e6f89d1e3091..c653b6aee256 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2220,6 +2220,15 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 			goto bail;
 		}
+
+		if (ocfs2_dinode_has_bad_chain_cpg(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: clusters per group %u\n",
+			     (unsigned long long)bh->b_blocknr,
+			     le16_to_cpu(cl->cl_cpg));
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
 	}
 
 	if (ocfs2_dinode_has_refcount_without_loc(di)) {
-- 
2.39.3

