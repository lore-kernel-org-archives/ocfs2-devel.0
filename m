Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8298F64
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Oct 2024 11:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728906501; cv=none; b=dy8VrSq1R2JP26N/BWsO8E4HzhVCIy0/KSwdYNwFaoM7+GQ741Bqd7nZSO3De0w/gVMgptREq70QL14hEN1mfqn9ytHuwU9MzgrwPW5JuruCqy3hOAlm/e0f+5YnwWo2XO7R9eU0P8J5i3HGSYpA3A5O+qMGuWx3taxeMFWCg24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728906501; c=relaxed/simple;
	bh=+MGkNQ1ds8E8v8RGXN1V0YRWJzr7vHOwLdZd9qDzmUM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=cUW7M4O+Ka1hVQ3sUPphim4u7J93BVLm5N6rB767/CKHMyKr2rUS72X9IxP1rG09JwKaYgnlNWCyZz3UdHkPo5zULonj8iNus1y2aNdr5p+gMGtHw2c5NlB6hoemxQBYd8f8Gj1BMSBxuWeCH2g4HqkMUJ1qoZkKldohn2hfwJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=FNaV/dxG; arc=none smtp.client-ip=203.205.221.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="FNaV/dxG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1728906491; bh=uLKofkemKMYHtX/PsB7KQi/N9gxjHQpFupUrdYhHAhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FNaV/dxGhLZN7R9cO3vfO9QNFqhgejOmXoUUU92YzOIQKlf55zRUwBiR856nU8NZt
	 ImxYt85S0IuS8Tk3QXDbsAM6JEclbUz7MMWSk0KT2xIfmL8SxXoyzvRKB1gvhFu9Gu
	 a3gq+lO7qdmoP63Bm/WwDijhrJQVfki6zfzWv/tQ=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszb21-0.qq.com (NewEsmtp) with SMTP
	id BF991C39; Mon, 14 Oct 2024 19:47:57 +0800
X-QQ-mid: xmsmtpt1728906477t03q5dfpn
Message-ID: <tencent_C8EA75F1764366383C3F373A972436904A09@qq.com>
X-QQ-XMAILINFO: OEaI/iTChbug+xsPGDkvuYbGfD19sPwcXHGzkR1Lt7tkFjakCAU/XAx4lFAvL1
	 fvxaS/id0o+7ndeT0m4JMpC8O8VAKa8dIGa3CZFg9dOpoBF1gwkTwKO+oyDmzfh4XmDv55JHH8AE
	 hzHJEWVPlhW90iYFCEpMZ7atME6BZxuGQCAfpbWBrg3MdFJ2x5wAmfFerXQFCR+iB0onIU3SgxcG
	 q+fryRgAAIjiINhKcS/H/WH5Kc991h6MXjKDgM3LK0mvJrg8E8wCHHihSNnsUB6QqZs10Yy3TmIO
	 BpHCknCBPSU5ZxRkhzchNCw7q5bwPgtwI3s38CbmUgC0X7nhWVypQ1ookU5j5KS+SeZpJPMSclyU
	 hgGKD16f/dpMT3TrtKPEqXHB/5+kQkB/W/saqfZ56nrCNFq6kT/cSjSPFKI2Tzf1GQSjkfGJGzB/
	 jxOlj2Sr+FTvQHYVx5mZTQ6NSE07wsZKD1um878tk5X0ST9HwkhbheH1FVXGaXyZWT060VlVNQpv
	 Hc7J5GcUcYvIOirNjK6XgM9BRgm8X70dTLr3mt0mjFw4hbkuyAb2pyAd1OgkjB61KVImISKrfCdr
	 5VRbYIzWe56du1DW+363oygBPxEfL7sn/za5/oOzLoJhLli9/2J8rT6Sk2VXOzhIsIzmh2+gslpY
	 IzR1APIoLxonaSavtrGHWeTVitYB56/xvtORMHAcDYDIKUMJZoyRM+3HCbDP8l97B2uYDG0GpKwG
	 F4pTQSmCkO7Mpc60C/tP7qUXm4KLsA9EUxaSibGvDKiptrt7WmewlKiDTSJmEe5WCyJYCo4F0J/M
	 n8TCM8BhbJJGzqgUY9vfAcAHGqc1oKaYBZ5L2O5XRJL4TJvBKIQ50Yg9hcam3VHLXh0MYlMGU0QO
	 I0TKXOTBUSiphLJrHxAd6D94H1lw57sCtsVT8ZOW/Tw7+vFWTCCkIZaNAMJEM5bFw3pG9xSbhIMG
	 RlgW9RVc3QcrHwrs1siINSJLKuRo80jc7pqRxQyrOZXnz3txFmUhLTh5WM6eqfpvrbAGCPcqXq2+
	 5zrSoaRw==
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
From: Edward Adam Davis <eadavis@qq.com>
To: joseph.qi@linux.alibaba.com
Cc: eadavis@qq.com,
	jlbec@evilplan.org,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V3] ocfs2: add a sanity check for i_size
Date: Mon, 14 Oct 2024 19:47:58 +0800
X-OQ-MSGID: <20241014114757.3480221-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <431f1d14-ba07-4903-ab02-b4628e0f1973@linux.alibaba.com>
References: <431f1d14-ba07-4903-ab02-b4628e0f1973@linux.alibaba.com>
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

In this path, v_block(0), flags(0), and nr(1) are fixed values that are
hard coded, so if i_size is 0, the bug will be triggered.

Reported-and-tested-by: syzbot+797d4829dafe3f11dce7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=797d4829dafe3f11dce7
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
V1 -> V2: keep rc to 0 when falgs contains READHEAD
V2 -> V3: check i_size only and alert subject and comments

 fs/ocfs2/extent_map.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

#syz test

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index f7672472fa82..29d27a70dbdd 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -961,13 +961,17 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 	int rc = 0;
 	u64 p_block, p_count;
 	int i, count, done = 0;
+	loff_t i_size = i_size_read(inode);
 
 	trace_ocfs2_read_virt_blocks(
 	     inode, (unsigned long long)v_block, nr, bhs, flags,
 	     validate);
 
+	if (!i_size)
+		return -EINVAL;
+
 	if (((v_block + nr - 1) << inode->i_sb->s_blocksize_bits) >=
-	    i_size_read(inode)) {
+	    i_size) {
 		BUG_ON(!(flags & OCFS2_BH_READAHEAD));
 		goto out;
 	}
-- 
2.43.0

