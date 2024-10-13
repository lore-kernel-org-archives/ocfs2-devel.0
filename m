Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D5836B
	for <ocfs2-devel@lists.linux.dev>; Sun, 13 Oct 2024 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728826615; cv=none; b=j3sYkKV+Vwht50ARQS5AjqLzm7sCI4XTBBhD9CInRs6HORpgUkalNQmL9Os+3L8hMCyUtAJPfzSJq+wItkpZ7pLmZ+GvjzN6vNxXuZY9M1AME6LyCSTQ+ApikuARDfYdvsQxERshF146UbcdGmIRfjvvZrKr3+6o7tGi8X83e9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728826615; c=relaxed/simple;
	bh=pytNIx+jKapQeucboWpIMiXRULkceqL/mqWhiMqw3ys=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=PG5yamKqUbMXLdTU98YImauwlEbJIiyxANYxIiZqJseFNuOsHxgDeo5BVVjzFR2SmO6oWrihcqNQFZ74YmSInGLasRjGt2MY2R71RkZ8z3BOtu0rTnq+ocLYt8TeRl/fMUeaNYxjZxn3giMUTQJw+qiG2MBDyaiCNXf8Vy0Nzlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=OeXpgvpf; arc=none smtp.client-ip=43.163.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="OeXpgvpf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1728826306; bh=Ir7E+cd5nsOzSK0P0aZLBMENQat91iTQBb56dgtbmEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OeXpgvpfayrRPYX8wCotBgrzqjprgHa/24dzuR7/KQ3cgYpoMjFiaF+USnJhVnVlt
	 Ikux9aVNrhj9REzWZsZ//drajgVm95iIPEvBXLA9sixGTXd6JiXT90r71VbtJ4+6ck
	 WXPqnCW4OcBQYkWEKsHF/qhmLmn8iSYBeo6jHkKQ=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszc16-0.qq.com (NewEsmtp) with SMTP
	id 65C9E00E; Sun, 13 Oct 2024 21:25:28 +0800
X-QQ-mid: xmsmtpt1728825928tuc1jd0oz
Message-ID: <tencent_10694B411BC625A4BA1BBB8033959EA31B08@qq.com>
X-QQ-XMAILINFO: NNoVXaH09J17YzWnYinin4OpNa5hWNReprXjMDMRP0ViCefJFVfE8aLnkkSzDl
	 5hZMY+CQUPkOipzrGnfacN9Q6P9oc719e5WG+5IYtTfcOYrKOBfN7qjVkRJ5XTRL/ONKqMtn7FmI
	 oIX2fZfoOluhJyZqfDaiwAEXqt9D7Hwp48wHKx4te5yPdPvj37bKiiWlKRO0rtbuDSIYs29oZI9/
	 YwlnjGM6WIQq8Z2j9tLnjILJYZG2nUOkoEtAHgs0WzXj4WRdnEK+4d9SNnihfGx/aKktWUmof8Jc
	 GqDS+5cp/Js1uDKDNfO1lLhbEH2eGEtVp4/UT7mq18D/qTcGFbPbL3CgW8xGpvoWpOWSlrdJgWyS
	 qqqfYgoFih51oiLe+N1nuuz3jzw9v80X3JMI3pzXZUNV27BFMhY9OKpDrffCe4PtvHeNI0T0F70d
	 1YAF/cZPXM7kB5w4aDO3mraF48/BhQ2XOvKeEJKKlGiTVrX+cEtdv/1sL9EXMbw1ojws9KD7j95J
	 zeofwsOccS+JO48ADpnTZLxvwYgIh1x9aI/Hq8DFqmcgZVhuSl4w2goaniczNUMec6Sfwv47s3RF
	 eX8Th56DaNdgQm0gWDl77jxHGH1n0XjtV+5vgpIXlmAD8PilGge2YDtEPFXI4Gsuah3QZWnF1C0p
	 MmHp10au50fCdxlwW+ev3JV8tcZvMJogp7Zl/7EoTxumP/rk/S1VMfQWSHcBqS80x5CmA5LqXqLf
	 27cT/Bvfc9Kv+8Z4wKpGYI5cqIcRakg7QkNH6b0/eZ2yUejbqvfhmYqibDHkcv5JKS0K+3SZkQvy
	 NqGa38g7Hw9Av0nZc8/9WrHLaERSD4ups4qeeO21KD6xNkb4MK2Sg7+tWobPz+jg7AjC/FJde6/P
	 R7Y16S//VzURG8PpPxBri/geZk8FqslzG+hWV39Ry4S1SLL1IeNoTQBNZu2e6PaKscVE+6H51W83
	 kdKAn1nY0=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] ocfs2: BUG is meaningless when the flags is 0
