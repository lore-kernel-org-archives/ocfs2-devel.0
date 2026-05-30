Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988733955D3
	for <ocfs2-devel@lists.linux.dev>; Sat, 30 May 2026 11:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780141662; cv=none; b=k6diK7U16RoBC0/D5EwaSitun+GAdGYQALsGNbLcEHstbTLkWrRGZW4Tle3mflxoGCnbVRvSem8mx44EGPJx3hNN+PCfudUDBlfJYBlo1bBaSHCmFR1GXNuLJREjxI2zTlQ3ryYD/GNmrOXhyR/rczfjE/slg59pzgtwliB627c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780141662; c=relaxed/simple;
	bh=Iql7l9Zjcy6ycgHhFU9FNFCNfC3mhdoiX5YlHSXnYGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzeNOywERxcl5cYqDQzL9dmfJLtyAQFbYaLRDSrUHzvU9IC+RurfktFr+//4oGLEVvHisEVVyJn5hZe7vJe/Sh/ZXqMt+4mzw0oWI1z+fQz+Pn7+/3ru1+JThvO76u3AR0PW4aKdVKVSAL6ORd2ReIesCly/gnogAwHOGnv5zZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oXryYkeA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ci30Av4N; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QJE2SKIq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=iPel/oIL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oXryYkeA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ci30Av4N";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QJE2SKIq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="iPel/oIL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ED2E66B874;
	Sat, 30 May 2026 11:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780141659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k54nfXDHbVgrnLnvueGuOx93XxSGsH2kAbFiBczQhxM=;
	b=oXryYkeA289Rxu+1iPVjWv89MOFaULoIjLaaEbUfeGW3o+TkeyC+hpH8BXY5vl4qUuN/He
	A6GECU+G89SB33kXEGSoZtfYC9mZG6xOZlOQ99u0zDZBOmqJK2rMz6fvyxBPM+gKaFe2uX
	rxdlpk0v7tCUqOfBX7+Ioa5fJCUpx1k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780141659;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k54nfXDHbVgrnLnvueGuOx93XxSGsH2kAbFiBczQhxM=;
	b=ci30Av4NW0D2tDK1HVLaGXIfgZU/SXBSb/cqhkFyFCyJt0saD8BDU9qYQVdKJONCp2EXi9
	xqzSaDX8WiNzqkDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QJE2SKIq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="iPel/oIL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780141658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k54nfXDHbVgrnLnvueGuOx93XxSGsH2kAbFiBczQhxM=;
	b=QJE2SKIqPcTMD0bBM5B5eBvoj+tWJcK+dWhCZFubOGUIcgR4Eg44efJbeLBS3mLjurFd/L
	Tm2PaetCZlrORC25DCO6jS61LgNftGJ1FnaJkNM6v6NpooI7a2S3vtrewOQ/9wO11dFIo+
	QKroAbnWwwGn6Li33DxAS3lHAh28iSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780141658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k54nfXDHbVgrnLnvueGuOx93XxSGsH2kAbFiBczQhxM=;
	b=iPel/oILZVMyj4eNWvCDxYfyWRfdeUS1hT0+KrinihSclLb55wYhP4vnG3H9KyB7i8iRtB
	B6tyktifvUHuOqDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E52A5779A7;
	Sat, 30 May 2026 11:47:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MKvvN1rOGmqiQQAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 11:47:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9F727A0EBD; Sat, 30 May 2026 13:47:30 +0200 (CEST)
Date: Sat, 30 May 2026 13:47:30 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH v2 21/34] ocfs2: Convert ocfs2_write_super_or_backup to
 bh_submit()
Message-ID: <6wyo2yim34pg4omgyaxo5bfgzedgk3ukju74pfgiqczpgqhi7l@t5exdj7w2hh4>
References: <20260528173150.1093780-1-willy@infradead.org>
 <20260528173150.1093780-22-willy@infradead.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528173150.1093780-22-willy@infradead.org>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: ED2E66B874
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,alibaba.com:email,infradead.org:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,linux.dev:email];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]

On Thu 28-05-26 18:31:34, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call and changing the buffer refcount
> by using bh_submit() instead of submit_bh().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Cc: ocfs2-devel@lists.linux.dev

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/buffer_head_io.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 185ff4dcba75..8e67eba70674 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -440,10 +440,8 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
>  	/* remove from dirty list before I/O. */
>  	clear_buffer_dirty(bh);
>  
> -	get_bh(bh); /* for end_buffer_write_sync() */
> -	bh->b_end_io = end_buffer_write_sync;
>  	ocfs2_compute_meta_ecc(osb->sb, bh->b_data, &di->i_check);
> -	submit_bh(REQ_OP_WRITE, bh);
> +	bh_submit(bh, REQ_OP_WRITE, bh_end_write);
>  
>  	wait_on_buffer(bh);
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
