Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BE11FF7D7
	for <ocfs2-devel@lists.linux.dev>; Fri, 28 Nov 2025 06:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764309920; cv=none; b=qloV/TFb6tPIrlVTVOMVggAaBBnHofLILDEZJ4RhCc4mBYlo0MpUjM0C6I/HQSUzlq5gxXc++pJEUfYxi5JLk/SYVDiOC1f0jcAR0ffJhF9y4tCa/d3RdN97n0xCjigo22O5I0CQYVOhPOGMcPIMLXL12YofH2O2WgQwtwRZ3yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764309920; c=relaxed/simple;
	bh=YQKIhGZkLraDZxZ3a1tWS6jiGoYSq2d5CLqycbWtpEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DaIS4DcV7R/TLLtpmK8yZVuBhBWDCCpjmqWrkaw3ORAcOj2KxyM/CLkYUjRO8+EtjCs3hY6g7kKosNc/GXEO9zmux7Zb322ipThzjRUoPPjg9XleMgXs/GTfE7Kjz5htPtPrcd/zdmx3LqJxk5jGPI/4r1wEO0pRuzEVMOGet84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QFHyX5uC; arc=none smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QFHyX5uC"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-64306a32ed2so1235602d50.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 27 Nov 2025 22:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764309918; x=1764914718; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2CEpEb7Rliujg9hBWny3N2GoV/BLU6MgF0lrLoy6yk=;
        b=QFHyX5uCBx4MnuuUW4AL8uZ3aoNYIO/WOlIqvGtX8BAccIRmUGZT/6ceqyK2utZJJN
         Ojjo+ThEAkRUJxPukpuzGjPZSTGCQKfXGfbeAvl99TBN/D7R5DiGtQUSr6XURlh8YH+Q
         6vGyqfzJEhOcKkq/QIfLDlXq7r3InNtjCfgyjD6Dalc/E16a8Fp1DMRNxTszx6KStPDR
         Fb/40HC2IvAl+vO64wG1KCyV1vQAhp8ayS2cAd3QD9g9kzw+tfdk+ri6FSWHFVmYUe8k
         nc9nNLvA3w3J9+hCuO8FmvM5qf8sQ2lyckyZW0ECUSlBv5VuysZsICJ3a71voHaN82BU
         hbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764309918; x=1764914718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q2CEpEb7Rliujg9hBWny3N2GoV/BLU6MgF0lrLoy6yk=;
        b=FIdEVIbdLz68BJvOum26G9zz7r3wtTYX4T0d7r4ywhomX6PEhztnciUvANtQrMaPW1
         s8EkaOo0WYxTfHmhJQYls6cM63izYZUXOTpKuXxre4/LLdmYKvGfr4+XmZboeBbfZfsk
         98RbKVR2Kg6DKdfNlaFmlLsyVZQ9h6tsbzmSS0nYozhSNPUk6ocD3VsJ752ErmkCik3Q
         W+dY+20usfGfV0sfYIK0mkpTfhkQcZDK2X1v5auVQ44gJQxnJOMVSe6htVozaDJDDmva
         Q/TIbgOYavJm8gHrAjTRZyqSEIZz57M3SAGsx5y9soOr5rGkgXC9xQh9VJS7rZ5ar7Lw
         pyGQ==
X-Gm-Message-State: AOJu0Yw1EQ9N1JupaZxP2BarQv7uwDnGOGP9wzYKtZWlZGUv9OSBP491
	lTmHXFbZIbv3TDVkuFR+0Ynr/AAMs1Y8vPQoem2ErgKRtqwpYNmP+bXis+d/9rpuJyCB3gL4Cs0
	Z5u9fx5Y7VwDCqIjt+tsDy2Oi1fWxWTc=
