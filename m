Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2C919F12C
	for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 09:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726133787; cv=none; b=saoj+SkbZroUIkf3qlgeoFzyn8GY+7gsV/T66imRiyQ9SZBmK4h4xWyR/zblZxB9dkU9V9dNPoLVASP0kYlJD4ikI1puYRTbnfVKeT1SzBOSC6gonVNCxLHlOu+osktMwnI8qcqdB+mBKoD8zL0ox3sm2CHWk5sOLDEqt126Uck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726133787; c=relaxed/simple;
	bh=+r+AiJjBy3bBgHfKy5X5zsisybDNHwDM/YM3ggKKo74=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ppAwmZmBZzvRhVSPSxMZ9Bf97ttzpLsxogzug3xa18JawMqWst1n1PdEgkJ0mi+Eo51y9wPMhuQnMFdYtqKslNLRED2pZJn6O6KxLu/oZYmz/YLV1L5kLkXqzXm4TadcrzaL8c20i5W+dRBAD/Wo3KB0vgRL7KlYwp6sAKMWYO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82ad9fca5fcso97210639f.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 12 Sep 2024 02:36:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726133785; x=1726738585;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KgxEH/dPckQoax++2jD1H3sGNyjmpWxJ25gWSJfGOe8=;
        b=OIkzHMquB1zDYwWxlN+TgGVPxd+nKabDphDTjk8DICYGNN/ZDNtnaj9cOzmcPOldCc
         e2p1I6T3HcSuj7y+hq34oBNTkazdg4O8LTzyEHZdEIqDx2oVTtnYBbeIGzT5WAuAFkgB
         fP7Wyp4h17qQOGyj+PpHcO36mq+ngDPKYpqi+DX37IQj+YETB0Id4ybIOfcwnm7CyW8I
         KHNqtXDHxtC45rFWEYI+My8JaKMiVeMu7g1FkIIsOTahRTh6szB322Co75IL/dmJLbdo
         ao4aCSAOohv7a6SQgvXLV5wGBQL/laGrpGx4koKyfbX7nom4PKDVHRvx376TIX+1T4pm
         tWFg==
X-Forwarded-Encrypted: i=1; AJvYcCWd+DbNrPnfujs8HfzHBaoHex9Ilk3OKpq3ybvfam2AjkCwA/Mj5HHNxc4O1FYHMpEWFxYQnkoiUa1yhw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1+Fp9T6FI+0bAtv0T/vBJLIF4O8FMpcUvksAD2m08VXs4c09M
	N/Gd2+nSAK/PD53Q1ZJmFc/K/lYF+I/IAwR15Ro7YU2RMg3abOVmoX5KBtz8ch3Yjgw44dIqiyy
	IMdqHKxUKemikm//4WW20P+uW0NptlorDxHlWufdvhEBU5xaUMlpwK70=
X-Google-Smtp-Source: AGHT+IE4Rtr3bDVXvd8wGV+5Uq30bbzGmO2pUXAU7uStNZCkC1ZMooGvqhjTheKDn6SizE60n/R8s3dEis7+KzGvu52J9sOn6JpJ
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170a:b0:39f:74c2:9210 with SMTP id
 e9e14a558f8ab-3a08494ab48mr20449605ab.25.1726133785464; Thu, 12 Sep 2024
 02:36:25 -0700 (PDT)
Date: Thu, 12 Sep 2024 02:36:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001e20c30621e8d767@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_dio_wr_get_block
From: syzbot <syzbot+f8b081be889b639423bb@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8d8d276ba2fb Merge tag 'trace-v6.11-rc6' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=160d07c7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=f8b081be889b639423bb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-8d8d276b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d23708af23a4/vmlinux-8d8d276b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1aed2837c105/bzImage-8d8d276b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f8b081be889b639423bb@syzkaller.appspotmail.com

