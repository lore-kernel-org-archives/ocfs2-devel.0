Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B313596F3
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Jan 2026 09:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767950829; cv=none; b=nKNq/55n9X4m/gw/8eD/xfw6a3m2mWOadVdMtxvIlMWu7c3Pm+AWmwYTT/eFoXV4T7VZ4fb84v8AKzRykl2lnMySAocJNDDpkFYlG7Y0jSn9/ABwtcaborgBRU9/UNeYumxZ+tHAtAxu7q2Oday9GLTHImyevj1a6466CV4Hvtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767950829; c=relaxed/simple;
	bh=ieYSLGgTtXaBSsZi7KAl2J0dTzr2UwfHoVXBpw/UxdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OO49XF7lW/5MJ0Tp2XlSJEEULbGxLu/+HEKFUjb3Z+kYYTqag4TR93uEIUC2dcV2Dws34gMYsX3GkxiisnGPv5EE4k9OUgZcOY5b8oy/LElJxdLn/vPH/6aptNjSky+FkyqsoLwvUdjtHVY71JSQdgKou8EHN+I7XohRqQ5ZZ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KXI2iTWi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=I+3h+YTM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=16e6Tram; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PGw8o01N; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KXI2iTWi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="I+3h+YTM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="16e6Tram";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PGw8o01N"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 43CDB33820;
	Fri,  9 Jan 2026 09:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767950820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ix79vpLIssdL500RHYujbFB++xsIiyUcELipWU4WwU=;
	b=KXI2iTWiAJmOz21iis4yFqf5NnYhRDof3J19rqsZwYRuWlpBv5dcGDcz+rPkZ2NFQ7sBw3
	6F/yzH+m9ddnb9SROmmw6miQVWUavs2Eg8AGGPV1EpMQQU6h2S4XjYW76fJh6lzGTBRt02
	shHABFz4+AgJcXRKWJA4UpNzrHl4hCE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767950820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ix79vpLIssdL500RHYujbFB++xsIiyUcELipWU4WwU=;
	b=I+3h+YTMi7XyTBxg0nKsfasYi3xNLsyRViTjEJI4hA7/0Kr4xASdVvjM5NCcFY8z/BXHig
	gtG0FCWUIYgZrHDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767950819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ix79vpLIssdL500RHYujbFB++xsIiyUcELipWU4WwU=;
	b=16e6TramPJH4Gs7875HDbzGuy8ICZI2BILnT1SGRvVAXeI5sQUjzAFlNaNR9kACorpHpXM
	nei3ptJVD2BUcQ5r+hV5aj5YMzGmHUhxPPheHPPJgtr2K4a0j9TnIfXo+9hSNy8lOl3XCf
	SJ1RxzU1924fXlBtLP3laUNrmhN+RXw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767950819;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ix79vpLIssdL500RHYujbFB++xsIiyUcELipWU4WwU=;
	b=PGw8o01N9jcoRQmfnP+ZoeS9HgNB1q6FOHcZJKmgTM6SnO2dBelSCiHyvByrrSDNihQRUj
	Pa0cf4D023nkzOAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3206F3EA65;
	Fri,  9 Jan 2026 09:26:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TGXGC+PJYGkWAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 09 Jan 2026 09:26:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D22A1A0A4F; Fri,  9 Jan 2026 10:26:58 +0100 (CET)
Date: Fri, 9 Jan 2026 10:26:58 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, 
	Salah Triki <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>, 
	Christoph Hellwig <hch@infradead.org>, Anders Larsen <al@alarsen.net>, 
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
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
Message-ID: <qzdy4ipzuxl3exs26tr3kd5bloyp7lrr3fqircgcxltvoprd6k@shasgtm4zncv>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4>
 <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,gmail.com,fluxnic.net,infradead.org,alarsen.net,zeniv.linux.org.uk,suse.com,fb.com,linux.alibaba.com,google.com,huawei.com,vivo.com,mit.edu,dilger.ca,mail.parknet.co.jp,nod.at,dubeyko.com,paragon-software.com,fasheh.com,evilplan.org,omnibond.com,szeredi.hu,squashfs.org.uk,linux-foundation.org,samsung.com,sony.com,oracle.com,redhat.com,lwn.net,ionkov.net,codewreck.org,crudebyte.com,samba.org,manguebit.org,microsoft.com,talpey.com,vger.kernel.org,lists.ozlabs.org,lists.sourceforge.net,lists.infradead.org,lists.linux.dev,lists.orangefs.org,kvack.org,lists.samba.org];
	R_RATELIMIT(0.00)[to_ip_from(RL6z1i6dkhnac7oamujmo9nifa)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[86];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Thu 08-01-26 13:56:57, Jeff Layton wrote:
> On Thu, 2026-01-08 at 18:40 +0100, Jan Kara wrote:
> > On Thu 08-01-26 12:12:55, Jeff Layton wrote:
> > > Yesterday, I sent patches to fix how directory delegation support is
> > > handled on filesystems where the should be disabled [1]. That set is
> > > appropriate for v6.19. For v7.0, I want to make lease support be more
> > > opt-in, rather than opt-out:
> > > 
> > > For historical reasons, when ->setlease() file_operation is set to NULL,
> > > the default is to use the kernel-internal lease implementation. This
> > > means that if you want to disable them, you need to explicitly set the
> > > ->setlease() file_operation to simple_nosetlease() or the equivalent.
> > > 
> > > This has caused a number of problems over the years as some filesystems
> > > have inadvertantly allowed leases to be acquired simply by having left
> > > it set to NULL. It would be better if filesystems had to opt-in to lease
> > > support, particularly with the advent of directory delegations.
> > > 
> > > This series has sets the ->setlease() operation in a pile of existing
> > > local filesystems to generic_setlease() and then changes
> > > kernel_setlease() to return -EINVAL when the setlease() operation is not
> > > set.
> > > 
> > > With this change, new filesystems will need to explicitly set the
> > > ->setlease() operations in order to provide lease and delegation
> > > support.
> > > 
> > > I mainly focused on filesystems that are NFS exportable, since NFS and
> > > SMB are the main users of file leases, and they tend to end up exporting
> > > the same filesystem types. Let me know if I've missed any.
> > 
> > So, what about kernfs and fuse? They seem to be exportable and don't have
> > .setlease set...
> > 
> 
> Yes, FUSE needs this too. I'll add a patch for that.
> 
> As far as kernfs goes: AIUI, that's basically what sysfs and resctrl
> are built on. Do we really expect people to set leases there?
> 
> I guess it's technically a regression since you could set them on those
> sorts of files earlier, but people don't usually export kernfs based
> filesystems via NFS or SMB, and that seems like something that could be
> used to make mischief.

I agree exporting kernfs based filesystem doesn't make a huge amount of
sense.

> AFAICT, kernfs_export_ops is mostly to support open_by_handle_at(). See
> commit aa8188253474 ("kernfs: add exportfs operations").
> 
> One idea: we could add a wrapper around generic_setlease() for
> filesystems like this that will do a WARN_ONCE() and then call
> generic_setlease(). That would keep leases working on them but we might
> get some reports that would tell us who's setting leases on these files
> and why.

Yeah, this makes sense at least for some transition period so that we
faster learn if our judgement about sane / insane lease use was wrong.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
