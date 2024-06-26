Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060F716A94B
	for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jun 2024 09:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719394841; cv=none; b=JYu0KZ7VC+OIvJMSDzKq9KG2X7hxtt9MkGzlzp5jynP9uOUB7hRXyFhC4EyCW2i0qcBN+hJLyAnNkwDM4QaKylUFXEuES6E1/ivq4tbNqY2D2X1lvjQnfTGEGOQbv7QpTYWUeBrcACHGaMvYWInyRKmcS0kLAGiDHTlKhndI3RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719394841; c=relaxed/simple;
	bh=HDausrn6wtDLO5z17WvzTCVs8dLkQCTX2JJwCZfBZTo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q/cA8X3PWwFYkgB4s+wHtQXp4YOLpaJPfECvKmoYbur/cjshYUbuY254LJTD5O/Jc+WhYOjcrnF5Q3tvjxGNIvbW0Qi4szHPNIiqhOC76VEb+2F5aDzSq9npWKVgh2KoWZjmh0LrRXYuAObveUvXdtI5kj2VTkYp8BNsF22P4mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KuX4hAKh; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KuX4hAKh"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e02b605bca2so253648276.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Jun 2024 02:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719394839; x=1719999639; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xq5zjelEmkvM1v2o/Fvt3qR/bkTWWdqxKQ41G8dfuYY=;
        b=KuX4hAKhu/ZLqtY8BSyT5F9pnIlToGDGGw4Mk7Aty63qZN3Xc6B+iNv8xbtR/Lk1F0
         Gjde2UNXdV6EK4rt+a8orCjo512EU/pD06bg7Vvs9o6Ve4buU4hfiz27u3PkOygK3bcb
         W772/szlPuj5IuB2jx9HTXFFgIKDk4DpTa6weOFayWmrg8oP4ruA38vlg42ZjhHlJe3H
         5WHJbZG7vy17/cYQVTYngRfPF7L1LcEr3SP2t9ZEzpyfd6ttd0KBq2YdMnb0c8eK5fsE
         umsDsU7ohL+FvAnwfPaV0qA60Lzu/VzWwr6UqDBxbKvPjUq3MLUJFNNlL44WUUeMYmii
         LHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719394839; x=1719999639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xq5zjelEmkvM1v2o/Fvt3qR/bkTWWdqxKQ41G8dfuYY=;
        b=d3DlTo2Gf+5n7KNC61cShQktrWVw4MO1+SQoWZOGjRHamloUrPJMqLDJ+t8z7SLubA
         pwlTEUzkAzYGt341UMuI9iedCO6QmXdrahF94dUkYAxNtFX2y1E8adC9ncz5n1qCYYbc
         QEVrHNTpaqf/OWfL1wkzviVZZjYEnoyMoSDTIddp/pxSSm/g7SGyki18aNaqGwrzNwPz
         JtNMV2q2BDgGPN4sGDtzmuf662Jl2hLyf3Sl6f1EHdmj1Q1L2lqoLz0zmeJW3yMInoMq
         8qh8x/JcPvNGBEO7QzxzPuO4w+7tq76NYCMquLGGyw4B2WLj3xTFxzIsCqVzYHUt2wEA
         8Eig==
X-Forwarded-Encrypted: i=1; AJvYcCW2guKMjeRpR38vrED9eJzowC0iua9X5RXGTMLvDQK0RrT5UH0GCxUzdvYPGAxcWem+vIVPwgxwJU21yeMK8QydqUZ7JO835KeVpw8=
X-Gm-Message-State: AOJu0YwWkjIXQmh34HK+hycSla4wcEYqc+M6PnLGPm2jiJWkBfgYmsao
	LhcjR2MFQIc2ttakyTaiAkePGOIZtOnQ+ao1N5Xuqa6v8z+XE494o1YBTp/gach440lWJhqhejV
	ksd2qMdxt/cLzRdcr0SNHttB3tZC8PsYpgcx0Sw==
X-Google-Smtp-Source: AGHT+IETUfiHu7B4Nd5IgeuTwHvP6hdEinFjbp3nQsIqAv3I62YVJcTZSrez/D4vedTEkPIgcndI55pzi3J2KfrwWyY=
X-Received: by 2002:a25:d805:0:b0:e02:b7a2:818e with SMTP id
 3f1490d57ef6-e02f9f50816mr7020111276.14.1719394838587; Wed, 26 Jun 2024
 02:40:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240618065427.143612-1-llfamsec@gmail.com> <1af4ff4a-e963-4969-86cc-27419d326614@suse.com>
 <CAEBF3_Yeby=aeq21y5qq-pe9zP5OFV5Fo+FatwPV0cOnDJ+K_Q@mail.gmail.com>
 <6f97e658-6dcd-47e9-9cf4-3b413cdb5b57@linux.alibaba.com> <0bfdc0ed-18ab-43e7-bc64-2d245e67db74@suse.com>
