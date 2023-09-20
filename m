Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EC31FC1;
	Wed, 20 Sep 2023 03:43:09 +0000 (UTC)
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-7a8b522ae46so1632948241.0;
        Tue, 19 Sep 2023 20:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695181388; x=1695786188; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ngNBnUvO+0NVI0ss84Zb16ZvzrZCajcq442dwEgXZM=;
        b=mfmN0ivJhw7h8jx8XvpaVGejOVd/F2RYMvlG9BdgaSHhHJjEkWzNY+quRXAySD2zbY
         w2Ga3mgrIasdBzd6k6dzhwkx3w4Ce4J0wkA58BI0D9LlJrrF5S9hy9HbAd/SN7a4W6ew
         +CW8pQvONVwIedUAvieyH+bWfVtWGAvs0NvuCotnYa24PK1VY81gRFWpc5el2XwNxrcu
         gQWEbApj/spWg1wxZtB38gRCSXis41Qb7JlS+fkwpqk2Jy58cD1XnLdEYVLcOVAvrv9V
         4Nmr0sGGVrQ3BoZuzNFdkwzBUHnM6KDPVB0XySxrEaRkrEe+n+H8xJb72PqoSdL0aa5s
         C7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695181388; x=1695786188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ngNBnUvO+0NVI0ss84Zb16ZvzrZCajcq442dwEgXZM=;
        b=LvlXzP26kKggPrptPU5lngRTOv6S9qPnZ063suwgEiUsSahpR3aVIqHR/CZnXk+90B
         RmFOwqTYNuTxRJQPxb6nDUJl2J+KP12iH+/rYC97J/UhxOyEWkFbtQN9ozOQE9Yz0QMX
         TtvaTlqFYMXTlMukeS7tKioRnH//L+O/wWn2Yzr/LcQaZZrXcP46jcjK5EDCg0xwapAd
         Kz/6PL5K3lq9ti/gcq/giU5t9aW5LH2/4V7PgMydtLfNo+dCT161mEFX/wZLWQqteXkK
         Yb7S/BJvU1i59h4sM5gmPa1ySWPfHmyDJnOTlnuVMeZJDvbMGx4b4WcznE3wVwjuOnPO
         Bf4A==
X-Gm-Message-State: AOJu0YwcV+wqQrNcMOHdfB/ew3R5cn93H46+pQcIypwKwvrEUdbiUDNi
	QHf9Sv8bFhg8yVNPgUwO2p5jwe/MRn4ca+/JPB4=
X-Google-Smtp-Source: AGHT+IGPPyxUdWQmz12+jR8GRkg4Q7xlkbrev/wkMNzsTNm8rjJQLm794z9bRnC0gXpAvfWgdwBP7VgL2CwiFhgTFmo=
X-Received: by 2002:a67:f3d0:0:b0:44e:bc13:b761 with SMTP id
 j16-20020a67f3d0000000b0044ebc13b761mr1886156vsn.14.1695181388190; Tue, 19
 Sep 2023 20:43:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-10-willy@infradead.org>
In-Reply-To: <20230919045135.3635437-10-willy@infradead.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 20 Sep 2023 12:42:51 +0900
Message-ID: <CAKFNMokgW2Js5RUpLujf72C+vpMmJbLM=0OfDpD6MvGwLWFphw@mail.gmail.com>
Subject: Re: [PATCH 09/26] nilfs2: Convert nilfs_mdt_freeze_buffer to use a folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 19, 2023 at 6:09=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Remove a number of folio->page->folio conversions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/mdt.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index 19c8158605ed..db2260d6e44d 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -560,17 +560,19 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, st=
ruct buffer_head *bh)
>  {
>         struct nilfs_shadow_map *shadow =3D NILFS_MDT(inode)->mi_shadow;
>         struct buffer_head *bh_frozen;
> -       struct page *page;
> +       struct folio *folio;
>         int blkbits =3D inode->i_blkbits;
>
> -       page =3D grab_cache_page(shadow->inode->i_mapping, bh->b_folio->i=
ndex);
> -       if (!page)
> -               return -ENOMEM;
> +       folio =3D filemap_grab_folio(shadow->inode->i_mapping,
> +                       bh->b_folio->index);
> +       if (IS_ERR(folio))
> +               return PTR_ERR(folio);
>
> -       if (!page_has_buffers(page))
> -               create_empty_buffers(page, 1 << blkbits, 0);
> +       bh_frozen =3D folio_buffers(folio);
> +       if (!bh_frozen)
> +               bh_frozen =3D folio_create_empty_buffers(folio, 1 << blkb=
its, 0);
>
> -       bh_frozen =3D nilfs_page_get_nth_block(page, bh_offset(bh) >> blk=
bits);
> +       bh_frozen =3D get_nth_bh(bh_frozen, bh_offset(bh) >> blkbits);
>
>         if (!buffer_uptodate(bh_frozen))
>                 nilfs_copy_buffer(bh_frozen, bh);
> @@ -582,8 +584,8 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, stru=
ct buffer_head *bh)
>                 brelse(bh_frozen); /* already frozen */
>         }
>
> -       unlock_page(page);
> -       put_page(page);
> +       folio_unlock(folio);
> +       folio_put(folio);
>         return 0;
>  }
>
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Looks good to me.

Thanks,
Ryusuke Konishi
