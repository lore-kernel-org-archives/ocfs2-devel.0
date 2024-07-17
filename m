Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE111802A3
	for <ocfs2-devel@lists.linux.dev>; Wed, 17 Jul 2024 13:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721221938; cv=none; b=NSdFR1Mf2YUIoeQMedsI1pwUzqhahzm+A3SUM+BUWeKqO/rbzLfMg+bn1zU11YpIXEDO7oVrJwPpy9r8+rGp6IGrRxrSUbLIZ1V/xeuLxgQUxYrQhbJCCPixRoFh2GoatxBN3xw6Ns6cPydYC8ZOVZk2h8H5vAVhf4h5E2nBCWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721221938; c=relaxed/simple;
	bh=7jYcfZbZTqJqyfizIPyc3nXvbkvl6k6c5g3lHzdFKD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VrbtrrFebFY0Ipv9X5giFhHOKGw8HOA+UgaFapiiaLd6qG+J8ARt+jCDJINAVAPIfC4Rgx+beVZhzJAwRDx5nOrrmrQGcjQd2yCcu77oOoFkLDCzLDovOtMIK1t7nZVHU2Hp7t3+NOpr3WesOojfpYavdVyb2Df4Z2qkC4ObgzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yn0eYBm5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SltmJzhJ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yn0eYBm5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SltmJzhJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yn0eYBm5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SltmJzhJ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yn0eYBm5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SltmJzhJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 97F6E1FB82;
	Wed, 17 Jul 2024 13:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721221935; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JzV5Kbli/7nNdaaLLJp5ngAKh1EzYbtVHYUprSvEpYs=;
	b=yn0eYBm5vUslVZpeFukTwPzW3o1uWXM4+KgqXihGaqmHcb7SKjpv5NFVi9psDcautRvcMB
	dhLdV9RR17SDPGhoHrkI7FjD2+paIvhXLptBCYFi2QA3fiJBGZBTDpphNMBSx2Qs/vU3bV
	7WafOHB6LzqYz1Xvrbee96P+oZnDCUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721221935;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JzV5Kbli/7nNdaaLLJp5ngAKh1EzYbtVHYUprSvEpYs=;
	b=SltmJzhJza9UN8X7CYx6Eqo9w4ba8kz3j6ywLQMeck7vtyFtGUxVbcDtIWzlh35MnAJae3
	cgZ+I1lRsM+mBqDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721221935; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JzV5Kbli/7nNdaaLLJp5ngAKh1EzYbtVHYUprSvEpYs=;
	b=yn0eYBm5vUslVZpeFukTwPzW3o1uWXM4+KgqXihGaqmHcb7SKjpv5NFVi9psDcautRvcMB
	dhLdV9RR17SDPGhoHrkI7FjD2+paIvhXLptBCYFi2QA3fiJBGZBTDpphNMBSx2Qs/vU3bV
	7WafOHB6LzqYz1Xvrbee96P+oZnDCUk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721221935;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JzV5Kbli/7nNdaaLLJp5ngAKh1EzYbtVHYUprSvEpYs=;
	b=SltmJzhJza9UN8X7CYx6Eqo9w4ba8kz3j6ywLQMeck7vtyFtGUxVbcDtIWzlh35MnAJae3
	cgZ+I1lRsM+mBqDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B263136E5;
	Wed, 17 Jul 2024 13:12:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5aH0IS/Dl2Y0bAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Jul 2024 13:12:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 43D08A0987; Wed, 17 Jul 2024 15:12:15 +0200 (CEST)
Date: Wed, 17 Jul 2024 15:12:15 +0200
From: Jan Kara <jack@suse.cz>
To: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: jack@suse.com, mark@fasheh.com, jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com, hughd@google.com,
	akpm@linux-foundation.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] Fix and cleanups to quota
Message-ID: <20240717131215.6rzqis37vi35z52p@quack3>
References: <20240715130534.2112678-1-shikemeng@huaweicloud.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240715130534.2112678-1-shikemeng@huaweicloud.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.986];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 

On Mon 15-07-24 21:05:30, Kemeng Shi wrote:
> This series contains some random fix and cleanups to fs quota. Please
> check respective patches for more detail. Thanks!
> 
> Kemeng Shi (4):
>   quota: avoid missing put_quota_format when DQUOT_SUSPENDED is passed
>   quota: remove unneeded return value of register_quota_format
>   quota: remove redundant return at end of void function
>   quota: remove unnecessary error code translation in dquot_quota_enable

Thanks! All the patches look good to me. I'll queue them into my tree.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