(syz.0.0,5118,0):__ocfs2_journal_access:705 ERROR: Error -30 getting 1 access to buffer!
(syz.0.0,5118,0):ocfs2_write_end_nolock:1967 ERROR: status = -30
(syz.0.0,5118,0):ocfs2_commit_trans:382 ERROR: status = -5
------------[ cut here ]------------
kernel BUG at fs/ocfs2/aops.c:2279!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5118 Comm: syz.0.0 Not tainted 6.11.0-rc7-syzkaller-00020-g8d8d276ba2fb #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:ocfs2_dio_wr_get_block+0x18bd/0x18d0 fs/ocfs2/aops.c:2279
Code: e1 8e 4c 89 f2 e8 23 f7 6b 01 e9 3a f6 ff ff e8 19 3d 39 08 e8 54 30 13 fe 90 0f 0b e8 4c 30 13 fe 90 0f 0b e8 44 30 13 fe 90 <0f> 0b e8 3c 30 13 fe 90 0f 0b 66 0f 1f 84 00 00 00 00 00 90 90 90
RSP: 0018:ffffc90002d6f060 EFLAGS: 00010287
RAX: ffffffff83805c6c RBX: 0000000000002000 RCX: 0000000000040000
RDX: ffffc9000b8c1000 RSI: 000000000001881d RDI: 000000000001881e
RBP: ffffc90002d6f250 R08: ffffffff8380570b R09: 1ffffffff283c928
R10: dffffc0000000000 R11: fffffbfff283c929 R12: 1ffff11006b8d50d
R13: dffffc0000000000 R14: 00000000ffffffe2 R15: ffff888040c68710
FS:  00007f1e355396c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000dc00000000 CR3: 000000003ca5a000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 get_more_blocks fs/direct-io.c:649 [inline]
 do_direct_IO fs/direct-io.c:937 [inline]
 __blockdev_direct_IO+0x1c90/0x4890 fs/direct-io.c:1249
 ocfs2_direct_IO+0x257/0x2c0 fs/ocfs2/aops.c:2465
 generic_file_direct_write+0x130/0x350 mm/filemap.c:3941
 __generic_file_write_iter+0x129/0x230 mm/filemap.c:4107
 ocfs2_file_write_iter+0x17b4/0x1f60 fs/ocfs2/file.c:2455
 do_iter_readv_writev+0x60a/0x890
 vfs_writev+0x37c/0xbb0 fs/read_write.c:971
 do_pwritev fs/read_write.c:1072 [inline]
 __do_sys_pwritev2 fs/read_write.c:1131 [inline]
 __se_sys_pwritev2+0x1ca/0x2d0 fs/read_write.c:1122
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1e3477def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1e35539038 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f1e34936058 RCX: 00007f1e3477def9
RDX: 0000000000000001 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 00007f1e347f0b56 R08: 0000000000000030 R09: 0000000000000003
R10: 0000000000001400 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007f1e34936058 R15: 00007ffd191ac778
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_dio_wr_get_block+0x18bd/0x18d0 fs/ocfs2/aops.c:2279
Code: e1 8e 4c 89 f2 e8 23 f7 6b 01 e9 3a f6 ff ff e8 19 3d 39 08 e8 54 30 13 fe 90 0f 0b e8 4c 30 13 fe 90 0f 0b e8 44 30 13 fe 90 <0f> 0b e8 3c 30 13 fe 90 0f 0b 66 0f 1f 84 00 00 00 00 00 90 90 90
RSP: 0018:ffffc90002d6f060 EFLAGS: 00010287
RAX: ffffffff83805c6c RBX: 0000000000002000 RCX: 0000000000040000
RDX: ffffc9000b8c1000 RSI: 000000000001881d RDI: 000000000001881e
RBP: ffffc90002d6f250 R08: ffffffff8380570b R09: 1ffffffff283c928
R10: dffffc0000000000 R11: fffffbfff283c929 R12: 1ffff11006b8d50d
R13: dffffc0000000000 R14: 00000000ffffffe2 R15: ffff888040c68710
FS:  00007f1e355396c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000dc00000000 CR3: 000000003ca5a000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
