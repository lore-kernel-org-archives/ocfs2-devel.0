Received: from forward502b.mail.yandex.net (forward502b.mail.yandex.net [178.154.239.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE802641FB
	for <ocfs2-devel@lists.linux.dev>; Wed, 29 Oct 2025 14:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761748398; cv=none; b=jmsEWRiAkGggODqK0OP2GBp2ZCgJsArAaKj5uK0AN+P6IfUXPOCTbOLNWlxQ5WuzoIieeQ8xz5jXkpGrf6554hkUbkgIOUtBs+ss1TgjH1nZ8jyyhetS96pmJfgF82AgJbhz4uy7NDyb90XSV3LDKKsg1tqi2XTHvFLaI/CLvQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761748398; c=relaxed/simple;
	bh=pPEXzXLfrJS09Poes4pauiyCnrlZWaFmr7JJ1suDeKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SMrYl+OZZPM4dFchZ01cXI5UhtzZb7PU+pfiN+klfPcyPEZY6ZaVOD3O2EwRymhXEe4mIVuNaebHCPCtCB+xp6aj4tS8zZ2cVI1tcNwM+dI18FjX7qNnVNBh7VHs3z0SJ8b/HDVEISUW+3xczFPyu4kzzFk4XQZwlgMJqJLWvXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=bvLD0VZn; arc=none smtp.client-ip=178.154.239.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="bvLD0VZn"
Received: from mail-nwsmtp-smtp-production-main-55.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-55.sas.yp-c.yandex.net [IPv6:2a02:6b8:c16:17a0:0:640:d1e1:0])
	by forward502b.mail.yandex.net (Yandex) with ESMTPS id EB33881FF4;
	Wed, 29 Oct 2025 17:25:04 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-55.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 3PfYtE2LLOs0-rXGl9nlr;
	Wed, 29 Oct 2025 17:25:04 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761747904; bh=+lWyF9kZJpT1AoIgRnpkaSrq1ILpHn88231GH9z+aIk=;
	h=In-Reply-To:To:From:Cc:Date:References:Subject:Message-ID;
	b=bvLD0VZn3kwP/pcl7Xq1hMWXxc14UqMqmF1mT0do9C3GAfnAV61/ZiMB8E6tJgnyX
	 Ina2175DQieDCiBGrrZiNRYpEf9RokZAbW8TaVl3lCt3Twyvop0B2PNOQ6bwUakIFZ
	 KUb/VWf5tshdJaghexO8hH7BCltHPwxUNSktcIRs=
Authentication-Results: mail-nwsmtp-smtp-production-main-55.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <523f1272-8bf8-41d4-afb1-36a7ceb11494@yandex.ru>
Date: Wed, 29 Oct 2025 17:25:03 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: validate cl_bpc in allocator inodes to prevent
 divide-by-zero
Content-Language: en-MW
To: Joseph Qi <joseph.qi@linux.alibaba.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>, akpm <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 lvc-project@linuxtesting.org,
 syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
References: <9461385f-235d-40fc-8da6-b1f2dfb47d6c@linux.alibaba.com>
 <20251029055338.1192000-1-dmantipov@yandex.ru>
 <20251029055338.1192000-2-dmantipov@yandex.ru>
 <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
From: Dmitry Antipov <dmantipov@yandex.ru>
Autocrypt: addr=dmantipov@yandex.ru; keydata=
 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
 A/UwwXBRuvydGV0=
In-Reply-To: <632f9f46-785d-4da9-a422-546fe3d91af3@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/25 12:53 PM, Joseph Qi wrote:

> On 2025/10/29 13:53, Dmitry Antipov wrote:
>> From: Deepanshu Kartikey <kartikey406@gmail.com>
>>
>> The chain allocator field cl_bpc (blocks per cluster) is read from disk
>> and used in division operations without validation. A corrupted filesystem
>> image with cl_bpc=0 causes a divide-by-zero crash in the kernel:
>>
>>    divide error: 0000 [#1] PREEMPT SMP KASAN
>>    RIP: 0010:ocfs2_bg_discontig_add_extent fs/ocfs2/suballoc.c:335 [inline]
>>    RIP: 0010:ocfs2_block_group_fill+0x5bd/0xa70 fs/ocfs2/suballoc.c:386
>>    Call Trace:
>>     ocfs2_block_group_alloc+0x7e9/0x1330 fs/ocfs2/suballoc.c:703
>>     ocfs2_reserve_suballoc_bits+0x20a6/0x4640 fs/ocfs2/suballoc.c:834
>>     ocfs2_reserve_new_inode+0x4f4/0xcc0 fs/ocfs2/suballoc.c:1074
>>     ocfs2_mknod+0x83c/0x2050 fs/ocfs2/namei.c:306
>>
>> This patch adds validation in ocfs2_validate_inode_block() to ensure cl_bpc
>> matches the expected value calculated from the superblock's cluster size
>> and block size for chain allocator inodes (identified by OCFS2_CHAIN_FL).
>>
>> Moving the validation to inode validation time (rather than allocation time)
>> has several benefits:
>> - Validates once when the inode is read, rather than on every allocation
>> - Protects all code paths that use cl_bpc (allocation, resize, etc.)
>> - Follows the existing pattern of inode validation in OCFS2
>> - Centralizes validation logic
>>
>> The validation catches both:
>> - Zero values that cause divide-by-zero crashes
>> - Non-zero but incorrect values indicating filesystem corruption or
>>    mismatched filesystem geometry
>>
>> With this fix, mounting a corrupted filesystem produces:
>>
>>    OCFS2: ERROR (device loop0): ocfs2_validate_inode_block: Inode 74
>>           has corrupted cl_bpc: ondisk=0 expected=16
>>
>> instead of a kernel crash.
>>
>> Link: https://lore.kernel.org/ocfs2-devel/20251026132625.12348-1-kartikey406@gmail.com/T/#u [v1]
>> Link: https://lore.kernel.org/all/20251027124131.10002-1-kartikey406@gmail.com/T/ [v2]
>> Reported-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=fd8af97c7227fe605d95
>> Tested-by: syzbot+fd8af97c7227fe605d95@syzkaller.appspotmail.com
>> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
>> [dmantipov: combine into the series and tweak
>>   the message to fit the commonly used style]
>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> 
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>>   fs/ocfs2/inode.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
>> index 1b6bdd9d7755..efb930da0920 100644
>> --- a/fs/ocfs2/inode.c
>> +++ b/fs/ocfs2/inode.c
>> @@ -1505,6 +1505,8 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>>   
>>   	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
>>   		struct ocfs2_chain_list *cl = &di->id2.i_chain;
>> +		u16 bpc = 1 << (OCFS2_SB(sb)->s_clustersize_bits -
>> +				sb->s_blocksize_bits);
>>   
>>   		if (le16_to_cpu(cl->cl_count) != ocfs2_chain_recs_per_inode(sb)) {
>>   			rc = ocfs2_error(sb, "Invalid dinode %llu: chain list count %u\n",
>> @@ -1518,6 +1520,12 @@ int ocfs2_validate_inode_block(struct super_block *sb,
>>   					 le16_to_cpu(cl->cl_next_free_rec));
>>   			goto bail;
>>   		}
>> +		if (le16_to_cpu(cl->cl_bpc) != bpc) {
>> +			rc = ocfs2_error(sb, "Invalid dinode %llu: bits per cluster %u\n",
>> +					 (unsigned long long)bh->b_blocknr,
>> +					 le16_to_cpu(cl->cl_bpc));
>> +			goto bail;
>> +		}
>>   	}
>>   
>>   	rc = 0;

Oops. This seems prevents from mounting filesystems with any block size except 4k
(mkfs.ocfs2 -b 512, mkfs.ocfs2 -b 1024, mkfs.ocfs2 -b 2048) with the following message:

OCFS2: ERROR (device sdb): int ocfs2_validate_inode_block(struct super_block *, struct buffer_head *): Invalid dinode 23: bits per cluster 1

Dmitry

