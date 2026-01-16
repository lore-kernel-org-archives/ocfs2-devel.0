Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4C1399A55
	for <ocfs2-devel@lists.linux.dev>; Fri, 16 Jan 2026 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768574827; cv=pass; b=uzjIEI3BJJPNcHSCIx3c0HwKxObntROG9oS6PXt+adwVI043JunlYL+hIf9a3xk7ux1bvUdh+lZAXKjvZl8mwHkpZ1sfnl/519d/UgbOUKLkebod2PdynJ9yNcbtVPun5w+/MjmHvQz2wcr9OBwG4NYDIAyZirROpomRcMYCw98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768574827; c=relaxed/simple;
	bh=roiUOgMNh/uHT7xq/Ufc65Xx1gVdLlGNv2hq3QwsGUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LPbFpS6lYzPzsgItPtFeFQRgDzVhgVFVgTQO6kDrWC/569xEzQ4F/7+WSD54hGooOTaTEqNPsrB3lhtYrqy/EpPT9vXHLHJiRcW6RypH2PPRyWTuYi8wrN0D+B9dw/yplLY8Uh+lJ4bLQPeGYx85s/fmMZ9w7VmH3T8H775jOIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GId/cctv; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GId/cctv"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so497674566b.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 16 Jan 2026 06:47:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768574823; cv=none;
        d=google.com; s=arc-20240605;
        b=HNmb8AK7I3pRUYITvlitC+QCDzekfRQNBPBPlsWRflcZUP6YyveU4UznSQd0C43fCI
         vcOgodRV/iY6eOSffZXoGkFlCDSzXL2HAw8G0VSXBnPYQbw8wunxN2ClR+TJjrlgeDjy
         JRWhdGGQ6wuv2F+MvDpYHB4FAy28UpB7NBPjzGMDg3qXxL/Nd8Vhp3JhPxRsisdPfuaE
         Amagkxbz9uAIRcmBb/W4uxfqKnOVPeEyX4Rj5WgfR2QdcpSfwox2lBXCY2xEJKRTGzj3
         eGbuwJNWjExcReIP11LeQJ9/6tVl+4so074MFwHTiSS3p9cX4wmzHSnWzLXO1HmLmdR0
         m5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rWCEzzwQTN3Jcqg8Pr6svjg3sqJRK7qADI0E/O11arI=;
        fh=JSgUWTLX6NM0dG6Qkxm+lOAIyAJYfQbtJJi0AoUa0QQ=;
        b=MESlf8rugWoerWRRm9F99JJ0tONcxe9C6yHLBshw8bHWE9n5REmJt+sbrsTVoYUcYO
         wPepw3SotHGKW+YMCy7h4Z2KQJTyF2jdFhSlR20Ri/vQ0I7ClmEplDa6vzFYGcXkuO3U
         /qKEIXyiGwcVInsJtk0FlQqS1sKBD75oemWyCC6kDzAKYDEZwMGKdW73z4OGfhIAddj9
         hcdwQr6qorE2uaLrCAlfBWZD7vqh2nrVdhD1t12MbAvMihzXbKphNNhHObmlOBNBOYSH
         2EcpcCDYmJHt7Yw5A0C55V4pwEK+061V/2CGe8BMMkAJwHA3MT8eqcPcYG1/AFzOB1il
         IMIg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768574823; x=1769179623; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rWCEzzwQTN3Jcqg8Pr6svjg3sqJRK7qADI0E/O11arI=;
        b=GId/cctv73AaW+rDv6+X7nkHUMrQblqaqRg1uQP/xd+NbsxW+3exblHqWnYDQ2u01h
         Dn9/469/0X4YOzYYOeG4UHDkUYMd6CUkqh5L1hKf/EZgDRYo+C9tTxx+bibHYUH73CpG
         Sy0DYgKygAYDUd9aH+ue6gayfp7YFWbum+2585ZLDsJBf09IN7NRXde55WIChvWNDWfG
         wAe9hsmZFaAVhSZ3BuxmD+psnR7iGv2d9c2wCrY9T43tFDC402T9hlqBdTl6NhgjexRQ
         PE1RukJeFU0CGQKfWkBSgooo+xtXMxqtG/ODeG78idW2EXpJdQ9L5xYtc3l2YGYSoCNW
         Rw4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768574823; x=1769179623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rWCEzzwQTN3Jcqg8Pr6svjg3sqJRK7qADI0E/O11arI=;
        b=mXfsvMuBxWARo0P/J+oYSnKHM5euvQPCBjmXKCivIPVoUi3Wk8iyEJPYkFm+OqZfvS
         1UDJYEukWurWR0G8cZ0KB5EO1htpZcK9voV3E5pC5jRs56UhMzbypc7p7lkqOekQeK+1
         cQCNh7PDxu8gNgmV/n3EQEEzTb6Bf1f2q4+oJlF8R9I4uaeUJoB7GGaecHp9KbIzWTgq
         Hae9E34Tn9SM0Sr/zBOjp0IvVaoBNWiSnMsGo6xRp67lUabMHNs6XB6vaL95wVL4Wk6j
         weA/UK1qUVFpHQH8A+61IPsucefbkgG4obG6Lk1Kp1okjN+D8rNteoqoTWEek1lmEp3r
         AGBw==
