Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226929;
	b=UtMr0Ye4a5Upc6hM7j6flvvT/1+vfj7/dvepUPXtRMvEKUgjIrgPpIEqLxGsoO/KU/OV
	 xlQpMeI+Sc7ejWLa+908uHmpJ0s0FYwa2nxBnJRJU4nSkM+7DQ3LfTjXu+2yLdX9WmcQq
	 g4wvNu+fgSWqf9iF1NUokQuhlVm8q1oz/lFDqWARi6HUhj75Jssuvnpqd83Mb0iCNGfri
	 7vWprdDZsUxKWlQ84IAGYlSfohoF32Vf8XluMxfv2g9MgHKWCgivMt3vVcvLw6KnamcL7
	 lIxdHbmy2Y7o9VQTp274QXJkEm4V/Z+9aU30oEL3HjRkf1WLs68kKj/PRqwsGjLmzIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226929;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9lW0G/siDmQa58oRaiQcTBrX8im6OkfGUEyhuDd7WEc=;
	b=OlTFqMJbiDxhvZBzZ11kIeFowWGvhzBU+/IQLZeWKgOKFxg95O7KzI8xiDekIov/ncqW
	 G3Jra4qAOfuIaFaoCZnpLCz+N00lFOmhz6o0ROCzPGz0OARI0AZq7Kv98bLubLxF96bdE
	 ZDFjoeQ1omZEh5NGXytUuTYnPjtX3mZGAaEiai4i9UL3yndzbb03/Uo48sLtQGhW6PkU8
	 1ct7NO2l7oMff3LHKLzFU1801wv7MYsjcBEL19tUotvhXAVa3CIv7DH1yUZAzQ9+mbRJY
	 767ZkInN2Vl4ohoeoNQTWg4FaPIQ7H55wAnCXBGZEt85XMlGejZiM3ntqrudsp8jVKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wcgp1W68;
	arc=none smtp.remote-ip=115.124.30.132
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F882606EE92
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F882606EE92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wcgp1W68
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226921; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=9lW0G/siDmQa58oRaiQcTBrX8im6OkfGUEyhuDd7WEc=;
	b=wcgp1W68WlyypBYoEkFqTcBu2Lf8VbKrzg9F0NCUVS4oQZaIT1+G6HQtt9l2Dvng0HQcY8QrMV6yZrShPwvT1O1EzI0fi6XAK/1wN63Q/FtTC7tGXQwc3VdO6+KS86U8t+KY+0luuMM351ysrYP0pwGMptaSd8XFp6s46wMSzQA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEOZNje_1794226920;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEOZNje_1794226920 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:00 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 14/31] ocfs2: abstract the fast symlink NUL-termination check
Date: Mon,  9 Nov 2026 20:21:04 +0800
Message-Id: <20261109122121.21473-15-joseph.qi@linux.alibaba.com>
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

Fold the strnlen() test into a predicate that bounds the read itself
against ocfs2_fast_symlink_chars(), which is exactly the space available
for id2.i_symlink in the inode block.

The open-coded version was only safe because the preceding i_size check
had already bailed: i_size comes from disk, so an unbounded strnlen() on
i_size + 1 bytes can run past the end of the buffer.  Keeping that
ordering dependency implicit in a helper would be fragile, especially
once the filecheck variant starts calling it, so the predicate returns
false for an oversized i_size and leaves that case to
ocfs2_dinode_has_oversized_fast_symlink().

At the existing call site the size check still runs first, so behaviour
is unchanged.

No functional change intended.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index bf27925dd5c8..dbb4563dbc70 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -207,6 +207,25 @@ static bool ocfs2_dinode_has_oversized_fast_symlink(struct super_block *sb,
 	return le64_to_cpu(di->i_size) >= ocfs2_fast_symlink_chars(sb);
 }
 
+static bool ocfs2_dinode_has_unterminated_fast_symlink(struct super_block *sb,
+						       struct ocfs2_dinode *di)
+{
+	u64 i_size = le64_to_cpu(di->i_size);
+
+	/*
+	 * Bound the strnlen() here rather than relying on the caller having
+	 * rejected an oversized i_size first.  i_size comes from disk, and
+	 * ocfs2_fast_symlink_chars() is exactly the space available in the
+	 * inode block, so without this bound the read can run past it.
+	 * An oversized i_size is reported by
+	 * ocfs2_dinode_has_oversized_fast_symlink() instead.
+	 */
+	if (i_size >= ocfs2_fast_symlink_chars(sb))
+		return false;
+
+	return strnlen((char *)di->id2.i_symlink, i_size + 1) != i_size;
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1812,7 +1831,7 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 			goto bail;
 		}
 
-		if (strnlen((char *)di->id2.i_symlink, i_size + 1) != i_size) {
+		if (ocfs2_dinode_has_unterminated_fast_symlink(sb, di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: fast symlink is not NUL-terminated at i_size %llu\n",
 					 (unsigned long long)bh->b_blocknr,
-- 
2.39.3

