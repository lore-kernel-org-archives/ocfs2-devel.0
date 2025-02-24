Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224DA24C66A
	for <ocfs2-devel@lists.linux.dev>; Mon, 24 Feb 2025 10:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740394251; cv=none; b=JUqm4bXM1xgr97jqGNiG+uX6zexhgFMum1KRQHXsYOjMfjl6PGeAYxzaX+vDkE2Te2gZ5tMNTc5R2VTbC4j7qeEmk8s4c1VNNyJqD0/7FeVDLvIJJnQaSLK6yEsZ/7Q6SDjJkKk/v4RtHa2jJUA9CcUNSwVaScXaQwwTPcKA6+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740394251; c=relaxed/simple;
	bh=KcThmfRasS7DsZtTCpFem3O4eA8mIV14m1XVjXKnK34=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=AjzKMj2ldFNrfb66+IB1f/UGDdOVsYUgvoZNTR12b9+dGHrEUzd25uh8KNmuaD03a81eU0mXBzgar8VSHbQ985T/+KE3tJaza3EKgufq0OA++inTsrd59FKROfZTqxcYPVBW9h9dtb67P9he0WTycsx+gp/RtDZCmzsnXWx/Hco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn; spf=pass smtp.mailfrom=m.fudan.edu.cn; dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b=fyQ2Mdky; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b="fyQ2Mdky"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=m.fudan.edu.cn;
	s=sorc2401; t=1740394195;
	bh=Xz3JmGIEagQIhP0/n7iGFZZw2ou8Hp6f88+VhdnTQiM=;
	h=From:Mime-Version:Subject:Message-Id:Date:To;
	b=fyQ2Mdky+WwsQ3B11BXtPx7ywYPZrlyKUIX+23yGH8dSduA+M8z8kxNqENemhwYAn
	 dSgI32gpJrT7G4bEi8HhRgzVfXHUDSKeqNMzpteeAmFe1YPeyYthSSVJP6C2tNmxzW
	 07ci3rXpfoDHMjh0xjylD0W8e9eMsSRfPyTHbMho=
X-QQ-mid: bizesmtpip3t1740394189toi9olu
X-QQ-Originating-IP: ja77/5bQWOInVWrR6Coek+ao6hP0rhEbNhgqoFIcKds=
Received: from smtpclient.apple ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 24 Feb 2025 18:49:47 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 1852574584142837343
From: Kun Hu <huk23@m.fudan.edu.cn>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: KASAN: use-after-free Read in ocfs2_block_group_alloc
Message-Id: <B65ACC68-3450-434A-B428-5ADBD5CE8478@m.fudan.edu.cn>
Date: Mon, 24 Feb 2025 18:49:37 +0800
Cc: "jjtan24@m.fudan.edu.cn" <jjtan24@m.fudan.edu.cn>,
 baishuoran@hrbeu.edu.cn,
 syzkaller@googlegroups.com,
 ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
To: ark@fasheh.com,
 jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com
X-Mailer: Apple Mail (2.3818.100.11.1.3)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:m.fudan.edu.cn:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: M6x2tnEVru4exmE+tOQi6RE9yDcknxcGai0N21RNnTSPWSpmUX7ym38a
	ckQmzeztyRF5uqj520AHlh77C4bk2AM/kcZ+oisCLrHBxm6yrFpG+A44C6Jo3bSEF7UNIRN
	Nm3UFnuYZHBlV6ZA90jP8WHOqollicQ/6SyEI0HcZ07iMX8MBgLos9QN/ft6LT78p8fiejy
	yTeC798sORb0hWs/kiWQ3prBfZvJO9FSxt7zkJY5CimmJRTPZHSfc8tX8Reazss/LS33pn7
	93sVNDQ/LwXkU/BStQkw2NhghP1P+PnMlGzrpA1oFbx83SHT4rDTxiMixRaamicuLmB1lnk
	Gd7JYY8gOl5fJip4oZmbey4tt70t53iXPP7tdlr6DOw+03FwCsRcD/RyRqIGRxpHU5m3E5y
	6RLxt2EVJrX0YgYIZLIdYoQKPIl0aYXegmqnppUlRSomF4BrgSRkTX7XkHxIhpC0Okk+6/N
	yHSt4/kWP8Yx7u5rEIarwAgT+VOEIn/EFyw+SkexzcIrAA2dzXyDncULrPfIooN90geDXJ0
	pFnILUdTvT7FPaCpql3PO78SkutD2QkW4gcxAnb2FFpXjNH6GJD8df88N/OJBMmtPMgoiVT
	5OVQS9nA8/GoQoHhB+WQBZ5x0KghD/RF97YnzB+xnAcNAvJi8tC8tGTK1yZMZdbA5AbIpi2
	FGUe+f+Aa6aiszWZOg8P+9R4niz4GZ2Sfu1CRQvVcIPAd3Ke+5VjOSQrSbYYQunFnqjNzW7
	uO4ToJ0oI74R4h2q/A8XXuxYSnoPhf71VTyPCF+M2gTqryY0LAsUGESsQu9YYMMQ9PSV1tm
	+Wu63KVXbf30/niAiDv1SGKnd/9J5AdoZJ2G6pYbYQAk5LnAjl9u6Xu5yP1yYS05+Ulka9z
	BubnHtVmXFuAqqDK1r4XxvoU4Tbb3A+KjVJDzlVFJxWaBUApF4ydvjSS2oY0iCmRTK23KxT
	/Zxjbc8SYL48IYJe7K8mrfBeuaSUbtWvoKfEnaJLBArW6pw==
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

