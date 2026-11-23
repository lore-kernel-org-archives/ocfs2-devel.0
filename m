Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442554;
	b=5PAFC+kAWmp7MOFYa8idYbKEre4yZ30wK5uPTBPpWacHUuLgZYCcErUQ2cTl30cXPJ+Q
	 VluC8tY7PYcQnuj3U6+fPTULMywuWMyDn++iWpX9FJog+ZeykRawitB43AWrLn3lqh5M0
	 4L7Z2WMO3q1HOziWCJv+Bz5NdCgpwj1743b9iUYdO2XAa4YV1ulI3ASfVLVebiVmkYofA
	 at7Tx4FXWV04vg6OeLAiAVzTnL7MI0PLcPezZ2penxC8WU7hehaVmXNecn6z68WmWpt0e
	 RMErsbU+ZMbyqrkH0dhTQNOMDE+TT9/ad9nPgrudNnb6yT+02Gr1emRrMIkIekD1ovA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442554;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=LCYFbskMl+LyFHFG2nf8V+sGn8y0gNhHMxUxfnESADI=;
	b=DeqpW7CzYTmAoVCC7VwCcVnQ8xCYFw6dq0+ebC8AOHfKnoyVJGYx/X9WEl+ZLsplHtH7
	 LoUpLLdeSL01NVZdNpv0Xo76laMPMBgAAEgLI5E0izPPz1EkTttsg37a9fJUGKpDRt2Nq
	 Xn70EgfFAsaAQJvHuZ7S8l3Hm/6cZcpop38cMc/ni62uoVqbdee8RNV2oP/KtZUF/ODPx
	 I1BMdp39j+vTtbL4lHk61SR9eLrCaCOIPU08TPmWZeW+HAoGQufOpvVA9meaa74Tgmn8O
	 0XArGEhcPvCPZb1Rjqca+fApxzhKQedCfjweSuCFpZB8rBSxZ1EChwrTYJN56ivHkvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=wOgD8Dwb;
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E674A606A683
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 14:02:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E674A606A683
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=wOgD8Dwb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1795442551;
	bh=1ZTup9760Tx+vF3edc3wRkKhxyozVEtqdxyENtR/dLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOgD8DwbIUj8VJjT/MOr75KTWkfM+4g8tGT00dQRUliYdB6AMJ4U1bLp1prvmaZEC
	 sUClU3adNrmlSixTf4n2wZA/6/oiuJi6dr6wTosXXnAh/3dgS6gMOjfGpW2vJi/trG
	 RJGGPToWG3xMPzow7DZ2KqNcxlo0zzNfBLATLeTZN5RTV7XTN0g1DZ9ea+jIjQVR7G
	 zQRngo+n+vT4f3k+fkiw0ABJH7UCMogMW6T1Y5v8F8Tc44RU2NdBPLpuSrbJFjY0Al
	 bj077nqU50EkfAhQtZ3tvYsSv3faOR7jmKcPwCAsEyRZXxgP/fhBOWI2R7J+PMRQO4
	 4c0Cf1BM5AQuw==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 1255426B4C;
	Mon, 23 Nov 2026 17:02:31 +0300 (MSK)
Received: from mail.astralinux.ru (unknown [10.205.207.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Mon, 23 Nov 2026 17:02:28 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.55.149])
	by mail.astralinux.ru (Postfix) with ESMTPA id 4jY71H741xz1FqH;
	Mon, 23 Nov 2026 17:02:27 +0300 (MSK)
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
Subject: [PATCH 5.10/5.15 v2 3/4] ocfs2: validate orphan slot during inode read
Date: Mon, 23 Nov 2026 16:59:36 +0300
Message-ID: <20261123143419.ocfs2-slot-validation-v2-3-mdmitrichenko@astralinux.ru>
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

From: ZhengYuan Huang <gality369@gmail.com>

commit b2d31acbd3b182755b019183fb46949ba5e39b9f upstream.

Patch series "ocfs2: validate active orphan slots during inode read".

OCFS2 trusts active ordinary and append-DIO orphan slots read from dinodes.
A corrupted slot can therefore index osb_orphan_wipes or the slot-local
system-inode cache outside their allocations before the corruption is
reported.

Patch 1 validates the ordinary orphan slot used by inode wipe processing.
Patch 2 validates the append-DIO orphan slot used by DIO completion and
orphan recovery.  Both checks reject corrupt metadata at the existing inode
validation boundary.


This patch (of 2):

[BUG]
A corrupted dinode with OCFS2_ORPHANED_FL can carry an
i_orphaned_slot outside the mounted filesystem slot range.
ocfs2_wipe_inode() uses it to index osb_orphan_wipes before looking
up the orphan directory, causing an out-of-bounds memory access.

BUG: KASAN: slab-use-after-free in ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
Read of size 8 at addr ffff88800b767c00 by task kworker/u8:3/85
Call Trace:
 ...
 ocfs2_get_system_file_inode+0x780/0x820 fs/ocfs2/sysfile.c:102
 ocfs2_wipe_inode+0x292/0xf70 fs/ocfs2/inode.c:840
 ocfs2_delete_inode fs/ocfs2/inode.c:1155 [inline]
 ocfs2_evict_inode+0x6c9/0x1170 fs/ocfs2/inode.c:1295
 evict+0x38e/0x8f0 fs/inode.c:810
 iput_final fs/inode.c:1914 [inline]
 iput fs/inode.c:1966 [inline]
 iput+0x55b/0x8b0 fs/inode.c:1926
 ocfs2_recover_orphans+0x610/0xe40 fs/ocfs2/journal.c:2374
 ocfs2_complete_recovery+0x5af/0xd00 fs/ocfs2/journal.c:1373
 ...

[CAUSE]
ocfs2_validate_inode_block() validates i_suballoc_slot but leaves
the active ordinary orphan slot unchecked. Downstream consumers
assume that the value is smaller than osb->max_slots.

[FIX]
Reject an active i_orphaned_slot outside the slot range during
dinode validation, before the inode reaches orphan wipe processing.

Link: https://lore.kernel.org/20260803030007.3993199-1-gality369@gmail.com
Link: https://lore.kernel.org/20260803030007.3993199-2-gality369@gmail.com
Fixes: b4df6ed8db0c ("[PATCH] ocfs2: fix orphan recovery deadlock")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: bb88131c9831 ("ocfs2: validate DIO orphan slot during inode read")
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Backport fix for CVE-2026-90205

 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 2b4936c8a789..117b60ef0aff 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1479,6 +1479,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((le32_to_cpu(di->i_flags) & OCFS2_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: orphaned slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_orphaned_slot));
+		goto bail;
+	}
+
 	/*
 	 * Reject dinodes whose i_mode does not name one of the seven
 	 * canonical POSIX file types.  ocfs2_populate_inode() copies
