Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39FB2D97BD
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767984793; cv=none; b=dzzdaOTT9lim2H3CG2Z2EvEeSkMfywQVY/dnYUTpxumiMfo/AJV3TMrzt8BYDLkMeNSfvnPKKeTYvXIsMUPO/npdcbWAS5IZqtEkJ5HHWy15lRNnq1CwX20vrzfNI1mETCBaBxSqpoXhLRjsViL1UvPjwHgwuWrBtbPG1AS5z7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767984793; c=relaxed/simple;
	bh=PEO8wbSaGOwwRv5UKfYcgXejOCV3Kmi4mBiob/Mhc5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JgSKvG3W0fbz1GtX98FHtDr5lgjRe51JqmERoQ5a3kiD7UocpPRCZxgJGsE67GQx+4tegTsmudg/52bZ5RG6xGJmshcRMwfmmTZ2yE3HQSuOWHw8bXqu1wFLRkU+2wqd2b587AIIqdAw4u3Lqwng6H2q8I5sZNXHDhyGoGnYx/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SCA8c0sB; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SCA8c0sB"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64d0d41404cso7021571a12.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767984790; x=1768589590; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEO8wbSaGOwwRv5UKfYcgXejOCV3Kmi4mBiob/Mhc5w=;
        b=SCA8c0sBAdCEOBBDJLhj47yxx2MQSllQO+hnIxCp5sItnbxZuIMCY6zjsWvcDsxrVs
         slZUMENkX8qTU+W+KmyMGMd4ExUlaP2HBwGyuLwQVn1Pfobj2sYXo7QsiI97reA3q1iz
         xfuQ+Q2nlhfMlHZUVelZ41aetGLQduYlGVkYCxoM6jS8omGELB7HH7tSnc5d8PkT3X4y
         QP7PhZhW9sX7yEm13vyII0Edm3xIgX6+Jj+OCZR9oZd5QcGnRWBJx0Q9p8a541Begyjc
         cKXpNcJA0D25YQ002MD3Natk4n4b/7nPQCmwYmfXnT5Irrw40XUwL3ggYKgssvOmD6kD
         5yfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767984790; x=1768589590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PEO8wbSaGOwwRv5UKfYcgXejOCV3Kmi4mBiob/Mhc5w=;
        b=X6HVsopEbml4bAB7sl5uYUxtmzI8qlWHuuBIx3PEIRkM90NWJCwYsOoOgJdnF3uoZQ
         nhPYMedN/F2Z6WGg1RE+Mr875lE/kEBjeME8QMkrYKd/GVE4QsgGXMRyYWO6eXfzA/z5
         Jr5UoA1PJuEGCe+h5g6Dz40pKLTAeVotqVKOCOCdHr4o0mkgLBpZH7e9Khcu+78/zvVu
         gndbu23SvQU2n2PcYhCsch0gINBKsdRE376fGNaEmv7Y2JDXN95Oy5Yh/04xFRbSRhxw
         1h5Taj+p7ivo8Oiggwi1Y/66Q3AEQYQGvHlEdKMm/+VRkcFExL+rjqDR3bAlOO5/elWO
         rI6g==
X-Forwarded-Encrypted: i=1; AJvYcCVHVbUT3brf+aouuwPtsgQMyFtpVhDKU+G1sj54ykg/vXCyMccoHVP6uhOpzI+UDzXQTA17tnRK2ksoxA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxMwxp8KrbSllm7wvKpeCDLxjpgkK4wG4f6ldmIv4iCMD2cgxer
	cfgC0/pzHKVICsuOJZOja4OS+wqz/IKN0Semp7oDoY5hZtSzYRXTl0XtARACP2EJmPS9vwCuLCa
	GOIKqph3C1FV1j9c1IlIJdK8a+g0ZG9w=
