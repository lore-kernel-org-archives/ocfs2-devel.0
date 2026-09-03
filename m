Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9639792B
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Sep 2026 08:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425272; cv=none; b=iiCmQi+Y9wxf9JPxKglJD10D1vC9tiCCIxJ6EzG5h8YIcJ8MqoTPUvWaAbys2fXD4L0rB3uqz3G9myAnJgzSk7zQ2DU0gY6dDpfhC9DyQU68qlNuEAKkRy6P+bn5QR9raaxr+niNxQRsqjsOa/FlAKfiS6FPewYaL1+JbQkbVPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425272; c=relaxed/simple;
	bh=OYLFYCMNZA114MD3J4O/f3tpHH6pl1m2DK3vvbvVBgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/Wz3/D7pJAVLqXet67wu+9Dl6F0okBpiPjd4b7v14Y9L5xA72795SZixDYf3RXJe3v0O2+b0zl5JhVQ8qoCEYC3F6UHop0yKaiB8MxidD+rMGRXytwVNK9Z+KBP6/giBRjPcO+lTWv1XKftnMPSPgmL3ZfX/ScWSCfcccSDSTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EUz8hBvA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=O4QrIF0+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mSgKNGw3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DChrvXuK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EUz8hBvA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="O4QrIF0+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mSgKNGw3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DChrvXuK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B6FA1FDF1;
	Thu,  3 Sep 2026 08:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788425264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WRbi2rD+eFTwUJ5ZZTOJbWeHQrzHMzr4OJI3Dgz/GAY=;
	b=EUz8hBvApKxx5IgDTg/FlQC3HwWB9yyCE0LvVwnmP9MBTmBWo36+o29D7kf9SJY1YK05nt
	YvlW/VQuFWS3nm1Bk+LBi5woS24IU2sF3MLQm621xkRLtMmyGkA11f0wKTuY6EcCH8lRUU
	DPUbfVdEOfCGRVWQAHkCtc9b+fpShmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788425264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WRbi2rD+eFTwUJ5ZZTOJbWeHQrzHMzr4OJI3Dgz/GAY=;
	b=O4QrIF0+JZUFM2RfNEyE1/jKUPpJv2uA3CwDtKiJIdthO+4UMdFaHZ97hyHbDdihNyQxHo
	IFk9EzOD4nwmofDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mSgKNGw3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DChrvXuK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788425260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WRbi2rD+eFTwUJ5ZZTOJbWeHQrzHMzr4OJI3Dgz/GAY=;
	b=mSgKNGw3hUzw0ZA5DLotGb3bIcu2CXtGPQ6C33+rNEQJAoqm8sQJoQGIxf3Qd22sXdSjIw
	skfR+8avk9h0dTxwH6JBlFIOSku109Y2syqlHSgreKOZXmfe+Iut/zXSS7bsItI9lNW0Hv
	CVCLbdmnbRTdhyjnr1RvcqtqBHxppp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788425260;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WRbi2rD+eFTwUJ5ZZTOJbWeHQrzHMzr4OJI3Dgz/GAY=;
	b=DChrvXuKBc/kE9j0IEbTY2enwJCh6DYNkDWWpqr6JfEnSOAy1XPZE/9qmtqvXy8wj+ge52
	ukX9ce6wXwiHwJAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DAD5136E6;
	Thu,  3 Sep 2026 08:47:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JiTgFiw0mWrgOgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 08:47:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E2081A0867; Thu, 03 Sep 2026 10:47:39 +0200 (CEST)
Date: Thu, 3 Sep 2026 10:47:39 +0200
From: Jan Kara <jack@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, ocfs2-devel@lists.linux.dev, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: Re: [PATCH 2/2] shmem: Refuse to enable tmpfs format for another
 filesystem
Message-ID: <hqcus3yg5hdnf42f6ccin3lmnzv6xzrbpev7c2qaabo3fh7wiq@jckmpvb36ili>
References: <20260902132458.23590-1-jack@suse.cz>
 <20260902133702.1313635-4-jack@suse.cz>
 <5f7e2e81-6a79-3b5a-1dc2-83ce775017ac@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f7e2e81-6a79-3b5a-1dc2-83ce775017ac@google.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7B6FA1FDF1
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,berkeley.edu:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Wed 02-09-26 19:31:39, Hugh Dickins wrote:
> On Wed, 2 Sep 2026, Jan Kara wrote:
> 
> > It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> > requesting to enable quota using tmpfs quota format. With suitable
> > passed arguments this can actually succeed in enabling tmpfs quota
> > format on top of ext4 filesystem which leads to crashes later in
> > dquot_acquire().  As tmpfs quota format is intended for tmpfs
> > filesystems only, verify we are indeed enabling quotas there.
> > 
> > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  mm/shmem_quota.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> > index d0b92d6da50f..6e0b43cbded3 100644
> > --- a/mm/shmem_quota.c
> > +++ b/mm/shmem_quota.c
> > @@ -54,6 +54,10 @@ struct quota_id {
> >  
> >  static int shmem_check_quota_file(struct super_block *sb, int type)
> >  {
> > +	/* Verify enabling happens on tmpfs superblock */
> > +	if (strcmp(sb->s_type->name, "tmpfs"))
> > +		return 0;
> > +
> 
> I don't object to this, but was rather expecting you'd check s_magic
> for TMPFS_MAGIC: isn't this the kind of hi-tech thing s_magic is for?

Oh, I completely forgot about s_magic. Yes, I guess that will be better
than looking at sb->s_type. Thanks for the idea.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
