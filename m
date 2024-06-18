Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C1D1D9535
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 06:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718691669; cv=none; b=a+dFw4Ng1xv9D9HCblB74QZSfiOdy8P1iR0AIb3epvuF47WhF9BRUUXd8sk6gcqFjszk+r3eU+9Da5QJU+xBXCAsFz8AQyAo0Zekr/e6oSMWSuZeoYtzAzwKVybQZsgTiDnNsbWOZep01ySxH/0KtJ7JHPOw74w/ntv658qn0Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718691669; c=relaxed/simple;
	bh=KzoXFOsJv6DAwavEyIDarFEzYn/D6gz7PHI6ITAnCTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Amu7qXgCT138FGkW9rU5n66j/+5KZTklq+SU3u+B46QJW9zTc4TolTGO65DzZ+7GeKom0ym7XfB/qitntq8/+ljBW4hoF+r3a0soS8oweyw8cXm6wKYjY4HkahdO+TeSTJ5yEY7VrwN3DSws0RBkch+uMl98WsUBgoB2/gAyVwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kWivs3S/; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kWivs3S/"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-dfecd065b0aso4414159276.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 23:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718691666; x=1719296466; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CBO9YLppuDym7whpwGKJcKb2o9ZdyBxgtTuhdTZtppM=;
        b=kWivs3S/hyZvNyVzH5bqVGyBKbJpTvCkFY/xvzszz2SZJcuDpYPW0fR6FUkGC9gS5L
         Fz2xbQwFg6k0iL65h7f5OhoUKIFo1AfX1NcZSHyqLba7+XVXe6Oai4DTfJPGbBmhStzm
         BC/MfqGAcBXtvVfJXs0jcf+Qs/5C2YePFa7p1N1cgYjZbo5QaQeoFiJe3JyixmVamsgn
         9mAxvziVSoorz+NfEs58AfXUX5BdFpozFr4KOcpZTTv3kdPJlXvMOIHQ4B7jOCtUG8Lx
         G3moWduFqXDCggfVkq9XSMnupKIGlIt3t74XCSE7HBAdR2ykb83COo5UoZxAX/rmJPA9
         LXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718691666; x=1719296466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CBO9YLppuDym7whpwGKJcKb2o9ZdyBxgtTuhdTZtppM=;
        b=ZEgS4vuwiW7pg/CjKCXogFfx+zbwmBK1bgkvCCaOOo6QXN1tdGvd4iypxVm+5cOl73
         XY1XkBIp3LBUSG+Np/SQyNRk9fUEWHvOKyGQeAasozuwj3OXHmOLVayREOyubH+dd+NX
         qgafLj1/t9DFqDNvqk3DI2P3SBgdUlXneOQbbfoabhmKdl45mWJ1AUhWxQNZAAXhxPY9
         zXjRyJNqmg1EetXkLRHy2jBG+wmw7zBKR/MSiotp702eUE+SCDFCwAPWAqpfeQvFrFo8
         q+GwX79THTefSu7iTWTy8Od9xqADcnIzKShdu1ic9AoW7l26jQ9vPFe+wol2o5e7BZ4y
         v9EQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfxHzpIUkvovbGEQRmDARoXeL7avMO3I6fweVLekvVym96bAXxqXGDAte8fZd8DaNHmH4KJT7re1mcMNMWS/cpOaR2ja7xHKjV2+k=
X-Gm-Message-State: AOJu0Ywr7SEKLoXe/NcNMpyp8KHZ3KR3IjUU80fSQ+hGJhH9KEvPh15W
	EJCOaURU6XbAbYaEtuQ3JuIr/rIB62HiSXKm1ZvybrBpTdQnUF7+M5Ab3Dhmm+eITnGLsbmc27A
	oF/2dEdMkWKKJqYhCv6HjDe/wows=
X-Google-Smtp-Source: AGHT+IHLNY54KY+46KZyrfKTbcGfH0v+fdPDfAVCODoqS2UCwVur3a8vY47En0X43t9U2NRY/U1hYb6nuTafdrNlntw=
X-Received: by 2002:a05:6902:602:b0:e02:3e43:f1c7 with SMTP id
 3f1490d57ef6-e023e43f3fdmr1409618276.13.1718691666461; Mon, 17 Jun 2024
 23:21:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240617114027.139982-1-llfamsec@gmail.com> <c5a6ab63-884a-4328-bfbe-7045f5469141@suse.com>
 <CAEBF3_be2K059_WqisKXUL-mm9-vqXshzrkGpc1-7AVdB=xcVQ@mail.gmail.com> <106d3676-d689-45a6-bdfb-f0db1a020ed4@suse.com>