X-Gm-Gg: AY/fxX5nfTBou3KW9MV+yLudCIbf3UzqoMnyKAkZtU1gOJe+qvhOwC4/Czw3qWasq7Y
	D+Z+7sg2AuZakGroEIpRHdxiwN1mvYiqaPJZ/A+Cm0FVzDEpxWdvAK9M6FCFfp+4BW5RYwfy3q8
	wY984BP6nNpw/bVxnAPVe7xIdZZ5OiXRWbo5XUdvNrbr4O7d8yd5APSyMbYR1mHSA2pyC9YCMNm
	NPbcBDUQdRwi79HgLFnLe8iT/LbGxgFEQnjLJjoDEo3NkRBERS7eokMsNOiz9XXKJ+L4mO7jq2I
	wEn0Lv4xiKraCWFvv/+g+6dAH+HzSTFqcb+rEhGt
X-Google-Smtp-Source: AGHT+IFY7MBbUL67We039/hTqFQidfYCDXoLMKl5hH4eJeY3RDGzxdromP5L0kMZXOGuaChoBhGE8PO55vilYs9+TsQ=
X-Received: by 2002:a05:6402:278f:b0:64b:4333:1ece with SMTP id
 4fb4d7f45d1cf-65097e88af5mr10672063a12.34.1767984790069; Fri, 09 Jan 2026
 10:53:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4> <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
In-Reply-To: <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 9 Jan 2026 19:52:57 +0100
X-Gm-Features: AQt7F2pw3gC6snSxmHIFjd46zJk7oZ4nEXaveS8flAw1hsLI4KglAqmZVf1WWIg
Message-ID: <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
To: Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Christoph Hellwig <hch@infradead.org>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, 
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	gfs2@lists.linux.dev, linux-doc@vger.kernel.org, v9fs@lists.linux.dev, 
	ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 7:57=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> On Thu, 2026-01-08 at 18:40 +0100, Jan Kara wrote:
> > On Thu 08-01-26 12:12:55, Jeff Layton wrote:
> > > Yesterday, I sent patches to fix how directory delegation support is
> > > handled on filesystems where the should be disabled [1]. That set is
> > > appropriate for v6.19. For v7.0, I want to make lease support be more
> > > opt-in, rather than opt-out:
> > >
> > > For historical reasons, when ->setlease() file_operation is set to NU=
LL,
> > > the default is to use the kernel-internal lease implementation. This
> > > means that if you want to disable them, you need to explicitly set th=
e
> > > ->setlease() file_operation to simple_nosetlease() or the equivalent.
> > >
> > > This has caused a number of problems over the years as some filesyste=
ms
> > > have inadvertantly allowed leases to be acquired simply by having lef=
t
> > > it set to NULL. It would be better if filesystems had to opt-in to le=
ase
> > > support, particularly with the advent of directory delegations.
> > >
> > > This series has sets the ->setlease() operation in a pile of existing
> > > local filesystems to generic_setlease() and then changes
> > > kernel_setlease() to return -EINVAL when the setlease() operation is =
not
> > > set.
> > >
> > > With this change, new filesystems will need to explicitly set the
> > > ->setlease() operations in order to provide lease and delegation
> > > support.
> > >
> > > I mainly focused on filesystems that are NFS exportable, since NFS an=
d
> > > SMB are the main users of file leases, and they tend to end up export=
ing
> > > the same filesystem types. Let me know if I've missed any.
> >
> > So, what about kernfs and fuse? They seem to be exportable and don't ha=
ve
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
>
> AFAICT, kernfs_export_ops is mostly to support open_by_handle_at(). See
> commit aa8188253474 ("kernfs: add exportfs operations").
>
> One idea: we could add a wrapper around generic_setlease() for
> filesystems like this that will do a WARN_ONCE() and then call
> generic_setlease(). That would keep leases working on them but we might
> get some reports that would tell us who's setting leases on these files
> and why.

IMO, you are being too cautious, but whatever.

It is not accurate that kernfs filesystems are NFS exportable in general.
Only cgroupfs has KERNFS_ROOT_SUPPORT_EXPORTOP.

If any application is using leases on cgroup files, it must be some
very advanced runtime (i.e. systemd), so we should know about the
regression sooner rather than later.

There are also the recently added nsfs and pidfs export_operations.

I have a recollection about wanting to be explicit about not allowing
those to be exportable to NFS (nsfs specifically), but I can't see where
and if that restriction was done.

Christian? Do you remember?

Thanks,
Amir.
