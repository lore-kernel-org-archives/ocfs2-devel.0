Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A325CC8E0;
	Wed, 20 Sep 2023 08:15:21 +0000 (UTC)
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-48d0edd8a81so2434265e0c.0;
        Wed, 20 Sep 2023 01:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695197720; x=1695802520; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJxfyTLNGZAN0qgRxWWT6/oteEKQT8o70eVgdNPEM/Q=;
        b=fP1A37sbBLs/A/Kxwz29paSstGoH3VmMVk3NkI821s9UvZ9BVIf96/3U3E7NF889Fe
         6vC3w62D+aIjLMmEQiZTIAZAjUMQQSK1OT1XXjD0HcbYf6FBwYlJzy11exqAXXX2DpsD
         b2Ktxk0V8Cr/vaqBCt2KL6EiOQt1KUzBXeX3mccYmh7pYwo4W1RM7MAX2UPramg9tiXb
         eAHWz+8P3bmIANDrCkWsJugGpRZ76gUcE/C5mf8IBk5iSxget1Ey34DN5SGztiT+Avfm
         BhXHf1onZpCffZy36CYJv9aKlcIM3EABsEggcXbs0GmKTszPExGSVF+ICbri5kF/frnT
         yKgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695197720; x=1695802520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zJxfyTLNGZAN0qgRxWWT6/oteEKQT8o70eVgdNPEM/Q=;
        b=IRLxgGlugLDSznwrwBYtBdNnqyC5V8Y9NwqxPWu80piZiZNLbKI8YB6TXqX+88vzLm
         ufAWsxmfrf+FlDQybMzNGUV4ULeBy0Ir//8D+atBagiSkgXy9p1egmL0/sDDBqbSgrBf
         GwrtppE+mMxpxpLnogOAjcqIpeQnTknM5WgDjFkTIuEE0YRAJIrC7auQPmxNqQe8J1Ls
         eVwOyRESGJ29jZSXcZTwWBXho1UIG9bxiRQZUQIWLMDzj4TL9aULLwus3Ub20XWZU4dP
         FzzspZS8Cr6md2EaJuewG8mWx9XyUTeTyJoz9/0hS+lZpKodWxaN8txGIV3b43jvpthi
         zLPQ==
X-Gm-Message-State: AOJu0YyXAnQvFr9Qds+aUEh3FkY5Mtx/y02TMFcOgQLqx2XQrR2QRAxM
	zy04aWU3Hq0YgQiJwc4N+qMhFDzudiuAk3x2yFI=
X-Google-Smtp-Source: AGHT+IEsfO4EAx787RgGydCMUNs6b7OZCMZLpCKdedAcjUM4XsQ/CD9NHXWZexv599YssdpWeGgAwMzr8a3yyUbhRVE=
X-Received: by 2002:a1f:6643:0:b0:48d:38fe:3133 with SMTP id
 a64-20020a1f6643000000b0048d38fe3133mr1913731vkc.16.1695197720435; Wed, 20
 Sep 2023 01:15:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230919045135.3635437-1-willy@infradead.org> <20230919045135.3635437-15-willy@infradead.org>
In-Reply-To: <20230919045135.3635437-15-willy@infradead.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 20 Sep 2023 17:15:04 +0900
Message-ID: <CAKFNMo=uGWNL5pe7JK7-GBKR1L6tsxmtRH5+p4mPrri=CeJXUw@mail.gmail.com>
Subject: Re: [PATCH 14/26] nilfs2: Remove nilfs_page_get_nth_block
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
> All users have now been converted to get_nth_block().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/nilfs2/page.h | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
> index 344d71942d36..d249ea1cefff 100644
> --- a/fs/nilfs2/page.h
> +++ b/fs/nilfs2/page.h
> @@ -52,10 +52,4 @@ unsigned long nilfs_find_uncommitted_extent(struct ino=
de *inode,
>  #define NILFS_PAGE_BUG(page, m, a...) \
>         do { nilfs_page_bug(page); BUG(); } while (0)
>
> -static inline struct buffer_head *
> -nilfs_page_get_nth_block(struct page *page, unsigned int count)
> -{
> -       return get_nth_bh(page_buffers(page), count);
> -}
> -
>  #endif /* _NILFS_PAGE_H */
> --
> 2.40.1
>

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi
