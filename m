Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C550F3AB5AB
	for <ocfs2-devel@lists.linux.dev>; Sat, 13 Jun 2026 12:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781353146; cv=none; b=MJu9LqwdgMCzTzdMQ3kMRbxXiPKnNq+Nba0pRJOCgk8x67FX03Jdj2MaJF63r8aNkA5kIEv/rOKbg8I1BKzG0Tj9Tyl1HNi2OOxyxuLs2BYTP91oV0K81RJRrCGavr+vXijUGOchxG0993iExcCax796jQQstuBEn8XYvcTcPR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781353146; c=relaxed/simple;
	bh=mOEnyGrTqUDvJsaMPxQg/N1Elo1ZvN+X4HJyyeoTgYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PgqCE/SvJGhd2lCJleCDTxvMjss9t2Tr/QzL9Hg8EzqNLRFGhfhZxrGsEoKK81HuV0ze9ch80ICEuCAM1RJy085Amk+ZyQ8mHqXCoJawB1etpgclqQ6XzYj0midpuBfX4A6fMiV7q0lws78xawrGInj6SIv1uuhhvoijqA4ejy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org; spf=pass smtp.mailfrom=fastmail.org; dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b=jAiJlz4E; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kWaeO+DR; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.org header.i=@fastmail.org header.b="jAiJlz4E";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kWaeO+DR"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id D07D9138014D;
	Sat, 13 Jun 2026 08:19:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sat, 13 Jun 2026 08:19:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1781353142; x=1781356742; bh=y9uNjEKa1t
	Vi4FgZ/KblH3XwCjM22KIzKltssFGfyWQ=; b=jAiJlz4EvWBkGbWxuI2Qds6wpF
	bd6eCJMrETumrvNqnJO5CPr2EofBwpWM7IUqtMA/SwP8yBHz5nQrct30dlk1betB
	LUHhrp6bf9zapKq7LZUFyh/oIohAlP/F8buOndGbVC1bKoM1SfxdkpDkNhaFvyaF
	lfr8jSRLbLUnCCXHnvlndkTmems+BB8v206Ynk8thIp4HC0C6xsdjTAxBFUUCSUO
	WHDMZ4aLob3/L9VcCIsqfO3+Dg+dCDbCzJv5arvhKZpL7A2YmH/mXwCpzue5Et9J
	mQTEJDuZhMMGptMZmqpZQusTNb9w6MIQYi+k9wwMbDRUa/XTbYowqfdKbfuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1781353142; x=1781356742; bh=y9uNjEKa1tVi4FgZ/KblH3XwCjM22KIzKlt
	ssFGfyWQ=; b=kWaeO+DRv1GxKebU8DvLxnPsTssZRAiB6gFaP74RrpF45084qep
	TlgYjOxepyFOOj4wAlztqZiFnDP1hFwvnRbgf71XdIvOoqTO0GN5ueS1moc6ELHr
	yF2r4AwOsRHDk/xkl4LlejJ46bWizR9hHJhNsPU+a1qTQ9huVT9qEuKrHVRDTgcG
	7liBRNccxzNVeG47pkh2vHVl611KVpKrD41CNxEFxe+n8kTq9J5hJG6fWaUWhPBh
	xFPxroLEsEHgR9PvowzSV/S20eGabrbX+4wBQ1S3K4heWWqDw6NQkxq1xmcC9vg4
	ARxOyFrC1GomEum4R42TcWlMuXKPkrZPFjQ==
X-ME-Sender: <xms:tkotasTUn0MEh1EO9qW8gzcfDjz4_mIgxDyTLI0TkcaeMPuZU6FFww>
    <xme:tkotakvOFRCc2FsiB-iySCjXQfHnHN-QXPnI1UJXm1T-rjeo-33GZJWRAXupqBu8m
    47Fam6rj1Z8eyNSNMXJ1UrGFKC3eWm7XLhZrlbaVtHiITTFEB5DRRI>
X-ME-Received: <xmr:tkotao2uzLU84_TciGi1FQ1NHMXYXkq2Tcfc5JRYcz81pIPn7HlSXbLYdVU>
X-ME-Proxy-Cause: dmFkZTFZElk+o2B6MPRHZfIfeWoQjdGohuDrQJumjnVTObmsdq50pJhmSoe7pzQPUlI1KD
    gbY8KSZqfr3XYUgUhZH0eQ/07PJ5q8PqD1Csku/Na6Uj3PDpQ2eVIdTre2rd+qfQl7KkJp
    S/fT+ABGGFuGW8MzBTonIjdNaDT+lxv/mwv/shQeXVAa+/fDYGqMULp2q2bWH6RjnBL8Re
    UbUurinWBrdvN1M+5SMpIvq2vTW4+GpMkViotSiX/sYZ2vMPpNIngeIO0wP+/PYtID1HOM
    50kXw9KulwLWPTCpeMegNsoFEkIM5Jt9pkva91JHf6IGQIed53iKJJ7S4YCzW1rE7l2cVb
    FgsN6PFGP9iX/0LPeWQ4YJ0YQNCTOBlfVm/pwdyAI1HfM1syOnYpjMeUMxgaSsOERMkHcd
    pVAFXlAlp339Fg5ikuh9MJUTTLFQocOEZV0XUmZf+D2NBpxWVo/tdzlLgttDlkP5mNcThA
    Vk/yGTMxuKUbI5A0vqtEwRk9Lp8LzgYNJsE4pbE9Zhf45iWw1qFcvG0RDVTxU9j4e645Bg
    Npftn9a0MyJBBOksub+jVluUfjbX7pmGGPxn8qoGMr027wx4/PoggvMRqBKKHyQmlDLOEb
    nyirgmaaicveGGfmoIreqMMGc3oZOA7vwkutxJQK8qYEQQCBFGyuFvcOxGyw
