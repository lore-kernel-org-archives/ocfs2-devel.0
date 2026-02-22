Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E3FEADC
	for <ocfs2-devel@lists.linux.dev>; Sun, 22 Feb 2026 08:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771748194; cv=none; b=szpmHUPWCwrNJp9ubmUivSX3PuCmqSq81MGEYq/xZ5k59X2Plx1HV5tRtWvXu63uuNIp/dc6UWTB+wykU27LrubD7YDQEs/4jr3WgtBRS9DayBzd0yqnK9uiZ3RryaM3V9P67zROt65NLze2UBrha7fqC5zIUAnIlGdlmGuYPWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771748194; c=relaxed/simple;
	bh=3pL9ZoT7LoKSErSILWpERQv68LDgb9g/L2JzARLcbxM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=RxDcv10oD8+sAV0iRu84lmO4GIBIsUTR6pCDsxPHMMLRMBDLG9Am6Y4QRK5tExvllfkff7CZuqw9lMjpqQD5C4jmthIdQgyvB70pcH9PrTEgj9hJ6gwvimU1/Isd4m9gG0v1Mftp38Hhbo17yObuN+w31igUXCd2ca141wUl/I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6799654a158so21836046eaf.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 22 Feb 2026 00:16:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771748192; x=1772352992;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6U7d04dJRNMKwk6a8BhjZ4v64ipuXf0/k0nlflFqgQk=;
        b=OyPTg/ySLTzwxRWTG4pTCTbHG1GHP5c5gPzwYOP9lII5NjZrP+RPhKX0PcidjBdWxZ
         OYBW7ynvZgCr3guvBCKIt82R9OftyDSX40VVAR080nwtmzbM6iYj6kAvwdukxlZbu5bl
         xnUYbE+pIyG6N5/6oqW7QRuR+gxxCzwFT01DPB3AudWIIrsdqC3SEgkRXWy0QyLpO+B6
         4/cJ3+Medxm5imhzon3lBVR4JzuCxJyw63GfPFr7SMdh5qge7tkdf9IyXLWzg+x17Y+F
         3wxk2y/Q9zI7BWuyrE+nOceeU8YjcB8oDJHMgoSGPNfu5ZhHmAEv05jlFZnMQXiXiz5z
         uyzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWX48cmE22kel9vM/4TIFRaDbeb0zvvM+TXBwQBmoI5U4qWXdn/u02jKppO6MX2F5jEJXOWvs452fDS2w==@lists.linux.dev
X-Gm-Message-State: AOJu0YxV9zvYPCRp/nPqafgrQX+RkJOt7FhAh6/Nl7taq4q5HB4rohhF
	iCzDXLXlbJrbyepERv/9THqm63Hv6Z/IcD0YKuO7ZaFa4OQ4IyJJ3ohrIxcML3nemrtG09miaAP
	EsY44xHR6j8rx5CLsu3+DEhOgaFt9Yv6v78XfP9a0oM6LTH3yQ4BH7ziWqAw=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f031:b0:672:7d05:8225 with SMTP id
 006d021491bc7-679c451c04emr2438273eaf.74.1771748192024; Sun, 22 Feb 2026
 00:16:32 -0800 (PST)
Date: Sun, 22 Feb 2026 00:16:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <699abb60.a70a0220.2c38d7.0171.GAE@google.com>
Subject: [syzbot] [ocfs2?] kernel BUG in ocfs2_xattr_value_truncate (2)
From: syzbot <syzbot+e538032956b1157914a3@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2961f841b025 Merge tag 'turbostat-2026.02.14' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e3bee6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=65722f41f7edc17e
dashboard link: https://syzkaller.appspot.com/bug?extid=e538032956b1157914a3
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-2961f841.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/19ffd1a88c42/vmlinux-2961f841.xz
kernel image: https://storage.googleapis.com/syzbot-assets/621dc0fadd96/bzImage-2961f841.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e538032956b1157914a3@syzkaller.appspotmail.com

