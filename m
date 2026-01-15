Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9DC2857CD
	for <ocfs2-devel@lists.linux.dev>; Thu, 15 Jan 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768501070; cv=pass; b=tsAHSYDBdfBwVK5zwLldSUbmpm1yw4qgMv2/yr1ey3NtCcwk+aeGp206tj30xIWurwuHVNPT0JiV8c7vlwIRpJvhG1sUxcbuht+dh5LvYKv9BgqWfyYDiejAKMQD64gqlq8mmcN+TVGRRJS1pwg0N5EKBGTeR1dodDV8S3QQN+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768501070; c=relaxed/simple;
	bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n2lwoU82V071XbC7vbtit8lye8o4ELPpNcWxh1CBkvSZO75elLWZ3qRMfwqSFCvgAFxj9Uan1TByqewt8VlAUFTdK99SaE9nD/iXLslg+t0UMLixNMOi9wL6kFURI3fQziVqmdgBBAxXDaOCeP02JKM+PPWKGaErvAKRm9hPU44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gLi6yUR1; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gLi6yUR1"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64b5ed53d0aso1716532a12.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 15 Jan 2026 10:17:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768501067; cv=none;
        d=google.com; s=arc-20240605;
        b=Q7P0R6g4HzDW27O65KjW4EAR6BYCkjleUrK248dx3+JZBdU61d3Yx/4Na3JK9Ecwgj
         Oi42qaQIUEC+Kr6jROvrmH1TahrbPnvc5hHqFJoJdW3bBcqaV2Kis6oRnpvi5iob/r9u
         iL+jDipOKkNzH1XPWaPFAPOE15DrIBGhGIran/oEkVLD0isFGFfDll+v/sjikzb0d+ro
         oPebqtBCvYb/aahMfNBDB/Bw5kVYmGac330doAc7WWM+4D0xLsALS+ICh2YJodCE7l1h
         HkgJk6b3KYZH6dgxxrVhPY72VNBQGazAgLOZ94JoPQGqmgoMme9EiqVoqPEQF45+oWgz
         joFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        fh=lLNhJA5e4ryT9CidT16oMxGn1AJf/mmdOzKgC4fv0Oo=;
        b=QSohMINm7exoXEPYn6iqy1883MyB329iNdo4+nXFMdIZy8Q963dvipLcwynNOcttaP
         gNpirS4T3iTkgE+nIvsTNWtU0wDf8FwkwHZUf9WTiVD52vmzPTeuH5vvATDxDf1Cr5Ie
         6FL0yp2ce46ZswfPucE+kCkTzxSacDERVJ7riqKQozmLVqOERjwA9745fsouTDKIzlyv
         fjPCCm3c9ARdvXMtBTAbnjIEokoqgyX0qFof0k8eGOCJIjgpfmRDRWSpQeQwX+VGXMlq
         aypU0S2uHgiWzDsLreh9K4jSIUXhe9JtjUN0QhBteC0CFeTp0VxtuAvsqFhZgloI4thd
         1r3g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768501067; x=1769105867; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=gLi6yUR12i3npVpyhbKivi+F2vYd3B2E52Xxgw12yhsRxVXZBeORK5T/lny77S+bl/
         EeXxBqLyA/HuJAlr0qWn6Qbv9GYP7Bsii89kGGvLPQsQtOn6gmpMe67doQpGqSHNhJGK
         6m3RaH11JF5qjdeKb8JXVVjYmoMSjVjVn3gC98ENUK71xWUV2CNl1TKmRVG6u0VnlqKS
         7e0EllwSPUpjztmTAxP8tZFHLk313rddgqvHykz3VCL2P8vRJkSb1Sa1Xey0s3UglKx+
         A/AhHr4RKiXcwTgEx/lT+G+pipaPwlxacr99319gy0uh3L+w3y3AS5ll5bhOszL6YL7L
         5EDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501067; x=1769105867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrPbqnzgCOvE5NgsFSOuHcaOEuIUQeGDqGbHFIodw8A=;
        b=uJdglQMinAJNl73xI/nId7lVSWIY2l8w/+Oj2nMOZzh8vxdoFuZvb3gxxWHAyzY9NX
         cF9KLwfEQ5YxdGqy3RLJ28aevBNLQyxg7dftAfW3xaqhUR5rtoBDm7GeidUC6tS1zf0l
         vl2GtZdRZ+DOGqrPRMc43s9qGTWaeTdsKZBqxMtKMCkcQSPiT2q8afziuyq/4aNGPc4v
         t8Du56Ni31Jfl91HXx0nhONkmbeJzgz0F0CnznC4OXjV+/tCkECA0yLXO/FgHPKNlLVJ
         xXsICAaBrAcTfKw6OOHB+6wWShcuiQHQLMY3HBiKq3QtCmgPa3C5oI8Z4LWR7p0z0zze
         H5OQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVE95TmfGoMhJ/8qQA0HBF7wmnBQWuaP0vkiKG9uTh6d8RKnEuNiOQgFCjkMVMe7Zi34BasSafgZrIeg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6/5DT0muc22IE2cLPxaTUDtM6AwdR5vvEApbGYSeomH2xDtAl
	7Plfjb+eYxmiX2VmYx2lkXH2aAri1SLaG+IajxjyqwSQznLg/6jNB9yZKYdl0oEpcfe/HjDfbUR
	U+JEb2zlwKocVYIC5x6NZRF1rJMSJBmE=
