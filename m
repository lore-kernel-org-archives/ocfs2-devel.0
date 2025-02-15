Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8539441A8F
	for <ocfs2-devel@lists.linux.dev>; Sat, 15 Feb 2025 23:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739660849; cv=none; b=PA3hCiBrQpBpqnH1i7m57Lnb19LmBoU6AqvixzQP0BBZH20/mA0lIth4oPv0q7OJ9aZNV+zGVzyOigNSIIQlSRsrk/Sawh+/EME28/nl4ybW0cnF2E4VWypBErGvYnOtDgNN1p4ncn7MhmpjRluLkxUI33Fge7R1D3J1mN/4btk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739660849; c=relaxed/simple;
	bh=sAUydxP2m80oXKo8WnXR34icefeMyLrCdS1/NT0+D/o=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iBwEHtTuM1KpL0/PhpO/vRbS1FTG9IhAWo+cvWo068oapYNv5BPLavK4CNlu2JyyaWpBfiC5GRqjTsCkdxItJ2yG8iWbVww40wFFjJCpt6MYObCAexTk8uPX0X1r8AE6EKCLqoHgpB7maRAtIldivOCemBm4gNuEo/KevXC/z5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d18700311dso22542015ab.0
        for <ocfs2-devel@lists.linux.dev>; Sat, 15 Feb 2025 15:07:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739660846; x=1740265646;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2WYie95owwq4yNXrs+hzQDVYonhfXUI/z2RzXPREhoE=;
        b=TnZLobUBfNNDBUfZgo2jI7vJr4IGOHMgGy9lABD75BV0zUp5zNwltVyIL05GnXEa/C
         vf5qiwEqBiqGUBgpAM71al+4dD9WJYADXbRm6ak06u6CUa0n555qX3/AhJ421KD4exz+
         oWc6IYrhLI5qr10qI92QZvADNmpg6rrVW4U+67bAOcH8v9mP5DZFC676KeWMM/EEIL0k
         SdRV12WvnV7b+QdsaHmvNgZ4aeuHC/cNZ1oXOs1O26Davec5po8RtYQnlKQugcPPTl6e
         d7ndJXTlI0j04pQsU+AhKp5fr1ZCyM1IvwG44f1zxJrlWNknZ/4LuzQKzRWCda160P4+
         8XLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0No1nO0y7er4Sg2EvCxJ9OqOz7u9Rnpv2cPHpR8phQmjlI2piWzndXm5sU5Xhid2A+x6xHmvhi+Q+Ow==@lists.linux.dev
X-Gm-Message-State: AOJu0YyawQyYptg+YDm2o/SxjPfD1H9FdVJJ947MlhXwA++f6eHRFBOj
	bQIigairQOtRYzhPnwxg54jv4aLnhEFLTIZ4WIpq36DpM2PDcT6mDhHSkJQIUzYKZf3/YwQvibK
	ZXU7+vTHsgi3FY7Zbs3YTUQhoq6R7L9Kpm7S6N6/3cYbWMyPvHWkOx4A=
X-Google-Smtp-Source: AGHT+IEGTkhTpZewK0yZ4dnBAz/syN7LWHbXDNJU2Va13KdJcm+RMRSlozvL9pBfuuxhBeFPscsMEn6CGtZlQ0nG9Qf5g6CbUb4G
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2686:b0:3d1:bbc2:a324 with SMTP id
 e9e14a558f8ab-3d28076e074mr41098035ab.4.1739660846652; Sat, 15 Feb 2025
 15:07:26 -0800 (PST)
Date: Sat, 15 Feb 2025 15:07:26 -0800
In-Reply-To: <0000000000001e20c30621e8d767@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b11e2e.050a0220.54b41.0000.GAE@google.com>
Subject: Re: [syzbot] [ocfs2?] kernel BUG in ocfs2_dio_wr_get_block
From: syzbot <syzbot+f8b081be889b639423bb@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    7ff71e6d9239 Merge tag 'alpha-fixes-v6.14-rc2' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1463cbf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c776e555cfbdb82d
dashboard link: https://syzkaller.appspot.com/bug?extid=f8b081be889b639423bb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1242b9b0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-7ff71e6d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fd3ab8248fc7/vmlinux-7ff71e6d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/78a957463e92/bzImage-7ff71e6d.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/9f4996b458f4/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=13d217df980000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/bb9bcc7dccee/mount_1.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1063cbf8580000)
mounted in repro #3: https://storage.googleapis.com/syzbot-assets/f9c91d3ae4fc/mount_11.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f8b081be889b639423bb@syzkaller.appspotmail.com

