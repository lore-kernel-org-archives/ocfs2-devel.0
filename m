Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3095E17588
	for <ocfs2-devel@lists.linux.dev>; Mon, 30 Dec 2024 02:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735525613; cv=none; b=oUbANbNURcoznnizlNvw/rmSK9NrKE4xGn/z+M/RzQ2bIFlutczMlbDcCATsDfedU9vfSgDE3WpnclQCUDTbNB43z4z/rmb/3jpAaWXBXxX2xrKmncxZEySKpsMhPuTTTa54ep37M19x87jprYa6D5Vd6s45KRtPSmDkNbCkTvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735525613; c=relaxed/simple;
	bh=lpnxMHtCxjsEjLix2+2j3OXYNiMRP7nZzVttUbqGRBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eLDtr+sqx0KeCuEHJkyYoGhnV1IW5vIybckZitALRgJeoIRLrifK5W5htF/9/wRSLR32liiDq0MvCEY27SLzqHz/mVb0S41eyurSpDGmcKw75DXM87GfQhT986ZUBbFIncwhcReba+q5uNkv/IgMh0NJuFJ+K8G7XdDcsxKZBrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kgtgsBQN; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kgtgsBQN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1735525601; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EzIBDka8FMcES/Nz8XBvheWklMzM4V/ljD5qsinAatA=;
	b=kgtgsBQNXPTBJ24n8K1drW/p1H+ZJ0a67IMnf951zsNIvA/zqHK4VwpumflS4VHFp0unUwZQoeeoDjnP4Mbj85Ij7o9nU8Fu6r0C83lu2aJCukK7QJGAJ0Hv3k8oByTig9baIzjBeMIIX262jEKO+wWKZLIRNk3fEaQ7hX0eWK4=
Received: from 30.221.129.25(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WMRaCc4_1735525600 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 30 Dec 2024 10:26:41 +0800
Message-ID: <4a74859a-a0a4-419e-b481-f1ffc4e77e85@linux.alibaba.com>
Date: Mon, 30 Dec 2024 10:26:40 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add extent record check in ocfs2_commit_truncate()
To: Glass Su <glass.su@suse.com>, Matthew Wilcox <willy@infradead.org>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+c16daba279a1161acfb0@syzkaller.appspotmail.com
References: <20241217104345.358461-1-dmantipov@yandex.ru>
 <BCB4B87E-9C81-4212-8C05-CE160130A399@suse.com>
 <Z3EpSTa5KzSazonJ@casper.infradead.org>
 <A4DC5E5D-8736-45AA-8B8E-8124422B89B3@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <A4DC5E5D-8736-45AA-8B8E-8124422B89B3@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/12/30 10:05, Glass Su wrote:
> 
> 
>> On Dec 29, 2024, at 18:49, Matthew Wilcox <willy@infradead.org> wrote:
>>
>> On Sun, Dec 29, 2024 at 10:05:17AM +0800, Glass Su wrote:
>>>> +++ b/fs/ocfs2/alloc.c
>>>> @@ -7219,12 +7219,20 @@ int ocfs2_commit_truncate(struct ocfs2_super *osb,
>>>> struct ocfs2_extent_rec *rec;
>>>> struct ocfs2_path *path = NULL;
>>>> struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
>>>> + u16 tree_depth = le16_to_cpu(di->id2.i_list.l_tree_depth);
>>>
>>> No need of tree_depth. Just call
>>> If (unlikely(le16_to_cpu(di->id2.i_list.l_tree_depth) >= OCFS2_MAX_PATH_DEPTH))  {
>>
>> That seems more complicated to me.  I find the original easier to read.
>>
>>>> + if (unlikely(tree_depth >= OCFS2_MAX_PATH_DEPTH)) {
>>>> + ocfs2_error(inode->i_sb,
>>>> +    "dinode %llu has invalid extent record depth %u\n",
>>>> +    (u64)di_bh->b_blocknr, tree_depth);
>>>> + return -EINVAL;
>>>
>>> -EIO is better.
>>
>> -EFSCORRUPTED is surely the right errno here?
> 
> Indeed. -EIO is an old school errno. -EFSCORRUPTED is more accurate.
> 

Yes, EFSCORRUPTED is more proper.
It seems that it is caused by a crafted ocfs2 image. And I think there will
be more bugs for those similar crafted images.

Thanks,
Joseph