X-Forwarded-Encrypted: i=1; AJvYcCVRhfIf/olY6LTInqEiuvRDdMcDO0oiHf9qdd+w/bihQ1cAyq6F27QyC0C/hBeFBPWlXcTVGF+NMgzJEw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxZ1C5eoXcsl7ULSZheYugQ4AREzo98AvxbjGKSQiJ9ACigyooz
	s+CwoprZg7G5cJPMXUd70wI9tpdk3hc70FXwjGScUrieyzG6P01o5/D+htNxjwBWMO5NZo1Lwj4
	Y6oimumsmQBRPn6Y0Zd3ehSySfiFNNL4=
X-Gm-Gg: AY/fxX5nhzqENcUy0w2zfFUvuOu0F8TVax21hTwIIUXvN6JaV6Uf3jlYewQO601PRBM
	9RfoHwySyxKcjOLVDb9JReiFqUaF/OAJNHPbG4PgVrAHE0PbBvHU/HtDZwNvRKRWlJWlkHyCglc
	tm0N0zT6DMyOIF459YFXcPbJdbU5TtRKap3r3pjtMCftUsBsFBnodPQ192yeqwYjLWn8wWNWzYe
	9tus6WaJvBBzKE4WoeTDH7CgdSTWhD7N1KZpro8QK2Hpxj0DZLS7S7rf36ZiLP7vjU1V4iTW0HD
	d4rH8CGfiLnAGk3rWuELz0gRRanScg==
X-Received: by 2002:a17:906:7305:b0:b72:a899:169f with SMTP id
 a640c23a62f3a-b8792d6cf8amr335795366b.4.1768574823087; Fri, 16 Jan 2026
 06:47:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org> <CAOQ4uxg304=s1Uoeayy3rm1e154Nf7ScOgseJHThw4uQjKwk0A@mail.gmail.com>
 <8e4c3df4828351c677186bf018061f2b1fd1b48e.camel@kernel.org>
In-Reply-To: <8e4c3df4828351c677186bf018061f2b1fd1b48e.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Jan 2026 15:46:50 +0100
X-Gm-Features: AZwV_QiRcITYtWxbtRpeIxfeQr9ho0AGFQM_8wESdHA53c49E-5t7eaX1T9rC3o
Message-ID: <CAOQ4uxhkZNueydP0tTCAj6tuzKWPTYB7=JR_hb4gaavSKQ8C2w@mail.gmail.com>
Subject: Re: [PATCH 29/29] nfsd: only allow filesystems that set EXPORT_OP_STABLE_HANDLES
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2026 at 1:36=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Thu, 2026-01-15 at 20:23 +0100, Amir Goldstein wrote:
> > On Thu, Jan 15, 2026 at 6:51=E2=80=AFPM Jeff Layton <jlayton@kernel.org=
> wrote:
> > >
> > > Some filesystems have grown export operations in order to provide
> > > filehandles for local usage. Some of these filesystems are unsuitable
> > > for use with nfsd, since their filehandles are not persistent across
> > > reboots.
> > >
> > > In __fh_verify, check whether EXPORT_OP_STABLE_HANDLES is set
> > > and return nfserr_stale if it isn't.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/nfsd/nfsfh.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> > > index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..da9d5fb2e6613c2707195=
da2e8678b3fcb3d444d 100644
> > > --- a/fs/nfsd/nfsfh.c
> > > +++ b/fs/nfsd/nfsfh.c
> > > @@ -334,6 +334,10 @@ __fh_verify(struct svc_rqst *rqstp,
> > >         dentry =3D fhp->fh_dentry;
> > >         exp =3D fhp->fh_export;
> > >
> > > +       error =3D nfserr_stale;
> > > +       if (!(dentry->d_sb->s_export_op->flags & EXPORT_OP_STABLE_HAN=
DLES))
> > > +               goto out;
> > > +
> > >         trace_nfsd_fh_verify(rqstp, fhp, type, access);
> > >
> >
> > IDGI. Don't you want  to deny the export of those fs in check_export()?
> > By the same logic that check_export() checks for can_decode_fh()
> > not for can_encode_fh().
> >
>
> It certainly won't hurt to add a check for this to check_export(), and
> I've gone ahead and done so. To be clear, doing that won't prevent the
> filesystem from being exported, but you will get a warning like this
> when you try:
>
>     exportfs: /sys/fs/cgroup does not support NFS export
>
> That export will still show up in mountd though, so this is just a
> warning. Trying to mount it though will fail.
>

Oh, I did not know. What an odd user experience.
Anyway, better than no warning at all.

Thanks,
Amir.
