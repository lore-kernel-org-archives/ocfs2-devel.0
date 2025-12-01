Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFBC1519B4
	for <ocfs2-devel@lists.linux.dev>; Mon,  1 Dec 2025 07:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764573789; cv=none; b=ayMRn0Qry7KjjRwzuUe4FttLLjRSvwnlrLiy4GVaBJTGTvo8LfDlmEgjODigicOMaGm+84jElSgyp/7vkdB6zOE2+q9gs4sjEBzeqyrmccEXXYisOg/FTXef0T2Kt4sy56rIPRrrDB0DQep3paxoxFfuObYpT0qmG2wnbGsAM6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764573789; c=relaxed/simple;
	bh=Yy8/JJenWxU8bQlYEdVlwLq4cA5tqo17rndP0DhLawI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yzwp5uF7eOkx+KZwDo2ZHfsgznYoaJPnBQdJJob7tWOi7BdF9VjxWqCDBxLO7ic5XgW/ToKvW2WsI9MB1maDwFevG9KwL/4D9hKQojTvN5KCq6VqF885h34AwNpQoCT/uP1anpgN/m1HHgb9V41cMwXUSqmgN4Ch7YHT8aQCwgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xkj2lXkU; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xkj2lXkU"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2957850c63bso28519715ad.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 30 Nov 2025 23:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764573787; x=1765178587; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nsPYaeG9WOKt7UvSBlmL6x58HE75ArQ750F87XhjNTU=;
        b=Xkj2lXkUNBP1K9AqZX7MDlMs5/5U3GIey41lyF8TmabRmncYXd9f3lZGlE7aBG14TU
         qHBrNbdfhZDxT7CEjZsN6wRk744VSdOpoS545BD1SaZR+j1QQgyLYjgDw1z8xVEYDNIs
         EVEnAxqT5ZRYUnHXGiKZ8Fld2AdWLI4m7pX+qXY3mtohdXDrnKLVif4XkBRgoW2elIyw
         A6A0a4s3ir8reAlKFliQAGOf5+U9KYv0Ecra+ZrhsIJ6U2FpSTcz9dAvgu8/betEd+uJ
         G9VdChnt+jUx9NVWwK/mkYumqm+p9jh78Z/PVpJfIrKNnL8wB/1N6Pc+HolNLQclJCHt
         Hs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764573787; x=1765178587;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nsPYaeG9WOKt7UvSBlmL6x58HE75ArQ750F87XhjNTU=;
        b=ae2RdtzLGzyKRpH6IOUOdLB5CBBW46nCWg+BxVrVIr1PKvJiJGFdQLLLg5fXSgUuf2
         7yLPLBkGP/dCLvnoRfIpscYe8iPnWeOfgLkQLRL//pUrPYcLF63AR+B0xJ+5VmdXHBU6
         MT3oLbFrkoHNnrhmZg2CIPTWHcfaKry2yTJZvu/Huu/gjVQzvy1AdJcFgCYBbcAFLOsg
         z+9zKcVxCS8U1KZD7A3q+BMOHTmZNRsaUICb1rek0tSL5ZyO8L4boE8XnsPAI2sI2YuN
         l5JmNngIQO6hh8YaaaInFEZY4N162Jbp0YH+T+ZvM3GCfVUAc9ZhKR4Y1U4tzGm/6YEV
         RRCA==
X-Forwarded-Encrypted: i=1; AJvYcCUumwP0pq35+DBJpNb6s6FVA99oep2QSEXsXxdNBVndOoRQSKfL8nvid/U5fPSZ87ayU/CVpo38HZoYqw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5rNN7WVXdtjrqGBK5Id4rYfzg/E9NjcmVxbE/tfnAZf9FgTFS
	2Z7kx2I8EAD121IKmyN9K4C2i1Duip9UnWk+Tnfv5U6DGkc1yfyxrI8f
X-Gm-Gg: ASbGncvi5J76s4y/DdDj07Qre2QYphTI4yotXcS4AA7iBFRNN7gMCqIOIKJ8uF9gF0L
	3/BDTwSJpKA8xuTJbXLxKPQm2fCPzDQbW8BHyKLMY3PjejzePpH0CAZ8O7KBSRVksT3ZoLVt1Mg
	jiFDBV9UQCQFAGcfLfLIw8qKUyGHy4QEg0isrtfrf4u/FVyZK//I5Po43YlVfJyQi9FMls7Hfrm
	ibGTI6BN5PwpMZEY2IbwVIeiJ7h9kD5qBmyb6mZ+Sfu9UTcAKzDflx0DhwlJ5fuKCF9Z8JVc8aD
	He820uPBUfMXW1usUFDVKX5q3IuEI4SkerEJRLzO40LbxrZz4huJjZM10hY8eW2raBbjCha9hSy
	3DvSabb6GirYeJMVoQ8ufLtG4qN3ct/N/pYKVTngT6pA1BljWKmtzQ9UejHnBsiUfThxW+gTRHB
	h5feMpei6jGA==
