Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D99F187F;
	Wed, 20 Sep 2023 03:40:24 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-44d4c3fa5beso2724446137.3;
        Tue, 19 Sep 2023 20:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695181223; x=1695786023; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbsTDv/vdTgo0XJKb9aBetBXttLdsN9uZRk25mtVFgs=;
        b=hpob5K5PknX3wZP1QR0J4WVvHACQusGM7M38Fw0Vw2zMU6NZkQZvPglSJhz+bNHUAc
         /oH/hBKuf65ycSSaWjH+neHGP3IOoZZ4Z44dKJFrb2215lxEm7Rp0l3zLosHzHq1h6NL
         /1bBTisR6fSTaOIa7fGaewoiYac/NPCKc+YI3XtGeaeitBVmb3D1WQrBQwLujH5DJqer
         5qAtjoTTYJ84YcLAFYND8SRDm8C+h9gQzOBShLWIrfITXQ5ono9hcBv3T67z9KZ257sJ
         N5ghYRNXVsToz5UZCnYT1IHqr7tSwylMdUzPx8zNwXhGiehBCmdlPvV2LuymM+8z/k4j
         GwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695181223; x=1695786023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pbsTDv/vdTgo0XJKb9aBetBXttLdsN9uZRk25mtVFgs=;
        b=BEr6t5ywOXQtwwmYrJrjFQU9MB3nLYeKOtM79lrLLk3ip36f3mx+4cUy3Zx7RTdbkf
         hypV/KnUb/ZH4EI1Nym1cVef0lUG8miQkdEbXmtR5ZlulLgmKEm4YgxQ0dFUS4YDyuLt
         Hqusm59hGisGhShLgSdKtTFf+a2ZFvjKnvqdKVKX8PpGp7bfOr97JQaBtdU7U05EXTos
         AbWUpsHHftDmkEN4Qjk7MBVYtR5XKuhX1+X8oPmXxntugJEUgA0SnJ4f9exqwZig78kj
         1Szoo7rHRceK0HYHtjYpPJ2FOxtFDFKVbmr8ZBtK4G0hi7CmwHmZqXY7d2wHCB86IuKP
         zbeA==
X-Gm-Message-State: AOJu0Yw0jDMO1HtHPfRaG+dlZtFDbkZSw79uHUieETQQhVYS1WhlF4HM
	A5YoCwgjcCOFW+QCO9UA1ALlG/nL1EyxVyUhWXs=
X-Google-Smtp-Source: AGHT+IHEBWq/1XTZtP0mhqwg3tAU0M9kblloDD8+XtqFaWUz5y3r1rDHF8lseWtoSoONYJCT/DOmQ8XEC2PsGWaMvyQ=
X-Received: by 2002:a67:fe97:0:b0:452:62b2:36b with SMTP id
 b23-20020a67fe97000000b0045262b2036bmr1651569vsr.30.1695181223031; Tue, 19
 Sep 2023 20:40:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-5-willy@infradead.org>
In-Reply-To: <20230919045135.3635437-5-willy@infradead.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 20 Sep 2023 12:40:06 +0900
Message-ID: <CAKFNMonYFYCXnJTkM+MQbDCfTWV19v+acYZwHs-W4NuBBHE7Tg@mail.gmail.com>
Subject: Re: [PATCH 04/26] buffer: Add get_nth_bh()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 19, 2023 at 4:20=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Extract this useful helper from nilfs_page_get_nth_block()
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/page.h            |  7 +------
>  include/linux/buffer_head.h | 22 ++++++++++++++++++++++
>  2 files changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> index 21ddcdd4d63e..344d71942d36 100644
> --- a/fs/nilfs2/page.h
> +++ b/fs/nilfs2/page.h
> @@ -55,12 +55,7 @@ unsigned long nilfs_find_uncommitted_extent(struct ino=
de *inode,
>  static inline struct buffer_head *
>  nilfs_page_get_nth_block(struct page *page, unsigned int count)
>  {
> -       struct buffer_head *bh =3D page_buffers(page);
> -
> -       while (count-- > 0)
> -               bh =3D bh->b_this_page;
> -       get_bh(bh);
> -       return bh;
> +       return get_nth_bh(page_buffers(page), count);
>  }
>
>  #endif /* _NILFS_PAGE_H */
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 1001244a8941..9fc615ee17fd 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -457,6 +457,28 @@ __bread(struct block_device *bdev, sector_t block, u=
nsigned size)
>         return __bread_gfp(bdev, block, size, __GFP_MOVABLE);
>  }
>
> +/**
> + * get_nth_bh - Get a reference on the n'th buffer after this one.
> + * @bh: The buffer to start counting from.
> + * @count: How many buffers to skip.
> + *
> + * This is primarily useful for finding the nth buffer in a folio; in
> + * that case you pass the head buffer and the byte offset in the folio
> + * divided by the block size.  It can be used for other purposes, but
> + * it will wrap at the end of the folio rather than returning NULL or
> + * proceeding to the next folio for you.
> + *
> + * Return: The requested buffer with an elevated refcount.
> + */
> +static inline struct buffer_head *get_nth_bh(struct buffer_head *bh,
> +               unsigned int count)
> +{
> +       while (count--)
> +               bh =3D bh->b_this_page;
> +       get_bh(bh);
> +       return bh;
> +}
> +
>  bool block_dirty_folio(struct address_space *mapping, struct folio *foli=
o);
>
>  #ifdef CONFIG_BUFFER_HEAD
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Looks good to me.

Thanks,
Ryusuke Konishi
