Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CDC4A35
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Jun 2026 00:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781137399; cv=none; b=PzeJrMoiK2pvp5WZJOqt56HXXBdEtK5WHo4IwJT4guhxvLWpxhR3ybmxn267/MV4961yq05tuqcLu8pDEQl3oKHg2+6cKusTQyy/x/K9yrzfDGh1R8kdI/rMFzLm/QU8dpZsc2m8EDrX0NPJMrXUyDg5ls2IYSL3xwNKyFadNnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781137399; c=relaxed/simple;
	bh=cbLIyBeiRQ7UQFH7zQGjJgAO8/CUpqxgp/yx4/C30HU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=n/JQgbj6S1k6rbbVMyIhDtVYsQplGt5N5avNqKwLWj/RQ5vmonpts4OqB6rhmn1lFWDYf647V+FQpZLvN4AnY0LBD40zjJ3+4KOxHJoDJSmX+Y2ZlUeetxl4P/ZErfSGrThP7nvlNNxp13M2Ycg1cRkj9nMp9wJkBb9040LeFgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=iPJ0NeVB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LN4bLIFg; arc=none smtp.client-ip=202.12.124.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="iPJ0NeVB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LN4bLIFg"
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.stl.internal (Postfix) with ESMTP id B2EF413001AB;
	Wed, 10 Jun 2026 20:23:15 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Wed, 10 Jun 2026 20:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm1;
	 t=1781137395; x=1781140995; bh=ZN1UcjvL6ipXajNG7OLS7jOkQjdBr9/k
	6efK45QJPkU=; b=iPJ0NeVBssAzs4eLG95m+HlQOBlRYL1fKTY0pTeV5hqoyVy4
	7SXGHhFMb0nExuVsR2Vl3beOsjNaWEghFbiPJX4P9ui2aSCWCLjjbzUZelMNvw8E
	ClyvLp1uydH6llgLqcHZjARnAqOloRxMoG3Fk74DI4EgRA7+txZdGZZbZvXZmz2j
	fRKm1sC+LB8j5afBj4ZtukynHac/N29xjUH1u502O8QxuNgnCWOEmQm7REnVf6Pb
	v5bBZcs6di3wZV8kiQ1J8MvZXumHoqnwkn2iPu4DBlVKxq/uIrv/Ic+Z406+YFGs
	/hq0aujeHlYcXrxn9HtGMyMxfSXXiK5hgvuUjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781137395; x=
	1781140995; bh=ZN1UcjvL6ipXajNG7OLS7jOkQjdBr9/k6efK45QJPkU=; b=L
	N4bLIFgd66zG4BpoVZD+4LEecdjd/ByZu4cl4g7ZMlX68mu3dc6b9ugkEtDCE6IG
	SiLG1oEwe+H4jXqR6d2sWfNDKsNzB4TDorWU+DRkpoFM/4XazSeXuWx/3HM/AZQm
	0eK5b2YORqWrNDzwafmK13+29kaD/Mghk1RI4kv3oGVHnD23q9R1f1OcSB4ntiPL
	ywLcF1xAjTxGlLCnMit+PP0YVzc1Vpkf7nxg9QTI6rEV72lL8fU9znEIacG7Rl63
	YjJRK1t/hT++hp0aJZPGzI7HzNebwqVl0EYMkHI76qxfQjeQ6kbzuWoINfpwLdSQ
	mBGQpfbwkfumt9uFUhfVA==
X-ME-Sender: <xms:8v8pag6tWbNSpT_WHZwhVaGHY5LDtl1S_aUcZPQy21E-xtGJ66uyag>
    <xme:8v8paq2cjZ-yuiy4VE4MLcbvJOiWo4V0T45a0HfCOntF-nRIUocwDwcvwHGnzm1k2
    zDRpIfn_k7qPgQK_QHsu1yecml4BKXvKwB8Nl8cxdpPHoUhHjgGzi8>
