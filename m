Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD0531770E
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 11:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760614217; cv=none; b=W0dcM/Ers2d3O1fkQlhky26NEvXeI3j86/46W3P/zOw3bxhrQt1TJ2IEh8YV45uCvywmFB0PkFEcY/4P9Yo03wOT+AQXlRK0petOvpcD7a6LLYwANa9sdvNtDRba0co99reL79bdUmHg9vyXgEvFHzSmNiJGFSqNUhrbzihjoD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760614217; c=relaxed/simple;
	bh=5ntrQM6L99NgqdmUnRdb0LRxcH84Vvw86SDhvDKyC8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CrGHOBLZOv3KvM3ZrtDb9Kl66W0fbQmccHZYgmdwvnh5X9rOmSL/RbDYBF8RjBbecU2Ff21P6CvMOnnFua4d6gmqbQsmV/CI7jpCLT5njNsK/ITs3nDX91zZbKIuUOOmPkoH3rsSb51ESsDWPxXdki7NWRcT2ZKyQXUKje7yGds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VdCO4nMA; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VdCO4nMA"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4710653ac03so527625e9.2
        for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 04:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760614212; x=1761219012; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=enAWEL09vKC2NwB+BawYCi+Urjez76Tm/Vm2TR9o3JM=;
        b=VdCO4nMAEswoYTiS4k0joVBm8EGABI3gUG5k/MKN1JACwbxjSfBVCJAzD2yU6iKKsl
         hu9aH3xO9CT2Fjt2jgI5sh04ALCiRC/X2lABF5CMG5MFfCvCLI4YIS1YOLXmbMOeiDD6
         qxWUZoSCbpg/eFiI5XIAxehqKDe7fnAa1xsRUtbDmz+pntbvHT7uPkr1c1+qVpoHKZL+
         9SLtoiGurgqtnkS+hYsuvcqpwqumomUJne3ExUyNSLeRltQiXI+QM6ZS64uWSeQadAyP
         kAd1FL82dmuVZMKR70vtuf8ZDFNCKXr5RZq/ihS5OuSKHr4cjJ6kUKK22t+Ev45NDrMl
         uVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760614212; x=1761219012;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=enAWEL09vKC2NwB+BawYCi+Urjez76Tm/Vm2TR9o3JM=;
        b=NOBF7s5ruUXx22Y8Bloksslslr6wN136UloboSlYANqugN0Bnc7KzB61XjPj7/k6t1
         ufIQeMuFlttvkugwFXRGbM8gOw10kVWqSkMoW5ud6s7ePN1zwzMVXvApEEHnjG2O+POQ
         TCcmapwq+LJKx/DFXquqnnDDlIi+lESGciO0Hx2CM4bNULTgNeLaVzz20hoh8XHyJf4b
         5qEVXBt/557XR41957a325rZQ7qbytMH76fHb7TJerkE8eGVglMqmMtHAr4hR0tCulmZ
         YI9+ju/eoNxryDk59pKzE8wEeyoxKmB7UWsuo2YWaNo+VWNTiHqHMqiFCYQBZcf2WBin
         oJ7Q==
X-Gm-Message-State: AOJu0YyFxnbrG8iHkPW61ntc4LtNy3O1NAI5+0riXFjiWwFLnukX2fFN
	YWb7AG8HdG26QJV2JIwE2XdKjrdjN8K6LdyXCEb4H09nX1z2qWc53Y53F4hx3L4mQJgSvLL9TSq
	ib0bv
X-Gm-Gg: ASbGncvypbX9sUBvYhfOqf7v3FgGVr1U/+WuZSHS21p+zzS0irjyLWexTOfT2jY3jkA
	MQfxYtTd7q9HndHS85je0gPa8QkvSO1ZJ/UWWmPs1aDDTFhk/t7Ef2rTQk4wCUpd1gRu64jxslh
	4DdKWZgEIXlWMfO4ednRVvPFcolCxwThQuuKMQ7ySc220qBSCIEAEeZqubqJvCixE/azjxflyEs
	25GLDM8DOIZe5RX+yfJ83gw10/RxagUhnU9+kZQ8OYqj0AswiHb+84rohjHKrE5LhuPObyU1BE5
	grL5b+4bSmZllsj/I8nA4LXfKOSgj00XLSWAs8eUKOi2JJWFabxSphltKJmVrWhESF/RKekeNvU
	oh+9ZPCGrrHu4iyo/k18c/CiOkNC5aCL//CCKWqRh7p1inzKydJbx8Zupb3kzB+V/oHZ86gVh8I
	qdlXN1Dhg=
X-Google-Smtp-Source: AGHT+IGAy09iB4kEnziK5wNCPnHZrGkcA4D71INdDVgXDgJUyVnOlwZ3Vg3BJPpRzh+YXJ3vosNqLA==
X-Received: by 2002:a05:600c:4745:b0:46e:36f9:c57e with SMTP id 5b1f17b1804b1-46fa9b07766mr125851685e9.5.1760614212310;
        Thu, 16 Oct 2025 04:30:12 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099314ceesm27398605ad.16.2025.10.16.04.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 04:30:11 -0700 (PDT)
Message-ID: <ed6e60dc-6639-44d7-80b1-35e87cf4d409@suse.com>
Date: Thu, 16 Oct 2025 19:30:07 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add chain list sanity check to
 ocfs2_block_group_alloc()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
References: <2d6351d4-c753-4a95-8036-95c991524de6@suse.com>
 <20251016084653.59686-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251016084653.59686-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 16:46, Dmitry Antipov wrote:
> In 'ocfs2_block_group_alloc()', add an extra check whether the maximum
> amount of chain records in 'struct ocfs2_chain_list' matches the value
> calculated based on the filesystem block size.
> 
> Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

LGTM
Reviewed-by: Heming Zhao <heming.zhao@suse.com>> ---
> v2: remove redundant call to mlog_errno() and comment (Heming Zhao)
> ---
>   fs/ocfs2/suballoc.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
> index 6ac4dcd54588..e6d4f5015f84 100644
> --- a/fs/ocfs2/suballoc.c
> +++ b/fs/ocfs2/suballoc.c
> @@ -671,6 +671,11 @@ static int ocfs2_block_group_alloc(struct ocfs2_super *osb,
>   	BUG_ON(ocfs2_is_cluster_bitmap(alloc_inode));
>   
>   	cl = &fe->id2.i_chain;
> +	if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(osb->sb)) {
> +		status = -EINVAL;
> +		goto bail;
> +	}
> +
>   	status = ocfs2_reserve_clusters_with_limit(osb,
>   						   le16_to_cpu(cl->cl_cpg),
>   						   max_block, flags, &ac);

