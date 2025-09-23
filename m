Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2823320380
	for <ocfs2-devel@lists.linux.dev>; Tue, 23 Sep 2025 12:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758631955; cv=none; b=WKyM0Drv2E/fuTpwlMdE3fyBHz7K4cQ3GX7qURTXQT1A9lJ6Ho2YjiZs+qiMmozMZM05K7bg1WWKCDvjYsxZRdtTXCNrrHsskrsM3qLL/2otgo85YouBIcv+lWcw+6x1k+1XdP56SsWLJlfoJdI2vM/31usjtrGBRp/14hJgirw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758631955; c=relaxed/simple;
	bh=sjd61e03hu245OMhoz0cjX9Ejw3BzIg9ilctwtQrfnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCwpUaMkfPMLUZ+chy7RVI9354opnFi3ybRZ1egvz7zanU7rLNggExIjZKvOnKo5GplrwMmB+Zr58m5T+h5nmMY/7tmaghd4rquQFtbo3PwOCS6poS5ZVaiQhz/DluFuoQswnvd06x5WtW2NU6tw+s3CwN/PkFURsKID9totrvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lNPt1ECH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Q44sAhcI; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kp/YHQba; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7hkXYKuT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lNPt1ECH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Q44sAhcI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kp/YHQba";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7hkXYKuT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DEBF421E41;
	Tue, 23 Sep 2025 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758631952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fh9T3run12o4CnoDgqW2h2il/sJVahqTey2FZapn6XQ=;
	b=lNPt1ECHFcOuMueorji+i3QPLW6E6ExiWtc89lNkez2aWJ99W070j+ZQtdLexqSCKVZsEv
	CwEsihG9x4/Av9eDDTtTneMsm2f58h697b7l0en58nX+9knOdKKs6k3rlBjfEGDFw8en6q
	c1le8VzLB/D6FNKDlpVeHKhy4FhwQkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758631952;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fh9T3run12o4CnoDgqW2h2il/sJVahqTey2FZapn6XQ=;
	b=Q44sAhcIkBhSQMGQ9MyELgJQAWJHmWTHIP3UgPfrbXHYSuutEm0LqcA5xRGmqfGwvv0occ
	eALj6w3hNBU/6oDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758631951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fh9T3run12o4CnoDgqW2h2il/sJVahqTey2FZapn6XQ=;
	b=kp/YHQbaowVgJmfa8jOOXAOm6PEG0VJgTcAYTfKJmwDv2UsGmXASj+CYpOAmNHGdR2/Edd
	ku1BeoIuN8KKBG03NaFqtk188PgoKVkA7IjLl7krHwqNvxktw2p9ZxgpeFPX2/1KY8loAY
	HKnM2V2JlEDO71x+pMFBGUS0w4DpK8Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758631951;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fh9T3run12o4CnoDgqW2h2il/sJVahqTey2FZapn6XQ=;
	b=7hkXYKuTCEzp023kWbutyP8N5+KDfx4MX3e4FVmkrlvJEEPdDpeuXUnO7k+FVYtYNL0H5c
	yW7H5g/NmHI4uZBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1AF2132C9;
	Tue, 23 Sep 2025 12:52:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id STzpIA+Y0mh2IAAAD6G6ig
	(envelope-from <rgoldwyn@suse.de>); Tue, 23 Sep 2025 12:52:31 +0000
Date: Tue, 23 Sep 2025 08:52:25 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix double free in user_cluster_connect()
Message-ID: <okxwk7vmbvfxiypz2uvigrlupr3qbiqenzhih2dehjd3hu4mxd@qtqa6oikikrr>
References: <aNKDz_7JF7aycZ0k@stanley.mountain>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNKDz_7JF7aycZ0k@stanley.mountain>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.98%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80

On 14:26 23/09, Dan Carpenter wrote:
> The user_cluster_disconnect() function frees "conn->cc_private" which is
> "lc" but then the error handling frees "lc" a second time.  Set "lc" to
> NULL on this path to avoid a double free.
> 
> Fixes: c994c2ebdbbc ("ocfs2: use the new DLM operation callbacks while requesting new lockspace")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Looks good. Thanks!

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

-- 
Goldwyn