X-ME-Received: <xmr:8v8parBrxPWuUnExmoR6vRgLfcgNeBxgXqnUIDw33oHGi5wplshAkmRUmPk>
X-ME-Proxy-Cause: dmFkZTGwli7/AGgrqaKrFacd1t5R2l1beyySsQj+8dmEbfCR0SuScN17jn8E4AdfotjuBA
    GLGFxliaxrHGJ939bdIHRsTMuW5Chdo51bZEdAL7l4q1XaeTKR1Q3oupP58mHLwSU5CI6r
    zwqtkyAscBa1b+x20o0O5U9UQ8yxBbkRWtF6RDvNrc+u6QGq6FHhqMjInm7SmF/YioFf8g
    Gt8+e1ave8oewhsci71LgonNlXIr38nnZ2W5DSF9I05fkpAytxg/own5vITqTjyKkhkQkX
    BiA8wpvx5Ofs2Gm/5ThBb2+mG2JGX4J06B0thFAHHIUOzkmF2AzaJnTaaqQvXMhhcpSopG
    gtA7A/lMp1SOcdnGvvY5BQ0SSYVuJfHVGEbouaXemjd7f2utESGOKFZD4zKOyLV9jyuE9+
    YlMy6UAq2zqfUmT6s4/EhT4AjMKrDTtZ274U9sbENRRDRWtXiK4AaryYoKk942DRuwVk+E
    BR8ahBDksLbuPRKeCgnYs4PzmfHI2V7VLiVn55r0ytZFDvi/F9CE3Ou8e3GTM2g2L3EtqK
    8MnNywg0GKQRyBlLc69EJpev7EavFoZI3S8okYwa92VHvfADn3oWnLs1+/yOK1G6tFK3O5
    9+NwtL1RoFHRvuyVT5llUJgjUqCsa49EeAkWHz1UDDrU81vXz8lEVUmRtSig
X-ME-Proxy: <xmx:8v8palM7E_uipbsr3l0WKSaUci1oY5Akzz39r3gcbt63aE_mtU2igQ>
    <xmx:8v8pagYvxCH8KemnEfmm14WhvcCe1pPvYLVDg8jKUG9WsCd6L0EPgw>
    <xmx:8v8pakvZPBTXNvia_mv0YHWJ3t_4SYb-VCLohYmyWOk-MmMGYH0CBA>
    <xmx:8v8paiO2uwri3VSC9P7Q4g2sKTvnzqKWr3rtGMHAgLEUqbv8BaJy1g>
    <xmx:8_8paglE9igwNkX8FvdkD0mlOtIDHbp5O3v0sTRtpphgWt_L8YmT0dIV>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 10 Jun 2026 20:23:14 -0400 (EDT)
Date: Wed, 10 Jun 2026 19:23:11 -0500
From: Ian Bridges <icb@fastmail.org>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH v4] ocfs2: fix UBSAN array-index-out-of-bounds in
 ocfs2_sum_rightmost_rec
Message-ID: <ain_780qc0P4ypNd@dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[BUG]
On-disk corruption setting l_next_free_rec to 0 in an inode's embedded
extent list triggers a UBSAN panic on the next write to that file.

[CAUSE]
ocfs2_sum_rightmost_rec() computes
i = le16_to_cpu(el->l_next_free_rec) - 1
and accesses el->l_recs[i] without validating i. When l_next_free_rec
is 0, i becomes -1; when l_next_free_rec exceeds l_count, i falls
past the end of the array. Either case violates the
__counted_by_le(l_count) annotation on l_recs[] and triggers UBSAN.

[FIX]
Validate the inode's embedded extent list when the inode is read, in
ocfs2_validate_inode_block(): l_count must be non-zero and no larger
than the inode block can hold, and l_next_free_rec must not exceed
l_count. A corrupt list is rejected at read time, before the b-tree
code can index l_recs[] out of bounds.

Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
Changes in 4:
 - Update commit message to use "inline" instead of "embedded"
 
v3: https://lore.kernel.org/all/aibMhhAH-swS38i0@dev/

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

