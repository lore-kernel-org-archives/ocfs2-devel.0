Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018632FD7CA
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 06:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656232; cv=none; b=gGcRWI9p1XTQBWugDxuXuUrmCecHyjGJmeA58gq3XtE1weHTWw7SdD255ePRxSOfDiSYwyXD0cGQpT0Q84OV3NiOZeL0eJLqGK+XdCXgY+F3LHMYAyCnXdnBY0Tgt3phMWPFQcv9v81ZUM7JvIFya4FBxivOIQ31zt+77Oabugo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656232; c=relaxed/simple;
	bh=yb6ZM8y6BeOOBjacvLvS46rC1H0Qv1yJ5bga74I58Qg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t7cFn3UlS6In0MmJQcHWp28de4qIySps54AbKGh22njlTxmPPw1/dSndxIZeQB25k5KIHuNKGHDKt/TavggS4+f+CRQtc8YmnufrbykoR4pmrZuC5UVoSjs2UQS6rnQENBp2tBuX2dZ4x0Hbr5yQFJW7RsAe4cbwuhLi3P9kDBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iswtzwpR; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iswtzwpR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764656217; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IiLWJ4yqEBxjoNEx6cYypR+Pdv1UUnacaVj+NmacKag=;
	b=iswtzwpRChHdqm4QCVLCDqfQuRVX+vfpQyXbIJ6FCfVq5j8iLWIlXPAmB+qzxVBO0AZhBaLGXJsmjJV0o8z8dfECVcqa0rN36nQnKS4CmxcAGolQQ88yDSHwK/CX0KB5jUCU4egMeu+vET+EqVQSWUgpACfKFAEHqxiY/CAbKLY=
Received: from 30.221.128.146(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WtvIFND_1764656216 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Dec 2025 14:16:56 +0800
Message-ID: <8ede6a79-adb8-4b89-a8c2-d0cf57ff2267@linux.alibaba.com>
Date: Tue, 2 Dec 2025 14:16:55 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] ocfs2: Invalidate inode if i_mode is zero after block
 read
To: Heming Zhao <heming.zhao@suse.com>,
 Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, david.hunter.linux@gmail.com,
 skhan@linuxfoundation.org,
 syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>
References: <20251108120133.37443-3-eraykrdg1@gmail.com>
 <20251202035213.633096-2-eraykrdg1@gmail.com>
 <r3mqyzrky6pamao7b4tsobdqqybhmyt6dg7jao76ho24kph3aq@wfwbzjqzury5>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <r3mqyzrky6pamao7b4tsobdqqybhmyt6dg7jao76ho24kph3aq@wfwbzjqzury5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/2 14:15, Heming Zhao wrote:
> On Tue, Dec 02, 2025 at 06:52:14AM +0300, Ahmet Eray Karadag wrote:
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
>> v4:
>>  - Reading i_links_count hi and low bits without helper function
>>   to save few cpu cycles
>> ---
>> v5:
>>  - Clear i_links_count check
>>  - Log the actual i_nlink/i_mode
>> ---
>>  fs/ocfs2/inode.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 14bf440ea4df..08ce0846289c 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -1456,6 +1456,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>>  		goto bail;
>>  	}
>>  
>> +	if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
>> +		mlog(ML_ERROR, "Invalid dinode #%llu: "
>> +			"Corrupt state (nlink = %u or mode = %u) detected!\n",
>> +		        (unsigned long long)bh->b_blocknr,
>> +			(di->i_links_count_hi | di->i_links_count), di->i_mode);
> 
> The '|' logic is meaningless here. Because the error case is rare, you can simply
> call ocfs2_read_links_count(di).
> 
Yes, also 'di->i_mode' should be converted to cpu endian as well.

Joseph

