Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D5837CAD;
	Tue, 19 Sep 2023 13:01:45 +0000 (UTC)
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-4963a2e3aa6so3215396e0c.0;
        Tue, 19 Sep 2023 06:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695128504; x=1695733304; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2w/wQ8V2E6A/A9h71MT3wsUIExlrWO06vblA9KgaYVM=;
        b=Wk/Qpmvv8RqqdDKo3d9Ha4xMfOGDCOAJrdvPTO8PT2FH3mTuJkDIxEZGhG2EawZ99F
         OZYEzuT7uWO3bTr+Ibzf+D9gcXiMJYys57/VHbNsEiHy1hsBDoVei18xmeTzbImDpx57
         1i2elzZ/sR9FDOhQqMwIoRyqfjeIWfC6FpvivWNbwIk8QEMwDoojTZFm6vlpXdWnsW7o
         p6M4Tf4OpjVCx+TDjb09FSmvDwfGQ4DpwWE4QcJx0fpwGX9lbipV5ccmyVMbsigfxmYR
         4zU4KkwhFaF8aOIJJkxEtNyf1oLuH3aBVtkwP1S0/Y+Q6Ob/biL3uvKfMCvZIIj1ySAR
         QUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695128504; x=1695733304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2w/wQ8V2E6A/A9h71MT3wsUIExlrWO06vblA9KgaYVM=;
        b=BqCL0j9CCqmvmkjthWMG0bQHnNhYI3BIa64TFBONPIgqeAHdUmdflQopaXHcYjE0xA
         WBTaPA+cTh6dASmsC61Iu0lbR6LLKdDFxjYd5jeH+mk5sn+JMMql+ob2xzNqCijTtkkP
         E3ddl/SFtwqxho60ByDjaLfiX3izcUGD0ksFxBTTdC6JdDWlVygWG/s/Y10/Nn9h+4Bb
         s+vfUxuTp1u+9TMYgySPMb79PcyaEBKtf61N8rjE00wS7N8yUbRfHquf9aecZD4B3Gvl
         R4TZdLIdfT32eS5tWNfHPU2onXktswBxMo3gcdyfh1aZTeg2WgL1jmZV863CNG2mDTgj
         WEQA==
X-Gm-Message-State: AOJu0YwTkwxW+HUwnnNhf/jVak/7m0yj2U2/EuNFOXO7U5qsgpd0WLdK
	gl1yKjPljDMNZe77Ucmaar1+HmjoysFAFFdLNII=
X-Google-Smtp-Source: AGHT+IGt+cH+gF//llikjpiYbxgkUAmOFr3hKUulbwUJC348hXuZy75vYMRDDJ/wPMR9xuIT1pMOSxpCoePjUW6q3X0=
X-Received: by 2002:a05:6122:3657:b0:496:2d54:e6f0 with SMTP id
 dv23-20020a056122365700b004962d54e6f0mr921811vkb.6.1695128503713; Tue, 19 Sep
 2023 06:01:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-12-willy@infradead.org>
