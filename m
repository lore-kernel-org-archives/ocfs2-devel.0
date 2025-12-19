Received: from out203-205-221-192.mail.qq.com (out203-205-221-192.mail.qq.com [203.205.221.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88662F3C3E
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 07:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766130220; cv=none; b=oNHFiuGTkb0c3FMkv76Gyr3zrekqZTescxoMGY62BNzQyBC+BYH1MR3r8aWBMMdvKU2RBO2/5uAUlss8y6WRMSmchscM6RMe8PVr9opZTwBZq14mff2ET+RLDX2JX2+aPyUK7zFWurO/2zr8zrBbcfU7iNle0vImMlYAprECk/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766130220; c=relaxed/simple;
	bh=ImhYUtMM+kyYNR71KLPGwAwsFLGjfqmHWqoyU8h05BI=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=F77WX47qfbcjOLBlftR+pGI0gRTE5ocoLgY7/mBIYacmwipk4wCT7C89ggx4nJFD+OAipYYDxkLN7vHa4SLWnGmAVYzHZjUIIIm7TKPCXa55h6F8+N7zSx3NkqlmJ9L4P6iLySUrPPt6X9cxGzmwp7VeQNFhzfeXo0I2gjo4D4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=mkY1Gr8L; arc=none smtp.client-ip=203.205.221.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="mkY1Gr8L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766130215; bh=CIpunve5t0XwgqdV3VDk4SqiHuOVNIhzFcG7B9MiVPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mkY1Gr8L7XDQyR7DP11tvphC7Jhr1DcYpl6jhYo9J2CtZneu7AwbpdZRA8SQl/kJZ
	 6oYSPPxoCs3FVO3qj9PWrep3DArQkEtV9sL4jdThS056WJAAcR6vlnOaw9Q/Ck+phN
	 2M/AgBl7wR6k6R7EAQc+S/eYBvNsPtUukGe9FJr4=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszc41-0.qq.com (NewEsmtp) with SMTP
	id AE03F42F; Fri, 19 Dec 2025 15:43:32 +0800
X-QQ-mid: xmsmtpt1766130212txiolsplk
Message-ID: <tencent_72C97EE3BCA443F77C776D46CAF36D436E05@qq.com>
X-QQ-XMAILINFO: No7DFzN00JnRczQrdX6tH8itC7IM2wuK4Xu0wlEWYdeezU9lhPot7WuSAAVcmo
	 TW4i1MXw+DwUSvej0ZJaDMUohcvSPNlFd6re8Uxs6PECvTNenBi4GcobvebkWi1oEyTkfKt8Qs66
	 lDghnf4thF5FfaJ9Jt/JvuUFI9cn9QhwAAEapygPcstFlQglI1DGIRZoFq/HDmcHAEo1hoXPYnvY
	 t3evvWsuZsn/N5zw1tSKN7JL1P3Jgh4Puouq7h+1IuuSjgQmE2nvFM9I9SiaJegPbcK4JpVRSCwX
	 QzwwOlvjl5tMOqKhOLePPo50FdQS4QG3gX5RYZYSeDe8afSoeOunPxNWlz/9cP9OawSfxeQPTfpl
	 wKL1qHqwP0/YYJwDSRCcsnbIoNgrx/wxFpL14bCRgIttlg09kuh4FbNg1QHCI/N3eLk7smbOjy2X
	 Hd92gpDjOTzXum0fq02bhAWhkJEMMdJeZ2fzkU2qYkXKQoC4OL5vYpKOyS33COwzZ1HE9OrVXwCp
	 zMALmaLFC0t4Kod7VxIopZNlrlsXQzBKkTnkLExAlK4Ptu7KpljmdTNj2E+2N6K2kZfXyUogPVIR
	 Gshphg9DUievBosLg5qi+yPRZa7od+bhtfNR450bwDoQhOKu8hvVqD6yaOl0AIHfVSDL5VBKJGpK
	 v8PMkNgTD2aJiygJ8F1w/1br4JZvBb7b3Mri37BHXEMNfhyQ0RclYw5iB0U3mWWuhi3WsavdYA8v
	 XPZGA2oec/aYMXtFtDlG2zbQsySSLirrgvjIi9urIDCOIby2D/VMoq1rD+XejpJpbbMDHKd09G9h
	 o460eqxKlcdYmh3D679WHoMDjfM1e4Kr5sN7+2DckMAx5OnARa2Yxonnda28JI63tP1wegJ4wIUI
	 sh6+mAiUPGBy7oEIGFnHyhMA68lFwG0KOuFi3JHjX/ndwc3a0m3DKlyNB/p5dLKqM9BkpneFW2Xi
	 MOtxgVt8xXxqKcgqZh4u4ffEYPkdjsbKJy7+CUJjDDxmS/H/GFbM+b4fdBTEZ5Uk9qH2SyV4wPLd
	 xs1BLlG1HZWJRFHS/H69sDD+xgUhYrqHZkWAxo4Q3KczY3RGXAmwreICW6t8E=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
From: Edward Adam Davis <eadavis@qq.com>
To: heming.zhao@suse.com
Cc: eadavis@qq.org,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v3] ocfs2: fix oob in __ocfs2_find_path
Date: Fri, 19 Dec 2025 15:43:32 +0800
X-OQ-MSGID: <20251219074331.119394-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <5hyc4g4g6uxix5jncqi7ukhmdzq6xoxvou5dkvpj2o5y6v7zoe@qgvucbpcvbqn>
References: <5hyc4g4g6uxix5jncqi7ukhmdzq6xoxvou5dkvpj2o5y6v7zoe@qgvucbpcvbqn>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot constructed a corrupted image, which resulted in the l_count
value of the root element being 0. Since the length of the l_recs
array depends on l_count, reading its member e_blkno triggered the
out-of-bounds access reported by syzbot in [1].

The loop terminates when l_count is 0, similar to when next_free is 0.

[1]
UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:1838:11
index 0 is out of range for type 'struct ocfs2_extent_rec[] __counted_by(l_count)' (aka 'struct ocfs2_extent_rec[]')
Call Trace:
 __ocfs2_find_path+0x606/0xa40 fs/ocfs2/alloc.c:1838
 ocfs2_find_leaf+0xab/0x1c0 fs/ocfs2/alloc.c:1946
 ocfs2_get_clusters_nocache+0x172/0xc60 fs/ocfs2/extent_map.c:418
 ocfs2_get_clusters+0x505/0xa70 fs/ocfs2/extent_map.c:631
 ocfs2_extent_map_get_blocks+0x202/0x6a0 fs/ocfs2/extent_map.c:678
 ocfs2_read_virt_blocks+0x286/0x930 fs/ocfs2/extent_map.c:1001
 ocfs2_read_dir_block fs/ocfs2/dir.c:521 [inline]
 ocfs2_find_entry_el fs/ocfs2/dir.c:728 [inline]
 ocfs2_find_entry+0x3e4/0x2090 fs/ocfs2/dir.c:1120
 ocfs2_find_files_on_disk+0xdf/0x310 fs/ocfs2/dir.c:2023
 ocfs2_lookup_ino_from_name+0x52/0x100 fs/ocfs2/dir.c:2045
 _ocfs2_get_system_file_inode fs/ocfs2/sysfile.c:136 [inline]
 ocfs2_get_system_file_inode+0x326/0x770 fs/ocfs2/sysfile.c:112
 ocfs2_init_global_system_inodes+0x319/0x660 fs/ocfs2/super.c:461
 ocfs2_initialize_super fs/ocfs2/super.c:2196 [inline]
 ocfs2_fill_super+0x4432/0x65b0 fs/ocfs2/super.c:993
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
 vfs_get_tree+0x92/0x2a0 fs/super.c:1751
 fc_mount fs/namespace.c:1199 [inline]

Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
v2 -> v3: remove le16 and Fix tag and update comments
v1 -> v2: check l_count and update comments

 fs/ocfs2/alloc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 58bf58b68955..b7db177d17d6 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1812,14 +1812,15 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 			ret = -EROFS;
 			goto out;
 		}
-		if (le16_to_cpu(el->l_next_free_rec) == 0) {
+		if (!el->l_next_free_rec || !el->l_count) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has empty extent list at depth %u\n",
+				    "Owner %llu has empty extent list at depth %u\n"
+				    "(next free=%u count=%u)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
-				    le16_to_cpu(el->l_tree_depth));
+				    le16_to_cpu(el->l_tree_depth),
+				    le16_to_cpu(el->l_next_free_rec), le16_to_cpu(el->l_count));
 			ret = -EROFS;
 			goto out;
-
 		}
 
 		for(i = 0; i < le16_to_cpu(el->l_next_free_rec) - 1; i++) {
-- 
2.43.0

