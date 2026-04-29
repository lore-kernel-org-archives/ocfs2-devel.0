Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20573A6404
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Apr 2026 08:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777450333; cv=pass; b=TUl5Styx7aFfHehjDWWyNuzjH3ezbbW/fFlIRsHVabMa+zvKATHYW3f+vEw5+MHA5RYdTyyPe34ovA1D9sMmtjJcl2EjAlhgrkB7mdwTW66cnTAqskqpfdK9vHGlOn0IuMsffU0jvEsq/23DqWe1sFGGM30pAa27g8hS5XxiM0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777450333; c=relaxed/simple;
	bh=taBZTJFooL7d/kgCuEbTQjLu7iqoPTOQ47AMps5lGjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SkHrVRjbRSGq5FSkghTsyG6Dk823cJJWxdiT+BNH7dwPdG/4twGVkS6sud316k5DEmjOc9f7cSVyolavF3haDdC9wO8BACJTexj9RpHYJXnRbatXH5vkaY75YLOGWJY5N7yRXX4F78SiTSieBM4868buxDyT6CLwDnEVABBhxDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fGhCGmRG; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fGhCGmRG"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-671d60ef9c6so17066725a12.2
        for <ocfs2-devel@lists.linux.dev>; Wed, 29 Apr 2026 01:12:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777450330; cv=none;
        d=google.com; s=arc-20240605;
        b=ex3U/QJEbwRxMJjv5XNOQYfECdwlPNDhGf/O1zGNyQBaMBq318iH40N+j4xymo2Km8
         aqoOaxEaHPuf//YYmyZcznT8DVcj4isqvXgfRpCKnempJW8c/IxpPBsD+KOTTZVI00dz
         blo11CX+8GAmxEa5HATpU4m/rvCWSVTvepVMu8/t0Enbeu3Ygm1hxBEevinlR9GPfzwV
         brlYoEU7OLAk2yV//4UGW52qauRDMBmF/jenBDdJ9X9d1Y16z47Ccyuksa9n7ieBkle9
         9oAvewgkqv4YW1l9HK8gqj8gNiHmF4FjJENTsoc9Vm282KnXglhdNWlViwRLmSVZPlH5
         TTkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y3XAZpqIfdfw2WeLM58+L03LNTauZvqYuYw2l15p2B0=;
        fh=REz2W7PSFA0zMLVjnpBw7ujEUO3+YPGm2Nf5VbwLQSY=;
        b=eYfkM/QJlL3IYeRSL5DK5vBeqEr4M86NPB3DS7iC3QVxD2Yi7pEur8NrFP+Gnh/IY8
         blGX//GqP4msMhwvdok/LRyaCvnnUx1mHBuwbI7Qzv3CDmdNbtkE4ZkKxNiLl1Y0EEAn
         9fonLF8LQuQO5vB6JQFNRC6uGDH8PfgMy0WfedlOfAhuzPm5Fai6LTQxF9K+UnrhiRG2
         yrxOqOcCPx4S6oFCF52uZ9vSGI7r1WTeWugog4hR+tumqAIy/IfzsebK3ynP8mYTbd6Q
         rwlsLdnKHLnth9bq8x7D63l3SrODtydjk5iY/pcLSRh4nqEUaWk/DSNra/7uBVxc0vOL
         6Pjg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777450330; x=1778055130; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3XAZpqIfdfw2WeLM58+L03LNTauZvqYuYw2l15p2B0=;
        b=fGhCGmRGfSsffTKNm9uS3sxku23e3uHGQqRxQ3c4ZmboGufmz3RyNqglSkeboCs/l5
         WZ8k2XGrdzmVUkyNTAAkZv2dHNIFvavkIcixpzG38+Qbq0FfQa2szaH55GwBKyAU/k86
         oypdnujFGDrsRY+QcRyo4BS1/r6MkPghZq+0BUZ1LYeQG6E+3d8sj8drbaDTeasB5CDP
         InGMT4CSn6siqdH4q3R7+cz7UGclsRtG6IBLZ2ZKRuzO1rapnKD9e+nDrxbJX+Sn9KwG
         8Ru9fhseiKIz8VlQoGZVVCEvRQMQbhUXVvvNyJGnTsj7yEomwHhzmXZH5xeX7MpsxEDj
         QO3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777450330; x=1778055130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y3XAZpqIfdfw2WeLM58+L03LNTauZvqYuYw2l15p2B0=;
        b=kmxTXRmZpJiz4cI54xm8H/+2Bw3xEIZCPFbQq12lR61vA3SkkQKMT8QI8N5rrez4JH
         8sOTHzJNuFAyMoZetFF9dBGPY9qdi2FG7E/40KYOA6nKv7v+qGnlA3CBubxdHOO0Zo4v
         2LjQNwGxgpZoZsNU7I3r07s5cMiR7SSkAxNLmL8QVc3LtXL8ur04wc0oPZmZdosqxoV/
         PfZQacdL2190v0HDVz/tbrrfZR5MW+O8gBE7c0mBFN193zGqeJrFuWs+S53j7NnX0u7i
         EMEAI+ikfetlUrvPadbQ79ll1dnTYERvEl/QOVJOB+OPlkVhZZCfGWUniQzahY97cb/I
         dhRw==
