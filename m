Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C1E146D65
	for <ocfs2-devel@lists.linux.dev>; Wed, 25 Sep 2024 01:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727227708; cv=none; b=fy2fABNDv6lTjzP7OodBmGsDSx9PvbvtV2ctr57WHw5rdQf7BXG71Rtyb+twUBqoj5x2r/VZhrM0nz7fTsALvDjhDCcYFe46H+MtM1SWIzAQ9bMJEGtihuuBW50EhghX+P204Fip4Zzn0UXdqQ8zx7GHFd7cWm4+/Er8XSoeGOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727227708; c=relaxed/simple;
	bh=5n942yHYYWOIIk0LfIm2nfmYfyORxFjSQXjeLhFsLV8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=O4cxBQzTm+n/FgDbCDaOjYKWprE+JOMEYC0K5UgtHyyDzGHiXp1dos1f7DnZ1XOA9YVKqKDOm4FkCnMPfOfk/8rE7K2+Q5ZBz6zM7if+Vrjo7neFrTseqamkN0UK6EVn2bMMrHfgwtf5ftaQe1B/EcoG0/x4moY9Q1hdjJJczBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-82aa3527331so626781939f.0
        for <ocfs2-devel@lists.linux.dev>; Tue, 24 Sep 2024 18:28:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727227705; x=1727832505;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6iVNGliU2YEWa4+d/A9WhHN0EgbELWDz/lD1nQdQndo=;
        b=kflkTGOLVIxIiRZHKbH1cYzkOXI5+dqz2yY6cHAjzb7Zeg/PtISHxAeBb42ReE4IpS
         xt++q0bI2qReSQ1Z8gxdako3QA49SSHJIuCpUco49AEeNquyMX+QfX75ja9NIIirBOuQ
         vjdt8PIsZ0Dc2WzmFDZKriOQIN9tXqQ57KWdKRxdKYpKgaOHZWhGF/O9yrayMp1Cblfy
         JDWoUIlfgrGusmm82XGQZUG/VCD4tzOSG/6riStGkOnkEpkifIlj5eH2E0jrORd2+RgH
         dGoYT10NssFkxQtu3IfUaUCzXkUjtgJlRkZH+w3+42M4jREITqEQ4/qWAeNXB2ntMDcf
         6Peg==
X-Forwarded-Encrypted: i=1; AJvYcCW/j7rS0GDqig8YSIQw42atfKScpZDWSacvU7e97XTtKmA9R0UqUDxprWLSBxM5p2YUKlLqndKKywXKew==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5o2/VC7egDIy2QvWmiWKeh3qKmAvNUXOZsyK65DxCHq2XgcXF
	xQG0sSWRRWbYot53xcRZ0i38wa3ugfyjv8rdBabeeWpbi+sd13Xmey1c0Ghir6KbKjej3hCXe9c
	x2hxTWGGYXJrkqtZBRWytodGum8Pm/9SztHYgZv2Xd+njuOap7DC57xI=
X-Google-Smtp-Source: AGHT+IGcKJDS1W6/v9uEM44JZcc/aG8tZxBooFdmswhFeCLD7+c5rrnNFzYQiO/fRcwKR+Wa7SNMU3bLrJhzxmxLr80gpNQf2bCY
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d97:b0:3a0:90c7:f1b with SMTP id
 e9e14a558f8ab-3a26d773085mr12755805ab.12.1727227705228; Tue, 24 Sep 2024
 18:28:25 -0700 (PDT)
Date: Tue, 24 Sep 2024 18:28:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f36739.050a0220.30ac7d.0004.GAE@google.com>
Subject: [syzbot] [ocfs2?] KMSAN: uninit-value in ocfs2_get_block
From: syzbot <syzbot+9709e73bae885b05314b@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    baeb9a7d8b60 Merge tag 'sched-rt-2024-09-17' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=172af607980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=acaa65be5f19fc5a
dashboard link: https://syzkaller.appspot.com/bug?extid=9709e73bae885b05314b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=161e2ca9980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=151bff00580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cac89ddb3388/disk-baeb9a7d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ddec90b149ab/vmlinux-baeb9a7d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f8db8244cc07/bzImage-baeb9a7d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/25ed405f5727/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9709e73bae885b05314b@syzkaller.appspotmail.com

OCFS2: ERROR (device loop0): int __ocfs2_find_path(struct ocfs2_caching_info *, struct ocfs2_extent_list *, u32, path_insert_t *, void *): Owner 17 has empty extent list at depth 312
On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
OCFS2: Returning error to the calling process.
(syz-executor337,5180,0):ocfs2_find_leaf:1940 ERROR: status = -30
(syz-executor337,5180,0):ocfs2_get_clusters_nocache:421 ERROR: status = -30
(syz-executor337,5180,0):ocfs2_get_clusters:624 ERROR: status = -30
(syz-executor337,5180,0):ocfs2_extent_map_get_blocks:671 ERROR: status = -30
=====================================================
BUG: KMSAN: uninit-value in ocfs2_get_block+0xed2/0x2710 fs/ocfs2/aops.c:159
 ocfs2_get_block+0xed2/0x2710 fs/ocfs2/aops.c:159
 do_mpage_readpage+0xc45/0x2780 fs/mpage.c:225
 mpage_readahead+0x43f/0x840 fs/mpage.c:374
 ocfs2_readahead+0x269/0x320 fs/ocfs2/aops.c:381
 read_pages+0x193/0x1110 mm/readahead.c:160
 page_cache_ra_unbounded+0x901/0x9f0 mm/readahead.c:273
 do_page_cache_ra mm/readahead.c:303 [inline]
 force_page_cache_ra+0x3b1/0x4b0 mm/readahead.c:332
 force_page_cache_readahead mm/internal.h:347 [inline]
 generic_fadvise+0x6b0/0xa90 mm/fadvise.c:106
 vfs_fadvise mm/fadvise.c:185 [inline]
 ksys_fadvise64_64 mm/fadvise.c:199 [inline]
 __do_sys_fadvise64 mm/fadvise.c:214 [inline]
 __se_sys_fadvise64 mm/fadvise.c:212 [inline]
 __x64_sys_fadvise64+0x1fb/0x3a0 mm/fadvise.c:212
 x64_sys_call+0xe11/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:222
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable p_blkno created at:
 ocfs2_get_block+0xc7/0x2710 fs/ocfs2/aops.c:140
 do_mpage_readpage+0xc45/0x2780 fs/mpage.c:225

CPU: 0 UID: 0 PID: 5180 Comm: syz-executor337 Not tainted 6.11.0-syzkaller-07341-gbaeb9a7d8b60 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
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
