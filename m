Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4A08BFE;
	Wed, 20 Sep 2023 07:26:12 +0000 (UTC)
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-48d0edd8a81so2419089e0c.0;
        Wed, 20 Sep 2023 00:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695194771; x=1695799571; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQu/iPxRaWTK1rhHGERjdyj3zLGL4cZdjE4RNeJI6UE=;
        b=SvZ/mI10I+JRu/4LlOO6goBeMkCf57+EQWYD8oH1egVTSweHhHA5S5k/xLhvK7eGC2
         3rPhFUEJp22BvzEutbhVrTHTp7ggB7QxWFTX2UwVvY+g5JQNx1YPFCD6OEMO+6abes6E
         asBZQNs4kwOfW+Z9zAYBdMD4sBKR74W5BGyzkEMZn8QbG3bGhsRSOZw+A8KDg+RPimkF
         rxTby1nA0foK8wc4EVhXBW3AvngnkE81McnoWI/bLaygQOKQJHl0iHC0L8Ei8e+3qzfL
         K1TN2wosmO7N9L+pw7yUaaW1/4lulpVBeUFY0GjIeUqnZm+n1Y+WkSH5iR21GjsE5QUa
         Y/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695194771; x=1695799571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LQu/iPxRaWTK1rhHGERjdyj3zLGL4cZdjE4RNeJI6UE=;
        b=IhHmEsVHsfqERaoeNw0GR4viShzloBwZRzZH+ibXz1jslU985stKYHq0QAAnVuOuCA
         VIdAas5ZKSJopA4S6Y6QtQ3x5yKz8XNWs/MKpF5tIa7EEmJ1m0Lc+YFKnuwOTuGEry1z
         GFoNVeYFoNh/MzI4lGJmXnLKrjWPiPh54DI9SxC5FGAa0a/WZQ9j1PT0QkHAbco/ue5t
         zmOlgm1UFNZNsEHXB7vACq2mztgRV1GgTBfTaUeSA6aam/V85PxzV/zYroQIvfoNbBnJ
         oZUdLrrMLn9HuYEfHK32JF+yE6Q7C4uRU+Hv+Y4EZ+OGCXoDjHi7Et9bmko68AHJ68xg
         bx4A==
X-Gm-Message-State: AOJu0YwJ2QBH7Gufy4sWvwqcx9WboHfBgMlgZElAjVDR1WiuGux8smFs
	EYzuc9z/JTfHY9iS/2aG60XZJg+pXzF+R6RWMLQ=
X-Google-Smtp-Source: AGHT+IFQlFeFAcKAQ7LPppd3w6KDWjLwNbdHXda8Z23QhXjgisZYRRlc9Mek2KJpmLRFy8U78oSpyqfwiEocIqQmsWU=
X-Received: by 2002:a1f:e043:0:b0:495:e530:5155 with SMTP id
 x64-20020a1fe043000000b00495e5305155mr1981897vkg.3.1695194771638; Wed, 20 Sep
 2023 00:26:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-13-willy@infradead.org>
In-Reply-To: <20230919045135.3635437-13-willy@infradead.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 20 Sep 2023 16:25:55 +0900
Message-ID: <CAKFNMokf=ucSpitwt2sF-nBPJPfL02MmorwXvdcw_h1zEoB7BA@mail.gmail.com>
Subject: Re: [PATCH 12/26] nilfs2: Convert nilfs_mdt_forget_block() to use a folio
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 19, 2023 at 3:04=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Remove a number of folio->page->folio conversions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/mdt.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
>
> diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
> index db2260d6e44d..11b7cf4acc92 100644
> --- a/fs/nilfs2/mdt.c
> +++ b/fs/nilfs2/mdt.c
> @@ -356,30 +356,28 @@ int nilfs_mdt_delete_block(struct inode *inode, uns=
igned long block)
>   */
>  int nilfs_mdt_forget_block(struct inode *inode, unsigned long block)
>  {
> -       pgoff_t index =3D (pgoff_t)block >>
> -               (PAGE_SHIFT - inode->i_blkbits);
> -       struct page *page;
> -       unsigned long first_block;
> +       pgoff_t index =3D block >> (PAGE_SHIFT - inode->i_blkbits);
> +       struct folio *folio;
> +       struct buffer_head *bh;
>         int ret =3D 0;
>         int still_dirty;
>
> -       page =3D find_lock_page(inode->i_mapping, index);
> -       if (!page)
> +       folio =3D filemap_lock_folio(inode->i_mapping, index);
> +       if (IS_ERR(folio))
>                 return -ENOENT;
>
> -       wait_on_page_writeback(page);
> +       folio_wait_writeback(folio);
>
> -       first_block =3D (unsigned long)index <<
> -               (PAGE_SHIFT - inode->i_blkbits);
> -       if (page_has_buffers(page)) {
> -               struct buffer_head *bh;
> -
> -               bh =3D nilfs_page_get_nth_block(page, block - first_block=
);
> +       bh =3D folio_buffers(folio);
> +       if (bh) {
> +               unsigned long first_block =3D index <<
> +                               (PAGE_SHIFT - inode->i_blkbits);
> +               bh =3D get_nth_bh(bh, block - first_block);
>                 nilfs_forget_buffer(bh);
>         }
> -       still_dirty =3D PageDirty(page);
> -       unlock_page(page);
> -       put_page(page);
> +       still_dirty =3D folio_test_dirty(folio);
> +       folio_unlock(folio);
> +       folio_put(folio);
>
>         if (still_dirty ||
>             invalidate_inode_pages2_range(inode->i_mapping, index, index)=
 !=3D 0)
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Looks good to me.

Thanks,
Ryusuke Konishi
