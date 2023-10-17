Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A02DF64;
	Tue, 17 Oct 2023 19:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OS+qgn72"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-7b5fe8ab5f9so2192987241.3;
        Tue, 17 Oct 2023 12:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697571721; x=1698176521; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nEdPLPUGt3bDYuqJR132GTKL4Kbaz2ZIt3XjP65gcfI=;
        b=OS+qgn729sA/CffelznXtaNisNOjiMeYZ9qYH8GsnJ/wECxdaerj60OyTMzIT+9XOf
         dJ5dcvXpQuRP5hUMPuo7T4xIKSu9l1JRPg3bk3c7ZIy6k3eywnbKzCDqlHb6ESAZhYh8
         tC3ugbm1ohEQpynTRzNxLfTtSO5zXDrjMZWqhnpORhFu7s3VlGwhiOHzBE37+7ipbO9q
         yj3zCiUzORonckohkHQB7vYP2H2S+nyRjogPJ/IUYCcDVRrt4G0ZQOvzF6miyWXKhGuZ
         xU7bn/1DqjqLiQvf6ORCSBnjlJrpfE9R8BGyYrpwBQnUvABl/6EK2i68y+Nt47Ojpael
         maIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697571721; x=1698176521;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nEdPLPUGt3bDYuqJR132GTKL4Kbaz2ZIt3XjP65gcfI=;
        b=Xr8/hwKp9Nfi2FJYqxqGPAnuQa0q/SZiDJ7lk3DuYb1IopXi5W6TdV7qz7M2jqKJA9
         yD/k4lj9zRufv+88AmpJDpfBiA56p0MP6NmVHOmTno959DGqlHEczhf4F2CH4mG25uGa
         jBETE2dyUWf4CLnJhx4rPFxpMEtthREmbL1E2SB/yYAKEj1f2RZVq9l6i816GuzoT0Q9
         G/kWqNuNZUQIRn0VyilVNAMU6H2fCv9D3BYoHrCFShlA7frLI24nYUdV/HLg6manTbFQ
         iHtjU2pRH7ByflbzcH0wh6a+c8ftnsSl7v6NIrh8B6K3RNWARNWE8+6Oe7AGE3Gg1XW7
         StxQ==
X-Gm-Message-State: AOJu0YzD0C4dMlCRbnJxo5BpP6oOO4HYSHGYtXIYp9JTW0VLbT265g9C
	q4As4VALlBtZ+1F87Eqc+XsJSN+hytcq87aJrhw=
X-Google-Smtp-Source: AGHT+IEGVouf3g52zAQZKqogAWOdoqW2ayEa2oclPTWNKWf5D8raecPXGS+4xiqVaAbbP8NV0hXO6xERMf3T6Nmer6s=
X-Received: by 2002:a67:c186:0:b0:457:dd92:f913 with SMTP id
 h6-20020a67c186000000b00457dd92f913mr3741772vsj.14.1697571721243; Tue, 17 Oct
 2023 12:42:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231016201114.1928083-1-willy@infradead.org> <20231016201114.1928083-2-willy@infradead.org>