X-Gm-Message-State: AOJu0YzCFA6QVMcK5hvCJ62Py4xgS1eUnY07hVXZ5oVB7V9GxH7S3DGQ
	QNpZcHTjICMmnRqaDlpF8YInMG4NweyrjsPVPLVNC5+KnK8sL7gC2rP2WfKW5uCAG0M3QHEzOOR
	gGrBYLTKqnsufyrfi1N9010jRRC829OM=
X-Gm-Gg: AeBDiet6EIO9mQf/FqB7aHmMMGpgQPAtWcG9G8MJqgppeFfqPpNM2E++HWtD4yD0T/7
	NzMqbu3BLBt5jAqvR+fke0OM1q5+10V/d5gj/KWCtSFywnJJMc/LKWZ0+3RnzpFP0FaDlKyvNlg
	ZgATah2Ls64iRosZIRh+XFB1huJBrcnawfNlJ8rZxw4vDlA/Q2O0PY9kHClJ9EMa7gfAx0zYgFz
	30psZ18oxd9eKw8R5kI12LIS21XCigOKZnePT+6aGi/GSf5AzYrRni4JzdCHHPoJaU/stzBJuqy
	AJTJXx6ln7EfujxfoKmU1AsD8M5Dv8cS52jimQt+/g7hkRCJ/9JVe4tC/GV3NMcyDw==
X-Received: by 2002:aa7:d490:0:b0:678:87d5:de0e with SMTP id
 4fb4d7f45d1cf-67b1fe1bc1cmr1168975a12.23.1777450329729; Wed, 29 Apr 2026
 01:12:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260429024434.1472685-1-gality369@gmail.com>
In-Reply-To: <20260429024434.1472685-1-gality369@gmail.com>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Wed, 29 Apr 2026 16:11:42 +0800
X-Gm-Features: AVHnY4IINtj_8ZBJKBpZCxCp7BVk_dcSwp80xikvQXbGrTulN6lwIsdDoS6GEUo
Message-ID: <CAOmEq9ULZ3H5So+4vku2Zu3B8Mgt9kp-Vck_g66KOjWTAzv0VA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate inline xattr header before listxattr
 walks it
