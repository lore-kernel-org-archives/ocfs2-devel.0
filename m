Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDFA1F8ADF
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Dec 2024 16:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733244367; cv=none; b=aDga1yXFZy1C6lDMyDZSpXqw1Rap/WKCsA+cz3SSg1Wpu5mCC3vFfwrRudd7dKJnitcejQTpkSNSyUhrPm+zOLaTgkV6XSS4NXShQ+5q9gWh5sYYVnUDGhDrkZUx9wVZP5YU1Xcr2DUspFQb4xG01Chhhp6JASGQi/tJ5LixrtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733244367; c=relaxed/simple;
	bh=qPyDp9VfXrDbGbf86kLMw4EHeXyG1Xttyc9hsJdbFTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAT7niqGopvwV8udd8/9a02yrHX1reGVoC+M1qTUOgOhxGmhw6kGka+k7ZQt2qO+WvG6PO6JiJvWMGZmYB+4KtdZmwbEkL7869ynN/XQ7F0oWgoVH3/XVpIVnltHiofZLEVUgdvWcs+EeUtcFIwAnap/IVv/Df5biUYegfK2+IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RcqWfg/E; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dZ/wXb+J; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TzWQH5h7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d1Oz7vCQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RcqWfg/E";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dZ/wXb+J";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TzWQH5h7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d1Oz7vCQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8B181F44F;
	Tue,  3 Dec 2024 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733244364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HmuOsncpWHj7TOKmuLtmn98GbWBxIHr8ve3VJcSek8=;
	b=RcqWfg/EXOxiNXIphuLPAtnSGybTj3+YrfFr4QhBgU9QzLLX8s373EHIlqCmxf/YaDcfN8
	GJ9QOSZaXjlw6fbVItWdEd0ewwTBdt2E9XNq2cOKECnRyg1wG7fnjo7AMLko4cJAYcRS/S
	4rvaQuNfl6oodR6wx5N4v4NyfGSNBik=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733244364;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HmuOsncpWHj7TOKmuLtmn98GbWBxIHr8ve3VJcSek8=;
	b=dZ/wXb+JnPgEhsQ/4ZG5dz/Fvkdiu4S8bRzAddoTYZWx0+93Wzqd8FOx+njKBIQsPoe6Sd
	4Gq/ciE0+eJxJXCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TzWQH5h7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=d1Oz7vCQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733244363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HmuOsncpWHj7TOKmuLtmn98GbWBxIHr8ve3VJcSek8=;
	b=TzWQH5h7Jq9l2YQAUZxqYCzJZHHJO1t3wGno/UHVzRb/VSGkxCMtR2c4kKKzqn94n7Rjl5
	PxVOmWldgHRyWdl9je4rTETjW/1d4l67XrPZekaz7L1s1ZJWEG3LAy60cswalk32uVuA3l
	ckJ7TjjrglYUP3eTVdgV7yxG40pCqjA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733244363;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HmuOsncpWHj7TOKmuLtmn98GbWBxIHr8ve3VJcSek8=;
	b=d1Oz7vCQWwRhm/p6nCStu2Q949j5y6bv0mU2tqe15sSm5x51N3cS6z9E2O5gc1hfq6WXTN
	PiKXTDRdA8aSiSCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE82D139C2;
	Tue,  3 Dec 2024 16:46:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lHtYJMs1T2d5YQAAD6G6ig
	(envelope-from <rgoldwyn@suse.de>); Tue, 03 Dec 2024 16:46:03 +0000
Date: Tue, 3 Dec 2024 11:45:58 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: Eric Sandeen <sandeen@redhat.com>
Cc: ocfs2-devel@lists.linux.dev, joseph.qi@linux.alibaba.com, 
	brauner@kernel.org
Subject: Re: [RFC PATCH 1/2] dlmfs: convert to the new mount API
Message-ID: <qqweow5tk4x5t3ad5tw27l4k7t725zauilkab2kpcr7g5hdtfv@ukhanojeglqt>
References: <20241028144443.609151-1-sandeen@redhat.com>
 <20241028144443.609151-2-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028144443.609151-2-sandeen@redhat.com>
X-Rspamd-Queue-Id: E8B181F44F
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
> Convert dlmfs to the new mount API.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

> ---
>  fs/ocfs2/dlmfs/dlmfs.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index 7fc0e920eda7..2a7f36643895 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -20,6 +20,7 @@
>  
>  #include <linux/module.h>
>  #include <linux/fs.h>
> +#include <linux/fs_context.h>
>  #include <linux/pagemap.h>
>  #include <linux/types.h>
>  #include <linux/slab.h>
> @@ -506,9 +507,7 @@ static int dlmfs_unlink(struct inode *dir,
>  	return status;
>  }
>  
> -static int dlmfs_fill_super(struct super_block * sb,
> -			    void * data,
> -			    int silent)
> +static int dlmfs_fill_super(struct super_block *sb, struct fs_context *fc)
>  {
>  	sb->s_maxbytes = MAX_LFS_FILESIZE;
>  	sb->s_blocksize = PAGE_SIZE;
> @@ -556,17 +555,27 @@ static const struct inode_operations dlmfs_file_inode_operations = {
>  	.setattr	= dlmfs_file_setattr,
>  };
>  
> -static struct dentry *dlmfs_mount(struct file_system_type *fs_type,
> -	int flags, const char *dev_name, void *data)
> +static int dlmfs_get_tree(struct fs_context *fc)
>  {
> -	return mount_nodev(fs_type, flags, data, dlmfs_fill_super);
> +	return get_tree_nodev(fc, dlmfs_fill_super);
> +}
> +
> +static const struct fs_context_operations dlmfs_context_ops = {
> +	.get_tree       = dlmfs_get_tree,
> +};
> +
> +static int dlmfs_init_fs_context(struct fs_context *fc)
> +{
> +	fc->ops = &dlmfs_context_ops;
> +
> +	return 0;
>  }
>  
>  static struct file_system_type dlmfs_fs_type = {
>  	.owner		= THIS_MODULE,
>  	.name		= "ocfs2_dlmfs",
> -	.mount		= dlmfs_mount,
>  	.kill_sb	= kill_litter_super,
> +	.init_fs_context = dlmfs_init_fs_context,
>  };
>  MODULE_ALIAS_FS("ocfs2_dlmfs");
>  
> -- 
> 2.46.0
> 
> 

-- 
Goldwyn
