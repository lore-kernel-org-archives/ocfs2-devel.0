Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEB0101F2
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Sep 2024 01:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725843789; cv=none; b=ALvh7yT8hs63EEaqlvD09skkHcI5bCPGqfjAxTkahYyf9MeCkvU+P3MYsBXbytp6F8N3R053HgCQUVzZFVwFImyx2xffbdOlIZpZ0S+PQPdx4aBtFVOOHPD5b6Xzxz44qIWvNNYsCgRdZvPRadtSdMnhcPlLjbGpzWlzCjr0VrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725843789; c=relaxed/simple;
	bh=khk30wY3xXyR9sRYV8s5FHMtDbhrQkXYCwdpJoT8eiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lEc/mMy5HUVHgkr+Iud5KLv7EYrMoeemPRL+2AMo1BwU2lU1vezuPV+lUIGHnSv7H/Tk5CY2VMupnRM0L9MYLIDmhDwG+siD5IGwXqtHtxrByfuU38NBdycnsT4ljFutUtv9d7EDj+tMe9SBQN63xFNAG44TPn9kCr2SHKT7sE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LbtXIuaa; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LbtXIuaa"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42ca2ce583cso3748705e9.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 08 Sep 2024 18:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725843784; x=1726448584; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OV7VGKDNa+MYCPDaH3eYbggjB6/nkG30q/dMutycMh8=;
        b=LbtXIuaayJH1O8/ou4/F3ARv6JYu2/Q5Cf4vTGhsEdK66RDJuGVVXDJcfxHx3FJEgS
         uaQ6xU61vNeR61u0eZlq/ehgPPO5E4pYPjfDEmwmXuAN/PAvt697Td5/1fag9zm0rDX8
         xG/BrlvgT0e7JAk4dCzpKaNPn2WUtS6Ov0XwKg4Ewjzo/XE4ErIWP7KKgj3JlfsJaccj
         Nj8vmHQXv+PQj4ndSTQvLe/qJfa3WBm/KSrXJ2WyqktxRpx6RWQr8qxt9xr+9DfJ6KJS
         /gIVJlj0M5G05LKNZT7DpEeNX91vrfO2YFXQeuxpLpbfiuPtKuNRyIj/zdLH+gep6JkL
         eFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725843784; x=1726448584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OV7VGKDNa+MYCPDaH3eYbggjB6/nkG30q/dMutycMh8=;
        b=QTyQiouGgw7QBYEDvNoK+eWxw9e05fauSem2kdDo/4aC3xPEbI9vt/NiUJTsvxHBtp
         p2ZDg0Rgs2OR5w+1FGpNewMSkuRJEh1FMXgf3Twq2wYBcT2kZ5Sd6XkoSEGaQrj3VkO8
         8oWuBeas67FfjtIy0tQxLxNIJavxmF5fEGknQQTOhSpm+gOGT/0jjYBCNNdjiYFTVHdE
         moYICvQQh0xOy8ayBSXV3U0u7wrZu29Vb3HiSgUNM4fFFm3oKMW23w2t0kpnEM4Nwy7Y
         MRu2PLOfud6eddJw5dY0xw8fEVlRPoiEJg5A4pmNHFNGzcoLLUS1LCkdpsM0gROBSe5i
         gstg==
X-Gm-Message-State: AOJu0Yyksi1zkQen0HYA5Fj4TEJGPooe4x8pJ4cJpFjEyCiMVcAR1Bf6
	VxKKoC7u6X69/EXZefGA3oB2XCNlMLRB6fBDicFZyED5QFDnC5l6RNvDRg/LZ28=
X-Google-Smtp-Source: AGHT+IG+Q3rwxK84PkFA2rjUi4Xr9PUnKPR3t9AIPNqqCub9ivi56tLrKglxADx78f/P33lxOLQ8xg==
X-Received: by 2002:a5d:6d08:0:b0:374:d088:476f with SMTP id ffacd0b85a97d-37889659481mr2967933f8f.5.1725843783325;
        Sun, 08 Sep 2024 18:03:03 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-718e58c6a3csm2497871b3a.65.2024.09.08.18.03.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Sep 2024 18:03:02 -0700 (PDT)
Message-ID: <094ef45c-3268-4155-b867-56d06e80ba69@suse.com>
Date: Mon, 9 Sep 2024 09:02:59 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] ocfs2: give ocfs2 the ability to reclaim suballoc
 free bg
To: joseph.qi@linux.alibaba.com, glass.su@suse.com
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240908140705.19169-1-heming.zhao@suse.com>
 <20240908140705.19169-2-heming.zhao@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240908140705.19169-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/24 22:07, Heming Zhao wrote:
> The current ocfs2 code can't reclaim suballocator block group space.
> This cause ocfs2 to hold onto a lot of space in some cases. for example,
> when creating lots of small files, the space is held/managed by
> '//inode_alloc'. After the user deletes all the small files, the space
> never returns to '//global_bitmap'. This issue prevents ocfs2 from
> providing the needed space even when there is enough free space in a
> small ocfs2 volume.
> This patch gives ocfs2 the ability to reclaim suballoc free space when
> the block group is freed. For performance reasons, this patch keeps
> the first suballocator block group.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reviewed-by: Su Yue <glass.su@suse.com>
> ---
>   fs/ocfs2/suballoc.c | 302 ++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 292 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index f7b483f0de2a..d62010166c34 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> ... ...
>   
> +/*
> + * Reclaim the suballocator managed space to main bitmap.
> + * This function first works on the suballocator then switch to the
> + * main bitmap.

need to revise above comment:
This function first works on the suballocator to perform the
cleanup rec/alloc_inode job, then switches to the main bitmap
to reclaim released space.

-Heming

> + *
> + * handle: The transaction handle
> + * alloc_inode: The suballoc inode
> + * alloc_bh: The buffer_head of suballoc inode
> + * group_bh: The group descriptor buffer_head of suballocator managed.
> + *           Caller should release the input group_bh.
> + */
> +static int _reclaim_to_main_bm(handle_t *handle,
> +			struct inode *alloc_inode,
> +			struct buffer_head *alloc_bh,
> +			struct buffer_head *group_bh)
> +{

