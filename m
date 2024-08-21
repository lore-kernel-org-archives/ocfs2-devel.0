Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B811D12FD
	for <ocfs2-devel@lists.linux.dev>; Wed, 21 Aug 2024 10:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724236873; cv=none; b=SYEHRTCsdmsgR3iFhZnE/XNp3fS1qzGUx3+wAmU+tzlsq4mfObV8LRS00XF27Zrw1uH+ccJveHCLAyPPl5oKaMtTDQrXmqO6uZRY0TQVolLuBc4yIGZgPqIadoY9kcypsHQnLckcxzWvSN/xAo3t3fgrT6+iNtksP51/SFOjJdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724236873; c=relaxed/simple;
	bh=MgqXQfGaLc+nIDTVyDl6f5wXU6tPZonqzL6bIuo4/YM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jK42CEK03Xss3SBT4yR4w0qzqwUvVmpu46tv1x4uNX8/zAYsMHY0DuAaOT7EWKEPdcfyeTakLm02S1n6AgL322/mM7QcE1BFofh7oseFjkeWal5RP9wC1D4WIEgVcOn0hQjx0HpD0Xi77kvS08VgmeXLy/29eAi4kimN87bHTno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GwX6P8LX; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GwX6P8LX"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1724236868; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wEhaDbJBW3F/a7RTaPxU6t0bpUhGjfqwIvVd64YX3O4=;
	b=GwX6P8LXD0igoDIA9x9B8eQ41tI7RCL/HizBIDwaALd1o4+BCbE5U5ZyTdBoogbTGLeLg3qUgsLer/9qjd1cJBxoQ/Yaom4YuawSXKSDDbqgiafmGR1To8fK/gdRn61FsqJkr3VYCnlmSdA0ES93DyetwrwMkI+DMSan6rELDnA=
Received: from 30.221.129.221(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WDLhHw4_1724236866)
          by smtp.aliyun-inc.com;
          Wed, 21 Aug 2024 18:41:07 +0800
Message-ID: <606d781a-2d5c-48fc-bc67-4c7ff66a1dd7@linux.alibaba.com>
Date: Wed, 21 Aug 2024 18:41:06 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: Add i_size check for dir
To: Edward Adam Davis <eadavis@qq.com>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <205e0d29-2567-4d82-a024-a8e7826d9f18@linux.alibaba.com>
 <tencent_16A450176CD77A86C8536B8366297C03A105@qq.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <tencent_16A450176CD77A86C8536B8366297C03A105@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/24 9:55 PM, Edward Adam Davis wrote:
> On Tue, 20 Aug 2024 20:44:37 +0800, Joseph Qi wrote:
>>> When the i_size of dir is too large, it will cause limit to overflow and
>>> be less than de_buf, ultimately resulting in last_de not being initialized
>>> and causing uaf issue.
>>>
>>> Reported-and-tested-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
>>> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
>>> ---
>>>  fs/ocfs2/dir.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>>> index d620d4c53c6f..c308dba6d213 100644
>>> --- a/fs/ocfs2/dir.c
>>> +++ b/fs/ocfs2/dir.c
>>> @@ -3343,6 +3343,8 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
>>>  	unsigned long offset = 0;
>>>  	unsigned int rec_len, new_rec_len, free_space;
>>>
>>> +	if (i_size_read(dir) > OCFS2_MAX_BLOCKSIZE)
>>> +		return -EINVAL;
>>
>> Why OCFS2_MAX_BLOCKSIZE?
> I think it is largest block size in ocfs2, therefore, if it is larger
> than it, it must be incorrect, even though the value of i_size in dir
> in the current issue is much larger than it (i_size_read(dir) is 0x900000000000100).
>> It seems that this is caused by a corrupted dir inode, since this is an
>> inline case, we may try best to make sure it won't exceeds block size?
>> i.e. dir->i_sb->s_blocksize.
> You mean dir->i_sb->s_blocksize bigger than OCFS2_MAX_BLOCKSIZE?
> 
No, I mean check s_blocksize seems more reasonable rather than
OCFS2_MAX_BLOCKSIZE.

Thanks,
Joseph