Date: Sun, 13 Oct 2024 21:25:29 +0800
X-OQ-MSGID: <20241013132528.2763484-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <670a46a0.050a0220.4cbc0.001e.GAE@google.com>
References: <670a46a0.050a0220.4cbc0.001e.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported a BUG in ocfs2_read_virt_blocks.
------------[ cut here ]------------
kernel BUG at fs/ocfs2/extent_map.c:971!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 5221 Comm: syz-executor117 Not tainted 6.12.0-rc2-syzkaller-00006-g87d6aab2389e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:ocfs2_read_virt_blocks+0xaa3/0xb20 fs/ocfs2/extent_map.c:971
Code: 8b 54 24 30 8b 4c 24 1c 4c 8b 44 24 38 45 89 e1 ff 74 24 48 e8 7e 0a 0c 00 48 83 c4 08 eb 25 e8 43 d2 34 08 e8 ee d1 0c fe 90 <0f> 0b e8 e6 d1 0c fe 4c 89 e8 45 89 e5 49 89 c4 e9 01 f7 ff ff e8
RSP: 0018:ffffc90002e2e820 EFLAGS: 00010293
RAX: ffffffff83881432 RBX: 0000000000000000 RCX: ffff88802d3e9e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002e2e9f0 R08: ffffffff83880eae R09: 1ffffffff203781d
R10: dffffc0000000000 R11: fffffbfff203781e R12: ffff8880764d8878
R13: 0000000000000000 R14: 0000000000000000 R15: 1ffff920005c5d18
FS:  000055557cd55380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005628fd41e058 CR3: 000000002d2e6000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ocfs2_read_dir_block+0x106/0x5c0 fs/ocfs2/dir.c:508
 ocfs2_find_dir_space_el fs/ocfs2/dir.c:3427 [inline]           // status = ocfs2_read_dir_block(dir, 0, &bh, 0);
 ocfs2_prepare_dir_for_insert+0x3f2/0x5c60 fs/ocfs2/dir.c:4274
 ocfs2_mknod+0xcaf/0x2b40 fs/ocfs2/namei.c:292
 ocfs2_create+0x1ab/0x480 fs/ocfs2/namei.c:672
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

It is because the parameter v_block passed to ocfs2_read_virt_blocks() is 0,
nr is 1, and inode->i_size is 0, and flags are also 0.
In this path, v_block, flags, and nr are fixed values that are hard coded,
so if i_size is 0, the bug will be triggered.
Therefore, it is more meaningful to check if the flags contain the READHEAD
bit when their value is non-zero.

Reported-and-tested-by: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=797d4829dafe3f11dce7
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/ocfs2/extent_map.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f7672472fa82..0043c2428ef2 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -968,7 +968,8 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 
 	if (((v_block + nr - 1) << inode->i_sb->s_blocksize_bits) >=
 	    i_size_read(inode)) {
-		BUG_ON(!(flags & OCFS2_BH_READAHEAD));
+		BUG_ON(flags && !(flags & OCFS2_BH_READAHEAD));
+		rc = flags ?: -EIO;
 		goto out;
 	}
 
-- 
2.43.0

