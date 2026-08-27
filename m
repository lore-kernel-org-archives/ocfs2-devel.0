Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B367F36494B
	for <ocfs2-devel@lists.linux.dev>; Thu, 27 Aug 2026 01:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787793157; cv=none; b=KlhL8+vpR5cJ8dCAe92QlMfI3mliEO9Blyf6PbabB9XxVG1xanKCUYNNa2JGNjq/ali3JCKqgpbalVG49a7rX3SpejMiImwaLQ69OkXDf4Fzb+TvLr54ua54u/VZiBeWU1ss8wmN7CUxk77vQubcw1++kB8cdJIobWNZ72MkkfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787793157; c=relaxed/simple;
	bh=2coRKFAH9cNqiyhtw07qn9z1W7zhNc9SfXdcE8YBCh4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BvBQG9bd/cJKLsesEVb8gfG+41KsprkQJ3FUep1TrjCv7l8UWfse4MhuojkgUzofeHNtGBiBZpSKg/8hhX05WKLDx5GtoEvtbrAUrSX3tgnq79T6QgMy9WWa3NPpoUO88MdkLIm04gubF4BuP1bqB/OmaOL7i7ElgEz4LHLK2a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f9.google.com with SMTP id 46e09a7af769-7f4ddb9adf4so105412a34.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 26 Aug 2026 18:12:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787793154; x=1788397954;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Itf6RmgjvkhoqwlS5GCnNh75k7jqyc3/y/6VprIuqhQ=;
        b=MIDWABlypuszG58npPSpJsohRizkV1Pb5vukcOhPUpD2jcC9PSiG4MA3f4r7ikf44n
         Vx/u3IKU7wf3G9bJPh+w99dYTXaxaSIQpeamt2Dd8g7tFedc9t3B0l8WmrdIHUeXbYu0
         FdG6P6ypTKGeYvoJYU+irZH2sWJRSr3svNFdICZBtrNlnCmYlUg0e4aCJcJmYhAR1rUx
         4otJZB5EScLC/JhKHCbEl95/B3PjuVUOcdBW/q8omcKFzUqMpvW1nDKF3Ll6zMjPFEkK
         XB6VSRh5yN2SgX1sKNpzG8A2rybWxzcRTjtnGmYt0h1dIShJQJlYaJEwtBpsnJn4AsHC
         762Q==
X-Forwarded-Encrypted: i=1; AHgh+RpKXP3Y/EFJb6dGVCu0Uw+fLV019oMmMiW/Wjpg4enLMTXwjZqJD0U8QTGi2kzHIziQyvc9NzaW8imKbQ==@lists.linux.dev
X-Gm-Message-State: AFuF++nZrmNXx8yhZLWgDmL+Dso4mS1KEWWZbgtrj6Fofii3r4LeHTSm
	wooDudWZBMtYwkSpmyKu+nlsGYNeJ2k3axNio6jzawt363nVxRwkb8Vt/r6Q8kmqzjVgW5Af9Cb
	8HiHzy3wno8HACuShWdcEHVEEWwl5gDnp+4Z+mPr8/LH+QLJaiJHHlIC08K8=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee0e:0:b0:6b0:4170:59ae with SMTP id
 006d021491bc7-6b1a04ffdd4mr10386448eaf.27.1787793154596; Wed, 26 Aug 2026
 18:12:34 -0700 (PDT)
Date: Wed, 26 Aug 2026 18:12:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8f8f02.1d9ded08.62e62.00c1.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING in ocfs2_journal_toggle_dirty
From: syzbot <syzbot+74790b3c813acfbc0b7f@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    66fb95a52111 Merge tag 'caps-pr-20260820' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11575179580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a70bec3546180b6
dashboard link: https://syzkaller.appspot.com/bug?extid=74790b3c813acfbc0b7f
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2292b7113c9e/disk-66fb95a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9e2ef66f55ed/vmlinux-66fb95a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea5109857a36/bzImage-66fb95a5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+74790b3c813acfbc0b7f@syzkaller.appspotmail.com

(syz.0.20,5939,0):ocfs2_shutdown_local_alloc:412 ERROR: status = -117
------------[ cut here ]------------
!OCFS2_IS_VALID_DINODE(fe)
WARNING: fs/ocfs2/journal.c:1029 at ocfs2_journal_toggle_dirty+0x304/0x370 fs/ocfs2/journal.c:1029, CPU#0: syz.0.20/5939
Modules linked in:
CPU: 0 UID: 0 PID: 5939 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:ocfs2_journal_toggle_dirty+0x304/0x370 fs/ocfs2/journal.c:1029
Code: e8 31 fd 14 00 43 c6 44 27 04 f8 e9 43 ff ff ff e8 f1 a4 dc fd e9 39 ff ff ff e8 e7 a4 dc fd e9 2f ff ff ff e8 dd a4 dc fd 90 <0f> 0b 90 bb fb ff ff ff 49 bc 00 00 00 00 00 fc ff df 4c 8b 7c 24
RSP: 0018:ffffc90002e66fa0 EFLAGS: 00010283
RAX: ffffffff83ea84b3 RBX: 1ffff1100ed2dce5 RCX: 0000000000080000
RDX: ffffc90003db9000 RSI: 0000000000056367 RDI: 0000000000056368
RBP: ffffc90002e67070 R08: ffffffff90798137 R09: 1ffffffff20f3026
R10: dffffc0000000000 R11: fffffbfff20f3027 R12: 00000000ffffffff
R13: ffff8880528b6600 R14: ffff88803622ac00 R15: 0000000000000000
FS:  00007fe6cae546c0(0000) GS:ffff888124cfd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33a1eff8 CR3: 0000000054aea000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 ocfs2_journal_shutdown+0x540/0xb70 fs/ocfs2/journal.c:1112
 ocfs2_mount_volume fs/ocfs2/super.c:1784 [inline]
 ocfs2_fill_super+0x59ea/0x6840 fs/ocfs2/super.c:1083
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1887
 vfs_get_tree+0x92/0x2a0 fs/super.c:1947
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3848
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe6c9f9f34a
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe6cae53e58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fe6cae53ee0 RCX: 00007fe6c9f9f34a
RDX: 0000200000004440 RSI: 0000200000000040 RDI: 00007fe6cae53ea0
RBP: 0000200000004440 R08: 00007fe6cae53ee0 R09: 00000000000008c0
R10: 00000000000008c0 R11: 0000000000000246 R12: 0000200000000040
R13: 00007fe6cae53ea0 R14: 0000000000004451 R15: 0000200000000080
 </TASK>


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
