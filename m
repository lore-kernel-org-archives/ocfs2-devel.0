Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702CE54737
	for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 10:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711623032; cv=none; b=YRiBEFC2lgTikhgoVxSmMqxElQpVxjhOGXbYjTd0qJUskBUVzNwLlRhJOqnyWmA/b+UJmBSLCKoLN5XkFPS/wck0GB6WDbCoz5lY85altVpFOktcWq+Y7cQg7kcIvnCG4lG3aRSwJErJavEyW5HhtBhTidn7biMPWWO0dWpXoIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711623032; c=relaxed/simple;
	bh=0fxnFQVDt4mj78Rcybd4Ae17R7l97g6SttSGlXgz/So=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=id5TwhT/3c3KlJiFhmZ59jBOOL4vvZ4rTSjrBTVMKH4B3PwTnLic6hp7GRX+AWJaBeBC4tqcdcIAzM+JhPcQGpaa7eQQT1rYIResNynJ3b9zuz/hn4HnPFZx4hepSUyXEPYjmpw8Ji2jFnRihvRcHPd+g6p8TG+FVh3V4MPMkEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=byssfdxJ; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="byssfdxJ"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d094bc2244so8275611fa.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 28 Mar 2024 03:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711623027; x=1712227827; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P/GlYDOtXHZod5GSsNgbwJTHlB0hiY9E3+77G2GfUDA=;
        b=byssfdxJp2RB09EdlYKqLxNrJ/IbopvnVwFZVs6Osptkgwk+2Wu4dkAi9IKAZSxINr
         kLlGGfhXvm8j8zKrWoIoStwThXDQS65cVUjNToc8XtN0MsIs22d4jNW6rgoKPaleMk6a
         Cfdhb0mDkRCDl5yKfhLrJo5Na3eMkbVTUWYsKZcEDWRT64gcydShR3t3XXiQ4cfpe3m4
         oOKO0s7wtmavvOOq0HbRLninIVl3gD9eaNHvxBZsrtGRtwsnd+ZEDa4NUzGkUORVkez6
         C74g5GmF3OiB28+ZYRYHjYw6d6V4sUGKOmh7JKoNKKahaM0hsQ/2m/25cszFUU6AAist
         HNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711623028; x=1712227828;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P/GlYDOtXHZod5GSsNgbwJTHlB0hiY9E3+77G2GfUDA=;
        b=D+2uu5z3xYCnVZJ27USgrMPQfkSgg24g44fUH8jb+u9zxIEEpjgqNtxAsEpad0shTc
         dxzOTM5RQdSXKco7woS9bAZ3He8qGGOa86ZyoJqL80OOvvLYNG7rDbuq1gT26O+z90Sq
         AkMHV0e5A5g7iWDkPtbbph8AmoHJ2du95NTEDbRRcSVn4bAcJVAGNpsP06H5A0IPVyUZ
         xaKxrbqxB6SI2+YvqdZtWSinsJgN5fsVqAKAQDQgWLvKnJE2vqVEbQoiENND/xZY5ndB
         rfRD28DQ254s5r2p3AAIpcfOXMUawJIY1A32m9op+CdkqY78bQF1s2/2FNIw22XkP1hi
         xsDg==
X-Gm-Message-State: AOJu0YzdNUWpohHugL1bSObrTNyrdQv64lhsV3DlFytJhBir2OqZCxuM
	w24e8L/aLw/766YzKq1qbhCzhokA36elahKrVVNBvnoa6kBnyK3AvexYX2T1faE=
X-Google-Smtp-Source: AGHT+IHPzyzFB6u0IJKHG9T3af0VKQXG0nFbhOTLNXNkg+rr9K7fgMCLTHRZN8vlxQUldRlWNoFckQ==
X-Received: by 2002:a2e:7c01:0:b0:2d6:ab2f:7862 with SMTP id x1-20020a2e7c01000000b002d6ab2f7862mr1963161ljc.2.1711623027662;
        Thu, 28 Mar 2024 03:50:27 -0700 (PDT)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id v12-20020a17090abb8c00b0029c13f9bd7fsm3206381pjr.34.2024.03.28.03.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 03:50:27 -0700 (PDT)
Message-ID: <bb3fdfc2-ad16-4907-9d20-d3696c6f1a86@suse.com>
Date: Thu, 28 Mar 2024 18:50:24 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/4] ocfs2: fix sparse warnings
Content-Language: en-US
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, ailiop@suse.com
References: <20240328082943.20251-1-heming.zhao@suse.com>
 <20240328082943.20251-5-heming.zhao@suse.com>
 <b1982b17-0674-4080-8ed4-de2c0107c7f3@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <b1982b17-0674-4080-8ed4-de2c0107c7f3@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/24 17:01, Joseph Qi wrote:
