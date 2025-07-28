Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC8772621
	for <ocfs2-devel@lists.linux.dev>; Mon, 28 Jul 2025 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753716162; cv=none; b=kbsnYFCX0TvSTqqMbXMvUZwwfNc+XDZtOOd4OQUxOJjD01sMNSkmFYeBNTVs1Z3PemzMEoTvoiTzaVeoaZFtJI3fHgDmWGl2/gbPUP0M2R0pmFSjGFwFeLUJSBlV79496dd57XswuthgBTQ14lXHrt+dDuuzHHuGCBvOkEi4y7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753716162; c=relaxed/simple;
	bh=ZlOXeH45jXSInPeaLOZi5V79DwA2UjKdgqRkKe0mS54=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PTHmtvw7pQ8sUNwv0kuFXVpOJ+HVV2Li4/3XQ2+1il+mnoM+kspuRf+lJOmcidpGihWR9T0nJreU3s/TC+INO1mekeCmHtoCooN6RjD+uYzlnLwcEOPgKatxFR9PCIVonU4MtQyYqo+0b4dxkX0AnSC5DLemtLRFpQR+dmeCAu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3e3e69b2951so153975ab.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 28 Jul 2025 08:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753716159; x=1754320959;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z+cOxGAfhS86VetiITXfJtW7Zee3QngOEVHl91cKsyg=;
        b=gTJq0kYXBror5opRtsvK0IXg1MesgxU2T86HP/kK7+tmtCMpokmfVxftrKqLYYnddO
         /H+0Cnv96NtIlLtI+NdHf9YRvBqb7Im9vSuYZJC8wWVTXVx+WgRtquoqm05F8PYaUkIN
         FLEr7ki/SOpfD/UAU9TS35btflJRncE02ggn5d27V1xN4HalNDep6erKmRhdK/4++0Cr
         TIMyI4ucgfoNeGpFH9SDLTJCS/bgCALxrtPOUjFfOWnpuC7DttbNfXuvLUIQNBm6DdoL
         FaEl/j6m0zhxe+8wdseZ8i/ON3nhU0OhIjIKxr2rBW1q00z9Z1k27fYa3JNPIEpj/XOp
         Im3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXCwr4mUoh5uEMFLcpe1SvYdynbtXTkDgKmtLSa8IB1yETwmJ46WiUCVVsAmFt69XMK45cnhiV6TuVcfg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+ZnRswr214v6r6EXVE8drLeapldVZjHxCdq8Cxx5RLwhE4Nx4
	h0od77vepqdZvkBc0xcEI+ouVYbtIKUi8w6Y3LrtKJZTtlwA21vXGb8EZJQ4ReVLmssRyjOMAEH
	xUzBuraww39yV5vmV/YcK53lVKoLoF15QQKPGeEcL3Cnz+zBczYR4EedoLi4=
X-Google-Smtp-Source: AGHT+IFlAGbr4nnwVrgucSaEVThbjFPHP6R3imB4vj5zyrOwstKkz4Kwe+RcbfTwEWwroQKhgM5p1+K/1oCRvWsf2j/3hhfFBiVN
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4818:b0:3e3:b3d0:26cf with SMTP id
 e9e14a558f8ab-3e3b9826d22mr255234485ab.10.1753716159510; Mon, 28 Jul 2025
 08:22:39 -0700 (PDT)
Date: Mon, 28 Jul 2025 08:22:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688795bf.050a0220.3cc461.000c.GAE@google.com>
Subject: [syzbot] [ocfs2?] general protection fault in ocfs2_clear_inode (2)
From: syzbot <syzbot+d58fc9c4a90032ed31ff@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    038d61fd6422 Linux 6.16
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16941034580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be3042dc81e96425
dashboard link: https://syzkaller.appspot.com/bug?extid=d58fc9c4a90032ed31ff
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/96c326de2cf2/disk-038d61fd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cf0010801745/vmlinux-038d61fd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/572bd02ef3c3/bzImage-038d61fd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d58fc9c4a90032ed31ff@syzkaller.appspotmail.com

 </TASK>
