Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0AE3358B7
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Feb 2026 12:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770122236; cv=none; b=X7YRkQn2wsVYwCqIMZTB0tWy7I++NnB3HA8rnZKBCn4ZyiTMDSptWLrJFbxctLLPVMvc41k5eaD21Pve3YR5xrOp24zfAhtgZMTmebFwBmmiEG4+vId1DxW2aU1+MsIjddC/DYgPJb+K4arNvg7Fju/ghZ85skDrpECbzeWZATk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770122236; c=relaxed/simple;
	bh=ejs7HF0Q/N2AZKPDYMFrFMczbmvrn/j4Cm0b5KAkeU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7Iz1Enmekc8pczx64lpGC5OeXmH89LTalO+PxuxZ5wTSu54zlsOXVj4nVGo+p6zXOd5N0OwnvzKV2cFSuBIr+z6pIzxRV5p+cPcmwK/nWkhFfofnwgEkM5O8avWZ9L/Ikz9k7PAIJ8vo8gxvLKQXbUTUMFWaMSVwiaL/erPdXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=B5sSUh6r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gbhifEzj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=B5sSUh6r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gbhifEzj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="B5sSUh6r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gbhifEzj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="B5sSUh6r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gbhifEzj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1715A5BCC3;
	Tue,  3 Feb 2026 12:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770122233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IYlOF89+ddPtyjyDFeQBOhxSFeFpERPk5eYstZgQzno=;
	b=B5sSUh6rqEBuEsFH1Xqk0bs9VfAwz7twnIoV+nsZ0xi/wcwTSwuCHYw6yUG0NzbJi4nkaZ
	qKhCynG7tsKQ6TKp4D6+Z6ZIjr0+TrYfUcxO6DRuEF6Zaql9xbV8E2OyoblcS9zAKKhr+/
	tzRwI5dcUFcWdoRLyxOBv1BUQywECNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770122233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IYlOF89+ddPtyjyDFeQBOhxSFeFpERPk5eYstZgQzno=;
	b=gbhifEzjU5ld8B9r7/Li9s2HXrz+BG/9RfYxrxH+fT4qMKm0wXe0hTqXUPeL73S3jn6J+B
	T1y1yTz0W05ZmgCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B5sSUh6r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gbhifEzj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770122233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IYlOF89+ddPtyjyDFeQBOhxSFeFpERPk5eYstZgQzno=;
	b=B5sSUh6rqEBuEsFH1Xqk0bs9VfAwz7twnIoV+nsZ0xi/wcwTSwuCHYw6yUG0NzbJi4nkaZ
	qKhCynG7tsKQ6TKp4D6+Z6ZIjr0+TrYfUcxO6DRuEF6Zaql9xbV8E2OyoblcS9zAKKhr+/
	tzRwI5dcUFcWdoRLyxOBv1BUQywECNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770122233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IYlOF89+ddPtyjyDFeQBOhxSFeFpERPk5eYstZgQzno=;
	b=gbhifEzjU5ld8B9r7/Li9s2HXrz+BG/9RfYxrxH+fT4qMKm0wXe0hTqXUPeL73S3jn6J+B
	T1y1yTz0W05ZmgCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F11953EA62;
	Tue,  3 Feb 2026 12:37:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D1bXOvjrgWmIGwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Feb 2026 12:37:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A5701A08F8; Tue,  3 Feb 2026 13:37:12 +0100 (CET)
Date: Tue, 3 Feb 2026 13:37:12 +0100
From: Jan Kara <jack@suse.cz>
To: Li Chen <me@linux.beauty>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel <ocfs2-devel@lists.linux.dev>, 
	linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>
