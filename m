Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E6F28B4FD
	for <ocfs2-devel@lists.linux.dev>; Thu,  8 Jan 2026 17:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767893356; cv=none; b=L12dCoT63BWnZwGD/GdvQHmBogsarZriAONQ9CvTQYn5tIyJt4yy4SNc3pGcjJfXpKMJt05kMr/GuRbJ7vVJ7jkqcDLGaLBYF9rtslHGitlG7wwE1ZU92SUuj5mjGQjhgnhqEAIObz8B3UMS/EGW4suvnU5Z39suLR7iAyh/TSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767893356; c=relaxed/simple;
	bh=QjHdQfnNg+Za/CYkkniRUbTtNLhua7jmppdVYx7FN40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FqbTgdvYHsc5aTHgAGW4twTq74q7cYpPPtbfV9L1h/jFMuZUeIBTQmFcEuZWIse+C+ii77PQiWXXNShqmoV46P7x8Qispt/QQBS7q+mYQwO+Tk0O83NJLoD3An9CeyOtj86ysxKFQzMIHSJz+bIvzkCc30q1JA4/snu65fb0Wwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=q98OikX8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jLiiYj1N; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=q98OikX8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jLiiYj1N; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="q98OikX8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jLiiYj1N";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="q98OikX8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jLiiYj1N"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 58B935CB90;
	Thu,  8 Jan 2026 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2FXB05KWinghyISdrGnDsHHRXJ2LLquCS7DmluRFvrw=;
	b=q98OikX8Rlp+tPfB2ZHxVR36nEhJ+HZD3bnqMRpYfLGtKGtaEncX/JNBcjEjloWK4bXk1i
	cIWDAvSVP/sBQXMd6MLI6eFHRSDl9mCxqH52YzdYtVgcoOrPlWPoiERTin9dhH0ik9+24V
	rDIl9wrHXO7t0NpcA3X/w+2/NXnTdMc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893352;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2FXB05KWinghyISdrGnDsHHRXJ2LLquCS7DmluRFvrw=;
	b=jLiiYj1NB/KC2FKXGW0Rp8Gdggj+tWABL2abRsfkiJij0e8jQKly3ieKviRIh0zE1u83aY
	WzA2A1lxr6mI77CQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767893352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2FXB05KWinghyISdrGnDsHHRXJ2LLquCS7DmluRFvrw=;
	b=q98OikX8Rlp+tPfB2ZHxVR36nEhJ+HZD3bnqMRpYfLGtKGtaEncX/JNBcjEjloWK4bXk1i
	cIWDAvSVP/sBQXMd6MLI6eFHRSDl9mCxqH52YzdYtVgcoOrPlWPoiERTin9dhH0ik9+24V
	rDIl9wrHXO7t0NpcA3X/w+2/NXnTdMc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767893352;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2FXB05KWinghyISdrGnDsHHRXJ2LLquCS7DmluRFvrw=;
	b=jLiiYj1NB/KC2FKXGW0Rp8Gdggj+tWABL2abRsfkiJij0e8jQKly3ieKviRIh0zE1u83aY
	WzA2A1lxr6mI77CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 446973EA63;
	Thu,  8 Jan 2026 17:29:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OEmrEGjpX2kZeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 08 Jan 2026 17:29:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 008D9A0B23; Thu,  8 Jan 2026 18:29:11 +0100 (CET)
Date: Thu, 8 Jan 2026 18:29:11 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, 
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, 
	Dave Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, gfs2@lists.linux.dev, 
	linux-doc@vger.kernel.org, v9fs@lists.linux.dev, ceph-devel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH 15/24] ocfs2: add setlease file operation
Message-ID: <ou554m23k22d2mswmhwxyhrhfnrhz6socc2jx7p2ef3w7zb56f@noumdopgdg5f>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-15-ea4dec9b67fa@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-15-ea4dec9b67fa@kernel.org>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	R_RATELIMIT(0.00)[to_ip_from(RL6z1i6dkhnac7oamujmo9nifa)];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,fluxnic.net,infradead.org,suse.cz,alarsen.net,zeniv.linux.org.uk,suse.com,fb.com,linux.alibaba.com,google.com,huawei.com,vivo.com,mit.edu,dilger.ca,mail.parknet.co.jp,nod.at,dubeyko.com,paragon-software.com,fasheh.com,evilplan.org,omnibond.com,szeredi.hu,squashfs.org.uk,linux-foundation.org,samsung.com,sony.com,oracle.com,redhat.com,lwn.net,ionkov.net,codewreck.org,crudebyte.com,samba.org,manguebit.org,microsoft.com,talpey.com,vger.kernel.org,lists.ozlabs.org,lists.sourceforge.net,lists.infradead.org,lists.linux.dev,lists.orangefs.org,kvack.org,lists.samba.org];
	RCPT_COUNT_GT_50(0.00)[86];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Thu 08-01-26 12:13:10, Jeff Layton wrote:
> Add the setlease file_operation to ocfs2_fops, ocfs2_dops,
> ocfs2_fops_no_plocks, and ocfs2_dops_no_plocks, pointing to
> generic_setlease.  A future patch will change the default behavior to
> reject lease attempts with -EINVAL when there is no setlease file
> operation defined. Add generic_setlease to retain the ability to set
> leases on this filesystem.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 732c61599159ccb1f8fbcbb44e848f78678221d9..ed961a854983d5e7abe935e160e3029c48e6fca4 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -19,6 +19,7 @@
>  #include <linux/mount.h>
>  #include <linux/writeback.h>
>  #include <linux/falloc.h>
> +#include <linux/filelock.h>
>  #include <linux/quotaops.h>
>  #include <linux/blkdev.h>
>  #include <linux/backing-dev.h>
> @@ -2823,6 +2824,7 @@ const struct file_operations ocfs2_fops = {
>  	.fallocate	= ocfs2_fallocate,
>  	.remap_file_range = ocfs2_remap_file_range,
>  	.fop_flags	= FOP_ASYNC_LOCK,
> +	.setlease	= generic_setlease,
>  };
>  
>  WRAP_DIR_ITER(ocfs2_readdir) // FIXME!
> @@ -2840,6 +2842,7 @@ const struct file_operations ocfs2_dops = {
>  	.lock		= ocfs2_lock,
>  	.flock		= ocfs2_flock,
>  	.fop_flags	= FOP_ASYNC_LOCK,
> +	.setlease	= generic_setlease,
>  };
>  
>  /*
> @@ -2871,6 +2874,7 @@ const struct file_operations ocfs2_fops_no_plocks = {
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= ocfs2_fallocate,
>  	.remap_file_range = ocfs2_remap_file_range,
> +	.setlease	= generic_setlease,
>  };
>  
>  const struct file_operations ocfs2_dops_no_plocks = {
> @@ -2885,4 +2889,5 @@ const struct file_operations ocfs2_dops_no_plocks = {
>  	.compat_ioctl   = ocfs2_compat_ioctl,
>  #endif
>  	.flock		= ocfs2_flock,
> +	.setlease	= generic_setlease,
>  };
> 
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
