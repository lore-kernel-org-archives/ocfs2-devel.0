Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C8B8BFF
	for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 23:00:38 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1c1f8aaab9aso1448345ad.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 30 Aug 2023 16:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693436438; x=1694041238; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mqxu+tFGh9Jqwxve6bfR96NTIDgvY/0bBwoU0szPzAI=;
        b=SwOoQWT+fCbhMcO2aUgp91ItqK0/nJpYZmhCMxjXMwgDJ82c6D+ajYYrHuUwWWa6N7
         HH7R+oPoxtc5BBwaJx5sJ+KJLc0lt24HLdkqy6LL//t+RHq135yWLA+wezUzJ+Avou3u
         5fwxP8OHSQU1odlJr6oUsGRE/QGhf+Ho6/8Po=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693436438; x=1694041238;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mqxu+tFGh9Jqwxve6bfR96NTIDgvY/0bBwoU0szPzAI=;
        b=HJVDU/2/tT0rXFDuIE5oDgRQ6pXB4xS8qjVsYfAQynUGoHvdmCp5PlQfO67Y5PRgKM
         fvQzwCdrZ+TqVQlsdqKTU8YW1k4oLGTN1ZhMSOYmHDnl8lpjugHy4DuGw2gK2+jvV41k
         zggUnZmf3A+U1doaADfUV7rLU2Q8lVQmm+uUKcw1XjjVAXVw5b8bfpifu23xXLFxilJm
         gltlaX0HJ4U5JXwSLy4KL7xNtVbAYsmY3774+t0yH2ixh4UMjgra+CA1UcyyQWHBeKNf
         sg/owRVeCmhZL9SOQ3Ngb48aX7uyrI9pmUyU2SaCqljoDZHspR3Fvg4RtWdfHz/rLqYJ
         4PBw==
X-Gm-Message-State: AOJu0YyLhFqEbNzMJSaCRe1sOgW9B/ulu6+tPi3Ga7/TmXF2IECEVtyi
	g9t8cUfsuVP0srM35xpGZztbJQ==
X-Google-Smtp-Source: AGHT+IH5AprVacmHqYm3RuV5CCezVz/DJRyjbaoRrsUaqcqdsLDSojkrt58gIYwBMHkpfshuHjj+oA==
X-Received: by 2002:a17:903:2349:b0:1b8:90bd:d157 with SMTP id c9-20020a170903234900b001b890bdd157mr4044458plh.26.1693436438271;
        Wed, 30 Aug 2023 16:00:38 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id b14-20020a170903228e00b001b81a97860asm28420plh.27.2023.08.30.16.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 16:00:37 -0700 (PDT)
Date: Wed, 30 Aug 2023 16:00:37 -0700
From: Kees Cook <keescook@chromium.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-hardening@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH 1/2] ocfs2: Replace module_param_call with module_param_cb
Message-ID: <202308301546.5C789E5EC@keescook>
References: <20230830215426.4181755-1-azeemshaikh38@gmail.com>
 <20230830215426.4181755-2-azeemshaikh38@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830215426.4181755-2-azeemshaikh38@gmail.com>

On Wed, Aug 30, 2023 at 09:54:25PM +0000, Azeem Shaikh wrote:
> module_param_call has been marked obsolete [1], so replacing its usage with
> module_param_cb instead.
> 
> [1] https://elixir.bootlin.com/linux/v6.5/source/include/linux/moduleparam.h#L296
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> ---
>  fs/ocfs2/dlmfs/dlmfs.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index 81265123ce6c..33e529de93b2 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -83,8 +83,11 @@ static int param_get_dlmfs_capabilities(char *buffer,
>  	return strlcpy(buffer, DLMFS_CAPABILITIES,
>  		       strlen(DLMFS_CAPABILITIES) + 1);
>  }
> -module_param_call(capabilities, param_set_dlmfs_capabilities,
> -		  param_get_dlmfs_capabilities, NULL, 0444);
> +static const struct kernel_param_ops dlmfs_capabilities_ops = {
> +	.set = param_set_dlmfs_capabilities,
> +	.get = param_get_dlmfs_capabilities,
> +};
> +module_param_cb(capabilities, &dlmfs_capabilities_ops, NULL, 0444);
>  MODULE_PARM_DESC(capabilities, DLMFS_CAPABILITIES);

Oh, hm. Yeah, that's not good documentation. It was originally added in
9bbb9e5a33109b2832e2e63dcc7a132924ab374b, but that was doing some
casting and other things during the conversion to an ops structure.

I cleaned up all the last of those back in 2017, and I should have
dropped the "Obsolete" comment:
ece1996a21eeb344b49200e627c6660111009c10
b2f270e8747387335d80428c576118e7d87f69cc

The resulting patch you sent ends up literally open coding what it
already does...

#define module_param_call(name, _set, _get, arg, perm)                  \
        static const struct kernel_param_ops __param_ops_##name =       \
                { .flags = 0, .set = _set, .get = _get };               \
        __module_param_call(MODULE_PARAM_PREFIX,                        \
                            name, &__param_ops_##name, arg, perm, -1, 0)

#define module_param_cb(name, ops, arg, perm)                                 \
        __module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, -1, 0)

Looking at usage, it's still common:

$ git grep '^module_param_call(' | wc -l
54
$ git grep '^module_param_cb(' | wc -l
93

And the users of module_param_cb() appear to be almost universally
open-coding the result. Only a few initialize struct members that aren't
.get and .set:

$ git grep -B6 ^module_param_cb

I'd say drop this patch and instead patch moduleparam.h to not say it's
deprecated. :P

-Kees

-- 
Kees Cook
