Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66858749C
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Mar 2026 09:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774517524; cv=none; b=mvP5S3VspamGZn57kKd6S3Ib4HuYUg9enRuqPDb8Qu2TwipUrm55nIt6rJjT+Aner8iXKZc6AB2M22lsJ8aPgOXaxdoak5g0aFOiuOBQI5UDbVXqYG4ebMv8a+kwelJybNfidcuMRHdqzhorYrefT5RWYOVLw1OgvWVdgQXnvCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774517524; c=relaxed/simple;
	bh=FWi5RSbxzcBtfDvPFjcYil5X5jmjPE2fEveh54tzOlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQh0Ila9cbRZUhTKZnJjfgyk6np7G7gSTuwKjlvr5DnxReCTGon7/YaY5giRR3hpTe4FeW5VI9g3lE7ZjxlmZCNFGuyVK2d4/WnU/XciSz9oI5ddO009HTX1hXwUcIFyDFpDP+FDQiwSxkVBhnfCExh50jKcY6hxeFzEw3KHQa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cIuPnxd/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pTiGt1qr; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cIuPnxd/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pTiGt1qr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cIuPnxd/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pTiGt1qr";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cIuPnxd/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pTiGt1qr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 931545BCD5;
	Thu, 26 Mar 2026 09:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774517519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=etwlXafhsIN5sbhblZWTmnp0zJkhoVpCOycxZH+u8AE=;
	b=cIuPnxd/zi2UK0pJxt174lkopZQhOIKXjPzIzsMRpzeOU3R04qkDFrAnc3pIr8vmMC5Px1
	Coa8575KfarIKfqPkOlZTyGhYmDCnQ+9p2jtl5EB8PfvHzo0VNgBRth7fuVKqpouccqSKD
	/i0dRvjhsPCvNyCDbJzmRoAS8JpyY+Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774517519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=etwlXafhsIN5sbhblZWTmnp0zJkhoVpCOycxZH+u8AE=;
	b=pTiGt1qruSIoZymD9fncG+Lt8Q+xkF8CvblOF0nX6hqJOhCPFdbSKgkxrJFon+DZSUqNz6
	3M/TQG7tKEzLOKDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="cIuPnxd/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pTiGt1qr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774517519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=etwlXafhsIN5sbhblZWTmnp0zJkhoVpCOycxZH+u8AE=;
	b=cIuPnxd/zi2UK0pJxt174lkopZQhOIKXjPzIzsMRpzeOU3R04qkDFrAnc3pIr8vmMC5Px1
	Coa8575KfarIKfqPkOlZTyGhYmDCnQ+9p2jtl5EB8PfvHzo0VNgBRth7fuVKqpouccqSKD
	/i0dRvjhsPCvNyCDbJzmRoAS8JpyY+Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774517519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=etwlXafhsIN5sbhblZWTmnp0zJkhoVpCOycxZH+u8AE=;
	b=pTiGt1qruSIoZymD9fncG+Lt8Q+xkF8CvblOF0nX6hqJOhCPFdbSKgkxrJFon+DZSUqNz6
	3M/TQG7tKEzLOKDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 85C234A0A3;
	Thu, 26 Mar 2026 09:31:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mF2hIA/9xGm0QQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:31:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4845BA0976; Thu, 26 Mar 2026 10:31:51 +0100 (CET)
Date: Thu, 26 Mar 2026 10:31:51 +0100
From: Jan Kara <jack@suse.cz>
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, jack@suse.cz, glass.su@suse.com
Subject: Re: [PATCH v3 1/2] ocfs2: split transactions in dio completion to
 avoid credit exhaustion
Message-ID: <yqubr44ypca3emh5fem3gpjbkviymk5wa26keoqmmyj6o4vmkc@zumircxyi7pt>
References: <20260326065821.15156-1-heming.zhao@suse.com>
 <20260326065821.15156-2-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326065821.15156-2-heming.zhao@suse.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Queue-Id: 931545BCD5
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Thu 26-03-26 14:58:17, Heming Zhao wrote:
> During ocfs2 dio operations, JBD2 may report warnings via following call trace:
> ocfs2_dio_end_io_write
>  ocfs2_mark_extent_written
>   ocfs2_change_extent_flag
>    ocfs2_split_extent
>     ocfs2_try_to_merge_extent
>      ocfs2_extend_rotate_transaction
>       ocfs2_extend_trans
>        jbd2__journal_restart
>         start_this_handle
>          output: JBD2: kworker/6:2 wants too many credits credits:5450 rsv_credits:0 max:5449
> 
> To prevent exceeding the credits limit, modify ocfs2_dio_end_io_write()
> to handle extent in a batch of transaction.
> 
> Additionally, relocate ocfs2_del_inode_from_orphan(). The orphan inode should
> only be removed from the orphan list after the extent tree update is complete.
> this ensures that if a crash occurs in the middle of extent tree updates, we
> won't leave stale blocks beyond EOF.
> 
> Finally, thanks to Jans and Joseph for providing the bug fix prototype and
> suggestions.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/aops.c | 72 ++++++++++++++++++++++++++++++-------------------
>  1 file changed, 44 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 09146b43d1f0..60f1b607022f 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -37,6 +37,8 @@
>  #include "namei.h"
>  #include "sysfile.h"
>  
> +#define OCFS2_DIO_MARK_EXTENT_BATCH 200
> +
>  static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
>  				   struct buffer_head *bh_result, int create)
>  {
> @@ -2277,7 +2279,7 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  	struct ocfs2_alloc_context *meta_ac = NULL;
>  	handle_t *handle = NULL;
>  	loff_t end = offset + bytes;
> -	int ret = 0, credits = 0;
> +	int ret = 0, credits = 0, batch = 0;
>  
>  	ocfs2_init_dealloc_ctxt(&dealloc);
>  
> @@ -2294,18 +2296,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  		goto out;
>  	}
>  
> -	/* Delete orphan before acquire i_rwsem. */
> -	if (dwc->dw_orphaned) {
> -		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> -
> -		end = end > i_size_read(inode) ? end : 0;
> -
> -		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh,
> -				!!end, end);
> -		if (ret < 0)
> -			mlog_errno(ret);
> -	}
> -
>  	down_write(&oi->ip_alloc_sem);
>  	di = (struct ocfs2_dinode *)di_bh->b_data;
>  
> @@ -2326,20 +2316,22 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  
>  	credits = ocfs2_calc_extend_credits(inode->i_sb, &di->id2.i_list);
>  
> -	handle = ocfs2_start_trans(osb, credits);
> -	if (IS_ERR(handle)) {
> -		ret = PTR_ERR(handle);
> -		mlog_errno(ret);
> -		goto unlock;
> -	}
> -	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> -				      OCFS2_JOURNAL_ACCESS_WRITE);
> -	if (ret) {
> -		mlog_errno(ret);
> -		goto commit;
> -	}
> -
>  	list_for_each_entry(ue, &dwc->dw_zero_list, ue_node) {
> +		if (!handle) {
> +			handle = ocfs2_start_trans(osb, credits);
> +			if (IS_ERR(handle)) {
> +				ret = PTR_ERR(handle);
> +				mlog_errno(ret);
> +				handle = NULL;
> +				break;
> +			}
> +			ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode), di_bh,
> +					OCFS2_JOURNAL_ACCESS_WRITE);
> +			if (ret) {
> +				mlog_errno(ret);
> +				break;
> +			}
> +		}
>  		ret = ocfs2_assure_trans_credits(handle, credits);
>  		if (ret < 0) {
>  			mlog_errno(ret);
> @@ -2353,17 +2345,41 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
>  			mlog_errno(ret);
>  			break;
>  		}
> +
> +		if (++batch == OCFS2_DIO_MARK_EXTENT_BATCH) {
> +			ocfs2_commit_trans(osb, handle);
> +			handle = NULL;
> +			batch = 0;
> +		}
>  	}
>  
>  	if (end > i_size_read(inode)) {
> +		if (!handle) {
> +			handle = ocfs2_start_trans(osb, credits);
> +			if (IS_ERR(handle)) {
> +				ret = PTR_ERR(handle);
> +				mlog_errno(ret);
> +				goto unlock;
> +			}
> +		}
>  		ret = ocfs2_set_inode_size(handle, inode, di_bh, end);
>  		if (ret < 0)
>  			mlog_errno(ret);
>  	}
> -commit:
> -	ocfs2_commit_trans(osb, handle);
> +	if (handle)
> +		ocfs2_commit_trans(osb, handle);
> +
>  unlock:
>  	up_write(&oi->ip_alloc_sem);
> +
> +	/* everything looks good, let's start the cleanup */
> +	if (dwc->dw_orphaned) {
> +		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
> +
> +		ret = ocfs2_del_inode_from_orphan(osb, inode, di_bh, 0, 0);
> +		if (ret < 0)
> +			mlog_errno(ret);
> +	}
>  	ocfs2_inode_unlock(inode, 1);
>  	brelse(di_bh);
>  out:
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
