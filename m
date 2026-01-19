Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C303A7832
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841015; cv=none; b=GH7TPOxdTgRmhkcUwxruVsITJFkBE3zfKBJIFvhHjVKIukYvGY/3wigdTwTiIvlCP7VyHFmzJC2QakOrJJ7ckrUtKXamLDpgdNtHy0HpiFgbFtKS12J6nV6PJM6O2FY8avj3UpQWC3x9pxlbVTWmuk88vgxj14g5pnSQjlda7Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841015; c=relaxed/simple;
	bh=CQ3IL8fqKnWIgvRv+IOv0Cfz8J1ZjzxNV5oCIJJcLY4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PAjto5prJip1AULIGdc+tM392mN/+DhR0mhsUanjCN5wwICpZYFnZ1plzxku9SXJoD8sVH9wNsVNmSBs8/MYxuZAXcn0RASVFHqfq8el7mw5Bf7+uUZL7h/w+EFta4TPW58VGH/UHl6r0mmhgRE8qrFAY2NgDPwQ474cCc5cXzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dte2BOvy; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dte2BOvy"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64d4d8b3ad7so7241259a12.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 08:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768841011; x=1769445811; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7xapJC59KqqTTsHRvPEloTsuOjJhUfycEcUpCAL4U8=;
        b=dte2BOvy9smLAXf5E6CLaxy4tWSqQ2FY38x+55qUVbbzuT7XXop0zJNXqK74mRl0n7
         zc0l+bRgzNa1x8ApGP93awlG9F0kDIOnXt1XEnjEGDMg+0TzsA/6oyXDITB6yFD1Qd3n
         NvwR1Zhy1E+oT/EZLxrCqMdcXq0YSQzKJyrtKKi/BGQdEG2CtVcSSJTE5L/jdh2KSx8E
         fqzMrm27MSkyi5WUME0GnE4xe7oiqIbu+IR5NByDHmhGqtXSib4zAFrjaUH7MJl5pix/
         jJnihfIz/MVKxoIgnEcu2LUee8Ej9oq+gP7cCsKUM2qgLjs4c9S0woSDGySv1f9q9xuG
         Qn6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768841011; x=1769445811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t7xapJC59KqqTTsHRvPEloTsuOjJhUfycEcUpCAL4U8=;
        b=S2tM3Y9akvGFqNRB2HjuPmN3rqk/bVUn9E/vCTu4IvUUnHzxiu0Ta1zzQVpooCh+YY
         YQazOxYj35L2NyLFmhoLLv/BokosXeZeKolRZG79ytMBA4hDXW12cQaQTb7x7RcLyY2x
         lwrPWpOaFfErY1SLcStBQ51RIKUzFRFNdjljtsX6jiIv4c9qKfVfh8ZM4xYzLpVRtWjv
         F+ngtgvf7Uksw3bj0BvgNB8oIDW37QzawYflpxr5nmtdDU+wOwttWNif2x0LyEeBosM7
         yR+QrbZk34p/E0mDRLGBjm2ufWnpY6yHwuFkfeaSoUJt6UJ3zBbTKELUO/1JwKqRaoNK
         kc0g==
X-Forwarded-Encrypted: i=1; AJvYcCUKFHJyQURu15yj8RC+J9kU0fwUdkmb2k9Drny2dM/PQ0VKW0kmRGCCIN05wB3US/XXn57nis985KuGVA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzAp7mb3L1L+gDuQpcopn7pVUKYDWEFOTGqcz/ssoB5l3pBPpV/
	DHj5tsPUeO7i34mseYrHKy6Yjn3K9sJJF6+me3gSPk6XZkQOjEybWRrbrjBDpBgiZH26bUriU6y
	OOlc5O4pvOVEdu/JPXKfGZKovRTizUbg=
X-Gm-Gg: AZuq6aLPP/rLWI8u92v4gjc1ynrGh/X3qyFbhv8avBF8HOqCDqqnZkErXqjb2fPMD37
	Y9P1azUnJWVpA8pGo5PV7W0REU63/tym4JKTTf3GFjZ0GTsGSOol2AjJNCi7hENN9xoPmNDmVWB
	ZfCN0wi/aa2Y/l//ODxuYUzZlj1B0Uj5JDS6eeKcmWSCA6edvYW8k8hwoniXHQ1URKv3V5hnT1L
	CjEcv06Ti1quS+p5MWgCIZJw5GVqEdSFB/XkFpMUl7g+DpPd8QHn3V1qVEb2fqwRMRQYESsBZyB
	z8qM3jGN1DGKx/aYvIAVnJ43xLRAsF14WRg93gI+
X-Received: by 2002:a05:6402:5106:b0:64c:584c:556c with SMTP id
 4fb4d7f45d1cf-654bb6192admr8530585a12.30.1768841011353; Mon, 19 Jan 2026
 08:43:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org> <20260119-exportfs-nfsd-v2-27-d93368f903bd@kernel.org>
In-Reply-To: <20260119-exportfs-nfsd-v2-27-d93368f903bd@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 19 Jan 2026 17:43:19 +0100
X-Gm-Features: AZwV_QgQ6YFmczFqASwqjyOa509PoCTPsOB-sET1G173IBHOd4X5kFjH9N6z5MI
Message-ID: <CAOQ4uxjyTdf21G1Y=_5Eox58drVPA0gAMeSQZxh=T36_yzssNw@mail.gmail.com>
Subject: Re: [PATCH v2 27/31] fuse: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
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
	Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	David Laight <david.laight.linux@gmail.com>, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 5:30=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Add the EXPORT_OP_STABLE_HANDLES flag to fuse export operations to indica=
te
> that this filesystem can be exported via NFS.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/fuse/inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 819e50d666224a6201cfc7f450e0bd37bfe32810..df92414e903b200fedb9dc777=
b913dae1e2d0741 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1215,6 +1215,7 @@ static const struct export_operations fuse_export_o=
perations =3D {
>         .fh_to_parent   =3D fuse_fh_to_parent,
>         .encode_fh      =3D fuse_encode_fh,
>         .get_parent     =3D fuse_get_parent,
> +       .flags          =3D EXPORT_OP_STABLE_HANDLES,
>  };
>
>  static const struct super_operations fuse_super_operations =3D {
>
> --
> 2.52.0
>