X-Gm-Gg: ASbGncu9jiD9aw72z3vy5Pp0dsYfCT/6KjpJLZ5HWHmbm3+DvbLc0bHR8WH+95L4ZAE
	XCFO7YRdooRRrcvCMZIEHvaHsMOd6afa+0cNp14Wj292y2BBJ131l3BuFcu2C5LCv/iM/rFRrxJ
	3JK5hqKrR7V+y2Ca/T31OYZmYltbmGxgBoUhIc2F83XFwJTKChfd58da4zMESIqTsLwGg4Jb1O0
	rgw+k6piG9pkZ8x5Wlx91ERmQsx6Mc4CMSREZ2HUllcm+sxcKmQkBb9lPbhPFSqEUmxFBFQdwAz
	x3vj+DvcQnPKvprBjNDDRv4zx2vW
X-Google-Smtp-Source: AGHT+IEV6Fsy/Zp+o4l+MuMkiAy3s4WhIpKcW60AWiYS1WppqFNp4lSqDFnbtXpRUt+75V11KFfcNm3QtI86ikZAxek=
X-Received: by 2002:a53:b849:0:b0:63f:99b1:3a83 with SMTP id
 956f58d0204a3-64302ac94a1mr13702295d50.61.1764309917970; Thu, 27 Nov 2025
 22:05:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251120041145.33176-1-kartikey406@gmail.com> <2frdco53wk4kj5x6wpfsaqm5qswvsgqa72ex7qsp3zuppltsoh@bvt2zaom5w2t>
In-Reply-To: <2frdco53wk4kj5x6wpfsaqm5qswvsgqa72ex7qsp3zuppltsoh@bvt2zaom5w2t>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Fri, 28 Nov 2025 11:35:05 +0530
X-Gm-Features: AWmQ_bn2zn24-lhIsm0fWjUOIE4D-Q2Hic4Z9yUOGC5XrJtUyOZBbWIt_rCYozA
Message-ID: <CADhLXY7+rJwz=AnZ_GYAZZuKn_5_KMSkSx5_aYuiqcO58ZiLtA@mail.gmail.com>
Subject: Re: [PATCH v4] ocfs2: validate inline xattr size and entry count in ocfs2_xattr_ibody_list
To: Heming Zhao <heming.zhao@suse.com>, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2025 at 12:19=E2=80=AFPM Heming Zhao <heming.zhao@suse.com>=
 wrote:
