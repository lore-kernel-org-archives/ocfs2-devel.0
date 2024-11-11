Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374F8155325
	for <ocfs2-devel@lists.linux.dev>; Mon, 11 Nov 2024 09:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731318389; cv=none; b=s0LyF3AmzqE+G/DhQrBvYK2cPWUIHdbm7sGwv9ZArTMY9hmocv2nwPZBU3QhjsofkE1Lqx95YmB60vxCjJI+7gqN3cLB+z845eLfh9ytZVx+k6R3KoI5kb8jqVlu1FILa0CN2HSkLX5Hs/CFqGkWyMO/AghH5BEyoxyCQmoixYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731318389; c=relaxed/simple;
	bh=IcdsDmh4lFp0GgeUIjd3e1pf0wxJazod891NpMGBnGw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pONpgNCRIO3oqq3kLjnXsFmfOGHLKe8AA2kYY/0NBTAYICFjWEIOpSic4DhAzNiiadlZdyYrIZ8Rs9/XZrr34sEOEUFq2iWlKGkRQuJHGsjrAAaddiCG9r7gOYz6HQmLeSf0yQn4ce17uQ8UoBSXcVO2nXrkEFlB38p61mCfaqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83acb657f91so547112039f.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 11 Nov 2024 01:46:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731318385; x=1731923185;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=foIUVhk7FPWeE6KKNZvbhWrSDgh7muMDD0HRvNyKrL0=;
        b=rXvit4lSgP8AHqbs2looajOHoCWRUXnBorD4M071vs5lwLZadfe0isyeoyuw23Qt8J
         w8vUyuWh3K0z399ypbqBjeUTiSIamT2+zOWL0G6tLn3pBUJFWXxPq9fEP18UuTkKOvp0
         sFSia46U5m/rTpMclZlx3Tr6rIq+MAjSTfGTtihTMEWZtzoSWrE9yUDCPNAWyZW4tEQK
         nTYIRF/xuP6TcGCct/RwT7b/3m872Yjg9gSX9Ba7KkLRUclrfjBiveXC8ue1SbUydERD
         kOG6pedtcm9X/0d8QMGuQrlej+hSJZtSZmrrGhbrDJ5AO+ETtq1aIExNU8Ysoaor2K1L
         JMPQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6ZB/yy1AJK6OsDJW7B2xUTFUVuSO/nns4U5aot9XSFn5HUSMkPGygo62H4796jQnZb7oLbM/UzcDHsw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxB+TNc+QQiG29h2HNfomtaPoOt1Rm4N7RzMV3QV0aQ8rTXPgNo
	Pb/G9kbOy6ydWfIHjQh58hEj4x8MAumFzB6Nf8079fIIt4yzQNJA2lIEPUE86xf7Jbe9Ph3Ksti
	GZo6tPt0nO+N9ND9O1L+UQOlv7q1YPnJ86gYHX6mFxrOBIHHBz5Lm14U=
X-Google-Smtp-Source: AGHT+IGCNRFOH/at0VfaBcw2KbhCiaj1vzUSgrOlp4Li5ow21+4StNBhRoa4kpQrIhUCVIXNgL6Xh7osxpS7LtV92NhG/CkxCEbu
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1789:b0:3a0:a070:b81 with SMTP id
 e9e14a558f8ab-3a6f1a59322mr108957395ab.23.1731318383710; Mon, 11 Nov 2024
 01:46:23 -0800 (PST)
Date: Mon, 11 Nov 2024 01:46:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6731d26f.050a0220.1fb99c.014b.GAE@google.com>
Subject: [syzbot] [ocfs2?] KASAN: slab-use-after-free Read in ocfs2_lock_global_qf
From: syzbot <syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17bfcc30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41330fd2db03893d
dashboard link: https://syzkaller.appspot.com/bug?extid=d173bf8a5a7faeede34c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d116f71ad0eb/disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bdd6f545b105/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0d26b05e3d7c/bzImage-c2ee9f59.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d173bf8a5a7faeede34c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in ocfs2_lock_global_qf+0xb8/0x2b0 fs/ocfs2/quota_global.c:303
Read of size 8 at addr ffff88805fc78028 by task syz.3.122/6441

CPU: 1 UID: 0 PID: 6441 Comm: syz.3.122 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 ocfs2_lock_global_qf+0xb8/0x2b0 fs/ocfs2/quota_global.c:303
 ocfs2_get_next_id+0x233/0x760 fs/ocfs2/quota_global.c:900
 dquot_get_next_dqblk+0x73/0x3a0 fs/quota/dquot.c:2701
 quota_getnextquota+0x2c5/0x6c0 fs/quota/quota.c:250
 __do_sys_quotactl fs/quota/quota.c:961 [inline]
 __se_sys_quotactl+0x2c4/0xa30 fs/quota/quota.c:917
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f89ffd7dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8a00b48038 EFLAGS: 00000246 ORIG_RAX: 00000000000000b3
RAX: ffffffffffffffda RBX: 00007f89fff35f80 RCX: 00007f89ffd7dff9
RDX: 0000000000000000 RSI: 0000000020000c80 RDI: ffffffff80000900
RBP: 00007f89ffdf0296 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f89fff35f80 R15: 00007fff22979a58
 </TASK>

