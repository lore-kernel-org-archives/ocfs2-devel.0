Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F6B1CAA4
	for <ocfs2-devel@lists.linux.dev>; Fri,  7 Nov 2025 17:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762535497; cv=none; b=NOx1moQyjAnliZAjtmMmbzwvNTbTvZNt1KRVAU6cnlPkFrdrrFqKoDgWEqIKR5kIspzAU1ELDYxjPzPeCCKddgfWlvrTlhK1V+OgXmdePs/FRj6y5Np7ylltRE70AJ/HGXBOpj26cBlSCijpcwbY2pEkuE0NF7XSZ6Nn6WGnhLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762535497; c=relaxed/simple;
	bh=Ijy0mE9Bfj28iw5OFeTduBgvK0D0fRpvyf00WFIo4Mo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kbiTHRkm0qzfCL/O+BFOBOvAUy+B/IKLrxHpZTzno1UCjnNFa4DktqInSvYWCF6ewkRW+sTzqRnjSsD0K6p6GKjS965j5yDiYEBKfvvxFHpJFO1c4um8iwbGQw+UDoHvR/9blrZudOCTIfOvgZyYfsoi13YdwYiXTzmJSgHjTjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-4330f62ef60so9405745ab.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 07 Nov 2025 09:11:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762535495; x=1763140295;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kIC83JLdaG0kr9v2fCZaiP1QsIT1/GnA9WZ2IXM/M8U=;
        b=CSto4yoNyUCpvltW2jZwFFaDKijyoROFADo/J2Al82ctZomDVfTAZXaie/IFqDn3cs
         rFDnMYUmx6bevKpDOObBQI9bEJT8pXTqDsunz7MDFiwCfWokh5Hq6jwsM8Srmn5UH2jr
         sqldz2BeCrjV1JQL+ZIRdPZtLPxPui6rzMX/d4yVGF3aHlvjdkNI9XDK7h/r9ike5wqk
         v8XtLw/Lj/UDkFfDV2RbH42dBZ8kTAcMmYF8tX1pvKdA6uEz9OC0aXft0qpH9iX6NeUI
         f/yggvj7g4dXZNUBtHd6WajDcEeoYIHUuAGGSYlW3Judrw30LKAHvHMeHwSFsGVYnNX8
         h+cA==
X-Forwarded-Encrypted: i=1; AJvYcCUk5igv4CzqA35jJb9E5Q4T3S/0DvK4klyeIuRI3Stq++cSKeC6QPD1P6up6icRHPmd7yrK1spLmdPEtA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4QtwskjMIC5bFd3b5kHJkhUazg0sMlyBvdtZF92CKVWq/kGPm
	0Ke34A99+7ilO8y/+YowD1D0LQ+G5lJZLMlKPO2we2L74pVAebuoAlMY9Q2FDYkA8U48lSb/T+m
	ir/J0KNH25+eeSGsAbjC5LR8uEZliaKqQRdw94F03kKmHDJm2yW9rA8ghGu8=
X-Google-Smtp-Source: AGHT+IHVsOrmMHH/4XX7mg0f3XuGt7DT1GNJkN+g0OFloaLQziPQryRytU+ljqU+wFh9kAMb2zYqr2B5Nfb1/lZwxxCyO2W1w26t
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c22:b0:433:2943:3a78 with SMTP id
 e9e14a558f8ab-43367e70f05mr2674525ab.31.1762535494581; Fri, 07 Nov 2025
 09:11:34 -0800 (PST)
Date: Fri, 07 Nov 2025 09:11:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690e2846.a70a0220.22f260.0057.GAE@google.com>
Subject: [syzbot] [ocfs2?] memory leak in ocfs2_new_path_from_path
From: syzbot <syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4a0c9b339199 Merge tag 'probes-fixes-v6.18-rc4' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15fbca92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb128cd5cb439809
dashboard link: https://syzkaller.appspot.com/bug?extid=cfc7cab3bb6eaa7c4de2
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114be17c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bfd02a09ef4d/disk-4a0c9b33.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ed9a1334f973/vmlinux-4a0c9b33.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e503329437ee/bzImage-4a0c9b33.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/275c7c156b9c/mount_0.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=11545084580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff8881286c42a0 (size 96):
  comm "syz.3.46", pid 6293, jiffies 4294945738
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 a0 0e 30 82 ff ff ff ff  ..........0.....
    88 b8 5b 2d 81 88 ff ff c0 f4 c3 2f 81 88 ff ff  ..[-......./....
  backtrace (crc f97a0cdc):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __kmalloc_cache_noprof+0x3a6/0x5b0 mm/slub.c:5758
    kmalloc_noprof include/linux/slab.h:957 [inline]
    kzalloc_noprof include/linux/slab.h:1094 [inline]
    ocfs2_new_path fs/ocfs2/alloc.c:688 [inline]
    ocfs2_new_path_from_path+0x4f/0x90 fs/ocfs2/alloc.c:702
    ocfs2_get_left_path.constprop.0+0x182/0x390 fs/ocfs2/alloc.c:3491
    ocfs2_merge_rec_left+0x426/0xe60 fs/ocfs2/alloc.c:3543
    ocfs2_try_to_merge_extent+0x3cb/0xe90 fs/ocfs2/alloc.c:3794
    ocfs2_split_extent+0xd2e/0x1330 fs/ocfs2/alloc.c:5139
    ocfs2_change_extent_flag+0x2ed/0x720 fs/ocfs2/alloc.c:5230
    ocfs2_mark_extent_written+0x1e3/0x2c0 fs/ocfs2/alloc.c:5276
    ocfs2_dio_end_io_write+0x5bc/0xaa0 fs/ocfs2/aops.c:2350
    ocfs2_dio_end_io+0x8c/0x180 fs/ocfs2/aops.c:2404
    dio_complete+0x12e/0x4b0 fs/direct-io.c:281
    __blockdev_direct_IO+0x1782/0x1b40 fs/direct-io.c:1303
    ocfs2_direct_IO+0xf6/0x100 fs/ocfs2/aops.c:2441
    generic_file_direct_write+0xb4/0x180 mm/filemap.c:4176
    __generic_file_write_iter+0xa1/0x130 mm/filemap.c:4345
    ocfs2_file_write_iter+0x68a/0x15a0 fs/ocfs2/file.c:2469

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


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
