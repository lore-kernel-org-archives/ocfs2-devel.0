Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F72616DC29
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 06:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724220988; cv=none; b=jvHVmbFGkF0KtkAACpXM4+gbKGSlvVqdQ4skqoDyzvMnf4PkiP100xGK93REWR+CgRCvnEiT6jAb192Fnm8jm28ZfZFSFgDAJ2zwZ+36payVLBPpoXujOJVdd0S9fhiyQX+t2kwWRqQG7B5ZitJutpbHsAzJrHN3sEA6l+kqDNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724220988; c=relaxed/simple;
	bh=TFCz7PQJhvKH/U686Gug3qL4/gmui/CXF+yBlr+kKtw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JT+v5zH48+8Dzjeyxw/kAfJYdeH4Pe9r5T7hTwrFlLJ+BVNbnj6V2titBjtHTvFnqY40E7eQTrwvaAljNNRDEWQMtbloJQdU4389xZPVPgvsMpMRJo+tmWgeWqhsm021KUDqezXwkB730Hh8eut4QheqpLPzm9EkLt3at8TCE4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aKb0yiAt; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aKb0yiAt"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-530ad984f2dso84190e87.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 23:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724220984; x=1724825784; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9P4gcxzVu5ZblE5EZdgIWz1gVNiyAoJspohsbbpxAWw=;
        b=aKb0yiAtQplSXQ56jGZOuebwinJlkotVGIAKtuSVv8mZaOSWal0/QHEtZwJWjsMxuv
         tm09on1q++1iL5BiINZV4WUrEoHlgeFtxYAqajjRnSvbSeq8iaVBgEOWkdtuNL3kmtpI
         +PUvGhueK1y99uto6GzQSq0azz+/dCoCBAmPZtfA1fcfi6/tX685PuVBo5hGdMXkRbJ+
         Eahpkj9ORJsnzkNH2CSBf8o4qV010tWJwuAVllVmNoUAlOrwmvDiHucixVQ/XQ3mDIch
         9Ovky67qyMNcayGa9NKPWJkiRvWQQ5TZL2J9oE2afM7QmX7J31r6NE499egkaAaXb9/H
         dlgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724220984; x=1724825784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9P4gcxzVu5ZblE5EZdgIWz1gVNiyAoJspohsbbpxAWw=;
        b=DqCy6qeBWlT6lM/RDQcFDxJVsTedIzFpHBtWsw4ZTUjjeGgy3etCRfpnqMUdz02Lfn
         Kn9nj67VpoW6c0cks0aRaZOwxJ+yBQnPktb0k4waK/ipFg3klGdA64ghbnNKLRhtcYca
         1gxeQPWv9khCCzh0zAyFcxSegT0oYUkiEboGNUrptrBsz8FzB9h9WfGDyE1nO5uJ4gJF
         hzrYrdsvvCBtQTMwDMwVeu3hcEae0WVxYeoC1za3OzxfkH8sw/iC87pExExVKGIYcW8g
         Gw1fi0d8gnwoWEnOQ+frXL8Ntxq13baP47G5FkoYwwk6CMP994g+KZ6cFlv+a1ehM8B6
         lMPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuCIWU/bG5POnSyzAjokb3mbr64VKcCMTLLCrmMhRShVnIVKFeOdSS5DeYKdZ46zl5yW0yMoEgWMS0mw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxArBeng4dN+aWyx9AQC92r9Y3LTLwNfwvN8eidtXmWyFd5KaZO
	JH2EuUmjd8Hw1IWNP/YCGMqBysRJtTUgq3wEYWEMLxaED4YtJ68/H74ykdlaihU=
X-Google-Smtp-Source: AGHT+IEurWlDkBYCwKYc8PABk6orI+cY1w8eBbYayTY407u5x81wfTTYFYytldOAJ71ExMNirgbCdQ==
X-Received: by 2002:a2e:be9e:0:b0:2ee:e196:1486 with SMTP id 38308e7fff4ca-2f3f894c99amr5506261fa.4.1724220983530;
        Tue, 20 Aug 2024 23:16:23 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127af18899sm9182877b3a.155.2024.08.20.23.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 23:16:22 -0700 (PDT)
Message-ID: <1c4d5baa-0ee9-46f9-b7d1-cb69387cc0d0@suse.com>
Date: Wed, 21 Aug 2024 14:16:17 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Add i_size check for dir
To: Matthew Wilcox <willy@infradead.org>, joseph.qi@linux.alibaba.com,
 Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com,
 jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <0000000000005894f3062018caf1@google.com>
 <tencent_EC9ACDC0793A6F742D7D6FA094F0E96AEF0A@qq.com>
 <ZsSvbDxMtUEHEldl@casper.infradead.org>
Content-Language: en-US
From: "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <ZsSvbDxMtUEHEldl@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/20/24 22:59, Matthew Wilcox wrote:
> On Tue, Aug 20, 2024 at 08:08:38PM +0800, Edward Adam Davis wrote:
>> When the i_size of dir is too large, it will cause limit to overflow and
>> be less than de_buf, ultimately resulting in last_de not being initialized
>> and causing uaf issue.
>>   
>> +	if (i_size_read(dir) > OCFS2_MAX_BLOCKSIZE)
>> +		return -EINVAL;
> 
> Surely directories can be more than one block in size?
> 

The key point above is that the patch uses a hard code value, but in the real world,
the blocksize can be smaller than OCFS2_MAX_BLOCKSIZE.

-Heming
