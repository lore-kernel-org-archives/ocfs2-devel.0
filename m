Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD3133EC
	for <ocfs2-devel@lists.linux.dev>; Tue, 30 Jul 2024 01:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722303775; cv=none; b=aPNe9BmeOLqfAAwHgZY8sExsQbgaH03mQ+hSmlf2RMIdE8Rph6qNvyG7Fz9qSJF3EX19bejF/UL3GwbSMSsXVFbMg1HzqmS/PiEW2LTXsUc0u7naKgkbWXRJAgF9yRNSYtdBhq+UhcQs18bmnxwsFBI8vlzw1+sm5UvW7ITIZAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722303775; c=relaxed/simple;
	bh=RpxgnUmCIxdfzcEWIHvux8HX1ZC88pw5KIm9qFIAOS0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=FVWvtAy7PdgBtUChyOmVILZUiTQh6VuYzFBuiaA5IHxS49fDmP8GC9FpuOfnyN4REOZ8hvRXsw7NP8DJ6ILQBGzxi0WMY7BN1A02V8r71rA8Qw2Lay35/DvnIvvizcSO/RhndfX7YWTAbEgKOLJ+AZ+cebN7A5uK1+D7p0lFTKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UB0Z9YUI; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UB0Z9YUI"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-36887ca3da2so1725383f8f.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 29 Jul 2024 18:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722303768; x=1722908568; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iMCjAh6UTYDjGI/18oLQoiuLfoB1NdPxArrYwKwp+Bs=;
        b=UB0Z9YUIjZEBe7DjRQ+Ci9Gfw2FIujT291NXTrd642v4JnblcEwVhY8haTJqVO1RLz
         EfJ9Gz2Nq1TnkTDlzNyNNYKuJzK9YY7xS3aHNI/1Z9M11Lut5UM0BL7Y0/lqNR10f8js
         GmLu+HBFJy0mF14/Bt/o33GPEkWv0eET+/5IFL7d6idKEwTD7pjrfcmFCuWGiXX7vuZt
         6Yd6NuBn0OlRnxCxX7JPRXQJeEufnHFcmWNVDoQ/3FY/SY2QBwpxmf2NSONp26MsQTR6
         tKi0/YeUhJVy2yFIpgWuM5hwRqlXM/Yi+oYQaNe2jj0my5NHU2Nn+tpV63qbUA6uG8a2
         waGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722303768; x=1722908568;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iMCjAh6UTYDjGI/18oLQoiuLfoB1NdPxArrYwKwp+Bs=;
        b=jGqHUJUUaLHzu1qp4rEMG2Xc+a2Z+SQRameOcKZFf02i+x3ytCvTwE9AkymAc4sAS3
         08zR3JOzDMPRA5qac8cqyazymwVZ5R+d2f0NYwsGyWyiFt9rNODsP2Oo43rkFUTpQN0v
         JB5fnu3cXYa0Tfz7rMIwFCFSyaqWqHF9fPiptyV1fpG5KarchRMsmUuenmxwjrZi8r6G
         QNRXbwQDr+QbPqoeHwga2hyu/ZlSlXvKPkRVPp2s6o1E45XOaiwZ4bdbQnjCfdFZaXP8
         LilLgOo/Tp7ceEShVUoxQWZOZqWmm/KNz4LzKPrFOyjMpG8xqIGRRNCOY9c/NPk269Rs
         zbmw==
X-Gm-Message-State: AOJu0YxY/Ed8bF2IoGyMkpiad27XtBR9+seAIGViuYVoZtnStcOAuR1F
	nOtFu5QCdO589WK2RWlBEibMbug2+O8qEW4ySatU34IyTdLJRrTYunoWxUt7VW0=
X-Google-Smtp-Source: AGHT+IHlmUd6EQQCzgZLScOqhEopr9k/buFcacD95RwVL7mYF51QE0518pAA2LhboRU1mVXpxqq5lg==
X-Received: by 2002:a5d:4685:0:b0:368:747c:5a04 with SMTP id ffacd0b85a97d-36b5cefdeeamr5457608f8f.25.1722303768243;
        Mon, 29 Jul 2024 18:42:48 -0700 (PDT)
