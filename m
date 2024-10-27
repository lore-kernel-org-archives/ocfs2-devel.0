Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956703F9D2
	for <ocfs2-devel@lists.linux.dev>; Sun, 27 Oct 2024 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730044953; cv=none; b=G04yIIX36o2H5J7IUKn+jdYrOgJNAYb00goyEuHWYvAHIxMt9DdvZLQbXUGbfnCjV0AmGq52S2jx0+9QNeR4OmkfxAnRhptzwEmYZCCLF/k/3lrLLPGT1kWBhTHDUQvGFk+umtxHDAMPihpxwGCOJIssggTo5k2VovFl2aIFx60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730044953; c=relaxed/simple;
	bh=fgp8QgV6/xl9FkVLpQi6ueFKupfPmkD2Bb60iRl0IGA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qyG2dhOR8Mt3nTkZ8q+lOguaDxRna9NiBX+DlmaGn4EMDtR3wFC702ikGtnIB3A9ea/89I/u0J8hKyGu2/fwkFO/0b1X0P857ocI7tprsT2GGqT9KeV3A9Fq81YrBymJuchpwaIo4kghxur1KX9oQZ33G5MFYQ3YlrapSpKDvQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3c9886eccso31696505ab.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 27 Oct 2024 09:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730044951; x=1730649751;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kXTENcATWXHDIpCLm9caWV9x74kiV5jk6fdrjj3b6zU=;
        b=c4ADN4LI+M/nowdYKpPIfTZv5SldwHL7NpqdDM4DLrwjzq7ZTAeGytyXi84DcYUkpz
         ynhpRS/ZRZIDzM7MpOLiiB3s6Oh7gjKA6IA2QVXGiIx5MyRFYm0RWDzpqXJQd1FT1moS
         czoftYwb8EF4v41deQUra6kOIwcMSTdDQQTQlWMZHZdvuA5YVf30ZtLeNGbS2kWrGrXA
         qb4ifI5HTJIyyxpw0cG3dROMQDl+hzC1JAHbfcD2wT4a5GydYcoJR2bI4dcV7UzXs1BQ
         gQAs0SexImzaaS34ZTGi9OrxDhx7b2zSh3/202XhI63l/MoVkiCeIc0sXXj+yNdEz/iD
         UFcA==
X-Forwarded-Encrypted: i=1; AJvYcCVgL583rgptgWMzCO9Ie7tNfLi28g3fj3C/1eJs0kxmcNJt6UBPXydTmDFs0si3T4fSOcw5oBABWVPv3g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxV9+gKj/jFIhl05fqI1o8kTt2x4/n8CnO/bR55XdqByH995575
	T3GQh6hw6aVL8NZuY1n20QKLUMW41Mdx0LBMmpnwTqQ4yPWXb7mr3rN73SdJmtAb7LbEMY09VPG
	QRo/v0dYbMEvmMea367d3aNuCOHZuJeZaZslXYqmodILNzUbVc8U+JmQ=
X-Google-Smtp-Source: AGHT+IFotLjMvavE2oyGlBz4gCi8DpUFI7VLLENKnEOt38nwthivm604RGj2fVjIecRcPP5r4d9SEKN77/5RqFZikQx6gZ9m7sVc
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c54e:0:b0:3a3:9471:8967 with SMTP id
 e9e14a558f8ab-3a4ed29e555mr55937535ab.11.1730044950593; Sun, 27 Oct 2024
 09:02:30 -0700 (PDT)
