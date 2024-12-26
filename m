Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B1715B111;
	Thu, 26 Dec 2024 22:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735251568; cv=none; b=quIidNjGgdtB00pWzbYupGVsViewWEY2D1C1xffRHPcKVsc5yKyC9i39nVg4dCpJt4RqfY2v3bxXVfYvbwj9yaDzaBe/FIu3IsH+vXQjiNAMWG34x4mMYhRj2q0lcMkkWbvdQXce7BCZFPz1sqJ4G+xZ7phnN6RdHAcpgdCdtlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735251568; c=relaxed/simple;
	bh=HoHZ3WA83t5UAq9A/Ewrf3E5kPY12CDvg+sGOsDq1Xs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=MNtuVJyFdc+lwy1FY7ChCYn8tCDh9N4Td5/V8Kle0h2eWJeVoCvCcR0f/OgsnrEkFA1iZ8MmUPL9l2EEdpuOxj6iBC5ccsBLOWDhnsuGaFxHVj77qWLevVOyMVcmEv6UVv5GucVOUaphM6/0X6fqrIS2RzqDHvDbJxyioA8hXBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=19CPy+bG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="19CPy+bG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7ABC4CED1;
	Thu, 26 Dec 2024 22:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735251568;
	bh=HoHZ3WA83t5UAq9A/Ewrf3E5kPY12CDvg+sGOsDq1Xs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=19CPy+bGXq4G+QiRBoWg8vdK/JAG/sU3RLgZTMiQYufq2eF5K2NaOyPGGshkjxdTw
	 m/qNhhpeXVQ1wQQozKPTq3ZjXWm501Uvqc+Oc3Uae4VjnLYysuiY9VsCaHpYmlRw81
	 p6k7g87g5aa6eCanHa/TvnX15gPvl7pALy37oZ5k=
Date: Thu, 26 Dec 2024 14:19:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kun Hu <huk23@m.fudan.edu.cn>
Cc: yury.norov@gmail.com, linux@rasmusvillemoes.dk, pabeni@redhat.com,
 jacob.e.keller@intel.com, linux-kernel@vger.kernel.org,
 "jjtan24@m.fudan.edu.cn" <jjtan24@m.fudan.edu.cn>,
 ocfs2-devel@lists.linux.dev
Subject: Re: Bug: use-after-free in __bitmap_weight
Message-Id: <20241226141927.766513a025a87b5fd1126fa3@linux-foundation.org>
In-Reply-To: <630B5C8C-5C8A-4BFB-9FB0-A63CDB200629@m.fudan.edu.cn>
References: <630B5C8C-5C8A-4BFB-9FB0-A63CDB200629@m.fudan.edu.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 24 Dec 2024 19:37:29 +0800 Kun Hu <huk23@m.fudan.edu.cn> wrote:

> Hello,
> 
> When using fuzzer tool to fuzz the latest Linux kernel, the following crash
> was triggered.

Thanks.  Let's cc the ocfs2 list.