> 
> 
> On 3/28/24 4:29 PM, Heming Zhao wrote:
>> 1.
>> fs/ocfs2/localalloc.c:1224:41: warning: incorrect type in argument 1 (different base types)
>> fs/ocfs2/localalloc.c:1224:41:    expected unsigned long long val1
>> fs/ocfs2/localalloc.c:1224:41:    got restricted __le32 [usertype] la_bm_off
>>
>> 2.
>> fs/ocfs2/export.c:258:32: warning: cast to restricted __le32
>> fs/ocfs2/export.c:259:33: warning: cast to restricted __le32
>> fs/ocfs2/export.c:260:32: warning: cast to restricted __le32
>> fs/ocfs2/export.c:272:32: warning: cast to restricted __le32
>> fs/ocfs2/export.c:273:33: warning: cast to restricted __le32
>> fs/ocfs2/export.c:274:32: warning: cast to restricted __le32
>>
>> 3.
>> fs/ocfs2/inode.c:1623:13: warning: context imbalance in 'ocfs2_inode_cache_lock' - wrong count at exit
>> fs/ocfs2/inode.c:1630:13: warning: context imbalance in 'ocfs2_inode_cache_unlock' - unexpected unlock
>>
>> 4.
>> fs/ocfs2/refcounttree.c:633:27: warning: incorrect type in assignment (different base types)
>> fs/ocfs2/refcounttree.c:633:27:    expected restricted __le32 [usertype] rf_generation
>> fs/ocfs2/refcounttree.c:633:27:    got unsigned int
>>
>> 5.
>> fs/ocfs2/dlm/dlmdomain.c:1316:20: warning: context imbalance in 'dlm_query_nodeinfo_handler' - different lock contexts for basic block
>>
>> 6.
>> fs/ocfs2/dlm/dlmrecovery.c:2950:9: warning: context imbalance in 'dlm_finalize_reco_handler' - different lock contexts for basic block
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>> v5: (first version)
>> - localalloc.c fix (No: 1) is split from v4 patch 3/3.
>> - new sparse warnings fixes (No: 2~6) for other files.
>>
>> ---
>>   fs/ocfs2/dlm/dlmdomain.c   | 11 +++++------
>>   fs/ocfs2/dlm/dlmrecovery.c |  4 ++++
>>   fs/ocfs2/export.c          | 12 ++++++------
>>   fs/ocfs2/inode.c           |  2 ++
>>   fs/ocfs2/localalloc.c      |  4 ++--
>>   fs/ocfs2/refcounttree.c    |  2 +-
>>   6 files changed, 20 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
>> index 5c04dde99981..2e0a2f338282 100644
>> --- a/fs/ocfs2/dlm/dlmdomain.c
>> +++ b/fs/ocfs2/dlm/dlmdomain.c
>> @@ -1274,7 +1274,7 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
>>   {
>>   	struct dlm_query_nodeinfo *qn;
>>   	struct dlm_ctxt *dlm = NULL;
>> -	int locked = 0, status = -EINVAL;
>> +	int status = -EINVAL;
>>   
>>   	qn = (struct dlm_query_nodeinfo *) msg->buf;
>>   
>> @@ -1290,12 +1290,11 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
>>   	}
>>   
>>   	spin_lock(&dlm->spinlock);
>> -	locked = 1;
>>   	if (dlm->joining_node != qn->qn_nodenum) {
>>   		mlog(ML_ERROR, "Node %d queried nodes on domain %s but "
>>   		     "joining node is %d\n", qn->qn_nodenum, qn->qn_domain,
>>   		     dlm->joining_node);
>> -		goto bail;
>> +		goto unlock;
>>   	}
>>   
>>   	/* Support for node query was added in 1.1 */
>> @@ -1305,14 +1304,14 @@ static int dlm_query_nodeinfo_handler(struct o2net_msg *msg, u32 len,
>>   		     "but active dlm protocol is %d.%d\n", qn->qn_nodenum,
>>   		     qn->qn_domain, dlm->dlm_locking_proto.pv_major,
>>   		     dlm->dlm_locking_proto.pv_minor);
>> -		goto bail;
>> +		goto unlock;
>>   	}
>>   
>>   	status = dlm_match_nodes(dlm, qn);
>>   
>> +unlock:
>> +	spin_unlock(&dlm->spinlock);
>>   bail:
>> -	if (locked)
>> -		spin_unlock(&dlm->spinlock);
>>   	spin_unlock(&dlm_domain_lock);
>>   
>>   	return status;
>> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
>> index 50da8af988c1..40a0e5df3de0 100644
>> --- a/fs/ocfs2/dlm/dlmrecovery.c
>> +++ b/fs/ocfs2/dlm/dlmrecovery.c
>> @@ -2917,8 +2917,11 @@ int dlm_finalize_reco_handler(struct o2net_msg *msg, u32 len, void *data,
>>   		BUG();
>>   	}
>>   
>> +	spin_unlock(&dlm->spinlock);
>> +
> 
> I'm not sure unlock first and then lock is a right way.
> I'd rather leave it as of now.
> 
> Joseph

Me too, I will restore this function code in v6.
Thanks for reviewing.

-Heming