>
> On Thu, Nov 20, 2025 at 09:41:45AM +0530, Deepanshu Kartikey wrote:
> > Add comprehensive validation of inline xattr metadata in
> > ocfs2_xattr_ibody_list() to prevent out-of-bounds access and
> > use-after-free bugs when processing corrupted inline xattrs.
> >
> > The patch adds two critical validations:
> >
> > 1. Validates i_xattr_inline_size before use:
> >    - Ensures it does not exceed block size
> >    - Ensures it is at least large enough for xattr header
> >    - Prevents pointer arithmetic with corrupted size values that could
> >      point outside the inode block
> >
> > 2. Validates xattr entry count (xh_count):
> >    - Calculates maximum entries that can fit in the inline space
> >    - Rejects counts that exceed this limit
> >    - Prevents out-of-bounds array access in subsequent code
> >
> > Without these checks, a corrupted filesystem with invalid inline xattr
> > metadata can cause the code to access memory beyond the allocated space=
.
> > For example:
> > - A corrupted i_xattr_inline_size of 0 would cause header pointer
> >   calculation to point past the end of the block
> > - A corrupted xh_count of 22 with inline_size of 256 would cause
> >   array access 7 entries beyond the 15 that actually fit (the syzbot
> >   reproducer used xh_count of 20041), leading to use-after-free when
> >   accessing freed memory pages
> >
> > The validation uses the correct inline_size (from di->i_xattr_inline_si=
ze)
> > rather than block size, ensuring accurate bounds checking for inline
> > xattrs specifically.
> >
> > Reported-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Dab0ad25088673470d2d9
> > Tested-by: syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
> > Suggested-by: Heming Zhao <heming.zhao@suse.com>
> > Link: https://lore.kernel.org/all/20251111073831.2027072-1-kartikey406@=
gmail.com/ [v1]
> > Link: https://lore.kernel.org/all/20251117063217.5690-1-kartikey406@gma=
il.com/ [v2]
> > Link: https://lore.kernel.org/all/20251117114224.12948-1-kartikey406@gm=
ail.com/ [v3]
> > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
>
> LGTM
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
>
> > ---
> > Changes in v4:
> >  - Corrected commit message example: max entries is 15, not 7
> >    (pointed out by Heming Zhao)
> >
> > Changes in v3:
> >  - Moved validation from ocfs2_xattr_list_entries() to
> >    ocfs2_xattr_ibody_list() to use correct inline size calculation
> >    (suggested by Heming Zhao)
> >  - Added validation of i_xattr_inline_size before use
> >  - Added validation of xattr entry count against inline space
> >  - Changed return value to -EFSCORRUPTED for consistency
> > ---
> >  fs/ocfs2/xattr.c | 30 ++++++++++++++++++++++++++++--
> >  1 file changed, 28 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> > index d70a20d29e3e..98fd4f3f2d2d 100644
> > --- a/fs/ocfs2/xattr.c
> > +++ b/fs/ocfs2/xattr.c
> > @@ -971,13 +971,39 @@ static int ocfs2_xattr_ibody_list(struct inode *i=
node,
> >       struct ocfs2_xattr_header *header =3D NULL;
> >       struct ocfs2_inode_info *oi =3D OCFS2_I(inode);
> >       int ret =3D 0;
> > +     u16 xattr_count;
> > +     size_t max_entries;
> > +     u16 inline_size;
> >
> >       if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
> >               return ret;
> >
> > +     inline_size =3D le16_to_cpu(di->i_xattr_inline_size);
> > +
> > +     /* Validate inline size is reasonable */
> > +     if (inline_size > inode->i_sb->s_blocksize ||
> > +         inline_size < sizeof(struct ocfs2_xattr_header)) {
> > +             ocfs2_error(inode->i_sb,
> > +                         "Invalid xattr inline size %u in inode %llu\n=
",
> > +                         inline_size,
> > +                         (unsigned long long)OCFS2_I(inode)->ip_blkno)=
;
> > +             return -EFSCORRUPTED;
> > +     }
> > +
> >       header =3D (struct ocfs2_xattr_header *)
> > -              ((void *)di + inode->i_sb->s_blocksize -
> > -              le16_to_cpu(di->i_xattr_inline_size));
> > +              ((void *)di + inode->i_sb->s_blocksize - inline_size);
> > +
> > +     xattr_count =3D le16_to_cpu(header->xh_count);
> > +     max_entries =3D (inline_size - sizeof(struct ocfs2_xattr_header))=
 /
> > +                    sizeof(struct ocfs2_xattr_entry);
> > +
> > +     if (xattr_count > max_entries) {
> > +             ocfs2_error(inode->i_sb,
> > +                         "xattr entry count %u exceeds maximum %zu in =
inode %llu\n",
> > +                         xattr_count, max_entries,
> > +                         (unsigned long long)OCFS2_I(inode)->ip_blkno)=
;
> > +             return -EFSCORRUPTED;
> > +     }
> >
> >       ret =3D ocfs2_xattr_list_entries(inode, header, buffer, buffer_si=
ze);
> >
> > --
> > 2.43.0
> >




Hi Joseph, Mark, Joel,

Gentle ping on this patch. It has been reviewed and approved by Heming:

  Reviewed-by: Heming Zhao <heming.zhao@suse.com>

This patch fixes a syzbot-reported use-after-free bug in OCFS2 inline
xattr handling. The fix adds validation of i_xattr_inline_size and
xh_count before use to prevent out-of-bounds access.

Should I resend with the Reviewed-by tag included, or is there anything
else needed for this to be picked up?

Thanks,
Deepanshu

Link: https://lore.kernel.org/all/20251120041145.33176-1-kartikey406@gmail.=
com/T/
[v4]
