Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7596194A6A
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 11:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718623731; cv=none; b=owZ9YFRdEF3Eh4aYT9qA/Q/lXHi6toHQDN8B3Cf1/HorXxmv8HvGxKit+Yk7sDnrISEhpBIZzzXVtpyG6IEgrVg7FNjeOxfPWD08Cs9Wb3iBQ5uPHDSoFp0+dCfbqaiPBmyHq4MWissow2y4v2T25i1sBtCiGAYGHpgSu3OQ5YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718623731; c=relaxed/simple;
	bh=7hjuaLiKG0yvbk0OHs83WoU69dEK9AqwRAjlBpYyVpY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OV1Fo91a9oAT7/NjULPhnAStWPGi8gW9VEkloDtPaBNlyXmxKuMTiGdC1DYc2Fim8ZM5l6tk4xMUXzJU4a+5V1NH4SxpQQx2/19ejs6ND7Pops7aRl7U19UqTiMKnBPhSGbnJT8Tmb105ZvtjdPEUviAtXTwWk6ZlH/9N9p8b50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lgqYWZPt; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lgqYWZPt"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-dfefe1a9f01so4695532276.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 04:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718623729; x=1719228529; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Jkpm02645RYjRIRJBnvvyY5Jtb+wCyxVPpAEdzZE5g=;
        b=lgqYWZPt+eDJXfUPa4dAY6lKWepqC9cA9j+EY0vBhFKpo7z12izXLH9j8mZPd18uUy
         3cGsXDLa0qHB7QS2MJHuCZZoNzA0a0ZNGRCahu+KuMZSrhchwuUXO5QUtvEY/BWrm51i
         9jI1zAfgtmW5fJSNdN2y+cW3nh7IklkE3th3v5LT78wvN0eQNfhwiSo1RrCzdhqcADqr
         oC3Dvv06KDyDVZ//F7KCiugQB7wWyeCi55C6C0+qA00+jRn2hzFsP6tdtn6bSYgmwmy5
         8AmhsOJJitWGq9JIgMk3qX8sHDkOewAzFxNXWovipD1FHoN4o0jOsqkxTMp7MBeA+3hb
         uPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718623729; x=1719228529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Jkpm02645RYjRIRJBnvvyY5Jtb+wCyxVPpAEdzZE5g=;
        b=Hb5hca9mNOZ/CT3PfWk2hL8phDWlfH5KGesrLtjBVXuqb9B/s58eSfkixxv3Fbcs9t
         N4KMgLnTSMWoG4loal5LSgp5WrPl9U1H4m2tX3s9DWTmbGksPZ/cYdHRAXmUp24s4qsw
         jwioHbci9qkPViR4yiOnjwLyc6EM4iaa+II1zEczwJKSUEHKQ6AcLmgbc+oFIP6GGkG6
         heDw3C54PkE6e2I7gbg8DWLfQr5a1/CBUUgThLF3PUOfKsqulflhxmmD7jr6K/NxP5Fa
         7UBZ5CI7s8NL52Eiak4TTL3IBTnOOWU8jsLkFupb6NkLuaDpnBoI5R4p78vEox944Arh
         kMxQ==
X-Gm-Message-State: AOJu0Yzdi6p/LUcAleh0pbhNNOmga7rdiZQO6oVj8dzxRlIf3aC9B8W+
	tjxhYe/qJKF0d0FnG2g+NBEqw9CfaecLUfy79V1M2JaJVhePzNskkvSBkzn2qeQEFWLis9skCtS
	D6ZBuHdx/iUiHTJgToHHEJEuo8uk=
X-Google-Smtp-Source: AGHT+IG65hgqOVvs1Mo9XukxhQQle4jdPARzN0PVdDEHGqWsx0DeDfTQzq85XtlLMcdflLL3Ac/rPYTGx87ijy0XJ+g=
X-Received: by 2002:a25:908:0:b0:dff:435b:ca99 with SMTP id
 3f1490d57ef6-dff435bcf8amr2535362276.41.1718623728686; Mon, 17 Jun 2024
 04:28:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240615044107.135012-1-llfamsec@gmail.com> <76e9f48b-8d23-45a5-8cba-1dc7d852781d@linux.alibaba.com>
In-Reply-To: <76e9f48b-8d23-45a5-8cba-1dc7d852781d@linux.alibaba.com>
From: lei lu <llfamsec@gmail.com>
Date: Mon, 17 Jun 2024 19:28:37 +0800
Message-ID: <CAEBF3_byijZ=63mhVOfo79h=zDeYvvbGJHNLVX0Srd-r_+vwLQ@mail.gmail.com>
Subject: Re: [PATCH v3] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, heming.zhao@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Got it. Thanks for your time.

Thanks,
LL

On Mon, Jun 17, 2024 at 5:58=E2=80=AFPM Joseph Qi <joseph.qi@linux.alibaba.=
com> wrote:
>
>
>
> On 6/15/24 12:41 PM, lei lu wrote:
> > This adds sanity checks for ocfs2_dir_entry to make sure all members of
> > ocfs2_dir_entry don't stray beyond valid memory region.
> >
> > Signed-off-by: lei lu <llfamsec@gmail.com>
> > ---
> >  fs/ocfs2/dir.c | 32 ++++++++++++++++++++------------
> >  1 file changed, 20 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> > index d620d4c53c6f..ada97ac6e2ea 100644
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
> I'd like move 'buf' and 'size' each to a new line.
> This is to be consistent with the existing code style.
>
> Other looks good. With the above comments addressed,
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
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
ytes, offset)) {
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
> > +                                                sb->s_blocksize, offse=
t)) {
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
> > +             if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, block=
size, offset)) {
> >                       status =3D -ENOENT;
> >                       goto bail;
> >               }
