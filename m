Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA27E23A9
	for <ocfs2-devel@lists.linux.dev>; Tue, 18 Jun 2024 05:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718689604; cv=none; b=b1iFWuUBla/dRqp3zUhqmRlxcxNiAXLf4gdVVp2+640Q849pLptVvRYPKBw115hI3p27Zm1yHlLyfFhs2Hk0O3osvWbc0uvTv1f82f6NuZkM41NhMHil0aHgx3qB+ILXgrrzkiCg27s3d41/oBWFf/pEmXI4zOp/Tc4S+/mA1pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718689604; c=relaxed/simple;
	bh=uO1ohoITUl+855nI+R/Ikwx5V73VOPBNHFWha4YFbgQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WeKTWHa8T6n1g7KW4tI5p21MoxnN3jeAheP1/Feblqb4BJGdff3Or1hZht8bDxQ0B9WUsTcYTtdkJ52SqIT7caNV9kadWTP8mMdvJ9TIkB4MQDg8UUEX3V41tSB6x9r1YrKQYj7GGx9w7a5J+Mky52R4Wvx7pcpgt81X/jCWMkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W+Fn32GK; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+Fn32GK"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dff0c685292so4526871276.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 17 Jun 2024 22:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718689601; x=1719294401; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9QSG1D1NR/I9dCnJXoFojx4FjTUePkWZdD6gNSCUqo=;
        b=W+Fn32GKjCYwFWe/Ghysbcx5FyUs1awsnTGU+NmdmXk2IAmANAoCqd2tPk6PYYs79x
         hB1TV0PdmN7ziZdznxTY8jgn4GTTNsxDmRmdjAI8wwrvnStfe9Yiq97voexFE3q7ZoTo
         Dj8MuQfGJxqQh4Kmk/AzXfQDEkiMrBL2ZyRjnYPz11x8Q/FxDk8OVPqhxDu+Ut+5vjSi
         RHKx/LUkplo0Qlq6zWcocx1ie9nBIaVFrHdvGGzVFP9XHqDSkxm0aIB1fJkhZzhYpy+v
         F619+pMXX6t6nHppvPOT1qNg/FlpTnUPJrzsqXW8v8qS8pfQcpyD5dDvJqAADbzBJQ6/
         jIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718689601; x=1719294401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G9QSG1D1NR/I9dCnJXoFojx4FjTUePkWZdD6gNSCUqo=;
        b=qW01lQ1fQXVsw7aik0vgWtgxst0PZNEhCS8EgaRDbXrEN89VQ011jdA69xigOSw7U5
         OGQil26c2gx20qpC66Udt+/5RScfcEhKKIEPHWO5byxyy1PLyhgdgh3nTMDvYXVpis+H
         +T/WnirEpKtvN3I0MlqZUD5mzYpLrQ/6TwS3gnE4qsT0EEFPYyWm89tT321lw/3CAYv2
         cRX7BwALIyXHqoh+PmRfT1K5yHfPveTu3lP274+zZGImGBFHUtd+1AuQTivks8KpHYYh
         9DGEPKH0hLQP5sBUQ1od/8lTKMbKPSe9WYCu43IUhAKaKAZgpyEQLJMVy235R6dsk4Mx
         9MzA==
X-Forwarded-Encrypted: i=1; AJvYcCUb6gwgX/0NQrGzHrvHtd69eUvCPVk1PsX2Opkve5/o/qo6f/63Ko6si2qbTCwaKWo2toY0jeM1EyQpn3N8bbqFiidqRxiu5F9ga2A=
X-Gm-Message-State: AOJu0YxAt45fDxe5vREVqiJGZtnB08LBQa9uh2OxooCyYo6mZwovqCGT
	2Xe252eUcOqNX8vt1+5a1cClZBBftAggnsTTXSBqLOewnQ3FON1zTRDLC5lPb/T12NsAN0fb2xt
	ri2fTwHtASzhYFEYDM38uAxXUbYq0mQr4ej5APG8b
X-Google-Smtp-Source: AGHT+IGkidoY/gk0TpyUlvxgrSdfMrcQkJCyClSqyAnldVw9r13iw8m2DuZsoilUBfUZTVdMmgzHhVLIy6DhP9RfWMM=
X-Received: by 2002:a25:844c:0:b0:dff:322c:79ac with SMTP id
 3f1490d57ef6-dff322c7ea1mr7124422276.3.1718689601418; Mon, 17 Jun 2024
 22:46:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606065455.94846-1-llfamsec@gmail.com> <046696eb-4e56-4190-8295-d77a8b5cb522@linux.alibaba.com>
 <CAEBF3_bXhKw+CBsTQBonM3ZTSZB7hyTJiV6wrw7=3pieYT0DYg@mail.gmail.com> <34170f8b-7c72-4973-a047-dbe4efce10f8@suse.com>
