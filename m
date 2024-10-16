Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1214ABA45
	for <ocfs2-devel@lists.linux.dev>; Wed, 16 Oct 2024 02:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729044498; cv=none; b=QA8IVUMFYo3CmhRkMPPceppzqJb6i4t3DyM2SyU6LddYLpQJiAUGB3cXor7IP+tsLAqNhFefSdAngABEl6d40tdWN4kQbMiPReOTrFyxGENJeyY3VU4/ZHlFHzNhtbbacCgLBgMWvbtYblPyVujhjkB72A+ENckGEElpmxTGukU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729044498; c=relaxed/simple;
	bh=mSt+llx5V9Jk5EZZTu94ZxFrTSLWrMasbVRGewz5CgU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=fUDUjH1g4S0YOEgn906HFDSXPY8LH0JM/sKabmX1c49ajuvy9LeENWlwxTUFbiaP8UhQK4goDJvE5SLZml6dtCIzrctTDmRErJkdiYqtQ4hg4k6c6PKbTjDskP6TsMhKL6jvERn1fqFA0bac84iJbNBocrgFDUAuUHNzvvFor+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Cx0xYSmE; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Cx0xYSmE"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1729044491; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=xXcdYa7bBPWB644v53VqWYgELpfwLoDsr9YzxCxASzk=;
	b=Cx0xYSmEAVuHCH0M+nygGjU0vPO2r4J6xeGKI9laVS1rNaBfjFGxoF5hG/N/800SbLb935rIMOWeGtZ1I30hDCGH+kE8qy0fyr4cx7de6LfxXkD4Jrr+hmjdFVKFkB6sYQnt9Jb5WNEuU+o8zCZgMwyh0HmAmeN0mQjQwk0+Ojk=
Received: from 30.221.129.144(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WHFDWVb_1729044490 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Oct 2024 10:08:10 +0800
Message-ID: <40f48906-09fd-4695-aef0-7647de46ea42@linux.alibaba.com>
Date: Wed, 16 Oct 2024 10:08:09 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] ocfs2: pass u64 to ocfs2_truncate_inline maybe
 overflow
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Edward Adam Davis <eadavis@qq.com>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, Su Yue <l@damenly.org>
References: <4195446e-2d2b-442c-a1ad-b1498d243a70@linux.alibaba.com>
 <tencent_91D2962236324AA47465761367183C8F3709@qq.com>
 <ed4no1gp.fsf@damenly.org>
 <a9a6f5ce-e0ef-4b5e-bfe8-7657ad1a8dac@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <a9a6f5ce-e0ef-4b5e-bfe8-7657ad1a8dac@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 10/11/24 10:01 AM, Joseph Qi wrote:
> 
> 
> On 10/11/24 9:07 AM, Su Yue wrote:
>>
>> On Thu 10 Oct 2024 at 22:31, Edward Adam Davis <eadavis@qq.com> wrote:
>>
>>> Syzbot reported a kernel BUG in ocfs2_truncate_inline.
>>> There are two reasons for this: first, the parameter value passed is greater
>>> than UINT_MAX, second, the start and end parameters of ocfs2_truncate_inline
>>> are "unsigned int".
>>>
>>> So, we need to add a sanity check for byte_start and byte_len right before
>>> ocfs2_truncate_inline() in ocfs2_remove_inode_range(), if they are greater
>>> than UINT_MAX return -EFBIG.
>>>
>>> Reported-by: syzbot+81092778aac03460d6b7@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=81092778aac03460d6b7
>>> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
>>> ---
>>> V1 -> V2: move sanity check to ocfs2_remove_inode_range
>>>
>>>  fs/ocfs2/file.c | 5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>>> index ad131a2fc58e..05d6a8acfcda 100644
>>> --- a/fs/ocfs2/file.c
>>> +++ b/fs/ocfs2/file.c
>>> @@ -1784,6 +1784,11 @@ int ocfs2_remove_inode_range(struct inode *inode,
>>>          return 0;
>>>
>>>      if (OCFS2_I(inode)->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
>>> +        if (byte_start > UINT_MAX || byte_start + byte_len > UINT_MAX) {
>>>
>> Why not use ocfs2_max_inline_data_with_xattr() here? Yes, UINT_MAX indeed
>> solves overflow problem Syzbot reported but you can find much lowerer
>> limit if once looked into inline data structures.
> 
> Right, since it is inline data, so the offset can't exceeds block size
> at least. You can refer bad inline data check in
> ocfs2_read_inline_data().
> 
Could you please update the check condition and send a new version?

Thanks,
Joseph

