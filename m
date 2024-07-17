Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25626433DF
	for <ocfs2-devel@lists.linux.dev>; Wed, 17 Jul 2024 13:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721221761; cv=none; b=USKQW/9PU0Q1DsYZ85O6vBA8Vo4vS3M2eaRiz3/cXgo/UdKwpXBGaqkwQuphb1BxbCBsiN7AYoN3oYV9Ab5aApBcLerJvlkkXfatajj+qSyn/jaNtTmQ0/VPt0Nv0vPZnZA8lsAZka6hfB2bL8NlXdmD3rXy9fGwYDHb27WNAGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721221761; c=relaxed/simple;
	bh=BRZGG4xrDva0qCLU6PS97WxJGyw0A+QKEt3Ur6Gdth4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E1CajlK9rDQNOtNIsfMYBeiONVYybVnAkaAosmXJjY4TJaSU6cM6xGArfQPwfeYjbEXPQH0O2p+Of9oZgaT7/bE8oM7fqfNWajKk+RMihFMiZuS+nMi8lA8t27/0csfyYSOuNnte3Y9VsBn1day5r9TM/q8DZ/vI+1yZmPgZvMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xzJm8ufW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=w1N8++Kj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xzJm8ufW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=w1N8++Kj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xzJm8ufW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="w1N8++Kj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xzJm8ufW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="w1N8++Kj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1A7D71FB7F;
	Wed, 17 Jul 2024 13:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721221758; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1X5zF2e3ed+7pjk1P5AqGhiD9y5udzLMGekEyZDkQwg=;
	b=xzJm8ufWPOXoASQt/+4WPUw3gFMHZJKHC9QAqi5cBAEYq5m5uedEsrgPOqPFf23LRAv7Ip
	F/A+08iE0bjIXCSgktBfCH1PnFyY6a4E2B67Cfie/7KaS62NYFGm9JI8mBQJMu8GQ+xfsB
	b3gv1K/z4/cy7EMbwh9ThTsh55GQetM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721221758;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1X5zF2e3ed+7pjk1P5AqGhiD9y5udzLMGekEyZDkQwg=;
	b=w1N8++Kjxoge/oODrFK/HCgJ5Kn+60DCUumksA8HPskvOnFtl4pyFlNoO+2Mult3/WJj8k
	D/MNpz5UgpeGEAAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xzJm8ufW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=w1N8++Kj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721221758; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1X5zF2e3ed+7pjk1P5AqGhiD9y5udzLMGekEyZDkQwg=;
	b=xzJm8ufWPOXoASQt/+4WPUw3gFMHZJKHC9QAqi5cBAEYq5m5uedEsrgPOqPFf23LRAv7Ip
	F/A+08iE0bjIXCSgktBfCH1PnFyY6a4E2B67Cfie/7KaS62NYFGm9JI8mBQJMu8GQ+xfsB
	b3gv1K/z4/cy7EMbwh9ThTsh55GQetM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721221758;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1X5zF2e3ed+7pjk1P5AqGhiD9y5udzLMGekEyZDkQwg=;
	b=w1N8++Kjxoge/oODrFK/HCgJ5Kn+60DCUumksA8HPskvOnFtl4pyFlNoO+2Mult3/WJj8k
	D/MNpz5UgpeGEAAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 037A0136E5;
	Wed, 17 Jul 2024 13:09:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WTTWAH7Cl2ZSawAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Jul 2024 13:09:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9E773A0987; Wed, 17 Jul 2024 15:09:17 +0200 (CEST)
Date: Wed, 17 Jul 2024 15:09:17 +0200
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, jack@suse.com, mark@fasheh.com,
	jlbec@evilplan.org, hughd@google.com, akpm@linux-foundation.org,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/4] quota: avoid missing put_quota_format when
 DQUOT_SUSPENDED is passed
Message-ID: <20240717130917.sbxkbgglhwq2wcrg@quack3>
References: <20240715130534.2112678-1-shikemeng@huaweicloud.com>
 <20240715130534.2112678-2-shikemeng@huaweicloud.com>
 <afca4e22-7edd-494f-9a43-66d1098a3ec4@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afca4e22-7edd-494f-9a43-66d1098a3ec4@linux.alibaba.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim]
X-Spam-Flag: NO
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 1A7D71FB7F

On Tue 16-07-24 09:10:18, Joseph Qi wrote:
> 
> 
> On 7/15/24 9:05 PM, Kemeng Shi wrote:
> > Avoid missing put_quota_format when DQUOT_SUSPENDED is passed to
> > dquot_load_quota_sb.
> > 
> 
> It seems worth a 'Fixes' tag:
> Fixes: d44c57663723 ("quota: Remove BUG_ON in dquot_load_quota_sb()")
> 
> Other looks good to me. So with the above addressed, feel free to add:
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks for the patch and review. I'll add the tag on commit.

								Honza

> 
> > Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> > ---
> >  fs/quota/dquot.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> > index 627eb2f72ef3..23fcf9e9d6c5 100644
> > --- a/fs/quota/dquot.c
> > +++ b/fs/quota/dquot.c
> > @@ -2408,7 +2408,7 @@ static int vfs_setup_quota_inode(struct inode *inode, int type)
> >  int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
> >  	unsigned int flags)
> >  {
> > -	struct quota_format_type *fmt = find_quota_format(format_id);
> > +	struct quota_format_type *fmt;
> >  	struct quota_info *dqopt = sb_dqopt(sb);
> >  	int error;
> >  
> > @@ -2418,6 +2418,7 @@ int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
> >  	if (WARN_ON_ONCE(flags & DQUOT_SUSPENDED))
> >  		return -EINVAL;
> >  
> > +	fmt = find_quota_format(format_id);
> >  	if (!fmt)
> >  		return -ESRCH;
> >  	if (!sb->dq_op || !sb->s_qcop ||
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
