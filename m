Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792854632;
	b=Tc8Nf6Kw0pfyhlnt3zHUfbph5c5rkoZdm834memjgQxE9BT/JkTt4Np7D/gTgPAws9Uu
	 fx7ukphHDWMLQ0OifnedHqQm8jMvQIZ7FRZtJ3gGSdSiLXp0lsQS/nSEaF8AdtoITkVIe
	 /9rzoU9xqlklEKlvt2Gyzcjr21tu8tJdlGeARuIi8qKi4u09w+jXpB8xGlX6sSMd8lT0s
	 B9REbNbfDbQPJZ4jf4L/seDM/2V+pqgAAfeqjZ96g1TyWgx+9TyDonVRQDR9ElQCo4RAi
	 z/l9pqjO0Iy9zIV7SmjyvR8LXGeIKOWa96H0yKudF2zZ2KXh8qnAmdA/Vyb9z9Ko3bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792854632;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZDlcAeojPWg25zmpljtugJi6kVq+0n3tsOpMW2HWI1o=;
	b=mVD39ngxA9Ctiuoj8crRR+0XY2X0UcnzBstqso47WP3m+dZc+nRTKW/xupkRZFmgAGVL
	 TCnoLEvoDdc+HnjwSZxmzKksRxa+ow6N/jbwxKHxrev/5jfkkK41DOBYKFdAST3NXUp0r
	 X5rSo+iK2te4z8XfkdJWVSxPDjMKCCLc1U6RjAhiQli6Exj6lzzw58ebmucipe6yExDzW
	 CUlsf6/dvOj1BLUbY6QqyIdZR/RyqXuGr/R3kgP+KljW44K7Rs7DeUa4hiTNgJmT/iNqi
	 eIycJPx3tA8uPC2yTJwh+BlaOCL1Nf5HKct2KP3TDCvaU8xS8APkgfgRy7ZUnmk7Mqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qGBBI1+i;
	arc=none smtp.remote-ip=115.124.30.98
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61AC606A327
	for <ocfs2-devel@lists.linux.dev>; Sat, 24 Oct 2026 15:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A61AC606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qGBBI1+i
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792854617; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ZDlcAeojPWg25zmpljtugJi6kVq+0n3tsOpMW2HWI1o=;
	b=qGBBI1+iZ9rJ7D0XeJmeyrbrs1jVTR1ZwYaBXMd8qk/F8LE30eCJD7IWpf/OlYo9q6P3xOu+15WxKawmuac/OreBGUGAkytr38p4q/9PQ05MApjg6NNbXMhEmwHsbIHg58yDeTKsWLN6v/T/zYtBPJ3Kbu3Eqm3P3ttWMiSipjA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDONeQd_1792854615;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDONeQd_1792854615 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Oct 2026 23:10:16 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] ocfs2: do not read the entry array of an empty xattr bucket
Date: Sat, 24 Oct 2026 23:10:10 +0800
Message-Id: <20261024151012.1059683-5-joseph.qi@linux.alibaba.com>
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

ocfs2_check_xattr_bucket_collision() decides whether splitting a bucket
can make room by comparing the hash being inserted against the first and
the last entry.  xh_count comes off disk and is never checked, and a
bucket is allowed to hold no entries: ocfs2_xa_remove_entry() keeps the
last slot when it removes the only one, so that an empty bucket still
carries the hash it is keyed by.  xh_count then reads back as 0 while
xh_entries[0] is still meaningful, and the second comparison indexes
xh_entries[-1].

That is outside the __counted_by_le(xh_count) bounds of xh_entries[] and
lands on the header.  An entry is 16 bytes and xe_name_hash is its first
field, so the value read is xh_count | xh_free_start << 16.  It stays
inside the block, but the answer is arbitrary, and for an empty bucket
it says there is no collision, so a new bucket gets added on the
strength of it.

An empty bucket holds no entries to collide with.  Return before reading
the array.

One way to reach the test with an empty bucket is a set that removes the
bucket's only entry during cleanup and then fails for space again, since
it is that second -ENOSPC which calls this.  Growing a value past
OCFS2_XATTR_INLINE_SIZE is the easy route: the cluster allocation fails,
the "!orig_clusters" arm of ocfs2_xa_cleanup_value_truncate() removes
the entry, and although the "growing" caller does set ctxt->set_abort,
only ocfs2_xattr_block_set() and __ocfs2_xattr_set_handle() look at it,
so ocfs2_xattr_set_entry_index_block() goes straight on to the collision
check.

This sits on commit a9ea8b397864 ("ocfs2: use the stored hash when
checking xattr bucket collision"), which gave the collision check its two
argument form and is marked for 6.2 and later.  The read fixed here is
present in the three argument version too, but a tree without that
commit needs the hunk adapted by hand.

Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 2c069029cef7..3a16b4a36d9a 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6061,11 +6061,20 @@ static int ocfs2_check_xattr_bucket_collision(struct ocfs2_xattr_bucket *bucket,
 					      u32 name_hash)
 {
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
+	u16 count = le16_to_cpu(xh->xh_count);
+
+	/*
+	 * An empty bucket keeps the hash of the entry that was removed in
+	 * xh_entries[0] so that it can still be found, but it holds no
+	 * entries to collide with.
+	 */
+	if (!count)
+		return 0;
 
 	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
 		return 0;
 
-	if (xh->xh_entries[le16_to_cpu(xh->xh_count) - 1].xe_name_hash ==
+	if (xh->xh_entries[count - 1].xe_name_hash ==
 	    xh->xh_entries[0].xe_name_hash) {
 		mlog(ML_ERROR, "Too much hash collision in xattr bucket %llu, "
 		     "hash = %u\n",
-- 
2.39.3

