Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F152877E3
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Dec 2025 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765807781; cv=none; b=udxYYOJd//ZKGNX8/vtoI9bDmO1nLMcYnknC3cHeud18RsIC2ealKgN9Pap1fYUvrg9Ca/JzHgkGawNr3NO+5HhTBH9SJPvMpuFnatEsfClW8D4pLhNoBOQoPxlYLA6OhV9Alxf9bBPnN40IrNHRk9Ic2wYXo+1j7DBAfeqRNvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765807781; c=relaxed/simple;
	bh=7eFNjq1NsUN+Fquxr6c6qynAHcGbfWX2mv8cs4hurOA=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=FrFogek9yfCMK5zg8GUUS3cZM5snYNf/KouWt05lcmkWugRD8gXM3mNH1fx64vdd18pjTR8vaDxAW5LwaR30q0w4jsVIEk2/PyTkSlKkG4TPgS47Tz5q33DUd6uyyqFwplvEUdK+IbAaDP9b6vHqPY8cHrTchu7KP1nkR6FPAng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=dHS2wy9F; arc=none smtp.client-ip=43.163.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="dHS2wy9F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765807774; bh=xbD29CNBFkQGlMjReuF767zT1NcF0qJ8ksZQ+UvvBTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dHS2wy9Fnk3gOZNK1O7uw8eXdnS9aF56h8bpcxa6QOMJGxRwiw3b8BW7gCiTE94xR
	 /wZDifyZxOBZ1l2z+c03vF5Zzsnxk53GK17HXZDTQoPLge9GY+LzRytLF6iStxBicH
	 C72sMQS66k2qQ9KZhLZgHxI+LlIN2JAZhNw6Kvho=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id 25FBBCD1; Mon, 15 Dec 2025 22:09:31 +0800
X-QQ-mid: xmsmtpt1765807771t182v721g
Message-ID: <tencent_5EA7DB86C912FD065749A52EC12EC94C8B06@qq.com>
X-QQ-XMAILINFO: MFA3rFz8fXqrRl+M5aRvLsZ2dWEU9p37I6EZxeZp6WAAxV0IOcNV2RNfMpVgTg
	 sbw2jgGiddvxKz+Cl5+YQfveTPBqoFeuaNGMb3wkhSKcTwZ2rVixungzCy7SwRRMBSo0+fCQKtl2
	 S+V6KItHwRl/Fo3kbyw27GcukbiYEjq1QHeK3DVztUrk1tciSOHMsa25Tlz8RwcEMmskwDc5EpD6
	 WojRe4OWWis4OqYn8tvpHxkX8tUzX1XuIU9rfM+ghI28d1fZB6sHXFRfmxmWSNYLpmHqNSfuMo+x
	 WdkDZAvHOvRradtsmqYjsFCgjZS4uq70TpHaS0zUZ74WtMW3BaxgZ6hTaFIE1pzFWfO8d+q5VvPw
	 uWitKJv3XfYAraMsgD1rqERsYvG1554oCS5lu5sLRL3yA3zcUXETkaC2oi4U/MlZEttwyBS7+AgI
	 4ss+s5pk9PrzUxYpSCzT/FzmXwosoZnTA/Lh0ffdMfh+hxGB+d89eJaFWoPXhqNHfO77MtNHK291
	 b+rKW220yrob6aLxRTh2zuk3qbaUOxEDT/Kx9sSl6PS+VNKojtWzO3x3tMOWBN8htc2AFq366FS5
	 5xPNrPTtbgWlpPckfvwETIunRPM9K1OmUWSLzvbcLCOD6W0TPSPOhfZUTQMmee5k23jz7MxX8n5d
	 pY3ZQW1iDUbhNBZhqDAlHnVoNmXN5rhxly1eK5efnOfpEedAgj4sTW2C1L27DNzeetkBh6aIm+co
	 Z1hipav8Clq3LAW0RNa0FeAandPfu/J269h/3sb8HKvt0n9wWeX4VEe0SJEP6LcHkbOZwZsv3alL
	 EQx7nlZPs4grApF9G+oQOAx+NmvusKIZX/RU7/G840+5d8wCv5scOtooP42TOtOzXtag69PgoZR5
	 vQqY2Ecmru34v856uGUhEr9X27dnVBpUVSHh497JW4dV1PBHiOLPA2as9/hen7XCCtycL3os93pu
	 Hu8vBfzo1XsjH6YwEhASLX+DlT3CSSuGPJ4W3Ftn7vfoLST5FT+inL5ROK9yitnW8er/6mCGmb+t
	 MtnS2MKawQQo6RCfn9GhZEF1YDo2X3tnPyGgwUcQ==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] ocfs2: fix oob in __ocfs2_find_path
Date: Mon, 15 Dec 2025 22:09:32 +0800
X-OQ-MSGID: <20251215140931.124811-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <693fd627.a70a0220.33cd7b.00f4.GAE@google.com>
References: <693fd627.a70a0220.33cd7b.00f4.GAE@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch d358e5254674 modifies the definition of the array l_recs, specifying
the number of its members as l_count. In the path shown in [1], it will
first read the inode block where the system file directory is located
from the disk, and then read the l_count of each extension block from
the disk according to the extension list of the directory. Then the
value is 0 before l_count is read. If the array l_recs member is directly
accessed, the oob in [1] will be triggered.

Use the rec pointer directly to access the extension block number to
prevent the oob reported in [1].

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

Fixes: d358e5254674 ("ocfs2: annotate flexible array members with __counted_by_le()")
Reported-by: syzbot+151afab124dfbc5f15e6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=151afab124dfbc5f15e6
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/ocfs2/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 58bf58b68955..1ab0b9095a7a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1836,7 +1836,7 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 			    break;
 		}
 
-		blkno = le64_to_cpu(el->l_recs[i].e_blkno);
+		blkno = le64_to_cpu(rec->e_blkno);
 		if (blkno == 0) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
 				    "Owner %llu has bad blkno in extent list at depth %u (index %d)\n",
-- 
2.43.0

