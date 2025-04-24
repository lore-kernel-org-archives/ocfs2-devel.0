Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC69182BD
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Apr 2025 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745502170; cv=none; b=n1nkcSKRHNmDndNw3jyl7FD3ZCZmiCzwf4mXzgLDYcrOtEvjm23d5G+DWlVlhrcMFTb/O/0CPOKL4GNFj9BouiqDMNzZSJgInUc33cKeFo4mcllBviCukPSNpfENwhmMnOdqfeTSugfgcN7lDkOfFJlKmcxjZWwn3R4C0fLUHlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745502170; c=relaxed/simple;
	bh=YK0NvXI9CxGXsnC++0bmiHRI/1DN/VoXZmEy7bw27BQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jz54c/pAPAWXCKRNpqxONsbea2X8t1zvH8IeEh75hhhA6hWdIR1PIFMEMirFcavkyqqnEL96uaptl5GBb0NP9QJRDGGK1HSCc8/ccc8dj15f1nb0GrBTZ8fy9YGK+MfrM7eU5zr5UXZUPvk3q3DWJ0i4knTyO5JfErpQpUiag5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UgMF4yNw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JYvPQXsH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UgMF4yNw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JYvPQXsH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UgMF4yNw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JYvPQXsH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UgMF4yNw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JYvPQXsH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9E4B81F452;
	Thu, 24 Apr 2025 13:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745502166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hwrXa/iuaPeTJydjzAQKh6pAQ0E8B9AJG1hSZVlrS6w=;
	b=UgMF4yNwh1Tl2mPbRyvg12j6/fgj0kdyiXuUmqQqF733NpLSZ2anz3f+lA9wtPzI0MJe7F
	8OLKVvuDUAl3x8Lgv7eF64g8pRqn2xGnGemg3puEtXbut8cBZ31u63e6T0Arn2yByGDB/f
	9qHMQbqfUGkBqz75p+/jDK8uxzJljvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745502166;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hwrXa/iuaPeTJydjzAQKh6pAQ0E8B9AJG1hSZVlrS6w=;
	b=JYvPQXsH6RU1zWuPuJu5DFjDPAGz/kEZ1dBRDAJ3ho9Z/AgX1sPHz1TMq3UFY/KXBJlZQ+
	Ur2ACxYtToB2rSBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UgMF4yNw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JYvPQXsH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745502166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hwrXa/iuaPeTJydjzAQKh6pAQ0E8B9AJG1hSZVlrS6w=;
	b=UgMF4yNwh1Tl2mPbRyvg12j6/fgj0kdyiXuUmqQqF733NpLSZ2anz3f+lA9wtPzI0MJe7F
	8OLKVvuDUAl3x8Lgv7eF64g8pRqn2xGnGemg3puEtXbut8cBZ31u63e6T0Arn2yByGDB/f
	9qHMQbqfUGkBqz75p+/jDK8uxzJljvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745502166;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hwrXa/iuaPeTJydjzAQKh6pAQ0E8B9AJG1hSZVlrS6w=;
	b=JYvPQXsH6RU1zWuPuJu5DFjDPAGz/kEZ1dBRDAJ3ho9Z/AgX1sPHz1TMq3UFY/KXBJlZQ+
	Ur2ACxYtToB2rSBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 924611393C;
	Thu, 24 Apr 2025 13:42:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wKGwI9Y/CmgYZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Apr 2025 13:42:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 40C81A0921; Thu, 24 Apr 2025 15:42:38 +0200 (CEST)
Date: Thu, 24 Apr 2025 15:42:38 +0200
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>, akpm <akpm@linux-foundation.org>, 
	ocfs2-devel@lists.linux.dev, Heming Zhao <heming.zhao@suse.com>, 
	Murad Masimov <m.masimov@mt-integration.ru>, Shichangkuo <shi.changkuo@h3c.com>
Subject: Re: [PATCH v2 1/3] ocfs2: Switch osb->disable_recovery to enum
Message-ID: <jgsu2kixvz4oiucbxtsvl45lt6iwbudwfzfgvg7swtdllwgyjh@zr7v3x6gi2xc>
References: <20250422123709.15078-1-jack@suse.cz>
 <20250422124138.26027-4-jack@suse.cz>
 <0b4d7927-e8cd-46c8-b751-ac6bc7fc82c2@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b4d7927-e8cd-46c8-b751-ac6bc7fc82c2@linux.alibaba.com>
