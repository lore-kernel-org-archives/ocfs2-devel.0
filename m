Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47D81F09B3
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Apr 2025 12:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745324597; cv=none; b=jdJQL/IsL09wu+dh4vQBY4WLlJL2vGJ7WErAtbfefO7IsL2czpMaJjqfKuYSJZxhBZnV4dSlYJPgX1HbYRA/CXWJ0fFjr2H2x8+p4zfLTwgj7VUuFKZp3l37P1E/g7H4Qri0LZeZvASdeFIjfLiBcvnFUlTRabeSNiW35oIATdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745324597; c=relaxed/simple;
	bh=P7p3qvHBw46pPL8gkAJDwY1qKZas8B4dUWTgsocJMAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iYBbfkHBNkUoQx0f1ByKl8uLIkl36ZTNIJz44oPTpoJWEIMYn+iJ2ZQ57ErKzErAxiL6w+AGdJbnN0LwDsieLqs2q5slrpCgTPPKsgnGpnGVNvomyQ4tm0KoP5tS3ieX18m9jl5lRrlrIV+nI0Ev8oG3tNQCB/5kNDgjO/MtBww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LmyJGhQZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xOWsz/wT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LmyJGhQZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xOWsz/wT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LmyJGhQZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xOWsz/wT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LmyJGhQZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xOWsz/wT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CC6931F38D;
	Tue, 22 Apr 2025 12:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745324591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z8cwW7hpk7JGDMDZOPQmd3fyBj22b6WWYc8H0g5EboI=;
	b=LmyJGhQZq1jLF5XzuGoamCP+XHh0ivlDCzY19vlFnX1IUfEAuSf9tqM9PDeqXyjK3fRxZM
	uKOTntlpbaoavdzAOc0BgMZ726KTUzm1lDXtyzIQKQXSGmUIoNrtya5dIRUXDIH/D3Ju/v
	c4TrUFZvebEIRlYDfC9JVMv9yYmh2O0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745324591;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z8cwW7hpk7JGDMDZOPQmd3fyBj22b6WWYc8H0g5EboI=;
	b=xOWsz/wTvctcuWcDy5CFHNf1sC1ekIi3V16qb3aL4K/xJBU6ItRb5kz943oqQFyw/vua0F
	J9ZaLLawtcgXxmCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1745324591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z8cwW7hpk7JGDMDZOPQmd3fyBj22b6WWYc8H0g5EboI=;
	b=LmyJGhQZq1jLF5XzuGoamCP+XHh0ivlDCzY19vlFnX1IUfEAuSf9tqM9PDeqXyjK3fRxZM
	uKOTntlpbaoavdzAOc0BgMZ726KTUzm1lDXtyzIQKQXSGmUIoNrtya5dIRUXDIH/D3Ju/v
	c4TrUFZvebEIRlYDfC9JVMv9yYmh2O0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1745324591;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z8cwW7hpk7JGDMDZOPQmd3fyBj22b6WWYc8H0g5EboI=;
	b=xOWsz/wTvctcuWcDy5CFHNf1sC1ekIi3V16qb3aL4K/xJBU6ItRb5kz943oqQFyw/vua0F
	J9ZaLLawtcgXxmCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C2462137CF;
	Tue, 22 Apr 2025 12:23:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KYxsLy+KB2i7HgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Apr 2025 12:23:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7097BA0734; Tue, 22 Apr 2025 14:23:07 +0200 (CEST)
Date: Tue, 22 Apr 2025 14:23:07 +0200
From: Jan Kara <jack@suse.cz>
To: Heming Zhao <heming.zhao@suse.com>
Cc: Jan Kara <jack@suse.cz>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Murad Masimov <m.masimov@mt-integration.ru>, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH 2/3] ocfs2: Implement handshaking with ocfs2 recovery
 thread
Message-ID: <ivsgxgtbrlsfrclvyfhhs3dvaty2teban3c7bgzjxijiwg4ejg@adahy2kizyk6>
References: <20250403112908.13750-1-jack@suse.cz>
 <20250403113250.20572-5-jack@suse.cz>
 <a0c7e040-d953-40bc-8c84-a2984b8c381e@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0c7e040-d953-40bc-8c84-a2984b8c381e@suse.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	RCPT_COUNT_FIVE(0.00)[5];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Score: -3.80
