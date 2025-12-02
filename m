Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF92513C3F2
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 01:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764638722; cv=none; b=DDMM5fPoZMMmQ9t+t7ADkn2U+7cKErYvPBxWNFHmTOUvPjcC5gOGoHJ6RJ0fMMTStxLvkkL4jHB35YCWvnYBUp4mwkBMVZgzfH+n1ctBbeTy7Aay0t3B2d6RDWsLBY7H3yc5eKXIC7fe+tHXvpdFGKPomhisUcDHqWl+kXjtZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764638722; c=relaxed/simple;
	bh=uHs2oPKQ3cM1cZpVBEIdmre1LDvvbJ6UGyYrPoXHXwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sijyXCafHJQ2jCLorRwXyNUkv7yTwRdyBI+ZgazYpyc8Iod/k2LMAFgDdj3qWzpgvo8//dyhdw0SX6r6aflwvgKQQIGRV8Z6iG1l/cAPDl6f7OzTX/p+QUdAhgmMkmjXwAYy0VrF8Ee7jxHk9sNos/a/hcbiIy6X8t6chfmLm/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DeRz1iE/; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DeRz1iE/"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764638716; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vWL6sHrOHn0D74zxtiLPBX/mjidfedzAlss60GVI7FE=;
	b=DeRz1iE/GN84FkzXrSs6r5c79zFjMpXYCgVfoWkdgN59aQHoDW1FXiYjlZbu+FIjKqqr4cJL/9HxWoVH0bxZbf5A+H/LDqH+92MHj15lVtKdgNgJ/cI3FdKARHxK5KBi+7ClbKv04hMMMJNhlBuIYZUe4c5NEE2fumtwO0Vkap8=
Received: from 30.221.128.146(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WtuB3xP_1764638715 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 09:25:15 +0800
Message-ID: <971dd5c8-970d-47d0-8cd3-b2b56aa0aee8@linux.alibaba.com>
Date: Tue, 2 Dec 2025 09:25:14 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: Invalidate inode if i_mode is zero after block
 read
To: Heming Zhao <heming.zhao@suse.com>,
 Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com,
 skhan@linuxfoundation.org,
 syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251119221723.171746-2-eraykrdg1@gmail.com>
 <lkeaoxtkqccd3knpskbewkbn4cimlxaufix4evugcfkplk6u4b@oi36e4iu3x3r>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <lkeaoxtkqccd3knpskbewkbn4cimlxaufix4evugcfkplk6u4b@oi36e4iu3x3r>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/11/20 10:32, Heming Zhao wrote:
> On Thu, Nov 20, 2025 at 01:17:24AM +0300, Ahmet Eray Karadag wrote:
>> A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
>> handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.
>>
>> This "zombie" inode is created because ocfs2_read_locked_inode proceeds
>> even after ocfs2_validate_inode_block successfully validates a block
>> that structurally looks okay (passes checksum, signature etc.) but
>> contains semantically invalid data (specifically i_mode=0). The current
>> validation function doesn't check for i_mode being zero.
>>
>> This results in an in-memory inode with i_mode=0 being added to the VFS
>> cache, which later triggers the panic during unlink.
>>
>> Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0, non-orphan)
>> within ocfs2_validate_inode_block. If the check is true, return -EFSCORRUPTED to signal
>> corruption. This causes the caller (ocfs2_read_locked_inode) to invoke
>> make_bad_inode(), correctly preventing the zombie inode from entering
>> the cache.
>>
>> Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
>> Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
>> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
>> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
>> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
>> Previous link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
>> ---
>> v2:
>>  - Only checking either i_links_count == 0 or i_mode == 0
>>  - Not performing le16_to_cpu() anymore
>>  - Tested with ocfs2-test
>> ---
>> v3:
>>  - Add checking both high and low bits of i_links_count
>> ---
>>  fs/ocfs2/inode.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 14bf440ea4df..c8b129db756e 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -1456,6 +1456,13 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>>  		goto bail;
>>  	}
>>  
>> +	if (!ocfs2_read_links_count(di) || !di->i_mode) {
> 
> the code logic looks good to me, but I prefer the following code to save a few
> cpu cycles.
> 
> ```
> /* only check if the "link count" or i_mode is ZERO */
> if (!(di->i_links_count | di->i_links_count_hi) || !di->i_mode)
> ```
> 
> @Joseph
> which do you like?
> 
Sorry to miss this thread discuss.
The above check looks wried since "(di->i_links_count|di->i_links_count_hi)"
is meaningless, though it may work well...
So I'd prefer the code readability first.

BTW, from the syzbot report, I haven't seen where to show i_mode=0 or
i_nlink=0. Am I missing something?

Thanks,
Joseph

