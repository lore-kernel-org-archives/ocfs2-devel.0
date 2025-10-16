Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE9D31D732
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 11:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760615928; cv=none; b=cpY0+gaarj1PIMZn6FIRKITyV1sZTdsJJh6VMr46yG1x5SUxLSzaPvpdVn90M6VcmwXZM9yA9IS8b2AgDze5V+UrSmbDprI4g3q5oQzhG0G+SK2Zj2CJg7xNpBwoHpX/5rNc4YiuUwLd9j57YEOvypR1zDa6AaXV0c204vcJ/xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760615928; c=relaxed/simple;
	bh=jN5ukxPxnMIeutcb60pTCGmhJtVGo8IXrcCa833m3sI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X2Otf0IRjLK9EblqjAkIDArrTMgz9qNjXOi99ng9lehQRGpM04HC/K/2f/ahQNY8iIfUBowlin34JQx20qL46kTdBkLYeFLFFDYieI9i+mVShllIdjvzyg8KDzEItPAxcYYE8sPJY3oCrZ/j+4zEbMn1jX9jaaFlRyGRJyUvIfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UTY8fo3C; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UTY8fo3C"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47112c4abc8so770485e9.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 04:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760615924; x=1761220724; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xufGbtpD6Ny51lilNGjTzP3C80baPcSSLhflrXWLOGk=;
        b=UTY8fo3CRhdi10m7SbJ8x6oNXY9K/y3igkMMPQu3PpntTUviYz/d8PCjwlY8Yq7PHg
         0K6CaYqyZ3Sg8p4HW+eN3Kvuz2UB0mh+mapk6XHFTqnIMslvq6ygaa6uskuA/Amock+Y
         8bLQMkonR1finOwBaSbFgTZVsgGw09CxqzI1Pg96PrDqsNDRCG3R5R1aO0eb6OAcwa8H
         1mgly3JZNpFr0umlvAYAPn1aZPONb/G4daDWWOvkgw2eS+QpQIkNj9wAvMj9xtDO+Vtc
         8AUZVuj11xhua5wBu6wW0/x2uzLNaEPxUMhMdnWsSJQGDIHveYqBcAap99TClF7A7Rnt
         /aDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760615924; x=1761220724;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xufGbtpD6Ny51lilNGjTzP3C80baPcSSLhflrXWLOGk=;
        b=ti//u5kALX9KvVJBeb6C7CIVdpVkb+TdRJmZDTyRldgbEKO1srjt+uZYrc1ms5+Npz
         SbWNtgfZAA2zG/GKsQHt6/rvIzunPp9O7sLky8Tr+h3hb1wJgmPkPcyDsbuGnhHZo3mo
         9t4Nn9yhZrSqoIju7BBv6jqu3gvfLudk3mtAygorfSgKCUlsw6r9ZcYReprCxvf4Jxbu
         XINYQwlPuzg7TsgkLDTevwfdXo+sWY+NUCzVqGYHQMMQGETG6FN9D5fgpgPcHhBVkMTy
         EkIPMu/TCMcPf+o8gBnW9P447trQpFxmfCtziSobIC8WPcNwauUG57olPq1eEySeT44k
         IXyQ==
X-Gm-Message-State: AOJu0Yw5wamgtCmw5P+ovrecqfkd8ra8RiCxefPuqMyyRSboaHwoGUEL
	ULlVZtqmOdr/VO/aWGJLz9ljZs7yDp1eihDFdYYzuO0phjAnSWdL2T1+X+zmVsQaY8Q=
X-Gm-Gg: ASbGncvi483NepOnA8O6G1xwTKsdLb7kz6eq9HOyZmN0bSq6ApO+P6292JU2bMVwffK
	KXGKvA1QG5XL/dZQRhCCAYVVVgrgsNOwBLWkcHj0wAefIhDekd9NOK0VV3VAh/kw8CjtYh9zw2o
	uQ2WkOkfx8BqEmXg1Fc8/y0BFvse+nr76dn8LzhrBV6mhqimkvbBu4WGguTnvEsxrgFimE+proL
	Ft4t8vTOdZY1xrqhKkcxn7JFoOzNB9oBdWfOSXH1kOD/XIlGytZLS3xRSJi+TFEkx6yxxNqa1XU
	Vey/Cyo+9lVRcoHxyLXOCllu079DfbH8YZq1UQp3FnXf0ncck1eJMZdk4ijJOX4zFsgrZtAWCBP
	cd/VfD97Oj+dtlwZFe7HBl7xQ9nBQpPvSrpAFXA2+iXlJn9ElimBGIok0A2CEku/9S2y6vZlAFR
	95Ah9dGfEkCwTA6e8G4g==
X-Google-Smtp-Source: AGHT+IHDYjJ0QnFpeedcDLcaSztvQB3NrK22LtKH3FeiwOs5aik8az+OP93OlDqr2qx5trKIm5Qrsg==
X-Received: by 2002:a05:6000:2012:b0:3f8:dcfb:131f with SMTP id ffacd0b85a97d-4266e8f9a36mr11340491f8f.10.1760615923945;
        Thu, 16 Oct 2025 04:58:43 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d09659esm22429709b3a.45.2025.10.16.04.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 04:58:43 -0700 (PDT)
Message-ID: <fe37aa24-30c0-4c7c-83de-e3df6a9dac6a@suse.com>
Date: Thu, 16 Oct 2025 19:58:39 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add directory size check to
 ocfs2_find_dir_space_id()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com
References: <20251013103709.146001-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251013103709.146001-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dmitry,

On 10/13/25 18:37, Dmitry Antipov wrote:
> In 'ocfs2_find_dir_space_id()', add extra check whether the directory
> data block is large enough to hold at least one directory entry, and
> raise 'ocfs2_error()' if the former is unexpectedly small.
> 
> Reported-by: syzbot+ded9116588a7b73c34bc@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ded9116588a7b73c34bc
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>   fs/ocfs2/dir.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index b9bf1428a3d9..3c2dacba9b0a 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -3444,6 +3444,14 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>   		offset += le16_to_cpu(de->rec_len);
>   	}
>   
> +	if (!last_de) {
> +		ret = ocfs2_error(sb, "Directory entry (#%llu: size=%lld) "
> +				  "is unexpectedly short",
> +				  (unsigned long long)OCFS2_I(dir)->ip_blkno,
> +				  i_size_read(dir));
> +		goto out;
> +	}
> +

The 'goto' will use the uninitialized value of 'ret'.
The others look good to me.

- Heming

>   	/*
>   	 * We're going to require expansion of the directory - figure
>   	 * out how many blocks we'll need so that a place for the