X-Spam-Flag: NO

On Tue 22-04-25 12:08:28, Heming Zhao wrote:
> On 4/3/25 19:32, Jan Kara wrote:
> > We will need ocfs2 recovery thread to acknowledge transitions of
> > recovery_state when disabling particular types of recovery. This is
> > similar to what currently happens when disabling recovery completely,
> > just more general. Implement the handshake and use it for exit from
> > recovery.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >   fs/ocfs2/journal.c | 52 +++++++++++++++++++++++++++++++---------------
> >   fs/ocfs2/ocfs2.h   |  4 ++++
> >   2 files changed, 39 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> > index 8986e813ab2c..bed57687cc60 100644
> > --- a/fs/ocfs2/journal.c
> > +++ b/fs/ocfs2/journal.c
> > @@ -190,31 +190,48 @@ int ocfs2_recovery_init(struct ocfs2_super *osb)
> >   	return 0;
> >   }
> > -/* we can't grab the goofy sem lock from inside wait_event, so we use
> > - * memory barriers to make sure that we'll see the null task before
> > - * being woken up */
> >   static int ocfs2_recovery_thread_running(struct ocfs2_super *osb)
> >   {
> > -	mb();
> >   	return osb->recovery_thread_task != NULL;
> >   }
> > -void ocfs2_recovery_exit(struct ocfs2_super *osb)
> > +static void ocfs2_recovery_disable(struct ocfs2_super *osb,
> > +				   enum ocfs2_recovery_state state)
> >   {
> > -	struct ocfs2_recovery_map *rm;
> > -
> > -	/* disable any new recovery threads and wait for any currently
> > -	 * running ones to exit. Do this before setting the vol_state. */
> >   	mutex_lock(&osb->recovery_lock);
> > -	osb->recovery_state = OCFS2_REC_DISABLED;
> > +	/*
> > +	 * If recovery thread is not running, we can directly transition to
> > +	 * final state.
> > +	 */
> > +	if (!ocfs2_recovery_thread_running(osb)) {
> > +		osb->recovery_state = state + 1;
> > +		goto out_lock;
> > +	}
> > +	osb->recovery_state = state;
> > +	/* Wait for recovery thread to acknowledge state transition */
> > +	wait_event_cmd(osb->recovery_event,
> > +		       !ocfs2_recovery_thread_running(osb) ||
> > +				osb->recovery_state >= state + 1,
> > +		       mutex_unlock(&osb->recovery_lock),
> > +		       mutex_lock(&osb->recovery_lock));
> > +out_lock:
> >   	mutex_unlock(&osb->recovery_lock);
> > -	wait_event(osb->recovery_event, !ocfs2_recovery_thread_running(osb));
> > -	/* At this point, we know that no more recovery threads can be
> > -	 * launched, so wait for any recovery completion work to
> > -	 * complete. */
> > +	/*
> > +	 * At this point we know that no more recovery work can be queued so
> > +	 * wait for any recovery completion work to complete.
> > +	 */
> >   	if (osb->ocfs2_wq)
> >   		flush_workqueue(osb->ocfs2_wq);
> > +}
> > +
> > +void ocfs2_recovery_exit(struct ocfs2_super *osb)
> > +{
> > +	struct ocfs2_recovery_map *rm;
> > +
> > +	/* disable any new recovery threads and wait for any currently
> > +	 * running ones to exit. Do this before setting the vol_state. */
> > +	ocfs2_recovery_disable(osb, OCFS2_REC_WANT_DISABLE);
> >   	/*
> >   	 * Now that recovery is shut down, and the osb is about to be
> > @@ -1569,7 +1586,8 @@ static int __ocfs2_recovery_thread(void *arg)
> >   	ocfs2_free_replay_slots(osb);
> >   	osb->recovery_thread_task = NULL;
> > -	mb(); /* sync with ocfs2_recovery_thread_running */
> > +	if (osb->recovery_state == OCFS2_REC_WANT_DISABLE)
> > +		osb->recovery_state = OCFS2_REC_QUOTA_DISABLED;
> 
> OCFS2_REC_QUOTA_DISABLED is defined in [patch 3/3], so the
> above line will make gcc unhappy.
> All other code looks good to me.

Thanks for review and testing! I'll fix this up and send v2.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
