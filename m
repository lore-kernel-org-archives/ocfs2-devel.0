Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6756F22FE18
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Oct 2025 01:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759281174; cv=none; b=SoamYXpJV7vHWW1bNrD+2yUVdMcr+kE2PkuEoBzQLpD3DB8SpSrl264yGZOShZKTdizD8SB0OrfZ2IJecY2lEXAUB6ypoauhG3o1UQG02TPPOFJi2ZKOJ0/w1DjSp6Adl/i/yBDgLV8Wstlt39H+MxcwKGXc5T3bnrRo5ITWghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759281174; c=relaxed/simple;
	bh=HcaXh4P9HgGp/QKV4iNNFCz3EFW0eIMdMUIieGhQ0UE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cH5NA7V79TejWtJ4pHcp+V0Zr5ah3XYsf+z9NqKxEpEoNnjdaq6zBMT2FFptpF6wy+/HnZLWNFoJGrYykfTEWXT4bjHmUEQzoPX/pV2/GhMniV/tIrQGQ3QNnJgWVmrpEphQWUZOdEQJDo2BONQeTHsyQ+NvUklS8luFArWwHWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EsvlJZun; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EsvlJZun"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e2cfbf764so8829775e9.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 30 Sep 2025 18:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759281170; x=1759885970; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+yAwyN5j5aLe+2zl6/iClEiJPWHXrqzCkW8YeMKnmtg=;
        b=EsvlJZunWRnHc46SmVgRFobdtPtWWyxMgXNnnXdkapN9NE1VpG60aKaAPHsRxjexx0
         vJFImQxhRupm1J6WBcMi0VD9dVPToP0DGEC+s+3fwx2ZDiWDb/TL3LdT0BdQVjjfiEHW
         m8OvIVHwzD2mbgLpN/5G7eFpxRpCc+q4AHkWgwuGknF+G9Wa3WQE0gj0GyWepbYHr+9u
         LDU4wHqzFMJ6HvKkwD40aIxcvpBsxI8RY35LBkAR26uMHDxnKusm2kEVkV04oowfrDIL
         RmqHRjFhUoxasYQwqNpN70Ec7b6ddaD2j2/VyK94jkDyDaxJTVHgDs6Mfv2YRxSOLFKY
         Barw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759281170; x=1759885970;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+yAwyN5j5aLe+2zl6/iClEiJPWHXrqzCkW8YeMKnmtg=;
        b=HqLVbRHmbbIdsKo79p5c8e+l2fi+d5ruo1P1HJRFgRN0+KVYt9ZaUAP4qSkdf1+BlO
         Q9AxMDUpX/OIr/jOyXPHbAeSisQKn/TqKVl/TVERXFoM+EdxIFWB4XIX+3Fw3lKNwboP
         f3tDyEVE4cHCoV2KGZDiILDSQVyjnyLjDkvSZ+j/WadClkD07eeR025du7HIVXuqMT1u
         4kNSm43E1Z842u3SeOnBkvrbMNVSPZylTk7ZVtTSPcapW9deI+hZCtNn0okYpADUZIEc
         xkaNiuBou7e+9+6tYqOGk+cPIHyReD0IIXpmQB0s7cDFCBWXc3+tEjKavhLRUury8lo6
         pqWA==
X-Gm-Message-State: AOJu0YzCaTGs7HraZVa9cJ0X+VJxO0ldQlPHrdU9cHcpQ/JrrDtOhXXM
	UkFqKEySWmYVZJjFdhLr8cbTJ5+6x1NE4XsBQhM5FwQehbrRRV2M2TZNq2qmd2rCFZE=
X-Gm-Gg: ASbGncur1PYbeh4CWdLH49yZk7WHYq9dR0RgIkw/JgSbTXIfHM1akiafqF7Iz5LO/+1
	WMhiuMzEdrhU416HCET1KfkWwC2caLSvWhRmvYt0FAcU6nWFPcjYAUykBiivlv4uMCKM5SxGFr8
	v5xmLEIjO2jXJkcApXfFjAFHfwunql2zIq9o132CWZMYjfEzCAJrJlgzs2cd/zTKox5qh/HxdIH
	SPsQG6zL5gSCcS58VCHdpGktpaxeOKpxUx3Fb33tkEtgSOm0AshTGWQiCWG6XiIRHva/9+/p0d9
	QDEFr3VgWJgjYsBZHN2ON7fssKRHC5NTexNOXTTlyqcTI/rvSnlTHxEkf9G2XvvAuLDVfXu5nn/
	vtFVvo6Z573rg+WldveH8zRTJIFZGntxf6R9/+PFz1F4WiiT6IjXT0/LQi5R2orgW
X-Google-Smtp-Source: AGHT+IH9RhDHohCs00KBpDY16zwzq4wmV7w/S02iV0tUmgTukDJU4Z14JEZ/9KGgnPXyhUOOH5CXMQ==
X-Received: by 2002:a05:600c:8b16:b0:45f:2d07:7bb with SMTP id 5b1f17b1804b1-46e612861bfmr6751915e9.4.1759281169640;
        Tue, 30 Sep 2025 18:12:49 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339a6e9d25bsm857845a91.5.2025.09.30.18.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 18:12:49 -0700 (PDT)
Message-ID: <8af5355e-5a05-46c5-bee6-c7ed3de71c0b@suse.com>
Date: Wed, 1 Oct 2025 09:12:43 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add extra consistency check to
 ocfs2_dx_dir_lookup()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
References: <20250929170434.1757820-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20250929170434.1757820-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 9/30/25 01:04, Dmitry Antipov wrote:
> In 'ocfs2_dx_dir_lookup()', check whether an extent list length
> of the directory indexing block matches the one configured via
> the superblock parameters established at mount, thus preventing
> an out-of-bounds accesses in 'ocfs2_dx_dir_lookup_rec()'.
> 
> Reported-by: syzbot+30b53487d00b4f7f0922@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=30b53487d00b4f7f0922
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>   fs/ocfs2/dir.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8c9c4825f984..ff632f1337b7 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -865,6 +865,13 @@ static int ocfs2_dx_dir_lookup(struct inode *inode,
>   	u64 blkno;
>   	u32 name_hash = hinfo->major_hash;
>   
> +	if (le16_to_cpu(el->l_count) !=
> +	    ocfs2_extent_recs_per_dx_root(inode->i_sb)) {
> +		ret = -EFSCORRUPTED;
> +		mlog_errno(ret);
> +		goto out;
> +	}
> +
>   	ret = ocfs2_dx_dir_lookup_rec(inode, el, name_hash, &cpos, &blkno,
>   				      &clen);
>   	if (ret) {

In my view, relocating the sanity check to ocfs2_dx_dir_lookup_rec() is more
reasonable.

Another minor issue is that EFSCORRUPTED belongs to jbd2; we need to either
define it or simply use EUCLEAN instead.

Thanks,
Heming