(syz.0.529,6754,0):ocfs2_commit_trans:382 ERROR: status = -5
------------[ cut here ]------------
kernel BUG at fs/ocfs2/aops.c:2259!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 6754 Comm: syz.0.529 Not tainted 6.14.0-rc2-syzkaller-00259-g7ff71e6d9239 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_dio_wr_get_block+0x18bd/0x18d0 fs/ocfs2/aops.c:2259
Code: 02 8f 4c 89 f2 e8 13 7d 76 01 e9 3a f6 ff ff e8 99 d0 50 08 e8 b4 5b 0a fe 90 0f 0b e8 ac 5b 0a fe 90 0f 0b e8 a4 5b 0a fe 90 <0f> 0b e8 9c 5b 0a fe 90 0f 0b 66 0f 1f 84 00 00 00 00 00 90 90 90
RSP: 0018:ffffc9000d1a6cc0 EFLAGS: 00010293
RAX: ffffffff83b75c9c RBX: 0000000000001000 RCX: ffff8880003b2440
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 00000000ffffffe2
RBP: ffffc9000d1a6eb0 R08: ffffffff83b7573b R09: 1ffffffff28a892d
R10: dffffc0000000000 R11: fffffbfff28a892e R12: 1ffff1100b25690d
R13: dffffc0000000000 R14: 00000000ffffffe2 R15: ffff888033f59e10
FS:  00007f9eff0936c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa1c7fd4000 CR3: 00000000595e2000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 get_more_blocks fs/direct-io.c:648 [inline]
 do_direct_IO fs/direct-io.c:936 [inline]
 __blockdev_direct_IO+0x1c87/0x4890 fs/direct-io.c:1243
 ocfs2_direct_IO+0x255/0x2c0 fs/ocfs2/aops.c:2445
 generic_file_direct_write+0x1e6/0x400 mm/filemap.c:4112
 __generic_file_write_iter+0x126/0x230 mm/filemap.c:4276
 ocfs2_file_write_iter+0x19af/0x2180 fs/ocfs2/file.c:2469
 iter_file_splice_write+0xbfa/0x1510 fs/splice.c:743
 do_splice_from fs/splice.c:941 [inline]
 direct_splice_actor+0x11b/0x220 fs/splice.c:1164
 splice_direct_to_actor+0x586/0xc80 fs/splice.c:1108
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x289/0x3e0 fs/splice.c:1233
 do_sendfile+0x564/0x8a0 fs/read_write.c:1363
 __do_sys_sendfile64 fs/read_write.c:1424 [inline]
 __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1410
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9efe18cde9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9eff093038 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f9efe3a5fa0 RCX: 00007f9efe18cde9
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 0000000000000009
RBP: 00007f9efe20e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000800000009 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f9efe3a5fa0 R15: 00007ffc84ed0c78
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_dio_wr_get_block+0x18bd/0x18d0 fs/ocfs2/aops.c:2259
Code: 02 8f 4c 89 f2 e8 13 7d 76 01 e9 3a f6 ff ff e8 99 d0 50 08 e8 b4 5b 0a fe 90 0f 0b e8 ac 5b 0a fe 90 0f 0b e8 a4 5b 0a fe 90 <0f> 0b e8 9c 5b 0a fe 90 0f 0b 66 0f 1f 84 00 00 00 00 00 90 90 90
RSP: 0018:ffffc9000d1a6cc0 EFLAGS: 00010293
RAX: ffffffff83b75c9c RBX: 0000000000001000 RCX: ffff8880003b2440
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 00000000ffffffe2
RBP: ffffc9000d1a6eb0 R08: ffffffff83b7573b R09: 1ffffffff28a892d
R10: dffffc0000000000 R11: fffffbfff28a892e R12: 1ffff1100b25690d
R13: dffffc0000000000 R14: 00000000ffffffe2 R15: ffff888033f59e10
FS:  00007f9eff0936c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1bd36e8000 CR3: 00000000595e2000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
