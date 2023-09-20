Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED0C8E3;
	Wed, 20 Sep 2023 08:07:37 +0000 (UTC)
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-49032a0ff13so2733618e0c.0;
        Wed, 20 Sep 2023 01:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695197256; x=1695802056; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cH5sDHtnVKWCV3iCYyvX8z8Hs3DAvkXrfeXQp9YY8c=;
        b=bkfquifWXAntHyLaH8QhsMeP+WgWWbHrUqyzRLS4+rRh/tZooV8LylL12HRVS3CnHe
         V4cR+VENFmFQALFajhE2MAivUg1hNxFPvmbM+Vf93SB6JuC9FFhxFh3eRIllW2JMWCCr
         fiimUMbEPi/B2vFCzMEPpkJkQ3VBWYINsT2CthEZ2C8Ca/FYbBnShVVtAGHzbvQ2xU91
         RoU2RLKtB94xBAptIZdTu0nPShNKLOdv5xUO1G06ZjFHq4gA0pibq1HhCWq9HyWXJx0Q
         /pgHTTWu8fm6XzEa5BNdRBWevMa3gcPuwVk9/6boTeLhPn78+eyc9vvKFbJmhCiFdVSE
         XxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695197256; x=1695802056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9cH5sDHtnVKWCV3iCYyvX8z8Hs3DAvkXrfeXQp9YY8c=;
        b=CL9rg32zEHezEc80sNZOSUTYfntiptnq1xIoUgcfTcDK9sgtSZwfzjYkJMmLUMJ2wG
         b9ocYFvSfYv5IYHGEVxVeTs4PWOHSI4qDonK1vU0DOt3ZjOODEXWUVLmdVVpyC7qPnFl
         Kt/HGjK/mTj3DdPHlDBWUyt5ZomAQ1n2C5rZGXIyumhfpUfNPqBlDjrFI/eilhYIq3rj
         7QGFcO9b9v3nhELjxtVwuXtm1W88YLU8z4MOlsSvRwulzCxpdTB0BFS1Bs1uk+/i4eEi
         YAN1rZxcH3D/K7fDrtaan216kacrUNVoCBnohNVlXcXPTWtpLYJCNX6nwslJW20QuOr3
         QIoQ==
X-Gm-Message-State: AOJu0YySFjvzv8mN3lDcQM9i9/sr2WprZKaz/rnHosjBkg+LkHQgBFEG
	cU++EJfgsRvAYazZN1oaYt/bpUkZEzIGJaZxt+8=
X-Google-Smtp-Source: AGHT+IFkmee8vYqiRU2MDwPCUYc12H9bxQ6dbTyVl2uMQTPK3nmmRGzDpQBcuukLJM94BaZ9yBg2NObfT5FOrPxTcNo=
X-Received: by 2002:a1f:4c41:0:b0:48f:e0c4:1a1 with SMTP id
 z62-20020a1f4c41000000b0048fe0c401a1mr1862870vka.12.1695197256424; Wed, 20
 Sep 2023 01:07:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-14-willy@infradead.org>
In-Reply-To: <20230919045135.3635437-14-willy@infradead.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 20 Sep 2023 17:07:20 +0900
Message-ID: <CAKFNMokMe_QOPuLXsvUJf2+qZLUyi7Z_JFAKvh853N6ZV3yGyA@mail.gmail.com>
Subject: Re: [PATCH 13/26] nilfs2: Convert nilfs_mdt_get_frozen_buffer to use
 a folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 19, 2023 at 6:25=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Remove a number of folio->page->folio conversions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/mdt.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index 11b7cf4acc92..7b754e6494d7 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -592,17 +592,19 @@ nilfs_mdt_get_frozen_buffer(struct inode *inode, st=
ruct buffer_head *bh)
>  {
>         struct nilfs_shadow_map *shadow =3D NILFS_MDT(inode)->mi_shadow;
>         struct buffer_head *bh_frozen =3D NULL;
> -       struct page *page;
> +       struct folio *folio;
>         int n;
>
> -       page =3D find_lock_page(shadow->inode->i_mapping, bh->b_folio->in=
dex);
> -       if (page) {
> -               if (page_has_buffers(page)) {
> +       folio =3D filemap_lock_folio(shadow->inode->i_mapping,
> +                       bh->b_folio->index);
> +       if (!IS_ERR(folio)) {
> +               bh_frozen =3D folio_buffers(folio);
> +               if (bh_frozen) {
>                         n =3D bh_offset(bh) >> inode->i_blkbits;
> -                       bh_frozen =3D nilfs_page_get_nth_block(page, n);
> +                       bh_frozen =3D get_nth_bh(bh_frozen, n);
>                 }
> -               unlock_page(page);
> -               put_page(page);
> +               folio_unlock(folio);
> +               folio_put(folio);
>         }
>         return bh_frozen;
>  }
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Looks good to me.

Thanks,
Ryusuke Konishi