X-Rspamd-Queue-Id: 9E4B81F452
X-Spam-Score: -4.01
X-Rspamd-Action: no action
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
	RCPT_COUNT_SEVEN(0.00)[7];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Thu 24-04-25 08:59:59, Joseph Qi wrote:
> 
> 
> On 2025/4/22 20:41, Jan Kara wrote:
> > We will need more recovery states than just pure enable / disable to fix
> > deadlocks with quota recovery. Switch osb->disable_recovery to enum.
> > 
> > Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> > Tested-by: Heming Zhao <heming.zhao@suse.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks for review Joseph! It seems Andrew is still merging patches for
OCFS2, doesn't he? So I'll send the patches to him.

								Honza
> > ---
> >  fs/ocfs2/journal.c | 14 ++++++++------
> >  fs/ocfs2/ocfs2.h   |  7 ++++++-
> >  2 files changed, 14 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > index f1b4b3e611cb..8986e813ab2c 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -174,7 +174,7 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
> >  	struct ocfs2_recovery_map *rm;
> >  
> >  	mutex_init(&osb->recovery_lock);
> > -	osb->disable_recovery = 0;
> > +	osb->recovery_state = OCFS2_REC_ENABLED;
> >  	osb->recovery_thread_task = NULL;
> >  	init_waitqueue_head(&osb->recovery_event);
> >  
> > @@ -206,7 +206,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
> >  	/* disable any new recovery threads and wait for any currently
> >  	 * running ones to exit. Do this before setting the vol_state. */
> >  	mutex_lock(&osb->recovery_lock);
> > -	osb->disable_recovery = 1;
> > +	osb->recovery_state = OCFS2_REC_DISABLED;
> >  	mutex_unlock(&osb->recovery_lock);
> >  	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
> >  
> > @@ -1582,14 +1582,16 @@ static int __ocfs2_recovery_thread(void *arg)
> >  
> >  void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
> >  {
> > +	int was_set = -1;
> > +
> >  	mutex_lock(&osb->recovery_lock);
> > +	if (osb->recovery_state < OCFS2_REC_DISABLED)
> > +		was_set = ocfs2_recovery_map_set(osb, node_num);
> >  
> >  	trace_ocfs2_recovery_thread(node_num, osb->node_num,
> > -		osb->disable_recovery, osb->recovery_thread_task,
> > -		osb->disable_recovery ?
> > -		-1 : ocfs2_recovery_map_set(osb, node_num));
> > +		osb->recovery_state, osb->recovery_thread_task, was_set);
> >  
> > -	if (osb->disable_recovery)
> > +	if (osb->recovery_state == OCFS2_REC_DISABLED)
> >  		goto out;
> >  
> >  	if (osb->recovery_thread_task)
> > diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
> > index 51c52768132d..e713361939f0 100644
> > --- a/fs/ocfs2/ocfs2.h
> > +++ b/fs/ocfs2/ocfs2.h
> > @@ -308,6 +308,11 @@ enum ocfs2_journal_trigger_type {
> >  void ocfs2_initialize_journal_triggers(struct super_block *sb,
> >  				       struct ocfs2_triggers triggers[]);
> >  
> > +enum ocfs2_recovery_state {
> > +	OCFS2_REC_ENABLED = 0,
> > +	OCFS2_REC_DISABLED,
> > +};
> > +
> >  struct ocfs2_journal;
> >  struct ocfs2_slot_info;
> >  struct ocfs2_recovery_map;
> > @@ -370,7 +375,7 @@ struct ocfs2_super
> >  	struct ocfs2_recovery_map *recovery_map;
> >  	struct ocfs2_replay_map *replay_map;
> >  	struct task_struct *recovery_thread_task;
> > -	int disable_recovery;
> > +	enum ocfs2_recovery_state recovery_state;
> >  	wait_queue_head_t checkpoint_event;
> >  	struct ocfs2_journal *journal;
> >  	unsigned long osb_commit_interval;
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