> HEAD commit: 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
> git tree: upstream
> Console output: https://drive.google.com/file/d/1CJ3VaQxlqkGdcEitM_aoSuzeCpfUWrAi/view?usp=sharing
> Kernel config: https://drive.google.com/file/d/1RhT5dFTs6Vx1U71PbpenN7TPtnPoa3NI/view?usp=sharing
> C reproducer: /
> Syzlang reproducer: /
> 
> 
> Unfortunately, we're getting a stable reproduction of the program. If you fix this issue, please add the following tag to the commit:
> Reported-by: Kun Hu <huk23@m.fudan.edu.cn>
> 
> (syz.0.394,3922,2):ocfs2_mknod:298 ERROR: status = -2
> (syz.0.394,3922,2):ocfs2_mknod:502 ERROR: status = -2
> (syz.0.394,3922,2):ocfs2_create:676 ERROR: status = -2
> ==================================================================
> BUG: KASAN: use-after-free in __bitmap_weight+0xf9/0x110 lib/bitmap.c:340
> Read of size 8 at addr ff11000056367000 by task syz.0.394/3922
> 
> CPU: 2 UID: 0 PID: 3922 Comm: syz.0.394 Not tainted 6.13.0-rc3 #5
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x116/0x1b0 lib/dump_stack.c:120
> print_address_description mm/kasan/report.c:378 [inline]
> print_report+0xcf/0x5f0 mm/kasan/report.c:489
> kasan_report+0x93/0xc0 mm/kasan/report.c:602
> __bitmap_weight+0xf9/0x110 lib/bitmap.c:340
> bitmap_weight include/linux/bitmap.h:446 [inline]
> memweight+0x120/0x1c0 lib/memweight.c:24
> ocfs2_local_alloc_count_bits fs/ocfs2/localalloc.c:817 [inline]
> ocfs2_reserve_local_alloc_bits+0x3e1/0x10a0 fs/ocfs2/localalloc.c:655
> ocfs2_reserve_clusters_with_limit+0x7eb/0xcd0 fs/ocfs2/suballoc.c:1166
> ocfs2_reserve_clusters fs/ocfs2/suballoc.c:1227 [inline]
> ocfs2_lock_allocators+0x351/0x610 fs/ocfs2/suballoc.c:2746
> ocfs2_extend_allocation+0x274/0x17d0 fs/ocfs2/file.c:589
> ocfs2_allocate_unwritten_extents+0x22c/0x740 fs/ocfs2/file.c:1496
> __ocfs2_change_file_space+0xba0/0x1090 fs/ocfs2/file.c:2023
> ocfs2_fallocate+0x271/0x300 fs/ocfs2/file.c:2138
> vfs_fallocate+0x49d/0xeb0 fs/open.c:327
> ksys_fallocate+0x55/0xa0 fs/open.c:351
> __do_sys_fallocate fs/open.c:356 [inline]
> __se_sys_fallocate fs/open.c:354 [inline]
> __x64_sys_fallocate+0x97/0x100 fs/open.c:354
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9d68c8d71d
> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f9d678bfba8 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
> RAX: ffffffffffffffda RBX: 00007f9d68e50058 RCX: 00007f9d68c8d71d
> RDX: 00000000000000fa RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f9d68d02425 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000ffff R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9d68e50064 R14: 00007f9d68e500f0 R15: 00007f9d678bfd40
> </TASK>
> 
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f pfn:0x56367
> flags: 0x100000000000000(node=0|zone=1)
> raw: 0100000000000000 ffd4000001221708 ffd40000012ea688 0000000000000000
> raw: 000000000000007f 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
> ff11000056366f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ff11000056366f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ff11000056367000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ^
> ff11000056367080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ff11000056367100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ==================================================================
> OCFS2: ERROR (device loop0): ocfs2_reserve_local_alloc_bits: local alloc inode 10712166395476743305 says it has 2419393108 used bits, but a count shows 145657
> On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
> OCFS2: Returning error to the calling process.
> (syz.0.394,3922,2):ocfs2_reserve_local_alloc_bits:710 ERROR: status = -5
> (syz.0.394,3922,2):ocfs2_reserve_clusters_with_limit:1170 ERROR: status = -5
> (syz.0.394,3922,2):ocfs2_reserve_clusters_with_limit:1219 ERROR: status = -5
> (syz.0.394,3922,2):ocfs2_lock_allocators:2749 ERROR: status = -5
> (syz.0.394,3922,2):ocfs2_extend_allocation:592 ERROR: status = -5
> (syz.0.394,3922,2):ocfs2_allocate_unwritten_extents:1499 ERROR: status = -5
> (syz.0.394,3922,2):__ocfs2_change_file_space:2045 ERROR: status = -5
> 
> 
> ---------------
> thanks,
> Kun Hu
