Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAFC6CDB1
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 06:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718692379; cv=none; b=nWwcnPBoBYKphnY0b1yTgxtzmp7Akj/gkIuneVA5cr2PNb2P46eTtpTHN96szFJZv9avg4gnT+KLjhzoxuO4zGLSfX5sY/zmAmuzUyqLBvorLWnGeGXO74DLmxiLbw4DvgnOfai0pyP0SXnp5L5bKL6YnnKFCsMLiRmwmoRk/r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718692379; c=relaxed/simple;
	bh=jlWaL7Q2QCu+cEZbXFOZ1ZJbIOajmrF+vEqC/wI7m+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=imWOQKf/QxGzwi67jfPmxDfBqCTRC4Oum+lKxmKEbFJYxyHcv+Tzj1iemEjfDNMykruIFLE5ioTjVCravcQRCw+SGxzmz8qaZRsCiNryBdZqaIqqjtAek0v2Y3VZG/sO7b5yZ/Zdyz0XLBQRbE+divRe+ch5pxWNNvN+i1PGs0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D9ol7/ud; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D9ol7/ud"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-df481bf6680so5490743276.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 23:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718692377; x=1719297177; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0bpSdZiZ0Z7cteXKj4HCY0D0K6oodciMUpiiLFhkH3U=;
        b=D9ol7/udYan94qfknkbfyE95JPkQwLxaxjzI2zurl6/m8og9DkkmRZBrPRlIZ5ZNfR
         czQktnNA9rEyzR7q6Y7urzzDUS9TKxpH4XgtCb+Rv2A7NEzwIKWdqWZ6TFxECk9SWzFO
         Oj8ru1LYbIQPu8DhIWly9qF5m9mzif4NI+c3AsUxb2MMSMp6dzsYlR9GxC6L9QoxqxFT
         LNoxKJRthzU75xsDmApPDaLE72BtOYcolC9msPTxZt3sg97Q5BicItPtR7Ug3lQICCHc
         e7ksyCo+blvxEuaQWT49bP7NsP12SWGO0TA6D4zWjFytkAXsmaXNClkT5k1BZydROZbX
         U7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718692377; x=1719297177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0bpSdZiZ0Z7cteXKj4HCY0D0K6oodciMUpiiLFhkH3U=;
        b=tMZg8pFORqzaN857Fan4i0bYsIhP+5i3u18e+CdgdmmCItSNPc4HpMhrsIYf4N0P6q
         uc0RdyhGuT/mttlygzZrFIrLEaC+uD8TN4yOnDOSv8P8o2EvAkmI85bMJO2uOrhysxcj
         e8nHpWD+F73mYi8y141OmJboxVGIyYHj6ykZ/3oXqZ79cVgofuE7w4AopNjLt+GXVaof
         gcO5lkj/1Av2HYwk5u3n8QFBLpfpRCNfcaOFThfTqRGoaG/PKwzZ7lmms0cxm7LQAhsh
         sYZi9cPpCpqvra9lOqzMYvsoyNEfHhyO4KW/qLt6hSAK4UScnsKe8ioa4+UYtS2XDW2x
         IKGg==
X-Forwarded-Encrypted: i=1; AJvYcCV0uEx/TyGPEAF6SB4sSztK276HS7QzrSC3Y5RWjB2S+WfnP3g7KDZQXKJnd52pI0poYq38DObtkf867CUKTtUES84+GqvcSmaDeu4=
X-Gm-Message-State: AOJu0YxmdfzSALd73Mk35QjgarcJr4dkEtEuCzdazObHPxwhnSjxpSIz
	evkuO37CgkzDli8Dwz4glzqozxXzKuEl5NQoMM6KFc7by6agphBOK2MaXJHxWKp0CJLeWh79+80
	2zkL/6Y0s8Taz1evO9X6xXU6FWbI=
X-Google-Smtp-Source: AGHT+IEA5spVfSWF4nYplb2kskleYfB0fZoAdwP38lWtdMGVQ8U41wDbyXWfMumQZGLxZ+PQt5DqidbH+4JHhKNndBI=
X-Received: by 2002:a25:6953:0:b0:df4:e6db:d411 with SMTP id
 3f1490d57ef6-dff1537e372mr11945385276.20.1718692377107; Mon, 17 Jun 2024
 23:32:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240617114027.139982-1-llfamsec@gmail.com> <c5a6ab63-884a-4328-bfbe-7045f5469141@suse.com>
 <CAEBF3_be2K059_WqisKXUL-mm9-vqXshzrkGpc1-7AVdB=xcVQ@mail.gmail.com>
 <106d3676-d689-45a6-bdfb-f0db1a020ed4@suse.com> <CAEBF3_ay8oXvM1RNNVvUUG3ju8aEN6ve0yCJbKm8ZoxSJJi59Q@mail.gmail.com>
In-Reply-To: <CAEBF3_ay8oXvM1RNNVvUUG3ju8aEN6ve0yCJbKm8ZoxSJJi59Q@mail.gmail.com>
From: lei lu <llfamsec@gmail.com>
Date: Tue, 18 Jun 2024 14:32:46 +0800
Message-ID: <CAEBF3_YYM85TzD6r+fMP3Yyb-15g2QAQ8y45DD_f6NfG07zMkQ@mail.gmail.com>
Subject: Re: [PATCH v4] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: Heming Zhao <heming.zhao@suse.com>
Cc: joseph.qi@linux.alibaba.com, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Do you have further comments and/or suggestions? I will remake the
patch to fix the issue in case <1>.

Thanks,
LL

