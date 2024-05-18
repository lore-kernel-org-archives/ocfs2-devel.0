Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D03653;
	Sat, 18 May 2024 01:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715995514; cv=none; b=g/84IcyJeQJwhKwS11O8Z03HJqoIzYWm7bOUAsQxTRFLSYOyZrpFIVvx7v+ceCHLWq+07R1pETY+ubwoS1QvKC4Rankq6AzLQxFuC3tV9v/cH1gB0vqydtZtutUC2p4xRKo8ZORczAhwn1CtMihnuOxpHkNV3CY2hPlCOI3eUdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715995514; c=relaxed/simple;
	bh=c5iU4d0KugAsNiJ78E34UP2hhUUvKxnLdWrV/fkAXuI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=dNOefcd6juI+hFvcmSzari5LxYlnOPFzMQdp+t/ASy/1841IOrqjj9+fe7eJzOXMpmhWQVjwYoAJ93CTw18jhs5S5eNZljk4EkTXCsjHewS8ncyaOIU3nq5RErlPVR+ep8h0VMaw/YIa3jHS5DpLBbpuGoGh4v5QT2vKK8VQh58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rw0C5J72; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rw0C5J72"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5b279e04391so488602eaf.3;
        Fri, 17 May 2024 18:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715995511; x=1716600311; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=cJqjedwoYcqSzJKmZSEwT+6hVhtxWLfg/8QtauvSdx4=;
        b=Rw0C5J726+Lqvp8SxRcfLwFwto03B1DuM/YzljzpliiMtlGXJVzeJQN3EItAeM4TpE
         vJUKIzpvXD/0tnUDAp6koyOzFi8/vVpq9mz/Z8t7tMoF0sQp/NGK/3ktiVURa4Uy2RZq
         wOe+loKHitRd5yy0J/RPL5CAqcPVyC20bDf/niDsmQag+WKbvAPinPMMtqYJuPZcvL6s
         yBIDnJhDf8edi61Sg+Qm5sYZ2m7zcaIoBPh9VL57V76+Er5uYRECWWezkglbbDlNmlUu
         nYUfiWc/vnKMF1NWBIW7X027x6Fy6vtxd2mYEru3VnOGO9R5udQFC5b9lBs8aliGRtvx
         HD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715995511; x=1716600311;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cJqjedwoYcqSzJKmZSEwT+6hVhtxWLfg/8QtauvSdx4=;
        b=g5PPd0S0FJsx6H1yefMyzaKhORjQc/2aHEUD1Gy0WHHGcRejC4EPFQe1KSejK7wUuN
         SvBUMQX58qydBrL94loxq3o/N4e20d69SJEU5LUZfVAgps2s3QU3DsiPL0hc14zTeD7o
         ldYd49+BZWvKXG9ewn+luNFZHNhvwWuwOZxNUAUiOmVcVVxEA58Zwx/aBiXKVFtSiG7n
         1I0KG2lVKDDeOCdHL/yykTQ4n0s7RLnbaUHtK3/zMyJgSX38L/ZThaAgmDswBpIg8AxK
         GyolrjC05AmEg8fAhwO35DUpMUCqxeW9UV3WZJ/cZNEmJmqOsh44Iftt4Tk1SC9s4fVK
         uwtg==
X-Forwarded-Encrypted: i=1; AJvYcCUgk881BZ6wZ0YYOWATRvFaXZ0+KBdxujRBYyVNO9Lg36PE+azD4VZd9qZK7tZ1O+cxueUJsMMud+xJ0tJ66CHAba49LggM2+zWsbVdZ8NbuA9kr5W4NfTuS8z8Mfqoox1qzQqmcpASKcAjwszPkEMTzDMfIDL50xool7qcECjV02itXesX9wKH/V2oMUgB4B0U7mt+zfpcSbdEcUmM
X-Gm-Message-State: AOJu0Ywogc45qUUAV28y03+ev/C8iEYHFdNkF6O8LIthibAl1N1cqfJf
	um1VUazvORJiW0sCablI3X1KG7UwIBKyCg4WWHf9U2/UQuzN5wDm
X-Google-Smtp-Source: AGHT+IFRaG5+veBhAS+2oO1Mq9a7mnKgK9vX9unu3cCbE/KbyDzrBjSt084GN8tso2cWg108BqN4VA==
X-Received: by 2002:a05:6870:a3d2:b0:240:c8ff:c96a with SMTP id 586e51a60fabf-241728fc1damr27553351fac.27.1715995510785;
        Fri, 17 May 2024 18:25:10 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a66316sm15339938b3a.35.2024.05.17.18.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 18:25:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <64db2b94-edb3-4ea3-87cf-bb91746869e6@roeck-us.net>
Date: Fri, 17 May 2024 18:25:06 -0700
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
From: Guenter Roeck <linux@roeck-us.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Linux trace kernel <linux-trace-kernel@vger.kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-block@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
 freedreno@lists.freedesktop.org, virtualization@lists.linux.dev,
 linux-rdma@vger.kernel.org, linux-pm@vger.kernel.org, iommu@lists.linux.dev,
 linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
 linux-hyperv@vger.kernel.org, ath10k@lists.infradead.org,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 ath12k@lists.infradead.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-usb@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-edac@vger.kernel.org,
 selinux@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-hwmon@vger.kernel.org, io-uring@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-wpan@vger.kernel.org, dev@openvswitch.org, linux-s390@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, Julia Lawall <Julia.Lawall@inria.fr>
References: <20240516133454.681ba6a0@rorschach.local.home>
 <5080f4c5-e0b3-4c2e-9732-f673d7e6ca66@roeck-us.net>
 <20240517134834.43e726dd@gandalf.local.home>
 <5cff0ff0-48d1-49f8-84f4-bb33571fdf16@roeck-us.net>
Content-Language: en-US
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <5cff0ff0-48d1-49f8-84f4-bb33571fdf16@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/17/24 11:00, Guenter Roeck wrote:
> On 5/17/24 10:48, Steven Rostedt wrote:
>> On Fri, 17 May 2024 10:36:37 -0700
>> Guenter Roeck <linux@roeck-us.net> wrote:
>>
>>> Building csky:allmodconfig (and others) ... failed
>>> --------------
>>> Error log:
>>> In file included from include/trace/trace_events.h:419,
>>>                   from include/trace/define_trace.h:102,
>>>                   from drivers/cxl/core/trace.h:737,
>>>                   from drivers/cxl/core/trace.c:8:
>>> drivers/cxl/core/./trace.h:383:1: error: macro "__assign_str" passed 2 arguments, but takes just 1
>>>
>>> This is with the patch applied on top of v6.9-8410-gff2632d7d08e.
>>> So far that seems to be the only build failure.
>>> Introduced with commit 6aec00139d3a8 ("cxl/core: Add region info to
>>> cxl_general_media and cxl_dram events"). Guess we'll see more of those
>>> towards the end of the commit window.
>>
>> Looks like I made this patch just before this commit was pulled into
>> Linus's tree.
>>
>> Which is why I'll apply and rerun the above again probably on Tuesday of
>> next week against Linus's latest.
>>
>> This patch made it through both an allyesconfig and an allmodconfig, but on
>> the commit I had applied it to, which was:
>>
>>    1b294a1f3561 ("Merge tag 'net-next-6.10' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next")
>>
>> I'll be compiling those two builds after I update it then.
>>
> 
> I am currently repeating my test builds with the above errors fixed.
> That should take a couple of hours. I'll let you know how it goes.
> 

There are no more build failures caused by this patch after fixing the above
errors.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

