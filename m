Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADC33F4100
	for <ocfs2-devel@lists.linux.dev>; Sun,  6 Sep 2026 07:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788681317; cv=none; b=IsnokVAbVfLe1vwsSGf5VWfNu8YlZyqfBBVfgg9VibfzGu/qsWArp1SSh1DtZHzB4wtKnpkuaRIDAElBWu2Fk70UVu6JbGDXG+p9Alm916QNIIIzFXR/voB1wZgEiPDhDUjqVhDpnN/DJEdi4cguTsf4BigUvsl8Na+wjEKGl1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788681317; c=relaxed/simple;
	bh=6hRhD9s1Eb7w8aUoYQgcahtjpsTZZhQSlbsiHuBcnpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S3D8LO4QVRVbuxSTEmqwoOeMJSf3HDZCgh+HAP4mQ/xUdbxztE2p5F2tsc4XweF4NBgklNJu0HE1Q3SR5ZqFtEiqG6yrFxg9NwrVqpTuo6/T8SNbyMe7HAtphZPuov40LOFlR5UhveVS+b1lqoxBLME2piOKYzW1KIr0yGXurMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WP5eKxvl; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WP5eKxvl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788681303; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=e7lUb3+CThFsrKCAjFzK0nWH7mvvwMgeJ0ZmcJZES8Q=;
	b=WP5eKxvlbFWRZkJLQIJK6pAg/NA1zY5r52ysr/hi+wXVYHGvc+Od/mqDsF+yI20sDm45hpdm5ob1eDtVEpRedtamdLz8yuLjoIjmACVVYVUp/1a4q0lnbSdwmPssPxRjkd0mN9gg3AH/2ukgYBGpvrjrHA+osW34b1RsYvoxP7o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XAMeP8u_1788681302;
Received: from 30.134.112.244(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAMeP8u_1788681302 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 06 Sep 2026 15:55:02 +0800
Message-ID: <d9e68cce-14b0-4065-8973-3d1c5f5c5c97@linux.alibaba.com>
Date: Sun, 6 Sep 2026 15:55:01 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ocfs2: validate dl_blkno and dl_fs_generation of
 dir index leaf blocks
To: Heming Zhao <heming.zhao@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260905142144.2869105-1-joseph.qi@linux.alibaba.com>
 <20260905142144.2869105-2-joseph.qi@linux.alibaba.com> <apwp-6JMpJckN3If@p15>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <apwp-6JMpJckN3If@p15>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/5/26 10:45 PM, Heming Zhao wrote:
> On Sat, Sep 05, 2026 at 10:21:44PM +0800, Joseph Qi wrote:
>> ocfs2_validate_dx_leaf() checks the checksum, the signature and the
>> entry list counts, but it never checks dl_blkno or dl_fs_generation.
>> The inode, extent block, xattr block, refcount block and dir index root
>> validators all check the on-disk block number against bh->b_blocknr and
>> the generation against the superblock, and both dir index leaf fields
>> are documented as "Must match super block".
>>
>> Without the checks, a stale dir index leaf block left on the device from
>> a previously formatted filesystem at the same physical block number can
>> pass validation as long as its signature, entry counts and checksum
>> match.  Its index entries would then be used in the new filesystem
>> context.
>>
>> Both fields are written unconditionally when a leaf block is formatted
>> in ocfs2_dx_dir_format_cluster(), from the live superblock generation
>> and the real block number, so a correctly formatted filesystem cannot
>> trip the new checks.  The leaf block number read back here comes from
>> on-disk dir index root extent records.
>>
>> Reject dir index leaf blocks whose dl_blkno or dl_fs_generation does not
>> match, like the dir index root validator does.
>>
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>>  fs/ocfs2/dir.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
>> index 329680b46227..55c4a305a282 100644
>> --- a/fs/ocfs2/dir.c
>> +++ b/fs/ocfs2/dir.c
>> @@ -733,6 +733,18 @@ static int ocfs2_validate_dx_leaf(struct super_block *sb,
>>  		return ocfs2_error(sb, "Dir Index Leaf has bad signature %.*s\n",
>>  				   7, dx_leaf->dl_signature);
>>  
>> +	if (le64_to_cpu(dx_leaf->dl_blkno) != bh->b_blocknr)
>> +		return ocfs2_error(sb,
>> +				   "Dir Index Leaf # %llu has an invalid dl_blkno of %llu\n",
>> +				   (unsigned long long)bh->b_blocknr,
>> +				   (unsigned long long)le64_to_cpu(dx_leaf->dl_blkno));
> 
> The patch looks fine to me.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>
> 
> Only question: Do we add the same check for dl_blkno in ocfs2_validate_dx_root()?
> 

Yes，it's already added by:
a08f83559463c ocfs2: validate suballoc slot and bit of xattr and dir index blocks

Thanks,
Joseph
