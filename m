Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795521263;
	b=Vz3TgyUvs6QfVjxHL5y/b/Z6Ijxwv3ALn5mHdJYdsXQctWEKC1iHl3PrWN5HKmgacuIs
	 FwL/rs8Ssqire2E3FduIjBzHN3JO/db49MqQK8UTeOfanqGz25gvkQqG2MnqtSQSWe0BC
	 WZZA9ZaVVScyXKYu6fCg9eSduAtIdOn8PCamX89aPS2kmYNHrSs/Y/CzXevWrOCF21v1S
	 1VkwG8tS+cN395hp4kvPYUCPtLvZvZF0Wn079Z5lUNrtaehAFNANiQzb5I8+bJJWjRj36
	 1p8nnOe49x00Y8WFBATyN/akbxxt+fu9ziXULPTFrsFxSL92P3uPKv1HBPEGEZeiXMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795521263;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+LHmSjFHbgyWKmL7yVgkW6mPxr/StaHasiq5EyXuvZo=;
	b=bweE4LpKVExens5wTgFsf7muXo7rXL0eWktNG6VwXXf97fmxRV32a69VHgOdQhuAPB3i
	 SB9sdobO9wUWaATY3fvbf/dC7boY/rAtSXaHac5+F3k7YOF1DCflikMAnNmhHm75e01/H
	 zLnhZ0Y5XcL2gsR6ijwgAW0faDbXSrlqsjofibOGMedmoRGwryeZPwAeTAizxyLIHv4Du
	 gfh0qw6iXBY6KX340nkWJuxRQCnAtiMETRWxPk2DKvo8+2tkzTR6Xvk22aZe426JuRVcb
	 ioOwhZQIi7X1hymZ6XLb4NGebJFUsTuqQlS0s9tDG6Treng+PA8LETnUV+ejVyGg0uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TXoDZmhH;
	arc=none smtp.remote-ip=115.124.30.131
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1E4606A32D
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Nov 2026 11:54:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC1E4606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TXoDZmhH
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795521259; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=+LHmSjFHbgyWKmL7yVgkW6mPxr/StaHasiq5EyXuvZo=;
	b=TXoDZmhH2VIzspWJIzOpRJIe1toQuoHaX90AiSzkiyWiyVDw/bJG0nKj6cdiuL5WAbh8F1fgRBVcp3bX/aq9NKWPR4dRzj9xXi4kDjTnKp76qeioPYFWSrpZCdRUnNXmeieh0fijsVeoHtRAs7IJHEw10o9+2gZvGqoLPcQF8S4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XFOMdbI_1795521257;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XFOMdbI_1795521257 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Nov 2026 19:54:18 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	syzbot+487e39304129321dd253@syzkaller.appspotmail.com,
	CJ <firefly0158@163.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] ocfs2: don't BUG_ON when a group extend leaves too few free bits
Date: Tue, 24 Nov 2026 19:54:02 +0800
Message-Id: <20261124115404.2937581-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
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

ocfs2_reserve_suballoc_bits() extends a metadata chain allocator by
one block group when it holds fewer free bits than the caller wants,
then asserts that the extend satisfied the request.

That assertion trusts the on-disk allocator geometry.  With
id2.i_chain.cl_cpg and cl_bpc both set to 1, ocfs2_bits_per_group()
returns 1, so the only bit of the new group is consumed by its own
descriptor and ocfs2_block_group_fill() leaves bg_free_bits_count at
0.  The extend then adds 1 to both i_total and i_used, free_bits
stays 0, and BUG_ON(bits_wanted > i_total - i_used) fires on a plain
open(O_CREAT):

    ocfs2_reserve_suballoc_bits
    ocfs2_reserve_new_metadata_blocks
    ocfs2_mknod
    ocfs2_create
    path_openat

The reservation runs before ocfs2_start_trans(), so no transaction is
open and no dquot is charged when it fires.

Report the volume as errored instead, the way the missing
OCFS2_CHAIN_FL check just above already does.  The status is not
-ENOSPC, so callers propagate it rather than falling back to stealing
from another slot.  No new unwind is needed: ac->ac_bh is not set yet
on this path, so the bail label only releases the local bh, and the
allocation context is freed by the callers' existing error paths.
ocfs2_block_group_alloc() has already committed its own transaction,
so the degenerate group stays on disk - which is what every other
ocfs2_error() corruption path leaves behind.

Reported-by: syzbot+487e39304129321dd253@syzkaller.appspotmail.com
Cc: CJ <firefly0158@163.com>
Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/suballoc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index 624152e4f7fe..23c9fbb31cbd 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -957,10 +957,16 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
 		}
 		atomic_inc(&osb->alloc_stats.bg_extends);
 
-		/* You should never ask for this much metadata */
-		BUG_ON(bits_wanted >
-		       (le32_to_cpu(fe->id1.bitmap1.i_total)
-			- le32_to_cpu(fe->id1.bitmap1.i_used)));
+		/* Corrupt geometry can extend by a group with no usable bits. */
+		free_bits = le32_to_cpu(fe->id1.bitmap1.i_total) -
+			le32_to_cpu(fe->id1.bitmap1.i_used);
+		if (bits_wanted > free_bits) {
+			status = ocfs2_error(alloc_inode->i_sb,
+					     "Invalid chain allocator %llu: %u free bits after group extend, %u wanted\n",
+					     (unsigned long long)le64_to_cpu(fe->i_blkno),
+					     free_bits, bits_wanted);
+			goto bail;
+		}
 	}
 
 	get_bh(bh);
-- 
2.39.3

