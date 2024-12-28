Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E3526AF3
	for <ocfs2-devel@lists.linux.dev>; Sat, 28 Dec 2024 08:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735373664; cv=none; b=HPgZKp/j8whwVm/HDjqrLMiqqFQlsg3TGtvPMC7rb765hc08R4lHl1EEmM4u493CMb6Nr9RNT7MGGkL7OBZdqeKoCTDY98TVoQ2ElSypubzYWNxPX/0xqNS1Zff2nDGOSD8947W3Pi3Wz058WXukh9jeiYkM/lRZIQReT5ViFMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735373664; c=relaxed/simple;
	bh=X6KIHIEwMziJ8eeSgPQ9YaxHMqqtbcaYBcgbugCsVQg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=vAvGLWphlRQoZ9SgtO8LPjwQrBYdiL1QdtlBaH9QYJnbl8yhZcH57HZwKwE2E2ymkmG0ohTx0AiKzbeygLPjLa5CXOlJhxpPaWASWUzwjC0A0EHmQoO7sUcgpyvpze5x1GXbCu2WCD7a9M9njReqs2JXUz+Y4wOM1uJSMvk4UxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn; spf=pass smtp.mailfrom=m.fudan.edu.cn; dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b=uqu9AKWK; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b="uqu9AKWK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=m.fudan.edu.cn;
	s=sorc2401; t=1735373622;
	bh=krvb6hTfUfIHnxzcUB4dSxLlaR7TPom8+j9e+PoI3uU=;
	h=Mime-Version:Subject:From:Date:Message-Id:To;
	b=uqu9AKWKmuZEKwwJuLUCHoX3NRa0sK4HrqQ69riUGZl30Gii7fSB2MbZwRu+t0CAb
	 bWVT0z2ZMhTg+Gbhr/lUIIfOJPkVVTTL8yu2JMKbd2jvObFlfEStCiexMqmIZLBNxq
	 32fm6KbS9yMP9c3ZS7bRUYICVb/Q/kxKpleQ7TYo=
