Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F4F30597E
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 Oct 2025 02:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760494349; cv=none; b=jgfUPIvh+VuC1XEDJ/Vt+J8YCZ8a7Eejgfu4OMZPyFspl1zCYvjesm/vhUSuDgZybnRRkeQfufVwc57pv505HCdrmR4oazRY88hViE2e8+7vNbRskr3fDQE2KvSewBGcaeJPacUkoamcZKHSyIYNQ7wSRUsZskkl64V0Y/JfL7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760494349; c=relaxed/simple;
	bh=eKGNpUKyDE2VQSL6YlYyTmtjhvMrD1dZuDR+y2pvnn0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JhazfPuTwgnZPVhcZMdprR0qPVptjqZRd6FqNN8d7fy+/fnWpmhE8PjB6bUe/YS8A4idkwEudnkt3JJ8mdu7TZaHTyf9bWgBaasw5UJWxzhUWNUeHPllG2bWzYBABHCN4Bh6XomHMVeByQQEtYIaJ4LEAL5h8+cVRrNLbGCUqRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-42486f6da6fso164075995ab.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 14 Oct 2025 19:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760494346; x=1761099146;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yX6KbDxutmkXQKPzLf8J37+e9FP78fVbAOChBEEIGpg=;
        b=Y0Y1N4qEy2WHXK+/1Hr3S8VjoMoqIHtE1LM15tFF1e9LDnDRTLbGL+GbMc9Iye6USu
         kz6EdvSLPBz0IbK+kqa7N/ICNsL9iACvCg7ijybQevnNnK8hRRxKUuyFFxmwUatLUsC1
         rqpxSgyvCWDeLq+0OH5JNKp0InKV+n6J4r1JNdSBuUydDgYK85tC1JE23eWW3cPvf+Te
         0IxKhs7GUXMz6pDucRRAIzAs/I6OOPoSeyLRKyHhvSST7l0stda0jtfb6ytAde5oaPaQ
         MECMPW6wVyfhFbZRPI7ydAY9ajPmAAIrAQQzIf7GgKpo/9NN+32Us5gzFamC3jDrw+BM
         1Opw==
X-Forwarded-Encrypted: i=1; AJvYcCV6atnmDKohYuUpCE1O8dtSwk6NunGwj8ZgKYdswEOYZOg7vLujHsQWjwCc1lDtzMMgRfMAT/Sp1ez3vg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwW6yGDkUNwxGz15gakDHbp2EYiDlSALaJnjtjHRip3/RVh4DxD
	d5LHDzyskXdt6x0HIdu8SbtfH5qyc8BZ9pmdtdVzRT6/OAd2L+BID5dWYrjjfVqJvlMnoenKKGx
	8GFTLOnyJCZnbv0XXO0KoYEgKoU1Ja1umSFW2k1Pkg2Qiz4WXKYpi1yrw4zI=
X-Google-Smtp-Source: AGHT+IEh6ISMeUj5fvyKppQ0bbxdDEziWXtDJH7fDBk7Uuo84Z0DwzKlKYkmPlGFcq92pwmQedn0jgx81rgoPsgid71wyy9YFX5W
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cb:b0:42e:7589:6290 with SMTP id
 e9e14a558f8ab-42f87377de2mr300391665ab.12.1760494346563; Tue, 14 Oct 2025
 19:12:26 -0700 (PDT)
Date: Tue, 14 Oct 2025 19:12:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ef030a.050a0220.91a22.022b.GAE@google.com>
Subject: [syzbot] [ocfs2?] UBSAN: array-index-out-of-bounds in ocfs2_block_group_fill
From: syzbot <syzbot+77026564530dbc29b854@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, dmantipov@yandex.ru, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org, mark@fasheh.com, 
	ocfs2-devel@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    52ba76324a9d Add linux-next specific files for 20251013
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=157d3b34580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=99cb6b007a8889ef
dashboard link: https://syzkaller.appspot.com/bug?extid=77026564530dbc29b854
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15039dcd980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ad9542580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1729256319ee/disk-52ba7632.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a3152cfcba7c/vmlinux-52ba7632.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4065a3b3d959/bzImage-52ba7632.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d98ffa49f949/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=1510f304580000)

The issue was bisected to:

commit aa545adbe491402cf1e664f6be0a799ed69d9946
Author: Dmitry Antipov <dmantipov@yandex.ru>
Date:   Tue Oct 7 12:35:26 2025 +0000

    ocfs2: annotate flexible array members with __counted_by_le()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11575542580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13575542580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15575542580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+77026564530dbc29b854@syzkaller.appspotmail.com
Fixes: aa545adbe491 ("ocfs2: annotate flexible array members with __counted_by_le()")

         option from the mount to silence this warning.
=======================================================
JBD2: Ignoring recovery information on journal
ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mode.
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in fs/ocfs2/suballoc.c:380:22
index 0 is out of range for type 'struct ocfs2_chain_rec[] __counted_by(cl_count)' (aka 'struct ocfs2_chain_rec[]')
CPU: 0 UID: 0 PID: 6052 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
 ocfs2_block_group_fill+0x938/0xb30 fs/ocfs2/suballoc.c:380
 ocfs2_block_group_alloc_contig fs/ocfs2/suballoc.c:454 [inline]
 ocfs2_block_group_alloc fs/ocfs2/suballoc.c:699 [inline]
 ocfs2_reserve_suballoc_bits+0x117d/0x4680 fs/ocfs2/suballoc.c:834
 ocfs2_reserve_new_metadata_blocks+0x403/0x940 fs/ocfs2/suballoc.c:984
 ocfs2_expand_inline_dir fs/ocfs2/dir.c:2853 [inline]
 ocfs2_extend_dir+0xc76/0x4870 fs/ocfs2/dir.c:3215
 ocfs2_prepare_dir_for_insert+0x2fdf/0x54b0 fs/ocfs2/dir.c:4320
 ocfs2_mknod+0x819/0x2050 fs/ocfs2/namei.c:297
 ocfs2_mkdir+0x191/0x440 fs/ocfs2/namei.c:659
 vfs_mkdir+0x306/0x510 fs/namei.c:4453
 do_mkdirat+0x247/0x590 fs/namei.c:4486
 __do_sys_mkdirat fs/namei.c:4503 [inline]
 __se_sys_mkdirat fs/namei.c:4501 [inline]
 __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4501
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0917d8d617
Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 02 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff863b0218 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007fff863b02a0 RCX: 00007f0917d8d617
RDX: 00000000000001ff RSI: 0000200000000680 RDI: 00000000ffffff9c
RBP: 0000200000000080 R08: 0000200000000140 R09: 0000000000000000
R10: 0000200000000080 R11: 0000000000000246 R12: 0000200000000680
R13: 00007fff863b0260 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
---[ end trace ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