To: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 10:44=E2=80=AFAM ZhengYuan Huang <gality369@gmail.c=
om> wrote:
>
> [BUG]
> listxattr() can walk off the end of a dinode block when the inode-body
> xattr header is corrupted:
>
> BUG: KASAN: use-after-free in ocfs2_xattr_list_entry+0x1bd/0x370 fs/ocfs2=
/xattr.c:918
> Read of size 13 at addr ffff88800ab5c0c0 by task syz.0.1231/3756
>
> Call Trace:
>  ...
>  ocfs2_xattr_list_entry+0x1bd/0x370 fs/ocfs2/xattr.c:918
>  ocfs2_xattr_list_entries+0x1e1/0x320 fs/ocfs2/xattr.c:938
>  ocfs2_xattr_ibody_list fs/ocfs2/xattr.c:982 [inline]
>  ocfs2_listxattr+0x4fb/0x980 fs/ocfs2/xattr.c:1044
>  vfs_listxattr+0xb4/0x120 fs/xattr.c:493
>  listxattr+0x76/0x170 fs/xattr.c:924
>  filename_listxattr fs/xattr.c:958 [inline]
>  path_listxattrat+0x137/0x320 fs/xattr.c:988
>  __do_sys_listxattr fs/xattr.c:1001 [inline]
>  ...
>
> [CAUSE]
> ocfs2_xattr_ibody_list() computes the inline xattr header from
> di->i_xattr_inline_size and passes it straight to
> ocfs2_xattr_list_entries(). If corruption inflates xh_count, the list
> walk steps past the inline xattr area and eventually past the end of the
> 4K dinode block. The xe_type load in ocfs2_xattr_get_type() then reads
> poisoned memory.
>
> [FIX]
> Validate di->i_xattr_inline_size before locating the header, then bound
> xh_count by the number of ocfs2_xattr_entry records that fit inside the
> claimed inline area. Reject corrupted metadata with ocfs2_error() and
> -EFSCORRUPTED instead of iterating past the dinode block.
>
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>  fs/ocfs2/xattr.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@
>  static int ocfs2_xattr_ibody_list(struct inode *inode,
>                                   struct ocfs2_dinode *di,
>                                   char *buffer,
>                                   size_t buffer_size)
>  {
>         struct ocfs2_xattr_header *header =3D NULL;
>         struct ocfs2_inode_info *oi =3D OCFS2_I(inode);
>         int ret =3D 0;
> +       u16 xattr_count;
> +       size_t max_entries;
> +       u16 inline_size;
>
>         if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
>                 return ret;
>
> +       inline_size =3D le16_to_cpu(di->i_xattr_inline_size);
> +
> +       if (inline_size > inode->i_sb->s_blocksize ||
> +           inline_size < sizeof(struct ocfs2_xattr_header)) {
> +               ocfs2_error(inode->i_sb,
> +                           "Invalid xattr inline size %u in inode %llu\n=
",
> +                           inline_size,
> +                           (unsigned long long)OCFS2_I(inode)->ip_blkno)=
;
> +               return -EFSCORRUPTED;
> +       }
> +
>         header =3D (struct ocfs2_xattr_header *)
>                  ((void *)di + inode->i_sb->s_blocksize -
> -                le16_to_cpu(di->i_xattr_inline_size));
> +                inline_size);
> +
> +       xattr_count =3D le16_to_cpu(header->xh_count);
> +       max_entries =3D (inline_size - sizeof(struct ocfs2_xattr_header))=
 /
> +                     sizeof(struct ocfs2_xattr_entry);
> +       if (xattr_count > max_entries) {
> +               ocfs2_error(inode->i_sb,
> +                           "Invalid xattr entry count %u (max %zu) in in=
ode %llu\n",
> +                           xattr_count, max_entries,
> +                           (unsigned long long)OCFS2_I(inode)->ip_blkno)=
;
> +               return -EFSCORRUPTED;
> +       }
>
>         ret =3D ocfs2_xattr_list_entries(inode, header, buffer, buffer_si=
ze);
>
>         return ret;
>  }
> --
> 2.43.0

This bug has already been fixed by commit 2a4f33430e96. Sorry for the noise=
.

Thanks,
ZhengYuan Huang
