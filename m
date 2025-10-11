Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF3D21B905
	for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 07:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760167905; cv=none; b=nPEAK2LYYptvAQfsjA7eqCZ+cnPtdNOJRgkQq8QWa4rkvAKyGL6/DiMujYvB3uVV9oiKWgHCwsnPIAemTguMikQjyg/1DkhadrLcxNynZcb59e9Pm3mxbow8JuaedA5TS99SrOSBfdTZkT5WlyaQRkP9iAHJBqTXFuRIMfQ/vmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760167905; c=relaxed/simple;
	bh=4ZQMZ6lu98hFT5R3rQTJZOSGHKLpEJ+yNr9McwBwSuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ADQ7eGSnPZjwysIo1A5pXIFKqZzb5AZptEETAqqkISPTi4MRSGeISYR13gSmzUrJS/E7IciiqNcSjVArmm+cwFHEuhn/JK2N149sIsfVrlWdMASKyb5aLlQIWQ+92Jm80cToQf7DBheYd29BLC6S77L/rl44+W1b0ysBOpXWNf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TiNkCN30; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TiNkCN30"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e33cec8edso2096815e9.2
        for <ocfs2-devel@lists.linux.dev>; Sat, 11 Oct 2025 00:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760167901; x=1760772701; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tbYY7sY8Jo2X7gob7T9wRzQDhnsoRHBvrry0f0lUkwI=;
        b=TiNkCN30SpA75kxEAW/2EtvB8sDwYIAyfMBgKq/eQStkjiQlhR4z0yHOYaSWLUJ0BQ
         QrNYsH0B+na8LHiaMzW/R03444+1sM3teuqwmUf/lMar3HoMDwhYyNqT54Eq03u1OALE
         KkFc81mpQkC7VD6qBp4I4zAVIWLbpgHtLb+vjuAPDidqDlFpK+wwi7LtpNefTq5N3pQM
         kmxZXz0BmYj2SJbhAAWBG3gtwERe5tK2+CWYRlwitDOPOlakoeIFswNIONLhSvo8LszL
         7hjhRyAfwzR9XFYmVY/b8TbkerwE3Ml7HTO1RMc12tZPAVzc9metKqoRk/5Ut6Z3GX75
         LYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760167901; x=1760772701;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tbYY7sY8Jo2X7gob7T9wRzQDhnsoRHBvrry0f0lUkwI=;
        b=X2oDK85me7yOOz6sctnQbgdpS7duDtETSeYmCpQ0UgkWMn2PWX57TQBVA/Wz5HfcSb
         XlPyC/+q0vdaGtJv8KEDgGfQkULi+bgTJqUKvCG9Hmk1sqpn6V217f9pZes88Jl7bzIf
         P0rhuRZ+pYiJntvfadUmZ/JIcJWkjIpD8RAH40d7UyzVRO6LckSZSlI+zgP46+r8V/p3
         Sw22rMbCllIjqu2LpuIp36Y4xN3aATq21eTp0nxDHrzSpFuWBiXf/qvhPMAt8lkvzj7V
         qN70rOVQQK5YEN1uXTtT6a8JHfHbkICpvYW1er2KQ6PdCf41mDdEkObcUXjWjMtP+4wX
         xh0w==
X-Gm-Message-State: AOJu0YzFoFHPeWd2cgtjAcx7Kl5duURq+vFtDYTJYlnv1Enjntn4uI1y
	2c8zGa5tErQYtdQlt5PfStrBo8wVtkiI9cDs9koQNgHs5fG5yRRzNlg/izmgPhwT7jA=
X-Gm-Gg: ASbGncvsNY8Ja4j5AB9ubXXajnFp40LTi1TmY/fuzqG/JFrD+5jr/FGSjnPPCXSVj1A
	/zTVcZekQGLfhoet4TAQgbHzlsu3cuhX3l57nYyjAJiMHGTzOa8OSZPx4LJR9iHSSEEyA3gimNj
	caMrRWOqAEA9bmI3iKpdDmBhSc857V/mryqF+g+YN9Wo53Bnag9FLlvcPiortyWj16ApRYzS/27
	iJSwAILvYIMFI6ecQe2Tv9Cw2drUASd7SwkRI0cZaB1Ze1YQhHgmtkWWJoQW6xmxDI8V4sXbVEt
	VYnmf1J2AHdxZGux/zS1y6Gek7Z1CWBvxpUDGIHsPlIMphxSgbpb3Gte9L3aV+Hio7Dlcf78/5u
	YN2vfDK6vGaAdPq4Qa4ONgG6lCf+X5HkLPrKguS6VW3jNpn8mvp8EhrIR3do=