In-Reply-To: <20230919045135.3635437-12-willy@infradead.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 19 Sep 2023 22:01:27 +0900
Message-ID: <CAKFNMonjfsWBageg6vfWok9vvNEzjhXiqCCb+=cDFuwnTER95A@mail.gmail.com>
Subject: Re: [PATCH 11/26] nilfs2: Convert nilfs_copy_page() to nilfs_copy_folio()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 19, 2023 at 1:56=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> Both callers already have a folio, so pass it in and use it directly.
> Removes a lot of hidden calls to compound_head().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/page.c | 50 +++++++++++++++++++++++++-----------------------
>  1 file changed, 26 insertions(+), 24 deletions(-)
>
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 1c075bd906c9..696215d899bf 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -184,30 +184,32 @@ void nilfs_page_bug(struct page *page)
>  }
>
>  /**
> - * nilfs_copy_page -- copy the page with buffers
> - * @dst: destination page
> - * @src: source page
> - * @copy_dirty: flag whether to copy dirty states on the page's buffer h=
eads.
> + * nilfs_copy_folio -- copy the folio with buffers
> + * @dst: destination folio
> + * @src: source folio
> + * @copy_dirty: flag whether to copy dirty states on the folio's buffer =
heads.
>   *
> - * This function is for both data pages and btnode pages.  The dirty fla=
g
> - * should be treated by caller.  The page must not be under i/o.
> - * Both src and dst page must be locked
> + * This function is for both data folios and btnode folios.  The dirty f=
lag
> + * should be treated by caller.  The folio must not be under i/o.
> + * Both src and dst folio must be locked
>   */
> -static void nilfs_copy_page(struct page *dst, struct page *src, int copy=
_dirty)
> +static void nilfs_copy_folio(struct folio *dst, struct folio *src,
> +               bool copy_dirty)
>  {
>         struct buffer_head *dbh, *dbufs, *sbh;
>         unsigned long mask =3D NILFS_BUFFER_INHERENT_BITS;
>
> -       BUG_ON(PageWriteback(dst));
> +       BUG_ON(folio_test_writeback(dst));
>
> -       sbh =3D page_buffers(src);
> -       if (!page_has_buffers(dst))
> -               create_empty_buffers(dst, sbh->b_size, 0);
> +       sbh =3D folio_buffers(src);
> +       dbh =3D folio_buffers(dst);
> +       if (!dbh)
> +               dbh =3D folio_create_empty_buffers(dst, sbh->b_size, 0);
>
>         if (copy_dirty)
>                 mask |=3D BIT(BH_Dirty);
>
> -       dbh =3D dbufs =3D page_buffers(dst);
> +       dbufs =3D dbh;
>         do {
>                 lock_buffer(sbh);
>                 lock_buffer(dbh);
> @@ -218,16 +220,16 @@ static void nilfs_copy_page(struct page *dst, struc=
t page *src, int copy_dirty)
>                 dbh =3D dbh->b_this_page;
>         } while (dbh !=3D dbufs);
>
> -       copy_highpage(dst, src);
> +       folio_copy(dst, src);
>
> -       if (PageUptodate(src) && !PageUptodate(dst))
> -               SetPageUptodate(dst);
> -       else if (!PageUptodate(src) && PageUptodate(dst))
> -               ClearPageUptodate(dst);
> -       if (PageMappedToDisk(src) && !PageMappedToDisk(dst))
> -               SetPageMappedToDisk(dst);
> -       else if (!PageMappedToDisk(src) && PageMappedToDisk(dst))
> -               ClearPageMappedToDisk(dst);
> +       if (folio_test_uptodate(src) && !folio_test_uptodate(dst))
> +               folio_mark_uptodate(dst);
> +       else if (!folio_test_uptodate(src) && folio_test_uptodate(dst))
> +               folio_clear_uptodate(dst);
> +       if (folio_test_mappedtodisk(src) && !folio_test_mappedtodisk(dst)=
)
> +               folio_set_mappedtodisk(dst);
> +       else if (!folio_test_mappedtodisk(src) && folio_test_mappedtodisk=
(dst))
> +               folio_clear_mappedtodisk(dst);
>
>         do {
>                 unlock_buffer(sbh);
> @@ -269,7 +271,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap=
,
>                         NILFS_PAGE_BUG(&folio->page,
>                                        "found empty page in dat page cach=
e");
>
> -               nilfs_copy_page(&dfolio->page, &folio->page, 1);
> +               nilfs_copy_folio(dfolio, folio, true);
>                 filemap_dirty_folio(folio_mapping(dfolio), dfolio);
>
>                 folio_unlock(dfolio);
> @@ -314,7 +316,7 @@ void nilfs_copy_back_pages(struct address_space *dmap=
,
>                 if (!IS_ERR(dfolio)) {
>                         /* overwrite existing folio in the destination ca=
che */
>                         WARN_ON(folio_test_dirty(dfolio));
> -                       nilfs_copy_page(&dfolio->page, &folio->page, 0);
> +                       nilfs_copy_folio(dfolio, folio, false);
>                         folio_unlock(dfolio);
>                         folio_put(dfolio);
>                         /* Do we not need to remove folio from smap here?=
 */
> --
> 2.40.1

When I tried to test the patchset against 6.6-rc2, I encountered the
following error during the build:

 ERROR: modpost: "folio_copy" [fs/nilfs2/nilfs2.ko] undefined!

It looks like "folio_copy" is not exported to modules.

I'll correct this manually for now and proceed with the review and
testing, but could you please fix this build issue in some way ?

Thanks,
Ryusuke Konishi
