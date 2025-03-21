Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322561D5174
	for <ocfs2-devel@lists.linux.dev>; Fri, 21 Mar 2025 20:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742590355; cv=none; b=jBjOF65Lcd4Y1Fx8UqVtf/lJZIcHTLn88HDS940SzfaItBAzL0fmNrr+27zkJShObYnbf4aXQ05pkvpASPS6z25s3n6TkSzA7EynBy7hqeY5wYXGJKDA+GWGnCZOMWSUIw4Gjml8jb3LIjFBn3rgBhtTaai4DZsGFVtZMAOdgoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742590355; c=relaxed/simple;
	bh=cEeHfF389YJJ77d+pLffUqBUg+SjwSCK7+5MeXmENsI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=k3rI9ZVheYl7k3Jd3ZqppVAJOz/OgvM4vqy5KdcbuhwWaxl/uowk9SsB4JkkOdP+x/vcNRbpcaPF/PZDpoETPuT8ewStVyB9UnIRaAh5hdf3AgvUAjU1ycBebHmMngEydkqwQGt+tpoE5oDYiM9uCDccDwIkVcDeqsUxAFUhEj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d2b3882febso21469945ab.1
        for <ocfs2-devel@lists.linux.dev>; Fri, 21 Mar 2025 13:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742590353; x=1743195153;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h78MLdZ+nHhjTPfp8MYeVUe2SK0b8Rg0EhTM48s1c2U=;
        b=ZJl1svxh9Bu1Iw+AD5YuX0JCn9q6eWeWGfNg7/lfL6RzCAqELkHoiaikPxB403udGj
         +mWES5OY2/Hj51hSyJjl5EYMLf5XY+0MMJN3oksFIMR9sHY2G6yA3zKyb0FKI3da6eFy
         aRrUVebxigtIUaqZ/9bug2D/o3YCTdMEh2AY7+/+qsVGyCdT18veY6NvtaWACswAY8iA
         OTTwWhBeVoXsY9z71G0Rj5ii8KhoM5dKxozyf1RAHhBoWRd4JGmIaP4/AFjspqXIv1NG
         bALeN29n7O4RGXRpn+BiuPpD2bAyQ6rxeoa/6p9U2zXx/2XMgTFwa9uCY7VSTOI0vVOG
         4WoA==
X-Forwarded-Encrypted: i=1; AJvYcCXpB1YAmZnJEEyEWXGvIoxTH28euk110uQ/NlHwbwrOTqJVmRrIdhuUS0ofxEIqgCz20YkgY0BMqJKZCg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyIT6mdehIWd+3P1WSABPZn5xwH2+QA2L8/IBlArFn+ygynKJ3S
	Y+A4BItH0pFIxJ7SqKZlZtIyFoq322fea3bBPh7Am1A6zo9cPfIvuVsh0ZeIlXltbZaqoIMfTqP
	FZixU083z1P+UVjMnyl7Y9ralizPkokEpw3PazZFT+ZeDYWK8HzZc2U0=
X-Google-Smtp-Source: AGHT+IHNzs3AoAiAn+Jmmpq61eppd95WGDpwVLyXgU7nqyiiUH+UikNyqswo2o99q4HUv5sQuCgS9mFR1C3VWRgsfD6HijwewMPt
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1908:b0:3d0:47cf:869c with SMTP id
 e9e14a558f8ab-3d59617bb79mr50728885ab.19.1742590353311; Fri, 21 Mar 2025
 13:52:33 -0700 (PDT)
Date: Fri, 21 Mar 2025 13:52:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ddd191.050a0220.25ae54.006a.GAE@google.com>
Subject: [syzbot] [ocfs2?] KMSAN: uninit-value in _find_next_bit
From: syzbot <syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    76b6905c11fd Merge tag 'mm-hotfixes-stable-2025-03-17-20-0..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16e3c5e4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1d4644c4063c5098
dashboard link: https://syzkaller.appspot.com/bug?extid=7ea0b96c4ddb49fd1a70
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10060a78580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137eb19b980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/65bb985940e1/disk-76b6905c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0f4133d60a27/vmlinux-76b6905c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0ca5769b6e70/bzImage-76b6905c.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d3375a361225/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=108c9068580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com

BUG: KMSAN: uninit-value in _find_next_bit+0x11c/0x130 lib/find_bit.c:145
 _find_next_bit+0x11c/0x130 lib/find_bit.c:145
 find_next_bit include/linux/find.h:69 [inline]
 ocfs2_recover_local_quota_file fs/ocfs2/quota_local.c:488 [inline]
 ocfs2_finish_quota_recovery+0xc4f/0x3ea0 fs/ocfs2/quota_local.c:641
 ocfs2_complete_recovery+0x229f/0x38a0 fs/ocfs2/journal.c:1357
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xc1a/0x1e80 kernel/workqueue.c:3319
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3400
 kthread+0x6b9/0xef0 kernel/kthread.c:464
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4121 [inline]
 slab_alloc_node mm/slub.c:4164 [inline]
 __do_kmalloc_node mm/slub.c:4293 [inline]
 __kmalloc_noprof+0x923/0x1230 mm/slub.c:4306
 kmalloc_noprof include/linux/slab.h:905 [inline]
 ocfs2_add_recovery_chunk fs/ocfs2/quota_local.c:305 [inline]
 ocfs2_recovery_load_quota+0x415/0x1150 fs/ocfs2/quota_local.c:360
 ocfs2_local_read_info+0x139e/0x2c10 fs/ocfs2/quota_local.c:753
 dquot_load_quota_sb+0xa35/0xdc0 fs/quota/dquot.c:2459
 dquot_load_quota_inode+0x662/0x9f0 fs/quota/dquot.c:2496
 ocfs2_enable_quotas+0x1d4/0x6e0 fs/ocfs2/super.c:930
 ocfs2_fill_super+0xa6b7/0xb550 fs/ocfs2/super.c:1140
 get_tree_bdev_flags+0x6ec/0x910 fs/super.c:1636
 get_tree_bdev+0x37/0x50 fs/super.c:1659
 ocfs2_get_tree+0x34/0x40 fs/ocfs2/super.c:1184
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1814
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3560
 path_mount+0x742/0x1f10 fs/namespace.c:3887
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x71f/0x800 fs/namespace.c:4088
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:4088
 x64_sys_call+0x39bf/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 3555 Comm: kworker/u8:11 Not tainted 6.14.0-rc7-syzkaller-00067-g76b6905c11fd #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Workqueue: ocfs2_wq ocfs2_complete_recovery
=====================================================


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
