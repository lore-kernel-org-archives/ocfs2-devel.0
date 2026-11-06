Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961842;
	b=ulHx5qFRVN8YYfhFft8ICAFee//mH5OIlQ7oQF1toxxEIsnmk4p911KgmMH7hbMJ86Nd
	 A0Xs0Q8ls21LA5LTuQu8QkxrkPw+lO/lzkDUq6kozFfOYcbqjp+Z3RK1rjJSaZrBFM6Ce
	 iJnBy+WM5iVIIrkyBb5bxDWduDzJ/xbeoOi+eWKskOO2rYmqFYhQwA7s6ESElSxoDj1n+
	 BtdXXkFWbgtsLONC5jeV5opUh5vymSg7Pg7d2hYf8+wM/7VSxprsCYl8srnjvO5DvTaEW
	 TRnK7rEH8ZbWlJpbujz/uniat/53wgrBblmlN1eJ2U8Ceu1CKBcIdGpQU1xeSHYMLTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961842;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=KTFcSJ8/z5I4G3fn/muAWFhPzwBdN/4P41KeljFTC04=;
	b=tGJZDhaWJRc9M9s7Ea5X5n8FpJrIgXTfjZahfb4EOwYY4o1LtNuSaeVxCUFlQfTkGG+b
	 Kb4hXGJtM2E5NcpCeNcfxDLOARCf/xeTJzejNjDuNwkRjvCl9ZHMk0QFHPkyDJrNaGrTn
	 X7x4jn4Z83Qm7EIOZ4OPuVdJYsMXIVehS+5QM2K5mStvVkmv7+JmYrUTAfpl4Y/WAoYmO
	 ZF9LO2bg63/rKnRT4r25IT/YwrDJjNQde4YJejm6a3m5z4WfdjAvQ3nQcwwfyiXU8GCHm
	 //c/h++QXf8/C5SbFTvtd1BUr7Pv8dH/r0XKN5+ACJ4HtLC1r2dnB5+bJeNzn/G840A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=UoZrkx3O;
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807EC606A32F
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 10:44:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 807EC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=UoZrkx3O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1793961837;
	bh=ltjJs16pegDLFBrW4DJQ9+Vgba38cfF04q83fGrOFBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoZrkx3OIW7dq7pdVqk4kQLY9HF/eEGbbB22p0dxydPpubA8RHU4qBYit+J3msUCR
	 mAgrdqgPKK4IuTakJRpUFi5yBuq9yrI1RWeywm0xu6E3oJdYIKrztnkm8gED7wblqH
	 kvpFCukk9hMSuFzg8GDD+oI4Lw6fUHUwO70nD/ou1fjROzBIKMi90w/Aiw8HHark38
	 ibphvsGyqPf38+yz9M0/R5rsRUdm9NH05x8XymXrctS6Ot8rAGqmQVtkH2vB/3CWmF
	 fiTRJXgwG1VFodVbg9KZG1wO/pDTxlk1sSCeOJ8jyGBCAhYZoADMt+yLf9ZAURkixX
	 BbljYhvxDJ5lA==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id D1BBA24E8E;
	Fri,  6 Nov 2026 13:43:57 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Fri,  6 Nov 2026 13:43:56 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.54.9])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4jLbQ34hnMz2QwJ;
	Fri, 06 Nov 2026 13:43:55 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
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
Subject: [PATCH 5.10/5.15 1/2] ocfs2: validate orphan slot during inode read
Date: Fri,  6 Nov 2026 13:42:45 +0300
Message-ID: <20261106104249.1811-2-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
In-Reply-To: <20261106104249.1811-1-mdmitrichenko@astralinux.ru>
References: <20261106104249.1811-1-mdmitrichenko@astralinux.ru>
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
X-KSMG-AntiPhishing: NotDetected, bases: 2026/11/06 10:27:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 133 0.3.133 d508d579b02cdb6df47808421a9b9e12fc9fb75b, {date_rfc_vio_soft_silent}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;127.0.0.199:7.1.2, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 207310 [Nov 06 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/11/06 07:02:00 #28807345
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2026/11/06 10:27:00
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
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Backport fix for CVE-2026-90205.

 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ddbedc9aacf4..68ca2c948290 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1451,6 +1451,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
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
-- 
2.43.0

