Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442549;
	b=J+3OVNLqj6FTx8hvty12yEMAWZbFmA21iJNtLp/902T7WrrTadolDAubDjNo9w8x7UW6
	 Ef8MbCjyij35bhH7T+rDwubMjUDJlf/C+tQaC7X0MPG/LUmOwHR96bydStwEFRpTJWUdS
	 gvW0O+2yz4gj6+gcRQCOadGOq4TfAyeITvrxykEwBJu57NO446pZdfZvnL8w3mIMB2LFQ
	 taaC4APSJIEJO/55v7s06uHLzAeKYTYf0dJbfPZWIq7iYQv4vqkANYtST5262aakPy1yZ
	 42UFxLJ0GuBP+qxD5BR0LLBStTy1X02gw3UaEDqQGkafNZtLUGPKq2XAlwcss9ff1cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442549;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=JwQrfwT7frcR2b0vL9U7KAl8BP8bt75spL50zxwzzSI=;
	b=3hkkezMGdOgnNZ3IdeaCUBA5ecQZ6iqd5YyXovec/GtWviBxqoBEQuEpyY2Kyf4GdRrV
	 uYMw/OeUzbk3s+RM6NLroGKzUVo/GfqICOLw19jhllJKshJi7Y4VXmyCWBF7dFvwoVn3d
	 sx3vOZMGg6bGxvvqFyN7UjTcC5v6Ql06bjuRGmgTF57YX5ThMXnNuQBJX6g1GQcdA3l3S
	 m3+lagsxN8S8mXiV0Aq4SlznZeAchKAWIGXuju44rCZwDexNVjkUxLxuiuSFPJVwiapPU
	 ZNndfwb8pd06A/t2kr2q/3i0urOg1XEdyawKtauWsFGe6tTk3xYXW1GeJPXlzrNRq7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=QPY7XoHo;
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7818606A6B4
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 14:02:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7818606A6B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=QPY7XoHo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1795442546;
	bh=QmUJ+afkoKaCm+QSeG43dH9X+kC2myYf+nfZ4OGBHGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPY7XoHoZq0yXNFWUTt0ZlY6BJ+aLD4GlnJjrim1LWl537mSGyCb6EnJSuWeFIjSA
	 ++oc5J+O1lhi5BLOkrwfjLkTT85SO/P+cdj+DKef6lCtHIinWuJqjOkN2YFwgoelHq
	 TC+Da5NxV7BfzbkS5uO5ek/RviDKU7eyIMKaxrwmwtHNnvzWTQ20m4SwSuHCQDapfO
	 y33ek1+o7f8ugKxwNkonqz9zGeiXcJDqXBP+Qk1e49ySiZs1EflfQckvuzAph9c9Ly
	 lx7xgQwq1WJuLe1+4u6uDFR+4StJplU1gyTeRQstFQ0yr4m5Iq4f71AnRTnUATKBXA
	 JlEoTp6E8qPkg==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id A290A26B3D;
	Mon, 23 Nov 2026 17:02:26 +0300 (MSK)
Received: from mail.astralinux.ru (unknown [10.205.207.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Mon, 23 Nov 2026 17:02:24 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.55.149])
	by mail.astralinux.ru (Postfix) with ESMTPA id 4jY71C5l76z1FqF;
	Mon, 23 Nov 2026 17:02:23 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	ZhengYuan Huang <gality369@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10/5.15 v2 2/4] ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes
