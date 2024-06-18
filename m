Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5059A1586D5
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 13:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716159; cv=none; b=SVhoIs4dYSJuD966ujiyFd76gQSAM0+kBMBzKt4yCNnlZSzYnxHw7x2YcgROs+N7gSJoG68nARXQxiEQZOhoXbtnkcDkhyT7Yjypm1hKtkMlcnSXr2gMhttBeIjYvHq5fZ2XoQ+c0FeYYlUSyQlCF0g+RMxmoqpb6h4j6lU3kOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716159; c=relaxed/simple;
	bh=Es2Iv5OPU/seEGcNYxDx8S/CMYzMON2JSH7UkARahd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AgDal+thy9HtVauIZaiErJK7Y74Qg3VQ4/mge+92HzvPVXr4Lcs8CB5OM+AdY48IoG9u4BoyPCoC/Mj7m6AQoIHPgpA9xAaFF3gNnwttLwH07MYbil/EpeRfnyH47Cht+Sn2QXwBZ5H3j1RXX+1N6LB6HZIo/2VK+vxzVjd1j5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lWItLJh2; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lWItLJh2"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dff0c685292so4885794276.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 06:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718716156; x=1719320956; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vMPcMz+zNUPyNyomugwhnx8T1dY1U8MQO55ZDVi4vWQ=;
        b=lWItLJh2VOOzOgCbz16N3XC6EOuoHAnQukgH2v/LdYxUtXlM3Tc8KKgsqrQpzg1fNe
         zh+Wcf6WxAG2gi4ZLMGNAGWulU5rwIjYHcUszVYdIztn+nDs4Teqt40uLLeDpEHEPNOV
         ww30qYRZl7xugq4HUD4rPmWKC81fmGjODXy3OwXhpx5QiVz7Iekf+HtQyDaVO26760kA
         5kDk8n/fHaBMbJ8I5PINYdnFMfUts2ZxZiVQ6O+aowOB9MLZWRonfiH9CSTTGPafHPJa
         N8WgWgHgOzWgxeU4Ji1W6M0A2NlwLUIEtDH9nKz+m6S3kXYt1xHja9oiYZGfMMSNsDpg
         dpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718716156; x=1719320956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vMPcMz+zNUPyNyomugwhnx8T1dY1U8MQO55ZDVi4vWQ=;
        b=QubYkukilWgAEH50xkhp0sFDVuR3JDfP7pjHMtzyDBCQKhZZHsO3tV55hbGJBeX7+O
         ZVNYmJVLxlI+K6Mj37Bvqo6+8XyEYrFK+kyjv+NdS7Joe7M+TwRzAW1+7sjHhxZ77zky
         XhsgBeZZmj7xPcFampzjDIRPFJmKsH4N+61tKoTONW2fqSmdjRc8hSWr9F6xsjfkSZlN
         th9UBMnlWin9iqOGKNCziF9VksCgfN6eL8jEKjTTeBzQOfSJu4EWs9F3Th5jOhhACwmW
         /7i6BLeN2ZyFMYCiZoOiFiw6AdzPa+M7NJBygstJ3AdlG9acGFvsNH69yTUStC104dbV
         KPMw==
X-Forwarded-Encrypted: i=1; AJvYcCUEF4J4f0Qnv/3RWJxwV8iu3dp9+d/JT2bmt0rqGBWrvxwFNQYja736ouFc2kgpqMe47sdV8iuR4yk3x+qu92zNC6LT0s8EFCWI6wA=
X-Gm-Message-State: AOJu0YwuRxMZeVK+2UUi+LDjpZ+p7AknZHyNMh5dN4xA7eP0AZXOrQEk
	axDRtjUGiFwnwOVyR5HsuebJmmdm7sPS2SCEVE5l/wgFvuSNEPlfLS1Tm9HRt8cPT/EN3z9tySR
	cIwFI6TmX5eGyT2ETAC/ZfUEDXb0=
X-Google-Smtp-Source: AGHT+IERQHVCYAyC4yV86zWCcRaUoUl9g0B+Corej9aL0XZAgjbNmcu4vOaMwuQAdrzREbBAHz1c5UWSE8LTzGg+lVA=
X-Received: by 2002:a25:ae1d:0:b0:dff:383e:d84 with SMTP id
 3f1490d57ef6-dff383e1432mr8356053276.50.1718716155988; Tue, 18 Jun 2024
 06:09:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240618065427.143612-1-llfamsec@gmail.com> <1af4ff4a-e963-4969-86cc-27419d326614@suse.com>