Date: Sun, 27 Oct 2024 09:02:30 -0700
In-Reply-To: <670ec2d5.050a0220.d9b66.0155.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671e6416.050a0220.2b8c0f.01de.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_clear_cow_buffer
From: syzbot <syzbot+69c3bc471900052ecff5@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    850925a8133c Merge tag '9p-for-6.12-rc5' of https://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1553ea87980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=309bb816d40abc28
dashboard link: https://syzkaller.appspot.com/bug?extid=69c3bc471900052ecff5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f3cca7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f3cca7980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-850925a8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c831c931f29c/vmlinux-850925a8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/85f584e52a7f/bzImage-850925a8.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/219674756913/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+69c3bc471900052ecff5@syzkaller.appspotmail.com

ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/refcounttree.c:2890!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5326 Comm: syz-executor223 Not tainted 6.12.0-rc4-syzkaller-00261-g850925a8133c #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_clear_cow_buffer+0x79/0x80 fs/ocfs2/refcounttree.c:2890
Code: 02 75 21 e8 c9 ac 02 fe 4c 89 f7 be 08 00 00 00 e8 2c 6d 6c fe 3e 41 80 26 ef 31 c0 5b 41 5e c3 cc cc cc cc e8 a8 ac 02 fe 90 <0f> 0b 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d10ef60 EFLAGS: 00010293
RAX: ffffffff83923dc8 RBX: 0000000000000002 RCX: ffff8880009ac880
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: 0000000000001000 R08: ffffffff83923d9c R09: 1ffff11008a63722
R10: dffffc0000000000 R11: ffffed1008a63723 R12: ffff88804531b910
R13: ffff88804531b828 R14: ffff88804531b910 R15: 0000000000000000
FS:  00007fa36d8496c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa36d8e700a CR3: 000000004306e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 walk_page_buffers+0x104/0x1d0 fs/ocfs2/aops.c:434
 ocfs2_duplicate_clusters_by_page+0xb0a/0x1450 fs/ocfs2/refcounttree.c:2970
 ocfs2_replace_clusters fs/ocfs2/refcounttree.c:3123 [inline]
 ocfs2_make_clusters_writable fs/ocfs2/refcounttree.c:3255 [inline]
 ocfs2_replace_cow+0xd82/0x25d0 fs/ocfs2/refcounttree.c:3349
 ocfs2_refcount_cow_hunk fs/ocfs2/refcounttree.c:3427 [inline]
 ocfs2_refcount_cow+0x9c9/0x11c0 fs/ocfs2/refcounttree.c:3470
 ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2332 [inline]
 ocfs2_file_write_iter+0xf34/0x1f50 fs/ocfs2/file.c:2441
 do_iter_readv_writev+0x600/0x880
 vfs_writev+0x376/0xba0 fs/read_write.c:1064
 do_pwritev fs/read_write.c:1165 [inline]
 __do_sys_pwritev2 fs/read_write.c:1224 [inline]
 __se_sys_pwritev2+0x1ca/0x2d0 fs/read_write.c:1215
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa36d892ec9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa36d849208 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 0000000000000040 RCX: 00007fa36d892ec9
RDX: 0000000000000001 RSI: 0000000020000240 RDI: 0000000000000005
RBP: 00007fa36d91e708 R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000007800 R11: 0000000000000246 R12: 00007fa36d91e700
R13: 00007fa36d8eb4ec R14: 0031656c69662f2e R15: 6165627472616568
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_clear_cow_buffer+0x79/0x80 fs/ocfs2/refcounttree.c:2890
Code: 02 75 21 e8 c9 ac 02 fe 4c 89 f7 be 08 00 00 00 e8 2c 6d 6c fe 3e 41 80 26 ef 31 c0 5b 41 5e c3 cc cc cc cc e8 a8 ac 02 fe 90 <0f> 0b 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d10ef60 EFLAGS: 00010293
RAX: ffffffff83923dc8 RBX: 0000000000000002 RCX: ffff8880009ac880
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: 0000000000001000 R08: ffffffff83923d9c R09: 1ffff11008a63722
R10: dffffc0000000000 R11: ffffed1008a63723 R12: ffff88804531b910
R13: ffff88804531b828 R14: ffff88804531b910 R15: 0000000000000000
FS:  00007fa36d8496c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa36586a000 CR3: 000000004306e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
