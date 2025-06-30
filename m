Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FA4EAF6
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Jun 2025 02:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751251360; cv=none; b=qQcidb9polzOQxsZIPjENVwqHT959bQt+sVWMiX7zR/cFGvKWh3QWhcJMBnRVsDgOjHAgSeIKynbNYvQzI2gkHdzeY/jEV+baNVeb99KyzJaa2oWPApcRRGGQA3yC65YvFMYa6oNWfm/dNSLo8KBjjhqgZHRfAYLhlV39ZE7qcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751251360; c=relaxed/simple;
	bh=5Z9KyRUVm84surKnziWOlPcfo5hvLqWFepD2MD5F2uA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hpVUd1n0dk6pbZG3Vm0l7FoswrWMULJO2juhxfXa+fFzPORDth0uQLEOULslUsdfjJk4egBCOa+TxtZxw1es1s3iXGNATwEd7G60A15ZbrrjslPCqu15aid3oo3EXPygaFUxo+f+gvzG+escwQVSK4/0gxEy34Vd/DrvpEherRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KjhG3aFF; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KjhG3aFF"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a4e575db1aso141973f8f.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 29 Jun 2025 19:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1751251355; x=1751856155; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Alw9qrycqIrCL8CKseCQMJxxf18iqOrQKvaGUMvOZFc=;
        b=KjhG3aFFGXWHmedu6v3K80IiNtbQGBLrutqeoayHQ3EP8ldMw+3rbeF8YWu4g/e3F8
         BJ9qCj4nyi7g9qyh1KT0At2iqfEbsLwMtwaX9Djv4rPqpNW30xK2PQwFEa3uWU2ixeLd
         YgMazT6/ZcmfTbMpP2+y3qDGa+Xn2owj/VqERdKq4Z13rfyrHzPZmBOxedGNW5lCAZQC
         Y2UH2oHfkqAGa+f5218A/e7HnHg225CzGCwHZppkoLiUttzoz9hAuF54xrviFVdz3PR+
         geAb5piNofCV+oU2847/fa/seeouAUdtaFWYTgvAUrcSb8Zr4b/JcswQLMaBv3XGvmL1
         KUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751251355; x=1751856155;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Alw9qrycqIrCL8CKseCQMJxxf18iqOrQKvaGUMvOZFc=;
        b=I2dh8TELmifm9pQUgDWte5J6x7K+1syU6jhi6OZPBZeybn3NJd8wk/a2a+J1KW6KE5
         AZbbHjJFLK1LssqwWLzhpIFSZU0iQXzRIdFbAStXjOicfSEVYfoqFC/Lr3hCdSl2P99I
         ZvJ36Lh7m6ApCR00Obyn2QK5s2SbFCPd0ctEMv5G++wy9W67+6MWVAK3wiXK6DXaSTIG
         y/ULUzec6ofOxyMKqmuurwpp1a/tttkE4jMdLk9em4gux/dFsMKudfysvkVRjf9Qkwz+
         wTLy9rrXRTPLvqLdJ81zCIqssNweOFyQp4+WBrQp1M8cCs9x8zraIDuTCPlrDI7KhTHQ
         ubjA==
X-Forwarded-Encrypted: i=1; AJvYcCWmhHb8iJAizIMkArmy4/oHbK/CzuVcMUv/EzWwJ2w2ZcjVGvmn4DfEUnN+3LQ22F+udHNPM9tpJPJKzw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyMvDln4utKv/J5/7J7irKPK9nG5hCi+3rqAcodXR9so7KzVGnd
	Mev4RCSiLBWIIh3TFCeCwk2BuFqLUZneh41Mf4Kh9wPxZnJcw6pv58EiTfWBec2j21U=
