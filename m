Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD281A5BBE
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Sep 2025 01:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757296312; cv=none; b=kXPzLLO/SEg7sjRzl6OhiuJNFrfNStB4AvYMyOEyS3S9jilzWVuSCrNpk5UukC0ZAvF9f9QfkOB6yALBSAB1fgC2D6xkE0OAEt7zdOqyZPCQyuZxRdGODgBkvPqV6lAgU+qXUz71SusZVjuWjz9gXOezVxFQI7N+vJgWl4fohEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757296312; c=relaxed/simple;
	bh=oezj4ZW/OZn1ZzV3aAfA2dJ8To+R/lSex4B2dmnEGQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=glcZv/P76uXv6Z/4cOdstKL/YQj55rMJbOaoK23tqxf5kGTsEMvk0fu75eT6iNZDc3s1t5QaCQClweWr5M04kQ+2NPUdrD3MlBRqrskalDeZt0XVLQNYUQ0fsOCegZjp6WhECyBRVhFuclaGKvAdz5jek/lbE3vzCKFx9ucZKb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TbiReRBY; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TbiReRBY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757296299; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=sYGhb8CfCA/s+oBe7rr2GPNIIdVTSG49ZvvqC96QQ0g=;
	b=TbiReRBY+WR8lQV41/5G9pY0jynvnkAl17gK2tzcMdD7OPiHK1nTsydQ+nc/9TLPPk2qZrKBw7fFwzmf1FLHcL164a5r/T7x/QpW52VSPkSNo2z4bMRCEqbEDN09L5MwwQaZ/fzuITvUW73VvcOyJJf04ODHP/caBHvUp54RHec=
Received: from 30.221.128.217(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WnQBMaH_1757296298 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Sep 2025 09:51:38 +0800
Message-ID: <8ddcaa59-0cf0-4b7c-a121-924105f7f5a6@linux.alibaba.com>
Date: Mon, 8 Sep 2025 09:51:36 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH] ocfs2: retire ocfs2_drop_inode() and
 I_WILL_FREE usage
To: Mateusz Guzik <mjguzik@gmail.com>,
 Mark Tinguely <mark.tinguely@oracle.com>
Cc: ocfs2-devel@lists.linux.dev, viro@zeniv.linux.org.uk, jack@suse.cz,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, jlbec@evilplan.org, mark@fasheh.com,
 brauner@kernel.org, willy@infradead.org, david@fromorbit.com
References: <766vdz3ecpm7hv4sp5r3uu4ezggm532ng7fdklb2nrupz6minz@qcws3ufabnjp>
 <20250904154245.644875-1-mjguzik@gmail.com>
 <f3671198-5231-41cf-b0bc-d1280992947a@oracle.com>
 <CAGudoHHT=P_UyZZpx5tBRHPE+irh1b7PxFXZAHjdHNLcEWOxAQ@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CAGudoHHT=P_UyZZpx5tBRHPE+irh1b7PxFXZAHjdHNLcEWOxAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/9/5 00:22, Mateusz Guzik wrote:
