Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507C138A733
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Feb 2026 18:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770660129; cv=none; b=l+SqOZ58oxqvcDQX30novzPW2QhGWETIybP0CuLpWlPx7rpA3QyAnMBtwYzp7Ly8SYRpP9ayoDtZ3XU4Qq+nH4TiU8/orQJdh4O1w373Qp6urKYhuvhNwQ1IZanq21WhmpaeU/BSDDT/VffYJLDrM+ajHwdu9BAXMf4IhdhAmpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770660129; c=relaxed/simple;
	bh=n/wWW938KHzpfNbMHC4SH/9Dbi3KsElvYM65yXm/6cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KcZ/TgTfQ6686+NSw6oVuJHe8roBrjYA/8Md7i+3jNdt2aVbGV0KIP/s+r3cgbTUc1PJdSUvwaf0uuNSc5gmp1Eo8CzkSBlbE2dYmSjfUWnGixWBMxUdSnQBg9Kq4nKVa/IEbFCqlGd1VBdB8JF419+8LvTONOy9R2G7UHIZaIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vDjT4V0g; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nevxq9n4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vDjT4V0g; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nevxq9n4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vDjT4V0g";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nevxq9n4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vDjT4V0g";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nevxq9n4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4ED3C5BD2C;
	Mon,  9 Feb 2026 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770660122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1XOYzFi2oeOLG6Rv3RZi4yWoHUwYPdFepolmSJABjw=;
	b=vDjT4V0gkKiS1oySt1ljlot2utoh/hXmNs3rdCQvy9J0pGc0lQFwYUSBWa8SJGMkwg9ojY
	Rh5gI5Tg7GzKFZC1z5RAd/f4PS79CAdwBw3t+3LOZz+NZ5OErWWky+ryFkUfBvwOmKwUVz
	tuVKFFvZxKfnEAbWTowQFKwkaTERLUE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770660122;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1XOYzFi2oeOLG6Rv3RZi4yWoHUwYPdFepolmSJABjw=;
	b=nevxq9n49PNWMJu5oOUxHWpCamtYxdelRYFi+YQ+5mQ/OobKkVb3XngX2w6V2UPMeO5+Gx
	poqOUkPQlayk+SBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770660122; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1XOYzFi2oeOLG6Rv3RZi4yWoHUwYPdFepolmSJABjw=;
	b=vDjT4V0gkKiS1oySt1ljlot2utoh/hXmNs3rdCQvy9J0pGc0lQFwYUSBWa8SJGMkwg9ojY
	Rh5gI5Tg7GzKFZC1z5RAd/f4PS79CAdwBw3t+3LOZz+NZ5OErWWky+ryFkUfBvwOmKwUVz
	tuVKFFvZxKfnEAbWTowQFKwkaTERLUE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770660122;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p1XOYzFi2oeOLG6Rv3RZi4yWoHUwYPdFepolmSJABjw=;
	b=nevxq9n49PNWMJu5oOUxHWpCamtYxdelRYFi+YQ+5mQ/OobKkVb3XngX2w6V2UPMeO5+Gx
	poqOUkPQlayk+SBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38B5C3EA63;
	Mon,  9 Feb 2026 18:02:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L/bUDRohimkgfAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Feb 2026 18:02:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 626EEA0A27; Mon,  9 Feb 2026 19:01:57 +0100 (CET)
Date: Mon, 9 Feb 2026 19:01:57 +0100
From: Jan Kara <jack@suse.cz>
To: Daniel Hodges <git@danielhodges.dev>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Jan Kara <jack@suse.cz>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: zero-initialize recovery bitmap to prevent
 uninit-value in find_next_bit
Message-ID: <dvgcsdqeqhryxx7gy4mq65m44wti3ruqdqe4h43npofm4wrryl@edfz4nrai3yl>
References: <20260209161347.30400-1-git@danielhodges.dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209161347.30400-1-git@danielhodges.dev>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[7ea0b96c4ddb49fd1a70];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,appspotmail.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Mon 09-02-26 11:13:47, Daniel Hodges wrote:
> ocfs2_add_recovery_chunk() allocates a bitmap buffer of sb->s_blocksize
> bytes using kmalloc() but only copies (ol_chunk_entries(sb) + 7) >> 3
> bytes into it from the on-disk quota chunk. When the number of chunk
> entries is not aligned to a long boundary (64 bits on 64-bit systems),
> find_next_bit() reads uninitialized memory from the trailing bytes of
> the last word in the bitmap.

OK, but AFAICS it does not impact the functionality in any way because we
properly use:

for_each_set_bit(bit, rchunk->rc_bitmap, ol_chunk_entries(sb))

so the uninitialized bits are actually never used. This would be good to
stress in the changelog. Since this isn't really a performance sensitive
code I agree with the fix to make the checker happy anyway but I wanted to
make sure... So feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Fix this by using kzalloc() to zero-initialize the entire bitmap
> allocation, ensuring that any bits beyond the copied region are
> clean zeros.
> 
> Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
> Fixes: 2205363dce74 ("ocfs2: Implement quota recovery")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Hodges <git@danielhodges.dev>
> ---
>  fs/ocfs2/quota_local.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index de7f12858729..bd3eb098097f 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(struct super_block *sb,
>  	if (!rc)
>  		return -ENOMEM;
>  	rc->rc_chunk = chunk;
> -	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
> +	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
>  	if (!rc->rc_bitmap) {
>  		kfree(rc);
>  		return -ENOMEM;
> -- 
> 2.52.0
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