X-Gm-Gg: AY/fxX6PHiAJqUKVkhQmwmjIWoKyJXEU+NC2Af5I/zkwunUNNwWv06ONONlj2T5ymbR
	39KS1Dm61/Ko+MGOR9aOlxHNymi9ghlQ+1Drx9FRABESbevaQLX2Vq9wOFDe+Kjp2bp68xRv7BI
	Yvl1AewszCWxHNKOIuJvEoA2QipfWvJ6+NeVSjR8Pj9xnpNdzJv2Kj9WAO6JclSZXnPC44YltPe
	e5pEHIB/J72oDNGOx1uUnN8eRQRRaMdCvX0GJTPgZi7tWyOTqEQK3fPS4HHKXIQuRxBxlwIUBGV
	cJhnvK9ZvC1ZUtUV8jbPoc5DKNoopA==
X-Received: by 2002:a05:6402:510f:b0:64b:7eba:39ed with SMTP id
 4fb4d7f45d1cf-654525ccad4mr346097a12.13.1768501066374; Thu, 15 Jan 2026
 10:17:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 19:17:35 +0100
X-Gm-Features: AZwV_QjhT3ZtgvkbHJB7796GEklGCbcNDL5CeRwrn_YYeN3X8FqPO-3_iRnRORw
Message-ID: <CAOQ4uxjOJMwv_hRVTn3tJHDLMQHbeaCGsdLupiZYcwm7M2rm3g@mail.gmail.com>
Subject: Re: [PATCH 00/29] fs: require filesystems to explicitly opt-in to
 nfsd export support
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

On Thu, Jan 15, 2026 at 6:48=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> In recent years, a number of filesystems that can't present stable
> filehandles have grown struct export_operations. They've mostly done
> this for local use-cases (enabling open_by_handle_at() and the like).
> Unfortunately, having export_operations is generally sufficient to make
> a filesystem be considered exportable via nfsd, but that requires that
> the server present stable filehandles.

Where does the term "stable file handles" come from? and what does it mean?
Why not "persistent handles", which is described in NFS and SMB specs?

Not to mention that EXPORT_OP_PERSISTENT_HANDLES was Acked
by both Christoph and Christian:

https://lore.kernel.org/linux-fsdevel/20260115-rundgang-leihgabe-12018e93c0=
0c@brauner/

Am I missing anything?

Thanks,
Amir.
