Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com [209.85.208.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3696B361DAB
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 May 2026 03:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.194
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779765473; cv=pass; b=SGsRp/E9RkWokjHC36Apr0977I6WQFyG7+uBifjII39w9Ll4Uwkr99E4B0+DqHsh2gyt7M3cfPVrmzWZW/is8YIC2BqXxn+xYZER5HE8v7+iOZj6OjWG6BkfP5Lpv3wPQiX8BhKkwjobbPS49+r2+W2DUY+/Huv9zau3uSGj0FI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779765473; c=relaxed/simple;
	bh=72ZpGQ/zivMKVwoERhF+waMScTr5PItGedz3LqwO6Ag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mI8q6cCFaAbBC6d7h8kNaCAueeUG/6Sb+gFGgVIeF44f/k5PUvbImnGpw1HDI1ERsatBjMFQFVD6zW7h5UNA80UtkYwoAUTHl+Qz4xybtT5vpPsWyfLU0se2seC2DIs536SyP9e7eoy5G+FvX0VrWp1RDtZziCg9UAsBKFz5EBE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=smNHnM4V; arc=pass smtp.client-ip=209.85.208.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="smNHnM4V"
Received: by mail-lj1-f194.google.com with SMTP id 38308e7fff4ca-38e84ed22bdso114705181fa.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 20:17:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779765469; cv=none;
        d=google.com; s=arc-20240605;
        b=YCQeSdmCBQ6d+dr5dkq24qfYzGNadRTjPrNyc+a+chyulxIG8G69jI7pDJHWHq+819
         NgRTFWbb9er2BzbgQl0i8vZuuDm1hXOjLrFLMWAMenhIRfvzhaQyB3wJf0i2p27TnTvz
         QX+Cy1kDAt5Geh3E5H3MlTQREX82nIEOkDrC6QCvys1OBjbRRPQfVPL0XRC+IJQi9l7/
         ktCQ4OAfZHZ+DR+lgOi4L1ZwfZWzEgnRzG6nHb9YveU8S258Tu6uz6G3W6SP/HfO/qDE
         jL/mr0bFzbM+ojLzP4J/4TSbg/HPxa/bHwimxJfbcQPFrDp1WTDuFns0G4cKpjq3RMfN
         EABw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iDb6/fXrj+D38B1jEl6PjYFxLiKzc3rFv1o8t6ePGjQ=;
        fh=03m5+eNLbtApDDs/duJGc/Fv/6ndu0DyInaK//2Ww8I=;
        b=EAuhZcbL+8HXhBz5ZRczW1LO2TZhGSCiuK9aIYtKBUY1kmoh0hRdAmsZ4QRnWeLbti
         Em4TfOXTWIqTeEkjdvRHAK2rEY/u+iHVtSAIIL1a6rrJX96OEwCqzauiVmrNFTrKFK2P
         aLU+1SCcuQLXrhHK2x9yd4NuE87flkRUZea5+Wh4h/M+UPcgyR2sQPDXswLqnt5Pslfx
         JpvCmKgPYPRMP5z9M/QE4h1fqDRrNTK5q30Yz8eV7oJlFLFa18QDuaS9o0wsOcyICEhO
         MM6FFno8maaceYk+JnErLgYwQKdXM8ZXvzShlqOJCAbEjLqVp/WDq2tluLxNDOjZCtgI
         R+xA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779765469; x=1780370269; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iDb6/fXrj+D38B1jEl6PjYFxLiKzc3rFv1o8t6ePGjQ=;
        b=smNHnM4VuxpyngGC9RA+OpzcYZ4l8qDtgQbS5Hv6zz7bbvljLP4rYNOXQ5dIvFqSSN
         +3DaR902kvNWuVsW/Aifc7lmROCI/toyVL9/tRIMdJ2xyOyh/43eeschd5dBiTsd23ew
         PbV4yHO796Hiwt6SlylxCtjUVfcZkNFkmvDhu6BiWAsEdExmyg9DzN0AEw140MWiwXCD
         BYwzdus7xBBfqoGBjIsna7MMzmVRgeaJ9LRhijtt0Oprq2xe4FQ5Msr5GapB/O3ra7ER
         W2LNqy0jQk+9xiiJRIIPzrYmzdiF3n/0XS814VA2HShdeOb1PNMQCL7L2JFBLeiq4zg2
         E8eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779765469; x=1780370269;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iDb6/fXrj+D38B1jEl6PjYFxLiKzc3rFv1o8t6ePGjQ=;
        b=d9FHepSCigB5urg7K5iD3edoO8eot7EMU//pIDAJJR6Jo7ZhlZiOPYqY279vC+8CjI
         Uh7QWBDIfNKZj3poQ2XrqsNHfQInvqLQ5NQVUWPfTXIUhomo3FtQh95bTCa5taefp0VT
         d5IBQ2SQE56P7fqnO5aOsbEDvpkewfnejWy5Z0d/iowHxLUiEQ6+GKlBg/zLgENLS3X1
         zKEmHJ+8GhqMwgiGmpUjIrPHBt70ngoWb94xQhB3kBCtP7JzjeREMTUoEXP8YgYzI8rM
         J4s+MYukI8aYyAbT+KyHOfzhHIyZ2V6HB0tMYfU0x6xUddQgnkFgO2CAwdT3xD4BU/jJ
         4Nyw==
X-Gm-Message-State: AOJu0YzUGEieZSO1bDWlYTW1hw8q4d/gFCxlZNJoAQKCzaF0hUWjZK7w
	7bJq3rXOUGP0uq4+IPyrDOUHj78b4qVgOBhzh9cvBhna00cQpztxav2ZjFCVB0nw6Jmgdkhcb2K
	wG2MtH88Ugdf2cCgcof2QsHFiC80EeEU=
X-Gm-Gg: Acq92OF9rn8UkcfmisEwtcZAa2TEfVqpo/H+9MLUOjAzoiGlLIqcczyyc3MGhClDypY
	a2r4KMxJZ6VtyYxoCxyn4S4ouVQjAr1cMhQZbKFJic8NqoPwJe8yj36SYjd7DD9/btV66PrL1pE
	R6XBsY8CAKcp86+xW2f+mvSA+oMZkUPMJDZTbTtV6dp4mGtuum+J5FgV6NMgt+pfAHqbKUCTV6w
	zp9Tf4GyDx3KvxiIKaDT7+pupEjcm4yWbrf+8VcYh7C8J0kiEGPLX5Rw2K7UTUNl+84BR664HVx
	wgvb12khkw7D+buE0zBa
X-Received: by 2002:a05:651c:222c:b0:393:a4f5:3e0f with SMTP id
 38308e7fff4ca-395d8c35f3fmr55110571fa.2.1779765469033; Mon, 25 May 2026
 20:17:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260526030409.3506805-1-rollkingzzc@gmail.com>
In-Reply-To: <20260526030409.3506805-1-rollkingzzc@gmail.com>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Tue, 26 May 2026 11:17:37 +0800
X-Gm-Features: AVHnY4KjxVZdc8tQV73tkV7u520to_XxEbNQcunLuFZXJh4zwBuKZIuriS5yOjM
Message-ID: <CAB7XQsEjwRQgoxGjfEt2DJCDzPJip5zWv=f3aVzLqaRgw=0yvw@mail.gmail.com>
Subject: Re: [PATCH 0/2] ocfs2: validate xattr metadata bounds
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, zerocling0077@gmail.com, 2045gemini@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Sorry, I noticed that the patch series I sent has some formatting
issues. This is my first time sending a patch series, and I made a
mistake.

Please disregard this version. I will fix the formatting and resend it
properly.

Sorry for the noise.

Best regards,
Zhang Cen

Zhang Cen <rollkingzzc@gmail.com> =E4=BA=8E2026=E5=B9=B45=E6=9C=8826=E6=97=
=A5=E5=91=A8=E4=BA=8C 11:04=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>
> This small series rejects corrupted OCFS2 xattr metadata before the
> getxattr and listxattr paths walk filesystem-controlled inline, external
> block, or indexed bucket storage.
>
> Patch 1 validates the inline xattr header placement and entry count
> before ocfs2_xattr_ibody_get() parses it. Patch 2 builds on that helper
> and validates listxattr entry counts and name ranges against the storage
> that backs each walk.
>
> Both issues were reproduced with crafted OCFS2 images under KASAN.
>
> Zhang Cen (2):
>   ocfs2: validate inline xattr metadata in ocfs2_xattr_ibody_get
>   ocfs2: validate listxattr entry bounds
>
>  fs/ocfs2/xattr.c | 122 +++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 101 insertions(+), 21 deletions(-)
>
> --
> 2.43.0
>
> From 89ea62caaac9486558bf9cb933975d276a3e67c8 Mon Sep 17 00:00:00 2001
> From: Zhang Cen <rollkingzzc@gmail.com>
> Date: Sun, 24 May 2026 14:34:49 +0800
> Subject: [PATCH 1/2] ocfs2: validate inline xattr metadata in
>  ocfs2_xattr_ibody_get
>
> ocfs2_xattr_ibody_get() derives xs->header from
> di->i_xattr_inline_size and then immediately hands that header to
> ocfs2_xattr_find_entry(). If a corrupted inode advertises a zero,
> too-small, or too-large inline xattr size, the get path can place the
> header at the end of the inode block or outside it before reading
> xh_count and walking entries.
>
> Reuse the inline xattr size and xh_count validation that the list path
> already relies on before parsing the in-inode header on the get path.
> Reject corrupted inline metadata with -EFSCORRUPTED instead of walking
> past the inline area.
>
> A crafted image can otherwise trigger:
> BUG: KASAN: use-after-free in ocfs2_xattr_find_entry+0x5a/0x170
>
> Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> ---
>  fs/ocfs2/xattr.c | 51 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 32 insertions(+), 19 deletions(-)
>
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 86cfd4c2adf9..eabfaa02d8b8 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -967,24 +967,17 @@ int ocfs2_has_inline_xattr_value_outside(struct ino=
de *inode,
>         return 0;
>  }
>
> -static int ocfs2_xattr_ibody_list(struct inode *inode,
> -                                 struct ocfs2_dinode *di,
> -                                 char *buffer,
> -                                 size_t buffer_size)
> +static int ocfs2_xattr_check_inline_xh(struct inode *inode,
> +                                      struct ocfs2_dinode *di,
> +                                      struct ocfs2_xattr_header **header=
)
>  {
> -       struct ocfs2_xattr_header *header =3D NULL;
> -       struct ocfs2_inode_info *oi =3D OCFS2_I(inode);
> -       int ret =3D 0;
> -       u16 xattr_count;
> +       struct ocfs2_xattr_header *xh;
>         size_t max_entries;
>         u16 inline_size;
> -
> -       if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
> -               return ret;
> +       u16 xattr_count;
>
>         inline_size =3D le16_to_cpu(di->i_xattr_inline_size);
>
> -       /* Validate inline size is reasonable */
>         if (inline_size > inode->i_sb->s_blocksize ||
>             inline_size < sizeof(struct ocfs2_xattr_header)) {
>                 ocfs2_error(inode->i_sb,
> @@ -994,12 +987,11 @@ static int ocfs2_xattr_ibody_list(struct inode *ino=
de,
>                 return -EFSCORRUPTED;
>         }
>
> -       header =3D (struct ocfs2_xattr_header *)
> -                ((void *)di + inode->i_sb->s_blocksize - inline_size);
> -
> -       xattr_count =3D le16_to_cpu(header->xh_count);
> +       xh =3D (struct ocfs2_xattr_header *)
> +               ((void *)di + inode->i_sb->s_blocksize - inline_size);
> +       xattr_count =3D le16_to_cpu(xh->xh_count);
>         max_entries =3D (inline_size - sizeof(struct ocfs2_xattr_header))=
 /
> -                      sizeof(struct ocfs2_xattr_entry);
> +                     sizeof(struct ocfs2_xattr_entry);
>
>         if (xattr_count > max_entries) {
>                 ocfs2_error(inode->i_sb,
> @@ -1009,6 +1001,26 @@ static int ocfs2_xattr_ibody_list(struct inode *in=
ode,
>                 return -EFSCORRUPTED;
>         }
>
> +       *header =3D xh;
> +       return 0;
> +}
> +
> +static int ocfs2_xattr_ibody_list(struct inode *inode,
> +                                 struct ocfs2_dinode *di,
> +                                 char *buffer,
> +                                 size_t buffer_size)
> +{
> +       struct ocfs2_xattr_header *header =3D NULL;
> +       struct ocfs2_inode_info *oi =3D OCFS2_I(inode);
> +       int ret =3D 0;
> +
> +       if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
> +               return ret;
> +
> +       ret =3D ocfs2_xattr_check_inline_xh(inode, di, &header);
> +       if (ret)
> +               return ret;
> +
>         ret =3D ocfs2_xattr_list_entries(inode, header, buffer, buffer_si=
ze);
>
>         return ret;
> @@ -1200,8 +1212,9 @@ static int ocfs2_xattr_ibody_get(struct inode *inod=
e,
>                 return -ENODATA;
>
>         xs->end =3D (void *)di + inode->i_sb->s_blocksize;
> -       xs->header =3D (struct ocfs2_xattr_header *)
> -                       (xs->end - le16_to_cpu(di->i_xattr_inline_size));
> +       ret =3D ocfs2_xattr_check_inline_xh(inode, di, &xs->header);
> +       if (ret)
> +               return ret;
>         xs->base =3D (void *)xs->header;
>         xs->here =3D xs->header->xh_entries;
>
> --
> 2.43.0
>
>
> From 1ff5a1fde2b2ed5cfacf6c2205bb2f139795aa68 Mon Sep 17 00:00:00 2001
> From: Zhang Cen <rollkingzzc@gmail.com>
> Date: Tue, 26 May 2026 10:56:57 +0800
> Subject: [PATCH 2/2] ocfs2: validate listxattr entry bounds
>
> listxattr() trusts xh_count and the on-disk name offsets in the xattr
> storage it walks. A corrupted inline xattr area, non-indexed xattr block
> or indexed bucket can therefore push the walk past the entry array or
> make it read name bytes from outside the local xattr storage.
>
> Validate the entry count against the storage that actually backs the
> walk before iterating it, and reject names that extend past that local
> storage. For non-indexed external xattr blocks, use the bytes from
> xb_attrs.xb_header to the end of the block, so the count check matches
> the real xattr storage. For indexed buckets, validate xh_count against
> the full 4K bucket storage and reject names that select an invalid
> bucket block or cross the end of that block before bucket_block() is
> used.
>
> This makes listxattr() fail with -EFSCORRUPTED instead of walking
> corrupted xattr metadata.
>
> Validation reproduced this kernel report:
> KASAN use-after-free in ocfs2_xattr_list_entries+0xd7/0x190
> RIP: 0033:0x42086b
> Read of size 1
> Call trace:
>   dump_stack_lvl+0x66/0xa0 (?:?)
>   print_report+0xce/0x630 (?:?)
>   ocfs2_xattr_list_entries+0xd7/0x190 (fs/ocfs2/xattr.c:937)
>   srso_alias_return_thunk+0x5/0xfbef5 (?:?)
>   __virt_addr_valid+0x19f/0x330 (?:?)
>   kasan_report+0xe0/0x110 (?:?)
>   ocfs2_listxattr+0x3f6/0x610 (fs/ocfs2/xattr.c:1050)
>   vfs_listxattr+0x4c/0xa0 (?:?)
>   listxattr+0x90/0xe0 (?:?)
>   path_listxattrat+0xed/0x220 (?:?)
>   do_user_addr_fault+0x65a/0x890 (?:?)
>   do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)
>
> Fixes: cf1d6c763fbc ("ocfs2: Add extended attribute support")
> Fixes: 0c044f0b24b9 ("ocfs2: Add xattr bucket iteration for large numbers=
 of EAs")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> ---
>  fs/ocfs2/xattr.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 69 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index eabfaa02d8b8..66f5f9da2b3c 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -925,14 +925,54 @@ static int ocfs2_xattr_list_entry(struct super_bloc=
k *sb,
>         return 0;
>  }
>
> +static int ocfs2_xattr_list_corrupted(struct inode *inode)
> +{
> +       ocfs2_error(inode->i_sb, "corrupted xattr entries in inode %llu",
> +                   (unsigned long long)OCFS2_I(inode)->ip_blkno);
> +       return -EFSCORRUPTED;
> +}
> +
> +static int ocfs2_validate_xattr_list_entries(struct inode *inode,
> +                                            struct ocfs2_xattr_header *h=
eader,
> +                                            size_t storage_size)
> +{
> +       u16 xattr_count =3D le16_to_cpu(header->xh_count);
> +       size_t max_entries;
> +       int i;
> +
> +       if (storage_size < sizeof(*header))
> +               return ocfs2_xattr_list_corrupted(inode);
> +
> +       max_entries =3D (storage_size - sizeof(*header)) /
> +                     sizeof(struct ocfs2_xattr_entry);
> +       if (xattr_count > max_entries)
> +               return ocfs2_xattr_list_corrupted(inode);
> +
> +       for (i =3D 0; i < xattr_count; i++) {
> +               struct ocfs2_xattr_entry *entry =3D &header->xh_entries[i=
];
> +               size_t name_offset =3D le16_to_cpu(entry->xe_name_offset)=
;
> +
> +               if (name_offset > storage_size ||
> +                   entry->xe_name_len > storage_size - name_offset)
> +                       return ocfs2_xattr_list_corrupted(inode);
> +       }
> +
> +       return 0;
> +}
> +
>  static int ocfs2_xattr_list_entries(struct inode *inode,
>                                     struct ocfs2_xattr_header *header,
> +                                   size_t storage_size,
>                                     char *buffer, size_t buffer_size)
>  {
>         size_t result =3D 0;
>         int i, type, ret;
>         const char *name;
>
> +       ret =3D ocfs2_validate_xattr_list_entries(inode, header, storage_=
size);
> +       if (ret)
> +               return ret;
> +
>         for (i =3D 0 ; i < le16_to_cpu(header->xh_count); i++) {
>                 struct ocfs2_xattr_entry *entry =3D &header->xh_entries[i=
];
>                 type =3D ocfs2_xattr_get_type(entry);
> @@ -1013,15 +1053,18 @@ static int ocfs2_xattr_ibody_list(struct inode *i=
node,
>         struct ocfs2_xattr_header *header =3D NULL;
>         struct ocfs2_inode_info *oi =3D OCFS2_I(inode);
>         int ret =3D 0;
> +       u16 inline_size;
>
>         if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
>                 return ret;
>
> +       inline_size =3D le16_to_cpu(di->i_xattr_inline_size);
>         ret =3D ocfs2_xattr_check_inline_xh(inode, di, &header);
>         if (ret)
>                 return ret;
>
> -       ret =3D ocfs2_xattr_list_entries(inode, header, buffer, buffer_si=
ze);
> +       ret =3D ocfs2_xattr_list_entries(inode, header, inline_size,
> +                                      buffer, buffer_size);
>
>         return ret;
>  }
> @@ -1033,6 +1076,7 @@ static int ocfs2_xattr_block_list(struct inode *ino=
de,
>  {
>         struct buffer_head *blk_bh =3D NULL;
>         struct ocfs2_xattr_block *xb;
> +       size_t storage_size;
>         int ret =3D 0;
>
>         if (!di->i_xattr_loc)
> @@ -1048,7 +1092,10 @@ static int ocfs2_xattr_block_list(struct inode *in=
ode,
>         xb =3D (struct ocfs2_xattr_block *)blk_bh->b_data;
>         if (!(le16_to_cpu(xb->xb_flags) & OCFS2_XATTR_INDEXED)) {
>                 struct ocfs2_xattr_header *header =3D &xb->xb_attrs.xb_he=
ader;
> +               storage_size =3D blk_bh->b_size -
> +                       offsetof(struct ocfs2_xattr_block, xb_attrs.xb_he=
ader);
>                 ret =3D ocfs2_xattr_list_entries(inode, header,
> +                                              storage_size,
>                                                buffer, buffer_size);
>         } else
>                 ret =3D ocfs2_xattr_tree_list_index_block(inode, blk_bh,
> @@ -4096,8 +4143,28 @@ static int ocfs2_list_xattr_bucket(struct inode *i=
node,
>         struct ocfs2_xattr_tree_list *xl =3D (struct ocfs2_xattr_tree_lis=
t *)para;
>         int i, block_off, new_offset;
>         const char *name;
> +       size_t blocksize =3D inode->i_sb->s_blocksize;
> +       u16 xattr_count =3D le16_to_cpu(bucket_xh(bucket)->xh_count);
> +       size_t max_entries;
> +
> +       max_entries =3D (OCFS2_XATTR_BUCKET_SIZE -
> +                      sizeof(struct ocfs2_xattr_header)) /
> +                     sizeof(struct ocfs2_xattr_entry);
> +       if (xattr_count > max_entries)
> +               return ocfs2_xattr_list_corrupted(inode);
> +
> +       for (i =3D 0; i < xattr_count; i++) {
> +               struct ocfs2_xattr_entry *entry =3D &bucket_xh(bucket)->x=
h_entries[i];
> +               size_t name_offset =3D le16_to_cpu(entry->xe_name_offset)=
;
> +
> +               block_off =3D name_offset >> inode->i_sb->s_blocksize_bit=
s;
> +               new_offset =3D name_offset % blocksize;
> +               if (block_off >=3D bucket->bu_blocks ||
> +                   entry->xe_name_len > blocksize - new_offset)
> +                       return ocfs2_xattr_list_corrupted(inode);
> +       }
>
> -       for (i =3D 0 ; i < le16_to_cpu(bucket_xh(bucket)->xh_count); i++)=
 {
> +       for (i =3D 0 ; i < xattr_count; i++) {
>                 struct ocfs2_xattr_entry *entry =3D &bucket_xh(bucket)->x=
h_entries[i];
>                 type =3D ocfs2_xattr_get_type(entry);
>
> --
> 2.43.0