X-ME-Proxy: <xmx:tkotalUEw3sFaqdHNdZdU03ds1gKDJ8zVlef_YtbllFaTIC3T3jqVw>
    <xmx:tkotajISjYcXXiSsUKWRruAjHyhmZ6Vimu0YgUhYTg0viMIZKRVj7A>
    <xmx:tkotan0ZMSZ16xTYgO0ibFpKpvAMW8j9gQHpMNH0yeXyKGBdeZmbgw>
    <xmx:tkotap78vozhoodTW01KuklDM_6Pf6X0aKwkiA0RGBDIfUZQssVFPw>
    <xmx:tkotagrAZ6e_b1qiQvmX0miJ49fdkQUCtuYBx8AFzYpjKt6ypPy0Sehy>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 13 Jun 2026 08:19:01 -0400 (EDT)
Date: Sat, 13 Jun 2026 07:19:00 -0500
From: Ian Bridges <icb@fastmail.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: akpm <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	"ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] ocfs2: fix UBSAN array-index-out-of-bounds in
 ocfs2_sum_rightmost_rec
Message-ID: <ai1KtNJfMCE7U4iU@dev>
References: <ain_780qc0P4ypNd@dev>
 <d3c3ac65-0f46-40ec-9071-92bf6ffa4fc8@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3c3ac65-0f46-40ec-9071-92bf6ffa4fc8@linux.alibaba.com>

On Fri, Jun 12, 2026 at 09:02:18AM +0800, Joseph Qi wrote:
> 
> 
> On 6/11/26 8:23 AM, Ian Bridges wrote:
> > [BUG]
> > On-disk corruption setting l_next_free_rec to 0 in an inode's embedded
> > extent list triggers a UBSAN panic on the next write to that file.
> > 
> > [CAUSE]
> > ocfs2_sum_rightmost_rec() computes
> > i = le16_to_cpu(el->l_next_free_rec) - 1
> > and accesses el->l_recs[i] without validating i. When l_next_free_rec
> > is 0, i becomes -1; when l_next_free_rec exceeds l_count, i falls
> > past the end of the array. Either case violates the
> > __counted_by_le(l_count) annotation on l_recs[] and triggers UBSAN.
> > 
> > [FIX]
> > Validate the inode's embedded extent list when the inode is read, in
> > ocfs2_validate_inode_block(): l_count must be non-zero and no larger
> > than the inode block can hold, and l_next_free_rec must not exceed
> > l_count. A corrupt list is rejected at read time, before the b-tree
> > code can index l_recs[] out of bounds.
> > 
> > Reported-by: syzbot+be16e33db01e6644db7a@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=be16e33db01e6644db7a
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ian Bridges <icb@fastmail.org>
> 
> Looks fine.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> > ---
> > Changes in 4:
> >  - Update commit message to use "inline" instead of "embedded"
> 
> Typo here? I think you mean 'embedded' instead of 'inline'.
>

Yes, the placement of the "inline" and "embedded" should have been
swapped.

Ian

> >  
> > v3: https://lore.kernel.org/all/aibMhhAH-swS38i0@dev/
> > 
> >  fs/ocfs2/inode.c | 32 ++++++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> > 
> > diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
> > index a510a0eb1adc..aff95efd78e7 100644
> > --- a/fs/ocfs2/inode.c
> > +++ b/fs/ocfs2/inode.c
> > @@ -1559,6 +1559,38 @@ int ocfs2_validate_inode_block(struct super_block *sb,
> >  		goto bail;
> >  	}
> >  
> > +	if (ocfs2_dinode_has_extents(di)) {
> > +		struct ocfs2_extent_list *el = &di->id2.i_list;
> > +		u16 count = le16_to_cpu(el->l_count);
> > +		u16 next_free = le16_to_cpu(el->l_next_free_rec);
> > +
> > +		if (count == 0) {
> > +			rc = ocfs2_error(sb,
> > +					 "Invalid dinode %llu: extent list l_count is zero\n",
> > +					 (unsigned long long)bh->b_blocknr);
> > +			goto bail;
> > +		}
> > +		/*
> > +		 * The exact capacity depends on i_xattr_inline_size, another
> > +		 * unvalidated on-disk field. Inline xattrs only shrink the
> > +		 * list, so the no-xattr maximum is a safe upper bound that a
> > +		 * valid l_count never exceeds.
> > +		 */
> > +		if (count > ocfs2_extent_recs_per_inode(sb)) {
> > +			rc = ocfs2_error(sb,
> > +					 "Invalid dinode %llu: extent list l_count %u exceeds max %u\n",
> > +					 (unsigned long long)bh->b_blocknr, count,
> > +					 ocfs2_extent_recs_per_inode(sb));
> > +			goto bail;
> > +		}
> > +		if (next_free > count) {
> > +			rc = ocfs2_error(sb,
> > +					 "Invalid dinode %llu: extent list l_next_free_rec %u exceeds l_count %u\n",
> > +					 (unsigned long long)bh->b_blocknr, next_free, count);
> > +			goto bail;
> > +		}
> > +	}
> > +
> >  	rc = 0;
> >  
> >  bail:
> 
