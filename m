Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CB08BF7
	for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 22:17:58 +0000 (UTC)
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-349a94f3d69so3579215ab.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 15:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693433877; x=1694038677; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eUAmAIfHsOOy8zS6TdEt3xyRCqjjcX1SJ2/1LstkkSY=;
        b=Pz7tTAis/UmNw1RgTQ0X0HSkSD/pNKt2h6p4u3DkWCyrxz/HPNkg+jf2yNxm/oOYSv
         BgvKYbjo+XePTKnSQIj8+IWWsbV1eKlnhX8odm8U3/j9hBgcZDY64g4kQz/3ZKFpdBQs
         5ECg9iFnZ8UbubpQ4mssLI+El1GEICUoDhPwfz9gjJ8FOxpezMjIM8GflUrrz8QFoALu
         Q93bZAumsKpEvTLu/WAbj1B95RzooqknmM5MzdiIX+clPnAQcEfOK36lz7zTWWiGY1D3
         jwiBVwXpLXxWyH/N262gNMYzb6bZ4OlKdYF1ipln5dYJmpLgTaIQ63Hh0E2+juJu9Rfu
         GcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693433877; x=1694038677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUAmAIfHsOOy8zS6TdEt3xyRCqjjcX1SJ2/1LstkkSY=;
        b=EMH2DxxD6tycPIvr3A0LLJCvRdo1RvTWxi5Zk71Uxt6iOhFonxOG0I/ztevKtoS8nW
         zzwU7jd+tuee2oOSqD8UPMdJdp0IPRKBBKnb8nMutVWYbBan1+FnTWOcBA1F0PEBrtKL
         SvBEOqmaq5gOXGzo5Z1xxl9kwrhO8hZbvY29+rP8ybJh8M8wr70CDwZ4rATsyvncz1uG
         sFRSLYCAr94cwqoZRaNGVewFWb4kqMJCJC62l1Uz3eq8c5ZTq9SaBAQGa99DNXomMA6K
         GaMSCYO1dfWjnbgdJgde/7S3MCmHt5gJWOTxmwt0MASKaH23UAuVdUgS5eoUKisPJxgI
         4zjQ==
X-Gm-Message-State: AOJu0YyQc0PEvB+aKyLhdltpTqbbQvsVqr5y1macf1AS2fDLzSTKOzW2
	wcd14jSUNSDEK5v8Ya259srLEg==
X-Google-Smtp-Source: AGHT+IEJl2Gy/UlH0rjOjWUj+pyrp/3+xYSPOMHsZ83QRaizwW1QDk1RZG+FSAw+dDLKsUqFelUKBA==
X-Received: by 2002:a05:6e02:16c6:b0:348:b07e:fdac with SMTP id 6-20020a056e0216c600b00348b07efdacmr881860ilx.3.1693433877356;
        Wed, 30 Aug 2023 15:17:57 -0700 (PDT)
Received: from google.com (161.74.123.34.bc.googleusercontent.com. [34.123.74.161])
        by smtp.gmail.com with ESMTPSA id t6-20020a056e02010600b0034632ab31c9sm60981ilm.21.2023.08.30.15.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 15:17:56 -0700 (PDT)
Date: Wed, 30 Aug 2023 22:17:54 +0000
From: Justin Stitt <justinstitt@google.com>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-hardening@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 2/2] ocfs2: Replace strlcpy with strscpy
Message-ID: <20230830221754.3bhdz4qipppihoxz@google.com>
References: <20230830215426.4181755-1-azeemshaikh38@gmail.com>
 <20230830215426.4181755-3-azeemshaikh38@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830215426.4181755-3-azeemshaikh38@gmail.com>

On Wed, Aug 30, 2023 at 09:54:26PM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
>
> Direct replacement is assumed to be safe here since
> it's ok for `kernel_param_ops.get()` to return -errno [3].
> This changes the behavior such that instead of silently ignoring the
> case when sizeof(@buffer) < DLMFS_CAPABILITIES, we now return error.

Not super familiar with the semantics of `kernel_param_ops.get()` but do
note that strscpy can only return -E2BIG and not -ERRNO specifically. Is
this still OK?

>
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> [3] https://elixir.bootlin.com/linux/v6.5/source/include/linux/moduleparam.h#L52
>
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> ---
>  fs/ocfs2/dlmfs/dlmfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index 33e529de93b2..b001eccdd2f3 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -80,7 +80,7 @@ static int param_set_dlmfs_capabilities(const char *val,
>  static int param_get_dlmfs_capabilities(char *buffer,
>  					const struct kernel_param *kp)
>  {
> -	return strlcpy(buffer, DLMFS_CAPABILITIES,
> +	return strscpy(buffer, DLMFS_CAPABILITIES,
>  		       strlen(DLMFS_CAPABILITIES) + 1);
>  }
>  static const struct kernel_param_ops dlmfs_capabilities_ops = {
> --
> 2.42.0.283.g2d96d420d3-goog
>
