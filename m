Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E90C3D68
	for <ocfs2-devel@lists.linux.dev>; Sat,  8 Jun 2024 04:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717821402; cv=none; b=gfYHiz/UWGBowzKC+Mnwo4BRgl88w/yviOCkEgzQxLT98vw1q2aqzY1cbxaQ3ib0FdnBlXEa6jda1J6l3Pygk86AJ/HwzU1MDDrUf7sXhuUqcNIzzly0k/+J1kOx9eFxU1moOBr9LfIkowhKWdOZeqOunzk7psZ6iw+ofE9KvSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717821402; c=relaxed/simple;
	bh=eIwPsclUtm4yVqGTYCMdBtDpHn8WHi9zF/E3HDII8yA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i/QhncFzyrPNkaTI65MGjb36UMar0YPMjXzkxidSYxgU/zFpCSp9EGIKjImVEiHbO3h5iP9l7SLXtAtWvMj9hUa9cHc6yOthp8HYz+6yoJStLKAPOaZuPWEYl8CrC8AXHk3rdSKNoUaYpFaCtijcFmilU/TwrmufiA9K2PCj12I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NhtwuICy; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NhtwuICy"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-df771959b5bso2858025276.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 07 Jun 2024 21:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717821400; x=1718426200; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EAk9ZqJq6i5QIuPqv9Y7bK2fM20zbdTVUZu55oqTnh4=;
        b=NhtwuICyKGhD/c6G318RMUwmXqwKV9q/HE8QCW9Vbt/6ABmm4rRHlnPWxezUCZHfKi
         Lauge6A+WfSG8AU21Na4XdG0A5AzfMFZqMF0nRkoL0mQ7XeSfK9/b70jYVjeycZ3hDVd
         alBcYg6ZlMo3/dyte6kbIZRpTa4HOQ/3HI3dWjVKl9PthERL8318u4a+clhC9/IVybRV
         VWc2TKl54/eeH3wx1d1+mF3zUFz6w6pZWuokBJTDUnFKoOHSxSWc3Y55JurIPVpPF9TD
         SohA6sMeQADZuA25i0kZReep8aKMw+SuLnpiwPuvuBq5vkAd1I8+fa4d4a5bNweSKgWq
         C2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717821400; x=1718426200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EAk9ZqJq6i5QIuPqv9Y7bK2fM20zbdTVUZu55oqTnh4=;
        b=ZkXnix5GgoYRqsQB+jThnm8X2WFDt+ZPm4bOZoZfRlHV4DzIE+xPHe67mfFjf7IF64
         ScjrdAVd5U/PycqBo18+42BxLmX8EJ4lNl+oD3Gcx04OQSaBohJUT8g65fxqzwCGFSmo
         hfD7EY9rG6kNcGdDNVqQ+Pi0IWZG5ltmpr6R5slt+3Le7DaqeHWli5gsyXhrkkjrnC+k
         QqOfzG3R/QkxuZ+cgypOSEk47YR/SWo5keX6bwe9LUGSPx8GVRjTLnFNgyXscVlTJPIo
         oGJKW9XpskmX1OlLnJp6X4k83Sgls29zEOMsh15G306bIZudbLbjy40cceQJ2BQ+yCXC
         4A1w==
X-Gm-Message-State: AOJu0YxisVmYsJrCBConxIsqhZRunsb6vJ0B3aNzaVeqMUvV4QS7vfBB
	4TjKAZKWkfiXgVsJXnDd6BgBCm/H4dRNt+I2Uk1Vb74gClZyreHifcCEGbS1K4cpY3cQtr5D22O
	xpP5s3UVXnyxSAw+bs06Q/RQzjND1ASooRzB4Rw==
X-Google-Smtp-Source: AGHT+IHELSatnUhDLvBQxglKPfEf59c2obJuems+EghHdfEX2GPHKolwqjWx6mbIOJRNf6wq0c8P0VWPn9q+/dGRjFM=
X-Received: by 2002:a25:6c82:0:b0:dfa:b28e:f637 with SMTP id
 3f1490d57ef6-dfaf670b6b9mr4057468276.56.1717821400031; Fri, 07 Jun 2024
 21:36:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606065455.94846-1-llfamsec@gmail.com> <046696eb-4e56-4190-8295-d77a8b5cb522@linux.alibaba.com>
In-Reply-To: <046696eb-4e56-4190-8295-d77a8b5cb522@linux.alibaba.com>
From: lei lu <llfamsec@gmail.com>
Date: Sat, 8 Jun 2024 12:36:29 +0800
Message-ID: <CAEBF3_Y8-x=EEzPAf4WayD3q2fZ8QGN+NP=CMKt9QMZC1vW8bA@mail.gmail.com>
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

Oh, I see, I am missing a comma here. Sorry for that.

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
