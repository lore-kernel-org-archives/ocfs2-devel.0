Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD29B2356DB
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Apr 2025 12:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743597390; cv=none; b=gFLA9ZV2E9sqKj+K1UWm+JpsE9fXgBCsNYbzE+EfoS1MKs6cwlRMKf6tiB3lPbqKwOYBn1j/IvAiTHF15NfB1kLB4eJeoBt+EIHcjAboXTgAtRG2z27vdxu6u/fLhFDWIT0bWFzYHfuiNQ7m0EaFSJim7Bx1T2jsBjV9M5m/p0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743597390; c=relaxed/simple;
	bh=wLXCvrQkypVg4hlEhY6JXt6xgl1mkrVJGg1FXS9VB3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lo+lGqoM2B7CulDh74JWremPWzOdumv/cvECX4BzrWX21iv/m6zXQied+m1o4/VCElerqLkW1HtE2xYZw5oMY5nk6KcSMZiNWttiXotQYwxBupYvhdNMI2peMMAsqQ/AeCh5wzh9LZFmW2UyR+mczFsSM/sITzjYcEiL2OJIYjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fXPF+hrW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vQdOo3Fh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fXPF+hrW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vQdOo3Fh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fXPF+hrW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vQdOo3Fh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fXPF+hrW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vQdOo3Fh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD8561F461;
	Wed,  2 Apr 2025 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1743597386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OIq2yKV0kL+PNrsufhF/VS7j84XZ7TdP3HdOB/g4idM=;
	b=fXPF+hrW9OESPG2JyNmFiJbWfZw+aOLT2am3EsXDEEaawlck8775kXMFtH5spghsHMtUcX
	VscVu7TO3WxbGcWVnIsoPCJSY1e1WH3u5dN21madec0+Ca0cTDA90HvBCB0+Z7x25FU3Lo
	30xD+e0cl4e5ygj3jNeB1ccwj/BZJbg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1743597386;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OIq2yKV0kL+PNrsufhF/VS7j84XZ7TdP3HdOB/g4idM=;
	b=vQdOo3FhPZcMU3Ga27uied2qPElJlsEC94vV77CszZY2lWe+IWZ6FmtskR9LkIDLS/caXd
	Q3C9ciRZxeK1NsAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1743597386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OIq2yKV0kL+PNrsufhF/VS7j84XZ7TdP3HdOB/g4idM=;
	b=fXPF+hrW9OESPG2JyNmFiJbWfZw+aOLT2am3EsXDEEaawlck8775kXMFtH5spghsHMtUcX
	VscVu7TO3WxbGcWVnIsoPCJSY1e1WH3u5dN21madec0+Ca0cTDA90HvBCB0+Z7x25FU3Lo
	30xD+e0cl4e5ygj3jNeB1ccwj/BZJbg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1743597386;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OIq2yKV0kL+PNrsufhF/VS7j84XZ7TdP3HdOB/g4idM=;
	b=vQdOo3FhPZcMU3Ga27uied2qPElJlsEC94vV77CszZY2lWe+IWZ6FmtskR9LkIDLS/caXd
	Q3C9ciRZxeK1NsAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0D52137D4;
	Wed,  2 Apr 2025 12:36:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XEknK0ov7WdpBAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Apr 2025 12:36:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 69067A07E6; Wed,  2 Apr 2025 14:36:26 +0200 (CEST)
Date: Wed, 2 Apr 2025 14:36:26 +0200
From: Jan Kara <jack@suse.cz>
To: Murad Masimov <m.masimov@mt-integration.ru>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Jan Kara <jack@suse.cz>, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH 1/2] ocfs2: Fix possible memory leak in
 ocfs2_finish_quota_recovery
Message-ID: <ategbetdbjc3vxgablimxrche2dv4ndaqq3fkrd6lu64e3ggce@m76fa6gjhdh2>
References: <20250402065628.706359-1-m.masimov@mt-integration.ru>
 <20250402065628.706359-2-m.masimov@mt-integration.ru>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402065628.706359-2-m.masimov@mt-integration.ru>
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On Wed 02-04-25 09:56:27, Murad Masimov wrote:
> If ocfs2_finish_quota_recovery() exits due to an error before passing all
> rc_list elements to ocfs2_recover_local_quota_file() then it can lead to
> a memory leak as rc_list may still contain elements that have to be freed.
> 
> Release all memory allocated by ocfs2_add_recovery_chunk() using
> ocfs2_free_quota_recovery() instead of kfree().
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: 2205363dce74 ("ocfs2: Implement quota recovery")
> Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>

Looks good. Thanks for debugging this! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/quota_local.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
> index 2956d888c131..e60383d6ecc1 100644
> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -678,7 +678,7 @@ int ocfs2_finish_quota_recovery(struct ocfs2_super *osb,
>  	}
>  out:
>  	up_read(&sb->s_umount);
> -	kfree(rec);
> +	ocfs2_free_quota_recovery(rec);
>  	return status;
>  }
> 
> --
> 2.39.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
