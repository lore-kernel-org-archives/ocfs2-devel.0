Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792854630;
	b=XHHKltNaxg3t+rRYJ48ws1jU4zEpuNSVNlLpomOkOzy4wzpEB5zqcEGretlvbFfLfeGW
	 3znUdazIE+cS6BnwyvaQbGussN4xjjOA2qM1sq6800g8+Qf7FH6ne0v9WVxhsgL7w4GrE
	 s637M8gRy8qVYcAZHr1wuypJzTk0wgtLhhRzlh8+/ah1govMtOUZAgzjwWyYhNf7hjwz6
	 hhbwOoPynHnwiqHS7SIby++wl637agZFA34lTFrjDSP/9y9J8y9HR0A+lIPQusRPZY8mv
	 +lXdJxVrwjWYmQu6lxuV+s3mEMXPMVXT99J79ENP3PXFq8XaznCZLHkgVrPf99XZDHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792854630;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ryanL2dbdeecwzZPf9Ejq3ZeRrQmdc2FE6i0mK67jZY=;
	b=DdiWk2HReRn7aUi3w26QCMS1/7nZTHgTMeNWcgZiF/1ZHlsPue97brBJpxqMB6lITCT6
	 tiKK/o91zDDNuCtC4KH9e656G0r3Dzt/Rtuy37oWs/8qqADlQX+SFLWX/3mUnp8agQ52C
	 F/ka1FBZtW3fsPfzq2w1m6Jrb+Id8s+1evBrOZMYRHFqLuCmxcV/ftHMk6lAlWzyknVii
	 vaXjRG3moXADLlNqotZSM7TbN2Mcy1LqIrKQMMJKCkMS9j2RsJJ57JDO+l3e9j7bajNZA
	 sVWLW0T1HrVBSgR0WDaqdHJ70o3cwDky4LlaehRY/sl/nVAsjnwlJ5KSx0yx8rI2+Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Yrxp06rU;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55F160A2625
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 15:10:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C55F160A2625
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Yrxp06rU
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792854618; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ryanL2dbdeecwzZPf9Ejq3ZeRrQmdc2FE6i0mK67jZY=;
	b=Yrxp06rUQCF5eDYlHBMqDjaApdE1SHXmK4/KZOtTMZJJuQoiv4eWQgC/P1vRhPoJvbqrqAP16DNeZR8nOik4tc7NVJXlO+Yn6VxjzufaexWzk74MWTJqRhIs+Py3/8Ax9d1hPoSfheqBozWkgy6J/U13QpF20RgMFi3DU2aWZtA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDORGhn_1792854617;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDORGhn_1792854617 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Oct 2026 23:10:18 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] ocfs2: do not read the entry array of an empty xattr block
Date: Sat, 24 Oct 2026 23:10:12 +0800
Message-Id: <20261024151012.1059683-7-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261024151012.1059683-1-joseph.qi@linux.alibaba.com>
References: <20261024151012.1059683-1-joseph.qi@linux.alibaba.com>
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

ocfs2_cp_xattr_block_to_bucket() sizes the name and value area it has to
carry over from the block's last entry, so an empty block makes it read
xh_entries[-1].  That lands on the header, where xe_name_offset overlaps
xh_name_value_len, and block storage never maintains that field, so it
reads as 0 and the copy runs from the header to the end of the block.

The bucket that comes out has xh_count 0 but a name_value_len of
blocksize less the header, and a matching xh_free_start that claims
those bytes are in use -- nearly the whole bucket with the common 4K
block size -- while the last block of the bucket holds a copy of the old
block's bytes.  Nothing but a trace event reads xh_name_value_len, the
copied bytes came from the same inode and were wiped before the entry
was removed, and ocfs2_defrag_xattr_bucket() recomputes xh_free_start,
so this corrupts the header rather than leaking anything.

Leave the bucket empty instead, carrying over the hash the block was
keyed by, since ocfs2_add_new_xattr_bucket() and
ocfs2_xattr_bucket_find() both read xh_entries[0] of an empty bucket.
That read is the exception ocfs2_xa_remove_entry() documents rather than
a new out of bounds access.

A block reaches the conversion empty when truncating an external value
back fails partway through: the "reusing" and "overwriting" callers of
ocfs2_xa_cleanup_value_truncate() remove the entry without setting
ctxt->set_abort, so ocfs2_xattr_block_set() sees a plain -ENOSPC and
converts.  The "growing" caller does set it, and the block form makes a
single attempt with no defragment and retry in between, so that is the
only route here.

Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 822b1e9c3ba2..ac41653e59f5 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4704,6 +4704,21 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
 	for (i = 0; i < blks; i++)
 		memset(bucket_block(bucket, i), 0, blocksize);
 
+	/*
+	 * An empty block has no names or values to carry over, and the
+	 * xh_entries[count - 1] below would be xh_entries[-1].  Leave the
+	 * bucket empty, but carry over the hash ocfs2_xa_remove_entry() left
+	 * in the block's xh_entries[0] so that the bucket still holds the key
+	 * it is looked up by.
+	 */
+	if (!count) {
+		xh->xh_num_buckets = cpu_to_le16(1);
+		xh->xh_free_start = cpu_to_le16(OCFS2_XATTR_BUCKET_SIZE);
+		xh->xh_entries[0].xe_name_hash =
+			xb_xh->xh_entries[0].xe_name_hash;
+		return;
+	}
+
 	/*
 	 * Since the xe_name_offset is based on ocfs2_xattr_header,
 	 * there is a offset change corresponding to the change of
-- 
2.39.3

