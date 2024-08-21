Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C11146D75
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 02:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724207695; cv=none; b=CElmjw1IL9hbJZ9sf6Y1Y2+Dv9exOhd8aVdxtvz+a32FnOmjOWWOSBwyTFP5/DHOWqYn5+LaJ1N6JqcFwvqIBLjzbAH0yDGR25Jthp8meKjkZkWi8fJs1E/E2vDYH6HcNg4wi83nCxQqO0qMBmg0+SL0vmAvlnadoSkB5ILePTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724207695; c=relaxed/simple;
	bh=2vIZoAkI1Z9uABYuBIDeLBVi4Sea2hT1Cb7RdlLY72Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JBDw08Jlp7mB6BVwNlVso7jNeid3ztBBTsd0bLblGIq34PrdWZYayfYWaUxBHCV4F5JZLtVQ6CCZ771sErmHlz2t3D/jrz/XzoVN4grPmId+dhP3babW77r5+3B2p8BnBzgJRxeE3pMyrAr7FJqpE2EEoBjzZMPLcsUmEApOC3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bRG1pe4p; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bRG1pe4p"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724207690; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=xh6r/ko5G9TK3mJe6TGl9rTenCN9wEzZQt+59fp/fb8=;
	b=bRG1pe4pjin4vA6rlzNjgESZoBxa4Wz4YJYRsO7I6Rbtp2I82QzNC4RMuL7sNtD2tr/UGdfFfRkW7dsGdourfnZoc+zyUst5kH+FLVAudp554rjETbGQOPojBc/67RWYCs5g2pbkNqlWsPw7/V/dndCgLF5m97ACjTvTeRcN9lI=
Received: from 30.221.129.221(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WDKIOcs_1724207688)
          by smtp.aliyun-inc.com;
          Wed, 21 Aug 2024 10:34:49 +0800
Message-ID: <416247e6-5da7-401c-815f-a4cf8ae37d51@linux.alibaba.com>
Date: Wed, 21 Aug 2024 10:34:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] ocfs2: Fix uaf in ocfs2_set_buffer_uptodate
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Lizhi Xu <lizhi.xu@windriver.com>, heming.zhao@suse.com
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <980b3f4d-f265-4eb4-96a3-8f1a75588193@suse.com>
 <20240820094512.2228159-1-lizhi.xu@windriver.com>
 <20240820094512.2228159-2-lizhi.xu@windriver.com>
 <7da687ce-ffb7-44e3-bddc-d5c2f4f48c95@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <7da687ce-ffb7-44e3-bddc-d5c2f4f48c95@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

And this is not a UAF case, but NULL pointer dereference.
So I suggest change the subject to:
ocfs2: fix possible NULL pointer dereference in ocfs2_set_buffer_uptodate

On 8/21/24 8:08 AM, Joseph Qi wrote:
> 
> 
> On 8/20/24 5:45 PM, Lizhi Xu wrote:
>> In the for-loop after the 'read_failure' label, the condition
>> '(bh == NULL) && flags includes OCFS2_BH_READAHEAD' is missing.
>> When this contidion is true, this for-loop will call ocfs2_set_buffer
>> _uptodate(ci, bh), which then triggers a NULL pointer access error.
>>
> 
> Or it may simplified as the following:
> 
> When doing cleanup, if flags without OCFS2_BH_READAHEAD, it may trigger
> NULL pointer dereference in the following ocfs2_set_buffer_uptodate() if
> bh is NULL.
> 
>> Changes from V2:
>> * Make the code more concise
>>
> 
> This is not the right place for changelog.
> 
> Thanks,
> Joseph
> 
>> Reported-and-suggested-by: Heming Zhao <heming.zhao@suse.com>
>> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
>> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>>  fs/ocfs2/buffer_head_io.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
>> index e62c7e1de4eb..8f714406528d 100644
>> --- a/fs/ocfs2/buffer_head_io.c
>> +++ b/fs/ocfs2/buffer_head_io.c
>> @@ -388,7 +388,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
>>  		/* Always set the buffer in the cache, even if it was
>>  		 * a forced read, or read-ahead which hasn't yet
>>  		 * completed. */
>> -		ocfs2_set_buffer_uptodate(ci, bh);
>> +		if (bh)
>> +			ocfs2_set_buffer_uptodate(ci, bh);
>>  	}
>>  	ocfs2_metadata_cache_io_unlock(ci);
>>  