In-Reply-To: <1af4ff4a-e963-4969-86cc-27419d326614@suse.com>
From: lei lu <llfamsec@gmail.com>
Date: Tue, 18 Jun 2024 21:09:03 +0800
Message-ID: <CAEBF3_Yeby=aeq21y5qq-pe9zP5OFV5Fo+FatwPV0cOnDJ+K_Q@mail.gmail.com>
Subject: Re: [PATCH v5] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2024 at 8:04=E2=80=AFPM Heming Zhao <heming.zhao@suse.com> =
wrote:
>
> On 6/18/24 14:54, lei lu wrote:
> > This adds sanity checks for ocfs2_dir_entry to make sure all members of
> > ocfs2_dir_entry don't stray beyond valid memory region.
> >
> > Signed-off-by: lei lu <llfamsec@gmail.com>
> > ---
> >   fs/ocfs2/dir.c | 39 +++++++++++++++++++++++++--------------
> >   1 file changed, 25 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> > index d620d4c53c6f..cdd92b4f9bf1 100644
> > --- a/fs/ocfs2/dir.c
> > +++ b/fs/ocfs2/dir.c
> > @@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct inode *=
dir, const char *name, int len,
> >    * bh passed here can be an inode block or a dir data block, dependin=
g
> >    * on the inode inline data flag.
> >    */
> > -static int ocfs2_check_dir_entry(struct inode * dir,
> > -                              struct ocfs2_dir_entry * de,
> > -                              struct buffer_head * bh,
> > +static int ocfs2_check_dir_entry(struct inode *dir,
> > +                              struct ocfs2_dir_entry *de,
> > +                              struct buffer_head *bh,
> > +                              char *buf,
> > +                              unsigned int size,
> >                                unsigned long offset)
> >   {
> >       const char *error_msg =3D NULL;
> >       const int rlen =3D le16_to_cpu(de->rec_len);
> > +     const unsigned long next_offset =3D ((char *) de - buf) + rlen;
>
> Hi Lei & Joseph,
>
> I withdraw my previous saying: the rest codes look good to me.
>
> I checked some code. In my view, if the code runs as expected,
> next_offset should be equal to:  "((char *) de - bh->b_data) + rlen".

Hi,

As you said below, In inline mode, dir entry list starts at
bh->b_data->id2.i_data,
In the dir block mode, dir entry list starts at bh->b_data directly.

So the prerequisite for checking here is to make sure that buf is the first=
_de
and size is the de list size. We make sure that de don't stray beyond the d=
e
list regardless of its mode.

The above patch code refers to the __ext4_check_dir_entry.

>
> You could add codes here to verify, e.g:
>    printk("...");
>    BUG_ON(next_offset !=3D (((char *)de - bh->b_data) + rlen));
>
> This BUG_ON() will never be triggered.
>
> Please take some time to build and run the test, If my thinking is right,
> you need to send v6 patch.
>
> btw, please don't forget to check my below comments.
> It seems your code also has other bug.
>
> @Joseph, I also need your opinion.
>
> >
> >       if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
> >               error_msg =3D "rec_len is smaller than minimal";
> > @@ -308,6 +311,11 @@ static int ocfs2_check_dir_entry(struct inode * di=
r,
> >               error_msg =3D "rec_len % 4 !=3D 0";
> >       else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
> >               error_msg =3D "rec_len is too small for name_len";
> > +     else if (unlikely(next_offset > size))
> > +             error_msg =3D "directory entry overrun";
> > +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
> > +              next_offset !=3D size)
> > +             error_msg =3D "directory entry too close to end";
> >       else if (unlikely(
> >                ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blocksi=
ze))
> >               error_msg =3D "directory entry across blocks";
> > @@ -352,16 +360,16 @@ static inline int ocfs2_search_dirblock(struct bu=
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
> > +                     if (!ocfs2_check_dir_entry(dir, de, bh, first_de,=
 bytes, offset)) {
>
>
> ocfs2 uses two ways to store dir entry:
>   inline mode (OCFS2_INLINE_DATA_FL) & dir block mode
>
> Above function (ocfs2_search_dirblock) handles dir block case, the code
> can work under expectation.

I think ocfs2_search_dirblock handles both two modes? Because In the caller
ocfs2_find_entry_id, the first_de is from di_bh->b_data->id2.i_data->id_dat=
a.

>
> >                               ret =3D -1;
> >                               goto bail;
> >                       }
> > @@ -1138,7 +1146,7 @@ static int __ocfs2_delete_entry(handle_t *handle,=
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
> > @@ -1635,7 +1643,7 @@ int __ocfs2_add_entry(handle_t *handle,
> >               /* These checks should've already been passed by the
> >                * prepare function, but I guess we can leave them
> >                * here anyway. */
> > -             if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)) {
> > +             if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_start=
, size, offset)) {
> >                       retval =3D -ENOENT;
> >                       goto bail;
> >               }
> > @@ -1774,7 +1782,8 @@ static int ocfs2_dir_foreach_blk_id(struct inode =
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
>
> This function (ocfs2_dir_foreach_blk_id) handles inline mode.
>
> The de & data->id_data are both located in the inode struct, starting at
> offset 0xc8 in ((struct ocfs2_dinode)->id2.i_data). however di_bh->b_data
> points to the start address of the inode.
>
> if ocfs2_check_dir_entry() uses de & data->id_data to compare the offset,=
 it
> misses the 0xc8 space.
>
>   struct ocfs2_dinode
> +----------------------------------+
> |   ...      |    id2.i_data       |
> |            |---------------------|
> |            |           |id_data[]|
> ^------------------------^-------^-+
> |                        |   ... |
> 0x0                     0xc8     0xc8+xxx: de
> di_bh->b_data         data->id_da
>
>
> (This patch) in ocfs2_check_dir_entry(), it uses "de - data->id_da" to ge=
t
> the offset. However, from the above pic, the algorithm is wrong; it forge=
ts
> the [0,0xc8].
> the correct way: (de - bh->b_data)
>
> the same issue also occurs in ocfs2_find_dir_space_id().
>
>
> Thanks,
> Heming
>
> >                       /* On error, skip the f_pos to the end. */
> >                       ctx->pos =3D i_size_read(inode);
> >                       break;
> > @@ -1867,7 +1876,8 @@ static int ocfs2_dir_foreach_blk_el(struct inode =
*inode,
> >               while (ctx->pos < i_size_read(inode)
> >                      && offset < sb->s_blocksize) {
> >                       de =3D (struct ocfs2_dir_entry *) (bh->b_data + o=
ffset);
> > -                     if (!ocfs2_check_dir_entry(inode, de, bh, offset)=
) {
> > +                     if (!ocfs2_check_dir_entry(inode, de, bh, bh->b_d=
ata,
> > +                                                sb->s_blocksize, offse=
t)) {
> >                               /* On error, skip the f_pos to the
> >                                  next block. */
> >                               ctx->pos =3D (ctx->pos | (sb->s_blocksize=
 - 1)) + 1;
> > @@ -3339,7 +3349,7 @@ static int ocfs2_find_dir_space_id(struct inode *=
dir, struct buffer_head *di_bh,
> >       struct super_block *sb =3D dir->i_sb;
> >       struct ocfs2_dinode *di =3D (struct ocfs2_dinode *)di_bh->b_data;
> >       struct ocfs2_dir_entry *de, *last_de =3D NULL;
> > -     char *de_buf, *limit;
> > +     char *first_de, *de_buf, *limit;
> >       unsigned long offset =3D 0;
> >       unsigned int rec_len, new_rec_len, free_space;
> >
> > @@ -3352,14 +3362,15 @@ static int ocfs2_find_dir_space_id(struct inode=
 *dir, struct buffer_head *di_bh,
> >       else
> >               free_space =3D dir->i_sb->s_blocksize - i_size_read(dir);
> >
> > -     de_buf =3D di->id2.i_data.id_data;
> > +     first_de =3D di->id2.i_data.id_data;
> > +     de_buf =3D first_de;
> >       limit =3D de_buf + i_size_read(dir);
> >       rec_len =3D OCFS2_DIR_REC_LEN(namelen);
> >
> >       while (de_buf < limit) {
> >               de =3D (struct ocfs2_dir_entry *)de_buf;
> >
> > -             if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
> > +             if (!ocfs2_check_dir_entry(dir, de, di_bh, first_de, i_si=
ze_read(dir), offset)) {
> >                       ret =3D -ENOENT;
> >                       goto out;
> >               }
> > @@ -3441,7 +3452,7 @@ static int ocfs2_find_dir_space_el(struct inode *=
dir, const char *name,
> >                       /* move to next block */
> >                       de =3D (struct ocfs2_dir_entry *) bh->b_data;
> >               }
> > -             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> > +             if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, block=
size, offset)) {
> >                       status =3D -ENOENT;
> >                       goto bail;
> >               }
>
