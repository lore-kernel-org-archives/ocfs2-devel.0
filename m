Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68A684D0E
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Jul 2024 10:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721386612; cv=none; b=DMUW23sG5fc6RSteqF/i1nk0mS0QdiPVkaFq9LXmZaBXRqptxc+/6d/x21h6kn4kJZBt6GBz3upAV07MIPoS9qF8YpkbpnlslO7eBseydYPu4cBRL00XIdi0KKRCeHjHkl5h7vuTMzzVgJQcmTdHp/R8Io61twIKEMlPGKFerLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721386612; c=relaxed/simple;
	bh=yC2kWoKtjDml20rszDnN1gZKEL3PSeDXeMMjRL29voI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LO60Ofd59+WayObkD8mJ4ib79l4kA4ZUMgdzb3fhqvpM1yHPIOf/cOfcaf47UKWKjXosoS3rtPqfeftxa/jMidPZHO40/U86hp7Nc9IsN1crEMcUDtFHg7HuGgu8n+ckNHA3gAZZnB7guzfrSF7OtUMOw4MqiKqy1+sniUCcUBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d5v5h57S; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d5v5h57S"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2eedebccfa4so20584921fa.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 19 Jul 2024 03:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721386608; x=1721991408; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zLR4A3xOeoadTP7LI8okfAGJVhT+c0LxTEw1uv1DQNc=;
        b=d5v5h57SN4rFLmZILR+uTyZoCiLFXtbpK+BksZkyEA6acwoDWRIR49dQgyJUTScBWa
         lJ9ewQ24E+oFDx1bh3JRf+2mENCqW5qw9cu+DiVZyfhZsc7rtSxD59GxIUAkpbk3+LmI
         koI4h4kude1M12AFbtxr62eDiX9ENMNTeaSDpd1z+s54A3VOsxpelMpylQunQsQxgZS1
         SaaCGSawbJjrmEX4ZSlb4V5o8Es+P/oFl4c3ibuGU0Ir/x0iLiVLP5nJVTR5Ya2kZH8Z
         AVy/Wv+4RsNvWHbX83ys2YiC7iWYMWKVCnn0IKnQFaAf2F41YCXtzh0Nu6pmuCZeJ7rD
         p2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721386608; x=1721991408;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zLR4A3xOeoadTP7LI8okfAGJVhT+c0LxTEw1uv1DQNc=;
        b=BHi24NuPjXHtBwd2glIquUvSck0Sl1pkZO1sPLB1lUmha5jSMJdu64Rk9ZX4OyRgTm
         cwotn4m4MpzoMg1wGNugQf7FB9S+wYOzDkIi7Gr5iEA91FtBdW3abit7EO5eZUpFt0tC
         To2P7f8HKKAwJlW+62D9W6MBCIY4FGK3+eDrX0GiskQjwfCyvkkw3NAtT+Jjwz1Y1MIw
         iq52D1uY7+xefcaEtc8vW660zZcbdWrbj6QtNp9YMlqG3xnXaNkp8Mfew2iIEVojeG82
         Cx/WGqmuVp43CmHFcGsd1kmNiji6giZtpdSVuK2gv/nktU7Ecyxdj76oLg5EBpdD9t83
         oqGw==
X-Gm-Message-State: AOJu0YxZJQcSv/eNHsJ60Z4CKQKKamDL6tNB0x3SxeGppJZBz8//A+Am
	zTw0AvvIPn4gdczsanVVs1CdHrIWMT4Ibbi5RUaDiLZBnnsoJOaGBpDyppe5yD8=
X-Google-Smtp-Source: AGHT+IE0lRg/GUbfKQRdZwhvxfO449vCeTIvltCs6NNJxHUOK2AsDz47/qolfuUg3Z8SQX3Mv4QgOQ==
X-Received: by 2002:a05:651c:c8:b0:2ee:4623:93e with SMTP id 38308e7fff4ca-2ef05c784e9mr42422191fa.20.1721386607812;
        Fri, 19 Jul 2024 03:56:47 -0700 (PDT)
Received: from [127.0.0.1] ([172.98.33.42])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2610c716e17sm258735fac.12.2024.07.19.03.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 03:56:47 -0700 (PDT)
Message-ID: <f35d8c71-7fe9-4c32-bf40-6037a9312f95@suse.com>
Date: Fri, 19 Jul 2024 18:56:38 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: fix the la space leak when unmounting an ocfs2
 volume
To: Joseph Qi <joseph.qi@linux.alibaba.com>, glass.su@suse.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240718021842.7595-1-heming.zhao@suse.com>
 <dcede907-e830-4fe2-89ac-ee0d1cea7940@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <dcede907-e830-4fe2-89ac-ee0d1cea7940@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/19/24 16:52, Joseph Qi wrote:
> 
> 
> On 7/18/24 10:18 AM, Heming Zhao wrote:
>> This bug has existed since the initial OCFS2 code. The code logic
>> in ocfs2_sync_local_to_main() is wrong, as it ignores the last
>> contiguous free bits, which causes an OCFS2 volume to lose the
>> LA window size space on each umount command.
>>
> It only ignore the last few clusters, but not the whole la window.
> 
> Thanks,
> Joseph

Yes, I will revise the commit log.

-Heming

> 
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> Reviewed-by: Su Yue <glass.su@suse.com>
>> ---
>> v1 -> v2: adjust 'if' condition to make the code logic more concise
>> ---
>>   fs/ocfs2/localalloc.c | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>
>> diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
>> index 5df34561c551..8ac42ea81a17 100644
>> --- a/fs/ocfs2/localalloc.c
>> +++ b/fs/ocfs2/localalloc.c
>> @@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(struct ocfs2_super *osb,
>>   		start = bit_off + 1;
>>   	}
>>   
>> +	/* clear the contiguous bits until the end boundary */
>> +	if (count) {
>> +		blkno = la_start_blk +
>> +			ocfs2_clusters_to_blocks(osb->sb,
>> +					start - count);
>> +
>> +		trace_ocfs2_sync_local_to_main_free(
>> +				count, start - count,
>> +				(unsigned long long)la_start_blk,
>> +				(unsigned long long)blkno);
>> +
>> +		status = ocfs2_release_clusters(handle,
>> +				main_bm_inode,
>> +				main_bm_bh, blkno,
>> +				count);
>> +		if (status < 0)
>> +			mlog_errno(status);
>> +	}
>> +
>>   bail:
>>   	if (status)
>>   		mlog_errno(status);
> 

