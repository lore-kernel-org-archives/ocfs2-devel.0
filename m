Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF23A35BF
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 16:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768840991; cv=none; b=rruQ1PEW4KCgS4PuBmIBGP+H4rYivuhWXe/chnxZ7FhTb1G/Yn2rf4hKbgPRbW3pddkY+cX5E3wmLKHn87N7pYx86mpilsmz3yL2rjmncO1p/rZYvUtCPwwjkObR1EEDTRqpWTnYhX6vbeSiinCL3K3orQznBkRSx5vvNvhRt/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768840991; c=relaxed/simple;
	bh=vfqhKWwiRrrnfWX4CrdJmI0n1g3fK/4yGHAQKrOzOrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ceuPEurgxC440a+v5u5zrqrYbdEs8sfq7XnJIKfDxercpMv9U0Xs3EhnnJQS5xHpJR0u1PdoZCBcfsAzO2ihzvdSgBnKKiIRZb3107a8SfY52rFcWyu7NJ5mwbjUtLvg27b6l3uki3DXDOIm5A9BfUzRN2WAz1rIhlKzYaOlCMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AlnE+Ovg; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AlnE+Ovg"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6505d3b84bcso6787835a12.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 19 Jan 2026 08:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768840987; x=1769445787; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OP488vxzDs37SDvqB3SvtrET0fHZKVUQCP8+UqFkiUw=;
        b=AlnE+OvgC+C59ATzlrDbJCf/UI+uhnkWYlLtfDnGdRHU+ks3JDWTujFVyLnsrKmZ3e
         r4sRBH/6I0iTRDX9k7Sk8bZlxYGVCgnn6jwuXvK3OIn9+M00pHPOjdW+H7yjxj4yIzhf
         cCC/VNros6yokyZt7E9fJcuV+6Tav1gehtRpFTxSCfVnJ63F0Olmu7/QtplMjS0NB0GP
         mzu1k7g4ODHcSf/+qCbnDEUfArL0r6/fQWp3nO+AaEUIcLxWQ4rlKi3Xs8gg1InAgL77
         CqRkrLCdJ6MRC90Q0BGvzwWMdvXFSJ8n0BdguFoCtNf9Gm/pqjVolTUxPTc7h7ShfjtP
         p1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768840987; x=1769445787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OP488vxzDs37SDvqB3SvtrET0fHZKVUQCP8+UqFkiUw=;
        b=oQPRUOeluuNt4oBGgaFXlZsWV+uvz/1C69KZKnaSOYtPFaylgGqptDBZUDJRghJ/yn
         FXYS40TBAL7Jg72I3iFxPBtT6P0Yl6Zf4vH0xbNgkF+DbJ1PJCUWo2qf3HtOO3Ppe7yt
         pHITeLqtYtqNtz+FL+B6fhVn5LSi0PhDcuaj5udKcPcY6WBytqTnFhSva+2sckSxT0Nd
         7kYYQHr01QdevgiB1QGnUs7dGXNL4Xgv1bxvU8a0hmsWmJL6rjr9G4ZamTwBTRcayt8T
         wqrjQLJMoNF0h7Jk5RKAAsdv9DvmA9MGU8n32xkML5TzjWraiTHsUUebYVEiprJpk+eN
         HIVw==
X-Forwarded-Encrypted: i=1; AJvYcCWxIE+immxVDljDg1h6JjXAmtt1aWbEyW/f+fHvjyBl/dQceJtAAgWQmeEaXQVnFqDr0QtgKTtwyZxZjQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yya521yWCGcqWCcznub2Racoxg/F8qpSg0mtfoHxEZi73nZ9eFq
	oklyb0TD7KOb8QvgEDMd/5iLn8Ee7BSnqKMciK9HShBoS8sHXzt/3cFw37MrPtqKtHltX4Ke0H8
	K993+5nWMK8nAoV4N6RcCjyj8Ydfu1TM=
X-Gm-Gg: AZuq6aLDial9wYvEZLCbrtBqX/kVrvjtKLMRn5gpkoh4Qkg17bCUH1RSPLbZ4yRhWVs
	TxyguWaIMArNbqVwoZchA6fIb/8xTIDJdr9VO762N54bSzuvVVPOXMFC0jY+cADfoKO/jWI/Zds
	bV7IOWGXud0e3jiY+u3mpzcQrvRe+9xlSP89Wc7zb9NaC6VuQRCT/Wd1uN0SnVp/EEqWeHOaymm
	BZSggPVHtkAXuC17eBxjJb6ylfT72hcY3KGMrLQGEmNYIIOWd1Yftqf2pOJvecTqX2PzBQ/Tr6p
	ga39NsoxvututuFvEqFoRX9nHAnq7g==
X-Received: by 2002:a05:6402:4304:b0:649:b200:afe9 with SMTP id
 4fb4d7f45d1cf-65452cca909mr8384256a12.27.1768840987066; Mon, 19 Jan 2026
 08:43:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org> <20260119-exportfs-nfsd-v2-17-d93368f903bd@kernel.org>
In-Reply-To: <20260119-exportfs-nfsd-v2-17-d93368f903bd@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 19 Jan 2026 17:42:54 +0100
X-Gm-Features: AZwV_QiQ9eetgKyRnXUMiKJDXK2vIOYhTLzpDlKP7IN3cG_hSRVA59Z6sNZRsnw
Message-ID: <CAOQ4uxgXovX-rPuAE55D8x4jbNOQdAKJH3O5gpHJDMsT7kNGgw@mail.gmail.com>
Subject: Re: [PATCH v2 17/31] ovl: add EXPORT_OP_STABLE_HANDLES flag to export operations
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

On Mon, Jan 19, 2026 at 5:29=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Add the EXPORT_OP_STABLE_HANDLES flag to overlayfs export operations to
> indicate that this filesystem can be exported via NFS.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/export.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 83f80fdb156749e65a4ea0ab708cbff338dacdad..18c6aee9dd23bb450dadbe8ee=
f9360ea268241ff 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -865,6 +865,7 @@ const struct export_operations ovl_export_operations =
=3D {
>         .fh_to_parent   =3D ovl_fh_to_parent,
>         .get_name       =3D ovl_get_name,
>         .get_parent     =3D ovl_get_parent,
> +       .flags          =3D EXPORT_OP_STABLE_HANDLES,
>  };
>
>  /* encode_fh() encodes non-decodable file handles with nfs_export=3Doff =
*/
>
> --
> 2.52.0
>
