Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4861240E8E1
	for <ocfs2-devel@lists.linux.dev>; Fri,  5 Jun 2026 13:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780665727; cv=none; b=BzwgeIY2hRI3l0Igtm4Pm8KrGNIPx5tZvWXzLVogft7Ixx+LJjHC0VmZY+74dCXsIIKZ9kObtW1YexAhktESRd3wXxZ0UYvkEEKM7Nkg63jiVovhjrXY8TcOMk1r7AxH4ZFWfF+jViWyUjF2PhC+N1zUZMklLYax71884S859+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780665727; c=relaxed/simple;
	bh=ZMc0YHCL3jBWEQ9q/iyqLD0EHASUwjFrcbK6yzrL434=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WAV1OCmONQBt19ZS+Rzf5eXxuOeIG4flbmzLPiGYFkwwyHCE2zg9Uhhz86Orzizh4L8ONOfEG+qSR9AsG8QRRDALxzTyJ6K2TCYSi5cgnfOp7uxo6DEnOGJhCZ/drl01a6XY6+1+3O4ole3y25yp4cscVLPB3nwZhWngr/f+E9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=Bm39jOCZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WmupngsX; arc=none smtp.client-ip=202.12.124.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="Bm39jOCZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WmupngsX"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 3814C13000D6;
	Fri,  5 Jun 2026 09:22:04 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 05 Jun 2026 09:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm1;
	 t=1780665724; x=1780669324; bh=wc0cu37DUdGnV2HKXGVGY6xUIWFZmCha
	b+xPbvT4Tdg=; b=Bm39jOCZcwt4V8mZKGszvTlre04KxjEfbAvP3ivF9B4X7Dsh
	NqCFPvGKHGaTxYVHyh0To8MysF5Ik2ao1OSpCiEAZjuEU1JzPlWcUiAFsYtrqVCW
	LMGUlIunk0rqv8o7mj6/Ubijaz0tCiMbUFxLHoD0QKqyM/rAlUbeO81RLdoPPks8
	92x9C7x7kbk3tLREREG3zsMFDdBZKjRYW0G64xMiXSWW+wWAjp202A81bmam+GtC
	b3fBwzm43aLnyzC+AQ+ZVVmAKbisMtiKpByzaRueO+StARRiopkD5NO6KlG9U6tM
	KS+1fg7CpDqY/sMkJ2tU8nzHtwGJXRINvk3C3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1780665724; x=
	1780669324; bh=wc0cu37DUdGnV2HKXGVGY6xUIWFZmChab+xPbvT4Tdg=; b=W
	mupngsXW2apOZkw/x5fhKJhbCFCPjUlp0ijKjny3WaklR3FCiBfXA6uIaqJEnbae
	SJ+w9slW1skcXGpbtQy9pLkcMsmdf0eadi4R8rdLm3T8PMcG7HG0JZV97I6uXUPP
	Pp73c3v1rUtV37uZonLhcX5PaKWNGSFc84wQo5aLBJuCfxJNYhN5ioE6JK9KvcRk
	SQj9KlYXSktJCHGPXpa+BpEGOLdHDLps6JYjaReKWewUKiFvxHqPZHLzZcexN16W
	ftccpAKKn3XJsHCrwr8Nzr9bfYazBWmZr3j99z5vo0zQ9JFhoPtoVtkDKLvoyXHk
	DH2/bWT7XXJ2l7ADss5KQ==
X-ME-Sender: <xms:es0iaqhYyZ6TgL-xY2EO-0VfjA0A0xnJWF1d9jGdSiuMLnwg0j8jTA>
    <xme:es0iaj8JPvCK8M7-hCU-DyqHsp3BKHaVYeAMZcCa6PBjFYDuACYdYLRemUSs547GM
    6c8AoZFfrefQdzN3aAoaSm4zePg55ACGpDIg5sa70-boMlsvEjUAA3I>
X-ME-Received: <xmr:es0iatrRBYVNul5-OIYOdcqHrTu_HyeyLOvIhmMxdk46GmTVigBBBvilUDY>
X-ME-Proxy-Cause: dmFkZTFBZ2QUcKq2zNAiZBYlIBioHg9K9gIjoGpvG/6pSdTGIRxqTaI+V9wdt6jVgZLcjJ
    /0xdHupIa6UXa8GL/tw1QvyvF/mwAVb31TxoljDr4Lguejq91tZFHaAwDDKLStwjNV84yK
    uSh8HvNMwjqNkz4AkquieAJlkkCbxPP5EWRdgESfu+MZf46eSbwDk/vshsR6Wk96uyYhxr
    GxuQ4v4ph3AJ54EwINtHde5dm3v5KX40KjojAc71aH+5ugaUFabWyeCKeiLconZfVW35pH
    /Pn9k00WLj4JB0ixaGW92CvcMO+2hW4j8gO0epKg1U8JEZZxWAxOI/f6zO1/upREOtm6ij
    2O3MvSBIMW8239AsPwQh3pLczlVQ33Gz2JfidokVv5KfJ4B90eQ/jpJ18tJoBa6v020vHl
    N8jiiKoqxgSoMEROkC96sPiPdMWFVcJPPRUgWZzXHJcCih7fQTDFDXZL1LpRxIMuhTwRMv
    N/o7+t4o4PDXMhCQwWSFkpIqdd3GQHJ9wkwmFQOasPKTqB3Fh2Jb7SP+7eEp+C942HY0Mh
    iN5795Z4AD79Z7vbCfYskUJmmTmCXu6Mo5teZUzifCf9gC+xFqlWy/ZuC64jDWLCoUA9MQ
    AQ7FgUuNo05A7zHzgRGqf7RaMeB1z1QXRMVuEdqZuo5xJWjrN0mn3T4Vgt3g
X-ME-Proxy: <xmx:es0iajV3bVbZh-7vFlyqRsed-z5hZBMo3nwgc4AIHSLA5sKfhu3M2w>
    <xmx:es0iakC6VEmUAK2Bwxv-NFhCY_Wq7id1g_eUH0Jky-JE7hFlqfDdNg>
    <xmx:es0iav08Vm8r1EDJataew_1fNta-3d8STw-4nr0J9puhLhyDvHyftA>
    <xmx:es0iau0UNegfbzdMwasajQuVTwctYuRF96gctnG1xtCTEnMhrKB8Bw>
    <xmx:e80ialNDRCfEz8e9Hoh9_VhFuVF0lOKFwk3Q_s3la5PSM-r3MICbr7Pw>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jun 2026 09:22:02 -0400 (EDT)
Date: Fri, 5 Jun 2026 08:21:59 -0500
From: Ian Bridges <icb@fastmail.org>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ocfs2: fix UBSAN array-index-out-of-bounds in
 ocfs2_sum_rightmost_rec
Message-ID: <aiLNd9gAuCC5u2jf@dev>
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
extent list triggers a UBSAN panic on the next write to that file.

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

Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
Signed-off-by: Ian Bridges <icb@fastmail.org>
---
Changes in v2:
 - Reject the corrupt inode at read time by validating its inline extent
   list (l_count, l_next_free_rec) in ocfs2_validate_inode_block().

v1: https://lore.kernel.org/all/ah2ljwKRw-Xsi4Ga@dev/

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