> On Thu, Sep 4, 2025 at 6:15 PM Mark Tinguely <mark.tinguely@oracle.com> wrote:
>>
>> On 9/4/25 10:42 AM, Mateusz Guzik wrote:
>>> This postpones the writeout to ocfs2_evict_inode(), which I'm told is
>>> fine (tm).
>>>
>>> The intent is to retire the I_WILL_FREE flag.
>>>
>>> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
>>> ---
>>>
>>> ACHTUNG: only compile-time tested. Need an ocfs2 person to ack it.
>>>
>>> btw grep shows comments referencing ocfs2_drop_inode() which are already
>>> stale on the stock kernel, I opted to not touch them.
>>>
>>> This ties into an effort to remove the I_WILL_FREE flag, unblocking
>>> other work. If accepted would be probably best taken through vfs
>>> branches with said work, see https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-6.18.inode.refcount.preliminaries__;!!ACWV5N9M2RV99hQ!OLwk8DVo7uvC-Pd6XVTiUCgP6MUDMKBMEyuV27h_yPGXOjaq078-kMdC9ILFoYQh-4WX93yb0nMfBDFFY_0$
>>>
>>>   fs/ocfs2/inode.c       | 23 ++---------------------
>>>   fs/ocfs2/inode.h       |  1 -
>>>   fs/ocfs2/ocfs2_trace.h |  2 --
>>>   fs/ocfs2/super.c       |  2 +-
>>>   4 files changed, 3 insertions(+), 25 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>>> index 6c4f78f473fb..5f4a2cbc505d 100644
>>> --- a/fs/ocfs2/inode.c
>>> +++ b/fs/ocfs2/inode.c
>>> @@ -1290,6 +1290,8 @@ static void ocfs2_clear_inode(struct inode *inode)
>>>
>>>   void ocfs2_evict_inode(struct inode *inode)
>>>   {
>>> +     write_inode_now(inode, 1);
>>> +
>>>       if (!inode->i_nlink ||
>>>           (OCFS2_I(inode)->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)) {
>>>               ocfs2_delete_inode(inode);
>>> @@ -1299,27 +1301,6 @@ void ocfs2_evict_inode(struct inode *inode)
>>>       ocfs2_clear_inode(inode);
>>>   }
>>>
>>> -/* Called under inode_lock, with no more references on the
>>> - * struct inode, so it's safe here to check the flags field
>>> - * and to manipulate i_nlink without any other locks. */
>>> -int ocfs2_drop_inode(struct inode *inode)
>>> -{
>>> -     struct ocfs2_inode_info *oi = OCFS2_I(inode);
>>> -
>>> -     trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
>>> -                             inode->i_nlink, oi->ip_flags);
>>> -
>>> -     assert_spin_locked(&inode->i_lock);
>>> -     inode->i_state |= I_WILL_FREE;
>>> -     spin_unlock(&inode->i_lock);
>>> -     write_inode_now(inode, 1);
>>> -     spin_lock(&inode->i_lock);
>>> -     WARN_ON(inode->i_state & I_NEW);
>>> -     inode->i_state &= ~I_WILL_FREE;
>>> -
>>> -     return 1;
>>> -}
>>> -
>>>   /*
>>>    * This is called from our getattr.
>>>    */
>>> diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
>>> index accf03d4765e..07bd838e7843 100644
>>> --- a/fs/ocfs2/inode.h
>>> +++ b/fs/ocfs2/inode.h
>>> @@ -116,7 +116,6 @@ static inline struct ocfs2_caching_info *INODE_CACHE(struct inode *inode)
>>>   }
>>>
>>>   void ocfs2_evict_inode(struct inode *inode);
>>> -int ocfs2_drop_inode(struct inode *inode);
>>>
>>>   /* Flags for ocfs2_iget() */
>>>   #define OCFS2_FI_FLAG_SYSFILE               0x1
>>> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
>>> index 54ed1495de9a..4b32fb5658ad 100644
>>> --- a/fs/ocfs2/ocfs2_trace.h
>>> +++ b/fs/ocfs2/ocfs2_trace.h
>>> @@ -1569,8 +1569,6 @@ DEFINE_OCFS2_ULL_ULL_UINT_EVENT(ocfs2_delete_inode);
>>>
>>>   DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_clear_inode);
>>>
>>> -DEFINE_OCFS2_ULL_UINT_UINT_EVENT(ocfs2_drop_inode);
>>> -
>>>   TRACE_EVENT(ocfs2_inode_revalidate,
>>>       TP_PROTO(void *inode, unsigned long long ino,
>>>                unsigned int flags),
>>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>>> index 53daa4482406..e4b0d25f4869 100644
>>> --- a/fs/ocfs2/super.c
>>> +++ b/fs/ocfs2/super.c
>>> @@ -129,7 +129,7 @@ static const struct super_operations ocfs2_sops = {
>>>       .statfs         = ocfs2_statfs,
>>>       .alloc_inode    = ocfs2_alloc_inode,
>>>       .free_inode     = ocfs2_free_inode,
>>> -     .drop_inode     = ocfs2_drop_inode,
>>> +     .drop_inode     = generic_delete_inode,
>>>       .evict_inode    = ocfs2_evict_inode,
>>>       .sync_fs        = ocfs2_sync_fs,
>>>       .put_super      = ocfs2_put_super,
>>
>>
>> I agree, fileystems should not use I_FREEING/I_WILL_FREE.
>> Doing the sync write_inode_now() should be fine in ocfs_evict_inode().
>>
>> Question is ocfs_drop_inode. In commit 513e2dae9422:
>>   ocfs2: flush inode data to disk and free inode when i_count becomes zero
>> the return of 1 drops immediate to fix a memory caching issue.
>> Shouldn't .drop_inode() still return 1?
> 
> generic_delete_inode is a stub doing just that.
> 
In case of "drop = 0", it may return directly without calling evict().
This seems break the expectation of commit 513e2dae9422.

Thanks,
Joseph
