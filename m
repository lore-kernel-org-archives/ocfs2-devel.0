Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37F023AF;
	Wed, 20 Sep 2023 04:14:03 +0000 (UTC)
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4525dd7f9d0so1214035137.3;
        Tue, 19 Sep 2023 21:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695183242; x=1695788042; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0rt7w3e82POtgPKP1THsIMl2ekopUlVw4b9tDepiWE=;
        b=QmS/iQGqx1wXEQePsbmj1RXVPXyxjJR4/dZN342tvuNN2Z4FEMWbGr/CbkSJ2J6GhM
         /1TJNUqHUqQXuDVPtkRj8ytSvhP7XfhnyZGp9whf0FElUYxHUpZZj9k6cVfR7NfVtyA5
         FhfkYQWgxsK/+ZeREcIFVufZsaLApCnuimDoJsKfVTeRZiqFDTsaW8SQRh3/by7eAWyl
         eoOow8xfoL5pNJ55z1vNOgRLDff0h0v0EGJgzrbIHjHZyXhfMIwOyWPFGPbN+ZbJ2OX0
         RjbyTta2mpjoEYcrGveTjZ2Fdt/YGTTSkyS0A2zTurWEOODiC97LV2yWdejbVdmeh5je
         GlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695183242; x=1695788042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n0rt7w3e82POtgPKP1THsIMl2ekopUlVw4b9tDepiWE=;
        b=tMYc28FOc7RkPFXoJ2dIz0Te22JJJQWGbEhpd8LK1sz1EkD2nxvg0r87NzEk2FgFqY
         oqSTmEh9F7X3d1zvLy7Pib7mPVlhHZJkj3NQmHGcuUg5RkN53cbe2QCRo5Qn0y0NvqPV
         gaOBdVrCCbQLjsjdD12OTy8jaL7NEFlnvDu39O1HCyj70SClRsJ2TsLS8c7i2Iv0OOw4
         fYA4ya3t6jLC2OZ2V0DUrmSxQlXgOjwLQs+y7gQRDzWA2Ot3YMsQXV/5pFhYSkSltPFV
         Sa7hcEeVKGWIJIatPUdtqbpRfNxHyh82WiR+FwC4bhZEJF5kPFtECLa6UBcM2hdlCD4N
         oqng==
X-Gm-Message-State: AOJu0YzD6ZWbvoR2mubj41SMhpFYXbsrQbu0YCOHu6Riswy7MIMJDiZ+
	Jhc4ae68W4nCLSDY60FDsjn3pJ65W7njcasvNwE=
X-Google-Smtp-Source: AGHT+IGCKO6LeP33eZK46vTIa58jvzUXNGW5L0NVntBiKaEkNCqYCRfexXS3jzHPQ4GIsPMvj/0pYBrkJxVEdJ5Rjcw=
X-Received: by 2002:a05:6102:184:b0:452:635b:8440 with SMTP id
 r4-20020a056102018400b00452635b8440mr1509703vsq.30.1695183242192; Tue, 19 Sep
 2023 21:14:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-11-willy@infradead.org>
In-Reply-To: <20230919045135.3635437-11-willy@infradead.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 20 Sep 2023 13:13:45 +0900
Message-ID: <CAKFNMomBNvU-cRbrHMem8qPtLdfeO7VgKdSwxPixA1-vZMyDVg@mail.gmail.com>
Subject: Re: [PATCH 10/26] nilfs2: Convert nilfs_grab_buffer() to use a folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 19, 2023 at 7:20=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Remove a number of folio->page->folio conversions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/page.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index b4e54d079b7d..1c075bd906c9 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -25,19 +25,19 @@
>         (BIT(BH_Uptodate) | BIT(BH_Mapped) | BIT(BH_NILFS_Node) |       \
>          BIT(BH_NILFS_Volatile) | BIT(BH_NILFS_Checked))
>
> -static struct buffer_head *
> -__nilfs_get_page_block(struct page *page, unsigned long block, pgoff_t i=
ndex,
> -                      int blkbits, unsigned long b_state)
> +static struct buffer_head *__nilfs_get_folio_block(struct folio *folio,
> +               unsigned long block, pgoff_t index, int blkbits,
> +               unsigned long b_state)
>
>  {
>         unsigned long first_block;
> -       struct buffer_head *bh;
> +       struct buffer_head *bh =3D folio_buffers(folio);
>
> -       if (!page_has_buffers(page))
> -               create_empty_buffers(page, 1 << blkbits, b_state);
> +       if (!bh)
> +               bh =3D folio_create_empty_buffers(folio, 1 << blkbits, b_=
state);
>
>         first_block =3D (unsigned long)index << (PAGE_SHIFT - blkbits);
> -       bh =3D nilfs_page_get_nth_block(page, block - first_block);
> +       bh =3D get_nth_bh(bh, block - first_block);
>
>         touch_buffer(bh);
>         wait_on_buffer(bh);
> @@ -51,17 +51,17 @@ struct buffer_head *nilfs_grab_buffer(struct inode *i=
node,
>  {
>         int blkbits =3D inode->i_blkbits;
>         pgoff_t index =3D blkoff >> (PAGE_SHIFT - blkbits);
> -       struct page *page;
> +       struct folio *folio;
>         struct buffer_head *bh;
>
> -       page =3D grab_cache_page(mapping, index);
> -       if (unlikely(!page))
> +       folio =3D filemap_grab_folio(mapping, index);
> +       if (IS_ERR(folio))
>                 return NULL;
>
> -       bh =3D __nilfs_get_page_block(page, blkoff, index, blkbits, b_sta=
te);
> +       bh =3D __nilfs_get_folio_block(folio, blkoff, index, blkbits, b_s=
tate);
>         if (unlikely(!bh)) {
> -               unlock_page(page);
> -               put_page(page);
> +               folio_unlock(folio);
> +               folio_put(folio);
>                 return NULL;
>         }
>         return bh;
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Looks good to me.

Thanks,
Ryusuke Konishi
