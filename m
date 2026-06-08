Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7348A3C9892
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Jun 2026 14:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780927629; cv=none; b=qR5Se95gfrAVcU01kM/YZ188M0njooMFeFfFAc7WRjqX7I8hmHpIiw4Xj9x17P+EoWNpFdQLL6If9WcL/DhVNFNrL42zJmueatQ4SFqd8nAKznHZcxOT6yyK+JmvKBU+jebPuD8xVFWq6cMf0BByB54jdF1gQbAoZQX44ombUH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780927629; c=relaxed/simple;
	bh=z/5fWos5ldIj5zVi7dE5BRgICPZdQyJZ4W1Mhogzmg8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YxlIGkyqz9jI/R7yUUIJ5xIb9xshIOPoenRp+DOuQ9rEUQhcL6MhAWWRKfRoqMiteJf2c0SiuZC4vqT6KkSE1Te8E307Bdp8uQsz8iAs1dTZjAjOcbR/20RsiS4MaYDuzUkdTYhAWRUI8iEnsEUkkRBxuy4E5a2u/9zoxguELsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=m9IAo8ls; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Tt2v/Zu6; arc=none smtp.client-ip=202.12.124.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="m9IAo8ls";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Tt2v/Zu6"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 7E66B130014B;
	Mon,  8 Jun 2026 10:07:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 08 Jun 2026 10:07:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm1;
	 t=1780927625; x=1780931225; bh=eGP0VdosSyktWL8BNAnyvvvi2s7k8+Mn
	weM2XDOWbHs=; b=m9IAo8lsUk8NjFOcKYlkGLNMJmcWrL2sau6ILSWgUhRwwNzV
	5egq+HNvViUBMUKMf7L7Ts0rUimvA6HOi8mhSrT4RXhatia68Vw5lMAXEq8jNmh6
	+OOmRGELTpN0mna7NlLt1IbfBwKEDp7PAVPgFvluO4GI+RjmFufg21nnWW5ELZdl
	jjkmsFakTImOfO5t52eFeZiXnhZDKCRALJ1XiBEPMU6KizmVrm4XWWUxI7uM+748
	7AY+KBJfe7Ng56262AaaWqDOVbUzDXOSj3Vl7VBAWARbXh2vMiAilNLwjhyA88Zo
	/anNSigHQEeVWRDxRM0rd9fQI8b864DTfzCJWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1780927625; x=
	1780931225; bh=eGP0VdosSyktWL8BNAnyvvvi2s7k8+MnweM2XDOWbHs=; b=T
	t2v/Zu6GHCJ+Op7fKvFiAPGMPM/8St50oY3RYXw0KZFI4/sXW1H2a7Tl/9OGDXxq
	O91hZWX9AApSbwQILLN955Q/GY+J+dD0VKRw80/lzv3V7OWw+0pQUeyhjUGJ7zUa
	Ap6ZlcBpyNjsHhHTmwrHXYNHd/c24Vegq5EmKS2WPf1Vwm1gWMVbcQh5+4fEFCL4
	mYprpVGm9LSOq5Ir+IXvr7lWCdoOvL0dypPByl2saBc7lZl+YuBa9geOMB/U9Wh3
	TUfcG1+iVioZKi+FmaLEYbbjorVjDagbWzesc8oJ0Ij0KF+jRx7N+A7PwomuDj8E
	8g68XJllfo+I/LuVYtBsA==
X-ME-Sender: <xms:iMwmavTJuhe1nazyAzA7r8n1MATpyV_YhoPjUehEcCU9sGg1RUWW9w>
    <xme:iMwmapuO5bR7nl69m8uZPCxAGlRrUDZQ_nKWeFluka_LlgkFZLcYcpgopleJRnsny
    LF337CaDnatvB_IAWJJG7IiCTlZUkx4CBfEQYrB4CMJ5dAptQs6vA>
