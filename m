Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587A0FBE8
	for <ocfs2-devel@lists.linux.dev>; Sat,  8 Jun 2024 04:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717820619; cv=none; b=aNNamrZJ+UaggYQsSLNyQMPJg3g+CyN4en7bh7XHKhP11Sv0KjE7JlcD6G6zd/vHvvFwJpPiuQipNx4QpVs7ZPDvkmSsvVdHZBWa7I+xI2p7ZxPZxc+9SpZHq8aY7sqYDScveIs1YE8JEeIdyYSKavE8vy78TN4hXmcJYEsNEhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717820619; c=relaxed/simple;
	bh=4V3vHwWtOBxLoGTU77db9xkyGvkTPwJPshkdVvROr0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KObNSUM+SojMAV7WOox8ZeiEUbXklU7KgljBRq1jKuAjKgozDFq4feDD4YCaB7FkSaiGLBEDF+6Xka5rU1lq/7hOxAEYw0GhE3p4SdNu1VQXYL7JsE818lVOXev4JU2zpiozPj1Tnt96hPNYdftwRtfIZd9vN5xMBys+Rd5nSLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iX7jL0I1; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iX7jL0I1"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-dfb12c0b4ceso57888276.3
        for <ocfs2-devel@lists.linux.dev>; Fri, 07 Jun 2024 21:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717820616; x=1718425416; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PwgxLawkloFDceeT+hiBETpfY3+zDZvEd5EoKj5YXU4=;
        b=iX7jL0I1kcp90Pebcn9wg3K9B+9fhwJDR6kKhlFcH1/qkVTOR8WpMFqN5EdCyGzbHU
         lZ+M15vXRH32foWg4v9Qv6AA/ygLkRv28wndCfMx+WJrET8XhLoeNYELf2AmXOaLt5gd
         1kvx8GBkXK+3FDGZGveyWexmVM1HWsFHxCyyix20UrQ5rc2tkvEicjoR0NVLE7Q9f5i6
         yhVYLEDVIGCLhwwS4Gafca6OgiFuV5qUBBcHqmEP5P+9eyde/exQJ5UrAbLK3IDWJqUF
         CpjRC3CZB3+5HdHUiK4S3Hi75R0jlCTdTgT38IfcSlbXypSy4DjIBVYZf3ZMuCYTMkM3
         J/IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717820616; x=1718425416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PwgxLawkloFDceeT+hiBETpfY3+zDZvEd5EoKj5YXU4=;
        b=R8SIqXqfP3Ux+2XwO2FRvA0kzBs703Nn68ql1dz+FYC7iOFVytSNy3/kJRNV10Kv0k
         x+uVacDkZP5S6OnOTQ8Gb3QqMMnEePRzjkOXHE2KU48pfE7KcMCk24CQ7I/nCJO7kOte
         ziYLvqFsCInn/08Dw+dFoISAkxkQVtSeOPUnUiKRRh7HV4mSkDunnER1Mb6KfDzwRDO+
         7T0Se16eDXu4ENlcDzwu/bArxDAD9fWguusOYQKDAjlD59U/YtGnBVv4APxaaafh/Jbe
         A3f0hwQdYWFpA30HpT4Ye37dh91HkbphNTu1Oimp50m5+cEoYJzerJO8haVUJF5yBFwY
         LZQg==
X-Gm-Message-State: AOJu0YxDZImNf/mmuYTLcJWxStIzxcIqml9dJNf3VHLtrkvPWUxlU4FT
	NFUQHeGieBEIYopb5kL61F+Y2a3ltZz4FFCNJpNBaxp9RkVa825+wdKijZmxBNj0+nJWmdGYSlY
	a9hx6ztTugFZhiPmbU2v8APYT8opOUb5LI/E/kQ==
X-Google-Smtp-Source: AGHT+IGViuIzX58C8noBaY+zAycSMSZTgS/JB3iWXvKaFvlwI0yl9STz8deWrl1nDHMjM9uSP8yowvkbl6LluNrAcAM=
X-Received: by 2002:a25:b43:0:b0:dfb:6ff:403e with SMTP id 3f1490d57ef6-dfb06ff419dmr2362962276.13.1717820616128;
 Fri, 07 Jun 2024 21:23:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606065455.94846-1-llfamsec@gmail.com> <046696eb-4e56-4190-8295-d77a8b5cb522@linux.alibaba.com>
