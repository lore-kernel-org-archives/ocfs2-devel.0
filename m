Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939002E40E
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Jan 2025 03:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308343; cv=none; b=g1wPVZEjTi8SUtS6CQ28Pt7B0UJwQCq9q+HErU+SuqDHCXTAqU/STsP7dFFOcquRaLpXjbwYiFiGw/tF/B8wkEiclCqEgbAsQUoDoZvk5qnZ9DjqS4hYUEbACimHcpp3LU+vUAa0QfWNTTm3dFsEP3XEYndyLQf2tO6uT7QxmMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308343; c=relaxed/simple;
	bh=wSWMhyjJI36YIXQGNJzXAcxILhEQcIHAPK85yT0rgqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kg2LieO2VxliniSszg2tGjwRjj7uJOuSfd1qvrMsw/wWxbAemkb5+m8AuYzOiZP47ZuSwDmHWgCguyS+PZqd7Bf8G3q1+tx8Kte/HvhduI2WH7JGc5f9Qy07NC7izaHYXpJBgsFHc2M5Kg1poq1NqIn+ewJSAktFdUMzHawY66U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VOEjwDbb; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VOEjwDbb"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736308329; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gx8gPAjJhXosA2s+dVxGho2tZunPM/tNU3bzjX4JpM4=;
	b=VOEjwDbbZfvYy3YY8JjZrPR6Q3p8CPdh6+ZfSIG4ZjCj2Ethm9aeAbwzLnkUpKerZ68h5ZBbr9N3B9L0BjJc5M8kwY4Y+K1CJVr6OTJ0J//pNIq3bCKXaoNvTSgkvOFFaR/aryK0+GCUHwTxP8nJ8L6lj74Zj0QexOLAWFRh3dY=
Received: from 30.221.128.151(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WNCQM6R_1736308328 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 08 Jan 2025 11:52:09 +0800
Message-ID: <b71d012c-3716-49cd-ab9b-902b8e1b508b@linux.alibaba.com>
Date: Wed, 8 Jan 2025 11:52:07 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: check tl->count of truncate log inode in
 ocfs2_get_truncate_log_info
To: Su Yue <glass.su@suse.com>, akpm <akpm@linux-foundation.org>
Cc: Liebes Wang <wanghaichi0403@gmail.com>,
 syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com,
 "ocfs2-devel@lists.linux.dev" <ocfs2-devel@lists.linux.dev>
References: <20250108024119.60313-1-glass.su@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20250108024119.60313-1-glass.su@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/1/8 10:41, Su Yue wrote:
> syz reported:
> 
> (syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: bug
> expression: tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
> tl_count == 0
> (syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: Truncate
> record count on #77 invalid wanted 39, actual 2087
> ------------[ cut here  ]------------
> kernel BUG at fs/ocfs2/alloc.c:5874!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5313 Comm: syz-executor404 Not tainted
> 6.12.0-rc5-syzkaller-00299-g11066801dd4b #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
> RSP: 0018:ffffc9000cf16f40 EFLAGS: 00010292
> RAX: b4b54f1d10640800 RBX: 0000000000000027 RCX: b4b54f1d10640800
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc9000cf17070 R08: ffffffff8174a14c R09: 1ffff11003f8519a
> R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff110085f5f58
> R13: ffffff3800000000 R14: 000000000000004d R15: ffff8880438f0008
> FS:  00005555722df380(0000) GS:ffff88801fc00000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000002000f000 CR3: 000000004010e000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> ocfs2_remove_btree_range+0x1303/0x1860 fs/ocfs2/alloc.c:5789
> ocfs2_remove_inode_range+0xff3/0x29f0 fs/ocfs2/file.c:1907
> ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4537 [inline]
> ocfs2_reflink_remap_blocks+0xcd4/0x1f30 fs/ocfs2/refcounttree.c:4684
> ocfs2_remap_file_range+0x5fa/0x8d0 fs/ocfs2/file.c:2736
> vfs_copy_file_range+0xc07/0x1510 fs/read_write.c:1615
> __do_sys_copy_file_range fs/read_write.c:1705 [inline]
> __se_sys_copy_file_range+0x3f2/0x5d0 fs/read_write.c:1668
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd327167af9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89
> f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
> f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe6b8e22e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
> RAX: ffffffffffffffda RBX: 00007fd3271b005e RCX: 00007fd327167af9
> RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007fd3271de610 R08: 000000000000d8c2 R09: 0000000000000000
> R10: 0000000020000640 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007ffe6b8e24b8 R14: 0000000000000001 R15: 0000000000000001
> </TASK>
> 
> The fuzz image has a truncate log inode whose tl_count is bigger
> than ocfs2_truncate_recs_per_inode() so it triggers the BUG in
> ocfs2_truncate_log_append().
> 
> As what the check in ocfs2_truncate_log_append() does, just do same
> check into  ocfs2_get_truncate_log_info when truncate log inode is
> reading in so we can bail out earlier.
> 
> Reported-by: Liebes Wang <wanghaichi0403@gmail.com>
> Link: https://lore.kernel.org/ocfs2-devel/CADCV8souQhdP0RdQF1U7KTWtuHDfpn+3LnTt-EEuMmB-pMRrgQ@mail.gmail.com/T/#u
> Reported-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
> Tested-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com
> Signed-off-by: Su Yue <glass.su@suse.com>

Looks good.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
> Changelog:
> v2:
>     Add the missing brelse(bh). (Joseph Qi)
> ---
>  fs/ocfs2/alloc.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
> index 395e23920632..2a6e3588897d 100644
> --- a/fs/ocfs2/alloc.c
> +++ b/fs/ocfs2/alloc.c
> @@ -6154,6 +6154,9 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
>  	int status;
>  	struct inode *inode = NULL;
>  	struct buffer_head *bh = NULL;
> +	struct ocfs2_dinode *di;
> +	struct ocfs2_truncate_log *tl;
> +	unsigned int tl_count;
>  
>  	inode = ocfs2_get_system_file_inode(osb,
>  					   TRUNCATE_LOG_SYSTEM_INODE,
> @@ -6171,6 +6174,18 @@ static int ocfs2_get_truncate_log_info(struct ocfs2_super *osb,
>  		goto bail;
>  	}
>  
> +	di = (struct ocfs2_dinode *)bh->b_data;
> +	tl = &di->id2.i_dealloc;
> +	tl_count = le16_to_cpu(tl->tl_count);
> +	if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
> +		     tl_count == 0)) {
> +		status = -EFSCORRUPTED;
> +		iput(inode);
> +		brelse(bh);
> +		mlog_errno(status);
> +		goto bail;
> +	}
> +
>  	*tl_inode = inode;
>  	*tl_bh    = bh;
>  bail:

