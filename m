Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A26314B6D
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 09:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765791274; cv=none; b=XOkIpzxE3szBPD8qeUbnZ2YGpSDHXZq5vtWRhtUJJW9wPZdDc6WORaYK+9z3pbd9x6M0Nf/Sf6TUmMAXe7m84GRNqz72av38bZhDttKS4IyzWXmhB77Ujtzzyea//bExPxZCTmwr+oQwuE6KtNG7La2O//V7FnUuqRmhQ7qlybs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765791274; c=relaxed/simple;
	bh=QRyGzB+EbjeIiwe3c/fQ1YLbpH8CfdFuN6GJ3Ltxj4w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VamtRq+ksIq9yrD8DHgN/G/tl2hsqrZ2rY1BeH3MvWb2o5qNXdV0184s3GlfvCwtJyTh1+TlsuHKLY0NJqq4VfJMAzXpf7MSMiZ0+NKZf1kEIrQesYsOXgi5kU8WE8nSBu/RSGlnxxRV793KkDHQ3bdqSi8T+YfBGxOyKcYcCh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-656ceb0c967so2936278eaf.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 01:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765791272; x=1766396072;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SXNRqAOt/kGMoNuyR1E9hcgA4j9rZXVPNcRdES+Wm+Y=;
        b=dKNvtRskNbG7RW8Tn/9SE6jDIhWgneKaTv6klTvakwruJyWF51PpFXS92iXH/ykrzd
         u/Jh7J1i3eXQznG2NLK8qRvMJkhhWLqUeh/uNby4BEH0PxIN1k+ii3JiHdyNm798gVbQ
         dYRFhKrLEIwcYZjuQUohaYSTnIjbLoM8NF/K0stjnk4ghdFmL8gugDU7Q2LC9cdiZdbM
         J1+haEC2mfiBhZfkH57oxu1eFlA/jpBlRVi1HAGcfolhAWgz7FlmO8baQZKom1eL8Fub
         pehYXt+gbQH6m8iAxt6r7WLYMNHDUUq4SurkogBpE9Dz5zxTiW6IpKemwVmIfVHGoQ8F
         L49w==
X-Forwarded-Encrypted: i=1; AJvYcCVmtiJxUYbhJ/2Vxs0EwYEwMpuVlZqZVIAIIOOa1sIAnxVtelXmJ2RDlXDsgg9MEiOorlRtCLxwSeKLNA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwHjnpmfeKyP5tninqczvWGzUUIQg/BphhPDtOLEpv/KCbaEmDG
	k4mtm8f/zeiNDnZ6VqPpc8/vGZanROmo7OUusXvv/aCt5Vo1xahhD6XBNv1uThU6W+iQlN958I3
	g9Sr1rVdP7rox9pb+fOy4etprkcO29Wk6v4o/YOmb2PEOCV4g1ub6ordOOhQ=
X-Google-Smtp-Source: AGHT+IGwjvK+4RtmLgYu3rGt8hxCVbxSDIYSTeJr/1mO06gsWiO463Xia8Qz8DhpS9eMgPH0v9K3fRR98Ivfw5k8AVULarPpLAs7
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b98:b0:659:9a49:8de1 with SMTP id
 006d021491bc7-65b451901bfmr4449737eaf.35.1765791271794; Mon, 15 Dec 2025
 01:34:31 -0800 (PST)
Date: Mon, 15 Dec 2025 01:34:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693fd627.a70a0220.33cd7b.00f4.GAE@google.com>
Subject: [syzbot] [ocfs2?] UBSAN: array-index-out-of-bounds in __ocfs2_find_path
From: syzbot <syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d358e5254674 Merge tag 'for-6.19/dm-changes' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15800592580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f315601b98a91c0b
dashboard link: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148d91c2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c3161a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/605b74c6e6cd/disk-d358e525.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ec0e108fb585/vmlinux-d358e525.xz
kernel image: https://storage.googleapis.com/syzbot-assets/29e316e5a13d/bzImage-d358e525.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2f95504bd292/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=14ec261a580000)

Bisection is inconclusive: the first bad commit could be any of:

2f26f58df041 ocfs2: annotate flexible array members with __counted_by_le()
cd4eaccc00d7 treewide: drop outdated compiler version remarks in Kconfig help texts
1b34743c31fe ocfs2: add extra consistency check to ocfs2_dx_dir_lookup_rec()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=109551c2580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:1838:11
index 0 is out of range for type 'struct ocfs2_extent_rec[] __counted_by(l_count)' (aka 'struct ocfs2_extent_rec[]')
CPU: 0 UID: 0 PID: 6062 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
 __ocfs2_find_path+0x606/0xa40 fs/ocfs2/alloc.c:1838
 ocfs2_find_leaf+0xab/0x1c0 fs/ocfs2/alloc.c:1946
 ocfs2_get_clusters_nocache+0x172/0xc60 fs/ocfs2/extent_map.c:418
 ocfs2_get_clusters+0x505/0xa70 fs/ocfs2/extent_map.c:631
 ocfs2_extent_map_get_blocks+0x202/0x6a0 fs/ocfs2/extent_map.c:678
 ocfs2_read_virt_blocks+0x286/0x930 fs/ocfs2/extent_map.c:1001
 ocfs2_read_dir_block fs/ocfs2/dir.c:521 [inline]
 ocfs2_find_entry_el fs/ocfs2/dir.c:728 [inline]
 ocfs2_find_entry+0x3e4/0x2090 fs/ocfs2/dir.c:1120
 ocfs2_find_files_on_disk+0xdf/0x310 fs/ocfs2/dir.c:2023
 ocfs2_lookup_ino_from_name+0x52/0x100 fs/ocfs2/dir.c:2045
 _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:136 [inline]
 ocfs2_get_system_file_inode+0x326/0x770 fs/ocfs2/sysfile.c:112
 ocfs2_init_global_system_inodes+0x319/0x660 fs/ocfs2/super.c:461
 ocfs2_initialize_super fs/ocfs2/super.c:2196 [inline]
 ocfs2_fill_super+0x4432/0x65b0 fs/ocfs2/super.c:993
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
 vfs_get_tree+0x92/0x2a0 fs/super.c:1751
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3636 [inline]
 do_new_mount+0x302/0xa10 fs/namespace.c:3712
 do_mount fs/namespace.c:4035 [inline]
 __do_sys_mount fs/namespace.c:4224 [inline]
 __se_sys_mount+0x313/0x410 fs/namespace.c:4201
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6175f30eea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffefc9145f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffefc914680 RCX: 00007f6175f30eea
RDX: 0000200000004440 RSI: 0000200000000340 RDI: 00007ffefc914640
RBP: 0000200000004440 R08: 00007ffefc914680 R09: 0000000000004000
R10: 0000000000004000 R11: 0000000000000246 R12: 0000200000000340
R13: 00007ffefc914640 R14: 0000000000004463 R15: 0000200000000300
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