In-Reply-To: <0bfdc0ed-18ab-43e7-bc64-2d245e67db74@suse.com>
From: lei lu <llfamsec@gmail.com>
Date: Wed, 26 Jun 2024 17:40:27 +0800
Message-ID: <CAEBF3_aWXvu_7GAY9fT9P+wg0+7oj-ePTtZYzA=OcnTbGjOz3A@mail.gmail.com>
Subject: Re: [PATCH v5] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: "heming.zhao@suse.com" <heming.zhao@suse.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2024 at 4:30=E2=80=AFPM heming.zhao@suse.com
<heming.zhao@suse.com> wrote:
>
> On 6/22/24 08:31, Joseph Qi wrote:
> > Hi Heming=EF=BC=8C
> > Any more comments on this version?
> >
> > Thanks,
> > Joseph
>
> I made a mistake in the last mail. For inline mode, the 'size' parameter
> of ocfs2_check_dir_entry is the size of di->id2.i_data.id_data[], not
> the whole inode size.
>
> ref:
> ocfs2_fill_new_dir_id
>   + size =3D le16_to_cpu(data->id_count); //id_data[] size
>
>   + i_size_write(inode, size); //record in inode
>
> So the algorithm of v5 patch is correct. there is only one minor issue
> needs to be fixed. see below.
>
> >
> > On 6/18/24 9:09 PM, lei lu wrote:
> >> On Tue, Jun 18, 2024 at 8:04=E2=80=AFPM Heming Zhao <heming.zhao@suse.=
com> wrote:
> >>>
> >>> On 6/18/24 14:54, lei lu wrote:
> >>>> This adds sanity checks for ocfs2_dir_entry to make sure all members=
 of
