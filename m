Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D0E2CCDB
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Jun 2025 02:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750731460; cv=none; b=m7+RO9l1Ouwef/MMnvjxgZ96dEyy8loPTrr6dn7TtT+2cotexXHIvTBG/sLukex/R+QaAJGCghEMiIGpax62MkLuqq6806DTgLYqqRA/NEkk4KfWrSw8JxBUD3wg8zVJW2EvCkLC8OB99WEH+oWsywBvr9M1nvE8Mi2u8hAFDvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750731460; c=relaxed/simple;
	bh=aCc8bsAkjQYdVRheiUTB3DBXq/DyOIV/EGkjk16hu4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=my38oSnjsjlpBbsH6PpZwueMv7e7Hx2KB3oC8J4oYFaQ1c+lyKXn/C5gBYBOoUJRpD+nvzpMTwDonsjFw95BrIPOfbdQhiUQuOAbO/OXdLSeS7uKmLwcx9j5lx9kixqLVMT43foULJdHOPXr1g/JITYOA8C96lXXmvL44BuuVOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 55O2HAWr070810;
	Tue, 24 Jun 2025 11:17:10 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 55O2H9Zr070806
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 24 Jun 2025 11:17:09 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <675ea747-5c05-410c-888c-fe6dd2b48d87@I-love.SAKURA.ne.jp>
Date: Tue, 24 Jun 2025 11:17:09 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
To: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        jiangyiwen <jiangyiwen@huawei.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        ocfs2-devel@lists.linux.dev,
        Diogo Jahchan Koike <djahchankoike@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <faf70481-09dd-4c7a-bd43-f1e8bec877cb@suse.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <faf70481-09dd-4c7a-bd43-f1e8bec877cb@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav104.rs.sakura.ne.jp
X-Virus-Status: clean

On 2025/06/24 10:33, Heming Zhao wrote:
>> @@ -112,11 +110,10 @@ struct inode *ocfs2_get_system_file_inode(struct ocfs2_super *osb,
>>       inode = _ocfs2_get_system_file_inode(osb, type, slot);
> 
> In my view, the key of commit 43b10a20372d is to avoid calling
> _ocfs2_get_system_file_inode() twice, which lead refcnt+1 but no place to
> do refcnt-1.

My understanding is that concurrently calling _ocfs2_get_system_file_inode() itself
is OK, for the caller of ocfs2_get_system_file_inode() is responsible for calling
iput().

The problem commit 43b10a20372d fixed is that there was no mechanism to avoid
concurrently calling

  *arr = igrab(inode);

which will result in failing to call iput() for raced references when
ocfs2_release_system_inodes() is called.

> 
>>         /* add one more if putting into array for first time */
>> -    if (arr && inode) {
>> -        *arr = igrab(inode);
>> -        BUG_ON(!*arr);
>> +    if (inode && arr && !*arr && !cmpxchg(&(*arr), NULL, inode)) {
> 
> Bypassing the refcnt+1 here is not a good idea. We should do refcnt+1
> before returning to the caller.
> 
>> +        inode = igrab(inode);

We do refcnt+1 immediately after cmpxchg() succeeds, for
ocfs2_release_system_inodes() which clears *arr is the place for
doing refcnt-1.

>> +        BUG_ON(!inode);
>>       }
>> -    mutex_unlock(&osb->system_file_mutex);
>>       return inode;
>>   }
>>   
> 

