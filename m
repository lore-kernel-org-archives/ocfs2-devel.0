Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8283266B46;
	Thu,  5 Jun 2025 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749131891; cv=none; b=UJ5Dq8EjR+fdv+/wyS1VbtzNYUCJYn8YDUpHmu7mpl9QKsfj+XI/TJikPgP74vjUDOrlPJT1bqEeJj5uE/CvwTDPmyKeLNQ6KR3B48mtN0bG8MoofRieiuIJcmGfAAs0uA0gIGmpsdkuh9wby8zVR0vfj+03Z5+HyX1vmoqvuCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749131891; c=relaxed/simple;
	bh=RxeZKKtfRds3PxN3PLe0wf4c3gwQug6TquFWBiVuZic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gg/YMprXlf0cDWSGmzmv6h8rTI7Lnk8OYnsWJBPcau7BwX97UCjJ1SOtwoYoUurz1CnrAr49lgF5PMYctCvNNwicjCnuVcoy511TZNn5lSlDD6tkgI4mcWo3i/GSo+alxXNcaZFoeCfhpTg7JmXDEJpogTZajBaub5P8sY6B6cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oGVwMvp4; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oGVwMvp4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tiQUdlh/Ce3B8Ur44I1W3ANWS6iBCuhuH2zMPodOOo8=; b=oGVwMvp475cMptqAnh+LDsAfic
	6ETohqcOf2AIKYMPfZqGeo3k9QK+/bAYSvVz8Do6+DEjBsZChbz2VLkFpYNlEedEPfopmGUjicYA7
	eiqeA1XR6Bh3e9gf3M5bZcu+eyGfbTpnBN2VYnx+ujGC0z/MUE+63ux8Z98pi/uIfkudGfjazRMV2
	lMce6nTj1euWRLb/XfY/UGpQtoLi7HQ873GaeJeDL93gGiR8DIOazRhbIddSk2TSQDYmST5W9qUre
	pRHq2XVNue/5MivDrqoTZBqaoAI3BiOilTVGNjo/YPjO0nujpI19oQBo60Jf546AAT4IuKiEnfT+j
	QW3GnLPg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uNB6b-00000004IoF-01Q4;
	Thu, 05 Jun 2025 13:58:05 +0000
Date: Thu, 5 Jun 2025 14:58:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: syzbot <syzbot+f34f8bb121f222fb1f38@syzkaller.appspotmail.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org, mark@fasheh.com,
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_write_begin_nolock (2)
Message-ID: <aEGibEiKI5Tl6gmV@casper.infradead.org>
References: <6841282f.050a0220.2461cf.000d.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6841282f.050a0220.2461cf.000d.GAE@google.com>

On Wed, Jun 04, 2025 at 10:16:31PM -0700, syzbot wrote:
> ------------[ cut here ]------------
> kernel BUG at fs/ocfs2/aops.c:1389!

That's this one:

                        /* We should already CoW the refcountd extent. */
                        BUG_ON(ext_flags & OCFS2_EXT_REFCOUNTED);

> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 6894 Comm: syz.4.220 Not tainted 6.15.0-next-20250530-syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
> RIP: 0010:ocfs2_populate_write_desc fs/ocfs2/aops.c:1389 [inline]
> RIP: 0010:ocfs2_write_begin_nolock+0x42e0/0x4340 fs/ocfs2/aops.c:1687
> Code: 00 eb 05 e8 82 54 28 fe 49 bd 00 00 00 00 00 fc ff df e9 23 fe ff ff e8 fe dc cd 07 e8 69 54 28 fe 90 0f 0b e8 61 54 28 fe 90 <0f> 0b e8 59 54 28 fe 90 0f 0b e8 51 54 28 fe 90 0f 0b e8 49 54 28
> RSP: 0018:ffffc90019b97240 EFLAGS: 00010293
> RAX: ffffffff83980b4f RBX: 0000000000000002 RCX: ffff88802530da00
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: ffffc90019b97800 R08: ffff88802530da00 R09: 0000000000000006
> R10: 00000000fffffffc R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: 0000000000000001 R15: ffff88805b968010
> FS:  00005555780fd500(0000) GS:ffff888125c53000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000110c2f56bd CR3: 00000000675d4000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  __ocfs2_page_mkwrite fs/ocfs2/mmap.c:93 [inline]
>  ocfs2_page_mkwrite+0x600/0xc40 fs/ocfs2/mmap.c:144
>  do_page_mkwrite+0x14a/0x310 mm/memory.c:3378
>  wp_page_shared mm/memory.c:3779 [inline]
>  do_wp_page+0x268d/0x5800 mm/memory.c:3998
>  handle_pte_fault mm/memory.c:6105 [inline]
>  __handle_mm_fault+0x1144/0x5620 mm/memory.c:6232
>  handle_mm_fault+0x40a/0x8e0 mm/memory.c:6401
>  do_user_addr_fault+0x764/0x1390 arch/x86/mm/fault.c:1387
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x76/0xf0 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
> RIP: 0033:0x7f79671566ab
> Code: fa 10 73 2d 83 fa 08 73 46 83 fa 04 73 16 83 fa 01 7c 10 8a 0e 74 0a 0f b7 74 16 fe 66 89 74 17 fe 88 0f c3 8b 4c 16 fc 8b 36 <89> 4c 17 fc 89 37 c3 c5 fa 6f 06 c5 fa 6f 4c 16 f0 c5 fa 7f 07 c5
> RSP: 002b:00007fff1cbdc378 EFLAGS: 00010202
> RAX: 00002000000005c0 RBX: 0000000000000004 RCX: 0000000000737562
> RDX: 0000000000000006 RSI: 0000000075622f2e RDI: 00002000000005c0
> RBP: 00007f79673b7ba0 R08: 00007f7967000000 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000009 R12: 00007f79673b5fac
> R13: 00007fff1cbdc470 R14: fffffffffffffffe R15: 00007fff1cbdc490
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ocfs2_populate_write_desc fs/ocfs2/aops.c:1389 [inline]
> RIP: 0010:ocfs2_write_begin_nolock+0x42e0/0x4340 fs/ocfs2/aops.c:1687
> Code: 00 eb 05 e8 82 54 28 fe 49 bd 00 00 00 00 00 fc ff df e9 23 fe ff ff e8 fe dc cd 07 e8 69 54 28 fe 90 0f 0b e8 61 54 28 fe 90 <0f> 0b e8 59 54 28 fe 90 0f 0b e8 51 54 28 fe 90 0f 0b e8 49 54 28
> RSP: 0018:ffffc90019b97240 EFLAGS: 00010293
> RAX: ffffffff83980b4f RBX: 0000000000000002 RCX: ffff88802530da00
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: ffffc90019b97800 R08: ffff88802530da00 R09: 0000000000000006
> R10: 00000000fffffffc R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: 0000000000000001 R15: ffff88805b968010
> FS:  00005555780fd500(0000) GS:ffff888125c53000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005561c2044660 CR3: 00000000675d4000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 