X-Gm-Gg: ASbGncsH3pXkgyqAYvnY/PQ4OC3X+cUWnGZ7yheiqUlw5oo9OcCIjSfsMz7H9QPEJKE
	sH06nQL7bS0t5hBTQUk71qaNeyDtA1H8KrU6Aztd/274dR1eW7HvFgjbvz7w3VU/6veM5G5zdbI
	KzpoHEMDqvb/xAU9btIu15/iXahLbn5ekriELpJTRuDwI2jdZk7eyT0hZX9rJd1rUznG+SQGcKM
	KB51tMSEPaf9em+SGO7w1VM9Wy6gTTEoz1NME/atVFFiPCZzn8wYHkPwOzNJb80MZ8rQ4qjLZWp
	50GLEDn1SGGtSFlcA2ZuFpuH/nwEXtYNaDhVjVdrUWyweLxKqTKNbMad8n/qncmnJikj
X-Google-Smtp-Source: AGHT+IHY8ujAk+fL2MXP/Rs3N1Xth55HJlztHL+lk12CWLUGIau3enA3BMSlMhI+5kI8/QF0mOPMLw==
X-Received: by 2002:a5d:5f48:0:b0:3a5:7991:fee with SMTP id ffacd0b85a97d-3aaf503a36dmr2262476f8f.14.1751251355112;
        Sun, 29 Jun 2025 19:42:35 -0700 (PDT)
Received: from [10.202.112.30] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb39b8ddsm71032555ad.140.2025.06.29.19.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jun 2025 19:42:34 -0700 (PDT)
Message-ID: <d76672e5-0d69-42b1-a9d3-b70439c194b5@suse.com>
Date: Mon, 30 Jun 2025 10:42:31 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: embed actual values into ocfs2_sysfile_lock_key
 names
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <29348724-639c-443d-bbce-65c3a0a13a38@I-love.SAKURA.ne.jp>
 <d490a3ad-6309-42f3-9774-91871fbf7330@linux.alibaba.com>
From: Heming Zhao <heming.zhao@suse.com>
Content-Language: en-US
In-Reply-To: <d490a3ad-6309-42f3-9774-91871fbf7330@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I am not familiar with lockdep, and just have two questions regarding
the lockdep in ocfs2.

1>
there are three global "static struct lock_class_key" definitions:
- fs/ocfs2/inode.c  : ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES]
- fs/ocfs2/dlmglue.c: lockdep_keys[OCFS2_NUM_LOCK_TYPES]
- fs/ocfs2/sysfile.c: ocfs2_sysfile_cluster_lock_key[NUM_SYSTEM_INODES]

why did you env only trigger the ocfs2_sysfile_lock_key[] warning?

2>
It seems the existing CONFIG_DEBUG_LOCK_ALLOC is incorrect, it should be
replaced with CONFIG_LOCKDEP.

- Heming