Date: Mon, 23 Nov 2026 16:59:35 +0300
Message-ID: <20261123143419.ocfs2-slot-validation-v2-2-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
In-Reply-To: <20261123143419.ocfs2-slot-validation-v2-0-mdmitrichenko@astralinux.ru>
References: <20261106104249.1811-1-mdmitrichenko@astralinux.ru> <20261123143419.ocfs2-slot-validation-v2-0-mdmitrichenko@astralinux.ru>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2026/11/23 12:55:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 135 0.3.135 58dcfca10e9e4d27990d8f7387f1467d65061802, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, lore.kernel.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;mail.astralinux.ru:7.1.1;127.0.0.199:7.1.2;astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 207749 [Nov 23 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/11/23 09:07:00 #28960424
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/11/23 12:55:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 25bf9e549360b656a6763232e0e9e58a00c3aff7 upstream.

Patch series "ocfs2: validate suballoc slot and bit of metadata blocks", v3.

The ocfs2 metadata validators trust the on-disk suballoc slot and bit
without checking them against the slot range of the mounted filesystem and
the capacity of the block group bitmap.  A corrupted image can carry
OCFS2_INVALID_SLOT or another out-of-range slot, or a suballoc bit beyond
the bitmap, and once the corresponding inode, extent block, xattr block,
dir index root or refcount block gets freed, the bad value goes straight
into ocfs2_get_system_file_inode() or _ocfs2_free_suballoc_bits() and hits
a BUG_ON() or runs off the end of local_system_inodes[].

This series rejects such values at read time, in the existing validators,
so corrupted objects fail with -EROFS (and a read-only remount) instead of
crashing:

  patch 1 restricts OCFS2_INVALID_SLOT dinodes to system inodes,
        completing fe7a283b3916 ("ocfs2: add suballoc slot check in
        ocfs2_validate_inode_block()"), and turns the "system file
        state is ambiguous" BUG_ON() in ocfs2_read_locked_inode() into
        an ocfs2_error();
  patch 2 rejects oversized dinode suballoc bits;
  patch 3 validates the suballoc slot and bit of xattr and dir index
        blocks;
  patch 4 validates the suballoc slot and bit of extent and refcount
        blocks.

The checks only enforce what the kernel and mkfs.ocfs2 already write: a
valid slot from meta_ac->ac_alloc_slot and a bit within the block group
bitmap, with system inodes carrying OCFS2_INVALID_SLOT plus
OCFS2_SYSTEM_FL and extent blocks using slot 0.  Nothing changes for
healthy filesystems.

Each new check was exercised under QEMU by corrupting the field in
question with an out-of-range value; with the series applied the access
fails with -EROFS and the filesystem remounts read-only instead of hitting
the BUG_ON().


This patch (of 4):

ocfs2_validate_inode_block() currently permits i_suballoc_slot to be
OCFS2_INVALID_SLOT for any dinode.  Only system inodes created by
mkfs.ocfs2 are allocated from the global allocator and thus legitimately
carry this value; regular inodes are always allocated from a per-slot
suballocator and hence must have a valid slot.

If a corrupted regular inode with OCFS2_INVALID_SLOT is accepted,
ocfs2_remove_inode() will pass the slot to ocfs2_get_system_file_inode()
and get_local_system_inode() will hit BUG_ON(slot == OCFS2_INVALID_SLOT)
when the inode is deleted.  This can be triggered by an unprivileged user
unlinking such a corrupted file.

Reject OCFS2_INVALID_SLOT for non-system dinodes during validation, while
still accepting it for system inodes.  Note that a crafted dinode carrying
OCFS2_SYSTEM_FL passes the check above, yet a plain lookup of it still
used to BUG() in ocfs2_read_locked_inode() ("system file state is
ambiguous").  Since i_flags comes from disk, handle that mismatch with
ocfs2_error() instead of BUG_ON() as well.

Link: https://lore.kernel.org/20260901125221.1634686-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20260901125221.1634686-2-joseph.qi@linux.alibaba.com
Fixes: fe7a283b3916 ("ocfs2: add suballoc slot check in ocfs2_validate_inode_block()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Include the follow-up to fe7a283b3916 so that the new suballoc-slot
check does not leave OCFS2_INVALID_SLOT accepted for regular inodes.

 fs/ocfs2/inode.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index b6fa3c8c6663..2b4936c8a789 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -561,14 +561,18 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	fe = (struct ocfs2_dinode *) bh->b_data;
 
 	/*
-	 * This is a code bug. Right now the caller needs to
-	 * understand whether it is asking for a system file inode or
-	 * not so the proper lock names can be built.
+	 * The caller must know whether it is asking for a system file inode
+	 * or not so the proper lock names can be built.  Since i_flags comes
+	 * from disk, a mismatch is filesystem corruption instead of a code
+	 * bug, so handle it with ocfs2_error() rather than BUG_ON().
 	 */
-	mlog_bug_on_msg(!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
-			!!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE),
-			"Inode %llu: system file state is ambiguous\n",
-			(unsigned long long)args->fi_blkno);
+	if (!!(fe->i_flags & cpu_to_le32(OCFS2_SYSTEM_FL)) !=
+	    !!(args->fi_flags & OCFS2_FI_FLAG_SYSFILE)) {
+		status = ocfs2_error(osb->sb,
+				     "Inode %llu: system file state is ambiguous\n",
+				     (unsigned long long)args->fi_blkno);
+		goto bail;
+	}
 
 	if (S_ISCHR(le16_to_cpu(fe->i_mode)) ||
 	    S_ISBLK(le16_to_cpu(fe->i_mode)))
@@ -1452,8 +1456,23 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
-	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
-	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
+	/*
+	 * Only system inodes created by mkfs.ocfs2 are allocated from the
+	 * global allocator and thus legitimately carry OCFS2_INVALID_SLOT.
+	 * Regular inodes are always allocated from a per-slot suballocator.
+	 * If a regular inode with OCFS2_INVALID_SLOT was accepted here,
+	 * deleting it would pass the slot to get_local_system_inode() via
+	 * ocfs2_remove_inode() and trigger BUG_ON(slot == OCFS2_INVALID_SLOT).
+	 */
+	if (le16_to_cpu(di->i_suballoc_slot) == (u16)OCFS2_INVALID_SLOT) {
+		if (!(le32_to_cpu(di->i_flags) & OCFS2_SYSTEM_FL)) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode %llu: suballoc slot %u for non-system inode\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(di->i_suballoc_slot));
+			goto bail;
+		}
+	} else if ((u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
 		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
 				 (unsigned long long)bh->b_blocknr,
 				 le16_to_cpu(di->i_suballoc_slot));
