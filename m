Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DB22F1FD0
	for <ocfs2-devel@lists.linux.dev>; Fri, 23 Jan 2026 08:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769157537; cv=none; b=bJIHrBCu2bV9jci16Wg/+kW08EcmMRvusa69NQw2YrorxnLyhqZVimeDszysWEWmDrHFOD6Tv/btcDgUCwcc7TCTLSvcnRGQU36/x/CgMmcn5Fah0HVvteN8BiKGLStGlbzQhx8aP521Zy/2/C+fVixbD1ChLXZXZYleDh4TZU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769157537; c=relaxed/simple;
	bh=qu0YJGcTZdMm5ub/lb4myq/b4zDZDh/D0sKxRt+19sg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qcxoMscDMaGeKJug6w6GTzxRe1TWxhACiq2DWcaZd37UXNfAghAuIbFRCPwMGmb3ZJH51CZE7MR5cLdY0O9AbnEYww4O7wTFEBu3DClhgRJrkayQoZitPbMdqxTEfYpdJDfmbOGwb6+wNPEa+a7OxuGJzcJ2cIsMPexzKwLHn4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=k8BgtZ6c; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="k8BgtZ6c"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769157533; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2SL3xKhdMJFaTR/WdofbDvkRCLwCXFo1cMT2fz+c0H0=;
	b=k8BgtZ6cZ3KPe//vyyFAEVy5YmMLSI82lH4fiE6Q3Gk9Ldw1woObJN1HBRutK2tfhF+3M65sejY+Akr6u0qcvVeo2RDPAIqP78O+YTkKMHsJyMdpXmHOXLdKMUDshNXDHMQ7algy2+UfNrFnl23WKaK/vgygwVPmUnAFyzSOBOo=
Received: from 30.221.129.78(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WxfFWHR_1769157531 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 16:38:52 +0800
Message-ID: <d682ccc8-775c-49e2-a075-cee42d96d592@linux.alibaba.com>
Date: Fri, 23 Jan 2026 16:38:51 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: validate allocator type to prevent BUG_ON in
 ocfs2_block_group_search
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>
References: <20260110054443.604944-1-kartikey406@gmail.com>
 <CADhLXY6Dojpckbkq7Dk_T7BrHML9_AAscJ+xKt3aPiV9v1V73w@mail.gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <CADhLXY6Dojpckbkq7Dk_T7BrHML9_AAscJ+xKt3aPiV9v1V73w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/23/26 2:23 PM, Deepanshu Kartikey wrote:
> On Sat, Jan 10, 2026 at 11:14 AM Deepanshu Kartikey
> <kartikey406@gmail.com> wrote:
>>
>> ocfs2_is_cluster_bitmap() checks whether an inode is the global bitmap
>> by comparing ip_blkno with osb->bitmap_blkno. A corrupted filesystem
>> can have either the superblock's bitmap_blkno field corrupted to point
>> to the inode allocator block, or the inode allocator's i_blkno field
>> corrupted to match bitmap_blkno. In either case, ocfs2_is_cluster_bitmap()
>> returns true for the inode allocator.
>>
>> When the code later calls ocfs2_block_group_search(), it triggers
>> BUG_ON(ocfs2_is_cluster_bitmap(inode)) causing a kernel panic.
>>
>> Call trace:
>>   ocfs2_block_group_search+0x1c7/0x2c0 fs/ocfs2/suballoc.c:1611
>>   ocfs2_search_chain+0x38a/0x1010 fs/ocfs2/suballoc.c:1764
>>   ocfs2_claim_suballoc_bits+0x3a4/0x650 fs/ocfs2/suballoc.c:1978
>>   ocfs2_claim_new_inode+0x95/0x130 fs/ocfs2/suballoc.c:2137
>>   ocfs2_mknod_locked+0x129/0x510 fs/ocfs2/namei.c:568
>>   ocfs2_mknod+0x5c7/0x11d0 fs/ocfs2/namei.c:802
>>   ocfs2_create+0x136/0x170 fs/ocfs2/namei.c:852
>>
>> Add validation in ocfs2_reserve_suballoc_bits() to check that the
>> allocator inode type matches the expected type:
>> - Global bitmap allocator must be the cluster bitmap
>> - Other allocators (inode, extent) must NOT be the cluster bitmap
>>
>> This follows the existing pattern of validating OCFS2_CHAIN_FL in the
>> same function and uses ocfs2_error() for graceful error handling.
>>
>> Reported-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=44c564a3cb08605f34a1
>> Tested-by: syzbot+44c564a3cb08605f34a1@syzkaller.appspotmail.com
>> Link: https://lore.kernel.org/all/20260104014028.305029-1-kartikey406@gmail.com/T/ [v1]
>> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
>> ---
>> v2: Fix commit message - ocfs2_is_cluster_bitmap() checks ip_blkno
>>     against bitmap_blkno, not a flag (Joseph Qi)
>> ---
>>  fs/ocfs2/suballoc.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
>> index 8e6e5235b30c..fb72c062a8d5 100644
>> --- a/fs/ocfs2/suballoc.c
>> +++ b/fs/ocfs2/suballoc.c
>> @@ -813,6 +813,26 @@ static int ocfs2_reserve_suballoc_bits(struct ocfs2_super *osb,
>>                 goto bail;
>>         }
>>
>> +       /*
>> +        * Validate allocator type matches expected bitmap type.
>> +        * Global bitmap must have BITMAP flag, other allocators must not.
>> +        * This prevents a corrupted filesystem from triggering BUG_ON
>> +        * in ocfs2_block_group_search() or ocfs2_cluster_group_search().
>> +        */
>> +       if (type == GLOBAL_BITMAP_SYSTEM_INODE) {
>> +               if (!ocfs2_is_cluster_bitmap(alloc_inode)) {
>> +                       status = ocfs2_error(alloc_inode->i_sb,
>> +                                            "Global bitmap %llu missing bitmap flag\n",
>> +                                            (unsigned long long)le64_to_cpu(fe->i_blkno));
>> +                       goto bail;
>> +               }
>> +       } else if (ocfs2_is_cluster_bitmap(alloc_inode)) {
>> +               status = ocfs2_error(alloc_inode->i_sb,
>> +                                    "Allocator %llu has invalid bitmap flag\n",
>> +                                    (unsigned long long)le64_to_cpu(fe->i_blkno));
>> +               goto bail;
>> +       }
>> +
>>         free_bits = le32_to_cpu(fe->id1.bitmap1.i_total) -
>>                 le32_to_cpu(fe->id1.bitmap1.i_used);
>>
>> --
>> 2.43.0
>>
> 
> 
> Hi Joseph,
> 
> Just wanted to follow up on this patch. Do you have any further
> comments or suggestions?
> 
Hi，since the inode block is read from disk, it seems we'd better
validate it in ocfs2_validate_inode_block().

Thanks,
Joseph

