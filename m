Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1D81F756E
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Dec 2024 16:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733244401; cv=none; b=k+FFudl/fqZWjJtTUxtuNWujSqA3Mosn1TOKlE27ltKwooqHBbkYF9iJW9gPKBGeYfiqGppoaJkhiwi0Gp6MLFcU3oPNqvhpIufcTsLO153f7bQ8PcIffXjdTKwBQzYerbDJKwmPhLKZJon8OgLxnzVFWj6r2HSuW64TxDYwWhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733244401; c=relaxed/simple;
	bh=r67YlEnkLZtybuUc5kvV69oTSxGSds5fqkv90HJCp0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVmADCdaBVFgfe2SgcBY4vfrdh6+e1cZ0W8WMAXsMu4w295EN8AfqugkNNMLOkh31aGe8OLm4HnKMHDS8hBfTvmLV10yZzbJ9bOlRdz265FzxMoChCNlxT3Kvil5IUziHOc7I23LtWk5fC4xV5EpwO2CaHCNwNCMRKU5qTalDH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gAqll8XI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GaWfYbts; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=gAqll8XI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GaWfYbts; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gAqll8XI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GaWfYbts";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gAqll8XI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GaWfYbts"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 06E5D1F453;
	Tue,  3 Dec 2024 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733244397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wh6/xr5ddAVHqoQL7Bbw2HLD96ZE3lDDZK+9ccmdP5A=;
	b=gAqll8XIhMfbWbmTZsjukqaOMy+si6ymNL1p9/jd8f2dwWwlNMRJAgw4u/CGZgLq6H6qKt
	cxKhht9urx/ywuHDY58TH/zNVzpW9hS36SGrmIcGL/xffhqpG+GKgjKPlCa3whMx9Xhzyj
	Ao+QEN2GUdUlZ7jzyESZ6Wnt+Qlqf2E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733244397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wh6/xr5ddAVHqoQL7Bbw2HLD96ZE3lDDZK+9ccmdP5A=;
	b=GaWfYbtspq/0iv3VhG5reeWzNhI65j/bgxNLubr2vkgYr7QlGi6HrbQ0OU2XMHE/3xs0Oj
	bmWizIxTUdjWnjCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gAqll8XI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GaWfYbts
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733244397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wh6/xr5ddAVHqoQL7Bbw2HLD96ZE3lDDZK+9ccmdP5A=;
	b=gAqll8XIhMfbWbmTZsjukqaOMy+si6ymNL1p9/jd8f2dwWwlNMRJAgw4u/CGZgLq6H6qKt
	cxKhht9urx/ywuHDY58TH/zNVzpW9hS36SGrmIcGL/xffhqpG+GKgjKPlCa3whMx9Xhzyj
	Ao+QEN2GUdUlZ7jzyESZ6Wnt+Qlqf2E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733244397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wh6/xr5ddAVHqoQL7Bbw2HLD96ZE3lDDZK+9ccmdP5A=;
	b=GaWfYbtspq/0iv3VhG5reeWzNhI65j/bgxNLubr2vkgYr7QlGi6HrbQ0OU2XMHE/3xs0Oj
	bmWizIxTUdjWnjCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6D54139C2;
	Tue,  3 Dec 2024 16:46:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ByR8Iuw1T2egYQAAD6G6ig
	(envelope-from <rgoldwyn@suse.de>); Tue, 03 Dec 2024 16:46:36 +0000
Date: Tue, 3 Dec 2024 11:46:31 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: Eric Sandeen <sandeen@redhat.com>
Cc: ocfs2-devel@lists.linux.dev, joseph.qi@linux.alibaba.com, 
	brauner@kernel.org
Subject: Re: [RFC PATCH 2/2] ocfs2: convert to the new mount API
Message-ID: <f7vf6zesqebp5vsm7by3xg2c7ei7rlu2encjjtdau4jpwwbu3j@nqiae73busw6>
References: <20241028144443.609151-1-sandeen@redhat.com>
 <20241028144443.609151-3-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028144443.609151-3-sandeen@redhat.com>
X-Rspamd-Queue-Id: 06E5D1F453
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO

On  9:41 28/10, Eric Sandeen wrote:
> Convert ocfs2 to the new mount API.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

