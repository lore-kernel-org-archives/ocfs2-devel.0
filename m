Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A1B3C691
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Sep 2023 22:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695162747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0x5XQwTZHDcZyZxqW3gmQpgHS2gIGGzK97rIzkAXl3Q=;
	b=feAAS7O1g6lGUrDRMBJUFVi4qbugbyNyRFrzIlOg9OIfjWicBCWg6eAL9KgD4DOskL1Ajf
	6+PsCQTwpQyd6WAKR8eyPvPMUhrVou6KNz5rj8bAtR3ohO9n1uRJebzUuSu6arXCCQMeg3
	4r9aPEw1co6HvKjIyhx96JOeUe488/k=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-uc2Jmv5kNOKjSjtMtdnM4Q-1; Tue, 19 Sep 2023 18:32:25 -0400
X-MC-Unique: uc2Jmv5kNOKjSjtMtdnM4Q-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1c3d8bd4aa5so2075365ad.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 19 Sep 2023 15:32:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695162744; x=1695767544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0x5XQwTZHDcZyZxqW3gmQpgHS2gIGGzK97rIzkAXl3Q=;
        b=mp4E1iZorFraJe4467ZrwrzGCbTozYjybEoZZAqHDXaZt+PepfV21tz2HWY3MbrtbM
         c6i3CWnCur9oyP25mJ/jzYZCHa3OjsGiCcWJkhpcqzT/Y/YBypsVXNxemj2zZKNZiC79
         2FaxA6l2IzpxPXM48t/roVMvxTXTjzWyqyLf40/qXLfw20v1BSacx09I7m3ncs34tzTS
         IpNn2Eu+64YVC7Wq2d2zukRMjNiDXmc6fhJYNWrrOnewNh8rzbvJY8p/sUinEw8UQhvE
         9a0cGdcMkMw3VA/cJZJbPJ0CH4rKhbkT63npmnm2g5oFxmcz0sXsgfgv9IQOWzRVOsI1
         X1bw==
X-Gm-Message-State: AOJu0YxzlNn+siwAtdbTL360NSJVAiY9THXNZqoqVSNeYjtgfp+gv0jI
	ppZYpQbZdnKbLUuB97hrV7XOo3T03pcdk+xgT1TCu0QKGQlmw6+/nAvOcrIr9p+bX/HOYXZR3rJ
	GUceRutOREu53cp3F3qZEpBkTFLU3AbfeIDlE6w4=
X-Received: by 2002:a17:902:d506:b0:1c1:d5d1:a364 with SMTP id b6-20020a170902d50600b001c1d5d1a364mr1049139plg.33.1695162744527;
        Tue, 19 Sep 2023 15:32:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFOULM5jJKa8+WVmIJMbHRINBpo1VdX9mETx9Rab+seQWE9KrxE0Bg8iBH2mY8M4Iw6bvu9y/B6LXEosx06DA=
X-Received: by 2002:a17:902:d506:b0:1c1:d5d1:a364 with SMTP id
 b6-20020a170902d50600b001c1d5d1a364mr1049128plg.33.1695162744239; Tue, 19 Sep
 2023 15:32:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-9-willy@infradead.org>
In-Reply-To: <20230919045135.3635437-9-willy@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 20 Sep 2023 00:32:12 +0200
Message-ID: <CAHc6FU5XnHsqXunoT5oVdupFE_NVuW_uyitZPLqgEzfUkr=V0g@mail.gmail.com>
Subject: Re: [PATCH 08/26] gfs2: Convert gfs2_write_buf_to_page() to use a folio
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

On Tue, Sep 19, 2023 at 7:00=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
> Remove several folio->page->folio conversions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/gfs2/quota.c | 37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
>
> diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> index 171b2713d2e5..0ee4865ebdca 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -736,7 +736,7 @@ static int gfs2_write_buf_to_page(struct gfs2_sbd *sd=
p, unsigned long index,
>         struct gfs2_inode *ip =3D GFS2_I(sdp->sd_quota_inode);
>         struct inode *inode =3D &ip->i_inode;
>         struct address_space *mapping =3D inode->i_mapping;
> -       struct page *page;
> +       struct folio *folio;
>         struct buffer_head *bh;
>         u64 blk;
>         unsigned bsize =3D sdp->sd_sb.sb_bsize, bnum =3D 0, boff =3D 0;
> @@ -745,15 +745,15 @@ static int gfs2_write_buf_to_page(struct gfs2_sbd *=
sdp, unsigned long index,
>         blk =3D index << (PAGE_SHIFT - sdp->sd_sb.sb_bsize_shift);
>         boff =3D off % bsize;
>
> -       page =3D grab_cache_page(mapping, index);
> -       if (!page)
> -               return -ENOMEM;
> -       if (!page_has_buffers(page))
> -               create_empty_buffers(page, bsize, 0);
> +       folio =3D filemap_grab_folio(mapping, index);
> +       if (IS_ERR(folio))
> +               return PTR_ERR(folio);
> +       bh =3D folio_buffers(folio);
> +       if (!bh)
> +               bh =3D folio_create_empty_buffers(folio, bsize, 0);
>
> -       bh =3D page_buffers(page);
> -       for(;;) {
> -               /* Find the beginning block within the page */
> +       for (;;) {
> +               /* Find the beginning block within the folio */
>                 if (pg_off >=3D ((bnum * bsize) + bsize)) {
>                         bh =3D bh->b_this_page;
>                         bnum++;
> @@ -766,9 +766,10 @@ static int gfs2_write_buf_to_page(struct gfs2_sbd *s=
dp, unsigned long index,
>                                 goto unlock_out;
>                         /* If it's a newly allocated disk block, zero it =
*/
>                         if (buffer_new(bh))
> -                               zero_user(page, bnum * bsize, bh->b_size)=
;
> +                               folio_zero_range(folio, bnum * bsize,
> +                                               bh->b_size);
>                 }
> -               if (PageUptodate(page))
> +               if (folio_test_uptodate(folio))
>                         set_buffer_uptodate(bh);
>                 if (bh_read(bh, REQ_META | REQ_PRIO) < 0)
>                         goto unlock_out;
> @@ -784,17 +785,17 @@ static int gfs2_write_buf_to_page(struct gfs2_sbd *=
sdp, unsigned long index,
>                 break;
>         }
>
> -       /* Write to the page, now that we have setup the buffer(s) */
> -       memcpy_to_page(page, off, buf, bytes);
> -       flush_dcache_page(page);
> -       unlock_page(page);
> -       put_page(page);
> +       /* Write to the folio, now that we have setup the buffer(s) */
> +       memcpy_to_folio(folio, off, buf, bytes);
> +       flush_dcache_folio(folio);
> +       folio_unlock(folio);
> +       folio_put(folio);
>
>         return 0;
>
>  unlock_out:
> -       unlock_page(page);
> -       put_page(page);
> +       folio_unlock(folio);
> +       folio_put(folio);
>         return -EIO;
>  }
>
> --
> 2.40.1
>

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

Thanks,
Andreas

