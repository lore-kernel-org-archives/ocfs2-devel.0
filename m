Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81597194140
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 09:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718617449; cv=none; b=h4FGdwrkP+8VC9tXnQ/+0D4ColjIlNuaPVAuFkZi5xmQDklLQiSVog3kWnWyUG4TGjz8A+eIv/vhqzA0vMmm4BO97SKA/yDqjM9dfe9gsPC1IA5fQ+ARlynjjRyFRkpIkzhEXPmS0qJXnD0BzKMjZtylz5R/U6xJcKlAaQ3KFsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718617449; c=relaxed/simple;
	bh=ADRCEYYXyv9LCtXPSUwD/nloxYzcK815YGT+wl0DAlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kuyv57fe6y4QNTvIEBUDeA/CKCU0L1ZbrAwjdObhFpvpTAo30EgOf2T6ZskVt4xf7DNkPpmFa1KcWnwWwzoK6nI2J3h8scuRV5jlxDH5+wPdCdjynru+g0uwFelPA67aqB776Q3yXhPAWJi9z8gAw0QcsNmhX4SveQyKUsXfYvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MCCbiO3R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NkjC9wjO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MCCbiO3R; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NkjC9wjO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MCCbiO3R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NkjC9wjO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MCCbiO3R";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NkjC9wjO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 78C6D37F8F;
	Mon, 17 Jun 2024 09:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718617445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qccBg0j+BgE+82sX1tRKKGJXTsbuFjkpFAhCG7knQzA=;
	b=MCCbiO3RgIA2EOUkDH78vhN7clY0ILW4+wC+SZa2ycbHL6puqzd5ebbIazb/DClpDsqmuo
	YAXtHawPjZet0VdShroiZihogd2DECmpXkeInPpp1HLeTWM9gmGCwLnsLJnvpqH1pLplBq
	P2CvDw9JE/ATRroCdNtSGSOMgAKf2e4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718617445;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qccBg0j+BgE+82sX1tRKKGJXTsbuFjkpFAhCG7knQzA=;
	b=NkjC9wjOOoDPtGdIkPqGd8WVsr81lzxbpeT7w91E3x4gZNjWzIsWBDJfoI4lAfBqv1Kk6V
	s5kzcOXRrYOUJiCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1718617445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qccBg0j+BgE+82sX1tRKKGJXTsbuFjkpFAhCG7knQzA=;
	b=MCCbiO3RgIA2EOUkDH78vhN7clY0ILW4+wC+SZa2ycbHL6puqzd5ebbIazb/DClpDsqmuo
	YAXtHawPjZet0VdShroiZihogd2DECmpXkeInPpp1HLeTWM9gmGCwLnsLJnvpqH1pLplBq
	P2CvDw9JE/ATRroCdNtSGSOMgAKf2e4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1718617445;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qccBg0j+BgE+82sX1tRKKGJXTsbuFjkpFAhCG7knQzA=;
	b=NkjC9wjOOoDPtGdIkPqGd8WVsr81lzxbpeT7w91E3x4gZNjWzIsWBDJfoI4lAfBqv1Kk6V
	s5kzcOXRrYOUJiCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DFA2139AB;
	Mon, 17 Jun 2024 09:44:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fqDNGmUFcGYLegAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 17 Jun 2024 09:44:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 131F1A0887; Mon, 17 Jun 2024 11:44:01 +0200 (CEST)
Date: Mon, 17 Jun 2024 11:44:01 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, Jan Kara <jack@suse.cz>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev, Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mark@fasheh.com>
Subject: Re: [PATCH] ocfs2: Fix DIO failure due to insufficient transaction
 credits
Message-ID: <20240617094401.k6osqtus3yh4svwo@quack3>
References: <20240614145243.8837-1-jack@suse.cz>
 <2ec660c6-6f5d-448c-8488-3924552e261f@suse.com>
 <20240614195427.5bec08e823d3398b0f28216a@linux-foundation.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614195427.5bec08e823d3398b0f28216a@linux-foundation.org>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]

On Fri 14-06-24 19:54:27, Andrew Morton wrote:
> On Sat, 15 Jun 2024 09:21:51 +0800 Heming Zhao <heming.zhao@suse.com> wrote:
> 
> > On 6/14/24 22:52, Jan Kara wrote:
> > > The code in ocfs2_dio_end_io_write() estimates number of necessary
> > > transaction credits using ocfs2_calc_extend_credits(). This however does
> > > not take into account that the IO could be arbitrarily large and can
> > > contain arbitrary number of extents. Extent tree manipulations do often
> > > extend the current transaction but not in all of the cases. For example
> > > if we have only single block extents in the tree,
> > > ocfs2_mark_extent_written() will end up calling
> > > ocfs2_replace_extent_rec() all the time and we will never extend the
> > > current transaction and eventually exhaust all the transaction credits
> > > if the IO contains many single block extents. Make sure the transaction
> > > always has enough credits for one extent insert before each call of
> > > ocfs2_mark_extent_written().
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > Thanks for Jan's patch, it was used to fix a SUSE customer issue.
> 
> That's useful info.  Could we please have, for the changelog, a
> description of that issue?  Amongst other reasons, so that someone else
> who is dealing with a customer issue can figure out whether this patch
> will address it.

Sure, I'll update the changelog.
 
> I assume a cc:stable is appropriate.

Yes.

> Can we please identify a suitable Fixes: target, or has this been there
> for ever?

The problem seems to be there since the OCFS2 DIO rewrite some 8 years ago.
I'll add Fixes tag.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
