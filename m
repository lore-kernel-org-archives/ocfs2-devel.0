Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3B48F55
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Aug 2023 09:57:11 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B1E0A22C27;
	Tue, 22 Aug 2023 09:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1692698229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7U2NZ9gBWxfHpuzZJzDtLLb5BwFQB7ksHfZ1FviXIic=;
	b=nWcw18K8U7VM/+JsYDZT2tDiq+CKb75kJ7TWHiMWtPZMYFXSD858+G/7pkmjVH+HsdAtq7
	CAVH0VAEVBpZu7CDdoPYIaDNF89rPv1kF51gaPoVV6/kR714R6o2VARAe3KSx/COZVZTjf
	5NF7tExOIfSiwqfOPhbfJskPx/j7Bt8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1692698229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7U2NZ9gBWxfHpuzZJzDtLLb5BwFQB7ksHfZ1FviXIic=;
	b=Enin00QOQW+utBJfkJDSRot2sJX8/BA7MGMjtqQQzma2I1nMxrm8G5edJB7525uHLLqVok
	MUfHIj79EG+QQADQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A058D13919;
	Tue, 22 Aug 2023 09:57:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id W60QJ3WG5GRpFQAAMHmgww
	(envelope-from <jack@suse.cz>); Tue, 22 Aug 2023 09:57:09 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 19A4FA0774; Tue, 22 Aug 2023 11:57:09 +0200 (CEST)
Date: Tue, 22 Aug 2023 11:57:09 +0200
From: Jan Kara <jack@suse.cz>
To: Yang Yingliang <yangyingliang@huawei.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com, tytso@mit.edu, yi.zhang@huawei.com,
	jack@suse.cz
Subject: Re: [PATCH -next] jbd2,ocfs2: fix wrong pointer pass to PTR_ERR()
Message-ID: <20230822095709.tywqhinolf2oprpa@quack3>
References: <20230822030018.644419-1-yangyingliang@huawei.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230822030018.644419-1-yangyingliang@huawei.com>

On Tue 22-08-23 11:00:18, Yang Yingliang wrote:
> Fix wrong pointer pass to PTR_ERR() if jbd2_journal_init_inode() fails.
> 
> Fixes: c279913275eb ("jbd2: jbd2_journal_init_{dev,inode} return proper error return value")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Oh right, I've missed this during my review. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/journal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 90af6c47161d..ce215565d061 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -910,7 +910,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>  	j_journal = jbd2_journal_init_inode(inode);
>  	if (IS_ERR(j_journal)) {
>  		mlog(ML_ERROR, "Linux journal layer error\n");
> -		status = PTR_ERR(journal);
> +		status = PTR_ERR(j_journal);
>  		goto done;
>  	}
>  
> -- 
> 2.25.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
