Received: from mail-oo2-f10.google.com (mail-oo2-f10.google.com [74.125.231.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF223655E7
	for <ocfs2-devel@lists.linux.dev>; Sat, 19 Sep 2026 21:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789854644; cv=none; b=Hd4F+n9qfdZhh+OGO0m2omIaaz8MdEa5IOwFkWP3FTKjEXgNr8AcXfTcWPE7o/rgSc5Br4eQW+/at+ucLphVAnomEBR5FU1lEIq9QtzWIJvW2NHtrxMf7uDXsPxNZdZ4KUL1SYrUeC6e6LQq4SDlWK64+7wJGWz3zye8G8sWIUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789854644; c=relaxed/simple;
	bh=N9A4vnv5xdB6o6npPnpI6bRr68B5lvV5K4FEPfWAEUo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=fZMjsT6LITP1LYw0oETTKRvt0BA67R30zkME3oDq9DAe1WnCracZTqnp0LHM/G+kM9nqr5rluE1dATExkbzzg1Q7KBEM7PYqjLIWrdYaet3azzK69v1FYsjG4hPjzrd8bWMJEguGk8jC8yeVpOqFTSDQ9KSBGCiP2FS+7PTC59A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f10.google.com with SMTP id 006d021491bc7-6c12320cb24so140460eaf.1
        for <ocfs2-devel@lists.linux.dev>; Sat, 19 Sep 2026 14:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789854642; x=1790459442;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3dJdY2tLzdU7OEVLV6TmrJE3tILV5aMCvODKDhHqMWw=;
        b=aLshCZWIfvSay7pjm9npyg9bSV7EYg9YR9wPTKCvBCWI13vx/unURdxFa5Nhklqyt4
         E7eVQh/M6y72M3iAuTF7PZxjYKIOKihAV6nU7OaKuif6lHEBVtpCZaQX+za1hXDI89Kj
         yYCw/MrK2GtdahRtSeUpmCA+XCg6mzr1RAKjRertUvl8BdZmWRau+RRFPEFjJ1KbdNgj
         M6B7LdoyJd0fggNR+5IlJ098zNZ+G2nLWeC4PeNXue2S9igyP6UcWouB+a/gdrBj29vq
         9DB0Yk4HJniar6UKAO5iLrzx1YI9b26ws1pEmP/cVB3kc1tYfDUmiQ3qEzjGlqy8eYJH
         3uMQ==
X-Forwarded-Encrypted: i=1; AKwUvByJV3g2yjxLSBfPbo0rxXFlAOC/+dZXG8xz9KEjKKeEGaykn38/cNNVYW8NzqAsw5on8z5AAyLD4eQ2rg==@lists.linux.dev
X-Gm-Message-State: AFuF++nR+jGv56WvWvUXwKq5opuf4GdYHdKAsTKhL+J7seeq/hljG6gR
	jRyCucNA+QKrZTsdo9VSrhww5ASjn7LLoc95BXeLfVj8kOldc9A2oD/ANDECyp/+NQgqO5bJcp2
	4zUMMSQ3xw5fGeU9NWV8rKadQVS0fXaQ+hoJAIIW1o3+DC9BwdZc+Rk2PTEY=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:290b:b0:6be:2c0f:e40b with SMTP id
 006d021491bc7-6ca9a133802mr6053691eaf.2.1789854642237; Sat, 19 Sep 2026
 14:50:42 -0700 (PDT)
Date: Sat, 19 Sep 2026 14:50:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aaf03b2.a6af0033.177e91.0009.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_set_new_buffer_uptodate (3)
From: syzbot <syzbot+03aaa576f1daa1c1f2f0@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f6e7b42bf05b Merge tag 'sysctl-7.03-fixes-rc4' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13446115580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e909ffe6b35dddb7
dashboard link: https://syzkaller.appspot.com/bug?extid=03aaa576f1daa1c1f2f0
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f6e7b42b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/93106cf47a8e/vmlinux-f6e7b42b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e73f0f00e455/bzImage-f6e7b42b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+03aaa576f1daa1c1f2f0@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/ocfs2/uptodate.c:509!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5323 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ocfs2_set_new_buffer_uptodate+0x149/0x170 fs/ocfs2/uptodate.c:509
Code: 80 3c 20 00 74 08 4c 89 f7 e8 13 fc 3a fe 4d 8b 1e 48 89 df 5b 41 5c 41 5d 41 5e 41 5f 5d 2e e9 15 7a 01 1c e8 b8 55 c9 fd 90 <0f> 0b e8 b0 55 c9 fd 90 0f 0b e8 a8 55 c9 fd 90 0f 0b e8 a0 55 c9
RSP: 0000:ffffc9000e027108 EFLAGS: 00010293
RAX: ffffffff83fe8bd8 RBX: ffff888043c9b218 RCX: ffff888000dc4b00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff907a627f R09: 1ffffffff20f4c4f
R10: dffffc0000000000 R11: fffffbfff20f4c50 R12: dffffc0000000000
R13: ffff888043ce70e0 R14: ffff888043ce70e0 R15: ffff88801d025080
FS:  00007f335d9af6c0(0000) GS:ffff88808c2c6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f335ccd8250 CR3: 0000000013815000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_extend_local_quota_file fs/ocfs2/quota_local.c:1146 [inline]
 ocfs2_create_local_dquot+0x80e/0x1aa0 fs/ocfs2/quota_local.c:1232
 ocfs2_acquire_dquot+0x82c/0xb70 fs/ocfs2/quota_global.c:897
 dqget+0x725/0xbd0 fs/quota/dquot.c:1002
 __dquot_initialize+0x3c8/0xd40 fs/quota/dquot.c:1462
 ocfs2_get_init_inode+0x147/0x1c0 fs/ocfs2/namei.c:206
 ocfs2_mknod+0x8bb/0x22b0 fs/ocfs2/namei.c:315
 ocfs2_mkdir+0x180/0x430 fs/ocfs2/namei.c:667
 vfs_mkdir+0x40c/0x620 fs/namei.c:5410
 filename_mkdirat+0x285/0x510 fs/namei.c:5443
 __do_sys_mkdir fs/namei.c:5470 [inline]
 __se_sys_mkdir+0x34/0x150 fs/namei.c:5467
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f335cb9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f335d9aefe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00007f335ce26090 RCX: 00007f335cb9e159
RDX: 0000000000000000 RSI: 00000000000001ef RDI: 0000200000000040
RBP: 00007f335cc3503b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f335ce26128 R14: 00007f335ce26090 R15: 00007fff6f6a4708
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_set_new_buffer_uptodate+0x149/0x170 fs/ocfs2/uptodate.c:509
Code: 80 3c 20 00 74 08 4c 89 f7 e8 13 fc 3a fe 4d 8b 1e 48 89 df 5b 41 5c 41 5d 41 5e 41 5f 5d 2e e9 15 7a 01 1c e8 b8 55 c9 fd 90 <0f> 0b e8 b0 55 c9 fd 90 0f 0b e8 a8 55 c9 fd 90 0f 0b e8 a0 55 c9
RSP: 0000:ffffc9000e027108 EFLAGS: 00010293
RAX: ffffffff83fe8bd8 RBX: ffff888043c9b218 RCX: ffff888000dc4b00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff907a627f R09: 1ffffffff20f4c4f
R10: dffffc0000000000 R11: fffffbfff20f4c50 R12: dffffc0000000000
R13: ffff888043ce70e0 R14: ffff888043ce70e0 R15: ffff88801d025080
FS:  00007f335d9af6c0(0000) GS:ffff88808c2c6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f335cdeb660 CR3: 0000000013815000 CR4: 0000000000352ef0


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