Allocated by task 6441:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:257 [inline]
 __kmalloc_cache_noprof+0x19c/0x2c0 mm/slub.c:4295
 kmalloc_noprof include/linux/slab.h:878 [inline]
 ocfs2_local_read_info+0x1ee/0x19f0 fs/ocfs2/quota_local.c:699
 dquot_load_quota_sb+0x762/0xbb0 fs/quota/dquot.c:2458
 dquot_load_quota_inode+0x320/0x600 fs/quota/dquot.c:2495
 ocfs2_enable_quotas+0x169/0x450 fs/ocfs2/super.c:926
 ocfs2_fill_super+0x4c8d/0x5750 fs/ocfs2/super.c:1141
 mount_bdev+0x20a/0x2d0 fs/super.c:1679
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6441:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:2342 [inline]
 slab_free mm/slub.c:4579 [inline]
 kfree+0x1a0/0x440 mm/slub.c:4727
 ocfs2_local_free_info+0x81f/0x9a0 fs/ocfs2/quota_local.c:869
 dquot_disable+0x1160/0x1cd0 fs/quota/dquot.c:2303
 dquot_suspend include/linux/quotaops.h:85 [inline]
 ocfs2_susp_quotas+0x16c/0x340 fs/ocfs2/super.c:892
 ocfs2_remount+0x576/0xc30 fs/ocfs2/super.c:647
 reconfigure_super+0x445/0x880 fs/super.c:1083
 do_remount fs/namespace.c:3047 [inline]
 path_mount+0xc22/0xfa0 fs/namespace.c:3826
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88805fc78000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 40 bytes inside of
 freed 1024-byte region [ffff88805fc78000, ffff88805fc78400)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5fc78
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801ac41dc0 ffffea0001e51c00 dead000000000002
raw: 0000000000000000 0000000000100010 00000001f5000000 0000000000000000
head: 00fff00000000040 ffff88801ac41dc0 ffffea0001e51c00 dead000000000002
head: 0000000000000000 0000000000100010 00000001f5000000 0000000000000000
head: 00fff00000000003 ffffea00017f1e01 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x52820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5289, tgid 5289 (kworker/u8:8), ts 91435154744, free_ts 91399801248
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x3039/0x3180 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x120 mm/slub.c:2412
 allocate_slab+0x5a/0x2f0 mm/slub.c:2578
 new_slab mm/slub.c:2631 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3818
 __slab_alloc+0x58/0xa0 mm/slub.c:3908
 __slab_alloc_node mm/slub.c:3961 [inline]
 slab_alloc_node mm/slub.c:4122 [inline]
 __do_kmalloc_node mm/slub.c:4263 [inline]
 __kmalloc_noprof+0x25a/0x400 mm/slub.c:4276
 kmalloc_noprof include/linux/slab.h:882 [inline]
 kzalloc_noprof include/linux/slab.h:1014 [inline]
 ieee802_11_parse_elems_full+0xdb/0x2880 net/mac80211/parse.c:958
 ieee802_11_parse_elems_crc net/mac80211/ieee80211_i.h:2383 [inline]
 ieee802_11_parse_elems net/mac80211/ieee80211_i.h:2390 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1575 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x4c8/0x2d70 net/mac80211/ibss.c:1606
 ieee80211_iface_process_skb net/mac80211/iface.c:1603 [inline]
 ieee80211_iface_work+0x8a5/0xf20 net/mac80211/iface.c:1657
 cfg80211_wiphy_work+0x2db/0x490 net/wireless/core.c:440
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
page last free pid 5574 tgid 5574 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcd0/0xf00 mm/page_alloc.c:2638
 discard_slab mm/slub.c:2677 [inline]
 __put_partials+0xeb/0x130 mm/slub.c:3145
 put_cpu_partial+0x17c/0x250 mm/slub.c:3220
 __slab_free+0x2ea/0x3d0 mm/slub.c:4449
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4085 [inline]
 slab_alloc_node mm/slub.c:4134 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4141
 getname_flags+0xb7/0x540 fs/namei.c:139
 user_path_at+0x24/0x60 fs/namei.c:3015
 do_faccessat+0x5e2/0xb80 fs/open.c:493
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88805fc77f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88805fc77f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88805fc78000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88805fc78080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88805fc78100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


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