In-Reply-To: <106d3676-d689-45a6-bdfb-f0db1a020ed4@suse.com>
From: lei lu <llfamsec@gmail.com>
Date: Tue, 18 Jun 2024 14:20:55 +0800
Message-ID: <CAEBF3_ay8oXvM1RNNVvUUG3ju8aEN6ve0yCJbKm8ZoxSJJi59Q@mail.gmail.com>
Subject: Re: [PATCH v4] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2024 at 2:13=E2=80=AFPM Heming Zhao <heming.zhao@suse.com> =
wrote:
>
> On 6/18/24 13:58, lei lu wrote:
> > On Tue, Jun 18, 2024 at 11:29=E2=80=AFAM Heming Zhao <heming.zhao@suse.=
com> wrote:
> >>
> >> On 6/17/24 19:40, lei lu wrote:
> >>> This adds sanity checks for ocfs2_dir_entry to make sure all members =
of
> >>> ocfs2_dir_entry don't stray beyond valid memory region.
> >>>
> >>> Signed-off-by: lei lu <llfamsec@gmail.com>
> >>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> >>> ---
> >>>    fs/ocfs2/dir.c | 34 ++++++++++++++++++++++------------
> >>>    1 file changed, 22 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> >>> index d620d4c53c6f..562f61daf77d 100644
> >>> --- a/fs/ocfs2/dir.c
> >>> +++ b/fs/ocfs2/dir.c
> >>> @@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct inode=
 *dir, const char *name, int len,
> >>>     * bh passed here can be an inode block or a dir data block, depen=
ding
> >>>     * on the inode inline data flag.
> >>>     */
> >>> -static int ocfs2_check_dir_entry(struct inode * dir,
> >>> -                              struct ocfs2_dir_entry * de,
> >>> -                              struct buffer_head * bh,
> >>> +static int ocfs2_check_dir_entry(struct inode *dir,
> >>> +                              struct ocfs2_dir_entry *de,
> >>> +                              struct buffer_head *bh,
> >>> +                              char *buf,
> >>> +                              unsigned int size,
> >>>                                 unsigned long offset)
> >>>    {
> >>>        const char *error_msg =3D NULL;
> >>>        const int rlen =3D le16_to_cpu(de->rec_len);
> >>> +     const unsigned long next_offset =3D ((char *) de - buf) + rlen;
> >>
> >> from this patch, there are two cases for the parameter 'buf':
> >>
> >> 1>
> >> 'de' is the same as 'bh', de & bh both are the latest dir_entry offset=
.
> >> the sanity check always passes below cases. e.g:
> >> - ocfs2_search_dirblock()
> >> - ocfs2_find_dir_space_id()
> >
> > Thanks for your time.
> >
> > Sorry, I don't quite understand what you mean.
>
> Oh, sorry for my typo, my mean: 'de' is the same as 'buf' not 'bh'.
>
> The patch code in ocfs2_search_dirblock() is:
>    if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes, offset))
>
> the de is same as de_buf, so in ocfs2_check_dir_entry() the next_offset b=
ecomes
>    next_offset =3D rlen; //because "de =3D=3D de_buf"
>
> In this case, rlen is not the current dir entry end boundary.
>
> > I think 'de' is not the same as 'bh'. e.g.:
> > - ocfs2_search_dirblock(): de is the latest dir_entry offset, bh is
> > the ocfs2_dinode offset, buf is the first dir_entry offset
>
> buf is not the first dir_entry offset.
>
> > - ocfs2_find_dir_space_id(): de is the latest dir_entry offset, bh is
> > the ocfs2_dinode offset, buf is the first dir_entry offset
>
> ditto

Oh, you are right, We should use first_de here.

Thanks,
LL