In-Reply-To: <20231016201114.1928083-2-willy@infradead.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 18 Oct 2023 04:41:44 +0900
Message-ID: <CAKFNMonj9XQe1PdeCny7N8MFAHwQVQNDf6A2S4g-gxX4iJLvZQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/27] buffer: Return bool from grow_dev_folio()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17, 2023 at 5:11=E2=80=AFAM Matthew Wilcox (Oracle) wrote:
>
> Rename grow_dev_page() to grow_dev_folio() and make it return a bool.
> Document what that bool means; it's more subtle than it first appears.
> Also rename the 'failed' label to 'unlock' beacuse it's not exactly
> 'failed'.  It just hasn't succeeded.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/buffer.c | 39 ++++++++++++++++++++++-----------------
>  1 file changed, 22 insertions(+), 17 deletions(-)
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b33cc74e9649..dec41d84044b 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1024,24 +1024,26 @@ static sector_t folio_init_buffers(struct folio *=
folio,
>  }
>
>  /*
> - * Create the page-cache page that contains the requested block.
> + * Create the page-cache folio that contains the requested block.
>   *
>   * This is used purely for blockdev mappings.
> + *
> + * Returns false if we have a 'permanent' failure.  Returns true if
> + * we succeeded, or the caller should retry.
>   */
> -static int
> -grow_dev_page(struct block_device *bdev, sector_t block,
> +static bool grow_dev_folio(struct block_device *bdev, sector_t block,
>               pgoff_t index, int size, int sizebits, gfp_t gfp)
>  {
>         struct inode *inode =3D bdev->bd_inode;
>         struct folio *folio;
>         struct buffer_head *bh;
>         sector_t end_block;
> -       int ret =3D 0;
> +       bool ret;
>
>         folio =3D __filemap_get_folio(inode->i_mapping, index,
>                         FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
>         if (IS_ERR(folio))
> -               return PTR_ERR(folio);
> +               return false;
>
>         bh =3D folio_buffers(folio);
>         if (bh) {
> @@ -1050,14 +1052,17 @@ grow_dev_page(struct block_device *bdev, sector_t=
 block,
>                                         (sector_t)index << sizebits, size=
);
>                         goto done;
>                 }
> +
> +               /* Caller should retry if this call fails */
> +               ret =3D true;
>                 if (!try_to_free_buffers(folio))
> -                       goto failed;
> +                       goto unlock;
>         }
>
> -       ret =3D -ENOMEM;
> +       ret =3D false;
>         bh =3D folio_alloc_buffers(folio, size, gfp | __GFP_ACCOUNT);
>         if (!bh)
> -               goto failed;
> +               goto unlock;
>
>         /*
>          * Link the folio to the buffers and initialise them.  Take the
> @@ -1070,19 +1075,19 @@ grow_dev_page(struct block_device *bdev, sector_t=
 block,
>                         (sector_t)index << sizebits, size);
>         spin_unlock(&inode->i_mapping->private_lock);
>  done:
> -       ret =3D (block < end_block) ? 1 : -ENXIO;
> -failed:
> +       ret =3D block < end_block;
> +unlock:
>         folio_unlock(folio);
>         folio_put(folio);
>         return ret;
>  }
>
>  /*
> - * Create buffers for the specified block device block's page.  If
> - * that page was dirty, the buffers are set dirty also.
> + * Create buffers for the specified block device block's folio.  If
> + * that folio was dirty, the buffers are set dirty also.
>   */
> -static int
> -grow_buffers(struct block_device *bdev, sector_t block, int size, gfp_t =
gfp)
> +static bool grow_buffers(struct block_device *bdev, sector_t block,
> +               int size, gfp_t gfp)
>  {
>         pgoff_t index;
>         int sizebits;
> @@ -1099,11 +1104,11 @@ grow_buffers(struct block_device *bdev, sector_t =
block, int size, gfp_t gfp)
>                         "device %pg\n",
>                         __func__, (unsigned long long)block,
>                         bdev);
> -               return -EIO;
> +               return false;
>         }
>
> -       /* Create a page with the proper size buffers.. */
> -       return grow_dev_page(bdev, block, index, size, sizebits, gfp);
> +       /* Create a folio with the proper size buffers.. */
> +       return grow_dev_folio(bdev, block, index, size, sizebits, gfp);
>  }
>
>  static struct buffer_head *
> --
> 2.40.1

This changes the return type of grow_buffers() from "int"  to "bool".
But, it seems that the caller, __getblk_slow(), has not changed the
type of the variable "ret" that receives its return value:

        for (;;) {
                struct buffer_head *bh;
                int ret;

                bh =3D __find_get_block(bdev, block, size);
                if (bh)
                        return bh;

                ret =3D grow_buffers(bdev, block, size, gfp);
                if (ret < 0)
                        return NULL;
        }

So, it looks like the error check immediately after calling
grow_buffers() will not branch like before.
Is this okay ?   Or, am I missing some other changes?

Also, there is a typo in the changelog: "beacuse" -> "because".

Regards,
Ryusuke Konishi
