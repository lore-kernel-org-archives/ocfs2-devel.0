Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36BF143C5D
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Oct 2024 06:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728887646; cv=none; b=py03gZFyHA8ghBis1xoUrn6NvxIHQn0EnMydGuSKgGGchhal+QvPC91CfEsE3zKzIWYUWqAMz+ddbelWicDbpIgXC1O7WGkfl4R+jNmxFMjvDO4Md0zqxu1zi6c+33ofqCZvewAFmjglCzPahOzQx3gsL1t6galS5M0DltHX9zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728887646; c=relaxed/simple;
	bh=vI6zfZOAnEVuWkZk+6GqCLQDFURf4rfFVzjuwaY+aRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oP3t3M17BeYGn7L5XlE6k17TGL4DOUOZiQ4Sj3isT1vmw9K56pDXMDds7keFbNdTUedCAfct2Pgf/1Gd9pb8ISi6d5M5/98pBHw14ighemtFQnkRIhVu1ZWH/4xHFXUTmN7cIyIDMeFYRMxKzz9ipao3VS/bIz0/rlTPJUGQMFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gU4/39Uk; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gU4/39Uk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1728887636; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9iTqTFZay+eh5uh2AMI2uElpAwer6VJtK6rahZrN4AE=;
	b=gU4/39UkF6tCrCMDNyOtAv+55p8G6pbNycKljLeYVeHBEU7PAZp+Xb6KFs23Wl0Lbyjpa7ywaHKT2aHtBwHW4Q4TJTte/CajMQNNnbgFndNGEKfDqMqdyFHWI6r9kvl+7eX22lIT4Ak6Kv3ecHg9YSbycw3BvuWi0RvgOlpMRZY=
Received: from 30.221.132.11(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WH10Xau_1728887635 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Oct 2024 14:33:55 +0800
Message-ID: <431f1d14-ba07-4903-ab02-b4628e0f1973@linux.alibaba.com>
Date: Mon, 14 Oct 2024 14:33:54 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] ocfs2: BUG is meaningless when the flags is 0
To: Edward Adam Davis <eadavis@qq.com>
Cc: jlbec@evilplan.org, linux-kernel@vger.kernel.org, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev,
 syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <tencent_10694B411BC625A4BA1BBB8033959EA31B08@qq.com>
 <tencent_9D4C78EA6D442CB56C2C97D4EB8EEC26CC0A@qq.com>
Content-Language: en-US
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <tencent_9D4C78EA6D442CB56C2C97D4EB8EEC26CC0A@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/14/24 7:31 AM, Edward Adam Davis wrote:
> Syzbot reported a BUG in ocfs2_read_virt_blocks.
> ------------[ cut here ]------------
> kernel BUG at fs/ocfs2/extent_map.c:971!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5221 Comm: syz-executor117 Not tainted 6.12.0-rc2-syzkaller-00006-g87d6aab2389e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> RIP: 0010:ocfs2_read_virt_blocks+0xaa3/0xb20 fs/ocfs2/extent_map.c:971
> Code: 8b 54 24 30 8b 4c 24 1c 4c 8b 44 24 38 45 89 e1 ff 74 24 48 e8 7e 0a 0c 00 48 83 c4 08 eb 25 e8 43 d2 34 08 e8 ee d1 0c fe 90 <0f> 0b e8 e6 d1 0c fe 4c 89 e8 45 89 e5 49 89 c4 e9 01 f7 ff ff e8
> RSP: 0018:ffffc90002e2e820 EFLAGS: 00010293
> RAX: ffffffff83881432 RBX: 0000000000000000 RCX: ffff88802d3e9e00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90002e2e9f0 R08: ffffffff83880eae R09: 1ffffffff203781d
> R10: dffffc0000000000 R11: fffffbfff203781e R12: ffff8880764d8878
> R13: 0000000000000000 R14: 0000000000000000 R15: 1ffff920005c5d18
> FS:  000055557cd55380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005628fd41e058 CR3: 000000002d2e6000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  ocfs2_read_dir_block+0x106/0x5c0 fs/ocfs2/dir.c:508
>  ocfs2_find_dir_space_el fs/ocfs2/dir.c:3427 [inline]           // status = ocfs2_read_dir_block(dir, 0, &bh, 0);

Keep the original stacks is enough.

>  ocfs2_prepare_dir_for_insert+0x3f2/0x5c60 fs/ocfs2/dir.c:4274
>  ocfs2_mknod+0xcaf/0x2b40 fs/ocfs2/namei.c:292
>  ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
>  lookup_open fs/namei.c:3595 [inline]
>  open_last_lookups fs/namei.c:3694 [inline]
>  path_openat+0x1c03/0x3590 fs/namei.c:3930
>  do_filp_open+0x235/0x490 fs/namei.c:3960
>  do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
>  do_sys_open fs/open.c:1430 [inline]
>  __do_sys_openat fs/open.c:1446 [inline]
>  __se_sys_openat fs/open.c:1441 [inline]
>  __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> It is because the parameter v_block passed to ocfs2_read_virt_blocks() is 0,
> nr is 1, and inode->i_size is 0, and flags are also 0.
> In this path, v_block, flags, and nr are fixed values that are hard coded,
> so if i_size is 0, the bug will be triggered.
> Therefore, it is more meaningful to check if the flags contain the READHEAD
> bit when their value is non-zero.
> 
> Reported-and-tested-by: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=797d4829dafe3f11dce7
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> V1 -> V2: keep rc to 0 when falgs contains READHEAD
> 
>  fs/ocfs2/extent_map.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
> index f7672472fa82..0043c2428ef2 100644
> --- a/fs/ocfs2/extent_map.c
> +++ b/fs/ocfs2/extent_map.c
> @@ -968,7 +968,8 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
>  
>  	if (((v_block + nr - 1) << inode->i_sb->s_blocksize_bits) >=
>  	    i_size_read(inode)) {
> -		BUG_ON(!(flags & OCFS2_BH_READAHEAD));
> +		BUG_ON(flags && !(flags & OCFS2_BH_READAHEAD));

I don't think this is a right fix.
As you described in commit log, I think the root cause is the inode size
is 0, which mean no blocks actually.
So it seems we have to add a sanity check for this case.

Thanks,
Joseph

> +		rc = flags ? 0 : -EIO;
>  		goto out;
>  	}
>  