On Tue, Jun 18, 2024 at 2:20=E2=80=AFPM lei lu <llfamsec@gmail.com> wrote:
>
> On Tue, Jun 18, 2024 at 2:13=E2=80=AFPM Heming Zhao <heming.zhao@suse.com=
> wrote:
> >
> > On 6/18/24 13:58, lei lu wrote:
> > > On Tue, Jun 18, 2024 at 11:29=E2=80=AFAM Heming Zhao <heming.zhao@sus=
e.com> wrote:
> > >>
> > >> On 6/17/24 19:40, lei lu wrote:
> > >>> This adds sanity checks for ocfs2_dir_entry to make sure all member=
s of
> > >>> ocfs2_dir_entry don't stray beyond valid memory region.
> > >>>
> > >>> Signed-off-by: lei lu <llfamsec@gmail.com>
> > >>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > >>> ---
> > >>>    fs/ocfs2/dir.c | 34 ++++++++++++++++++++++------------
> > >>>    1 file changed, 22 insertions(+), 12 deletions(-)
> > >>>
> > >>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> > >>> index d620d4c53c6f..562f61daf77d 100644
> > >>> --- a/fs/ocfs2/dir.c
> > >>> +++ b/fs/ocfs2/dir.c
> > >>> @@ -294,13 +294,16 @@ static void ocfs2_dx_dir_name_hash(struct ino=
de *dir, const char *name, int len,
> > >>>     * bh passed here can be an inode block or a dir data block, dep=
ending
> > >>>     * on the inode inline data flag.
> > >>>     */
> > >>> -static int ocfs2_check_dir_entry(struct inode * dir,
> > >>> -                              struct ocfs2_dir_entry * de,
> > >>> -                              struct buffer_head * bh,
> > >>> +static int ocfs2_check_dir_entry(struct inode *dir,
> > >>> +                              struct ocfs2_dir_entry *de,
> > >>> +                              struct buffer_head *bh,
> > >>> +                              char *buf,
> > >>> +                              unsigned int size,
> > >>>                                 unsigned long offset)
> > >>>    {
> > >>>        const char *error_msg =3D NULL;
> > >>>        const int rlen =3D le16_to_cpu(de->rec_len);
> > >>> +     const unsigned long next_offset =3D ((char *) de - buf) + rle=
n;
> > >>
> > >> from this patch, there are two cases for the parameter 'buf':
> > >>
> > >> 1>
> > >> 'de' is the same as 'bh', de & bh both are the latest dir_entry offs=
et.
> > >> the sanity check always passes below cases. e.g:
> > >> - ocfs2_search_dirblock()
> > >> - ocfs2_find_dir_space_id()
> > >
> > > Thanks for your time.
> > >
> > > Sorry, I don't quite understand what you mean.
> >
> > Oh, sorry for my typo, my mean: 'de' is the same as 'buf' not 'bh'.
> >
> > The patch code in ocfs2_search_dirblock() is:
> >    if (!ocfs2_check_dir_entry(dir, de, bh, de_buf, bytes, offset))
> >
> > the de is same as de_buf, so in ocfs2_check_dir_entry() the next_offset=
 becomes
> >    next_offset =3D rlen; //because "de =3D=3D de_buf"
> >
> > In this case, rlen is not the current dir entry end boundary.
> >
> > > I think 'de' is not the same as 'bh'. e.g.:
> > > - ocfs2_search_dirblock(): de is the latest dir_entry offset, bh is
> > > the ocfs2_dinode offset, buf is the first dir_entry offset
> >
> > buf is not the first dir_entry offset.
> >
> > > - ocfs2_find_dir_space_id(): de is the latest dir_entry offset, bh is
> > > the ocfs2_dinode offset, buf is the first dir_entry offset
> >
> > ditto
>
> Oh, you are right, We should use first_de here.
>
> Thanks,
> LL
>
> >
> > -Heming
> > >
> > > Thanks,
> > > LL
> > >
> > >>
> > >> 2>
> > >> 'de' is different with 'bh', bh is the first dir_entry offset, de is
> > >> the latest offset. these cases should be the expected code paths, e.=
g:
> > >> - __ocfs2_delete_entry()
> > >> - ocfs2_dir_foreach_blk_id()
> > >> - ocfs2_dir_foreach_blk_el()
> > >> - ocfs2_find_dir_space_el()
> > >>
> > >> If my thinking is right, case <1> needs to be revised to follow the =
design.
> > >>
> > >> -Heming
> > >>>
> > >>>        if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
> > >>>                error_msg =3D "rec_len is smaller than minimal";
> > >>> @@ -308,6 +311,11 @@ static int ocfs2_check_dir_entry(struct inode =
* dir,
> > >>>                error_msg =3D "rec_len % 4 !=3D 0";
> > >>>        else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
> > >>>                error_msg =3D "rec_len is too small for name_len";
> > >>> +     else if (unlikely(next_offset > size))
> > >>> +             error_msg =3D "directory entry overrun";
> > >>> +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) =
&&
> > >>> +              next_offset !=3D size)
> > >>> +             error_msg =3D "directory entry too close to end";
> > >>>        else if (unlikely(
> > >>>                 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_bl=
ocksize))
> > >>>                error_msg =3D "directory entry across blocks";
> > >>> @@ -352,16 +360,16 @@ static inline int ocfs2_search_dirblock(struc=
t buffer_head *bh,
> > >>>        de_buf =3D first_de;
> > >>>        dlimit =3D de_buf + bytes;
> > >>>
> > >>> -     while (de_buf < dlimit) {
> > >>> +     while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN) {
> > >>>                /* this code is executed quadratically often */
> > >>>                /* do minimal checking `by hand' */
> > >>>
> > >>>                de =3D (struct ocfs2_dir_entry *) de_buf;
> > >>>
> > >>> -             if (de_buf + namelen <=3D dlimit &&
> > >>> +             if (de->name + namelen <=3D dlimit &&
> > >>>                    ocfs2_match(namelen, name, de)) {
> > >>>                        /* found a match - just to be sure, do a ful=
l check */
> > >>> -                     if (!ocfs2_check_dir_entry(dir, de, bh, offse=
t)) {
> > >>> +                     if (!ocfs2_check_dir_entry(dir, de, bh, de_bu=
f, bytes, offset)) {
> > >>>                                ret =3D -1;
> > >>>                                goto bail;
> > >>>                        }
> > >>> @@ -1138,7 +1146,7 @@ static int __ocfs2_delete_entry(handle_t *han=
dle, struct inode *dir,
> > >>>        pde =3D NULL;
> > >>>        de =3D (struct ocfs2_dir_entry *) first_de;
> > >>>        while (i < bytes) {
> > >>> -             if (!ocfs2_check_dir_entry(dir, de, bh, i)) {
> > >>> +             if (!ocfs2_check_dir_entry(dir, de, bh, first_de, byt=
es, i)) {
> > >>>                        status =3D -EIO;
> > >>>                        mlog_errno(status);
> > >>>                        goto bail;
> > >>> @@ -1635,7 +1643,7 @@ int __ocfs2_add_entry(handle_t *handle,
> > >>>                /* These checks should've already been passed by the
> > >>>                 * prepare function, but I guess we can leave them
> > >>>                 * here anyway. */
> > >>> -             if (!ocfs2_check_dir_entry(dir, de, insert_bh, offset=
)) {
> > >>> +             if (!ocfs2_check_dir_entry(dir, de, insert_bh, data_s=
tart, size, offset)) {
> > >>>                        retval =3D -ENOENT;
> > >>>                        goto bail;
> > >>>                }
> > >>> @@ -1774,7 +1782,8 @@ static int ocfs2_dir_foreach_blk_id(struct in=
ode *inode,
> > >>>                }
> > >>>
> > >>>                de =3D (struct ocfs2_dir_entry *) (data->id_data + c=
tx->pos);
> > >>> -             if (!ocfs2_check_dir_entry(inode, de, di_bh, ctx->pos=
)) {
> > >>> +             if (!ocfs2_check_dir_entry(inode, de, di_bh, (char *)=
data->id_data,
> > >>> +                                        i_size_read(inode), ctx->p=
os)) {
> > >>>                        /* On error, skip the f_pos to the end. */
> > >>>                        ctx->pos =3D i_size_read(inode);
> > >>>                        break;
> > >>> @@ -1867,7 +1876,8 @@ static int ocfs2_dir_foreach_blk_el(struct in=
ode *inode,
> > >>>                while (ctx->pos < i_size_read(inode)
> > >>>                       && offset < sb->s_blocksize) {
> > >>>                        de =3D (struct ocfs2_dir_entry *) (bh->b_dat=
a + offset);
> > >>> -                     if (!ocfs2_check_dir_entry(inode, de, bh, off=
set)) {
> > >>> +                     if (!ocfs2_check_dir_entry(inode, de, bh, bh-=
>b_data,
> > >>> +                                                sb->s_blocksize, o=
ffset)) {
> > >>>                                /* On error, skip the f_pos to the
> > >>>                                   next block. */
> > >>>                                ctx->pos =3D (ctx->pos | (sb->s_bloc=
ksize - 1)) + 1;
> > >>> @@ -3359,7 +3369,7 @@ static int ocfs2_find_dir_space_id(struct ino=
de *dir, struct buffer_head *di_bh,
> > >>>        while (de_buf < limit) {
> > >>>                de =3D (struct ocfs2_dir_entry *)de_buf;
> > >>>
> > >>> -             if (!ocfs2_check_dir_entry(dir, de, di_bh, offset)) {
> > >>> +             if (!ocfs2_check_dir_entry(dir, de, di_bh, de_buf, i_=
size_read(dir), offset)) {
> > >>>                        ret =3D -ENOENT;
> > >>>                        goto out;
> > >>>                }
> > >>> @@ -3441,7 +3451,7 @@ static int ocfs2_find_dir_space_el(struct ino=
de *dir, const char *name,
> > >>>                        /* move to next block */
> > >>>                        de =3D (struct ocfs2_dir_entry *) bh->b_data=
;
> > >>>                }
> > >>> -             if (!ocfs2_check_dir_entry(dir, de, bh, offset)) {
> > >>> +             if (!ocfs2_check_dir_entry(dir, de, bh, bh->b_data, b=
locksize, offset)) {
> > >>>                        status =3D -ENOENT;
> > >>>                        goto bail;
> > >>>                }
> > >>
> >
