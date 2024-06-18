Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E430A18E1D
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 05:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718690325; cv=none; b=M6PbqCGh71VS5f6sc1Z4sQYntjVjFzkPIsIlxFdDzPovTV3DvZ0I/2dQDmP9stDsRugx85+73DBhHnne6JV9lXQ4JHyikUL66lXbeCZMYDGZCtti/9r2aps4wWpa0Ut4fu1Fh1fnZZ3876GTcL/Gyus/U/V0YdY1REkaVr0eDS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718690325; c=relaxed/simple;
	bh=8SkN6GUx5cHC3cktpmCdN7+Z+/9pFEZAoFj0wcqQXHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kYFRgk+yDoTk21yGFIAPScmw1wGHyGsyKfBbgBRCAojBn9Le/U06t05MRciZA0n+zUhV8WOCMBoYvhGxzPbOeTGdUTRDWXBVQPygd0G3U8ZUD3odCq4cl6k8sXLNl3BaZg1ZKyksuQogWeXclI4GON/AsdQHkdOwJSJ4AR+1ddU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UbHohQRw; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UbHohQRw"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dff36345041so2072023276.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 22:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718690323; x=1719295123; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ne1imVAeEoJiZveDDwt5vFMpoW0qaqQkjuUgCDLbNA8=;
        b=UbHohQRwEe8tsvly9hU6OTRrQLp2BLlLixuPxMdpBoOoA1WyPCKBMXV1MX0JfC4OIx
         AOpGgg9C1VW6KmP/b8aJ0RCrvQBqlXRfKygPqc4fow1XWLeBTRLly6/a340IzWQkCH+/
         Sd7faol3sCyCm9/kA9iId24vlTmiv52cEQMSnFpDjFJuWRbq6OTs265DqKMkSmeNDQyv
         2E+hjttT8dPPcgcjEIPq4KyxlUBwCEBq8zlWTeTF/KyKppc2fdm6NlT77R5N89DcWp5M
         5EFHrwNw8u/W4R4BYSsR4wyJQGFKySjPcfdJIRqV6WahetuX9qHh/qM3uMUqmdC2yGcr
         QDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718690323; x=1719295123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ne1imVAeEoJiZveDDwt5vFMpoW0qaqQkjuUgCDLbNA8=;
        b=feNH3RmbrpX6kzce21igX6I6x66CpwIePwNmgBKE78FbmBqQJvygFMKNXWRBT6bOSl
         It7eTrzcQ4jh7DchVkCrVzQwBYzUjQzzXR/pfIdP4ZCgq+dO4SgmYl0wl4TvcVGQviN7
         iGsCnjervdouWnWntM43aPArhfcnSU3gb9FKD5eg7sGYZ6xeJR9JR1RZqQL6gMLDi4+C
         vOMtD/jgqqGU4JulmGipZItcD9JHNdVNvYqm5JDH+HAZNuK0KlwRQjDH0R4dyx246yHV
         JzHr2KJdcIbIRZwGTJYB5OD2qu+cNk8AeM/kYfHHyjKkuok91SuViDfPdH5ES/NvnusR
         eX3g==
X-Forwarded-Encrypted: i=1; AJvYcCWs/ngXuq0Yzn9fuU3afpyxcHxxoVC/fZdcFKGiYyfUlXcaR36rIGaFGV8wmWxMtSONsge3lumKOB0dqwNpwbf5QDrBQIGG8qLac34=
X-Gm-Message-State: AOJu0YxZeC1DdlOUXwtzWBpJrHA/eaFTZR8qPZRc9mhFzDCf3HPDZtcm
	1gcItg2vHwZ6cqHUbDe40hunqWHyvDZXKbOlJLheM30vjYVKBJWqLzSeehdwi/+AKP9FNA2SyEe
	4gfb7dBDqRanBgxB6/IBzQ61wem8=
X-Google-Smtp-Source: AGHT+IFzdUfgzyltcQbJnAotWU5Whhtq4L782Iz2XzsZ6Ke2j2PKRrYNVR4gc8LLDTdnM/PU05jnRkJhSekVmi56tVk=
X-Received: by 2002:a25:b212:0:b0:e02:b518:7f15 with SMTP id
 3f1490d57ef6-e02b5187f3dmr312979276.34.1718690322661; Mon, 17 Jun 2024
 22:58:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240617114027.139982-1-llfamsec@gmail.com> <c5a6ab63-884a-4328-bfbe-7045f5469141@suse.com>
In-Reply-To: <c5a6ab63-884a-4328-bfbe-7045f5469141@suse.com>
From: lei lu <llfamsec@gmail.com>
Date: Tue, 18 Jun 2024 13:58:31 +0800
Message-ID: <CAEBF3_be2K059_WqisKXUL-mm9-vqXshzrkGpc1-7AVdB=xcVQ@mail.gmail.com>
Subject: Re: [PATCH v4] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2024 at 11:29=E2=80=AFAM Heming Zhao <heming.zhao@suse.com>=
 wrote:
>
> On 6/17/24 19:40, lei lu wrote:
> > This adds sanity checks for ocfs2_dir_entry to make sure all members of
> > ocfs2_dir_entry don't stray beyond valid memory region.
> >
> > Signed-off-by: lei lu <llfamsec@gmail.com>
> > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > ---
> >   fs/ocfs2/dir.c | 34 ++++++++++++++++++++++------------
> >   1 file changed, 22 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> > index d620d4c53c6f..562f61daf77d 100644
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
> from this patch, there are two cases for the parameter 'buf':
>
> 1>
> 'de' is the same as 'bh', de & bh both are the latest dir_entry offset.
> the sanity check always passes below cases. e.g:
> - ocfs2_search_dirblock()
> - ocfs2_find_dir_space_id()

Thanks for your time.

Sorry, I don't quite understand what you mean.
I think 'de' is not the same as 'bh'. e.g.:
- ocfs2_search_dirblock(): de is the latest dir_entry offset, bh is
the ocfs2_dinode offset, buf is the first dir_entry offset
- ocfs2_find_dir_space_id(): de is the latest dir_entry offset, bh is
the ocfs2_dinode offset, buf is the first dir_entry offset

Thanks,
LL

>
> 2>
> 'de' is different with 'bh', bh is the first dir_entry offset, de is
> the latest offset. these cases should be the expected code paths, e.g:
> - __ocfs2_delete_entry()
> - ocfs2_dir_foreach_blk_id()
> - ocfs2_dir_foreach_blk_el()
> - ocfs2_find_dir_space_el()
>
> If my thinking is right, case <1> needs to be revised to follow the desig=
n.
>
> -Heming
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
> > +                     if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, b=
ytes, offset)) {
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
> > @@ -3359,7 +3369,7 @@ static int ocfs2_find_dir_space_id(struct inode *=
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
> > @@ -3441,7 +3451,7 @@ static int ocfs2_find_dir_space_el(struct inode *=
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
