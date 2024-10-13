Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B23B13CFBD
	for <ocfs2-devel@lists.linux.dev>; Sun, 13 Oct 2024 23:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728862300; cv=none; b=cgv8Eo2xN/smANSXTWNIm5/JYSLfss+pUw8H06ZWgyk+KAwfg+bpjZw6SNoB/LBg5IO8JO7sqQj8gnELu/2FerWDaeVNIll3HEPgmD/I0o/dPNzMsmzTnksTJmA8lac6fCSUe8REME5SkJAhHypbX+Eo5uOrL4hX6w/lYVG2eSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728862300; c=relaxed/simple;
	bh=jGBFm8DMVRl+cIY9ik911TDLmRtGw1gRGfluIuBTu50=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=udwERsaV7gVCFIcY2ShvQYQ22UYr6FuuZtKUADkZn69jh47K9vnfUM+YHpN7RvsZY37jVKB8lOoF1Ny/T4ydm1EEuoZbioVEHQ1haBScfvpQCcypf4tyft/Uts9u2GsJJs0K9ZMQMwJbgoT89UuBFQigQEdNIyEqQgpPHHdSsdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=QKS6y3iF; arc=none smtp.client-ip=203.205.221.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="QKS6y3iF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1728862291; bh=XgZ2Qa49k9aedugWqM8fyjuzPj2TUY+YDIuYoW1HvKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKS6y3iFqmSjrKttogO/aFRaIi4Ofabvv0gJe98vXXzPYFfnLssix63r0GkFSApzT
	 s5OBpzmx8vW9iVX8KF24E8s+VFdq7dk8OjqCcpy3VHe73ChLhNadA7HYYEdaqEDfkW
	 hpYiaFvGs1f04baoaC4coXVU1wVI9+Cm2yBb6S24=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id 7DCA7EAA; Mon, 14 Oct 2024 07:31:28 +0800
X-QQ-mid: xmsmtpt1728862288taar3kl0i
Message-ID: <tencent_9D4C78EA6D442CB56C2C97D4EB8EEC26CC0A@qq.com>
X-QQ-XMAILINFO: MHMAY6vlphTX6XyXC55uj4E8fpoHQg/ZXEe/hS1KFNm1+NahFbJBRIjLh55sjA
	 6Ki78I0cZJse6XOR9kN88c8wHvhenGXs160BhK+yqdIbzO6knO4UH75AnkvB/cAz5br317cCl2gS
	 bnAVYhV1efWM1W+8U+bS0KVbLMWNKGcGGTAD3nqQKskfba++8u+K9aPuQ+HTWbR5fMzOwStujB9p
	 NgZ4xere46d1FDdHJH/RbXFt3/tfXJUdmskeclcWlInymzmgGGG0QyL+q6npjpMZ07p1ZuFGhNeo
	 oh63dmQjAZ7N0QZL5HS0uw2JPRBPcSYc8mxGVnNG+/pZBiA+UI7u1sOX6i/O76CFwlOKXcvNuFj3
	 xEyDaEA/jI4q20WGel2qyQZqWQSvzgR91HCR27i1Cg4HzXsLVjPuaPN6Z8YrTov8D694dhBxZF+N
	 mcTxgiYbyB46sE1GGuUaoJMrlyCoA4jtmx6FhbRXa6QwsTkO+7gJ3OzM35uD8WUIvGih4ouBfVga
	 aEgIAlpUIKWInEGqETej8btPuQuGLjVj54IZdnoGSkhRiRHX4sQCBqOcjEw22HjPdIRqC9EdICFD
	 HGUSBYf0wfBSFKzQur5j0utMlfZ4SSDzqHfWrJtLuObsO4ApklaH07VCEntoCy8NQUsw1pQAl5bI
	 Q92otsuNDib6Eio4Jy5XoWCyJAfpIGuJsRlDNHOZjnE5fpyriZK2O6/jMCHUBz3IIFp5vt0b/Ocy
	 yqk0/PV32uWGskQcHc8rw7mWq8Z3qEUr+009eS9TW+yuoL6dyzm+df/T2LDUjI2WP7z9XxRlkwp9
	 YAuazHwQblrG6Vy6UxiaCxLCyYWQdgrBOs+GHSv3MQqdgGD8QIsqbn2l63pEoOBE63Dm8hcueXym
	 bfYqhEbgB1fSEYbWFGMhZ9oSmWmfcT5KNV1n70Ojjrg85vA/fH5KwCrEG3mOtTHuojuldBzwDoPR
	 RmhWUxd60tXifbo9tfDArq6eIPGCEAp5ioaaRkKjl2p+UekxrXC7K1SgHGYyEEDAIFHq0+LPo=
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Edward Adam Davis <eadavis@qq.com>
To: eadavis@qq.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V2] ocfs2: BUG is meaningless when the flags is 0
Date: Mon, 14 Oct 2024 07:31:28 +0800
X-OQ-MSGID: <20241013233127.2836641-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <tencent_10694B411BC625A4BA1BBB8033959EA31B08@qq.com>
References: <tencent_10694B411BC625A4BA1BBB8033959EA31B08@qq.com>
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
V1 -> V2: keep rc to 0 when falgs contains READHEAD

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
+		rc = flags ? 0 : -EIO;
 		goto out;
 	}
 
-- 
2.43.0

