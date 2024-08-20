Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B7016D313
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 07:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724138893; cv=none; b=FbCGqWiOAraqJV1i0nh2jILnnqj5GvQeXkmfK7LL7+yrE5r4rplBrw5MNivcN3G896Orp/wePAbZ97as4w5qpHfQveUAv2GmHqlH9H97bQLUrXPLFvgQoX0WPTkoOgCIM4zlRbJJ/T30E7oE+qDHXvZ+STBXmgQZNv9syOijb9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724138893; c=relaxed/simple;
	bh=jkWDW68RAx3HyWh3El60l1g4aMTlaslQ7spXe9iCdNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W6sCAt2a/3lsLIT2B9OtZhA5gXPvZt97szEz4rq29KHJZEl3siSsLjxOQn8iKhS3Me47mM/p03FGoog6532HKx6L30bML7n/4cYFDHFN7cvzvssAQlW3zCL900UUJuHnrz3tFLV+tmYuDsECgDiOqxC17YPlJySF3VoJ5Z4PLGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XbAGH50y; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XbAGH50y"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37196229343so2468246f8f.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 00:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724138889; x=1724743689; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Zf9Rl0UN+cGUF4HBWln7vCOPwms/pNqv52XDeRl6+w=;
        b=XbAGH50yhK9eoozuJnt0kGhQmspY444bRg3JP2ZL8g57z8jUkUuAzeJ5wofBfbYzda
         OJlV5gzk5hcpu13QfknKlJR44tWzqSxD3wGPRzMtjwYII/NfFukGYvXmF4uOYzijbg2N
         y7SSQpiWtunNCW5GFeeWADclnSmm856lBiqJ3Sdc6HuzxkEZp1xp+xLua8Pp63GtrSyu
         +Zw/+ErBlksU7EG3W1W9PqIPXEc0d2vroUc1KbSir5jPjDd73a2SCJk0RZS7UJh2MOTS
         YV6qlgGJj7d+DCDxVUr9se2Ynl/hZGXcIbdFNCOJ2tUSGAie23sEIXfhIBGVSeC4qVPt
         y2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724138889; x=1724743689;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Zf9Rl0UN+cGUF4HBWln7vCOPwms/pNqv52XDeRl6+w=;
        b=aLFShsbc28E/+wgtI5CoEKhGz4BM0dQxAuEBrYhqujMhldAy3m5/11QrPbp8WzJ6F/
         vSsSIjygPqOFWg3SGUAdTl3gqZY6yqgrtAdnY5+9CWQuVzYg1oYM2enuy9ya73h21pJu
         p3YZ/mnd0Y2QuBKr4YisiBHhE5MRX65UHlO7PhYMho2p+4On8ozemZH0RtSclCyXmL1Z
         bOmVIdDFBWNva0MOIkenMiW3Mb9AHjMycXpFo2mPEh8pDCeqaQLrv+adbegOf+MnBPkC
         h3Qji5jB23gAVE9q1wIT6v6PbecKFHAvl9WAHSjDgJZA64Pl3Vl/PmBLdGRUtWGVV8Yo
         eQAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcqiQwKiwhJ2vqeO2LftXbTlksiHhckXqZOBJl9FLdswKO081IkUNV+lFbhHwIfPVPdwIj64y5ne7+eg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxQtentMO5IWhoqLTlh7rZIzqzijyK+oiHFyM3iO/qLaa0LjRh/
	v5p1FgPJhsH5AU+UrkDOofAKHsZKV9MDjgy16cTBxqH/9VeMaOudSBdqEgmLSk0=
X-Google-Smtp-Source: AGHT+IFl1gl5Q3rqnnuhng4dzdFoLHznEATNGgJfs+9boyU9Xon3WFsGG0SpAMYmm8DhzLPdkBA83w==
X-Received: by 2002:a5d:5e05:0:b0:371:c578:3130 with SMTP id ffacd0b85a97d-371c578330bmr855827f8f.8.1724138888646;
        Tue, 20 Aug 2024 00:28:08 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03a35d0sm72569085ad.258.2024.08.20.00.28.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 00:28:08 -0700 (PDT)
Message-ID: <dd5dab9e-112d-4fca-ba12-b6e2dc4856cd@suse.com>
Date: Tue, 20 Aug 2024 15:28:03 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] ocfs2: remove unreasonable unlock
Content-Language: en-US
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <2e662cb6-47d9-4bbd-855d-1f6d5edb8633@suse.com>
 <20240820065511.996453-1-lizhi.xu@windriver.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240820065511.996453-1-lizhi.xu@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/24 14:55, Lizhi Xu wrote:
> There was a lock release before exiting, so remove the unreasonable unlock.
> 
> Reported-and-tested-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>   fs/ocfs2/buffer_head_io.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index cdb9b9bdea1f..e62c7e1de4eb 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -235,7 +235,6 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>   		if (bhs[i] == NULL) {
>   			bhs[i] = sb_getblk(sb, block++);
>   			if (bhs[i] == NULL) {
> -				ocfs2_metadata_cache_io_unlock(ci);
>   				status = -ENOMEM;
>   				mlog_errno(status);
>   				/* Don't forget to put previous bh! */

Looks good to me.

Reviewed-by: Heming Zhao <heming.zhao@suse.com>
