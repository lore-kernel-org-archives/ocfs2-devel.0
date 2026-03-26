Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A2434751C
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 09:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774517893; cv=none; b=U1kY5JiI4wTH5e0Qnm5kYYR0ufuh344f9+ElrITcD/6qRuP3hE2xCqk1g1l5+baVYlQWx8uF+LkELs/r7c5WjrXOzIw7++Kp95LXTon4ewqVi/jVxE7k1epMCk4fGNdSvdyS4x4je4TimYSHRLp0zF/HvKb/AjGmpcU5TI4zRG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774517893; c=relaxed/simple;
	bh=iU5x2mPVW97jYuVMzDw3xzwua1ptwIwf57J2H2cj5Mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6zruOPdTy819//GHAxiVMFdRQG8ue0DjNEAv0nWdyv+dte7blyVoFbI8LyrTGsO3lhb7MJl9ha2DaGSNqhvvboK4mhFVEMZZnDGJpJD+hK84udUK3bGxbBO3i1KlJ1yJBvpSs6XlSeOYp/ejaeYpHTTaClX3CoO0wKODEqYU5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RFr+r66l; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FgQtNCut; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RFr+r66l; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FgQtNCut; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RFr+r66l";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FgQtNCut";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RFr+r66l";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FgQtNCut"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 70BE95BCD5;
	Thu, 26 Mar 2026 09:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774517890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vmfBG8yXgT+5+CqAU0XjqM8BllwnD2Iaw798YSaZULY=;
	b=RFr+r66lB2YViC1zDxI77rkN/kQs/Xk7xPKuSVonfcvIkwAlu+FYnJknOevQCfCzUUWZ8g
	8pRA5g8REQzuVQU2p+qan8p8fugnkwVnxKHM5zfOoCGCxShfWwI3bTBkHLj2zT8r232i75
	jOMT3A6NJA1n14BpwqNL5ltr/QbWo4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774517890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vmfBG8yXgT+5+CqAU0XjqM8BllwnD2Iaw798YSaZULY=;
	b=FgQtNCutDirH2LNyqorUIvebcH2QFbhKhXoelQ/zQkMGUZQj+AZFcXLwDMqr38mYOi9YsB
	Lfr4taWuSdIJL/AA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774517890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vmfBG8yXgT+5+CqAU0XjqM8BllwnD2Iaw798YSaZULY=;
	b=RFr+r66lB2YViC1zDxI77rkN/kQs/Xk7xPKuSVonfcvIkwAlu+FYnJknOevQCfCzUUWZ8g
	8pRA5g8REQzuVQU2p+qan8p8fugnkwVnxKHM5zfOoCGCxShfWwI3bTBkHLj2zT8r232i75
	jOMT3A6NJA1n14BpwqNL5ltr/QbWo4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774517890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vmfBG8yXgT+5+CqAU0XjqM8BllwnD2Iaw798YSaZULY=;
	b=FgQtNCutDirH2LNyqorUIvebcH2QFbhKhXoelQ/zQkMGUZQj+AZFcXLwDMqr38mYOi9YsB
	Lfr4taWuSdIJL/AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 676984A0A3;
	Thu, 26 Mar 2026 09:38:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MJY8GYL+xGkxSwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:38:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2AF92A0976; Thu, 26 Mar 2026 10:38:06 +0100 (CET)
Date: Thu, 26 Mar 2026 10:38:06 +0100
From: Jan Kara <jack@suse.cz>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, jack@suse.cz, glass.su@suse.com
Subject: Re: [PATCH v3 2/2] Revert "ocfs2: fix DIO failure due to
 insufficient transaction credits"
Message-ID: <6byxycm7y3ppayqux5ylpvmoerwdldyyn6pysptsnwinm6ixsv@wgbxngzbyghd>
References: <20260326065821.15156-1-heming.zhao@suse.com>
 <20260326065821.15156-3-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326065821.15156-3-heming.zhao@suse.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO

