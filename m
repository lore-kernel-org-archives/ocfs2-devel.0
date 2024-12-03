Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135531FA826
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Dec 2024 16:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733244330; cv=none; b=edWu4Dm95W5T9B9Y1hBUGG2RGe3LYXMsTDBMoD8b1lhlQZU870HMvxDza1dyzZMXFe9TERoJ3HRRLIoDgSSLeBne2Mrx6XPKDtZG00zzNLsO7PuveAkmo8hporSXsWcoJFCW1OG0G+E5lk2gYwy0oUeprlq51nqM2Ox4eWwzijA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733244330; c=relaxed/simple;
	bh=B2qxPzPNy/Er+xLn8Lf7rh5iO2QJ9Cs6ceYpMkh5E+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGAvdof9m033UMBp6YVzfX73+Zj77GEsW0eC5mJ/9qmaXOFVctgMJ8neMqz5eDCaYiLrNbpBxcwdUGLZR5lDzY7fBbDv6HMCdJt61vCLlzJ+rm3ja3FI06aekznfjzEZk5ekyCsWcBlNZX4xdAf4/yEwcI8X+lyWbsrQuI5V/YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EpXahnOs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q15fiiC1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EpXahnOs; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=q15fiiC1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EpXahnOs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q15fiiC1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EpXahnOs";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="q15fiiC1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 157D11F451;
	Tue,  3 Dec 2024 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733244327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TSvWYocO+zFS4qWm3uEkkZcbDnPVkPIed4DIECyBTVA=;
	b=EpXahnOseZ58ksJEtka9gryofDUSj0y+CjTXSl1SFEltoeyV37cE67y/grTWTyJNFip/dy
	sYQJPoOF8syEvzFY9nqMwED1a0M0a9HboKZ43jSyG/CqTukyKH1XX3eaYZC9x31gth87LU
	4iFftC57/xvyS54Q0qelbfvYU1CKK4s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733244327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TSvWYocO+zFS4qWm3uEkkZcbDnPVkPIed4DIECyBTVA=;
	b=q15fiiC1hVkJIkhL3N+Vh/cwaXfD/+y+hh/c1i4f/WciRJ4bGdek6jhy3G8kTX4b6cMPc0
	RsxOPImmXiWv6hDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EpXahnOs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=q15fiiC1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733244327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TSvWYocO+zFS4qWm3uEkkZcbDnPVkPIed4DIECyBTVA=;
	b=EpXahnOseZ58ksJEtka9gryofDUSj0y+CjTXSl1SFEltoeyV37cE67y/grTWTyJNFip/dy
	sYQJPoOF8syEvzFY9nqMwED1a0M0a9HboKZ43jSyG/CqTukyKH1XX3eaYZC9x31gth87LU
	4iFftC57/xvyS54Q0qelbfvYU1CKK4s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733244327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TSvWYocO+zFS4qWm3uEkkZcbDnPVkPIed4DIECyBTVA=;
	b=q15fiiC1hVkJIkhL3N+Vh/cwaXfD/+y+hh/c1i4f/WciRJ4bGdek6jhy3G8kTX4b6cMPc0
	RsxOPImmXiWv6hDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFA26139C2;
	Tue,  3 Dec 2024 16:45:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aO90LKY1T2c8YQAAD6G6ig
	(envelope-from <rgoldwyn@suse.de>); Tue, 03 Dec 2024 16:45:26 +0000
Date: Tue, 3 Dec 2024 11:45:25 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: Eric Sandeen <sandeen@redhat.com>
Cc: ocfs2-devel@lists.linux.dev, joseph.qi@linux.alibaba.com, 
	brauner@kernel.org
Subject: Re: [RFC PATCH 0/2] ocfs2, dlmfs: convert to the new mount API
Message-ID: <z5krqu5typmeyi4vbwyinc5pcaeodk4zicjjkrmdsbq4vg6w57@vn5oyugodxks>
References: <20241028144443.609151-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028144443.609151-1-sandeen@redhat.com>
X-Rspamd-Queue-Id: 157D11F451
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO

On  9:41 28/10, Eric Sandeen wrote:
> This has been tested to some degree with a local ocfs2 mount, but I am
> not able to do a proper testing in a clustered environment. I have
> confirmed that AFAICT, random combinations of valid and/or invalid mount
> options on the local mount behave the same before and after these
> changes.
> 
> (Just a side note: I had to omit "ro" mount testing, because simply
> mounting a local ocfs2 filesystem as ro, then unmounting, panics the
> kernel with or without these changes. I haven't looked into why.)
> 
> Any feedback greatly appreciated, thanks!
> 

I have tested these patches in a clustered environment with pacemaker
(pcmk) and can confirm these patches work fine.

Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

-- 
Goldwyn