On 6/30/25 10:21, Joseph Qi wrote:
> 
> 
> On 2025/6/23 22:54, Tetsuo Handa wrote:
>> Since lockdep_set_class() uses stringified key name via macro, calling
>> lockdep_set_class() with an array causes lockdep warning messages to
>> report variable name than actual index number.
>>
>> Change ocfs2_init_locked_inode() to pass actual index number for better
>> readability of lockdep reports. This patch does not change behavior.
>>
>>
>> Before:
>>
>>    Chain exists of:
>>      &ocfs2_sysfile_lock_key[args->fi_sysfile_type] --> jbd2_handle --> &oi->ip_xattr_sem
>>
>>     Possible unsafe locking scenario:
>>
>>           CPU0                    CPU1
>>           ----                    ----
>>      lock(&oi->ip_xattr_sem);
>>                                   lock(jbd2_handle);
>>                                   lock(&oi->ip_xattr_sem);
>>      lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
>>
>>     *** DEADLOCK ***
>>
>> After:
>>
>>    Chain exists of:
>>      &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> jbd2_handle --> &oi->ip_xattr_sem
>>
>>     Possible unsafe locking scenario:
>>
>>           CPU0                    CPU1
>>           ----                    ----
>>      lock(&oi->ip_xattr_sem);
>>                                   lock(jbd2_handle);
>>                                   lock(&oi->ip_xattr_sem);
>>      lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
>>
>>     *** DEADLOCK ***
>>
>>
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> Looks fine.
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>>   fs/ocfs2/inode.c | 70 +++++++++++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 66 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 12e5d1f73325..14bf440ea4df 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -50,8 +50,6 @@ struct ocfs2_find_inode_args
>>   	unsigned int	fi_sysfile_type;
>>   };
>>   
>> -static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
>> -
>>   static int ocfs2_read_locked_inode(struct inode *inode,
>>   				   struct ocfs2_find_inode_args *args);
>>   static int ocfs2_init_locked_inode(struct inode *inode, void *opaque);
>> @@ -250,14 +248,77 @@ static int ocfs2_find_actor(struct inode *inode, void *opaque)
>>   static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
>>   {
>>   	struct ocfs2_find_inode_args *args = opaque;
>> +#ifdef CONFIG_LOCKDEP
>> +	static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
>>   	static struct lock_class_key ocfs2_quota_ip_alloc_sem_key,
>>   				     ocfs2_file_ip_alloc_sem_key;
>> +#endif
>>   
>>   	inode->i_ino = args->fi_ino;
>>   	OCFS2_I(inode)->ip_blkno = args->fi_blkno;
>> -	if (args->fi_sysfile_type != 0)
>> +#ifdef CONFIG_LOCKDEP
>> +	switch (args->fi_sysfile_type) {
>> +	case BAD_BLOCK_SYSTEM_INODE:
>> +		break;
>> +	case GLOBAL_INODE_ALLOC_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[GLOBAL_INODE_ALLOC_SYSTEM_INODE]);
>> +		break;
>> +	case SLOT_MAP_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[SLOT_MAP_SYSTEM_INODE]);
>> +		break;
>> +	case HEARTBEAT_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[HEARTBEAT_SYSTEM_INODE]);
>> +		break;
>> +	case GLOBAL_BITMAP_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]);
>> +		break;
>> +	case USER_QUOTA_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
>> +		break;
>> +	case GROUP_QUOTA_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[GROUP_QUOTA_SYSTEM_INODE]);
>> +		break;
>> +	case ORPHAN_DIR_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
>> +		break;
>> +	case EXTENT_ALLOC_SYSTEM_INODE:
>>   		lockdep_set_class(&inode->i_rwsem,
>> -			&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
>> +				  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
>> +		break;
>> +	case INODE_ALLOC_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
>> +		break;
>> +	case JOURNAL_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[JOURNAL_SYSTEM_INODE]);
>> +		break;
>> +	case LOCAL_ALLOC_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]);
>> +		break;
>> +	case TRUNCATE_LOG_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]);
>> +		break;
>> +	case LOCAL_USER_QUOTA_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[LOCAL_USER_QUOTA_SYSTEM_INODE]);
>> +		break;
>> +	case LOCAL_GROUP_QUOTA_SYSTEM_INODE:
>> +		lockdep_set_class(&inode->i_rwsem,
>> +				  &ocfs2_sysfile_lock_key[LOCAL_GROUP_QUOTA_SYSTEM_INODE]);
>> +		break;
>> +	default:
>> +		WARN_ONCE(1, "Unknown sysfile type %d\n", args->fi_sysfile_type);
>> +	}
>>   	if (args->fi_sysfile_type == USER_QUOTA_SYSTEM_INODE ||
>>   	    args->fi_sysfile_type == GROUP_QUOTA_SYSTEM_INODE ||
>>   	    args->fi_sysfile_type == LOCAL_USER_QUOTA_SYSTEM_INODE ||
>> @@ -267,6 +328,7 @@ static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
>>   	else
>>   		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
>>   				  &ocfs2_file_ip_alloc_sem_key);
>> +#endif
>>   
>>   	return 0;
>>   }
> 
> 