> ---
>  fs/ocfs2/ocfs2_trace.h |  20 +-
>  fs/ocfs2/super.c       | 589 +++++++++++++++++++----------------------
>  2 files changed, 277 insertions(+), 332 deletions(-)
> 
> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
> index 0511c69c9fde..54ed1495de9a 100644
> --- a/fs/ocfs2/ocfs2_trace.h
> +++ b/fs/ocfs2/ocfs2_trace.h
> @@ -1658,34 +1658,34 @@ TRACE_EVENT(ocfs2_remount,
>  );
>  
>  TRACE_EVENT(ocfs2_fill_super,
> -	TP_PROTO(void *sb, void *data, int silent),
> -	TP_ARGS(sb, data, silent),
> +	TP_PROTO(void *sb, void *fc, int silent),
> +	TP_ARGS(sb, fc, silent),
>  	TP_STRUCT__entry(
>  		__field(void *, sb)
> -		__field(void *, data)
> +		__field(void *, fc)
>  		__field(int, silent)
>  	),
>  	TP_fast_assign(
>  		__entry->sb = sb;
> -		__entry->data = data;
> +		__entry->fc = fc;
>  		__entry->silent = silent;
>  	),
>  	TP_printk("%p %p %d", __entry->sb,
> -		  __entry->data, __entry->silent)
> +		  __entry->fc, __entry->silent)
>  );
>  
>  TRACE_EVENT(ocfs2_parse_options,
> -	TP_PROTO(int is_remount, char *options),
> -	TP_ARGS(is_remount, options),
> +	TP_PROTO(int is_remount, const char *option),
> +	TP_ARGS(is_remount, option),
>  	TP_STRUCT__entry(
>  		__field(int, is_remount)
> -		__string(options, options)
> +		__string(option, option)
>  	),
>  	TP_fast_assign(
>  		__entry->is_remount = is_remount;
> -		__assign_str(options);
> +		__assign_str(option);
>  	),
> -	TP_printk("%d %s", __entry->is_remount, __get_str(options))
> +	TP_printk("%d %s", __entry->is_remount, __get_str(option))
>  );
>  
>  DEFINE_OCFS2_POINTER_EVENT(ocfs2_put_super);
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 3d404624bb96..110ffc4bb840 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -19,10 +19,10 @@
>  #include <linux/blkdev.h>
>  #include <linux/socket.h>
>  #include <linux/inet.h>
> -#include <linux/parser.h>
> +#include <linux/fs_parser.h>
> +#include <linux/fs_context.h>
>  #include <linux/crc32.h>
>  #include <linux/debugfs.h>
> -#include <linux/mount.h>
>  #include <linux/seq_file.h>
>  #include <linux/quotaops.h>
>  #include <linux/signal.h>
> @@ -80,17 +80,15 @@ struct mount_options
>  	unsigned int	resv_level;
>  	int		dir_resv_level;
>  	char		cluster_stack[OCFS2_STACK_LABEL_LEN + 1];
> +	bool		user_stack;
>  };
>  
> -static int ocfs2_parse_options(struct super_block *sb, char *options,
> -			       struct mount_options *mopt,
> -			       int is_remount);
> +static int ocfs2_parse_param(struct fs_context *fc, struct fs_parameter *param);
>  static int ocfs2_check_set_options(struct super_block *sb,
>  				   struct mount_options *options);
>  static int ocfs2_show_options(struct seq_file *s, struct dentry *root);
>  static void ocfs2_put_super(struct super_block *sb);
>  static int ocfs2_mount_volume(struct super_block *sb);
> -static int ocfs2_remount(struct super_block *sb, int *flags, char *data);
>  static void ocfs2_dismount_volume(struct super_block *sb, int mnt_err);
>  static int ocfs2_initialize_mem_caches(void);
>  static void ocfs2_free_mem_caches(void);
> @@ -135,7 +133,6 @@ static const struct super_operations ocfs2_sops = {
>  	.evict_inode	= ocfs2_evict_inode,
>  	.sync_fs	= ocfs2_sync_fs,
>  	.put_super	= ocfs2_put_super,
> -	.remount_fs	= ocfs2_remount,
>  	.show_options   = ocfs2_show_options,
>  	.quota_read	= ocfs2_quota_read,
>  	.quota_write	= ocfs2_quota_write,
> @@ -144,15 +141,10 @@ static const struct super_operations ocfs2_sops = {
>  
>  enum {
>  	Opt_barrier,
> -	Opt_err_panic,
> -	Opt_err_ro,
> +	Opt_errors,
>  	Opt_intr,
> -	Opt_nointr,
> -	Opt_hb_none,
> -	Opt_hb_local,
> -	Opt_hb_global,
> -	Opt_data_ordered,
> -	Opt_data_writeback,
> +	Opt_heartbeat,
> +	Opt_data,
>  	Opt_atime_quantum,
>  	Opt_slot,
>  	Opt_commit,
> @@ -160,52 +152,64 @@ enum {
>  	Opt_localflocks,
>  	Opt_stack,
>  	Opt_user_xattr,
> -	Opt_nouser_xattr,
>  	Opt_inode64,
>  	Opt_acl,
> -	Opt_noacl,
>  	Opt_usrquota,
>  	Opt_grpquota,
> -	Opt_coherency_buffered,
> -	Opt_coherency_full,
> +	Opt_coherency,
>  	Opt_resv_level,
>  	Opt_dir_resv_level,
>  	Opt_journal_async_commit,
> -	Opt_err_cont,
> -	Opt_err,
>  };
>  
> -static const match_table_t tokens = {
> -	{Opt_barrier, "barrier=%u"},
> -	{Opt_err_panic, "errors=panic"},
> -	{Opt_err_ro, "errors=remount-ro"},
> -	{Opt_intr, "intr"},
> -	{Opt_nointr, "nointr"},
> -	{Opt_hb_none, OCFS2_HB_NONE},
> -	{Opt_hb_local, OCFS2_HB_LOCAL},
> -	{Opt_hb_global, OCFS2_HB_GLOBAL},
> -	{Opt_data_ordered, "data=ordered"},
> -	{Opt_data_writeback, "data=writeback"},
> -	{Opt_atime_quantum, "atime_quantum=%u"},
> -	{Opt_slot, "preferred_slot=%u"},
> -	{Opt_commit, "commit=%u"},
> -	{Opt_localalloc, "localalloc=%d"},
> -	{Opt_localflocks, "localflocks"},
> -	{Opt_stack, "cluster_stack=%s"},
> -	{Opt_user_xattr, "user_xattr"},
> -	{Opt_nouser_xattr, "nouser_xattr"},
> -	{Opt_inode64, "inode64"},
> -	{Opt_acl, "acl"},
> -	{Opt_noacl, "noacl"},
> -	{Opt_usrquota, "usrquota"},
> -	{Opt_grpquota, "grpquota"},
> -	{Opt_coherency_buffered, "coherency=buffered"},
> -	{Opt_coherency_full, "coherency=full"},
> -	{Opt_resv_level, "resv_level=%u"},
> -	{Opt_dir_resv_level, "dir_resv_level=%u"},
> -	{Opt_journal_async_commit, "journal_async_commit"},
> -	{Opt_err_cont, "errors=continue"},
> -	{Opt_err, NULL}
> +static const struct constant_table ocfs2_param_errors[] = {
> +	{"panic",	OCFS2_MOUNT_ERRORS_PANIC},
> +	{"remount-ro",	OCFS2_MOUNT_ERRORS_ROFS},
> +	{"continue",	OCFS2_MOUNT_ERRORS_CONT},
> +	{}
> +};
> +
> +static const struct constant_table ocfs2_param_heartbeat[] = {
> +	{"local",	OCFS2_MOUNT_HB_LOCAL},
> +	{"none",	OCFS2_MOUNT_HB_NONE},
> +	{"global",	OCFS2_MOUNT_HB_GLOBAL},
> +	{}
> +};
> +
> +static const struct constant_table ocfs2_param_data[] = {
> +	{"writeback",	OCFS2_MOUNT_DATA_WRITEBACK},
> +	{"ordered",	0},
> +	{}
> +};
> +
> +static const struct constant_table ocfs2_param_coherency[] = {
> +	{"buffered",	OCFS2_MOUNT_COHERENCY_BUFFERED},
> +	{"full",	0},
> +	{}
> +};
> +
> +static const struct fs_parameter_spec ocfs2_param_spec[] = {
> +	fsparam_u32	("barrier",	Opt_barrier),
> +	fsparam_enum	("errors",	Opt_errors,	ocfs2_param_errors),
> +	fsparam_flag_no	("intr",	Opt_intr),
> +	fsparam_enum	("heartbeat",	Opt_heartbeat,	ocfs2_param_heartbeat),
> +	fsparam_enum	("data",	Opt_data,	ocfs2_param_data),
> +	fsparam_u32	("atime_quantum", Opt_atime_quantum),
> +	fsparam_u32	("preferred_slot", Opt_slot),
> +	fsparam_u32	("commit",	Opt_commit),
> +	fsparam_s32	("localalloc",	Opt_localalloc),
> +	fsparam_flag	("localflocks",	Opt_localflocks),
> +	fsparam_string	("cluster_stack", Opt_stack),
> +	fsparam_flag_no	("user_xattr",	Opt_user_xattr),
> +	fsparam_flag	("inode64",	Opt_inode64),
> +	fsparam_flag_no	("acl",		Opt_acl),
> +	fsparam_flag	("usrquota",	Opt_usrquota),
> +	fsparam_flag	("grpquota",	Opt_grpquota),
> +	fsparam_enum	("coherency",	Opt_coherency,	ocfs2_param_coherency),
> +	fsparam_u32	("resv_level",	Opt_resv_level),
> +	fsparam_u32	("dir_resv_level",	Opt_dir_resv_level),
> +	fsparam_flag	("journal_async_commit", Opt_journal_async_commit),
> +	{}
>  };
>  
>  #ifdef CONFIG_DEBUG_FS
> @@ -600,32 +604,32 @@ static unsigned long long ocfs2_max_file_offset(unsigned int bbits,
>  	return (((unsigned long long)bytes) << bitshift) - trim;
>  }
>  
> -static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
> +static int ocfs2_reconfigure(struct fs_context *fc)
>  {
>  	int incompat_features;
>  	int ret = 0;
> -	struct mount_options parsed_options;
> +	struct mount_options *parsed_options = fc->fs_private;
> +	struct super_block *sb = fc->root->d_sb;
>  	struct ocfs2_super *osb = OCFS2_SB(sb);
>  	u32 tmp;
>  
>  	sync_filesystem(sb);
>  
> -	if (!ocfs2_parse_options(sb, data, &parsed_options, 1) ||
> -	    !ocfs2_check_set_options(sb, &parsed_options)) {
> +	if (!ocfs2_check_set_options(sb, parsed_options)) {
>  		ret = -EINVAL;
>  		goto out;
>  	}
>  
>  	tmp = OCFS2_MOUNT_HB_LOCAL | OCFS2_MOUNT_HB_GLOBAL |
>  		OCFS2_MOUNT_HB_NONE;
> -	if ((osb->s_mount_opt & tmp) != (parsed_options.mount_opt & tmp)) {
> +	if ((osb->s_mount_opt & tmp) != (parsed_options->mount_opt & tmp)) {
>  		ret = -EINVAL;
>  		mlog(ML_ERROR, "Cannot change heartbeat mode on remount\n");
>  		goto out;
>  	}
>  
>  	if ((osb->s_mount_opt & OCFS2_MOUNT_DATA_WRITEBACK) !=
> -	    (parsed_options.mount_opt & OCFS2_MOUNT_DATA_WRITEBACK)) {
> +	    (parsed_options->mount_opt & OCFS2_MOUNT_DATA_WRITEBACK)) {
>  		ret = -EINVAL;
>  		mlog(ML_ERROR, "Cannot change data mode on remount\n");
>  		goto out;
> @@ -634,16 +638,16 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
>  	/* Probably don't want this on remount; it might
>  	 * mess with other nodes */
>  	if (!(osb->s_mount_opt & OCFS2_MOUNT_INODE64) &&
> -	    (parsed_options.mount_opt & OCFS2_MOUNT_INODE64)) {
> +	    (parsed_options->mount_opt & OCFS2_MOUNT_INODE64)) {
>  		ret = -EINVAL;
>  		mlog(ML_ERROR, "Cannot enable inode64 on remount\n");
>  		goto out;
>  	}
>  
>  	/* We're going to/from readonly mode. */
> -	if ((bool)(*flags & SB_RDONLY) != sb_rdonly(sb)) {
> +	if ((bool)(fc->sb_flags & SB_RDONLY) != sb_rdonly(sb)) {
>  		/* Disable quota accounting before remounting RO */
> -		if (*flags & SB_RDONLY) {
> +		if (fc->sb_flags & SB_RDONLY) {
>  			ret = ocfs2_susp_quotas(osb, 0);
>  			if (ret < 0)
>  				goto out;
> @@ -657,7 +661,7 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
>  			goto unlock_osb;
>  		}
>  
> -		if (*flags & SB_RDONLY) {
> +		if (fc->sb_flags & SB_RDONLY) {
>  			sb->s_flags |= SB_RDONLY;
>  			osb->osb_flags |= OCFS2_OSB_SOFT_RO;
>  		} else {
> @@ -678,11 +682,11 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
>  			sb->s_flags &= ~SB_RDONLY;
>  			osb->osb_flags &= ~OCFS2_OSB_SOFT_RO;
>  		}
> -		trace_ocfs2_remount(sb->s_flags, osb->osb_flags, *flags);
> +		trace_ocfs2_remount(sb->s_flags, osb->osb_flags, fc->sb_flags);
>  unlock_osb:
>  		spin_unlock(&osb->osb_lock);
>  		/* Enable quota accounting after remounting RW */
> -		if (!ret && !(*flags & SB_RDONLY)) {
> +		if (!ret && !(fc->sb_flags & SB_RDONLY)) {
>  			if (sb_any_quota_suspended(sb))
>  				ret = ocfs2_susp_quotas(osb, 1);
>  			else
> @@ -701,11 +705,11 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
>  	if (!ret) {
>  		/* Only save off the new mount options in case of a successful
>  		 * remount. */
> -		osb->s_mount_opt = parsed_options.mount_opt;
> -		osb->s_atime_quantum = parsed_options.atime_quantum;
> -		osb->preferred_slot = parsed_options.slot;
> -		if (parsed_options.commit_interval)
> -			osb->osb_commit_interval = parsed_options.commit_interval;
> +		osb->s_mount_opt = parsed_options->mount_opt;
> +		osb->s_atime_quantum = parsed_options->atime_quantum;
> +		osb->preferred_slot = parsed_options->slot;
> +		if (parsed_options->commit_interval)
> +			osb->osb_commit_interval = parsed_options->commit_interval;
>  
>  		if (!ocfs2_is_hard_readonly(osb))
>  			ocfs2_set_journal_params(osb);
> @@ -966,23 +970,18 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
>  	}
>  }
>  
> -static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
> +static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
>  {
>  	struct dentry *root;
>  	int status, sector_size;
> -	struct mount_options parsed_options;
> +	struct mount_options *parsed_options = fc->fs_private;
>  	struct inode *inode = NULL;
>  	struct ocfs2_super *osb = NULL;
>  	struct buffer_head *bh = NULL;
>  	char nodestr[12];
>  	struct ocfs2_blockcheck_stats stats;
>  
> -	trace_ocfs2_fill_super(sb, data, silent);
> -
> -	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
> -		status = -EINVAL;
> -		goto out;
> -	}
> +	trace_ocfs2_fill_super(sb, fc, fc->sb_flags & SB_SILENT);
>  
>  	/* probe for superblock */
>  	status = ocfs2_sb_probe(sb, &bh, &sector_size, &stats);
> @@ -999,24 +998,24 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	osb = OCFS2_SB(sb);
>  
> -	if (!ocfs2_check_set_options(sb, &parsed_options)) {
> +	if (!ocfs2_check_set_options(sb, parsed_options)) {
>  		status = -EINVAL;
>  		goto out_super;
>  	}
> -	osb->s_mount_opt = parsed_options.mount_opt;
> -	osb->s_atime_quantum = parsed_options.atime_quantum;
> -	osb->preferred_slot = parsed_options.slot;
> -	osb->osb_commit_interval = parsed_options.commit_interval;
> +	osb->s_mount_opt = parsed_options->mount_opt;
> +	osb->s_atime_quantum = parsed_options->atime_quantum;
> +	osb->preferred_slot = parsed_options->slot;
> +	osb->osb_commit_interval = parsed_options->commit_interval;
>  
> -	ocfs2_la_set_sizes(osb, parsed_options.localalloc_opt);
> -	osb->osb_resv_level = parsed_options.resv_level;
> -	osb->osb_dir_resv_level = parsed_options.resv_level;
> -	if (parsed_options.dir_resv_level == -1)
> -		osb->osb_dir_resv_level = parsed_options.resv_level;
> +	ocfs2_la_set_sizes(osb, parsed_options->localalloc_opt);
> +	osb->osb_resv_level = parsed_options->resv_level;
> +	osb->osb_dir_resv_level = parsed_options->resv_level;
> +	if (parsed_options->dir_resv_level == -1)
> +		osb->osb_dir_resv_level = parsed_options->resv_level;
>  	else
> -		osb->osb_dir_resv_level = parsed_options.dir_resv_level;
> +		osb->osb_dir_resv_level = parsed_options->dir_resv_level;
>  
> -	status = ocfs2_verify_userspace_stack(osb, &parsed_options);
> +	status = ocfs2_verify_userspace_stack(osb, parsed_options);
>  	if (status)
>  		goto out_super;
>  
> @@ -1180,27 +1179,72 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
>  	return status;
>  }
>  
> -static struct dentry *ocfs2_mount(struct file_system_type *fs_type,
> -			int flags,
> -			const char *dev_name,
> -			void *data)
> +static int ocfs2_get_tree(struct fs_context *fc)
> +{
> +	return get_tree_bdev(fc, ocfs2_fill_super);
> +}
> +
> +static void ocfs2_free_fc(struct fs_context *fc)
>  {
> -	return mount_bdev(fs_type, flags, dev_name, data, ocfs2_fill_super);
> +	kfree(fc->fs_private);
> +}
> +
> +static const struct fs_context_operations ocfs2_context_ops = {
> +	.parse_param	= ocfs2_parse_param,
> +	.get_tree	= ocfs2_get_tree,
> +	.reconfigure	= ocfs2_reconfigure,
> +	.free		= ocfs2_free_fc,
> +};
> +
> +static int ocfs2_init_fs_context(struct fs_context *fc)
> +{
> +	struct mount_options *mopt;
> +
> +	mopt = kzalloc(sizeof(struct mount_options), GFP_KERNEL);
> +	if (!mopt)
> +		return -EINVAL;
> +
> +	mopt->commit_interval = 0;
> +	mopt->mount_opt = OCFS2_MOUNT_NOINTR;
> +	mopt->atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
> +	mopt->slot = OCFS2_INVALID_SLOT;
> +	mopt->localalloc_opt = -1;
> +	mopt->cluster_stack[0] = '\0';
> +	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
> +	mopt->dir_resv_level = -1;
> +
> +	fc->fs_private = mopt;
> +	fc->ops = &ocfs2_context_ops;
> +
> +	return 0;
>  }
>  
>  static struct file_system_type ocfs2_fs_type = {
>  	.owner          = THIS_MODULE,
>  	.name           = "ocfs2",
> -	.mount          = ocfs2_mount,
>  	.kill_sb        = kill_block_super,
>  	.fs_flags       = FS_REQUIRES_DEV|FS_RENAME_DOES_D_MOVE,
> -	.next           = NULL
> +	.next           = NULL,
> +	.init_fs_context = ocfs2_init_fs_context,
> +	.parameters	= ocfs2_param_spec,
>  };
>  MODULE_ALIAS_FS("ocfs2");
>  
>  static int ocfs2_check_set_options(struct super_block *sb,
>  				   struct mount_options *options)
>  {
> +	if (options->user_stack == 0) {
> +		u32 tmp;
> +
> +		/* Ensure only one heartbeat mode */
> +		tmp = options->mount_opt & (OCFS2_MOUNT_HB_LOCAL |
> +					    OCFS2_MOUNT_HB_GLOBAL |
> +					    OCFS2_MOUNT_HB_NONE);
> +		if (hweight32(tmp) != 1) {
> +			mlog(ML_ERROR, "Invalid heartbeat mount options\n");
> +			return 0;
> +		}
> +	}
>  	if (options->mount_opt & OCFS2_MOUNT_USRQUOTA &&
>  	    !OCFS2_HAS_RO_COMPAT_FEATURE(sb,
>  					 OCFS2_FEATURE_RO_COMPAT_USRQUOTA)) {
> @@ -1232,241 +1276,142 @@ static int ocfs2_check_set_options(struct super_block *sb,
>  	return 1;
>  }
>  
> -static int ocfs2_parse_options(struct super_block *sb,
> -			       char *options,
> -			       struct mount_options *mopt,
> -			       int is_remount)
> +static int ocfs2_parse_param(struct fs_context *fc, struct fs_parameter *param)
>  {
> -	int status, user_stack = 0;
> -	char *p;
> -	u32 tmp;
> -	int token, option;
> -	substring_t args[MAX_OPT_ARGS];
> -
> -	trace_ocfs2_parse_options(is_remount, options ? options : "(none)");
> -
> -	mopt->commit_interval = 0;
> -	mopt->mount_opt = OCFS2_MOUNT_NOINTR;
> -	mopt->atime_quantum = OCFS2_DEFAULT_ATIME_QUANTUM;
> -	mopt->slot = OCFS2_INVALID_SLOT;
> -	mopt->localalloc_opt = -1;
> -	mopt->cluster_stack[0] = '\0';
> -	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
> -	mopt->dir_resv_level = -1;
> -
> -	if (!options) {
> -		status = 1;
> -		goto bail;
> -	}
> -
> -	while ((p = strsep(&options, ",")) != NULL) {
> -		if (!*p)
> -			continue;
> -
> -		token = match_token(p, tokens, args);
> -		switch (token) {
> -		case Opt_hb_local:
> -			mopt->mount_opt |= OCFS2_MOUNT_HB_LOCAL;
> -			break;
> -		case Opt_hb_none:
> -			mopt->mount_opt |= OCFS2_MOUNT_HB_NONE;
> -			break;
> -		case Opt_hb_global:
> -			mopt->mount_opt |= OCFS2_MOUNT_HB_GLOBAL;
> -			break;
> -		case Opt_barrier:
> -			if (match_int(&args[0], &option)) {
> -				status = 0;
> -				goto bail;
> -			}
> -			if (option)
> -				mopt->mount_opt |= OCFS2_MOUNT_BARRIER;
> -			else
> -				mopt->mount_opt &= ~OCFS2_MOUNT_BARRIER;
> -			break;
> -		case Opt_intr:
> -			mopt->mount_opt &= ~OCFS2_MOUNT_NOINTR;
> -			break;
> -		case Opt_nointr:
> +	struct fs_parse_result result;
> +	int opt;
> +	struct mount_options *mopt = fc->fs_private;
> +	bool is_remount = (fc->purpose & FS_CONTEXT_FOR_RECONFIGURE);
> +
> +	trace_ocfs2_parse_options(is_remount, param->key);
> +
> +	opt = fs_parse(fc, ocfs2_param_spec, param, &result);
> +	if (opt < 0)
> +		return opt;
> +
> +	switch (opt) {
> +	case Opt_heartbeat:
> +		mopt->mount_opt |= result.uint_32;
> +		break;
> +	case Opt_barrier:
> +		if (result.uint_32)
> +			mopt->mount_opt |= OCFS2_MOUNT_BARRIER;
> +		else
> +			mopt->mount_opt &= ~OCFS2_MOUNT_BARRIER;
> +		break;
> +	case Opt_intr:
> +		if (result.negated)
>  			mopt->mount_opt |= OCFS2_MOUNT_NOINTR;
> -			break;
> -		case Opt_err_panic:
> -			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_CONT;
> -			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_ROFS;
> -			mopt->mount_opt |= OCFS2_MOUNT_ERRORS_PANIC;
> -			break;
> -		case Opt_err_ro:
> -			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_CONT;
> -			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_PANIC;
> -			mopt->mount_opt |= OCFS2_MOUNT_ERRORS_ROFS;
> -			break;
> -		case Opt_err_cont:
> -			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_ROFS;
> -			mopt->mount_opt &= ~OCFS2_MOUNT_ERRORS_PANIC;
> -			mopt->mount_opt |= OCFS2_MOUNT_ERRORS_CONT;
> -			break;
> -		case Opt_data_ordered:
> -			mopt->mount_opt &= ~OCFS2_MOUNT_DATA_WRITEBACK;
> -			break;
> -		case Opt_data_writeback:
> -			mopt->mount_opt |= OCFS2_MOUNT_DATA_WRITEBACK;
> -			break;
> -		case Opt_user_xattr:
> -			mopt->mount_opt &= ~OCFS2_MOUNT_NOUSERXATTR;
> -			break;
> -		case Opt_nouser_xattr:
> +		else
> +			mopt->mount_opt &= ~OCFS2_MOUNT_NOINTR;
> +		break;
> +	case Opt_errors:
> +		mopt->mount_opt &= ~(OCFS2_MOUNT_ERRORS_CONT |
> +				     OCFS2_MOUNT_ERRORS_ROFS |
> +				     OCFS2_MOUNT_ERRORS_PANIC);
> +		mopt->mount_opt |= result.uint_32;
> +		break;
> +	case Opt_data:
> +		mopt->mount_opt &= ~OCFS2_MOUNT_DATA_WRITEBACK;
> +		mopt->mount_opt |= result.uint_32;
> +		break;
> +	case Opt_user_xattr:
> +		if (result.negated)
>  			mopt->mount_opt |= OCFS2_MOUNT_NOUSERXATTR;
> -			break;
> -		case Opt_atime_quantum:
> -			if (match_int(&args[0], &option)) {
> -				status = 0;
> -				goto bail;
> -			}
> -			if (option >= 0)
> -				mopt->atime_quantum = option;
> -			break;
> -		case Opt_slot:
> -			if (match_int(&args[0], &option)) {
> -				status = 0;
> -				goto bail;
> -			}
> -			if (option)
> -				mopt->slot = (u16)option;
> -			break;
> -		case Opt_commit:
> -			if (match_int(&args[0], &option)) {
> -				status = 0;
> -				goto bail;
> -			}
> -			if (option < 0)
> -				return 0;
> -			if (option == 0)
> -				option = JBD2_DEFAULT_MAX_COMMIT_AGE;
> -			mopt->commit_interval = HZ * option;
> -			break;
> -		case Opt_localalloc:
> -			if (match_int(&args[0], &option)) {
> -				status = 0;
> -				goto bail;
> -			}
> -			if (option >= 0)
> -				mopt->localalloc_opt = option;
> -			break;
> -		case Opt_localflocks:
> -			/*
> -			 * Changing this during remount could race
> -			 * flock() requests, or "unbalance" existing
> -			 * ones (e.g., a lock is taken in one mode but
> -			 * dropped in the other). If users care enough
> -			 * to flip locking modes during remount, we
> -			 * could add a "local" flag to individual
> -			 * flock structures for proper tracking of
> -			 * state.
> -			 */
> -			if (!is_remount)
> -				mopt->mount_opt |= OCFS2_MOUNT_LOCALFLOCKS;
> -			break;
> -		case Opt_stack:
> -			/* Check both that the option we were passed
> -			 * is of the right length and that it is a proper
> -			 * string of the right length.
> -			 */
> -			if (((args[0].to - args[0].from) !=
> -			     OCFS2_STACK_LABEL_LEN) ||
> -			    (strnlen(args[0].from,
> -				     OCFS2_STACK_LABEL_LEN) !=
> -			     OCFS2_STACK_LABEL_LEN)) {
> -				mlog(ML_ERROR,
> -				     "Invalid cluster_stack option\n");
> -				status = 0;
> -				goto bail;
> -			}
> -			memcpy(mopt->cluster_stack, args[0].from,
> -			       OCFS2_STACK_LABEL_LEN);
> -			mopt->cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
> -			/*
> -			 * Open code the memcmp here as we don't have
> -			 * an osb to pass to
> -			 * ocfs2_userspace_stack().
> -			 */
> -			if (memcmp(mopt->cluster_stack,
> -				   OCFS2_CLASSIC_CLUSTER_STACK,
> -				   OCFS2_STACK_LABEL_LEN))
> -				user_stack = 1;
> -			break;
> -		case Opt_inode64:
> -			mopt->mount_opt |= OCFS2_MOUNT_INODE64;
> -			break;
> -		case Opt_usrquota:
> -			mopt->mount_opt |= OCFS2_MOUNT_USRQUOTA;
> -			break;
> -		case Opt_grpquota:
> -			mopt->mount_opt |= OCFS2_MOUNT_GRPQUOTA;
> -			break;
> -		case Opt_coherency_buffered:
> -			mopt->mount_opt |= OCFS2_MOUNT_COHERENCY_BUFFERED;
> -			break;
> -		case Opt_coherency_full:
> -			mopt->mount_opt &= ~OCFS2_MOUNT_COHERENCY_BUFFERED;
> -			break;
> -		case Opt_acl:
> -			mopt->mount_opt |= OCFS2_MOUNT_POSIX_ACL;
> -			mopt->mount_opt &= ~OCFS2_MOUNT_NO_POSIX_ACL;
> -			break;
> -		case Opt_noacl:
> +		else
> +			mopt->mount_opt &= ~OCFS2_MOUNT_NOUSERXATTR;
> +		break;
> +	case Opt_atime_quantum:
> +		mopt->atime_quantum = result.uint_32;
> +		break;
> +	case Opt_slot:
> +		if (result.uint_32)
> +			mopt->slot = (u16)result.uint_32;
> +		break;
> +	case Opt_commit:
> +		if (result.uint_32 == 0)
> +			mopt->commit_interval = HZ * JBD2_DEFAULT_MAX_COMMIT_AGE;
> +		else
> +			mopt->commit_interval = HZ * result.uint_32;
> +		break;
> +	case Opt_localalloc:
> +		if (result.int_32 >= 0)
> +			mopt->localalloc_opt = result.int_32;
> +		break;
> +	case Opt_localflocks:
> +		/*
> +		 * Changing this during remount could race flock() requests, or
> +		 * "unbalance" existing ones (e.g., a lock is taken in one mode
> +		 * but dropped in the other). If users care enough to flip
> +		 * locking modes during remount, we could add a "local" flag to
> +		 * individual flock structures for proper tracking of state.
> +		 */
> +		if (!is_remount)
> +			mopt->mount_opt |= OCFS2_MOUNT_LOCALFLOCKS;
> +		break;
> +	case Opt_stack:
> +		/* Check both that the option we were passed is of the right
> +		 * length and that it is a proper string of the right length.
> +		 */
> +		if (strlen(param->string) != OCFS2_STACK_LABEL_LEN) {
> +			mlog(ML_ERROR, "Invalid cluster_stack option\n");
> +			return -EINVAL;
> +		}
> +		memcpy(mopt->cluster_stack, param->string, OCFS2_STACK_LABEL_LEN);
> +		mopt->cluster_stack[OCFS2_STACK_LABEL_LEN] = '\0';
> +		/*
> +		 * Open code the memcmp here as we don't have an osb to pass
> +		 * to ocfs2_userspace_stack().
> +		 */
> +		if (memcmp(mopt->cluster_stack,
> +			   OCFS2_CLASSIC_CLUSTER_STACK,
> +			   OCFS2_STACK_LABEL_LEN))
> +			mopt->user_stack = 1;
> +		break;
> +	case Opt_inode64:
> +		mopt->mount_opt |= OCFS2_MOUNT_INODE64;
> +		break;
> +	case Opt_usrquota:
> +		mopt->mount_opt |= OCFS2_MOUNT_USRQUOTA;
> +		break;
> +	case Opt_grpquota:
> +		mopt->mount_opt |= OCFS2_MOUNT_GRPQUOTA;
> +		break;
> +	case Opt_coherency:
> +		mopt->mount_opt &= ~OCFS2_MOUNT_COHERENCY_BUFFERED;
> +		mopt->mount_opt |= result.uint_32;
> +		break;
> +	case Opt_acl:
> +		if (result.negated) {
>  			mopt->mount_opt |= OCFS2_MOUNT_NO_POSIX_ACL;
>  			mopt->mount_opt &= ~OCFS2_MOUNT_POSIX_ACL;
> +		} else {
> +			mopt->mount_opt |= OCFS2_MOUNT_POSIX_ACL;
> +			mopt->mount_opt &= ~OCFS2_MOUNT_NO_POSIX_ACL;
> +		}
> +		break;
> +	case Opt_resv_level:
> +		if (is_remount)
>  			break;
> -		case Opt_resv_level:
> -			if (is_remount)
> -				break;
> -			if (match_int(&args[0], &option)) {
> -				status = 0;
> -				goto bail;
> -			}
> -			if (option >= OCFS2_MIN_RESV_LEVEL &&
> -			    option < OCFS2_MAX_RESV_LEVEL)
> -				mopt->resv_level = option;
> -			break;
> -		case Opt_dir_resv_level:
> -			if (is_remount)
> -				break;
> -			if (match_int(&args[0], &option)) {
> -				status = 0;
> -				goto bail;
> -			}
> -			if (option >= OCFS2_MIN_RESV_LEVEL &&
> -			    option < OCFS2_MAX_RESV_LEVEL)
> -				mopt->dir_resv_level = option;
> -			break;
> -		case Opt_journal_async_commit:
> -			mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
> +		if (result.uint_32 >= OCFS2_MIN_RESV_LEVEL &&
> +		    result.uint_32 < OCFS2_MAX_RESV_LEVEL)
> +			mopt->resv_level = result.uint_32;
> +		break;
> +	case Opt_dir_resv_level:
> +		if (is_remount)
>  			break;
> -		default:
> -			mlog(ML_ERROR,
> -			     "Unrecognized mount option \"%s\" "
> -			     "or missing value\n", p);
> -			status = 0;
> -			goto bail;
> -		}
> -	}
> -
> -	if (user_stack == 0) {
> -		/* Ensure only one heartbeat mode */
> -		tmp = mopt->mount_opt & (OCFS2_MOUNT_HB_LOCAL |
> -					 OCFS2_MOUNT_HB_GLOBAL |
> -					 OCFS2_MOUNT_HB_NONE);
> -		if (hweight32(tmp) != 1) {
> -			mlog(ML_ERROR, "Invalid heartbeat mount options\n");
> -			status = 0;
> -			goto bail;
> -		}
> +		if (result.uint_32 >= OCFS2_MIN_RESV_LEVEL &&
> +		    result.uint_32 < OCFS2_MAX_RESV_LEVEL)
> +			mopt->dir_resv_level = result.uint_32;
> +		break;
> +	case Opt_journal_async_commit:
> +		mopt->mount_opt |= OCFS2_MOUNT_JOURNAL_ASYNC_COMMIT;
> +		break;
> +	default:
> +		return -EINVAL;
>  	}
>  
> -	status = 1;
> -
> -bail:
> -	return status;
> +	return 0;
>  }
>  
>  static int ocfs2_show_options(struct seq_file *s, struct dentry *root)
> -- 
> 2.46.0
> 
> 

-- 
Goldwyn