X-ME-Received: <xmr:iMwmagZC-no2ZJLkz5TykOStkY9gcbYEX5PDgzryDzLRKx83hi4lHtAn8lY>
X-ME-Proxy-Cause: dmFkZTE1/slJ71k28ujPPBppLrD1AVh4lmRvUHwON/rWUoi26EV768C6JayedMYoVQhwKd
    n0gYztzb4qucxO0DsFd6XRGfqmvoJn5bzNKOrfy+2ltnLKP9/D3khnbO/0e2V2RpxH5Dcl
    l3BTqV7aecrFFixtCAS0JQ8/6x040hX32981QdPwCdvQmgjHZDfSd1paWy55KAVnCU0Xeh
    DDeQO3QxaOls5TdTPJ4c25iAV5Wt8anEBwJJTevs/W29LwRnQAhqaWX+AcMG65iiFUBmJF
    bFfrMK2RacV6BPNS/pRVVBFhDw1YOpebuGXJZXi34I2aVxvw0Xae8gGyd6Lv5WX1HmIEn/
    uKGBRAvZN7/GDgdxLq5j2xACFDyBxOFB9XCpc5xgZP8HhrIuk4bCHkUCxnmrcKafZKDMgH
    Y/Le3906RZcz8Hqzj6MCXCCc47vTju42seh3LFe3jd8p+66gyKpgzysIKUMKQvU0b3kT9O
    vcFY0PFbdBOm6/KaI2qjg8xDXNZ+kqdnMEm0NAcmJ3pXZCJWKwyhlOchPa5Fza+7DBRtO5
    MGkV2/U5eAzT3FmVjgfsWcAxGT1yC/vp/pyzmucGYfzXKVUwBkgqMaXnnJloXkCEs2oVjO
    wlW38XDcJKzKMGxwsmgIDnRdPob0kB6d4o3oNS0BcUBvqRjdFSpYpQJ8IjRA
X-ME-Proxy: <xmx:iMwmavHB2Dz5pQXVC4u6TSuQKtIcgLlSTTjt63fX6Ct1hpfPAmG1Pw>
    <xmx:iMwmakx0eLcT5jLdxDhX1IrLKfQC7J2R142pMTlBkZZzS8u0mOqAJQ>
    <xmx:iMwmahk8w1iqAI1L6P942_XvJGTjoq8BfK3aeost7MkTkWSpEhIugg>
    <xmx:iMwmatnboK6nN7Epp9Z5QRUMN7jGo9Xk5nwLXdadQR3tEjGrg-Lo2g>
    <xmx:icwmaj9pKU3Ti-DUHpk11sN9bizrYmv8KPK3sPfhtPawkqaYP9RmlUKx>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Jun 2026 10:07:04 -0400 (EDT)
Date: Mon, 8 Jun 2026 09:07:02 -0500
From: Ian Bridges <icb@fastmail.org>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH v3] ocfs2: fix UBSAN array-index-out-of-bounds in
 ocfs2_sum_rightmost_rec
Message-ID: <aibMhhAH-swS38i0@dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[BUG]
On-disk corruption setting l_next_free_rec to 0 in an inode's inline
extent list triggers an UBSAN panic on the next write to that file.

[CAUSE]
ocfs2_sum_rightmost_rec() computes
i = le16_to_cpu(el->l_next_free_rec) - 1
and accesses el->l_recs[i] without validating i. When l_next_free_rec
is 0, i becomes -1; when l_next_free_rec exceeds l_count, i falls
past the end of the array. Either case violates the
__counted_by_le(l_count) annotation on l_recs[] and triggers UBSAN.

[FIX]
Validate the inode's inline extent list when the inode is read, in
ocfs2_validate_inode_block(): l_count must be non-zero and no larger
than the inode block can hold, and l_next_free_rec must not exceed
l_count. A corrupt list is rejected at read time, before the b-tree
code can index l_recs[] out of bounds.

Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
Changes in v3:
 - Update commit message to use "inline" instead of "embedded"
 - CC stable@vger.kernel.org
 
v2: https://lore.kernel.org/all/aiLNd9gAuCC5u2jf@dev/

 fs/ocfs2/inode.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index a510a0eb1adc..aff95efd78e7 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1559,6 +1559,38 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_extents(di)) {
+		struct ocfs2_extent_list *el = &di->id2.i_list;
+		u16 count = le16_to_cpu(el->l_count);
+		u16 next_free = le16_to_cpu(el->l_next_free_rec);
+
+		if (count == 0) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_count is zero\n",
+					 (unsigned long long)bh->b_blocknr);
+			goto bail;
+		}
+		/*
+		 * The exact capacity depends on i_xattr_inline_size, another
+		 * unvalidated on-disk field. Inline xattrs only shrink the
+		 * list, so the no-xattr maximum is a safe upper bound that a
+		 * valid l_count never exceeds.
+		 */
+		if (count > ocfs2_extent_recs_per_inode(sb)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_count %u exceeds max %u\n",
+					 (unsigned long long)bh->b_blocknr, count,
+					 ocfs2_extent_recs_per_inode(sb));
+			goto bail;
+		}
+		if (next_free > count) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
+					 (unsigned long long)bh->b_blocknr, next_free, count);
+			goto bail;
+		}
+	}
+
 	rc = 0;
 
 bail:
-- 
2.47.3

