Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26232744F
	for <ocfs2-devel@lists.linux.dev>; Thu, 11 Dec 2025 02:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765419627; cv=none; b=XG/jLuVcbS2bxq8hz430764lpBg4MoorlFjR/0AfCds5010xIpg+JOLWcl27m9gu86e3HFVHk6CyghK+OpEz98FoM8txPaUmgtuY3I8hvcpeYeV0u0ssWwIrYWlq6d7XHydmo+j49qk4WHjgWLGLrTZjTrpVyuXwfriA1DdcBxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765419627; c=relaxed/simple;
	bh=uAh3SX7bUKL+34oYxYCTvZ6/dYmXtLjDb3iocGqe7Qs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CE2P/Z2boXkGypZ3Gzie5omgriXyl74IXSmZpkMGjdoDRYra2yEnMyhqnD5Z0WeBra8UrBXGVFWRN09JqzVoht6vnPrEr8Un8wRJ3puLtxUo064t98D/YyTlgd6UvpvK7IxUYuOTCqYCqG242JT17v7nQfnlunLYO8Q3c/ko9GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-6597c514eddso402393eaf.1
        for <ocfs2-devel@lists.linux.dev>; Wed, 10 Dec 2025 18:20:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765419625; x=1766024425;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i53Vsj8Q8r6Bs88aHx1o/1OfZw6DtuQiltggdysWbI8=;
        b=svox75mxgLaJa8uWk1VM3qN7IlN/Sm3k39JViSJOIUBYrLDNjXWsl5A3KthW7AtA6s
         WMYmlp/5ihN3j72YECVupBU6xn7Lt1Gi1HrMJYXiwRYJatvTa7Q/kEAtJ+P6gBFvxOmL
         uPJumqiyRd4dvOpmPZu2HqlmeTHMx5CkJ1IeefqRPf+1W0t1SQEj8boUD+EWGxo9O2PZ
         sES57fFOSOU9DmdLHFmD5GJNzqSmB8MJ/O3HPtnPM4Iz8HgSo8Qjkf4wHG58YHg5tEGr
         fd3Rba1TXBY0VNRt55Mk46t1EDK8dlyDsmoLEt8+vqrbWUMGhhe87iW3lkXXs5Shqs2+
         LE0A==
X-Forwarded-Encrypted: i=1; AJvYcCUynpGGvthnHQFdnyndlWETrYAV+ohFp7SXCTq1EeB7hN0kC+fWsr/W43nfGpvnn8QFTm2ES3if77qPxw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwaqV4kkhaXIVD+RFBM9A9glex+lzNQs6tlEnEjFf1nDigyNF4R
	tnebBQIKTaj3rNPwsUdHjLE7sdFMEeVbcUg8LYfEh6RLGs2vHTsw9HA6v3FlUWJ5QW3V9PV88pt
	7iom5yL41YyOVIyvvh4Uk71Rz/FVmHk+Z8dDGdL1jG1aaEA+O2o9jxDVnV8s=
X-Google-Smtp-Source: AGHT+IFoJmyIFvFVsGpWEMg4HPMEtEaNURt3N35jtewc5P3LMAUlsEfFSEEgtqE6GEPIt0Y9DN3Ap8mu05R6SMNKfg7xToi3xJLa
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c83:b0:659:9a49:909d with SMTP id
 006d021491bc7-65b2ac52747mr2811368eaf.28.1765419624796; Wed, 10 Dec 2025
 18:20:24 -0800 (PST)
Date: Wed, 10 Dec 2025 18:20:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693a2a68.050a0220.4004e.02c1.GAE@google.com>
Subject: [syzbot] [ocfs2?] UBSAN: array-index-out-of-bounds in ocfs2_grow_tree
From: syzbot <syzbot+7c93eb455e59ca14c7cd@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0048fbb4011e Merge tag 'locking-futex-2025-12-10' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16457992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de48dccdf203ea90
dashboard link: https://syzkaller.appspot.com/bug?extid=7c93eb455e59ca14c7cd
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-0048fbb4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d7e936edc53d/vmlinux-0048fbb4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/84b695b1f82c/bzImage-0048fbb4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7c93eb455e59ca14c7cd@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:1090:9
index -1 is out of range for type 'struct ocfs2_extent_rec[] __counted_by(l_count)' (aka 'struct ocfs2_extent_rec[]')
CPU: 0 UID: 0 PID: 5338 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
 ocfs2_sum_rightmost_rec fs/ocfs2/alloc.c:1090 [inline]
 ocfs2_shift_tree_depth fs/ocfs2/alloc.c:1412 [inline]
 ocfs2_grow_tree+0x35af/0x3dc0 fs/ocfs2/alloc.c:1560
 ocfs2_insert_extent+0xb54/0x15a0 fs/ocfs2/alloc.c:4755
 ocfs2_add_clusters_in_btree+0x64f/0xf50 fs/ocfs2/alloc.c:4857
 ocfs2_add_inode_data+0xce/0x120 fs/ocfs2/file.c:550
 ocfs2_write_cluster fs/ocfs2/aops.c:1115 [inline]
 ocfs2_write_cluster_by_desc+0x547/0x1cf0 fs/ocfs2/aops.c:1219
 ocfs2_write_begin_nolock+0x3180/0x4300 fs/ocfs2/aops.c:1796
 ocfs2_write_begin+0x1bb/0x310 fs/ocfs2/aops.c:1884
 generic_perform_write+0x2c5/0x900 mm/filemap.c:4314
 ocfs2_file_write_iter+0x1582/0x1cf0 fs/ocfs2/file.c:2469
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6962b8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6963a6b038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f6962de6090 RCX: 00007f6962b8f7c9
RDX: 0000000000000140 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00007f6962c13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6962de6128 R14: 00007f6962de6090 R15: 00007ffc0ec42858
 </TASK>
---[ end trace ]---


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
