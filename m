Received: from out203-205-221-231.mail.qq.com (out203-205-221-231.mail.qq.com [203.205.221.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA202E7624
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 08:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766133126; cv=none; b=XcMa85sFPfHG1OgTDrkySFirtjvbOgm0kTn9Pcaangl72QSdbGAWFhihPlE6HibxIxG3XaJ2ub1MVFaYtu32H4rLVcsqxHYE+QjF0MYfacZrVpZHbZ4MSolE9x9Djn24Bto54+ANFFrJx2CXKBsIVo+tHFI1TWPVjGNEUqkFyOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766133126; c=relaxed/simple;
	bh=w7+CfDEKDfLzQ24n+M6izOoFndfmc5oNrw2orqbNxfY=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=SHANEhl+C7XqQjzgvf0hufdeoy9ISHt587/u7x0o/GijBr182pRzqoVKtaEvH5rxR/O9wk62cO2uPECRdNXPT0TCh9nhl5cn9Wf36LjuMSW2CRHQq5DU8TvDUV4LN6GeZlpPrUY0SBQh8HiIUH9Cl51Qf5ogyRSseIMli1ySODc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Qtr/rAGP; arc=none smtp.client-ip=203.205.221.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Qtr/rAGP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766133114; bh=9vdOKUAVu3Zy3wqmF5yTe9WaOGspOBMNja4vt+Ikg/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qtr/rAGP1B76xyH4tp6L5LibN8+mytsNQpl/HZZgq7BLnSzwCAj2Cv/RNeY1HNdC5
	 koLIOaHOuiy2s5dryxdtn1G2FX26MhdzSxdtLde0onz7Nc3w7xHWPjo3i6lJHd2N0Z
	 3DA61DOE41hphRgkCqhQmK+czkpi0qbSwXBAqOzQ=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id 7F3B60AF; Fri, 19 Dec 2025 16:31:51 +0800
X-QQ-mid: xmsmtpt1766133111tpcgwbp20
Message-ID: <tencent_4D99464FA28D9225BE0DBA923F5DF6DD8C07@qq.com>
X-QQ-XMAILINFO: Oe8iJ2SlZYdbPu2YgWdjxh+wug2txsA2lLl+7FmLp+3UzgNCYHe5+F9/Jb7kLZ
	 /N8PlTbqCP/W8pGSl7d1xJyAZxlqobnLQwuH8TmPz48rekOWzXP10lTw4RafEqzwYXY05QcYUQ6l
	 rEZlOhN4QSlIJIomKhLTVqvoUuMZWA6J/7doJ3WugqnBEIwB8W63beF869LqGC+82vmjCjBT3l8e
	 w6Dk5RtamPF8frhsY/JJKt2NXVs9X5dnw5t9Ge/ZipFVByBTDEfF3Qd7+21EWhIu+AkBymlRX0dg
	 lSK5dQIicPPcM380TocUK33SL8Q9P+E1OEPS5+CP/5WmP4ltAQyCi5aVCCAIHojWL4HOVajHn28y
	 9CY2mhwl/L2OF95POrc7YJURS+cPwQtur2mruu7oYmHOrQmL+pPVEQ05S6vEP7BcJGU7BBifu27s
	 2UNBSrMm1wegVV+K3jPIbqhLSdtbuouWJDl2ESWTUiWu+ipIZfdmS6bEgO6T3cPjaAp1VRh12ogg
	 Xe94JtuXhxqHKQCdz5SOmlbu1c+SvsayrTrEUTapF5kfBGZs49nCk393dAZUqIJY4UzqVqQvP7mE
	 OSnoGrTq+uEeZsafhfh72AA/K8NTB7UTJ8by4DteUcpbBXp4+0zv2kyLOP6BchAiX+EolrZwZjuL
	 so8EYy8Dx4SflwvH8O8rbtNJI/DjcrS7zxjCgqV7vZVDg7misNz1a0ze5C7ITGtAtMIQdsn48Xob
	 86cOyAZzlaCJRMMGVXqmRvpC88MWseMvXCoDSad4/CFoa/2ufmW9cvXbX2N0xRb9ZgOXWiuiWJXn
	 J32k5MnMFzYUZv9aOMnaX5WHb6Qx7Aig1YljVH+BE8grBtSFP8FdTf/r9cqLXy5QSVM1TlhO6bhB
	 ZNUD2aCDqC24RrxHexBfd/OA8Wbyq8RfxrKHY8Kd0K6jGgCeVwNyyeHImE8EJ+gMdZdbUJCi986Q
	 9qe5IcnBbJIgI8/kJhvhAJ3y3udpf0qbP6EVlmI6BLUd5gHrjViLVP+R8Jpie5CV5SjKy+1LyDXE
	 ybwVpMU/tWabWjES3LLo5k40cVrskAyTIuCTG/WF+DggnJIRm7RLjDKsAfOw90TayqGrLIRL1f3a
	 SJz0tr
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: heming.zhao@suse.com
Cc: eadavis@qq.org,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v4] ocfs2: fix oob in __ocfs2_find_path
Date: Fri, 19 Dec 2025 16:31:52 +0800
X-OQ-MSGID: <20251219083151.121442-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <rwy27v6h3su6i7osrb5aelexurlg7ggbzeedv7bghuwhe54uvl@nfwl3p5xugwh>
References: <rwy27v6h3su6i7osrb5aelexurlg7ggbzeedv7bghuwhe54uvl@nfwl3p5xugwh>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot constructed a corrupted image, which resulted in el->l_count
from the b-tree extent block being 0. Since the length of the l_recs
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
v3 -> v4: update comments
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

