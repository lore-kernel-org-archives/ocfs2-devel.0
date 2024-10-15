Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E27C17C9BB
	for <ocfs2-devel@lists.linux.dev>; Tue, 15 Oct 2024 19:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729020632; cv=none; b=m6+X06e7bER6hYz2aRUUzhKvppqFnqmVG45Z/QBmVEbEhte1fbZMpTghDym4u96u6pgaBECUwG6nrIcAagGyYH6noEdbB4+zzSi72OiVuZ3c0/rkwgaEpl40YMR4swfQrlbh6DR8Etk176yD5oWI07jIbbKE9vY3DvM+BaayKjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729020632; c=relaxed/simple;
	bh=0/zX9WEiMwiOMuSgC0zToSP5RVWBdUcXQfpxF4Zo49w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rpu5EV4JD9l8elHxRAsLIUmnQD28Io5s+24clNXjIlIGQUbbUTyEDJAFPaK2upzvW4vtyRSSS7/dslcV8ILfiBPj3fUj6rCc2NWLP1OMFVdQCD1SHQq/iqVRwIDjwfdZo6di0qwN0LUCszg6K022OkfYzpQG6zfcZl4hYdYT9ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3a6afd01eso45962625ab.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 15 Oct 2024 12:30:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729020630; x=1729625430;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nTxvqzKczqnJBQ6r8LZyPHOblRBaRJQvP5p+w5NmVRg=;
        b=PkAJuwcLzxhWYw74pEZLuJcNwSy1xKo19lyBg5+rGZugJDp0Dppo1oBUeH1FqvYcxW
         BpM66WM4oDROokXkniaeY8J3GBtTDqy/AJM7llXvuTNI6W/AVA16bNNVSU+luT+kuN2e
         Ymy3vaWYaHdN80QtaKoe5KbVHr/kaJ3nxr7cwLS/u4IdeKRPdSPxOQMPSICApaXwM6W8
         LuTrP69Bxf7W0OGlWZToisJilWTqZRXBJTfUQ7IdIOgVnYrGq0YZ0IPweg+/JfTmX7ux
         lRntCoSfmcpaGcb4ZL8tME9XOvtm3Zw6+DTn1q0UpWjcTHq/DP3/BbUR/C3v5jmlMlMj
         6law==
X-Forwarded-Encrypted: i=1; AJvYcCX40RRAS/aCT9Gtr6JHqLdVGVksT3Z0tYMmJfrB4WfARa3s5WYqWl0QMMNXMjpxM1I6WEj61ArUF8GmJQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLvxz2opnkHleSrSIKGmZbJkmdnpOb5ipazJwj6fJaf+GUojk8
	BrGu2M5ZOeagcFa1Fie0tiAeSPb/5yUMn+N3uzQZTGU0QWCjzaCHg17Xj/frmHiwZKQSKZpbBGq
	DXihQzx1KvreNisi7i6ag5YQpxldIph5Y1uq9p6+DxeL9cI9+YtKBUoQ=
X-Google-Smtp-Source: AGHT+IFZ0067lMzfuTPAXqNNXsCQcARwTnOSD0XGXoDS5Fhs2GQuQX4Hs0ukJ2gwG3qmyW1VQuFPXGFiiUVwBL6kERyrqK6cfFoh
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1549:b0:3a3:b3f4:af4c with SMTP id
 e9e14a558f8ab-3a3dc4fffd8mr13726085ab.25.1729020629789; Tue, 15 Oct 2024
 12:30:29 -0700 (PDT)
Date: Tue, 15 Oct 2024 12:30:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670ec2d5.050a0220.d9b66.0155.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_clear_cow_buffer
From: syzbot <syzbot+69c3bc471900052ecff5@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1d227fcc7222 Merge tag 'net-6.12-rc3' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=104f9fd0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7cd9e7e4a8a0a15b
dashboard link: https://syzkaller.appspot.com/bug?extid=69c3bc471900052ecff5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-1d227fcc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ea82465646ea/vmlinux-1d227fcc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f764dd6d008a/bzImage-1d227fcc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+69c3bc471900052ecff5@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ocfs2/refcounttree.c:2890!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5114 Comm: syz.0.0 Not tainted 6.12.0-rc2-syzkaller-00205-g1d227fcc7222 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_clear_cow_buffer+0x79/0x80 fs/ocfs2/refcounttree.c:2890
Code: 02 75 21 e8 09 e3 02 fe 4c 89 f7 be 08 00 00 00 e8 1c 96 6c fe 3e 41 80 26 ef 31 c0 5b 41 5e c3 cc cc cc cc e8 e8 e2 02 fe 90 <0f> 0b 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000179ebe0 EFLAGS: 00010283
RAX: ffffffff83920468 RBX: 0000000000000002 RCX: 0000000000040000
RDX: ffffc9000b912000 RSI: 0000000000008db5 RDI: 0000000000008db6
RBP: 0000000000001000 R08: ffffffff8392043c R09: 1ffff110039a821d
R10: dffffc0000000000 R11: ffffed10039a821e R12: ffff88801cd410e8
R13: ffff88801cd41000 R14: ffff88801cd410e8 R15: 0000000000000000
FS:  00007ff66de346c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff66de12f98 CR3: 000000004b480000 CR4: 0000000000352ef0
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
 ocfs2_prepare_inode_for_write fs/ocfs2/file.c:2329 [inline]
 ocfs2_file_write_iter+0xf34/0x1f50 fs/ocfs2/file.c:2438
 iter_file_splice_write+0xbfa/0x1510 fs/splice.c:743
 do_splice_from fs/splice.c:941 [inline]
 direct_splice_actor+0x11b/0x220 fs/splice.c:1164
 splice_direct_to_actor+0x586/0xc80 fs/splice.c:1108
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x289/0x3e0 fs/splice.c:1233
 do_sendfile+0x561/0xe10 fs/read_write.c:1388
 __do_sys_sendfile64 fs/read_write.c:1455 [inline]
 __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff66cf7dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff66de34038 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007ff66d136058 RCX: 00007ff66cf7dff9
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
RBP: 00007ff66cff0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000800000009 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007ff66d136058 R15: 00007ffd4e93c2d8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_clear_cow_buffer+0x79/0x80 fs/ocfs2/refcounttree.c:2890
Code: 02 75 21 e8 09 e3 02 fe 4c 89 f7 be 08 00 00 00 e8 1c 96 6c fe 3e 41 80 26 ef 31 c0 5b 41 5e c3 cc cc cc cc e8 e8 e2 02 fe 90 <0f> 0b 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000179ebe0 EFLAGS: 00010283
RAX: ffffffff83920468 RBX: 0000000000000002 RCX: 0000000000040000
RDX: ffffc9000b912000 RSI: 0000000000008db5 RDI: 0000000000008db6
RBP: 0000000000001000 R08: ffffffff8392043c R09: 1ffff110039a821d
R10: dffffc0000000000 R11: ffffed10039a821e R12: ffff88801cd410e8
R13: ffff88801cd41000 R14: ffff88801cd410e8 R15: 0000000000000000
FS:  00007ff66de346c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056023ce6a038 CR3: 000000004b480000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
