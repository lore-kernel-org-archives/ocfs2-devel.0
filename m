Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1954D1172F;
	Wed, 20 Sep 2023 10:01:37 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6c0c6370e5eso4158410a34.3;
        Wed, 20 Sep 2023 03:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695204097; x=1695808897; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W2Sxc2lzUzNR93PpRUd+yVO8Zh7S3vyEBNQBpNy/0XM=;
        b=GPY26OAWKZG6/zJSDNQ8AYi8KTt2yLXPY5wiXup6VMb5HV4oLouNGxMQzeYwB28Weg
         zeAg1OH8+R1cLlqA9j0ZaIAMn4s5xrSwBm/0YleGbW/XlG3M/t8qqtEK/MaSoRBxTJ4r
         DuFBAOgQcpnF/qtdASs/PdvkbGFJqn38GTlReOoBHU5jI62+lEyuQsEoS5sBdNA5o51p
         wtw5AtT6M4tNQXGHsJx8oCT+Cj9up8EbHHrCUaOIcfrCFk2wxUJDGq2buSgdQiK01+ia
         nNJokT0gf1ZgeBdY7hq+6myY/pyMO/CQf3EP6/krmrZkiJ84Un6lt9pVdCN5ueHl0MMc
         I9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695204097; x=1695808897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W2Sxc2lzUzNR93PpRUd+yVO8Zh7S3vyEBNQBpNy/0XM=;
        b=xTlN9+4wW0bSTIDYrDeP8Kthqlb2xzjUQn4pZ/LSyTO0kMhnOYIYpSsEhUe2D59q8M
         R8ThkZ2Eb/WsQzLJVmNdghanlZOyuWmiqJcTtVycHdepLHFNmem02RTCX/V2u2mYSxWd
         AX9Pt3hH0rxSNIx2iBAj040ZBLtEbrA/xUX39uV4cs8f0B4bFZMc21bJI0B3BfRcKJLD
         Q8aJshZ8YyhK6GMAY7qesdiq0qMi01YgT9Mibdi0h3i9ssLMGAcwa1VHtiK7K3Gm4IAI
         EmZt1FHekkusQqLx7Vi3T+tcxz90jxybD9fzHsthaba4g+VesHkkOp0RRZoz3CHB7CrA
         nt+w==
X-Gm-Message-State: AOJu0YzOSAx5pSWjlH2MnUsINvvjUc/nWEQmfrUxLA3Pgdoa18Q88jFI
	gyzS/7ayz2mhyNDoyA+UtgSBKBJ5yjKICKhUZE4=
X-Google-Smtp-Source: AGHT+IF6TvvrFfInrhj56gdvCe5w+++P3HMf6bTBPikJlLKn+WLjAfLo6m95ThXJfvs6hZ63Kl1g7MzMNs/yRVqIDX8=
X-Received: by 2002:a05:6830:102:b0:6b9:b226:d08e with SMTP id
 i2-20020a056830010200b006b9b226d08emr2148062otp.34.1695204097042; Wed, 20 Sep
 2023 03:01:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-16-willy@infradead.org>
In-Reply-To: <20230919045135.3635437-16-willy@infradead.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 20 Sep 2023 19:01:20 +0900
Message-ID: <CAKFNMonL+TobLB6e6g0kKQsGY0-FP1fkQyuNQKqS8+B-QH4qig@mail.gmail.com>
Subject: Re: [PATCH 15/26] nilfs2: Convert nilfs_lookup_dirty_data_buffers to
 use folio_create_empty_buffers
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-nilfs@vger.kernel.org, 
	linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, reiserfs-devel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, Pankaj Raghav <p.raghav@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 19, 2023 at 3:47=E2=80=AFPM Matthew Wilcox (Oracle) wrote:
>
> This function was already using a folio, so this update to the new API
> removes a single folio->page->folio conversion.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/segment.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> index 7ec16879756e..94388fe83cf8 100644
> --- a/fs/nilfs2/segment.c
> +++ b/fs/nilfs2/segment.c
> @@ -731,10 +731,9 @@ static size_t nilfs_lookup_dirty_data_buffers(struct=
 inode *inode,
>                         continue;
>                 }
>                 head =3D folio_buffers(folio);
> -               if (!head) {
> -                       create_empty_buffers(&folio->page, i_blocksize(in=
ode), 0);
> -                       head =3D folio_buffers(folio);
> -               }
> +               if (!head)
> +                       head =3D folio_create_empty_buffers(folio,
> +                                       i_blocksize(inode), 0);
>                 folio_unlock(folio);
>
>                 bh =3D head;
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>


Now, I've seen all the changes to nilfs2 including the last patch.
It's almost a direct conversion throughout, and I don't see any issues
with the nilfs2 part other than the build issue.

With all 26 patches applied, nilfs2 is running without problems in
actual machine tests including stress tests.

Thank you very much for your efforts.

Regards,
Ryusuke Konishi
