Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DBF3AC13
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Sep 2023 22:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695162445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ji3zY74AAdaK/amC610EHUTsu6YY14D+u0Ic8yX0wF0=;
	b=aaYwhVx+5lYtGi5wLsgigFHYNq/AHjQYy/0tXNrn6SLwiyhd2QTcfUX5/RW77nXlcilRFl
	jak1Y7nqeCHwRU+YrRFBwkhSknzJwN26SoGdgL6VcORZqZQOMu4ypGp8Ycqt0+8XBtp9VU
	iyK+JNqOxZwQv1pTPlc6TNjc1BOWKGI=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-mdXMkH8RM5SKdUxogRGRlg-1; Tue, 19 Sep 2023 18:27:21 -0400
X-MC-Unique: mdXMkH8RM5SKdUxogRGRlg-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-578e2187f02so31273a12.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 19 Sep 2023 15:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695162441; x=1695767241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ji3zY74AAdaK/amC610EHUTsu6YY14D+u0Ic8yX0wF0=;
        b=RIs8Wy74laV1BZpS0mguo3luIO8uKoygjSsQ6QEEMeOZpivc1+n5gX3l1P/GZvHWr2
         KMYY5dbttSZs37fRHVaUDkv166erPbXqq3AyUNku8PqWGYT7H3sZCtOFExYh8mKXLAqH
         wPVBvWxOagnSuXjJY00/uRr+vNrQgJarna9Dlh3Cqo9KGLJFWMSn1YKVaSsT+Qee/17z
         MFTHYrcy8KEUNIjyc8lKL3aoEZLNSLtR8lVB774ENXllFDHH4vXGMiKHiTtl51il9KyN
         a820hyTnuKImajMn2pQJOGMR9aN/OZzLMZwGj2v3Hy4TJVW+C6RcEhYDex9EHvciPs9D
         SMrw==
X-Gm-Message-State: AOJu0YydMVDcGRobnG3w38KdgBFasc8z0qT6LFzTb7O+l9LgcVqHLmHf
	1Nj7kKcC2b3JF1QpdYYD+XEYsbL+Q2Wjw/XfqgLp5OZv6ysa/H9YVSQTPq/ywLNO2w56WvpZcA8
	rp0rygqLppNBB8rViFeLI7opvPzWe+CdORKTKMRY=
X-Received: by 2002:a05:6a21:7895:b0:13d:5b8e:db83 with SMTP id bf21-20020a056a21789500b0013d5b8edb83mr970438pzc.9.1695162440765;
        Tue, 19 Sep 2023 15:27:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvdFAMQ3u88UkWAe1LyDTaTZ9DZaFRmPuZojxyrc2071D47l1IiQLEM8pi3uRxKzn4ewwGY98liyEB7kMo1sI=
X-Received: by 2002:a05:6a21:7895:b0:13d:5b8e:db83 with SMTP id
 bf21-20020a056a21789500b0013d5b8edb83mr970415pzc.9.1695162440533; Tue, 19 Sep
 2023 15:27:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-8-willy@infradead.org>
In-Reply-To: <20230919045135.3635437-8-willy@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 20 Sep 2023 00:27:08 +0200
Message-ID: <CAHc6FU4-RSAsc-LWw2OuLDecofapd30OZhxyjVKLXzJNwh-ZoA@mail.gmail.com>
Subject: Re: [PATCH 07/26] gfs2; Convert gfs2_getjdatabuf to use a folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks,

but this patch has an unwanted semicolon in the subject.

On Tue, Sep 19, 2023 at 7:00=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> Use the folio APIs, saving four hidden calls to compound_head().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/gfs2/meta_io.c | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
> index f1fac1b45059..b28196015543 100644
> --- a/fs/gfs2/meta_io.c
> +++ b/fs/gfs2/meta_io.c
> @@ -400,26 +400,20 @@ static struct buffer_head *gfs2_getjdatabuf(struct =
gfs2_inode *ip, u64 blkno)
>  {
>         struct address_space *mapping =3D ip->i_inode.i_mapping;
>         struct gfs2_sbd *sdp =3D GFS2_SB(&ip->i_inode);
> -       struct page *page;
> +       struct folio *folio;
>         struct buffer_head *bh;
>         unsigned int shift =3D PAGE_SHIFT - sdp->sd_sb.sb_bsize_shift;
>         unsigned long index =3D blkno >> shift; /* convert block to page =
*/
>         unsigned int bufnum =3D blkno - (index << shift);
>
> -       page =3D find_get_page_flags(mapping, index, FGP_LOCK|FGP_ACCESSE=
D);
> -       if (!page)
> -               return NULL;
> -       if (!page_has_buffers(page)) {
> -               unlock_page(page);
> -               put_page(page);
> +       folio =3D __filemap_get_folio(mapping, index, FGP_LOCK | FGP_ACCE=
SSED, 0);
> +       if (IS_ERR(folio))
>                 return NULL;
> -       }
> -       /* Locate header for our buffer within our page */
> -       for (bh =3D page_buffers(page); bufnum--; bh =3D bh->b_this_page)
> -               /* Do nothing */;
> -       get_bh(bh);
> -       unlock_page(page);
> -       put_page(page);
> +       bh =3D folio_buffers(folio);
> +       if (bh)
> +               get_nth_bh(bh, bufnum);

And we need this here:

    bh =3D get_nth_bh(bh, bufnum);

> +       folio_unlock(folio);
> +       folio_put(folio);
>         return bh;
>  }
>
> --
> 2.40.1
>
>

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