loop0: detected capacity change from 32768 to 0
------------[ cut here ]------------
kernel BUG at fs/ocfs2/xattr.c:747!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5327 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:ocfs2_xattr_extend_allocation fs/ocfs2/xattr.c:747 [inline]
RIP: 0010:ocfs2_xattr_value_truncate+0x178b/0x1790 fs/ocfs2/xattr.c:868
Code: 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 51 eb ff ff 4c 89 ff 48 89 f3 e8 03 4e 5d fe 48 89 de e9 3e eb ff ff e8 66 b4 f1 fd 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
RSP: 0018:ffffc9000f64e920 EFLAGS: 00010287
RAX: ffffffff83d3e31a RBX: 0000000000000002 RCX: 0000000000100000
RDX: ffffc90020802000 RSI: 0000000000001a65 RDI: 0000000000001a66
RBP: ffffc9000f64ec50 R08: ffff888035132480 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000002 R12: 0000000000000002
R13: 00000000fffffff5 R14: 0000000000000000 R15: ffff888056fa93d0
FS:  00007f0d56df56c0(0000) GS:ffff88808ca5b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000491000 CR3: 000000001fc51000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 ocfs2_xa_value_truncate+0x2a5/0x3f0 fs/ocfs2/xattr.c:1945
 ocfs2_xa_prepare_entry fs/ocfs2/xattr.c:2204 [inline]
 ocfs2_xa_set+0x238e/0x2ec0 fs/ocfs2/xattr.c:2282
 ocfs2_xattr_block_set+0x3e0/0x3480 fs/ocfs2/xattr.c:3016
 __ocfs2_xattr_set_handle+0x6b3/0xf50 fs/ocfs2/xattr.c:3418
 ocfs2_xattr_set+0xf3f/0x13e0 fs/ocfs2/xattr.c:3681
 __vfs_setxattr+0x43c/0x480 fs/xattr.c:200
 __vfs_setxattr_noperm+0x12d/0x660 fs/xattr.c:234
 vfs_setxattr+0x163/0x360 fs/xattr.c:321
 do_setxattr fs/xattr.c:636 [inline]
 filename_setxattr+0x296/0x630 fs/xattr.c:664
 path_setxattrat+0x3eb/0x440 fs/xattr.c:708
 __do_sys_lsetxattr fs/xattr.c:749 [inline]
 __se_sys_lsetxattr fs/xattr.c:745 [inline]
 __x64_sys_lsetxattr+0xbf/0xe0 fs/xattr.c:745
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0d5a99c629
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0d56df5028 EFLAGS: 00000246 ORIG_RAX: 00000000000000bd
RAX: ffffffffffffffda RBX: 00007f0d5ac16180 RCX: 00007f0d5a99c629
RDX: 0000200000000480 RSI: 00002000000000c0 RDI: 0000200000000100
RBP: 00007f0d5aa32b39 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000fe37 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0d5ac16218 R14: 00007f0d5ac16180 R15: 00007ffd722eb838
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_xattr_extend_allocation fs/ocfs2/xattr.c:747 [inline]
RIP: 0010:ocfs2_xattr_value_truncate+0x178b/0x1790 fs/ocfs2/xattr.c:868
Code: 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 51 eb ff ff 4c 89 ff 48 89 f3 e8 03 4e 5d fe 48 89 de e9 3e eb ff ff e8 66 b4 f1 fd 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
RSP: 0018:ffffc9000f64e920 EFLAGS: 00010287
RAX: ffffffff83d3e31a RBX: 0000000000000002 RCX: 0000000000100000
RDX: ffffc90020802000 RSI: 0000000000001a65 RDI: 0000000000001a66
RBP: ffffc9000f64ec50 R08: ffff888035132480 R09: 0000000000000006
R10: 00000000fffffffc R11: 0000000000000002 R12: 0000000000000002
R13: 00000000fffffff5 R14: 0000000000000000 R15: ffff888056fa93d0
FS:  00007f0d56df56c0(0000) GS:ffff88808ca5b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0d565d1ff8 CR3: 000000001fc51000 CR4: 0000000000352ef0


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
