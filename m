Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853E537F30C
	for <ocfs2-devel@lists.linux.dev>; Sat,  8 Aug 2026 19:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786218998; cv=none; b=VAeoYMpo6DB1L1mrpSy66vIwvvAOEuK2DMz0xqJuq4mRqgjtC1uzCg9BY+oKPJbbo/x1i00GRb70cRwiWdI26f/7BY7nfY1VJ7X85/B1r5OED1r96tTS0Zsd15LKvt+LRcGEOhxBVIfPWpOzXExq9eW4Bm5amYXoTtGyLju0Enw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786218998; c=relaxed/simple;
	bh=4USWwJ4VuY7cb4SR+FDPLiklcUk+KRHo8GTq7vcuYII=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=EPYDCzrngBAfZZSHXF8FOjSEpgkyfJ+NPnMI8Wwb0Saqvdb0bLlXKIJNbv9Ohfg1BASEn7EMHy5ow/FJvBx71SHxv8PSIe3rRLM/oIw+xE7raiTK8Im7rDCTqSRB24NZ5V39/GE0x9AGlm4iuDwHd8PHah563AtdslSjkvM0gMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-4a485034d01so1034282b6e.3
        for <ocfs2-devel@lists.linux.dev>; Sat, 08 Aug 2026 12:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786218995; x=1786823795;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xOxQZSHFJola13Rx9uubIkF7+lBAUwvnbdqbxErfNzs=;
        b=E79IPhJAnqvK4XEC4RkcJQITF5YD95QKyhr6SxpBI+hFhQ2GEqfDMBZ5EKRdV3tUz5
         8ibxVJ1pgrCQnpOojOuXr12gwkLEMaM0fmqgHpxaebyf1YOuaaivvqO/JNhKDvXuwhaF
         hbM9ZW/nnbY6MI5i1mfeVpcOhCjU5Ov6BZdDElf0hHtrkQnjHExeNdjrkBBKJLkbY1P3
         Xc+vv/lDVYKdsC7FUDXSsFT9SW/Th3kJcVm1juMlpd/BpeWepmiWW0jlKDWDj+oD3ZCm
         Y1YX2Iue6fg3zqKNvv5CbGpiVYV082wHE0a3NlMpOXVCzr1YeEPUlVU8zUjEBn96l0Dy
         LnYw==
X-Forwarded-Encrypted: i=1; AHgh+RqWg3udv8Da30Gr5y6v9z82coHegcMCGBOoxMGYVMdIHPXKoDiiDl8bciHXYc8krZyltiChbUgqOgTPsw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwmFp4NttQr61gpxdRul8etUEEgerQhBla+PlZtQQaR8YMLqryS
	cF4AGI62x2ZYDCs9ZjWFPTh0QjYhVsqgHYHYUArZHQ1+C4a/RbEY+9araNgZrVA30MgJ4JeoT4Z
	MjmzTcALzWQLxERTde7Z9BaspU/G7FMzbT4VCM5ll57lLmOl5yeomHVUvFcA=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f4a:b0:497:d3d6:6a56 with SMTP id
 5614622812f47-4b1ab35240cmr6357081b6e.0.1786218995458; Sat, 08 Aug 2026
 12:56:35 -0700 (PDT)
Date: Sat, 08 Aug 2026 12:56:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7789f3.01d0871a.3a0d52.0067.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: null-ptr-deref Write in fput
From: syzbot <syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    848acc8ffe1b Merge tag 'fsverity-for-linus' of git://git.k..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=149d7649580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
dashboard link: https://syzkaller.appspot.com/bug?extid=5d4e96acd0febccb5e87
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e46cc6580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150d7e32580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/32c9dc084aaa/disk-848acc8f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b7604244b0a9/vmlinux-848acc8f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4cd321f6fe47/bzImage-848acc8f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d4e96acd0febccb5e87@syzkaller.appspotmail.com

(syz-executor157,5664,1):o2hb_bio_end_io:499 ERROR: IO Error 10
(syz-executor157,5664,1):o2hb_region_dev_store:1850 ERROR: status = -5
==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
BUG: KASAN: null-ptr-deref in atomic_long_dec_return include/linux/atomic/atomic-instrumented.h:3766 [inline]
BUG: KASAN: null-ptr-deref in file_ref_put include/linux/file_ref.h:157 [inline]
BUG: KASAN: null-ptr-deref in fput+0x2e/0x100 fs/file_table.c:588
Write of size 8 at addr 0000000000000158 by task syz-executor157/5664

CPU: 1 UID: 0 PID: 5664 Comm: syz-executor157 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:186 [inline]
 kasan_check_range+0x10f/0x1e0 mm/kasan/generic.c:200
 instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
 atomic_long_dec_return include/linux/atomic/atomic-instrumented.h:3766 [inline]
 file_ref_put include/linux/file_ref.h:157 [inline]
 fput+0x2e/0x100 fs/file_table.c:588
 o2hb_region_dev_store+0x1230/0x1bc0 fs/ocfs2/cluster/heartbeat.c:1935
 flush_write_buffer fs/configfs/file.c:207 [inline]
 configfs_write_iter+0x302/0x4e0 fs/configfs/file.c:229
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x6ac/0x1050 fs/read_write.c:687
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd8eccb5ab9
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc7d881e78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000200000000540 RCX: 00007fd8eccb5ab9
RDX: 0000000000000001 RSI: 00002000000005c0 RDI: 0000000000000004
RBP: 0030706f6f6c2f2e R08: 0000000000000009 R09: 0000000000000009
R10: 0000000000000009 R11: 0000000000000246 R12: 000000000001009b
R13: 00007ffc7d881e8c R14: 00007ffc7d881ea0 R15: 0000200000000008
 </TASK>
==================================================================


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
