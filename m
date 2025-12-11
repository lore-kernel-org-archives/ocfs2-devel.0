Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1CA274FD0
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 06:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765434145; cv=none; b=necVHRCjuMBulql1oF9yjgd3TTSjjPr5MpXDvLtTr0E4dk9Nc1x/Hu0hk9A1/ydAWSIkISBb64XvnBbIKjJTBxj/brpgZxP0ZzR5HP1irUIRJ4y3+BJnzsesztDNZhkZOOUBkRc1iS0L35X6D2JVXdrX5t1Rae72UEJ/CGH4ulA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765434145; c=relaxed/simple;
	bh=5bQ0KsnB/qglTWngqw67oFO+8bYuSjYWXxKix/EDrkk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CiNld49aIEJj2C08kOnAjZW/nVSqKulIDaGMS+uV3jxtHnXmcp4BtCjfpQPTgQeSrehLbcQNu72RBTPBCCp2AsNXjUwnPrYQz7esHULKqdUqESZ8ONlzZb+cPWOJ/+jZcWvDLqSivI7/YFsBhj4/j0u3jtgr6Bp1S1Kuby0YJ1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65746235dd4so426284eaf.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 22:22:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765434143; x=1766038943;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0qF5cd6NEUFRS42JZM5CAKpN8bz/A2ljT9mLJyiZWhE=;
        b=hB/kPxhKERlocO+csaYqpvyt13qxusPBnJdfmJgo2P3dwrNACYiAnFlHsk0ZmgW0rV
         YiSMYdcKgzhiyJq6Qv2pV2WIsWOMZCjx9zewAYZwOpHgBINq9zdJGsyMyfxsyrtGaO9y
         t4MreX3jH+rLfyzLiItOPSmgaCPI4QBO7AzP0fuwfr+WTJPv2oIBRSz7B/qkjILFNOg3
         9m1SGqQTeUY4QjkEeMSSO2k6Dq/oa3xRENf8mBSVBrsRfsUlg6D/9kgP7dF5k+NCeN8w
         aOv26mMelB9N0seGGz9jvoIEy/x0dLoPZZaUUwTyVdfmmGOCi6O4YkWFq3PHy7JT0vuL
         1tog==
X-Forwarded-Encrypted: i=1; AJvYcCUv8SUb2O2TLeg7hTKyXCvvvFNOCSJ/hFtzmlaCkTaTT8nJJ7K1c2S5N/q4UJidHxI7MdHQC5qLdmuVUQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5YKxblBf3ZEWWsyy1yVzpWwsftzHWB4X3xvA24R8A6uBgOGp1
	aV3Q1F+dXup7toDboGktvNSwJY+rE3J7a/SE/nIYYEUeouyT3RgL/YgdJoVXT3fB+m21hPDTJEJ
	pBNW/zSQNM6eGVHemvAb7YdZjv3HXIKI8lxD7eFEojKRxqzTn0utyVIKhmV0=
X-Google-Smtp-Source: AGHT+IF93rsDM4zwk+P1yWzIgigi6aYBnRnK/zfX3tMMJ0NDtYOf7m3frmgxV40hFPgLEEu6ORenVoDSx25tk0s2Ms4v2BctXqQp
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:813:b0:659:9a49:8e7d with SMTP id
 006d021491bc7-65b2ad1d13cmr2905414eaf.77.1765434142959; Wed, 10 Dec 2025
 22:22:22 -0800 (PST)
Date: Wed, 10 Dec 2025 22:22:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693a631e.a70a0220.33cd7b.0028.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: use-after-free Read in ocfs2_check_dir_entry
From: syzbot <syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cfd4039213e7 Merge tag 'io_uring-6.19-20251208' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=149b5992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8750900a7c493a0b
dashboard link: https://syzkaller.appspot.com/bug?extid=c897823f699449cc3eb4
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f1aec2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e32a1a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/57e430560492/disk-cfd40392.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9d30cdb15e4b/vmlinux-cfd40392.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea35480882e2/bzImage-cfd40392.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/494d52f48e7a/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=12f1aec2580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c897823f699449cc3eb4@syzkaller.appspotmail.com