In-Reply-To: <34170f8b-7c72-4973-a047-dbe4efce10f8@suse.com>
From: lei lu <llfamsec@gmail.com>
Date: Tue, 18 Jun 2024 13:46:28 +0800
Message-ID: <CAEBF3_Y8TGd4u8BA0-XWqY9JpPB4ta9J=U-KyaHkWNPJz0QaSQ@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: add bounds checking to ocfs2_check_dir_entry()
To: Heming Zhao <heming.zhao@suse.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2024 at 11:19=E2=80=AFAM Heming Zhao <heming.zhao@suse.com>=
 wrote:
>
> On 6/8/24 12:23, lei lu wrote:
> > On Sat, Jun 8, 2024 at 9:41=E2=80=AFAM Joseph Qi <joseph.qi@linux.aliba=
ba.com> wrote:
> >>
> >>
> >>
> >> On 6/6/24 2:54 PM, lei lu wrote:
> >>> This adds sanity checks for ocfs2_dir_entry to make sure all members =
of
> >>> ocfs2_dir_entry don't stray beyond valid memory region.
> >>>
> >>> Signed-off-by: lei lu <llfamsec@gmail.com>
> >>> ---
> >>>   fs/ocfs2/dir.c | 32 ++++++++++++++++++++------------
> >>>   1 file changed, 20 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> >>> index d620d4c53c6f..85966385d134 100644
> >>> --- a/fs/ocfs2/dir.c
> >>> +++ b/fs/ocfs2/dir.c
> >>> @@ -294,13 +294,14 @@ static void ocfs2_dx_dir_name_hash(struct inode=
 *dir, const char *name, int len,
> >>>    * bh passed here can be an inode block or a dir data block, depend=
ing
> >>>    * on the inode inline data flag.
> >>>    */
> >>> -static int ocfs2_check_dir_entry(struct inode * dir,
> >>> -                              struct ocfs2_dir_entry * de,
> >>> -                              struct buffer_head * bh,
> >>> +static int ocfs2_check_dir_entry(struct inode *dir,
> >>> +                              struct ocfs2_dir_entry *de,
> >>> +                              struct buffer_head *bh, char *buf, uns=
igned int size,
> >>
> >> Don't see why we have to pass 'buf' here.
> >> Seems it can be obtained from bh directly.
> >
> > We can not simply obtained de from bh->b_data. Because in
> > ocfs2_search_dirblock, the beginning of bh->b_data is ocfs2_dinode
> > (found in caller ocfs2_find_entry_id). But in ocfs2_find_dir_space_el,
> > we can see "de =3D (struct ocfs2_dir_entry *) bh->b_data;", which means
> > the beginning of bh->b_data is de directly. I'm not sure what's
> > causing this difference.
> >
> >>
> >>>                                 unsigned long offset)
> >>>   {
> >>>        const char *error_msg =3D NULL;
> >>>        const int rlen =3D le16_to_cpu(de->rec_len);
> >>> +     const unsigned long next_offset =3D ((char *) de - buf) + rlen;
> >>>
> >>>        if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
> >>>                error_msg =3D "rec_len is smaller than minimal";
> >>> @@ -308,6 +309,11 @@ static int ocfs2_check_dir_entry(struct inode * =
dir,
> >>>                error_msg =3D "rec_len % 4 !=3D 0";
> >>>        else if (unlikely(rlen < OCFS2_DIR_REC_LEN(de->name_len)))
> >>>                error_msg =3D "rec_len is too small for name_len";
> >>> +     else if (unlikely(next_offset > size))
> >>> +             error_msg =3D "directory entry overrun";
> >>> +     else if (unlikely(next_offset > size - OCFS2_DIR_REC_LEN(1)) &&
> >>> +              next_offset !=3D size)
> >>
> >> Seems we also have to consider meta ecc.
> >
> > Sorry, I'm not very familiar with this.
> >
> >>
> >>> +             error_msg =3D "directory entry too close to end";
> >>>        else if (unlikely(
> >>>                 ((char *) de - bh->b_data) + rlen > dir->i_sb->s_bloc=
ksize))
> >>>                error_msg =3D "directory entry across blocks";
> >>> @@ -352,16 +358,16 @@ static inline int ocfs2_search_dirblock(struct =
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
 bytes offset)) {
> >>
> >> It looks buggy, even cannot compile.
> >> Have you compiled and then verified with your POC?
> >
> > I have compiled and tested it. And I got an output as below:
> > root@syzkaller:~# mount -o loop ocfs2-test.img /mnt/ocfs2-test
> > [  116.777184] loop0: detected capacity change from 0 to 40960
> > [  116.843546] (mount,232,0):ocfs2_init_global_system_inodes:461
> > ERROR: status =3D -22
> > [  116.843946] (mount,232,0):ocfs2_init_global_system_inodes:462
> > ERROR: Unable to load system inode ?
> > [  116.844001] (mount,232,0):ocfs2_init_global_system_inodes:472
> > ERROR: status =3D -22
> > [  116.844821] (mount,232,0):ocfs2_initialize_super:2251 ERROR: status =
=3D -22
> > [  116.845590] (mount,232,0):ocfs2_fill_super:1176 ERROR: status =3D -2=
2
> > mount: /mnt/ocfs2-test: wrong fs type, bad option, bad superblock on
> > /dev/loop0, missing codepage or.
> >
> > The ocfs2_check_dir_entry was not called because "de->name + namelen
> > <=3D dlimit && ocfs2_match(namelen, name, de)" was not meet. I think
> > "while (de_buf < dlimit - OCFS2_DIR_MEMBER_LEN)" has taken effect, and
> > we got an error elsewhere.
> >
>
> Hi,
>
> I am not agree with the above statement. Based on your test, (applied thi=
s
> patch), there must be another issue preventing the mount from succeeding.
> "mount -o loop" command shouldn't cause an error in this case.

Hi,

Here is a security report about this issue.

In ocfs2_search_dirblock, it traverses de (ocfs2_dir_entry) depends on
de->rec_len. And it just check start address of de < dlimit. So if I
leave 1 byte of space in the current block, In the next traversal,
this space will be considered as de and access de->rec_len in "de_len
=3D le16_to_cpu(de->rec_len);".

PoC as below:
1. I found when I mount an image. The parameters for the first call to
ocfs2_search_dirblock is as follows:
    bytes: 0x338
    first_de: xx
    offset: 0x0
    namelen: 0x12
    name: global_inode_alloc <--
    dir: xx
    bh: xx
2. I found the corresponding ocfs2_dinode on the disk:
    ocfs2_dinode start at 0x2800
    ...
    ocfs2_dinode.i_size: 0x338 (824)
    ...
    ocfs2_dir_entry[0] 0x28c8
        ocfs2_dir_entry.inode: 0xa
        ocfs2_dir_entry.rec_len: 0x10
        ocfs2_dir_entry.name_len: 0x1
        ocfs2_dir_entry.file_type: 0x2
        ocfs2_dir_entry.name[255]: .
    ocfs2_dir_entry[1] 0x28d8
        ocfs2_dir_entry.inode: 0xa
        ocfs2_dir_entry.rec_len: 0x10
        ocfs2_dir_entry.name_len: 0x2
        ocfs2_dir_entry.file_type: 0x2
        ocfs2_dir_entry.name[255]: ..
    ocfs2_dir_entry[2] 0x28e8
        ocfs2_dir_entry.inode: 0xb
        ocfs2_dir_entry.rec_len: 0x18
        ocfs2_dir_entry.name_len: 0xa
        ocfs2_dir_entry.file_type: 0x1
        ocfs2_dir_entry.name[255]: bad_blocks
    ocfs2_dir_entry[3] 0x2900
        ocfs2_dir_entry.inode: 0xc
        ocfs2_dir_entry.rec_len: 0x20
        ocfs2_dir_entry.name_len: 0x12
        ocfs2_dir_entry.file_type: 0x1
        ocfs2_dir_entry.name[255]: global_inode_alloc
        ...
3. I change some values:
    ocfs2_dinode start at 0x2800
    ...
    ocfs2_dinode.i_size: 0xf38 <-- 0xf38 + sizeof(ocfs2_dinode) +
sizeof(ocfs2_inline_data) =3D 0x1000
    ...
    ocfs2_dir_entry[0] 0x28c8
        ocfs2_dir_entry.inode: 0xa
        ocfs2_dir_entry.rec_len: 0x10
        ocfs2_dir_entry.name_len: 0x1
        ocfs2_dir_entry.file_type: 0x2
        ocfs2_dir_entry.name[255]: .
    ocfs2_dir_entry[1] 0x28d8
        ocfs2_dir_entry.inode: 0xa
        ocfs2_dir_entry.rec_len: 0x10
        ocfs2_dir_entry.name_len: 0x2
        ocfs2_dir_entry.file_type: 0x2
        ocfs2_dir_entry.name[255]: ..
    ocfs2_dir_entry[2] 0x28e8
        ocfs2_dir_entry.inode: 0xb
        ocfs2_dir_entry.rec_len: 0xf17 <-- 0x2800+0x1000-0x28e8-1=3D0xf17
        ocfs2_dir_entry.name_len: 0xa
        ocfs2_dir_entry.file_type: 0x1
        ocfs2_dir_entry.name[255]: bad_blocks
    ocfs2_dir_entry[3] 0x2900
        ocfs2_dir_entry.inode: 0xc
        ocfs2_dir_entry.rec_len: 0x20
        ocfs2_dir_entry.name_len: 0x12
        ocfs2_dir_entry.file_type: 0x1
        ocfs2_dir_entry.name[255]: global_inode_alloc
        ...

I create a PoC on the corresponding ocfs2_dinode. It seems to be
searching for global_inode_alloc, and we couldn't find it (Before
patch, it triggered out-of-bound read, After patch, it also skip it
because of ocfs2_dir_entry[2].rec_len). So we got an error
"ocfs2_init_global_system_inodes:462 ERROR: Unable to load system
inode ?".

>
> -Heming
