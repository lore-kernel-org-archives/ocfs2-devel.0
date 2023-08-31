Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD975399
	for <ocfs2-devel@lists.linux.dev>; Thu, 31 Aug 2023 21:04:49 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-68becf931bfso1022401b3a.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 31 Aug 2023 14:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693515889; x=1694120689; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIzo2LBD81agdqbnvG9Ei0Uuoz7hAbrfR7IL8DHvg8w=;
        b=gp8l1NLst8BzAbFpR6D7k93tBZgXIhYXDTrzLDtieXYcRVtQMdgYM8npxZEQ0+kDxo
         er087C+xNa3Y+QAHOhufuCt+DKno+qAVcoAlyoawyceLUkjCEmgdML5fCcWG7PctpBSo
         c/T8XkqYYKO0gKds3XowZ840LCsRCDKxGY3VY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693515889; x=1694120689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIzo2LBD81agdqbnvG9Ei0Uuoz7hAbrfR7IL8DHvg8w=;
        b=jR2IrfKYqReUryJBz1UlV0nPuzqfkEO0ewIAvkaYH2P8zd9rgc1p+yVNx0D6LAw34S
         QVbFSz7TPyWIqfOTMuitUesrHUOxxmjRkrxYyWJLgjPnWYE+GDA+WyyKMVhx3hwyxNwK
         8lNZe1zyWjrAJF+6e8ioNCMqgIi1ncqd8LEMU1ghM5oZrOv0ZYqPqR/9OcyfV3V3DWir
         lHwA/ppzjXmQKKeCKclRZCRE032M26rOixTNMpvCvPb0Y4l3Me7XZN1YC9PIABisQazd
         D4PjOcHL8lLAWk4b8uj3ZSzjOhV0W5VhJ0ttqGKtZpw1bUJ1kKd5Ap7R0fqWgReOaJN2
         c9ug==
X-Gm-Message-State: AOJu0Yw1y3aleRbm5ARFkF1lAMF56rMYPiW4ldvfMBzniUueNdVkQXCB
	kwoM4v39nsvgZIjVeu3LMInjQDczSYCm4FUadd4=
X-Google-Smtp-Source: AGHT+IG5mBlw3wr5PKsYkuEkTYsra3ZdB1aft7ZjlwjT5ZLwBCBmO/IK0On1ae0vgAiWOWG8dGIzpQ==
X-Received: by 2002:a05:6a00:1397:b0:67a:9208:87a with SMTP id t23-20020a056a00139700b0067a9208087amr815479pfg.23.1693515889173;
        Thu, 31 Aug 2023 14:04:49 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id j13-20020aa7928d000000b00689f8dc26c2sm1678614pfa.133.2023.08.31.14.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 14:04:48 -0700 (PDT)
Date: Thu, 31 Aug 2023 14:04:48 -0700
From: Kees Cook <keescook@chromium.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-hardening@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2] fs: ocfs2: Replace strlcpy with sysfs_emit
Message-ID: <202308311404.875ABB0A@keescook>
References: <20230831193827.1528867-1-azeemshaikh38@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831193827.1528867-1-azeemshaikh38@gmail.com>

On Thu, Aug 31, 2023 at 07:38:27PM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with sysfs_emit().
> 
> Direct replacement is safe here since its ok for `kernel_param_ops.get()`
> to return -errno [3].
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> [3] https://elixir.bootlin.com/linux/v6.5/source/include/linux/moduleparam.h#L52
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
