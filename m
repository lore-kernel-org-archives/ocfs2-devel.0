Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC150E56C
	for <ocfs2-devel@lists.linux.dev>; Fri, 11 Oct 2024 02:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612114; cv=none; b=HsjB54hx24OCCtCPlUSCn5GZmHCYUoCKa+bf9zEKZ4wu14Iltzb37UkKLzDotF5PCJvlEnwOqH4u2Kbsrd9ISFhFBVaPJIKbwY9W+j+dk9FQ6pL5KBeiauWUrNGcVaay7WBiw7KYqrglHJcWJkUh7j1khZh6sPgDDaURYNaWYx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612114; c=relaxed/simple;
	bh=5YT2MH1SphLD8yHu2ulmt0PGxbNLsGIh/lMJ2PXkc+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dcyEu7tDPu62IO9AaD7GYhWlBCvfR8/I1Ml25p/EhXYjHdh3o4b35YrlcyiT7td9LCUWjAvmQwdYxclwDckxElt0vyQr4KxZKT/s6ethWfxUCuM2+XF82R6Tr+btRIW9WyQrvSEVktue8SZFwq7ZQr6MUF7F0p6HpSiziUQ9zZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=n5TEXOXO; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="n5TEXOXO"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1728612109; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=duKuP/OKhaeT4t3udU5f6xeBjrv0An1V+wIGEM26XZM=;
	b=n5TEXOXOXyAemuS2fVFiiViAk6fTZ8wKhKMkkPXNFv4bLQGKsw0LExlbyj4/WNIQoWSjmyjKx/qxoTrN9HW0viA71C7ZZVAW/vweXYvKxwFWQwbI9kV+o1g+THVvHxgOtdCvSosRLZOw6Xu+eDNXbFVsVy4t9E2qjqHD1JfMp9Q=
Received: from 30.221.129.65(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WGoD5Hf_1728612108 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 11 Oct 2024 10:01:49 +0800
Message-ID: <a9a6f5ce-e0ef-4b5e-bfe8-7657ad1a8dac@linux.alibaba.com>
Date: Fri, 11 Oct 2024 10:01:48 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] ocfs2: pass u64 to ocfs2_truncate_inline maybe
 overflow
To: Su Yue <l@damenly.org>, Edward Adam Davis <eadavis@qq.com>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <4195446e-2d2b-442c-a1ad-b1498d243a70@linux.alibaba.com>
 <tencent_91D2962236324AA47465761367183C8F3709@qq.com>
 <ed4no1gp.fsf@damenly.org>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <ed4no1gp.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 10/11/24 9:07 AM, Su Yue wrote:
> 
> On Thu 10 Oct 2024 at 22:31, Edward Adam Davis <eadavis@qq.com> wrote:
> 
>> Syzbot reported a kernel BUG in ocfs2_truncate_inline.
>> There are two reasons for this: first, the parameter value passed is greater
>> than UINT_MAX, second, the start and end parameters of ocfs2_truncate_inline
>> are "unsigned int".
>>
>> So, we need to add a sanity check for byte_start and byte_len right before
>> ocfs2_truncate_inline() in ocfs2_remove_inode_range(), if they are greater
>> than UINT_MAX return -EFBIG.
>>
>> Reported-by: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
>> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
>> ---
>> V1 -> V2: move sanity check to ocfs2_remove_inode_range
>>
>>  fs/ocfs2/file.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index ad131a2fc58e..05d6a8acfcda 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -1784,6 +1784,11 @@ int ocfs2_remove_inode_range(struct inode *inode,
>>          return 0;
>>
>>      if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
>> +        if (byte_start > UINT_MAX || byte_start + byte_len > UINT_MAX) {
>>
> Why not use ocfs2_max_inline_data_with_xattr() here? Yes, UINT_MAX indeed
> solves overflow problem Syzbot reported but you can find much lowerer
> limit if once looked into inline data structures.

Right, since it is inline data, so the offset can't exceeds block size
at least. You can refer bad inline data check in
ocfs2_read_inline_data().

Thanks,
Joseph
 
