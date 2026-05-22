Received: from mail-oa1-f79.google.com (mail-oa1-f79.google.com [209.85.160.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA06359A6F
	for <ocfs2-devel@lists.linux.dev>; Fri, 22 May 2026 06:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779431800; cv=none; b=IwWVwL9VtQul0BASTr465toWNIYUao6EhNm/NMsiCh+51jeJenO+OSvPW69kVWvTV/o0mm6Tt7gOzsGtYEPhZ2RNtMzKe+PeysfTIbxZi1vfCbaJsuIq2YBipChIfj35BpDls2TA405d71JlAQiaLeHL7ygBXyK0mnmzQMBxlos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779431800; c=relaxed/simple;
	bh=dFfesLJhfdTHvp2m5odKYxKtCNPwf3i1uZVOggnJ9rI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WX/g0MMN28gLI1Gf18UWC2x0JYigFxXFpXsjy3D5Mr97FFgPcjVPHnm22Pf9Qd9vPnsShDSMeG7/QZOpe/ZZKx7Vo7yxz2Atw2j37w6pv4rrZBsLwf3LVtr3Vdw7xy7b3tsJTVvkoJDGP5a1HRYhxVaaW+JZ4a3cXbNXvp6oG2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f79.google.com with SMTP id 586e51a60fabf-43a6343b671so14480865fac.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 21 May 2026 23:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779431797; x=1780036597;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XyYb1BlLZkIEDnzw5Rn1q/DF0QpbAbtQQcdB2UpOG2g=;
        b=qnMh4cN1mbgu6l4aOYPBpDklkSEKSUySOQwby4B0UCGNUV4PWf0uXj6YEd88pRTj3F
         UWfNsU7poVH0MuhZnBVRtbAJLiclnTxzFc7DCa+0LNQOhchOlCMMWps0uT+uL7PEo/uH
         hbRnBMTBfkYIjWBIU4YUtG2jWGMAjzhsvllmwzk0stVA2ZXYwMTUu2Kv87Z0x5gsyXPT
         O2DQAHFtQkVKcr6TYIEityFS08GGQPFe3sZvg8n/jjasaWxoR7Yu2vldd38m21ECHPr+
         Upe5KQyUcSKbP4tUHFDRmc4OEcOAfMX28TmMt/y24utkP/J6/ecmzVeX4ma6RCAMNM2t
         gvnA==
X-Forwarded-Encrypted: i=1; AFNElJ/oGIYWvT8V9fzoXdGc6DF9iaQrGWTvX5rmVLs22MY7Gtkd3vLc8PPs5enlkSMIl+5pSJ075ABrfnOprQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyMKUZyhJlbXlQs3Q32jYoXnNktHTiMe6Ov0sObTYKfJ8l/J04V
	d/lvxwdlsI+e86HeGf3skabUJM3s4ind5wm0OZFEUJDAq6nGpw/LXhab8mMdJObIP0Ml9g33cs4
	C1k11AG08OLCB5kEnwdsVE9bt+R3Z6E+FkGI/DJkovISJFqH0Xq4cgPlk6Rs=
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f00e:b0:69b:8e0f:3d43 with SMTP id
 006d021491bc7-69d7ec4b211mr1210257eaf.38.1779431797595; Thu, 21 May 2026
 23:36:37 -0700 (PDT)
Date: Thu, 21 May 2026 23:36:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0ff975.170a0220.a3509.0047.GAE@google.com>
Subject: [syzbot] [ocfs2?] UBSAN: array-index-out-of-bounds in ocfs2_dx_dir_lookup_rec
From: syzbot <syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com>
To: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	linux-kernel@vger.kernel.org, mark@fasheh.com, ocfs2-devel@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e5d505e3664b Merge tag 'trace-v7.1-rc3' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=125737ba580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7f195f6be48c12ec
dashboard link: https://syzkaller.appspot.com/bug?extid=caacd220635a9cc3bac9
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-e5d505e3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e34834fd8b3d/vmlinux-e5d505e3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/83271095636f/bzImage-e5d505e3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+caacd220635a9cc3bac9@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in fs/ocfs2/dir.c:840:14
index 40959 is out of range for type 'struct ocfs2_extent_rec[] __counted_by(l_count)' (aka 'struct ocfs2_extent_rec[]')
CPU: 0 UID: 0 PID: 5335 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
 ocfs2_dx_dir_lookup_rec+0x253/0x710 fs/ocfs2/dir.c:840
 ocfs2_dx_dir_lookup+0xdb/0x540 fs/ocfs2/dir.c:896
 ocfs2_dx_dir_search fs/ocfs2/dir.c:956 [inline]
 ocfs2_find_entry_dx fs/ocfs2/dir.c:1070 [inline]
 ocfs2_find_entry+0x1015/0x21a0 fs/ocfs2/dir.c:1107
 ocfs2_find_files_on_disk+0xe0/0x340 fs/ocfs2/dir.c:2030
 ocfs2_lookup_ino_from_name+0x52/0x100 fs/ocfs2/dir.c:2052
 ocfs2_lookup+0x249/0xa20 fs/ocfs2/namei.c:123
 __lookup_slow+0x2b7/0x410 fs/namei.c:1915
 lookup_slow+0x53/0x70 fs/namei.c:1932
 walk_component fs/namei.c:2278 [inline]
 lookup_last fs/namei.c:2785 [inline]
 path_lookupat+0x3f5/0x8c0 fs/namei.c:2809
 filename_lookup+0x256/0x5d0 fs/namei.c:2838
 kern_path+0x3d/0x150 fs/namei.c:3044
 unix_find_bsd net/unix/af_unix.c:1215 [inline]
 unix_find_other+0x19d/0xb40 net/unix/af_unix.c:1281
 unix_dgram_sendmsg+0x754/0x18b0 net/unix/af_unix.c:2162
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmmsg+0x27c/0x4e0 net/socket.c:2841
 __do_sys_sendmmsg net/socket.c:2868 [inline]
 __se_sys_sendmmsg net/socket.c:2865 [inline]
 __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2865
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbfe579ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbfe65d2fe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007fbfe5a16090 RCX: 00007fbfe579ce59
RDX: 0000000000000002 RSI: 0000200000000ec0 RDI: 000000000000000b
RBP: 00007fbfe5832d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbfe5a16128 R14: 00007fbfe5a16090 R15: 00007ffe2ece9c08
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