Received: from [192.168.2.179] ([2406:4440:0:105::28:b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7fe8af8sm90042765ad.290.2024.07.29.18.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 18:42:47 -0700 (PDT)
Message-ID: <0e4bc037-4afb-4d6c-b2bf-fadf66c59275@suse.com>
Date: Tue, 30 Jul 2024 09:42:44 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ocfs2: detect released suballocator bg for
 fh_to_[dentry|parent]
From: Su Yue <glass.su@suse.com>
To: Heming Zhao <heming.zhao@suse.com>, joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev
References: <20240729080454.12771-1-heming.zhao@suse.com>
 <20240729080454.12771-3-heming.zhao@suse.com>
 <1a2d6309-9730-44d0-80da-781a88af1ca4@suse.com>
Content-Language: en-US
In-Reply-To: <1a2d6309-9730-44d0-80da-781a88af1ca4@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2024/7/30 09:24, Su Yue wrote:
> 
> 
> On 2024/7/29 16:04, Heming Zhao wrote:
>> After ocfs2 has the ability to reclaim suballoc free bg, the

Since the patch fixes a regression which patch[1] causes, better to
document the patch explicitly. e.g.

After commit "ocfs2: give ocfs2 the ability to reclaim suballoc free 
bg", ocfs2 has the ability to reclaim suballoc free bg, the suballocator 
block group may be released.


No need to resend I think. Joseph, could you amend the message if the 
patch is fine to you?


--
Su
>> suballocator block group may be released. This change makes xfstest
>> case 426 failed.
>>
>> The existed code call stack:
>>
>> ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
>>   ocfs2_get_dentry
>>    ocfs2_test_inode_bit
>>     ocfs2_test_suballoc_bit
>>      ocfs2_read_group_descriptor
>>       + read released bg, triggers validate fails, then cause -EROFS
>>
>> how to fix:
>> The read bg failure is expectation, we should ignore this error.
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> 
> LGTM:
> Reviewed-by: Su Yue <glass.su@suse.com>
>> ---
>>   fs/ocfs2/suballoc.c | 27 ++++++++++++++++++---------
>>   1 file changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index 1b64f4c87607..dc421f55ed8f 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -3037,7 +3037,7 @@ static int ocfs2_test_suballoc_bit(struct 
>> ocfs2_super *osb,
>>       struct ocfs2_group_desc *group;
>>       struct buffer_head *group_bh = NULL;
>>       u64 bg_blkno;
>> -    int status;
>> +    int status, quiet = 0;
>>       trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
>>                         (unsigned int)bit);
>> @@ -3053,11 +3053,16 @@ static int ocfs2_test_suballoc_bit(struct 
>> ocfs2_super *osb,
>>       bg_blkno = group_blkno ? group_blkno :
>>              ocfs2_which_suballoc_group(blkno, bit);
>> -    status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
>> +    status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, 
>> bg_blkno,
>>                            &group_bh);
>>       if (status < 0) {
>> -        mlog(ML_ERROR, "read group %llu failed %d\n",
>> -             (unsigned long long)bg_blkno, status);
>> +        if (status == -EIDRM) {
>> +            quiet = 1;
>> +            status = -EINVAL;
>> +        } else {
>> +            mlog(ML_ERROR, "read group %llu failed %d\n",
>> +                    (unsigned long long)bg_blkno, status);
>> +        }
>>           goto bail;
>>       }
>> @@ -3067,7 +3072,7 @@ static int ocfs2_test_suballoc_bit(struct 
>> ocfs2_super *osb,
>>   bail:
>>       brelse(group_bh);
>> -    if (status)
>> +    if (status && (!quiet))
>>           mlog_errno(status);
>>       return status;
>>   }
>> @@ -3087,7 +3092,7 @@ static int ocfs2_test_suballoc_bit(struct 
>> ocfs2_super *osb,
>>    */
>>   int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
>>   {
>> -    int status;
>> +    int status, quiet = 0;
>>       u64 group_blkno = 0;
>>       u16 suballoc_bit = 0, suballoc_slot = 0;
>>       struct inode *inode_alloc_inode;
>> @@ -3129,8 +3134,12 @@ int ocfs2_test_inode_bit(struct ocfs2_super 
>> *osb, u64 blkno, int *res)
>>       status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
>>                        group_blkno, blkno, suballoc_bit, res);
>> -    if (status < 0)
>> -        mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
>> +    if (status < 0) {
>> +        if (status == -EINVAL)
>> +            quiet = 1;
>> +        else
>> +            mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
>> +    }
>>       ocfs2_inode_unlock(inode_alloc_inode, 0);
>>       inode_unlock(inode_alloc_inode);
>> @@ -3138,7 +3147,7 @@ int ocfs2_test_inode_bit(struct ocfs2_super 
>> *osb, u64 blkno, int *res)
>>       iput(inode_alloc_inode);
>>       brelse(alloc_bh);
>>   bail:
>> -    if (status)
>> +    if (status && !quiet)
>>           mlog_errno(status);
>>       return status;
>>   }