Dear Maintainers,

When using our customized Syzkaller to fuzz the latest Linux kernel, the =
following crash (65th)
was triggered.

HEAD commit: 6537cfb395f352782918d8ee7b7f10ba2cc3cbf2
git tree: upstream
Output: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/65-KASAN_=
%20slab-out-of-bounds%20Read%20in%20ocfs2_block_group_alloc/output%20on%20=
6.14-rc3.txt
Kernel config: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/config.tx=
t
C reproducer: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/65-KASAN_=
%20slab-out-of-bounds%20Read%20in%20ocfs2_block_group_alloc/c-repro.c
Syzlang reproducer: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/65-KASAN_=
%20slab-out-of-bounds%20Read%20in%20ocfs2_block_group_alloc/syscall_repro.=
syz.txt

Our reproducer uses mounts a constructed filesystem image. This issue =
seems to be related to the reuse of the bg_bh release, not sure if it's =
a failure to allocate the bg_bh and then a jump to the bail tab. We have =
reproduced this issue several times on 6.14-rc3 again, but we don't have =
too much knowledge about this area, could we trouble you to check the =
root cause.

If this issue doesn't have an impact, please ignore it =E2=98=BA.

If you fix this issue, please add the following tag to the commit:
Reported-by: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin =
<jjtan24@m.fudan.edu.cn>, Shuoran Bai <baishuoran@hrbeu.edu.cn>

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in ocfs2_block_group_alloc+0x1c9a/0x1ed0
Read of size 4 at addr ffff88802ad06004 by task syz-executor229/9523

CPU: 3 UID: 0 PID: 9523 Comm: syz-executor229 Not tainted 6.14.0-rc3 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x116/0x1b0
 print_report+0xc0/0x5e0
 kasan_report+0x93/0xc0
 ocfs2_block_group_alloc+0x1c9a/0x1ed0
 ocfs2_reserve_suballoc_bits+0x3c3/0xe60
 ocfs2_reserve_new_metadata_blocks+0x60a/0xa60
 ocfs2_expand_inline_dir+0x18fc/0x4210
 ocfs2_extend_dir+0x1c2/0x1ca0
 ocfs2_prepare_dir_for_insert+0xce9/0x18f0
 ocfs2_mknod+0x92a/0x2540
 ocfs2_create+0x105/0x490
 vfs_create+0x4df/0x7a0
 do_mknodat+0x3e9/0x540
 __x64_sys_mknod+0x87/0xb0
 do_syscall_64+0xcf/0x250
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1415cec08d
Code: c3 e8 17 2c 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 =
f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd6629ce58 EFLAGS: 00000246 ORIG_RAX: 0000000000000085
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1415cec08d
RDX: 0000000000000700 RSI: 0000000000000000 RDI: 0000000020001100
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: 00007ffd6629cd10 R11: 0000000000000246 R12: 00007ffd6629ce6c
R13: 00007ffd6629ce70 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x55847fd84 =
pfn:0x2ad06
flags: 0xfff00000000000(node=3D0|zone=3D1|lastcpupid=3D0x7ff)
page_type: f0(buddy)
raw: 00fff00000000000 ffffea0000a97b08 ffffea0000a96088 0000000000000000
raw: 000000055847fd84 0000000000000000 00000000f0000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Movable, gfp_mask =
0x140dca(GFP_HIGHUSER_MOVABLE|__GFP_COMP|__GFP_ZERO), pid 9508, tgid =
9508 (sshd), ts 641255298406, free_ts 641853904239
 prep_new_page+0x1b0/0x1e0
 get_page_from_freelist+0x19a2/0x3250
 __alloc_frozen_pages_noprof+0x324/0x6b0
 alloc_pages_mpol+0x20a/0x550
 folio_alloc_mpol_noprof+0x38/0x2f0
 vma_alloc_folio_noprof+0xe4/0x1a0
 do_pte_missing+0x13b9/0x3d70
 __handle_mm_fault+0xf6b/0x2a90
 handle_mm_fault+0x403/0xe00
 do_user_addr_fault+0x77e/0x1910
 exc_page_fault+0x98/0x170
 asm_exc_page_fault+0x26/0x30
page last free pid 9508 tgid 9508 stack trace:
 free_unref_folios+0xa87/0x1730
 folios_put_refs+0x4bd/0x760
 free_pages_and_swap_cache+0x23b/0x460
 tlb_flush_mmu+0x168/0x750
 tlb_finish_mmu+0x97/0x3c0
 exit_mmap+0x427/0xbf0
 mmput+0x178/0x450
 do_exit+0x94b/0x3080
 do_group_exit+0xd3/0x2a0
 __x64_sys_exit_group+0x3e/0x50
 x64_sys_call+0xf6a/0x1890
 do_syscall_64+0xcf/0x250
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88802ad05f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88802ad05f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88802ad06000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff88802ad06080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88802ad06100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

---------------
thanks,
Kun Hu=