X-QQ-mid: bizesmtpsz11t1735373620tpx7hg
X-QQ-Originating-IP: KDPku/+mcPzLjI4EE8WRTTKLe1wURpNrIaZay7ryFO0=
Received: from smtpclient.apple ( [223.160.206.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sat, 28 Dec 2024 16:13:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 6294575127339266685
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: Bug: use-after-free in __bitmap_weight
From: Kun Hu <huk23@m.fudan.edu.cn>
In-Reply-To: <20241226141927.766513a025a87b5fd1126fa3@linux-foundation.org>
Date: Sat, 28 Dec 2024 16:13:27 +0800
Cc: yury.norov@gmail.com,
 linux@rasmusvillemoes.dk,
 pabeni@redhat.com,
 jacob.e.keller@intel.com,
 linux-kernel@vger.kernel.org,
 "jjtan24@m.fudan.edu.cn" <jjtan24@m.fudan.edu.cn>,
 ocfs2-devel@lists.linux.dev
Content-Transfer-Encoding: quoted-printable
Message-Id: <BD5F6754-166A-40CB-A97B-B722039B845A@m.fudan.edu.cn>
References: <630B5C8C-5C8A-4BFB-9FB0-A63CDB200629@m.fudan.edu.cn>
 <20241226141927.766513a025a87b5fd1126fa3@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3818.100.11.1.3)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:m.fudan.edu.cn:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: M9OL2U7tWoeKTlGsLIbgyDespdeJwoFecCziqrh6VK2Rf5R0WHQwNdB3
	QBAX6V6EU0I53dYv+bX394v7Ex7fmjPvMo1NdDFO+K5YaIUTLO3+ySxNAiCQTsgu3zkb8YV
	kwWNYsyKub7XJ4u7nxAL/xrPF0hxsSQk8z8NayP3AyzZ/t4oBZC6s8KfoP0PEilDEDnEJ54
	7l/f3uXPajew3M59fwPu7sUAVukU1EJA83NnwVEnflbx6eXcCcfxLnwjyjiVqQ5v8JVx9SD
	cs8LkRWhNqFStXvC0wWQ0JPS1XNucHcR2swt1I+SQf6qU6IM5rEtqZS4FW3ukrrXlXHW+U8
	aogNxFc4bliusxPFdKo0wMyqsBIpzo86xYUS2MP557P6YwD31BRsfRQ6kvom3rHQ5WyNOj5
	Z1F2yTV4k5bcFJNKZ9n2pjhOwsallvOo4nn/koL+nfkx1ReiQTrPAAKxIxC7J2liM/NwUyr
	1Zon7cTGDcKvJ+tJArcXZVrJnkTJySd96G7eguRuilRHwT5eYkT3Di3ijg/mQlLEE02dT6+
	R0eg3Whz9Kj60IIdmZ2LJ5OijffswdoV9V5NzisBNkCZ5J02cbkxh85GqW6yCPPZcQG1lbU
	HYkKAj8Hp6SICC8NWBwdtG89eMyUljTRhzgkGdvNiIluGgmOIV0ZUgdXtiakJMjzTQ3m6P5
	fzjA9G2t4hCSzLbH8sNGEzjdijmZgwWI6QiUdMEBhpWl5Fly76lQSN8m25EgwMcCXm3KJ7C
	Yxv43q6NBMPHlDCqRMW0NKXnufEYY21gx5dhYbd3IND81Ue49vG/F+bLZHFasBJMPqbn8uU
	aDPgrYJR2J7YWVsqSSnOEPyzZQEwQDSB786FiTPuIPiIuv+E90xaHoxmwY8GXp1Gkl7YjLO
	ZucpslRrpxUxJtgt5tLZCJ3+Pnn/+K+1I1+CpBUwiGu258oVavoO972G56sx3RBqhGHuhRm
	iO/jIGI1MgdBrHUCKM02IeGoUOjdRvg1AL4YMtJlryu54in3QpRcInIKScGtxz7sMbdXbEf
	gXGFMg3Ei1lA7dK4wP
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0



> 2024=E5=B9=B412=E6=9C=8827=E6=97=A5 06:19=EF=BC=8CAndrew Morton =
<akpm@linux-foundation.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, 24 Dec 2024 19:37:29 +0800 Kun Hu <huk23@m.fudan.edu.cn> =
wrote:
>=20
>> Hello,
>>=20
>> When using fuzzer tool to fuzz the latest Linux kernel, the following =
crash
>> was triggered.
>=20
> Thanks.  Let's cc the ocfs2 list.
>=20
>> HEAD commit: 78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
>> git tree: upstream
>> Console output: =
https://drive.google.com/file/d/1CJ3VaQxlqkGdcEitM_aoSuzeCpfUWrAi/view?usp=
=3Dsharing
>> Kernel config: =
https://drive.google.com/file/d/1RhT5dFTs6Vx1U71PbpenN7TPtnPoa3NI/view?usp=
=3Dsharing
>> C reproducer: /
>> Syzlang reproducer: /
>>=20
>>=20
>> Unfortunately, we're getting a stable reproduction of the program. If =
you fix this issue, please add the following tag to the commit:
>> Reported-by: Kun Hu <huk23@m.fudan.edu.cn>
>>=20
>> (syz.0.394,3922,2):ocfs2_mknod:298 ERROR: status =3D -2
>> (syz.0.394,3922,2):ocfs2_mknod:502 ERROR: status =3D -2
>> (syz.0.394,3922,2):ocfs2_create:676 ERROR: status =3D -2
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: use-after-free in __bitmap_weight+0xf9/0x110 =
lib/bitmap.c:340
>> Read of size 8 at addr ff11000056367000 by task syz.0.394/3922
>>=20
>> CPU: 2 UID: 0 PID: 3922 Comm: syz.0.394 Not tainted 6.13.0-rc3 #5
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
>> Call Trace:
>> <TASK>
>> __dump_stack lib/dump_stack.c:94 [inline]
>> dump_stack_lvl+0x116/0x1b0 lib/dump_stack.c:120
>> print_address_description mm/kasan/report.c:378 [inline]
>> print_report+0xcf/0x5f0 mm/kasan/report.c:489
>> kasan_report+0x93/0xc0 mm/kasan/report.c:602
>> __bitmap_weight+0xf9/0x110 lib/bitmap.c:340
>> bitmap_weight include/linux/bitmap.h:446 [inline]
>> memweight+0x120/0x1c0 lib/memweight.c:24
>> ocfs2_local_alloc_count_bits fs/ocfs2/localalloc.c:817 [inline]
>> ocfs2_reserve_local_alloc_bits+0x3e1/0x10a0 fs/ocfs2/localalloc.c:655
>> ocfs2_reserve_clusters_with_limit+0x7eb/0xcd0 =
fs/ocfs2/suballoc.c:1166
>> ocfs2_reserve_clusters fs/ocfs2/suballoc.c:1227 [inline]
>> ocfs2_lock_allocators+0x351/0x610 fs/ocfs2/suballoc.c:2746
>> ocfs2_extend_allocation+0x274/0x17d0 fs/ocfs2/file.c:589
>> ocfs2_allocate_unwritten_extents+0x22c/0x740 fs/ocfs2/file.c:1496
>> __ocfs2_change_file_space+0xba0/0x1090 fs/ocfs2/file.c:2023
>> ocfs2_fallocate+0x271/0x300 fs/ocfs2/file.c:2138
>> vfs_fallocate+0x49d/0xeb0 fs/open.c:327
>> ksys_fallocate+0x55/0xa0 fs/open.c:351
>> __do_sys_fallocate fs/open.c:356 [inline]
>> __se_sys_fallocate fs/open.c:354 [inline]
>> __x64_sys_fallocate+0x97/0x100 fs/open.c:354
>> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
>> entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f9d68c8d71d
>> Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f9d678bfba8 EFLAGS: 00000246 ORIG_RAX: =
000000000000011d
>> RAX: ffffffffffffffda RBX: 00007f9d68e50058 RCX: 00007f9d68c8d71d
>> RDX: 00000000000000fa RSI: 0000000000000000 RDI: 0000000000000004
>> RBP: 00007f9d68d02425 R08: 0000000000000000 R09: 0000000000000000
>> R10: 000000000000ffff R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f9d68e50064 R14: 00007f9d68e500f0 R15: 00007f9d678bfd40
>> </TASK>
>>=20
>> The buggy address belongs to the physical page:
>> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x7f =
pfn:0x56367
>> flags: 0x100000000000000(node=3D0|zone=3D1)
>> raw: 0100000000000000 ffd4000001221708 ffd40000012ea688 =
0000000000000000
>> raw: 000000000000007f 0000000000000000 00000000ffffffff =
0000000000000000
>> page dumped because: kasan: bad access detected
>>=20
>> Memory state around the buggy address:
>> ff11000056366f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ff11000056366f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> ff11000056367000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> ^
>> ff11000056367080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> ff11000056367100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> OCFS2: ERROR (device loop0): ocfs2_reserve_local_alloc_bits: local =
alloc inode 10712166395476743305 says it has 2419393108 used bits, but a =
count shows 145657
>> On-disk corruption discovered. Please run fsck.ocfs2 once the =
filesystem is unmounted.
>> OCFS2: Returning error to the calling process.
>> (syz.0.394,3922,2):ocfs2_reserve_local_alloc_bits:710 ERROR: status =3D=
 -5
>> (syz.0.394,3922,2):ocfs2_reserve_clusters_with_limit:1170 ERROR: =
status =3D -5
>> (syz.0.394,3922,2):ocfs2_reserve_clusters_with_limit:1219 ERROR: =
status =3D -5
>> (syz.0.394,3922,2):ocfs2_lock_allocators:2749 ERROR: status =3D -5
>> (syz.0.394,3922,2):ocfs2_extend_allocation:592 ERROR: status =3D -5
>> (syz.0.394,3922,2):ocfs2_allocate_unwritten_extents:1499 ERROR: =
status =3D -5
>> (syz.0.394,3922,2):__ocfs2_change_file_space:2045 ERROR: status =3D =
-5
>>=20
>>=20
>> ---------------
>> thanks,
>> Kun Hu


If you need any more information, please don't hesitate to let me know.

=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
Best regards,
Kun Hu