X-Google-Smtp-Source: AGHT+IExHacmoOjLqpowlH+xbLwZ/5a1cHySOLNyr8/GIiYEg8delrkvbo/escNwn50cTcedfAQDrw==
X-Received: by 2002:a17:902:cf41:b0:296:547a:4bf2 with SMTP id d9443c01a7336-29b6c004ae1mr381601045ad.27.1764573787245;
        Sun, 30 Nov 2025 23:23:07 -0800 (PST)
Received: from inspiron ([114.79.136.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb2765esm113452535ad.65.2025.11.30.23.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 23:23:06 -0800 (PST)
Date: Mon, 1 Dec 2025 12:52:59 +0530
From: Prithvi Tambewagh <activprithvi@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
Subject: Re: [PATCH] fs: ocfs2: fix kernel BUG in ocfs2_find_victim_chain
Message-ID: <aS1CU5ISRK8yTfpA@inspiron>
References: <20251130104637.264258-1-activprithvi@gmail.com>
 <6d27a5aa-1e32-4dd3-997c-ddc015be88a3@linux.alibaba.com>
 <aS00nMK1juomYZkN@inspiron>
 <95804297-3a21-4024-8eb0-e75e8a3c4f87@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95804297-3a21-4024-8eb0-e75e8a3c4f87@linux.alibaba.com>

On Mon, Dec 01, 2025 at 03:07:56PM +0800, Joseph Qi wrote:
>
>
>On 2025/12/1 14:24, Prithvi Tambewagh wrote:
>> On Mon, Dec 01, 2025 at 10:51:49AM +0800, Joseph Qi wrote:
>>>
>>>
>>> On 2025/11/30 18:46, Prithvi Tambewagh wrote:
>>>> syzbot reported a kernel BUG in ocfs2_find_victim_chain() because the
>>>> `cl_next_free_rec` field of the allocation chain list is 0, triggring the
>>>> BUG_ON(!cl->cl_next_free_rec) condition and panicking the kernel.
>>>>
>>>> To fix this, `cl_next_free_rec` is checked inside the caller of
>>>> ocfs2_find_victim_chain() i.e. ocfs2_claim_suballoc_bits() and if it is
>>>> equal to 0, ocfs2_error() is called, to log the corruption and force the
>>>> filesystem into read-only mode, to prevent further damage.
>>>>
>>>> Reported-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
>>>> Closes: https://syzkaller.appspot.com/bug?extid=96d38c6e1655c1420a72
>>>> Tested-by: syzbot+96d38c6e1655c1420a72@syzkaller.appspotmail.com
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
>>>> ---
>>>>  fs/ocfs2/suballoc.c | 7 +++++++
>>>>  1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>>>> index 6ac4dcd54588..84bb2d11c2aa 100644
>>>> --- a/fs/ocfs2/suballoc.c
>>>> +++ b/fs/ocfs2/suballoc.c
>>>> @@ -1993,6 +1993,13 @@ static int ocfs2_claim_suballoc_bits(struct ocfs2_alloc_context *ac,
>>>>
>>>>      cl = (struct ocfs2_chain_list *) &fe->id2.i_chain;
>>>>
>>>
>>> This blank line can be eliminated.
>>>
>>>> +    if (le16_to_cpu(cl->cl_next_free_rec) == 0) {
>>>
>>> Better to add the upper limit check as well. e.g.
>>>
>>> !le16_to_cpu(cl->cl_next_free_rec) ||
>>> le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)
>>
>> Hello Joseph,
>>
>> I went through the code in fs/ocfs2/suballoc.c, like this function
>> static inline u16 ocfs2_find_smallest_chain(struct ocfs2_chain_list *cl)
>> {
>>     u16 curr, best;
>>
>>     best = curr = 0;
>>     while (curr < le16_to_cpu(cl->cl_count)) {
>>         if (le32_to_cpu(cl->cl_recs[best].c_total) >
>>             le32_to_cpu(cl->cl_recs[curr].c_total))
>>             best = curr;
>>         curr++;
>>     }
>>     return best;
>> }
>>
>> and in function ocfs2_block_group_alloc() these lines
>> if (le16_to_cpu(cl->cl_next_free_rec) < le16_to_cpu(cl->cl_count))
>>     le16_add_cpu(&cl->cl_next_free_rec, 1);
>>
>After this, cl_next_free_rec may equal to cl_count.
>
>
>> and observed that according to the architecture of ocfs2, the chain list is in the form of 0-indexed array. In that case, the change you suggested for upper limit, could be re-written as
>> le16_to_cpu(cl->cl_next_free_rec) >= le16_to_cpu(cl->cl_count)
>>
>> since value of cl->cl_next_free_rec greater than or equal to cl->cl_count will indicate that there are no available chains. Can you please review this?
>>
>Yes, it's full. But 'cl_next_free_rec == cl_count' is a designed behavior, see mkfs or fsck.

I get it. We are trying to catch a state of disk corruption, so your 
suggestion

le16_to_cpu(cl->cl_next_free_rec) > le16_to_cpu(cl->cl_count)

fits best here. Thanks...I will make v2 for the patch.

Best Reards,
Prithvi

>
>Joseph
>