On Thu 26-03-26 14:58:18, Heming Zhao wrote:
> This reverts commit be346c1a6eeb49d8fda827d2a9522124c2f72f36.
> 
> With the patch "ocfs2: split transactions in dio completion to avoid
> credit exhaustion," the jbd2 transaction is now restarted every
> OCFS2_DIO_MARK_EXTENT_BATCH loops. In theory, this should prevent
> credit exhaustion issues from occurring.

I don't see why that would be the case. Look at the commit message of
be346c1a6eeb49d8fda827d2a9522124c2f72f36. The problem is that
ocfs2_calc_extend_credits() doesn't (and hardly can) estimate maximum
number of credits needed for all extent tree manipulations. Some extent tree
manipulations in ocfs2_mark_extent_written() don't reserve additional
credits on their own. This ocfs2_assure_trans_credits() call won't be
needed if you didn't do any batching of extent conversions into a single
transaction. But if you do that, there's no guarantee that all conversions
in a single batch can fit in the amount of credits reserved initially.
Usually it will be the case but I don't see how that would be guaranteed in
every case.

								Honza

> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  fs/ocfs2/aops.c        |  5 -----
>  fs/ocfs2/journal.c     | 17 -----------------
>  fs/ocfs2/journal.h     |  2 --
>  fs/ocfs2/ocfs2_trace.h |  2 --
>  4 files changed, 26 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 60f1b607022f..e58314c6506a 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2332,11 +2332,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  				break;
>  			}
>  		}
> -		ret = ocfs2_assure_trans_credits(handle, credits);
> -		if (ret < 0) {
> -			mlog_errno(ret);
> -			break;
> -		}
>  		ret = ocfs2_mark_extent_written(inode, &et, handle,
>  						ue->ue_cpos, 1,
>  						ue->ue_phys,
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 4c86a9d46870..7e7546e070fb 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -464,23 +464,6 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
>  	return status;
>  }
>  
> -/*
> - * Make sure handle has at least 'nblocks' credits available. If it does not
> - * have that many credits available, we will try to extend the handle to have
> - * enough credits. If that fails, we will restart transaction to have enough
> - * credits. Similar notes regarding data consistency and locking implications
> - * as for ocfs2_extend_trans() apply here.
> - */
> -int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
> -{
> -	int old_nblks = jbd2_handle_buffer_credits(handle);
> -
> -	trace_ocfs2_assure_trans_credits(old_nblks);
> -	if (old_nblks >= nblocks)
> -		return 0;
> -	return ocfs2_extend_trans(handle, nblocks - old_nblks);
> -}
> -
>  /*
>   * If we have fewer than thresh credits, extend by OCFS2_MAX_TRANS_DATA.
>   * If that fails, restart the transaction & regain write access for the
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index 6397170f302f..9d4763f758ad 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -244,8 +244,6 @@ handle_t		    *ocfs2_start_trans(struct ocfs2_super *osb,
>  int			     ocfs2_commit_trans(struct ocfs2_super *osb,
>  						handle_t *handle);
>  int			     ocfs2_extend_trans(handle_t *handle, int nblocks);
> -int			     ocfs2_assure_trans_credits(handle_t *handle,
> -						int nblocks);
>  int			     ocfs2_allocate_extend_trans(handle_t *handle,
>  						int thresh);
>  
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index 4b32fb5658ad..74b283875e17 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -2575,8 +2575,6 @@ DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_commit_cache_end);
>  
>  DEFINE_OCFS2_INT_INT_EVENT(ocfs2_extend_trans);
>  
> -DEFINE_OCFS2_INT_EVENT(ocfs2_assure_trans_credits);
> -
>  DEFINE_OCFS2_INT_EVENT(ocfs2_extend_trans_restart);
>  
>  DEFINE_OCFS2_INT_INT_EVENT(ocfs2_allocate_extend_trans);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
