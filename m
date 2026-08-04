Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5B13E51F7
	for <ocfs2-devel@lists.linux.dev>; Tue,  4 Aug 2026 08:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785833433; cv=none; b=KN7NFOIhWlWWr5Dh358fooaPfvYgJXyuk0UVgLinPvvZ6j7/Xji0gKtzwoHr75Vsd6cE1DB35zaTL0OJ5ACFP0PrZU6ySTRywXsTVDD86wgzDvBVgbcY/8Y9moQ6bFgDnUWgJt424Tq0kZwI8wlyVs/2g8cIV/sYYAUnYLHpoQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785833433; c=relaxed/simple;
	bh=XoggicR4slZC7b+kv9oaWRxIUx4Lv1wZsgRpcLCJiDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XxuZy6kAt+/0oJ/lwnw9wq14qrU8NVRNQxUHKqXgw3CW51HNWzA2VStANZPVdv1XNEb0WWqf13Lz9sgYOBsKbdWTD+2VAePMlYtZ19up7RsWViAjTde5dzu6NynYScG3ei/uC6WvCiIJF8r2oQIC8CVyzT3ZuQBl0+qahzFOMDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=r80ulHCY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OL5mEjrx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=c+BhEBJS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NFSEBPcs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="r80ulHCY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OL5mEjrx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c+BhEBJS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NFSEBPcs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 71F777F7B5;
	Tue,  4 Aug 2026 08:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785833426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4xWWCH7WFnfMXbXP1iIQ1mgIZQTBIAzwX0KsfW7GzP8=;
	b=r80ulHCYvCJ3lSbHtx9VfEdocDBSglUHLwdBOloidEyEfSo6KGJbx4KGrH1u2HdZZ8d9QK
	9M50kAogruRs3hOyjAGqkslimLzsuqRC+zSmHJbAruU+rorw90EQ9JOMF9m0R6FBpdPdDX
	twtoCDTiCU39OJLGfqTwpnouZDKvQUU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785833426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4xWWCH7WFnfMXbXP1iIQ1mgIZQTBIAzwX0KsfW7GzP8=;
	b=OL5mEjrxxdw+Hq4/NFK5ogxhq3WHhOUP3SZ6N+aF9T7ERECz1+VjGqqhfZkjE4AXsbrGun
	KQZD6PHhVy0qdiBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c+BhEBJS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NFSEBPcs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785833422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4xWWCH7WFnfMXbXP1iIQ1mgIZQTBIAzwX0KsfW7GzP8=;
	b=c+BhEBJSIdzhaCcho7CFBhWITumu+nMCdSRO+1ZsdD+otoUYdV9NJn+ugB42HO/ybhrcCf
	FE9u2VE4FS5aFSWarylUavfu3KxV5y0PlCuMssMQ7uBDbh6wjPEu068MMO/x3YTcPNV8mG
	4SpCgKTOrc06oEWFnhGdhNu4GKsk+L8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785833422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4xWWCH7WFnfMXbXP1iIQ1mgIZQTBIAzwX0KsfW7GzP8=;
	b=NFSEBPcsa6Yw+96SBZ9Q1ACVP8jBnDgo6YkAPa2k8dGVo2CnFf6B4W+Om6joxITc84zvv2
	Rtvm32Co3SSF8KDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6947C779BE;
	Tue,  4 Aug 2026 08:50:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qD69Gc6ncWo2cAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 08:50:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2A2FDA13A6; Tue, 04 Aug 2026 10:50:18 +0200 (CEST)
Date: Tue, 4 Aug 2026 10:50:18 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/19] ocfs2: check for a stale write error before
 reusing a metadata buffer
Message-ID: <zkfpbzavypza6z427zvsjohfrtrowlktdv7nstt3pciph2m2hi@6fhq6rpyguoa>
References: <cover.1785621505.git.coshi036@gmail.com>
 <e63c15e7001fea3f83e0a0aed1512224832b8b1e.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e63c15e7001fea3f83e0a0aed1512224832b8b1e.1785621505.git.coshi036@gmail.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 71F777F7B5
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Sat 01-08-26 18:00:58, Chao Shi wrote:
> __ocfs2_journal_access() refuses to journal a buffer whose previous write
> failed, and turns the filesystem read-only rather than risk metadata
> inconsistency.  That check sits inside an if (!buffer_uptodate(bh)) block,
> because until now a failed write also cleared BH_Uptodate.
> 
> This series stops clearing BH_Uptodate on write error, so that outer test
> would never fire again and ocfs2 would silently start reusing buffers whose
> last write failed.  Hoist the check out of the debug block, where it does
> not depend on BH_Uptodate any more, and drop the now dead second half of
> its condition.
> 
> The mlog() pair keeps its own !buffer_uptodate() guard: it is a separate
> "we can safely remove this assertion after testing" debug aid about being
> handed a buffer with no valid contents, which is a different question from
> whether the last write of that buffer failed.
> 
> The unlocked test followed by a locked retest is deliberate.  BH_Write_EIO
> is cleared under the buffer lock when the buffer is submitted for write
> again, so taking the lock and looking a second time avoids turning the
> filesystem read-only over an error that a concurrent rewrite has already
> cleared, while keeping the common case lock-free.
> 
> The code in this patch is Jan's, from the review discussion linked in the
> cover letter.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/journal.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index d8afbc1a76bb..ea6802d894c2 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -676,19 +676,20 @@ static int __ocfs2_journal_access(handle_t *handle,
>  		mlog(ML_ERROR, "giving me a buffer that's not uptodate!\n");
>  		mlog(ML_ERROR, "b_blocknr=%llu, b_state=0x%lx\n",
>  		     (unsigned long long)bh->b_blocknr, bh->b_state);
> -
> +	}
> +	/*
> +	 * A previous transaction with a couple of buffer heads fail
> +	 * to checkpoint, so all the bhs are marked as BH_Write_EIO.
> +	 * For current transaction, the bh is just among those error
> +	 * bhs which previous transaction handle. We can't just clear
> +	 * its BH_Write_EIO and reuse directly, since other bhs are
> +	 * not written to disk yet and that will cause metadata
> +	 * inconsistency. So we should set fs read-only to avoid
> +	 * further damage.
> +	 */
> +	if (buffer_write_io_error(bh)) {
>  		lock_buffer(bh);
> -		/*
> -		 * A previous transaction with a couple of buffer heads fail
> -		 * to checkpoint, so all the bhs are marked as BH_Write_EIO.
> -		 * For current transaction, the bh is just among those error
> -		 * bhs which previous transaction handle. We can't just clear
> -		 * its BH_Write_EIO and reuse directly, since other bhs are
> -		 * not written to disk yet and that will cause metadata
> -		 * inconsistency. So we should set fs read-only to avoid
> -		 * further damage.
> -		 */
> -		if (buffer_write_io_error(bh) && !buffer_uptodate(bh)) {
> +		if (buffer_write_io_error(bh)) {
>  			unlock_buffer(bh);
>  			return ocfs2_error(osb->sb, "A previous attempt to "
>  					"write this buffer head failed\n");
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
