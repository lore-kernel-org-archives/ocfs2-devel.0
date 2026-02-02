Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C60D389477
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Feb 2026 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770052672; cv=none; b=Bbg5hUTrE1CMSam8gTdAeRMo3UZYOb+qcvlokZn4brx+FwM2Es5FrJOXJFVjIJpi8Df6PH55Q0Iq+CcKz4tYDXckhISyp7gs3A+7PhLHWS8Fk4MaYV/b1DWk0ot6pVQpPp3ARV/Cn1kWstqVADPUlNlubuJghVbO8rgxtdf1bes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770052672; c=relaxed/simple;
	bh=0wCo1upshoL3K7eaWleiourAANH76v4qhxtUXoy8CD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CuN5Cc/JfSee372I9EUsEoPq1CxMHtUB7w6PtS0yJ8bOmzazqJ438Jq2eDhqpc5OKxL0TSD30e0yDXP4Osvomk3Y3J++T4Hm9jnFfuBFt7ivEk8bEskYdl4Hu0Q3aH00ox07zWcEB9GYuNS7grdb5LqHPXfQF8/Uy4giQMhgCmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kpw1N7Et; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3QDCUYOY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kpw1N7Et; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3QDCUYOY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kpw1N7Et";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3QDCUYOY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kpw1N7Et";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3QDCUYOY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7E7AF5BCC4;
	Mon,  2 Feb 2026 17:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770052669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DEP+qNtdeYubvNKOKWMj40sMHyyQ6flD5y81xtBULG0=;
	b=kpw1N7EtYPpGebUyuqrB7SZjXhK5LoXUvM2R6+0AokrBxcmCvKBCL2ZfkGTlie8mDXFMPx
	iPNfMrSOK2XfgTXqz5tiWKNIe7m4oY3VIHo96gp09UzKC3v0U6pTJgUzWa5C4yCFCTMJJL
	rf39dM+YLxacCoqvL3oadje1gwjZao0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770052669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DEP+qNtdeYubvNKOKWMj40sMHyyQ6flD5y81xtBULG0=;
	b=3QDCUYOY/sfIB/f9Fk2eW7fjctpTO4yD8d9sEV3RGQIJS4Pos2ihVwcxPfIZg2O/JPaaN4
	xAMB4Giiyt8PbzDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770052669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DEP+qNtdeYubvNKOKWMj40sMHyyQ6flD5y81xtBULG0=;
	b=kpw1N7EtYPpGebUyuqrB7SZjXhK5LoXUvM2R6+0AokrBxcmCvKBCL2ZfkGTlie8mDXFMPx
	iPNfMrSOK2XfgTXqz5tiWKNIe7m4oY3VIHo96gp09UzKC3v0U6pTJgUzWa5C4yCFCTMJJL
	rf39dM+YLxacCoqvL3oadje1gwjZao0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770052669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DEP+qNtdeYubvNKOKWMj40sMHyyQ6flD5y81xtBULG0=;
	b=3QDCUYOY/sfIB/f9Fk2eW7fjctpTO4yD8d9sEV3RGQIJS4Pos2ihVwcxPfIZg2O/JPaaN4
	xAMB4Giiyt8PbzDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E9213EA63;
	Mon,  2 Feb 2026 17:17:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zrIXFz3cgGkqbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Feb 2026 17:17:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0C141A08F8; Mon,  2 Feb 2026 18:17:49 +0100 (CET)
Date: Mon, 2 Feb 2026 18:17:49 +0100
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Li Chen <me@linux.beauty>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	ocfs2-devel <ocfs2-devel@lists.linux.dev>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jan Kara <jack@suse.com>
Subject: Re: [PATCH 3/3] ocfs2: use READ_ONCE for lockless jinode reads
Message-ID: <nxltvmkavegi5tedwzb5g4gt5vzyjvsmkmg24sej74q7b5nvfm@o5u6uivv7sm7>
References: <20260130031232.60780-1-me@linux.beauty>
 <20260130031232.60780-4-me@linux.beauty>
 <aXxBX2Ul-S6nJzG5@casper.infradead.org>
 <19c0edeadad.6adfc20c802629.8728440093470268039@linux.beauty>
 <aXzeDE5P_lxiXfPB@casper.infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXzeDE5P_lxiXfPB@casper.infradead.org>
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO

On Fri 30-01-26 16:36:28, Matthew Wilcox wrote:
> On Fri, Jan 30, 2026 at 08:26:40PM +0800, Li Chen wrote:
> > Hi Matthew,
> > 
> >  > On Fri, Jan 30, 2026 at 11:12:32AM +0800, Li Chen wrote:
> >  > > ocfs2 journal commit callback reads jbd2_inode dirty range fields without
> >  > > holding journal->j_list_lock.
> >  > > 
> >  > > Use READ_ONCE() for these reads to correct the concurrency assumptions.
> >  > 
> >  > I don't think this is the right solution to the problem.  If it is,
> >  > there needs to be much better argumentation in the commit message.
> >  > 
> >  > As I understand it, jbd2_journal_file_inode() initialises jinode,
> >  > then adds it to the t_inode_list, then drops the j_list_lock.  So the
> >  > actual problem we need to address is that there's no memory barrier
> >  > between the store to i_dirty_start and the list_add().  Once that's
> >  > added, there's no need for a READ_ONCE here.
> >  > 
> >  > Or have I misunderstood the problem?
> > 
> > Thanks for the review.
> > 
> > My understanding of your point is that you're worried about a missing
> > "publish" ordering in jbd2_journal_file_inode(): we store
> > jinode->i_dirty_start/end and then list_add() the jinode to
> > t_inode_list, and a core which observes the list entry might miss the prior
> > i_dirty_* stores. Is that the issue you had in mind?
> 
> I think that's the only issue that exists ...
> 
> > If so, for the normal commit path where the list is walked under
> > journal->j_list_lock (e.g. journal_submit_data_buffers() in
> > fs/jbd2/commit.c), spin_lock()/spin_unlock() should already provide the
> > necessary ordering, since both the i_dirty_* updates and the list_add()
> > happen inside the same critical section.
> 
> I don't think that's true.  I think what you're asserting is that:
> 
> 	int *pi;
> 	int **ppi;
> 
> 	spin_lock(&lock);
> 	*pi = 1;
> 	*ppi = pi;
> 	spin_unlock(&lock);
> 
> that the store to *pi must be observed before the store to *ppi, and
> that's not true for a reader which doesn't read the value of lock.
> The store to *ppi needs a store barrier before it.

Well, the above reasonably accurately describes the code making jinode
visible. The reader code is like:

	spin_lock(&lock);
        pi = *ppi;
	spin_unlock(&lock);

	work with pi

so it is guaranteed to see pi properly initialized. The problem is that
"work with pi" can race with other code updating the content of pi which is
what this patch is trying to deal with.

> > The ocfs2 case I was aiming at is different: the filesystem callback is
> > invoked after unlocking journal->j_list_lock and may sleep, so it can't hold
> > j_list_lock but it still reads jinode->i_dirty_start/end while other
> > threads update these fields under the lock. Adding a barrier between the
> > stores and list_add() would not address that concurrent update window.
> 
> I don't think that race exists.  If it does exist, the READ_ONCE will
> not help (on 32 bit platforms) because it's a 64-bit quantity and 32-bit
> platforms do not, in general, have a way to do an atomic 64-bit load
> (look at the implementation of i_size_read() for the gyrations we go
> through to assure a non-torn read of that value).

Sadly the race does exist - journal_submit_data_buffers() on the committing
transaction can run in parallel with jbd2_journal_file_inode() in the
running transaction. There's nothing preventing that. The problems arising
out of that are mostly theoretical but they do exist. In particular you're
correct that on 32-bit platforms this will be racy even with READ_ONCE /
WRITE_ONCE which I didn't realize.

Li, the best way to address this concern would be to modify jbd2_inode to
switch i_dirty_start / i_dirty_end to account in PAGE_SIZE units instead of
bytes and be of type pgoff_t. jbd2_journal_file_inode() just needs to round
the passed ranges properly...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
