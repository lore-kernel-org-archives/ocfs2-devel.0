Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2727F
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Aug 2023 03:44:53 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-68a3ced3ec6so1688470b3a.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 21 Aug 2023 20:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692675892; x=1693280692;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hCylLQkD6CaV3LKHdHG4LUWPES565jK7zTqu20KIiGA=;
        b=Pf6D2uMDIcpNkZI0XgOnB47yazEZL65WItEK4Br1cXPiIPJaqxneCKCZTr6eza+8c9
         Zmh9Q2gAgquzQ/JRjXTom+zN3pQfpHEwsip5snqLmAjWG8xAtkveuaRf5uQdHOJh1zpc
         ohX4rBPvGJy8HkBifxFHQ2D8kHBXxoZOWdkb0UvwWMzcniGzj2GhFPtQHHeSX25/ZmJ2
         m0SmXRbO+gGe3V/I6D0wX5LRMB4le9K8lCe2/YpR64TgoF45HSfPL1x4yJyvXPt1wkVy
         zNsfIgBKZTJ86HFJTlHkvsy5c9aTD/w0IN0YAfx+5E1mXK41NRuPbY3WrbJ52Toi5Y6c
         1zWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692675892; x=1693280692;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hCylLQkD6CaV3LKHdHG4LUWPES565jK7zTqu20KIiGA=;
        b=bjeXXZqOVCEGAi+RrQj4+OO69ESt4tL9+nM2OzsqUDluihbb5npwsbhM5+DU7JmvFr
         XdIlvFbBIT5ZO0wGByhkQiiTofmR/dOUZBBMChtSZ9TDmnhu3T1EIryaON+GZSJ+wLtY
         ZZw/njhcALWHgtWbOBee8JY9WfQli7caCea2+e03NWVBXolke4jlPKY891RYt4dHYVMl
         ElKMBJ13winO+Vsh2HPj/72UEWpUNWDFa6Ixk3Ek+qwnNM922PXlbKCcolHY9l9+IxEf
         wPfkljYY7JfhoA6Qnm48H5sh8JQ6Jb1FASARGjTY6nv17e2IhNicMqnp+G+Zbjhg+C55
         ixmg==
X-Gm-Message-State: AOJu0YyBOFeBvqoZorXg9aVy3EPcUeOLvdVtW2A0haPZURvIv+aj+Y4d
	ZXfUcnXK84bDTgkDxISqtQI=
X-Google-Smtp-Source: AGHT+IHOl0iCW7g3fa1aMRGtEMjgmOjnJJKaBhqs9cqJN+73H2i56rD0fZB6B0k6UhCbqwCvCLTeew==
X-Received: by 2002:a05:6a00:21cc:b0:68a:5449:7436 with SMTP id t12-20020a056a0021cc00b0068a54497436mr4895777pfj.32.1692675892629;
        Mon, 21 Aug 2023 20:44:52 -0700 (PDT)
Received: from [30.221.128.103] ([47.246.101.55])
        by smtp.gmail.com with ESMTPSA id c9-20020a639609000000b0056569f7cbd2sm6980682pge.37.2023.08.21.20.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 20:44:52 -0700 (PDT)
Message-ID: <04629d94-393d-907a-27bf-789bab239524@gmail.com>
Date: Tue, 22 Aug 2023 11:44:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH -next] jbd2,ocfs2: fix wrong pointer pass to PTR_ERR()
Content-Language: en-US
To: Yang Yingliang <yangyingliang@huawei.com>, ocfs2-devel@lists.linux.dev,
 akpm <akpm@linux-foundation.org>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 tytso@mit.edu, yi.zhang@huawei.com, jack@suse.cz
References: <20230822030018.644419-1-yangyingliang@huawei.com>
From: Joseph Qi <jiangqi903@gmail.com>
In-Reply-To: <20230822030018.644419-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/22/23 11:00 AM, Yang Yingliang wrote:
> Fix wrong pointer pass to PTR_ERR() if jbd2_journal_init_inode() fails.
> 
> Fixes: c279913275eb ("jbd2: jbd2_journal_init_{dev,inode} return proper error return value")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/ocfs2/journal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index 90af6c47161d..ce215565d061 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -910,7 +910,7 @@ int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
>  	j_journal = jbd2_journal_init_inode(inode);
>  	if (IS_ERR(j_journal)) {
>  		mlog(ML_ERROR, "Linux journal layer error\n");
> -		status = PTR_ERR(journal);
> +		status = PTR_ERR(j_journal);
>  		goto done;
>  	}
>  