(kworker/u8:17,3565,1):ocfs2_read_blocks_sync:112 ERROR: status = -12
(kworker/u8:17,3565,1):ocfs2_read_locked_inode:599 ERROR: status = -12
==================================================================
BUG: KASAN: use-after-free in ocfs2_check_dir_entry+0x3a0/0x480 fs/ocfs2/dir.c:318
Read of size 2 at addr ffff888052e81780 by task kworker/u8:17/3565

CPU: 1 UID: 0 PID: 3565 Comm: kworker/u8:17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Workqueue: ocfs2_wq ocfs2_complete_recovery
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 ocfs2_check_dir_entry+0x3a0/0x480 fs/ocfs2/dir.c:318
 ocfs2_dir_foreach_blk_id fs/ocfs2/dir.c:1826 [inline]
 ocfs2_dir_foreach_blk+0xfff/0x1420 fs/ocfs2/dir.c:1954
 ocfs2_dir_foreach+0x42/0x70 fs/ocfs2/dir.c:1965
 ocfs2_queue_orphans fs/ocfs2/journal.c:2215 [inline]
 ocfs2_recover_orphans fs/ocfs2/journal.c:2299 [inline]
 ocfs2_complete_recovery+0xc37/0x20b0 fs/ocfs2/journal.c:1366
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xad1/0x1770 kernel/workqueue.c:3340
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3421
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x5c2 pfn:0x52e81
flags: 0x80000000000000(node=0|zone=1)
raw: 0080000000000000 ffffea00014ba088 ffffea00014ba008 0000000000000000
raw: 00000000000005c2 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 6060, tgid 6060 (syz.2.19), ts 112783813754, free_ts 113851953043
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x234/0x290 mm/page_alloc.c:1846
 prep_new_page mm/page_alloc.c:1854 [inline]
 get_page_from_freelist+0x28c0/0x2960 mm/page_alloc.c:3915
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5210
 alloc_pages_mpol+0xd1/0x380 mm/mempolicy.c:2486
 folio_alloc_mpol_noprof+0x39/0xe0 mm/mempolicy.c:2505
 shmem_alloc_folio mm/shmem.c:1890 [inline]
 shmem_alloc_and_add_folio mm/shmem.c:1932 [inline]
 shmem_get_folio_gfp+0x633/0x1a70 mm/shmem.c:2556
 shmem_get_folio mm/shmem.c:2662 [inline]
 shmem_write_begin+0x166/0x320 mm/shmem.c:3315
 generic_perform_write+0x29d/0x8c0 mm/filemap.c:4314
 shmem_file_write_iter+0xfb/0x120 mm/shmem.c:3490
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5d5/0xb40 fs/read_write.c:686
 ksys_write+0x14b/0x260 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5931 tgid 5931 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 free_unref_folios+0xc28/0x1810 mm/page_alloc.c:3000
 folios_put_refs+0x569/0x670 mm/swap.c:1002
 folio_batch_release include/linux/pagevec.h:101 [inline]
 shmem_undo_range+0x49e/0x1490 mm/shmem.c:1137
 shmem_truncate_range mm/shmem.c:1249 [inline]
 shmem_evict_inode+0x26e/0xa70 mm/shmem.c:1379
 evict+0x5f4/0xae0 fs/inode.c:837
 __dentry_kill+0x209/0x660 fs/dcache.c:670
 finish_dput+0xc9/0x480 fs/dcache.c:879
 __fput+0x69d/0xa80 fs/file_table.c:476
 task_work_run+0x1d4/0x260 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0xff/0x4f0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888052e81680: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888052e81700: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888052e81780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff888052e81800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888052e81880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
