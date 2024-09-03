Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7766AA5F
	for <ocfs2-devel@lists.linux.dev>; Tue,  3 Sep 2024 00:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725324204; cv=none; b=rZrnuLk4iQhbXKVy9NE9IwuzbF5yZi8l7vEV36fLFH7YAd7fzjkWDyA2bMlodw6XKzLsVUOGjK/tKQ6u7JaaZz4McHDa22xGt13tMMZOwIc369WRiAY/E6rqcWxNf0bdG/OwnAZRPyJbo7OKY1ztdf07S5wwGOiGY299iOk9nfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725324204; c=relaxed/simple;
	bh=45FjlJ8yMsJVgq0v6WbNq2PtIVLhkgJ4IkacyoVAD8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KasPK/a4IqvOdVtgkmXZ66JjrjNuUnv8VWBDmhH3cu/NCQtRm9QsjcUVuP1CYJUd9u3ybmJmhr2QU0EbGgTsu7VciDvhw/sAi2rNM2jGlTolwIMN+CfS9cdnujJfy8GMy32ETzir9TRqAx1PeDhMWDNbnRPKtpJbJsYK85Jhk+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bztk/rLk; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bztk/rLk"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-42c7bc972a5so3246715e9.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 02 Sep 2024 17:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725324201; x=1725929001; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8cX+4KKBr+xtIqA76SSMWx5F0CeAr18wSG0C/PuZrgk=;
        b=Bztk/rLk3Y1+f7Jyi+1i7s1gYINa7WgMzbc6MZSlX7vO7HJEOpOIIQxgqkmV01ivLk
         YHe/L6gTrjhApyvbRBvE8sJXiML3ARTRSd+W9vv3X/2DLTcR0CRwE43pcb3520WBFQm+
         QTEXPfClXQvIe/t5MxYPOf8GMG49VRGJ8qqrNeOEi73GO0g1Y45d6kyc7zW1r/7WB3G6
         YOVtnrkGoq6ZEhMI2sIV8MnavPdR9IOFBdY/kaL4/AfDuTxP79Uf88S0ZvvJ0HfDPc/f
         7iVsrjknNiFmjIAxNU9CdFX2GUbLt4NLMfsZWZW8zJkA1WrrggDuiWFLhCEhpg2tHCt8
         pwcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725324201; x=1725929001;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cX+4KKBr+xtIqA76SSMWx5F0CeAr18wSG0C/PuZrgk=;
        b=qISvM8uUNVj1zBIw448MDvFnGluYOhQPQOxDVMTHgxkVNW7F5I3O3ukvCOoZn/wX2W
         B4y43CEC9JlgwaKffBXvFBE9ttdaQPGV8ReoUbuPl4O0X6nwlyLyzcMaT3QvwZpo+6jV
         8YSfzDV/9beD3SOnX+fimMlvwbYK2Ju2yZj4nQvk6X6lcpO/doF3RG+Zwxto/BiyoB4g
         tlONezfKZKpxdsCYZhf4ug0l7hqSko2pOnLUEWLx/53haLyQUtilXcjcTShxD7+32eKp
         iz41UYP8i7KwTjN1IcrRX3fc62B0usjoqwNV7L6M8Ug3wCKZ9bFOVx1LqQmA0slOU1sq
         X35A==
X-Gm-Message-State: AOJu0YwZhvGy/UOt9GJZMsBTwjN3qidpwF15QYmrpG0uneEa4tVBWC63
	bhkCnWbSCMyxglNclj/hDOC2tOa1ak1B9QJhDXMNt4wdNi1mjryW+SZ6XuTims4=
X-Google-Smtp-Source: AGHT+IEGbXACHMkI8eLg3lwKLSvQUANk/WkR/scN9Jd9fiWFeiq2ZukMbC0koALhcyIM6LjlYxEd3Q==
X-Received: by 2002:a05:6000:1567:b0:374:cc10:bb42 with SMTP id ffacd0b85a97d-374cc10bd56mr1634056f8f.2.1725324200196;
        Mon, 02 Sep 2024 17:43:20 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20515556172sm71272865ad.280.2024.09.02.17.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Sep 2024 17:43:19 -0700 (PDT)
Message-ID: <19557432-ce04-4a92-9a3c-83539ab73648@suse.com>
Date: Tue, 3 Sep 2024 08:43:16 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] ocfs2: give ocfs2 the ability to reclaim suballoc
 free bg
To: Joseph Qi <joseph.qi@linux.alibaba.com>, glass.su@suse.com
Cc: ocfs2-devel@lists.linux.dev,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240729080454.12771-1-heming.zhao@suse.com>
 <20240729080454.12771-2-heming.zhao@suse.com>
 <88c9e6fd-db43-4c58-81f1-caa38369e732@linux.alibaba.com>
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <88c9e6fd-db43-4c58-81f1-caa38369e732@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/24 19:25, Joseph Qi wrote:
> 
> 
> On 7/29/24 4:04 PM, Heming Zhao wrote:
>> The current ocfs2 code can't reclaim suballocator block group space.
>> This cause ocfs2 to hold onto a lot of space in some cases. for example,
>> when creating lots of small files, the space is held/managed by
>> '//inode_alloc'. After the user deletes all the small files, the space
>> never returns to '//global_bitmap'. This issue prevents ocfs2 from
>> providing the needed space even when there is enough free space in a
>> small ocfs2 volume.
>> This patch gives ocfs2 the ability to reclaim suballoc free space when
>> the block group is free. For performance reasons, ocfs2 doesn't release
>> the first suballocator block group.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>   fs/ocfs2/suballoc.c | 211 ++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 206 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index f7b483f0de2a..1b64f4c87607 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -294,6 +294,60 @@ static int ocfs2_validate_group_descriptor(struct super_block *sb,
>>   	return ocfs2_validate_gd_self(sb, bh, 0);
>>   }
>>   
>> +/*
>> + * hint gd may already be released in _ocfs2_free_suballoc_bits(),
>> ... ...
>> +	alloc_bh = main_bm_bh;
>> +	fe = (struct ocfs2_dinode *) alloc_bh->b_data;
>> +	cl = &fe->id2.i_chain;
>> +	old_bg_contig_free_bits = 0;
>> +	brelse(group_bh);
>> +	group_bh = NULL;
>> +	start_bit = bg_start_bit;
>> +	undo_fn = _ocfs2_clear_bit;
>> +
>> +	/* reclaim clusters to global_bitmap */
>> +	goto reclaim;
>> +
>>   bail:
>> +	if (free_main_bm_bh) {
>> +		ocfs2_inode_unlock(main_bm_inode, 1);
>> +		brelse(main_bm_bh);
>> +	}
>> +	if (free_main_bm_inode) {
>> +		inode_unlock(main_bm_inode);
>> +		iput(main_bm_inode);
>> +	}
> 
> You've add too much logic into _ocfs2_free_suballoc_bits() and make it
> hard to review.
> Could you please factor out a new function and describe it clearly?
> e.g. why we need this function and how to achieve it.
> BTW, it seems that it contains a big loop, so please explictly specify
> the end condition.
> 
> Cc lkml as well.
> 
> Thanks,
> Joseph

Give me some time to do the factor out job.

- Heming

> 
>>   	brelse(group_bh);
>>   	return status;
>>   }
> 
> 