>
> -Heming
> >
> > Thanks,
> > LL
> >
> >>
> >> 2>
> >> 'de' is different with 'bh', bh is the first dir_entry offset, de is
> >> the latest offset. these cases should be the expected code paths, e.g:
> >> - __ocfs2_delete_entry()
> >> - ocfs2_dir_foreach_blk_id()
> >> - ocfs2_dir_foreach_blk_el()
> >> - ocfs2_find_dir_space_el()
> >>
> >> If my thinking is right, case <1> needs to be revised to follow the de=
sign.
> >>
> >> -Heming
> >>>
> >>>        if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
> >>>                error_msg =3D "rec_len is smaller than minimal";
> >>> @@ -308,6 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * =
dir,
> >>>                error_msg =3D "rec_len % 4 !=3D 0";
> >>>        else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
> >>>                error_msg =3D "rec_len is too small for name_len";
> >>> +     else if (unlikely(next_offset > size))
> >>> +             error_msg =3D "directory entry overrun";
> >>> +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
> >>> +              next_offset !=3D size)
> >>> +             error_msg =3D "directory entry too close to end";
> >>>        else if (unlikely(
> >>>                 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_bloc=
ksize))
> >>>                error_msg =3D "directory entry across blocks";
> >>> @@ -352,16 +360,16 @@ static inline int ocfs2_search_dirblock(struct =
buffer_head *bh,
> >>>        de_buf =3D first_de;
> >>>        dlimit =3D de_buf + bytes;
> >>>
> >>> -     while (de_buf < dlimit) {
> >>> +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
> >>>                /* this code is executed quadratically often */
> >>>                /* do minimal checking `by hand' */
> >>>
> >>>                de =3D (struct ocfs2_dir_entry *) de_buf;
> >>>
> >>> -             if (de_buf + namelen <=3D dlimit &&
> >>> +             if (de->name + namelen <=3D dlimit &&
> >>>                    ocfs2_match(namelen, name, de)) {
> >>>                        /* found a match - just to be sure, do a full =
check */
> >>> -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset)=
) {
> >>> +                     if (!ocfs2_check_dir_entry(dir, de, bh, de_buf,=
 bytes, offset)) {
> >>>                                ret =3D -1;
> >>>                                goto bail;
> >>>                        }
> >>> @@ -1138,7 +1146,7 @@ static int __ocfs2_delete_entry(handle_t *handl=
e, struct inode *dir,
> >>>        pde =3D NULL;
> >>>        de =3D (struct ocfs2_dir_entry *) first_de;
> >>>        while (i < bytes) {
> >>> -             if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
> >>> +             if (!ocfs2_check_dir_entry(dir, de, bh, first_de, bytes=
, i)) {
> >>>                        status =3D -EIO;
> >>>                        mlog_errno(status);
> >>>                        goto bail;
> >>> @@ -1635,7 +1643,7 @@ int __ocfs2_add_entry(handle_t *handle,
> >>>                /* These checks should've already been passed by the
> >>>                 * prepare function, but I guess we can leave them
> >>>                 * here anyway. */
> >>> -             if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset))=
 {
> >>> +             if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_sta=
rt, size, offset)) {
> >>>                        retval =3D -ENOENT;
> >>>                        goto bail;
> >>>                }
> >>> @@ -1774,7 +1782,8 @@ static int ocfs2_dir_foreach_blk_id(struct inod=
e *inode,
> >>>                }
> >>>
> >>>                de =3D (struct ocfs2_dir_entry *) (data->id_data + ctx=
->pos);
> >>> -             if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos))=
 {
> >>> +             if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)da=
ta->id_data,
> >>> +                                        i_size_read(inode), ctx->pos=
)) {
> >>>                        /* On error, skip the f_pos to the end. */
> >>>                        ctx->pos =3D i_size_read(inode);
> >>>                        break;
> >>> @@ -1867,7 +1876,8 @@ static int ocfs2_dir_foreach_blk_el(struct inod=
e *inode,
> >>>                while (ctx->pos < i_size_read(inode)
> >>>                       && offset < sb->s_blocksize) {
> >>>                        de =3D (struct ocfs2_dir_entry *) (bh->b_data =
+ offset);
> >>> -                     if (!ocfs2_check_dir_entry(inode, de, bh, offse=
t)) {
> >>> +                     if (!ocfs2_check_dir_entry(inode, de, bh, bh->b=
_data,
> >>> +                                                sb->s_blocksize, off=
set)) {
> >>>                                /* On error, skip the f_pos to the
> >>>                                   next block. */
> >>>                                ctx->pos =3D (ctx->pos | (sb->s_blocks=
ize - 1)) + 1;
> >>> @@ -3359,7 +3369,7 @@ static int ocfs2_find_dir_space_id(struct inode=
 *dir, struct buffer_head *di_bh,
> >>>        while (de_buf < limit) {
> >>>                de =3D (struct ocfs2_dir_entry *)de_buf;
> >>>
> >>> -             if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
> >>> +             if (!ocfs2_check_dir_entry(dir, de, di_bh, de_buf, i_si=
ze_read(dir), offset)) {
> >>>                        ret =3D -ENOENT;
> >>>                        goto out;
> >>>                }
> >>> @@ -3441,7 +3451,7 @@ static int ocfs2_find_dir_space_el(struct inode=
 *dir, const char *name,
> >>>                        /* move to next block */
> >>>                        de =3D (struct ocfs2_dir_entry *) bh->b_data;
> >>>                }
> >>> -             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> >>> +             if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, blo=
cksize, offset)) {
> >>>                        status =3D -ENOENT;
> >>>                        goto bail;
> >>>                }
> >>
>
