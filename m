Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F8C1C6FF6
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 02:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760583272; cv=none; b=jv7SVokLKSxpJ8BTzF3Fte+7UxB8z2wIwJjBZdRxYZMHVLsrvmGeDP5zGLuHISDBsUqTrnnGNAm8N3Qbwz9I2GGF/kQsTJgfKqeRWruLpwHmtHgwbDqhBGLSWzoIIriyCCbOFIhtFMvujg5MuYK0EogNOqL7/8yNCGHQuXAAOgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760583272; c=relaxed/simple;
	bh=KHCHcBVWvAp9hjz+XRUbtVuTiqk7hL2hNvDca/3lxLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cQE5aWxQEW5HHMYooswuTEcYlGmVfR289JkNiVB6ceULq18xlJLVKFLm5UsByaSwfyXWlxXRSTiEjfv2EUn7CF4BNZP/mggN6g5vDj37qM+ufcxBEFez9rXGGIaeVom4kjbcsQYmfQuN2rlaJCnVu6Dx+3g1ZmswmzCbux2nl2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=boDaulRf; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="boDaulRf"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3fba2c43a16so6019f8f.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 15 Oct 2025 19:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760583268; x=1761188068; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7zdsiyNtTOrbWAfftvy9D2zymsgyyWUuWQ3WN9aBcjI=;
        b=boDaulRfLp2WT+8cQg/v+s6mhIHa9rX6LdCu4V5ZmtEmwu8Bgitv/PJ2yO+xzLWEf4
         orcy13ROTxOxqeGUrzs5gQF2fn+f24oxYwCs/aK2M3jENxDo8FZA+6ZBnr61PWIBqrRu
         6Frx64tjV+/e22XTUIhnyZQzkZmYh8xbmgjW7zzU8jmU1cAa4iMDyirPTAG9DRPFKdbU
         YlfCy+DFEhizdmlJTLrkC/3ZS4NXB8MQrdZUHRKWuhQGTPM/W43RrXP+gx5SB/R+AN7Q
         78wrwglo2OCf1NjLscc8LyfXv/kGPLtc90UBN4ZGwsY6ExT/GhcCpt7A22nRgmq8SOqL
         Q4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760583268; x=1761188068;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7zdsiyNtTOrbWAfftvy9D2zymsgyyWUuWQ3WN9aBcjI=;
        b=eSsd9Mp3Dg8EzM+0CpXB78TMTPgmsh/x7aP1N17j/2I6LPY/jXaoK4stOVeZoSAdVa
         f9qwXc3InKs5IgpSTUZDbFOF5bPScwqe5f/cc03Oq89KZ0aEiz7BSVc0wdfzb9z7cAS9
         4IE16z4GuObbv4tJDb+zyI9w5pPLtzbslgVjiBS4AoDihubpTCH5Q+hT3+RzrmTyfkhA
         IhDrTlz5VJA6EyIh4xj3vhPDUHtjPjNGEV0tW4jkznaMURdCrv3yNg6AJvSTXz4+A7Ew
         cQl0Qz1l4vr5+lvkGjx/4TrJZGYKO33b7sQGzuBg81LAtGK25JRrlTydn0H1XV8Ksig1
         gKgA==
X-Gm-Message-State: AOJu0YzdbnHeGbmd0ce2KxFxg8OrK50fTJuqfDVS8/y3GxNNMuCW4/XK
	fEY56jEg6iQD3AXayPXSmEoZyGO9ICTzlGhz2X8sMNA+LUXYT6n7zh4QDQ4A84N9+7E=
X-Gm-Gg: ASbGnctLoR4xHUHV/7HP6Mgeuv2LrFbTkUzY73a+fL+asU/TjGjSKKJOBu3rh41U8gE
	aO9mK0Iu4c6MK+lXY+jG/aQbZMDyUn4pv64MvoBsHiJdsA8Now/9WQEGfVfHkLintpNvb5nsNkD
	BDrjKZLGoDl+EbLKlQhWMPDngl7gy+6X6pcz/LPLj0kdl1QqjrWOpPeCdYkryLfoch9JXqKp9M/
	kfGkA5uLAdubR6aMsUVb8BZj5TPrp4AFrJy53hu9EjLub2KKBNxmFGqJNGVj2Izb2tYdv+kFNNO
	c2pFsbh/zMtPX0ho5QJhIUhxIM+PbKPGvdv5/MtHEpVvUAQndxNdbJuRHMBgRQSMioYbgIOpJ1P
	7Bf+lfVZPzmHaNDZih4zw0o+PK2CcSMAbxWTdT70oWM/Q/RKxPRS3jsj+JLIru+lZxmUxm4Rjmx
	V3iLaQ65vZcto86akwqA==
X-Google-Smtp-Source: AGHT+IHg+yxHeng26cP4CglEdtG63FS4tK7ChSAtJNFd+xFlNSVYBMalcCWAwI8SI6nGffU3fG6M3A==
X-Received: by 2002:a05:600c:c162:b0:46e:6778:c631 with SMTP id 5b1f17b1804b1-46fa9a214c4mr124448655e9.0.1760583268143;
        Wed, 15 Oct 2025 19:54:28 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a228ab568sm1039159a12.16.2025.10.15.19.54.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 19:54:27 -0700 (PDT)
Message-ID: <b3a5af0b-6b83-4a2c-bd91-b0d43c6946ba@suse.com>
Date: Thu, 16 Oct 2025 10:54:23 +0800
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

Hi Dimitry,

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

I can't imagine how the last_de is NULL here.
Would you give more details for this patch?

Thanks,
Heming> +		ret = ocfs2_error(sb, "Directory entry (#%llu: size=%lld) "
> +				  "is unexpectedly short",
> +				  (unsigned long long)OCFS2_I(dir)->ip_blkno,
> +				  i_size_read(dir));
> +		goto out;
> +	}
> +
>   	/*
>   	 * We're going to require expansion of the directory - figure
>   	 * out how many blocks we'll need so that a place for the


