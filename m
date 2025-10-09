Received: from out199-7.us.a.mail.aliyun.com (out199-7.us.a.mail.aliyun.com [47.90.199.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171FD222586
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Oct 2025 07:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996300; cv=none; b=p4NA3IiFiQTUk96v6NCxzcZ2IbPjQEpAzV9n3tlkTBbLVXNlaXnB53+WvZbnUykXHs2+QpiG8KvZ6D7Fe99ySXS4R9TfzPnp0LD1c/QAA+DPALxk8iyBCmwXHJ6NZ+gzpTSf+x3k2RFCt5xMVylvpMj5MaVvHsGmu012XGqGwe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996300; c=relaxed/simple;
	bh=xdqm3rAwt19B+hGcVpqeh422H1tC+ygsHyedyd0eJC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CzRSqTLVnW7COIwuRLHSTmgBqEEp515SDS79/MJFzR2Ap/Hk22Ujg3ONOsBzZ0U0N6/5i9ebBwOpfl+std5qWs0VVQGTGLoYQkIaFF+9JGeiQbZSFcaywBuko8OkVN4sT+tSVbmhFVt157zw+xPJXoSIuIcgAnWKMyPzsKkaxOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sIXM8J81; arc=none smtp.client-ip=47.90.199.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sIXM8J81"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759996284; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+2oq6GTx+LG0KCpVv09C41uef2RL9iyKIarR3zsVVNI=;
	b=sIXM8J81vAlCwdgqsGwoQwyOz7YlCgk2Yw8MQKubMaaIOt/jc5Wmvvxqfe1+h8aWZmlVm6y9XiFjO6ljTOfgxd8lhhPEYJcbkP/jMUlE4h09K3JIChdOZjhFHzH1kU3ynqOQ2/1ozK2MtPH0hwqImswLjA7wEDJN+Z2c3ikdTus=
Received: from 30.221.128.150(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WpkCYvV_1759996282 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 15:51:23 +0800
Message-ID: <6be1e189-b974-4666-add0-5b0fe7330fb3@linux.alibaba.com>
Date: Thu, 9 Oct 2025 15:51:22 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: add extra flags check in
 ocfs2_ioctl_move_extents()
To: Dmitry Antipov <dmantipov@yandex.ru>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+727d161855d11d81e411@syzkaller.appspotmail.com
References: <20251008112031.2369598-1-dmantipov@yandex.ru>
 <8df4d266-6e41-43fb-9412-5a2ccbcf0d96@linux.alibaba.com>
 <f35612bf-e1f7-4bf6-871d-a95f0127856c@yandex.ru>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <f35612bf-e1f7-4bf6-871d-a95f0127856c@yandex.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2025/10/9 14:39, Dmitry Antipov wrote:
> On 10/9/25 5:15 AM, Joseph Qi wrote:
> 
>> The check here looks fine.
>> Could you please elaborate more how it fixes the reported bug?
> 
> Ugh. This just catches the reproducer early, thus stopping it the way
> before the actual BUG() is triggered :-(.
> 

So you mean the reproducer passes OCFS2_MOVE_EXT_FL_COMPLETE through
ioctl and then trigger this BUG?

> According to fsck.ocfs2, the filesystem used by the reproducer in this
> particular case is totally broken and even fsck.ocfs2 is unable to
> repair it automatically:
> 
> fsck.ocfs2 1.8.8
> Checking OCFS2 filesystem in /dev/loop0:
>   Label:              <NONE>
>   UUID:               B1DE653C5FFC4D88B33B244AAB9EB3E9
>   Number of blocks:   16384
>   Block size:         512
>   Number of clusters: 1024
>   Cluster size:       8192
>   Number of slots:    1
> 
> /dev/loop0 was run with -f, check forced.
> Pass 0a: Checking cluster allocation chains
> [GROUP_FREE_BITS] Group descriptor at block 32 claims to have 427 free bits which is more than 420 bits indicated by the bitmap. Drop its free bit count down to the total? y
> [CHAIN_BITS] Chain 0 in allocator inode 71 has 427 bits marked free out of 1024 total bits but the block groups in the chain have 420 free out of 1024 total.  Fix this by updating the chain record? y
> [CHAIN_GROUP_BITS] Allocator inode 71 has 597 bits marked used out of 1024 total bits but the chains have 604 used out of 1024 total.  Fix this by updating the inode counts? y
> [CHAIN_I_SIZE] Allocator inode 71 has 1024 clusters represented in its allocator chain which accounts for 8388608 total bytes, but its i_size is 16777216. Fix this by updating i_size? y
> Pass 0b: Checking inode allocation chains
> [CHAIN_I_SIZE] Allocator inode 68 has 288 clusters represented in its allocator chain which accounts for 73728 total bytes, but its i_size is 147456. Fix this by updating i_size? y
> [CHAIN_HEAD_LINK_RANGE] Chain 0 in allocator inode 74 contains an initial block reference to 17056 which is out of range.  Clear this reference? y
> [CHAIN_BITS] Chain 0 in allocator inode 74 has 2046 bits marked free out of 2048 total bits but the block groups in the chain have 0 free out of 0 total.  Fix this by updating the chain record? y
> [CHAIN_EMPTY] Chain 0 in allocator inode 74 is empty.  Remove it from the chain record array in the inode and shift further chains into its place? y
> [CHAIN_GROUP_BITS] Allocator inode 74 has 2 bits marked used out of 2048 total bits but the chains have 0 used out of 0 total.  Fix this by updating the inode counts? y
> [CHAIN_I_CLUSTERS] Allocator inode 74 has 0 clusters represented in its allocator chains but has an i_clusters value of 64. Fix this by updating i_clusters? y
> [CHAIN_I_SIZE] Allocator inode 74 has 0 clusters represented in its allocator chain which accounts for 0 total bytes, but its i_size is 1048576. Fix this by updating i_size? y
> Pass 0c: Checking extent block allocation chains
> [CHAIN_I_SIZE] Allocator inode 73 has 0 clusters represented in its allocator chain which accounts for 0 total bytes, but its i_size is 90133. Fix this by updating i_size? y
> Pass 1: Checking inodes and blocks
> pass1: Internal logic failure while trying to set inode 65's allocation to '1'.  None of the slots chain allocator's had a group covering the inode.
> pass1: Internal logic failure while trying to set inode 66's allocation to '1'.  None of the slots chain allocator's had a group covering the inode.
> pass1: Internal logic failure while trying to set inode 67's allocation to '1'.  None of the slots chain allocator's had a group covering the inode.
> pass1: Internal logic failure while trying to set inode 68's allocation to '1'.  None of the slots chain allocator's had a group covering the inode.
> [EXTENT_BLKNO_RANGE] Extent record 0 in owner 69 refers to a block that is out of range.  Remove this record from the extent list? y
> [INODE_SPARSE_CLUSTERS] Inode 69 has 1 clusters but its blocks fit in 0 clusters. Correct the number of clusters? y
> pass1: Internal logic failure while trying to set inode 69's allocation to '1'.  None of the slots chain allocator's had a group covering the inode.
> ...
> [INODE_ALLOC_REPAIR] Inode 128 is marked as invalid but its position in the inode allocator is marked as in use.  Fix the allocation of this and all future inodes? y
> [CLUSTER_ALLOC_BIT] Cluster 3 is marked in the global cluster bitmap but it isn't in use.  Clear its bit in the bitmap? y
> ...
> Pass 2: Checking directory entries
> pass2: Bit does not exist in bitmap range while testing if inode 65 is allocated.  Continuing as though it is.
> pass2: Bit does not exist in bitmap range while testing if inode 65 is allocated.  Continuing as though it is.
> pass2: Bit does not exist in bitmap range while testing if inode 65 is allocated.  Continuing as though it is.
> [DIRENT_INODE_RANGE] Directory entry 'lost+found' refers to inode number 17057 which is out of range, clear the entry? y
> pass2: Bit does not exist in bitmap range while testing if inode 72 is allocated.  Continuing as though it is.
> [DIRENT_NOT_DOTTY] The first directory entry in directory inode 72 is '' instead of '.'.  Clobber the current name with the expected dot name? y
> pass2: Bit does not exist in bitmap range while testing if inode 72 is allocated.  Continuing as though it is.
> pass2: Bit does not exist in bitmap range while testing if inode 66 is allocated.  Continuing as though it is.
> pass2: Bit does not exist in bitmap range while testing if inode 66 is allocated.  Continuing as though it is.
> [DX_TREE_MISSING] Directory 66 is missing index. Rebuild? y
> ...
> pass2: Invalid block number while rebuild indexed dirs.
> fsck.ocfs2: Invalid block number while performing pass 2
> 
> (exited with status 8)
> 
> I assume that any attempt to modify anything on such a filesystem just makes
> the things even worse. So what about just relaxing BUG() to ocfs2_error(), i.e.
> 
> diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
> index 86f2631e6360..bf3f3f0f6eb5 100644
> --- a/fs/ocfs2/move_extents.c
> +++ b/fs/ocfs2/move_extents.c
> @@ -98,7 +98,13 @@ static int __ocfs2_move_extent(handle_t *handle,
> 
>         rec = &el->l_recs[index];
> 
> -       BUG_ON(ext_flags != rec->e_flags);
> +       if (ext_flags != rec->e_flags) {
> +               ret = ocfs2_error(inode->i_sb,
> +                                 "Inode %llu has corrupted extent %d at cpos %u\n",
> +                                 (unsigned long long)ino, index, cpos);
> +               goto out;
> +       }
> +

This looks more sane and seems directly fix the BUG.
BTW, we'd better also log the extent flags.

Thanks,
Joseph

>         /*
>          * after moving/defraging to new location, the extent is not going
>          * to be refcounted anymore.
> 
> Dmitry