ocfs2: Unmounting device (7,5) on (node local)
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 UID: 0 PID: 21048 Comm: syz-executor Not tainted 6.16.0-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:ocfs2_clear_inode+0x56e/0x1540 fs/ocfs2/inode.c:1222
Code: 48 c1 ea 03 80 3c 02 00 0f 85 c0 08 00 00 48 8b 9d 90 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 88 08 00 00 48 8b 7b 08 e8 9f 3f e4 fe 48 8b 4c
RSP: 0018:ffffc90004c97898 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff83a9864b
RDX: 0000000000000001 RSI: ffff888050de37c0 RDI: 0000000000000008
RBP: ffff8880581cc000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff888050de2ac0
R13: ffff888050de3220 R14: ffff888050de32d0 R15: 0000000000000000
FS:  000055558ade6500(0000) GS:ffff888124827000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5659596e9c CR3: 00000000575b2000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 ocfs2_evict_inode+0x8fb/0x1680 fs/ocfs2/inode.c:1234
 evict+0x3e6/0x920 fs/inode.c:810
 iput_final fs/inode.c:1898 [inline]
 iput fs/inode.c:1924 [inline]
 iput+0x521/0x880 fs/inode.c:1910
 __ocfs2_free_slot_info.part.0+0x3e/0x210 fs/ocfs2/slot_map.c:307
 __ocfs2_free_slot_info fs/ocfs2/slot_map.c:304 [inline]
 ocfs2_free_slot_info+0x47/0x60 fs/ocfs2/slot_map.c:443
 ocfs2_delete_osb+0x52/0x1f0 fs/ocfs2/super.c:2450
 ocfs2_dismount_volume+0x445/0xa00 fs/ocfs2/super.c:1884
 generic_shutdown_super+0x156/0x390 fs/super.c:643
 kill_block_super+0x3b/0x90 fs/super.c:1755
 deactivate_locked_super+0xc1/0x1a0 fs/super.c:474
 deactivate_super fs/super.c:507 [inline]
 deactivate_super+0xde/0x100 fs/super.c:503
 cleanup_mnt+0x225/0x450 fs/namespace.c:1417
 task_work_run+0x150/0x240 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xeb/0x110 kernel/entry/common.c:114
 exit_to_user_mode_prepare include/linux/entry-common.h:330 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:414 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:449 [inline]
 do_syscall_64+0x3f6/0x4c0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0ecef8fcd7
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007fff28c54848 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007f0ecf010b55 RCX: 00007f0ecef8fcd7
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007fff28c54900
RBP: 00007fff28c54900 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007fff28c55990
R13: 00007f0ecf010b55 R14: 00000000001604be R15: 00007fff28c559d0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ocfs2_clear_inode+0x56e/0x1540 fs/ocfs2/inode.c:1222
Code: 48 c1 ea 03 80 3c 02 00 0f 85 c0 08 00 00 48 8b 9d 90 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 88 08 00 00 48 8b 7b 08 e8 9f 3f e4 fe 48 8b 4c
RSP: 0018:ffffc90004c97898 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff83a9864b
RDX: 0000000000000001 RSI: ffff888050de37c0 RDI: 0000000000000008
RBP: ffff8880581cc000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff888050de2ac0
R13: ffff888050de3220 R14: ffff888050de32d0 R15: 0000000000000000
FS:  000055558ade6500(0000) GS:ffff888124727000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d77c2d24b0 CR3: 00000000575b2000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess):
   0:	48 c1 ea 03          	shr    $0x3,%rdx
   4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   8:	0f 85 c0 08 00 00    	jne    0x8ce
   e:	48 8b 9d 90 02 00 00 	mov    0x290(%rbp),%rbx
  15:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1c:	fc ff df
  1f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 88 08 00 00    	jne    0x8bc
  34:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  38:	e8 9f 3f e4 fe       	call   0xfee43fdc
  3d:	48                   	rex.W
  3e:	8b                   	.byte 0x8b
  3f:	4c                   	rex.WR


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