Subject: Re: [PATCH 3/3] ocfs2: use READ_ONCE for lockless jinode reads
Message-ID: <vivemjs4vjvnfjapgnesrsk664rpk43l6w4sydfyrwryxrphkb@bduhqm5fnjou>
References: <20260130031232.60780-1-me@linux.beauty>
 <20260130031232.60780-4-me@linux.beauty>
 <aXxBX2Ul-S6nJzG5@casper.infradead.org>
 <19c0edeadad.6adfc20c802629.8728440093470268039@linux.beauty>
 <aXzeDE5P_lxiXfPB@casper.infradead.org>
 <nxltvmkavegi5tedwzb5g4gt5vzyjvsmkmg24sej74q7b5nvfm@o5u6uivv7sm7>
 <19c236980cd.2370a267287093.895726956980326936@linux.beauty>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19c236980cd.2370a267287093.895726956980326936@linux.beauty>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 1715A5BCC3
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Tue 03-02-26 20:10:42, Li Chen wrote:
> Hi Jan,
> 
>  ---- On Tue, 03 Feb 2026 01:17:49 +0800  Jan Kara <jack@suse.cz> wrote --- 
>  > On Fri 30-01-26 16:36:28, Matthew Wilcox wrote:
>  > > On Fri, Jan 30, 2026 at 08:26:40PM +0800, Li Chen wrote:
>  > > > Hi Matthew,
>  > > > 
>  > > >  > On Fri, Jan 30, 2026 at 11:12:32AM +0800, Li Chen wrote:
>  > > >  > > ocfs2 journal commit callback reads jbd2_inode dirty range fields without
>  > > >  > > holding journal->j_list_lock.
>  > > >  > > 
>  > > >  > > Use READ_ONCE() for these reads to correct the concurrency assumptions.
>  > > >  > 
>  > > >  > I don't think this is the right solution to the problem.  If it is,
>  > > >  > there needs to be much better argumentation in the commit message.
>  > > >  > 
>  > > >  > As I understand it, jbd2_journal_file_inode() initialises jinode,
>  > > >  > then adds it to the t_inode_list, then drops the j_list_lock.  So the
>  > > >  > actual problem we need to address is that there's no memory barrier
>  > > >  > between the store to i_dirty_start and the list_add().  Once that's
>  > > >  > added, there's no need for a READ_ONCE here.
>  > > >  > 
>  > > >  > Or have I misunderstood the problem?
>  > > > 
>  > > > Thanks for the review.
>  > > > 
>  > > > My understanding of your point is that you're worried about a missing
>  > > > "publish" ordering in jbd2_journal_file_inode(): we store
>  > > > jinode->i_dirty_start/end and then list_add() the jinode to
>  > > > t_inode_list, and a core which observes the list entry might miss the prior
>  > > > i_dirty_* stores. Is that the issue you had in mind?
>  > > 
>  > > I think that's the only issue that exists ...
>  > > 
>  > > > If so, for the normal commit path where the list is walked under
>  > > > journal->j_list_lock (e.g. journal_submit_data_buffers() in
>  > > > fs/jbd2/commit.c), spin_lock()/spin_unlock() should already provide the
>  > > > necessary ordering, since both the i_dirty_* updates and the list_add()
>  > > > happen inside the same critical section.
>  > > 
>  > > I don't think that's true.  I think what you're asserting is that:
>  > > 
>  > >     int *pi;
>  > >     int **ppi;
>  > > 
>  > >     spin_lock(&lock);
>  > >     *pi = 1;
>  > >     *ppi = pi;
>  > >     spin_unlock(&lock);
>  > > 
>  > > that the store to *pi must be observed before the store to *ppi, and
>  > > that's not true for a reader which doesn't read the value of lock.
>  > > The store to *ppi needs a store barrier before it.
>  > 
>  > Well, the above reasonably accurately describes the code making jinode
>  > visible. The reader code is like:
>  > 
>  >     spin_lock(&lock);
>  >         pi = *ppi;
>  >     spin_unlock(&lock);
>  > 
>  >     work with pi
>  > 
>  > so it is guaranteed to see pi properly initialized. The problem is that
>  > "work with pi" can race with other code updating the content of pi which is
>  > what this patch is trying to deal with.
>  > 
>  > > > The ocfs2 case I was aiming at is different: the filesystem callback is
>  > > > invoked after unlocking journal->j_list_lock and may sleep, so it can't hold
>  > > > j_list_lock but it still reads jinode->i_dirty_start/end while other
>  > > > threads update these fields under the lock. Adding a barrier between the
>  > > > stores and list_add() would not address that concurrent update window.
>  > > 
>  > > I don't think that race exists.  If it does exist, the READ_ONCE will
>  > > not help (on 32 bit platforms) because it's a 64-bit quantity and 32-bit
>  > > platforms do not, in general, have a way to do an atomic 64-bit load
>  > > (look at the implementation of i_size_read() for the gyrations we go
>  > > through to assure a non-torn read of that value).
>  > 
>  > Sadly the race does exist - journal_submit_data_buffers() on the committing
>  > transaction can run in parallel with jbd2_journal_file_inode() in the
>  > running transaction. There's nothing preventing that. The problems arising
>  > out of that are mostly theoretical but they do exist. In particular you're
>  > correct that on 32-bit platforms this will be racy even with READ_ONCE /
>  > WRITE_ONCE which I didn't realize.
>  > 
>  > Li, the best way to address this concern would be to modify jbd2_inode to
>  > switch i_dirty_start / i_dirty_end to account in PAGE_SIZE units instead of
>  > bytes and be of type pgoff_t. jbd2_journal_file_inode() just needs to round
>  > the passed ranges properly...
> 
>   Thank you, Jan. I will update the series accordingly.
> 
>   It seems this won’t break large files on 32-bit either: MAX_LFS_FILESIZE there is
>   ULONG_MAX << PAGE_SHIFT (i.e. ULONG_MAX pages, ~16TB with 4K pages), and pgoff_t
>   (unsigned long) can represent the same ULONG_MAX-page range.

Exactly. That's the reason why I've proposed this but I should have
probably stated that explicitely :).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
