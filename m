Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6051DFCB
	for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 11:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760440564; cv=none; b=HEnTg9bLOCz2kotOF2NKF8I/Hpv7o4Qzu7yULFGLhCxScERgT6sXx6EKAXyby9sgyqlolJpsBctJ99OSFkQgQ+iKMJuD70I52jiQcadJKTHdneRkovbQ3Yzk//7pd2jBVewVsoRyt4xctqK12a6kBMaSseMctabg/P//6PDw0/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760440564; c=relaxed/simple;
	bh=jVgCEn6FrOb6YjDigvZEdql71qMIQzs98E/O4XCOTQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lyizVWnpNRxNpTi1KR8K0AAWt0/c9zFmukwXfzBI4gPMM3/c3tkH2DbQrN/0kDjwUcd89LPL9pIEpBSqJ0fj6hf5Zs/yKxSJ+4uSrmm6CFllVIgZDkneKLWzAQiK2ES7REGjn9QrGOFzh0KMweS8LuNDyw7NvA1+ebwiFpP5aNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gWFjHau9; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gWFjHau9"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e704b11afso5266165e9.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 04:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760440560; x=1761045360; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=afCbx/A0i/DOfy/4hguxibdFpeY68y1Vn+7Oepnc2KI=;
        b=gWFjHau9ErpL57hdo4DwERuA7a9B2oE40knqqLMjLthnAnC9a8m/f3/4iPfDS2OmNg
         JzMYKPY3iHg/0ER6y6CRjmc8g2FA56j3C2TSMOWOyq0XP5ivJK/Lq2+hmR3F1RnHW1Z4
         wDR76uHs1YW9RIWTlpMXaP81spAOKt5YAwIg+bw8ZeykZVXVsKicJ2QthLzzncCJeEY8
         aFnBMHusa5vDpyB8Pw/Lb1xjQaTpubQKW8JpmxnGavF2Pg22Hu0vB4GKyILtF2P6P26y
         SUFQTpl9oBZgO+77xiBK57M7FRba4ctVhBlIBkG+heBmD8Tb45rc+VtLdvftIb5EQ8eD
         GUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760440560; x=1761045360;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=afCbx/A0i/DOfy/4hguxibdFpeY68y1Vn+7Oepnc2KI=;
        b=c8lwe2gwSrAJ+ZrbEAGgtS0nt6JYEnxrjb6GhRdLfZqOiklhvMqTQ4gSlR+072OFr7
         ckTxatJMNmxw+znPXR0Qk997P39AQgU8Vj4uVmOgvi25mD9gAC+pZYRuPp33GEtSpyBI
         1XyIiEm+62Czzc/Zc7WGjztsZwkXpEIs5WFhWAufAwZyIJpbHfx2/HsEETJAwHQlmHE1
         ekezARpmayOmQAZSl0PnqqHBKBTdvf3xXPcsruqO1Rvg5RTk/E0AjsecpEtxoKZBDLbA
         TbNpawOcmmSh/VKu0sCeFi2Nq2lE6k4uSWApqAi91SJXKsnvBvg/KHtCgvtl0uVsGOyO
         svJg==
X-Gm-Message-State: AOJu0YzbYTHYbkJ9+ix/ThU3YDPg9//xCBArCs6o4wapP6u5s98tnOI/
	JbYnyc0E8tn7PfjkD4WECmgAMt3kYWAQzpZGXOwxaFSBsJgFP86m4IFt3Hu70RJgz2U=
X-Gm-Gg: ASbGnctAc9dmu02Y6/3evbzcPqwzuCgijUHH40U6uWKlMAz6bCyp9Zeux9jSog45x4G
	CYy79mAKWSIHxNn87uXKzv43EcXW22Ym+owiGTEMX0yICVvw+OqAabFj3PfcJ5izxlui4EoxGA7
	e6IzAxDNf+HYDNLNF8BAv1ovc8kdOrQHLDyMNYuUbQSDryvfXumb3tbVWvZaXNoemsPnvjKT4NV
	tA3zpZaa9VXciyfnQKIymjpUGJhBAtjYxHcTA9lcH3a+N44ZWJgpN0juAlLs3rkspN645P89i0b
	WAHV14YngChCHySY4nQHTqRqs/+Bnrv64n6s/UnbYhAsx/H4MaUC8ntOBBCMarUV8OzhHgroail
	7GxvrYUrr92tqSB5DweltZUtXqCQa42ACkmZ0KmiA02kDxSk=
X-Google-Smtp-Source: AGHT+IHlPjoz5CjQmKoK2haCEeji+l3VucGIX6lZ6ILwAROEv1d0cXsvlRJiJqMjjjipcbAMLZNA6A==
X-Received: by 2002:a05:6000:2401:b0:3f3:1be5:ecbf with SMTP id ffacd0b85a97d-4266e8e1e70mr8516528f8f.7.1760440560075;
        Tue, 14 Oct 2025 04:16:00 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b252f23sm14598009b3a.6.2025.10.14.04.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 04:15:59 -0700 (PDT)
Message-ID: <548ac524-c625-46fb-80a0-e89ed132822c@suse.com>
Date: Tue, 14 Oct 2025 19:15:56 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix __counted_by_le() usage in
 ocfs2_expand_inline_dx_root()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org
References: <9efedaaf-3600-4d1e-9fb7-77f55f1524e5@suse.com>
 <20251014070324.130313-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251014070324.130313-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 10/14/25 15:03, Dmitry Antipov wrote:
> After annotating 'l_recs[]' VLA member of 'struct ocfs2_extent_list'
> with '__counted_by_le(l_count)', 'l_count' should be initialized
> before touching 'l_recs[]' with 'memset()' to avoid false positives
> from buffer overflow guards when CONFIG_UBSAN_BOUNDS is enabled.
> 
> Fixes: aa545adbe491 ("ocfs2: annotate flexible array members with __counted_by_le()")
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

LGTM.
Reviewed-by: Heming Zhao <heming.zhao@suse.com>> ---
> v2: adjust 'memset()' call to clear 'l_recs[]' of 'dr_list' only
>      and initialize the rest of the members explicitly (Heming Zhao)
> 
> note: since the commit in subject is not merged to upstream yet, Fixes: reference is taken from
> https://web.git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-nonmm-unstable&id=aa545adbe491
> ---
>   fs/ocfs2/dir.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8c9c4825f984..48b092bc83d4 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -4104,10 +4104,15 @@ static int ocfs2_expand_inline_dx_root(struct inode *dir,
>   	}
>   
>   	dx_root->dr_flags &= ~OCFS2_DX_FLAG_INLINE;
> -	memset(&dx_root->dr_list, 0, osb->sb->s_blocksize -
> -	       offsetof(struct ocfs2_dx_root_block, dr_list));
> +
> +	dx_root->dr_list.l_tree_depth = 0;
>   	dx_root->dr_list.l_count =
>   		cpu_to_le16(ocfs2_extent_recs_per_dx_root(osb->sb));
> +	dx_root->dr_list.l_next_free_rec = 0;
> +	memset(&dx_root->dr_list.l_recs, 0,
> +	       osb->sb->s_blocksize -
> +	       (offsetof(struct ocfs2_dx_root_block, dr_list) +
> +		offsetof(struct ocfs2_extent_list, l_recs)));
>   
>   	/* This should never fail considering we start with an empty
>   	 * dx_root. */

