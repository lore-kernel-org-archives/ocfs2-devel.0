Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C481F238C
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 11:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734003919; cv=none; b=QnkkR/7Im7fzREmNsvjAz3mP+RHhsYVUoEf3kP6qUOG6th5qkM5X33kF036KDYEgLv6uZ9T8R0G1unHyJ1PH9P/aQvYDUKTY051LDoI9uUbTd6Z8dMwyOBAQRsiff61qO9ctBBCub6wmCCEyzMBvDNdotljpntiQ3bKKZ22/MPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734003919; c=relaxed/simple;
	bh=/AeMddT5I/7ORa8Vq3OjuCXXDJmjVLBFui+0F4NUov0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SqXOFVMHsnGI+mZsIIZHhyvORlPKyFauNwxscvQwpfiBOhwthu8TNHfHGqPNm09TFzOoYJd6ox2r0xxmted5aJcPyRtGJKiXnsw7H0r4haah6+wif/TvCrxlpP5bjV3263sEO3UxUFsiqSBzme/FzPOnUUtChSSlQnqruToPOgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vu5K2ssg; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vu5K2ssg"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-385db79aafbso36392f8f.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Dec 2024 03:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1734003916; x=1734608716; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gNJ2NNXOEYsaP47VU4MW29jbTvfPJgrGv8fsDcVmvbY=;
        b=Vu5K2ssg1EEt6OqmgnZm+xHm3duTRKRhsTlxKgsi0YwEYKJxBYYxaZpZa7PBa0P+nW
         0FrQqJUtwXErI9JJ4AMsgFZqp7INK8tEk2UpT6AAbAPcdFeGphhr+oCcm0Xix1BOiR6s
         vuEnjtC6q13FAZcet340zBu/5sg19Y5tbyzV4O13P0vgU+JqJlqVnZA0SVrVQwJR8+XJ
         JyFZIC91iDC3VF8xmzt29r3GJm59WJfLkTnpl1N9ECsnPOG4Wvl//CQLUSQkxIJpJVsk
         zTc6z2TOz6o7iLHQg0h6Za2NjBy4wBMjy7q9aNaS4jRI+8kXmrB81DhEmnsgfGAQKzyz
         12tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734003916; x=1734608716;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gNJ2NNXOEYsaP47VU4MW29jbTvfPJgrGv8fsDcVmvbY=;
        b=RXPjNb62Wqgw3WDU+3lneMa/vJZizYX8JfpkoH7/BulHXUK/qQHsfzVDbIs3X3iFqV
         pc4ak9gWQbULWZ70Ot2muFa03Ycdtk20Up4BuHsAaJiQXP744yVqZXJjrClNaG+EASJj
         6r/KsLZAnwrG/TePub2NOI/zeAtbUGHxefguTYesOdjZaKGCzxM6PKYwzPDZlVXQSUaV
         P4j1nZGsjzVRRmQJQ4F3M4nhNrqxyxQcmqtlDxq15ZvomHi/87tfZO4K9Cxr5AFV3ZNl
         cAgKEnO3yOe+t0G+PPol6RgtLJu2RVdeYZcHDMs/+tE9JtG3JiMgEPTUNqP+uZNB3IOv
         723w==
X-Forwarded-Encrypted: i=1; AJvYcCXQCkW1prVim4/xo04Ps12MPPnhvkpTrxbcQvK6VUCTWgLkxojGky1jRy05qK/9bd6jeG9YbuJ9VntXcA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxvYfbm7ZV7gDVvnBPyw0BXygKt8PNy+r9vn8udZ89RzgHQItvU
	dE/Ep3ZRWMirMi/7pKQneLT0KRs85BS2S5R48yX/onN5nf9he+UvVO/TUkPE5ys6pf7IV73SU7j
	SBpw=
X-Gm-Gg: ASbGnctEb11zEejpEIQsYz6L/rDfsLiU11uxFxzUU79dwrfIuVf2JrZZip6FR5fZ3w5
	9oFHVDY/qkVoCgPrRT/XqLEPTdpr0W09dUIsY0Lw4PGZqxdn2dGuJ2SS3bQjVqUpSatdR8+zTUr
	PFzHvlMKC0fqesqH5EZ3T+7MQ+tOAmJ4SnBUo8NVYaZv8qkpEKPQsdJ1IWrIO5OcPfbs2nX9nw+
	ziBxQYqO89lWK0CV0NTkeqML8MdX4nhsmdnFctXnDNHA34EtBUrrTfsvYdI
X-Google-Smtp-Source: AGHT+IEq35k9CwEbCU11uF2TKeyxIO7Vf7aoHPTQorzrPZxcWI2W9+Q+cuNSK/R6YL8Vw1DfHHFb5w==
X-Received: by 2002:a5d:584d:0:b0:385:f1bc:7644 with SMTP id ffacd0b85a97d-3864ce55aa3mr2023500f8f.6.1734003915850;
        Thu, 12 Dec 2024 03:45:15 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21615dba950sm105039195ad.11.2024.12.12.03.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 03:45:15 -0800 (PST)
Message-ID: <92d413be-286e-49b7-a234-b6e2c8c94581@suse.com>
Date: Thu, 12 Dec 2024 19:45:11 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Revert "ocfs2: fix the la space leak when
 unmounting an ocfs2 volume"
To: joseph.qi@linux.alibaba.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 ocfs2-devel@lists.linux.dev
References: <20241212113107.9792-1-heming.zhao@suse.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20241212113107.9792-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

The 4.19 branch also needs this patch.

- Heming

On 12/12/24 19:31, Heming Zhao wrote:
> This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
> unmounting an ocfs2 volume").
> 
> In commit dfe6c5692fb5, the commit log "This bug has existed since the
> initial OCFS2 code." is wrong. The correct introduction commit is
> 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").
> 
> The influence of commit dfe6c5692fb5 is that it provides a correct
> fix for the latest kernel. however, it shouldn't be pushed to stable
> branches. Let's use this commit to revert all branches that include
> dfe6c5692fb5 and use a new fix method to fix commit 30dd3478c3cd.
> 
> Fixes: dfe6c5692fb5 ("ocfs2: fix the la space leak when unmounting an ocfs2 volume")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Cc: <stable@vger.kernel.org>
> ---
>   fs/ocfs2/localalloc.c | 19 -------------------
>   1 file changed, 19 deletions(-)
> 
> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
> index 8ac42ea81a17..5df34561c551 100644
> --- a/fs/ocfs2/localalloc.c
> +++ b/fs/ocfs2/localalloc.c
> @@ -1002,25 +1002,6 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>   		start = bit_off + 1;
>   	}
>   
> -	/* clear the contiguous bits until the end boundary */
> -	if (count) {
> -		blkno = la_start_blk +
> -			ocfs2_clusters_to_blocks(osb->sb,
> -					start - count);
> -
> -		trace_ocfs2_sync_local_to_main_free(
> -				count, start - count,
> -				(unsigned long long)la_start_blk,
> -				(unsigned long long)blkno);
> -
> -		status = ocfs2_release_clusters(handle,
> -				main_bm_inode,
> -				main_bm_bh, blkno,
> -				count);
> -		if (status < 0)
> -			mlog_errno(status);
> -	}
> -
>   bail:
>   	if (status)
>   		mlog_errno(status);

