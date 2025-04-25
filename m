Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23184101DE
	for <ocfs2-devel@lists.linux.dev>; Fri, 25 Apr 2025 13:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745588369; cv=none; b=NtbscMdCS2app50PmiN2gX+ZyjljbtFRKidTuR+EF13SnOvrouaKmtjtwKyxDdHBGrI0+lasrk2Qfc4L3FPBMVo6HTGz+I02PE+SeH7skPZOxF/wjUKTiBGo0YK9lDrZKxi/Wnu1R4NmHvPQLCjPfym2tACpIcqq2U+c6uxhhmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745588369; c=relaxed/simple;
	bh=ZaPNY5QyUHrfImHHkisC884lkBHX6go1KNhNzI8xw80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OjyQ204QddUesaRM8qlFFVfn3OLT450wzenDquRegPd322dXF2Dni6JWzy++8gpGnIZ7iWDnV7rd7Yc3PnNLNCq/EEBOev000xdTdruaQX6QePZxben+CtOtIT8q+tj2y2mfBoDpWl3sEHPCDSsdQAs5KmK2noSO0H/Ufm4/wLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mtAZYVud; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zr1BQy8R; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mtAZYVud; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zr1BQy8R; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mtAZYVud";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zr1BQy8R";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mtAZYVud";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zr1BQy8R"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 20CC01F399;
	Fri, 25 Apr 2025 13:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745588366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2z3avC5rP8cDX29I7eAhyduMafWtO/6c40mWDHzeywE=;
	b=mtAZYVud83IfA5M5tBNxXTNFunLsr+1acgRutR20oI3kMQtN5/xzqLOix3RIZlftrcQtl0
	1BWJhJ9FDMmdtQIX91q4k5SwLULtf3fVMyA09S3NoI6c0yGCCy/f/CET4lNKGbTj3ldape
	bhFWft9BK1wbtNQl2cjuhyDzFmM5NzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745588366;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2z3avC5rP8cDX29I7eAhyduMafWtO/6c40mWDHzeywE=;
	b=zr1BQy8Rpv79Yi5RkPBF3mp0+0nj3w0l13+yN89YBu4Dq3hbnixjr7OFvD2L44ikN5D/kh
	r+0M7ZLvDXBy54Cg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745588366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2z3avC5rP8cDX29I7eAhyduMafWtO/6c40mWDHzeywE=;
	b=mtAZYVud83IfA5M5tBNxXTNFunLsr+1acgRutR20oI3kMQtN5/xzqLOix3RIZlftrcQtl0
	1BWJhJ9FDMmdtQIX91q4k5SwLULtf3fVMyA09S3NoI6c0yGCCy/f/CET4lNKGbTj3ldape
	bhFWft9BK1wbtNQl2cjuhyDzFmM5NzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745588366;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2z3avC5rP8cDX29I7eAhyduMafWtO/6c40mWDHzeywE=;
	b=zr1BQy8Rpv79Yi5RkPBF3mp0+0nj3w0l13+yN89YBu4Dq3hbnixjr7OFvD2L44ikN5D/kh
	r+0M7ZLvDXBy54Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16CFA1388F;
	Fri, 25 Apr 2025 13:39:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EyKMBY6QC2jqVgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 25 Apr 2025 13:39:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 997EEA0944; Fri, 25 Apr 2025 15:39:17 +0200 (CEST)
Date: Fri, 25 Apr 2025 15:39:17 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, ocfs2-devel@lists.linux.dev, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Heming Zhao <heming.zhao@suse.com>, 
	Murad Masimov <m.masimov@mt-integration.ru>
Subject: Re: [PATCH v3 0/3] ocfs2: Fix deadlocks in quota recovery
Message-ID: <vu7b252xprdj7k25aox2qx7vlpyvr42fb6ex55qkcjkkmhxapw@icfo3gjt7sqc>
References: <20250424134301.1392-1-jack@suse.cz>
 <20250424151745.5a62839115508bcaf05f3dcc@linux-foundation.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424151745.5a62839115508bcaf05f3dcc@linux-foundation.org>
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On Thu 24-04-25 15:17:45, Andrew Morton wrote:
> On Thu, 24 Apr 2025 15:45:10 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > this implements another approach to fixing quota recovery deadlocks. We avoid
> > grabbing sb->s_umount semaphore from ocfs2_finish_quota_recovery() and instead
> > stop quota recovery early in ocfs2_dismount_volume(). Andrew, patches seem
> > to be ready. Can you please merge them? Thanks!
> 
> No probs.

Thanks!

> Should these be backported into -stable?  I assume there's no
> identifiable Fixes:.

Yes, I guess it qualifies for -stable. And I forgot to add proper Fixes
tag. It should be:

Fixes: 5f530de63cfc ("ocfs2: Use s_umount for quota recovery protection")

Thanks!
								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
