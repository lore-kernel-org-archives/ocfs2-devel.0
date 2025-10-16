Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226A12D3725
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 22:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760653237; cv=none; b=Fd8f1mLwd7/s+lyjbzsiH0ZdGh6ta+DGj4w4I2dMV+4UTfjtLD6p/2605V+jy8B8qbxi6GmGXQM6bbRVox5aoV/PVSsMogpTDKjBbfdOTMsDZzcy4+K7ZAvUs+2P2aSGOi+CAjoRIpv8SrKbcWat6i+lfh6hnVVqADgeYxyoWwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760653237; c=relaxed/simple;
	bh=6FEXu3h8BVdtBpTimsrRsWnRgSyl81nyKH4qALOQlV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t6WyoDKcm0HwKclwrZjaFAkYDiCAlVLwGG5A5pzJ88zwT5KFxowNRBWcVl5ob0d73Q2wffEFxDIGpNdHp718wIpHsymzt8Opaiwalbtjo1DxkIEVv5aMAzk/Ib4+l+WCXpWWlORpSlaODkVTj04DpedxGXvL05aaEOrMorHMNdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XBMd7G9u; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XBMd7G9u"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3fd2dee5c00so69378f8f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 16 Oct 2025 15:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760653233; x=1761258033; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XUTJlYcj7JGKZbvSbrtWDKF+Sr8w6F4cuqACEvXHC8A=;
        b=XBMd7G9u58omlEGxR8b/7FvaRCI8mwBByECCMhbRgJJDMipWxNYgNo41Z672/VY7tp
         ZQoZY2E7d+/T9Tcr0bM7iLu5XXVhBkEpSJQmhq0M/oxaRav+OxCke6M0VjsMN2tLpNx7
         HXehQfhI7IsDs7+EESBy9CANURuruzaYvcaEw8PzuV0zyC4LH6qaUNn6uAfcKgNvL2SH
         Q04TflT4xQmCSwOHOarS54pXlqoixhptWzJ269yY+KhV/Wi2OI/68QPJyfK1TCZeziSV
         k10Pccao62/18kNy0BMNkMkwzqOrkJAuhQUYxHraacE0Ur9JQ77VUY9BfH2PyqmPprff
         pvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760653233; x=1761258033;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XUTJlYcj7JGKZbvSbrtWDKF+Sr8w6F4cuqACEvXHC8A=;
        b=B6DmW9a9FLLXOMRMCcZTBpmwy/i4KAYB9WjxbJTEXh4HHaTAOmHS1e16ccXs1EHHv2
         pLzxTO012CBLK2ZVe1WiZ2pz0kR+CtiFD/7jVEiL3VtxyUaiXn74ze2Xtx0NsOO3VQgg
         ROfsycNQJpda7WX+q0ApnNMxnGVkHbFVB9VFV2UQaJ+3kPV8tTnBLLHHvEr+09wuWVkD
         dRbxCHMdqYybrytu3EXz33gKVDpDigfvGayula3TjXReL3YJOI9l8+aWFFcpdzgde6uy
         bo4ksrimFJN7AKzlb+OqYRGGwrq+vj5CCThdqYZWRTgKCLsaVMkHKq8EX1GnwxxEMtir
         6pOg==
X-Gm-Message-State: AOJu0YwoT2IuEky7Udf265DQVZMlfqBeXjwNTnDIeiji35dIwe2y1TPr
	S6WwT9RFUXHvhRPUkX2eYSVdc8OIRbHydxRtdMBENXyunbTei/tMT9ARYiX+WhGclhQ=
X-Gm-Gg: ASbGncu40C1I0yapyuqLimz8BNk6k7CRuUp/ePTk+hGlSuE2ZcznXj0qDMXgMzyeQrM
	RDmJtBJPboaKciWSnadwkLwD5FN9pScZtiWOAxyeVYp1NMFmhTRYRTOSa0mVWNd9NmSzegHtuOy
	Zw3WcOJKfmHZM/oRM9jtHeq4iCiGs5vXSxylnTA0874oPF4ZqMQMxbuEhY/Yp0hNKokQDcRj1Rp
	uNBWlIk7UDJdKr6BDTxFRq7zrlAaUpfsM+z0Ox9+Z+Q7GKQlbn7fe/aVDWPXC7bBDvB/a9ja74C
	jbQ+ORswTHtGWSY5ADbr5SvMCAlBQpsGE9nl5UBm8hW6c4hn0JPe3E5bKcKa6GqQEsr50BMfIEg
	nuxoOmY0qiUjbkiXkT5acDQtfxf9pi3k8noZocMKnCQNtKnfeP285JVe+igMmdDCF3vxB6An2PW
	CiB9sKBMt/ge6nioZm7g==
X-Google-Smtp-Source: AGHT+IFEHDy3iF4THQQ3Htl2bdjRa7NunpwwtZJhMvW3h//08zNYAxpcbbeqfrE6Mj8jQZpANfM69A==
X-Received: by 2002:a5d:5f49:0:b0:425:86cf:43bb with SMTP id ffacd0b85a97d-42704e11cc7mr637490f8f.5.1760653233448;
        Thu, 16 Oct 2025 15:20:33 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a22b9c315sm3907422a12.29.2025.10.16.15.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 15:20:32 -0700 (PDT)
Message-ID: <fcebfb3a-31c5-4833-a61e-ec4500ba8f8f@suse.com>
Date: Fri, 17 Oct 2025 06:20:28 +0800
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
 <fe37aa24-30c0-4c7c-83de-e3df6a9dac6a@suse.com>
 <4a5bae73-8831-4bf5-ac35-690380ad7ce9@yandex.ru>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <4a5bae73-8831-4bf5-ac35-690380ad7ce9@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/16/25 23:25, Dmitry Antipov wrote:
> On 10/16/25 2:58 PM, Heming Zhao wrote:
> 
>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>> index b9bf1428a3d9..3c2dacba9b0a 100644
>>> --- a/fs/ocfs2/dir.c
>>> +++ b/fs/ocfs2/dir.c
>>> @@ -3444,6 +3444,14 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>>           offset += le16_to_cpu(de->rec_len);
>>>       }
>>> +    if (!last_de) {
>>> +        ret = ocfs2_error(sb, "Directory entry (#%llu: size=%lld) "
>>> +                  "is unexpectedly short",
>>> +                  (unsigned long long)OCFS2_I(dir)->ip_blkno,
>>> +                  i_size_read(dir));
>>> +        goto out;
>>> +    }
>>> +
>>
>> The 'goto' will use the uninitialized value of 'ret'.
>> The others look good to me.
> 
> Hmmm... 'ret' is explicitly initialized with 'ocfs2_error(...)',
> which is expected to return either -EIO or -EROFS.
> 
> Dmitry
> 

My mistake, the code is correct.

- Heming
