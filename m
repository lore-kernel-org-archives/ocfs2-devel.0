Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895283A6B8E
	for <ocfs2-devel@lists.linux.dev>; Fri,  4 Sep 2026 11:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788520559; cv=none; b=VhIM5F9EwNVD+gzPrgBCcHcVhhMOq0NJu/03P5fw67o8Hjwm6kMdwG6ysGs7oPJWsySpgCCBMJjhDAg6S+aqYziDX95X6ZXz1XQ7r/oraKUzkSf2TTL2+7YuzZSgWiImb9AfErVw2iNN/JaUQjluqPKkw2iamIOc5h+haDmJ4kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788520559; c=relaxed/simple;
	bh=M5JWKYGSsPINlkG+stDFUMzYh+BCv6ZDngBeKX5wvnU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z0X5etLplmh4qPHCTxZt5GznNIcZI06cseEn28SgLnvYvesCbaYkpmkE8SaUGJXDrIkbnnApkuHWhm0hne+94UHB44K2UAMgHYvlVu5hgvoiHQhI5Htriz8Ec9Bnlsr7PO5izkSighwxzx2X4TVZ2qCk0PZSa1p1aHX9f9lJEc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=olW/8n8Q; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="olW/8n8Q"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788520552; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=wP/FjazOrrhA3Vb9DWVFJsXw0Pz59G95JuhFMHzSZ3s=;
	b=olW/8n8Qcjm4vRJOHuHa2HGsyMADJQiENvzRUh1KvIEUrF9BKrXTK/mVrCDdRVqwA+d3ihWeLIVvcAZTBb1Q0Kq8+oLinC0eHhNQ0KsuUTJt2bea9IU6I/4STh3TSlFWTtGupfUO9vLRRx3M3rX+C5OVFBQd3IR5qfAysHk1Cg0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XAIeC76_1788520551;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAIeC76_1788520551 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 19:15:52 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: validate dr_fs_generation of dir index root blocks
Date: Fri,  4 Sep 2026 19:15:51 +0800
Message-Id: <20260904111551.371150-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_validate_dx_root() does not verify dr_fs_generation against the
superblock generation, unlike the extent and xattr block validators
which check h_fs_generation and xb_fs_generation respectively.  The
field is documented as "Must match super block".

Without the check, a stale dir index root block left on the device from
a previously formatted filesystem at the same physical block number can
pass validation as long as its signature, dr_blkno and checksum match.
Its index entries and suballocator information would then be used in
the new filesystem context.

Reject dir index root blocks whose dr_fs_generation does not match the
mounted filesystem, like the extent and xattr block validators do.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/dir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 6bb6aa133f01..329680b46227 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -613,6 +613,14 @@ static int ocfs2_validate_dx_root(struct super_block *sb,
 		goto bail;
 	}
 
+	if (le32_to_cpu(dx_root->dr_fs_generation) != OCFS2_SB(sb)->fs_generation) {
+		ret = ocfs2_error(sb,
+				  "Dir Index Root # %llu has an invalid dr_fs_generation of #%u\n",
+				  (unsigned long long)bh->b_blocknr,
+				  le32_to_cpu(dx_root->dr_fs_generation));
+		goto bail;
+	}
+
 	/*
 	 * Dir index root blocks are allocated from a per-slot suballocator,
 	 * so the slot must be in range.  Otherwise removing the index passes
-- 
2.39.3