X-Google-Smtp-Source: AGHT+IH3Fu1/FK2XkLjEzPs+tdGWk8//yg/29/qkmRtovY3U1OJ54a6kwdpjvuNZuN8cPifJyZtrZw==
X-Received: by 2002:a05:600c:4e93:b0:45f:2919:5e9c with SMTP id 5b1f17b1804b1-46fa9a8ae60mr55204465e9.2.1760167901536;
        Sat, 11 Oct 2025 00:31:41 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626403desm5241528a91.7.2025.10.11.00.31.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Oct 2025 00:31:40 -0700 (PDT)
Message-ID: <d4398dec-0b71-4070-b542-b595edd0f8e4@suse.com>
Date: Sat, 11 Oct 2025 15:31:35 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: clear extent cache after moving/defragmenting
 extents
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>, mark@fasheh.com,
 jlbec@evilplan.org, akpm <akpm@linux-foundation.org>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
References: <20251009154903.522339-1-kartikey406@gmail.com>
 <94c9efca-2805-4fcb-a52b-e26eac8f58e1@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <94c9efca-2805-4fcb-a52b-e26eac8f58e1@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Joseph,

please check my comments in another mail.

https://lore.kernel.org/all/20251009142917.517229-1-kartikey406@gmail.com/T/#m0c02c884701c12d71206d0f9aba4450879b18e0c

- Heming

On 10/10/25 09:21, Joseph Qi wrote:
> 
> 
> On 2025/10/9 23:49, Deepanshu Kartikey wrote:
>> The extent map cache can become stale when extents are moved or
>> defragmented, causing subsequent operations to see outdated extent
>> flags. This triggers a BUG_ON in ocfs2_refcount_cal_cow_clusters().
>>
>> The problem occurs when:
>> 1. copy_file_range() creates a reflinked extent with OCFS2_EXT_REFCOUNTED
>> 2. ioctl(FITRIM) triggers ocfs2_move_extents()
>> 3. __ocfs2_move_extents_range() reads and caches the extent (flags=0x2)
>> 4. ocfs2_move_extent()/ocfs2_defrag_extent() calls __ocfs2_move_extent()
>>     which clears OCFS2_EXT_REFCOUNTED flag on disk (flags=0x0)
>> 5. The extent map cache is not invalidated after the move
>> 6. Later write() operations read stale cached flags (0x2) but disk has
>>     updated flags (0x0), causing a mismatch
>> 7. BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED)) triggers
>>
>> Fix by clearing the extent map cache after each extent move/defrag
>> operation in __ocfs2_move_extents_range(). This ensures subsequent
>> operations read fresh extent data from disk.
>>
>> Link: https://lore.kernel.org/all/20251009142917.517229-1-kartikey406@gmail.com/T/
>> Reported-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
>> Tested-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?id=2959889e1f6e216585ce522f7e8bc002b46ad9e7
>> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> 
> Looks fine.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
>> ---
>> Changes in v2:
>>    - Fix moved to __ocfs2_move_extents_range() instead of ocfs2_refcount_cow()
>>    - The real issue is in FITRIM/move_extents code path, not COW path
>>    - COW path already clears cache at end of ocfs2_refcount_cow_hunk()
>>
>>   fs/ocfs2/move_extents.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>> ---
>>   fs/ocfs2/move_extents.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
>> index 86f2631e6360..10923bf7c8b8 100644
>> --- a/fs/ocfs2/move_extents.c
>> +++ b/fs/ocfs2/move_extents.c
>> @@ -867,6 +867,11 @@ static int __ocfs2_move_extents_range(struct buffer_head *di_bh,
>>   			mlog_errno(ret);
>>   			goto out;
>>   		}
>> +		/*
>> +		 * Invalidate extent cache after moving/defragging to prevent
>> +		 * stale cached data with outdated extent flags.
>> +		 */
>> +		ocfs2_extent_map_trunc(inode, cpos);
>>   
>>   		context->clusters_moved += alloc_size;
>>   next:
> 
> 

