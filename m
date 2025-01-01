Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC5B3C14
	for <ocfs2-devel@lists.linux.dev>; Wed,  1 Jan 2025 08:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735719806; cv=none; b=nP2krICg+W6+ozzVDBld9xwOXcW/TMpOfBXfUO8X72SCTlpMOLr/hwPL/rsp2MOi+nv3QwUJedH0gPIcucQ+AN+cH8Ia6j7cdyhiCCWhcAFjfadLYs3PuSzsZb+60bKiDcMSnm/F7GcovCuXi/C6EhlP13TdL1qiNR+D1QEJX5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735719806; c=relaxed/simple;
	bh=VlMWzn5M+1M+bqnXA6Pe24o+NUIAWVM51MqXZk94NLU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TRkMifsHyHf7A4k3/J4TmKaElEkJLQ1d4XI6/5zT2PnKEWH5qvYY3F49V0wFhHeNpioxPBZNyhjX+CPVOE3TyRO/taUlF4ZmwKtcLdEtQXnSyskQARj2EUqH11f+B5VkYzoAFBiq/EDkXv7TGAIJIfKeLbutgqC0tR0k9gBG+tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a814c7d58eso109665515ab.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 01 Jan 2025 00:23:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735719803; x=1736324603;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8eSkN9JLqj7v8yXx6V452d7x42oU6sSQZhBHf1yV/T8=;
        b=OkkC/RWBWbM1zcivMiBUiJtCnT+LJU/64KsCruzDe88L6fqi4mZkE/GO+D7dtVV35d
         e15iVUaFKmdU909oHudERfSEN1di5EFMOIMCYp2nXnCrRO0hPs5/DSHDzi2H0CJbHgSn
         2qT2diThYqmRsbjNk+R7r4l7QCvI+mHAzpB49fl7a6ykw7gRpR5yaXAHGI83O6z5zlVF
         yASvFesCl8wv5I8tBWhw12MX+bntCZdwilZBWYYaF60E69WFF1NnVXQW7hDJQIOnUO7J
         U13DlXL6jNQOZfmmWZkkwtDG4ASfOWJ013YtOkiClf+vUnqGX7kTgRXxQZxigd87vnU1
         GFzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVq9ypI+cdnZ4xVO9yV9C8Tzmb/7Zjzf0yDSemr16sZPRtpcFoGXs1L+842dXMNLnN6iNEGzrHXZBNHYQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwURGtkB8A9J0bLnPpUq93+2iX+KqRXsEz0qbElIwgfeit6bBn7
	Fa+C6YmuivFdPTGhOvQfBC3voxfkSMxqjFkdx8sHzUwYGhIY09TOAg0dWTri9WBziRiQyMiAih+
	9ZjIN3g6qpwIoBKJJFBQOY8uZ41joRA0c8jG+Ie9Dnv+NTew7rwQRXm0=
X-Google-Smtp-Source: AGHT+IEk7dcMiLJ/uD2JOdOrrrOqqqm4hACMVm7YRL0TzJ1sBwn2omT/OM7n9wXQhH5DO8tAAU4x43AHuA8dIWEyQf6abqWt+lXf
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3891:b0:3a8:1195:f216 with SMTP id
 e9e14a558f8ab-3c2d25770a4mr345529115ab.10.1735719803610; Wed, 01 Jan 2025
 00:23:23 -0800 (PST)
Date: Wed, 01 Jan 2025 00:23:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6774fb7b.050a0220.3a8527.0026.GAE@google.com>
Subject: [syzbot] [ocfs2?] WARNING in dqput
From: syzbot <syzbot+bf75d2e9b63fe9e0c330@syzkaller.appspotmail.com>
To: jack@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=149256df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c541fa8af5c9cc7
dashboard link: https://syzkaller.appspot.com/bug?extid=bf75d2e9b63fe9e0c330
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e5d818580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0ebebb2cf79b/disk-ccb98cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8da8041cbc40/vmlinux-ccb98cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8de730af73c0/bzImage-ccb98cce.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6b4af5111ec5/mount_3.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bf75d2e9b63fe9e0c330@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 9 at fs/quota/dquot.c:880 dqput+0x359/0x490 fs/quota/dquot.c:880
Modules linked in:
CPU: 0 UID: 0 PID: 9 Comm: kworker/0:1 Not tainted 6.13.0-rc5-syzkaller-00004-gccb98ccef0e5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: events qsync_work_fn
RIP: 0010:dqput+0x359/0x490 fs/quota/dquot.c:880
Code: f7 64 ff eb 05 e8 87 f7 64 ff 48 c7 c7 80 58 61 8e 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 6d ef 90 09 e8 68 f7 64 ff 90 <0f> 0b 90 e9 5b fe ff ff 48 c7 c1 2c b1 19 90 80 e1 07 80 c1 03 38
RSP: 0018:ffffc900000e7af0 EFLAGS: 00010293
RAX: ffffffff823a7c78 RBX: ffff888060092c00 RCX: ffff88801c2b0000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: 1ffff1100c012584 R08: ffffffff823a79bc R09: 1ffff1100c0125a2
R10: dffffc0000000000 R11: ffffed100c0125a3 R12: 1ffff1100c0125a2
R13: dffffc0000000000 R14: ffff888060092d10 R15: ffff888060092c20
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a980c62a18 CR3: 0000000032178000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 dquot_scan_active+0x156/0x280 fs/quota/dquot.c:644
 qsync_work_fn+0xa9/0x150 fs/ocfs2/quota_global.c:658
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa68/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


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
