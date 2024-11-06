Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFABA645
	for <ocfs2-devel@lists.linux.dev>; Wed,  6 Nov 2024 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730914658; cv=none; b=ADiAmbFnRkVdsEri7Q+TnpeutumpHo58FhxZGSil8oh/nk56P3eXe2RjanZFwPLzZJu4h5m3xeMGbDlHM7q316ntbiB3WnNbLNK8Sp6d8FFgeYRS7IwDOusKFYzNKZy8nhkmBAYauJAghUJPdD8uZ21HbJIQ8grpLIBaj9hAJHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730914658; c=relaxed/simple;
	bh=Ml1nBf4Qqa8qI+74pfnybsjCQ3Xwijakij0vUSFkXmQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IiWvbWU3G/6iJB0p8lUzdKCcR+ltbSQU35gn9qN/eHjcLFKbcg3zZIduQ3pQtHT9V2/m/67zEVdRIngR+DZqXoDGMlmdEuSxYlanOh110uRCQvGwmnANcolU/6NUvt7NXuxjwKb/0+OHlrnN9N8t1xQVBHWhQl3EhoGzXJCP0LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a6b2581364so1207395ab.0
        for <ocfs2-devel@lists.linux.dev>; Wed, 06 Nov 2024 09:37:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730914656; x=1731519456;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wKkPZnsKw5Ly8IgM6wcmmxhijd2CBCP7ffFrYQmFB3E=;
        b=hDzxawM9CZq49SpJ1ys2PDmxyexyjjCUJj8u7nn9e5ifjCV+zjwFgJo3YaYE/6+/Oo
         Q8SYxd9Gm+5bXPR+HzXT+vLj2BOBNVB+ylDOoNwiBiOT1zBY0nlteZsbgUsLCjVTSLaQ
         RwctimWWR4aQ/KVqSXx/gSRhEzCUVR7o02Sfv7v7fOZJTSj4+6lhkgnq+NpyTKVwW8+P
         ko21VsE7x8gDcr+AOnQVpUaNG3FV7EYQil25Pfb2xrSrW1a6JGoqK5IFgi6Imuc5n+G2
         HDMeMGg6VCYKcezd4FpNPk7OCxIPmpUzMmn3zuOSlwf3RF+lfkPZi68bW9UICNE7hV1h
         Kr8A==
X-Forwarded-Encrypted: i=1; AJvYcCWXim5SvJrJlk5HQvg+4FnRT85zVHxz4Eg9EKst86CE45aBjbBeNR5HGyu20Of6xVFg8ASRSRWDyE7mPQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwWmxA/HGhLnB8zt4+ljwhWVrL75uV0+m0BAYXWRSkDgtgSah6s
	mgbVXqlStcvJDgnx3VGgOtCudWJsNC5sAcGt1Lg9iZU5+Xh+ojV0apvYrxMT2kWYjB8eRDtVLHo
	Ak5fpcy4AXUG82HLMezQCkqTrRzsgTj2VgnIIVt0Df4VW4cnRfspzwRY=
X-Google-Smtp-Source: AGHT+IG+E911eimZoBT9V3TXhgXNTH+C+SwSavAPi1H5SVSntJq9c7u6+70MHMNv3+bKuQBKamkcpLfTSkEIARspSRlu2S2fXhkD
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1746:b0:3a6:c716:ab1f with SMTP id
 e9e14a558f8ab-3a6c716ae23mr150450175ab.9.1730914656203; Wed, 06 Nov 2024
 09:37:36 -0800 (PST)
Date: Wed, 06 Nov 2024 09:37:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672ba960.050a0220.350062.0277.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_truncate_log_append
From: syzbot <syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    11066801dd4b Merge tag 'linux_kselftest-fixes-6.12-rc6' of..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=161ed630580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=672325e7ab17fdf7
dashboard link: https://syzkaller.appspot.com/bug?extid=a66542ca5ebb4233b563
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c0f55f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12482b40580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-11066801.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b062b193560b/vmlinux-11066801.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5b6da4ee7c42/bzImage-11066801.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/3a77709f2405/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a66542ca5ebb4233b563@syzkaller.appspotmail.com

(syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: bug expression: tl_count > ocfs2_truncate_recs_per_inode(osb->sb) || tl_count == 0
(syz-executor404,5313,0):ocfs2_truncate_log_append:5874 ERROR: Truncate record count on #77 invalid wanted 39, actual 2087
------------[ cut here ]------------
kernel BUG at fs/ocfs2/alloc.c:5874!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5313 Comm: syz-executor404 Not tainted 6.12.0-rc5-syzkaller-00299-g11066801dd4b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
Code: bc 24 a0 00 00 00 48 c7 c6 ac ae 12 8e ba f2 16 00 00 48 c7 c1 c0 18 49 8c 4d 89 f0 41 89 d9 50 e8 ad 90 20 00 48 83 c4 08 90 <0f> 0b e8 71 87 11 fe 90 0f 0b e8 69 87 11 fe 90 0f 0b e8 f1 d3 43
RSP: 0018:ffffc9000cf16f40 EFLAGS: 00010292
RAX: b4b54f1d10640800 RBX: 0000000000000027 RCX: b4b54f1d10640800
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000cf17070 R08: ffffffff8174a14c R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff110085f5f58
R13: ffffff3800000000 R14: 000000000000004d R15: ffff8880438f0008
FS:  00005555722df380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000f000 CR3: 000000004010e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_remove_btree_range+0x1303/0x1860 fs/ocfs2/alloc.c:5789
 ocfs2_remove_inode_range+0xff3/0x29f0 fs/ocfs2/file.c:1907
 ocfs2_reflink_remap_extent fs/ocfs2/refcounttree.c:4537 [inline]
 ocfs2_reflink_remap_blocks+0xcd4/0x1f30 fs/ocfs2/refcounttree.c:4684
 ocfs2_remap_file_range+0x5fa/0x8d0 fs/ocfs2/file.c:2736
 vfs_copy_file_range+0xc07/0x1510 fs/read_write.c:1615
 __do_sys_copy_file_range fs/read_write.c:1705 [inline]
 __se_sys_copy_file_range+0x3f2/0x5d0 fs/read_write.c:1668
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd327167af9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe6b8e22e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007fd3271b005e RCX: 00007fd327167af9
RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007fd3271de610 R08: 000000000000d8c2 R09: 0000000000000000
R10: 0000000020000640 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffe6b8e24b8 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_truncate_log_append+0x9a8/0x9c0 fs/ocfs2/alloc.c:5868
Code: bc 24 a0 00 00 00 48 c7 c6 ac ae 12 8e ba f2 16 00 00 48 c7 c1 c0 18 49 8c 4d 89 f0 41 89 d9 50 e8 ad 90 20 00 48 83 c4 08 90 <0f> 0b e8 71 87 11 fe 90 0f 0b e8 69 87 11 fe 90 0f 0b e8 f1 d3 43
RSP: 0018:ffffc9000cf16f40 EFLAGS: 00010292
RAX: b4b54f1d10640800 RBX: 0000000000000027 RCX: b4b54f1d10640800
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000cf17070 R08: ffffffff8174a14c R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: 1ffff110085f5f58
R13: ffffff3800000000 R14: 000000000000004d R15: ffff8880438f0008
FS:  00005555722df380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000f000 CR3: 000000004010e000 CR4: 0000000000352ef0
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

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