> >>>> ocfs2_dir_entry don't stray beyond valid memory region.
> >>>>
> >>>> Signed-off-by: lei lu <llfamsec@gmail.com>
> >>>> ---
> >>>>    fs/ocfs2/dir.c | 39 +++++++++++++++++++++++++--------------
> >>>>    1 file changed, 25 insertions(+), 14 deletions(-)
> >>>>
> >>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> >>>> index d620d4c53c6f..cdd92b4f9bf1 100644
> >>>> --- a/fs/ocfs2/dir.c
> >>>> +++ b/fs/ocfs2/dir.c
> >>>> @@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct inod=
e *dir, const char *name, int len,
> >>>>     * bh passed here can be an inode block or a dir data block, depe=
nding
> >>>>     * on the inode inline data flag.
> >>>>     */
> >>>> -static int ocfs2_check_dir_entry(struct inode * dir,
> >>>> -                              struct ocfs2_dir_entry * de,
> >>>> -                              struct buffer_head * bh,
> >>>> +static int ocfs2_check_dir_entry(struct inode *dir,
> >>>> +                              struct ocfs2_dir_entry *de,
> >>>> +                              struct buffer_head *bh,
> >>>> +                              char *buf,
> >>>> +                              unsigned int size,
> >>>>                                 unsigned long offset)
> >>>>    {
> >>>>        const char *error_msg =3D NULL;
> >>>>        const int rlen =3D le16_to_cpu(de->rec_len);
> >>>> +     const unsigned long next_offset =3D ((char *) de - buf) + rlen=
;
> >>>
> >>> Hi Lei & Joseph,
> >>>
> >>> I withdraw my previous saying: the rest codes look good to me.
> >>>
> >>> I checked some code. In my view, if the code runs as expected,
> >>> next_offset should be equal to:  "((char *) de - bh->b_data) + rlen".
> >>
> >> Hi,
> >>
> >> As you said below, In inline mode, dir entry list starts at
> >> bh->b_data->id2.i_data,
> >> In the dir block mode, dir entry list starts at bh->b_data directly.
> >>
> >> So the prerequisite for checking here is to make sure that buf is the =
first_de
> >> and size is the de list size. We make sure that de don't stray beyond =
the de
> >> list regardless of its mode.
> >>
> >> The above patch code refers to the __ext4_check_dir_entry.
> >>
> >>>
> >>> You could add codes here to verify, e.g:
> >>>     printk("...");
> >>>     BUG_ON(next_offset !=3D (((char *)de - bh->b_data) + rlen));
> >>>
> >>> This BUG_ON() will never be triggered.
> >>>
> >>> Please take some time to build and run the test, If my thinking is ri=
ght,
> >>> you need to send v6 patch.
> >>>
> >>> btw, please don't forget to check my below comments.
> >>> It seems your code also has other bug.
> >>>
> >>> @Joseph, I also need your opinion.
> >>>
> >>>>
> >>>>        if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
> >>>>                error_msg =3D "rec_len is smaller than minimal";
> >>>> @@ -308,6 +311,11 @@ static int ocfs2_check_dir_entry(struct inode *=
 dir,
> >>>>                error_msg =3D "rec_len % 4 !=3D 0";
> >>>>        else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
> >>>>                error_msg =3D "rec_len is too small for name_len";
> >>>> +     else if (unlikely(next_offset > size))
> >>>> +             error_msg =3D "directory entry overrun";
> >>>> +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &=
&
> >>>> +              next_offset !=3D size)
> >>>> +             error_msg =3D "directory entry too close to end";
> >>>>        else if (unlikely(
> >>>>                 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_blo=
cksize))
> >>>>                error_msg =3D "directory entry across blocks";
>
> the existing code " '((char *) de - bh->b_data) + rlen >
> dir->i_sb->s_blocksize' " should be removed. the reason is same with
> commit 226ba972b0863 ("ext4: refactor __ext4_check_dir_entry() to accept
> start and size").

Sure, I will send a v6 patch to fix this issue.

Thanks,
LL

>
> Thanks,
> Heming
>
> >>>> @@ -352,16 +360,16 @@ static inline int ocfs2_search_dirblock(struct=
 buffer_head *bh,
> >>>>        de_buf =3D first_de;
> >>>>        dlimit =3D de_buf + bytes;
> >>>>
> >>>> -     while (de_buf < dlimit) {
> >>>> +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
> >>>>                /* this code is executed quadratically often */
> >>>>                /* do minimal checking `by hand' */
> >>>>
> >>>>                de =3D (struct ocfs2_dir_entry *) de_buf;
> >>>>
> >>>> -             if (de_buf + namelen <=3D dlimit &&
> >>>> +             if (de->name + namelen <=3D dlimit &&
> >>>>                    ocfs2_match(namelen, name, de)) {
> >>>>                        /* found a match - just to be sure, do a full=
 check */
> >>>> -                     if (!ocfs2_check_dir_entry(dir, de, bh, offset=
)) {
> >>>> +                     if (!ocfs2_check_dir_entry(dir, de, bh, first_=
de, bytes, offset)) {
> >>>
> >>>
> >>> ocfs2 uses two ways to store dir entry:
> >>>    inline mode (OCFS2_INLINE_DATA_FL) & dir block mode
> >>>
> >>> Above function (ocfs2_search_dirblock) handles dir block case, the co=
de
> >>> can work under expectation.
> >>
> >> I think ocfs2_search_dirblock handles both two modes? Because In the c=
aller
> >> ocfs2_find_entry_id, the first_de is from di_bh->b_data->id2.i_data->i=
d_data.
> >>
> >>>
> >>>>                                ret =3D -1;
> >>>>                                goto bail;
> >>>>                        }
> >>>> @@ -1138,7 +1146,7 @@ static int __ocfs2_delete_entry(handle_t *hand=
le, struct inode *dir,
> >>>>        pde =3D NULL;
> >>>>        de =3D (struct ocfs2_dir_entry *) first_de;
> >>>>        while (i < bytes) {
> >>>> -             if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
> >>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, first_de, byte=
s, i)) {
> >>>>                        status =3D -EIO;
> >>>>                        mlog_errno(status);
> >>>>                        goto bail;
> >>>> @@ -1635,7 +1643,7 @@ int __ocfs2_add_entry(handle_t *handle,
> >>>>                /* These checks should've already been passed by the
> >>>>                 * prepare function, but I guess we can leave them
> >>>>                 * here anyway. */
> >>>> -             if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset)=
) {
> >>>> +             if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_st=
art, size, offset)) {
> >>>>                        retval =3D -ENOENT;
> >>>>                        goto bail;
> >>>>                }
> >>>> @@ -1774,7 +1782,8 @@ static int ocfs2_dir_foreach_blk_id(struct ino=
de *inode,
> >>>>                }
> >>>>
> >>>>                de =3D (struct ocfs2_dir_entry *) (data->id_data + ct=
x->pos);
> >>>> -             if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos)=
) {
> >>>> +             if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)d=
ata->id_data,
> >>>> +                                        i_size_read(inode), ctx->po=
s)) {
> >>>
> >>> This function (ocfs2_dir_foreach_blk_id) handles inline mode.
> >>>
> >>> The de & data->id_data are both located in the inode struct, starting=
 at
> >>> offset 0xc8 in ((struct ocfs2_dinode)->id2.i_data). however di_bh->b_=
data
> >>> points to the start address of the inode.
> >>>
> >>> if ocfs2_check_dir_entry() uses de & data->id_data to compare the off=
set, it
> >>> misses the 0xc8 space.
> >>>
> >>>    struct ocfs2_dinode
> >>> +----------------------------------+
> >>> |   ...      |    id2.i_data       |
> >>> |            |---------------------|
> >>> |            |           |id_data[]|
> >>> ^------------------------^-------^-+
> >>> |                        |   ... |
> >>> 0x0                     0xc8     0xc8+xxx: de
> >>> di_bh->b_data         data->id_da
> >>>
> >>>
> >>> (This patch) in ocfs2_check_dir_entry(), it uses "de - data->id_da" t=
o get
> >>> the offset. However, from the above pic, the algorithm is wrong; it f=
orgets
> >>> the [0,0xc8].
> >>> the correct way: (de - bh->b_data)
> >>>
> >>> the same issue also occurs in ocfs2_find_dir_space_id().
> >>>
> >>>
> >>> Thanks,
> >>> Heming
> >>>
> >>>>                        /* On error, skip the f_pos to the end. */
> >>>>                        ctx->pos =3D i_size_read(inode);
> >>>>                        break;
> >>>> @@ -1867,7 +1876,8 @@ static int ocfs2_dir_foreach_blk_el(struct ino=
de *inode,
> >>>>                while (ctx->pos < i_size_read(inode)
> >>>>                       && offset < sb->s_blocksize) {
> >>>>                        de =3D (struct ocfs2_dir_entry *) (bh->b_data=
 + offset);
> >>>> -                     if (!ocfs2_check_dir_entry(inode, de, bh, offs=
et)) {
> >>>> +                     if (!ocfs2_check_dir_entry(inode, de, bh, bh->=
b_data,
> >>>> +                                                sb->s_blocksize, of=
fset)) {
> >>>>                                /* On error, skip the f_pos to the
> >>>>                                   next block. */
> >>>>                                ctx->pos =3D (ctx->pos | (sb->s_block=
size - 1)) + 1;
> >>>> @@ -3339,7 +3349,7 @@ static int ocfs2_find_dir_space_id(struct inod=
e *dir, struct buffer_head *di_bh,
> >>>>        struct super_block *sb =3D dir->i_sb;
> >>>>        struct ocfs2_dinode *di =3D (struct ocfs2_dinode *)di_bh->b_d=
ata;
> >>>>        struct ocfs2_dir_entry *de, *last_de =3D NULL;
> >>>> -     char *de_buf, *limit;
> >>>> +     char *first_de, *de_buf, *limit;
> >>>>        unsigned long offset =3D 0;
> >>>>        unsigned int rec_len, new_rec_len, free_space;
> >>>>
> >>>> @@ -3352,14 +3362,15 @@ static int ocfs2_find_dir_space_id(struct in=
ode *dir, struct buffer_head *di_bh,
> >>>>        else
> >>>>                free_space =3D dir->i_sb->s_blocksize - i_size_read(d=
ir);
> >>>>
> >>>> -     de_buf =3D di->id2.i_data.id_data;
> >>>> +     first_de =3D di->id2.i_data.id_data;
> >>>> +     de_buf =3D first_de;
> >>>>        limit =3D de_buf + i_size_read(dir);
> >>>>        rec_len =3D OCFS2_DIR_REC_LEN(namelen);
> >>>>
> >>>>        while (de_buf < limit) {
> >>>>                de =3D (struct ocfs2_dir_entry *)de_buf;
> >>>>
> >>>> -             if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
> >>>> +             if (!ocfs2_check_dir_entry(dir, de, di_bh, first_de, i=
_size_read(dir), offset)) {
> >>>>                        ret =3D -ENOENT;
> >>>>                        goto out;
> >>>>                }
> >>>> @@ -3441,7 +3452,7 @@ static int ocfs2_find_dir_space_el(struct inod=
e *dir, const char *name,
> >>>>                        /* move to next block */
> >>>>                        de =3D (struct ocfs2_dir_entry *) bh->b_data;
> >>>>                }
> >>>> -             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> >>>> +             if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, bl=
ocksize, offset)) {
> >>>>                        status =3D -ENOENT;
> >>>>                        goto bail;
> >>>>                }
> >>>
