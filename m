Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E70020459A
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 04:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766120114; cv=none; b=ZtockwrD7HVvMBZcH3K69AzsHqopcHhHhYOTdid1KZ9K2fcVqh1mFvYFoasQ/ER3DS/hc9udv9yn2fXINmz1zIZ8XaMtvy+L8kiYaEtTOiFB3YOPTqTGhNQJop5nMDM8xXnv7ZeQsVkYiUkbUo87Rw9zfDYV4aWtS/9CX3+wb+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766120114; c=relaxed/simple;
	bh=u4aUP/yjqutJlJHhwWBUcRK6KbOQO7K9QNXpO8KYHuk=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=AAZt2BnD4WDsSrspZdzgDfwBbI2qaj8M2A97Y1zlZKF+9QbUo0esLOvec0Y76GrGdVZgZHu70jbKrt37xsWkoW4VJubFSLHDSVAAsyuBteq4/Gff7PQdlsZ1K1Krvoxv7wj8Jx8owXSDdpL1n3jbb0BaiJ7qM5k8CJB7cvksxs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=i5Z6GB8c; arc=none smtp.client-ip=203.205.221.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="i5Z6GB8c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766120109; bh=AW+1fOOQupkekJgPK/pS42Xp/1KK7wALyEdzoGyuW5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5Z6GB8c4S/sHmCV5HHXQBCcc5qYkg001ss9lVctCKZmCk2N0FAywMT1eN4rv0t1X
	 weE/I+i0y9i/b+rawY2dVVgDf2oYURexkerc/A1UimKMjAqDVXsr0eb6/Yd9sfSMBx
	 ACuo9Er7M9AXliaKFLByIL1Y2Sg7UQ3/gCe9a1A8=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id DC6312B6; Fri, 19 Dec 2025 12:55:06 +0800
X-QQ-mid: xmsmtpt1766120106tg3qxjxw9
Message-ID: <tencent_585DA45DC5993F4FCC0DA6A5F38DBD921207@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25GAk7A6D7JmA7bQtWbKuP1Ypm1uv970hPX+p1V0WhMAdTHPYc01T
	 YMBuPae2siuqFOkDMV6DpDNXJFa3MU8/YLbGkVWfYAVcsmU2t0wU5c0VwnD727dP1NqoTQyNGQZ2
	 wQ/N2nQgph2HtI81JW42Zs1FtMZqk82vRn1x8fLiiOY9+Z9xgGa10oviHCVR1FaKtJ8z37dk1RJH
	 Tr2uUOxMyaRllRYY8MFABImDA/3K2yt4N9s2TOXyBIhlI/94A4iLZZi3R2hFLMPCJby84SPX5OnH
	 S5h5Ysz2PoyROvvmPnxT2fqaTjg31g2or+7Vc+6J+NfcJFU/IX84rnnGQYO7YiaqRFPEkHgqPERG
	 3jYO7Wm5B3QECTDH1Ka2ajsV+1uMs9IhPH02wGGgg0UaqqVYqaoUfWwYVSHpI/7fDRg7GJns+7+/
	 oCwJ8p2H6/fParp2VdDs6mq4NNlAHMvtRLsxNbHCr78lA73xb2e8H+HXC+oWonQx6edCuwNVUXAp
	 FrvEr01f7rnhLorvC4RCoTDch/uc9wFVsLMZFWmjhFfY3NpkrK/n9sxEpq+rZl69fzvUujblXszb
	 MBOw4dcm0JfKpf7m7MWHgKxBPZ8mFxWwKG24CMRECRCOPS7KKuH1CnMh3K6GqnqURgPol76jPaUX
	 /IZ8dXP5K7g8uoVKaljCS6hkyWH8qyI5YRtAqJc+gwAhkhEbQ21uJwcOr6Pjl3duC0/2EdXJIznU
	 6pG8NhWqQi/I+6/H/0TzBJ1WW2x3BpIU33zFO2pLOOM4ytuza/CoVqEVvtlLdfdKCdMkFls/5i0n
	 IIciQnMY1O2nbX6NJyJk9aw+t7iNNNH3Z/rmt9S5KspEvyknn/Nnf796CRArSaNFpRM56pyls1wq
	 vCGx5Wo98y/oMCryIPzYRRe88kdYuDezYV2N8NggRnjc128FHj3/7VxRMTLu7ILKdDWq/gqwqk6e
	 gj5C1mi2zae4VrzO6/8W6dFriYf6PDFYGaRZKwfrKSQK2mupNj1B3laa+MSrnYP2qOSllQpVOO2x
	 VRxevUhfwVUIcherXK6O/3QStGvhozw+LEmbFeWouDyZZCOwx9frRJrTL4Y3/vcCCzAU1J5g==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Edward Adam Davis <eadavis@qq.com>
To: heming.zhao@suse.com
Cc: eadavis@qq.org,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v2] ocfs2: fix oob in __ocfs2_find_path
Date: Fri, 19 Dec 2025 12:55:06 +0800
X-OQ-MSGID: <20251219045505.110842-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <5wws3jiutruexkk4wl34wootqtfggj2h6ezrbemvtn7ykgsumq@3komfzq36st4>
References: <5wws3jiutruexkk4wl34wootqtfggj2h6ezrbemvtn7ykgsumq@3komfzq36st4>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 2f26f58df041 modifies the definition of the array l_recs, specifying
the number of its members as l_count. In the path shown in [1], it will
first read the inode block where the system file directory is located
from the disk, and then read the l_count of each extension block from
the disk according to the extension list of the directory. Then the
value is 0 before l_count is read. If the array l_recs member is directly
accessed, the oob in [1] will be triggered.

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

Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
v1 -> v2: check l_count and update comments

 fs/ocfs2/alloc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 58bf58b68955..44bbc51276de 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1812,14 +1812,16 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 			ret = -EROFS;
 			goto out;
 		}
-		if (le16_to_cpu(el->l_next_free_rec) == 0) {
+		if (le16_to_cpu(el->l_next_free_rec) == 0 ||
+		    le16_to_cpu(el->l_count) == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has empty extent list at depth %u\n",
+				    "Owner %llu has empty extent list at depth %u "
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

