Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC6C29A2
	for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 07:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760169523; cv=none; b=F2jIhdh/NTvV4UATsfYxPgKIPZt+GbpEKWKyBLEtdMp9LveepZhrRnsWZfP7OyFud9GkvAO0eLexWYwalcP2McOEwiyN2CFQrziS5bWJTRemVKzOCeVpNP3XHiLM1WD9xOZsWiTeuKuyvBdq05XDWrbahndxDdotgDxFI/T6ofg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760169523; c=relaxed/simple;
	bh=g1l8uiYdYFyPf3PGJbLoEMwMj8D+u9+L+Sf3q6mE94c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hneSQXybUUV3cP+xdeHBlGKBAX0C6cDp4OB08yVa70qsCZDj5B/240dWWPXakGyyjBdUOTbC/bdxja7UaUDD/V7oSfK1sXYNLmr8nh+XNARRjhiFP0bdrC8lh7jzKQSHCZUaoxf1pjztjiJ3UvDxGx5AbpL/jKtcevISaSO4kxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X779hh6H; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X779hh6H"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46fa4dbb72fso3067315e9.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 00:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760169520; x=1760774320; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VTdTmd9CSCWbkb4ZyEoH2o1hIcmNQge2MsncONxRn1U=;
        b=X779hh6H8FwfqanZ8VlhfKibel0GLS45u7IcL4N5DCrv5DFKfeRntIHBBRJchdYA18
         6Vxzt2Ad9eV1KNDcaAIzX1J0n5gOUl8tCyXHlr3TeSBJswC+m/XVd3Xjsggzdc/IwfCd
         LLXnoPWi/1OGSc5HZ+R2TCxHSHVncLZZj3opIqMvYYJDs8os7TmEX6dfgWJQ730v+htf
         hTBTfPRx891iMSQP08e8qkhoR58PsJ1MVSoCqpyg0RCOqj8kWza7mF/Vnv0AO74LYX6L
         5wIBZYpaHP9vpnkcDZ+h9Mfr6goOhpEixeWTSAsNinWmkIIINPJ2FNU6aBURNxLRgqyH
         CV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760169520; x=1760774320;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VTdTmd9CSCWbkb4ZyEoH2o1hIcmNQge2MsncONxRn1U=;
        b=EzDyE/8t7Dkm8ky5egHqFGsEDn6CgX3QV0arHizcJib/lKVIGHBFglnWEoSdxntqeF
         wFyCrzM+1FtYZa1m+dBaME+pQHR2EjkE5sOwwWiySphD37DibHk+YG1GBd47B4C6Y/x+
         Yk+vpEUnu9k+RyeCwpDxFaXqIMxjRil50MkySyCAjfKPNTo4zEHmoB/q5n4vgUCdaD8V
         HW6o0JpqXzTthwiJRqS1GR0IxIaOJigih99hDXqTFggRuMQ5jIFFD6EfSGz/zvuh4dtb
         Hr5hKu2DMt+1oYsHfzz3SK1wBgZSjt0E9eyj/cLpnppmEFDcmVWbD8a1903JKFW/ZgyR
         giBg==
X-Gm-Message-State: AOJu0Ywsb82OBbVegltjURLSRRmLO934FMP9p3yEDWsCX+7R7sZn4IGi
	76HnMCRv4cBfTYwFMljcXWCyDEQleKCXr399MwZigOhoagzV9f2143BOLQZJhU0VEiY=
X-Gm-Gg: ASbGncuK2YqDv/CNAAn1pz4VqASWoNo/6uQbu8yaxHyhvplAwBeAqcMS4yXR3V2qsbM
	vWVGDM+0vwReUGlZ0NNtidXFsncAlO3FpmdITBT8mr7uIXcLp2VAdTrJEWhEtmiFJEGl1k4WXaj
	4k7piiQ0ZFCP6rzBsvOBrzakRBocze9daNdER3GC8FHrh0RNBpTlW753HEl6mrRvLg1ntqCeMxu
	xWhETP8WHoCapUOAEnMxHszceLAcBynjUxk7zufJYvlw0W6ehiVv93ugDjW/EDaYrh5TgL9XpGH
	aH5dgmLkS92h5o/PGvpFvj/M4wnyVm/AM6JY3fPwWrdk7X4i2zsPZh/0dN68RS4eecpYudx97+u
	HkjsPCZFwq85M1qJSkA59I9wOFZXbefRVCFUWKFJakfydI7FP
X-Google-Smtp-Source: AGHT+IFy0FDYLzTatUSP9howClZ2hXz7lv/MEiAVdZs6RnwZirAGgS3mSgGc6R44VjXeDDPAudj0yg==
X-Received: by 2002:a5d:5886:0:b0:3e6:270e:3f64 with SMTP id ffacd0b85a97d-4266e7e17e5mr4838627f8f.8.1760169519750;
        Sat, 11 Oct 2025 00:58:39 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b5288043fsm6009751a91.0.2025.10.11.00.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Oct 2025 00:58:39 -0700 (PDT)
Message-ID: <f5c8060f-fff2-4c16-afec-ac750550cc30@suse.com>
Date: Sat, 11 Oct 2025 15:58:34 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add boundary check to ocfs2_check_dir_entry()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com
References: <20251010092130.621495-1-dmantipov@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <20251010092130.621495-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/25 17:21, Dmitry Antipov wrote:
> In 'ocfs2_check_dir_entry()', add extra check whether at least the
> smallest possible dirent may be located at the specified offset
> within bh's data, thus preventing an out-of-bounds accesses below.
> 
> Reported-by: syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b20bbf680bb0f2ecedae
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>   fs/ocfs2/dir.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 8c9c4825f984..c523816a3ebb 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -302,8 +302,20 @@ static int ocfs2_check_dir_entry(struct inode *dir,
>   				 unsigned long offset)
>   {
>   	const char *error_msg = NULL;
> -	const int rlen = le16_to_cpu(de->rec_len);
> -	const unsigned long next_offset = ((char *) de - buf) + rlen;
> +	unsigned long next_offset;
> +	int rlen;
> +
> +	if (offset > size - OCFS2_DIR_REC_LEN(1)) {
> +		/* Dirent is (maybe partially) beyond the buffer
> +		 * boundaries so touching 'de' members is unsafe.
> +		 */
> +		mlog(ML_ERROR, "out-of-bounds entry in directory #%llu: offset=%lu",
> +		     (unsigned long long)OCFS2_I(dir)->ip_blkno, offset);

The fix method looks good to me.
Only a minor issue, in my view, the following msg is better than the above:
directory entry (#%llu: offset=%lu) too close to end or out-of-bounds"

Thanks,
Heming> +		return 0;
> +	}
> +
> +	rlen = le16_to_cpu(de->rec_len);
> +	next_offset = ((char *) de - buf) + rlen;
>   
>   	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
>   		error_msg = "rec_len is smaller than minimal";