In-Reply-To: <046696eb-4e56-4190-8295-d77a8b5cb522@linux.alibaba.com>
From: lei lu <llfamsec@gmail.com>
Date: Sat, 8 Jun 2024 12:23:09 +0800
Message-ID: <CAEBF3_bXhKw+CBsTQBonM3ZTSZB7hyTJiV6wrw7=3pieYT0DYg@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 8, 2024 at 9:41=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba.c=
om> wrote:
>
>
>
> On 6/6/24 2:54 PM, lei lu wrote:
> > This adds sanity checks for ocfs2_dir_entry to make sure all members of
> > ocfs2_dir_entry don't stray beyond valid memory region.
> >
> > Signed-off-by: lei lu <llfamsec@gmail.com>
> > ---
> >  fs/ocfs2/dir.c | 32 ++++++++++++++++++++------------
> >  1 file changed, 20 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> > index d620d4c53c6f..85966385d134 100644
> > --- a/fs/ocfs2/dir.c
> > +++ b/fs/ocfs2/dir.c
> > @@ -294,13 +294,14 @@ static void ocfs2_dx_dir_name_hash(struct inode *=
dir, const char *name, int len,
> >   * bh passed here can be an inode block or a dir data block, depending
> >   * on the inode inline data flag.
> >   */
> > -static int ocfs2_check_dir_entry(struct inode * dir,
> > -                              struct ocfs2_dir_entry * de,
> > -                              struct buffer_head * bh,
> > +static int ocfs2_check_dir_entry(struct inode *dir,
> > +                              struct ocfs2_dir_entry *de,
> > +                              struct buffer_head *bh, char *buf, unsig=
ned int size,
>
> Don't see why we have to pass 'buf' here.
> Seems it can be obtained from bh directly.

We can not simply obtained de from bh->b_data. Because in
ocfs2_search_dirblock, the beginning of bh->b_data is ocfs2_dinode
(found in caller ocfs2_find_entry_id). But in ocfs2_find_dir_space_el,
we can see "de =3D (struct ocfs2_dir_entry *) bh->b_data;", which means
the beginning of bh->b_data is de directly. I'm not sure what's
causing this difference.

>
> >                                unsigned long offset)
> >  {
> >       const char *error_msg =3D NULL;
> >       const int rlen =3D le16_to_cpu(de->rec_len);
> > +     const unsigned long next_offset =3D ((char *) de - buf) + rlen;
> >
> >       if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
> >               error_msg =3D "rec_len is smaller than minimal";
> > @@ -308,6 +309,11 @@ static int ocfs2_check_dir_entry(struct inode * di=
r,
> >               error_msg =3D "rec_len % 4 !=3D 0";
> >       else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
> >               error_msg =3D "rec_len is too small for name_len";
> > +     else if (unlikely(next_offset > size))
> > +             error_msg =3D "directory entry overrun";
> > +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
> > +              next_offset !=3D size)
>
> Seems we also have to consider meta ecc.

Sorry, I'm not very familiar with this.

>
> > +             error_msg =3D "directory entry too close to end";
> >       else if (unlikely(
> >                ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksi=
ze))
> >               error_msg =3D "directory entry across blocks";
> > @@ -352,16 +358,16 @@ static inline int ocfs2_search_dirblock(struct bu=
ffer_head *bh,
> >       de_buf =3D first_de;
> >       dlimit =3D de_buf + bytes;
> >
> > -     while (de_buf < dlimit) {
> > +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
> >               /* this code is executed quadratically often */
> >               /* do minimal checking `by hand' */
> >
> >               de =3D (struct ocfs2_dir_entry *) de_buf;
> >
> > -             if (de_buf + namelen <=3D dlimit &&
> > +             if (de->name + namelen <=3D dlimit &&
> >                   ocfs2_match(namelen, name, de)) {
> >                       /* found a match - just to be sure, do a full che=
ck */
> > -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset)) =
{
> > +                     if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, b=
ytes offset)) {
>
> It looks buggy, even cannot compile.
> Have you compiled and then verified with your POC?

I have compiled and tested it. And I got an output as below:
root@syzkaller:~# mount -o loop ocfs2-test.img /mnt/ocfs2-test
[  116.777184] loop0: detected capacity change from 0 to 40960
[  116.843546] (mount,232,0):ocfs2_init_global_system_inodes:461
ERROR: status =3D -22
[  116.843946] (mount,232,0):ocfs2_init_global_system_inodes:462
ERROR: Unable to load system inode ?
[  116.844001] (mount,232,0):ocfs2_init_global_system_inodes:472
ERROR: status =3D -22
[  116.844821] (mount,232,0):ocfs2_initialize_super:2251 ERROR: status =3D =
-22
[  116.845590] (mount,232,0):ocfs2_fill_super:1176 ERROR: status =3D -22
mount: /mnt/ocfs2-test: wrong fs type, bad option, bad superblock on
/dev/loop0, missing codepage or.

The ocfs2_check_dir_entry was not called because "de->name + namelen
<=3D dlimit && ocfs2_match(namelen, name, de)" was not meet. I think
"while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN)" has taken effect, and
we got an error elsewhere.

Thanks,
LL

>
> Thanks,
> Joseph
>
> >                               ret =3D -1;
> >                               goto bail;
> >                       }
> > @@ -1138,7 +1144,7 @@ static int __ocfs2_delete_entry(handle_t *handle,=
 struct inode *dir,
> >       pde =3D NULL;
> >       de =3D (struct ocfs2_dir_entry *) first_de;
> >       while (i < bytes) {
> > -             if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
> > +             if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes, =
i)) {
> >                       status =3D -EIO;
> >                       mlog_errno(status);
> >                       goto bail;
> > @@ -1635,7 +1641,7 @@ int __ocfs2_add_entry(handle_t *handle,
> >               /* These checks should've already been passed by the
> >                * prepare function, but I guess we can leave them
> >                * here anyway. */
> > -             if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
> > +             if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start=
, size, offset)) {
> >                       retval =3D -ENOENT;
> >                       goto bail;
> >               }
> > @@ -1774,7 +1780,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode =
*inode,
> >               }
> >
> >               de =3D (struct ocfs2_dir_entry *) (data->id_data + ctx->p=
os);
> > -             if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)) {
> > +             if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)data=
->id_data,
> > +                                        i_size_read(inode), ctx->pos))=
 {
> >                       /* On error, skip the f_pos to the end. */
> >                       ctx->pos =3D i_size_read(inode);
> >                       break;
> > @@ -1867,7 +1874,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode =
*inode,
> >               while (ctx->pos < i_size_read(inode)
> >                      && offset < sb->s_blocksize) {
> >                       de =3D (struct ocfs2_dir_entry *) (bh->b_data + o=
ffset);
> > -                     if (!ocfs2_check_dir_entry(inode, de, bh, offset)=
) {
> > +                     if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_d=
ata,
> > +                                                i_size_read(inode), of=
fset)) {
> >                               /* On error, skip the f_pos to the
> >                                  next block. */
> >                               ctx->pos =3D (ctx->pos | (sb->s_blocksize=
 - 1)) + 1;
> > @@ -3359,7 +3367,7 @@ static int ocfs2_find_dir_space_id(struct inode *=
dir, struct buffer_head *di_bh,
> >       while (de_buf < limit) {
> >               de =3D (struct ocfs2_dir_entry *)de_buf;
> >
> > -             if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
> > +             if (!ocfs2_check_dir_entry(dir, de, di_bh, de_buf, i_size=
_read(dir), offset)) {
> >                       ret =3D -ENOENT;
> >                       goto out;
> >               }
> > @@ -3441,7 +3449,7 @@ static int ocfs2_find_dir_space_el(struct inode *=
dir, const char *name,
> >                       /* move to next block */
> >                       de =3D (struct ocfs2_dir_entry *) bh->b_data;
> >               }
> > -             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> > +             if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, sb->s=
_blocksize, offset)) {
> >                       status =3D -ENOENT;
> >                       goto bail;
> >               }
