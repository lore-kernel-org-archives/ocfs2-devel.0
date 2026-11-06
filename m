Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=93.188.205.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961842;
	b=Xpr2JqhK683VyL4siIvjgjlxHyT8Wk1+RuSspTe1TtubjcHa535E3IwJA9yO3H6tFnZ0
	 E6vtr9fr47qFtqzSx9PYUM7UjilXmrpXpt6jWeSUuqfRwZk/MzvW9nxft0ghXDOktuN32
	 clklZLbOIFRyHGxo1qDsl1rUOIEo09+LenPLownMLqV4g3Orbej5xqQAoxGmrR4U6jjgc
	 fCEAsFJg6ZMJoTGj3VWmwVDr+6GflKx4VomG1bQ8aULzKzmJtgg9Txi/0O42k1vHbi4Me
	 AlIxoUB/ZrRMhwyBXsmUiAOdQ/s8wMp2C3V2p4GDdjgr7X0YvvwUnklyIuiqne9r1RQ==
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
	bh=tM8wONcHkFnn5a4qTUBvewnNA8x1p4v1tK8iPl3/1uo=;
	b=q2Z0E6kahP1nOqlX3AsPQgoHWk1HHtTER/C2WftTUyqkmf6U6icL/Es9Mem4PAoMfNOD
	 2eaXCSdxE7wdK2v7YTqmZ8KGEfkDnQeF79T6JNEbMUHjM6tE/ILElhdQKWj1t9hXqV/BI
	 rOqv9icFDSQIFCdYM0Jmn96IrMojBNGGDFB0LTEOqvGwtKPGXoj8Rgmm5RUjmMGpvFrs6
	 sElcUNfSCzcvgXgXt7LKbhyN981hqV2/Dw06L7jI8IW3qdiiJODCpQOPoxqea1GKlaPV8
	 xAab9OJpPRSI08NwmGDbeImwLW5dM4cHSImWBhWhW70Yj4UF4BYhIqqR+0hM1F+HSxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=yTfzaoLO;
	arc=none smtp.remote-ip=93.188.205.243
Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECD2606A32C
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 10:43:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ECD2606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=yTfzaoLO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1793961838;
	bh=iq2XU0Ik0aG3bir6UyLGBLAMrcVZI4xwmpJ3OMIqzCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTfzaoLOuGHlvpRfZZZQ84/O0BnebcOWy7l+6mVx83fsjXiFr3uCQKkBahBlOSXQu
	 WpKceWuliIPJoe/rgHIIpZQyKeHOyNBBNcMtNrbnxbI7Z/llUiSXXAjv4FppymHbCg
	 tjipKpygnyWivIkolhGvaC9c6YGx6MH93tQoiIksYF8c1Thbg7LvGGnR+SH/PwRXQW
	 /H+13eoewiRoUU1taj7xodH4B4PSAPkvRIk0GUQ3s7uwYhcy0+QXvMtyS3EHBUipfs
	 aiMFIlSKrJ70tM8IWSZ60b6OwUMopmCx/qxHv/DFkk4IB45cj1SrLkwyRTWCcHELm7
	 Kpso3hJNAwvlA==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id 1B1331FA4A;
	Fri,  6 Nov 2026 13:43:58 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Fri,  6 Nov 2026 13:43:57 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.54.9])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4jLbQ46nlLz2QwK;
	Fri, 06 Nov 2026 13:43:56 +0300 (MSK)
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
Subject: [PATCH 5.10/5.15 2/2] ocfs2: validate DIO orphan slot during inode read
Date: Fri,  6 Nov 2026 13:42:46 +0300
Message-ID: <20261106104249.1811-3-mdmitrichenko@astralinux.ru>
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
X-KSMG-AntiSpam-Info: LuaCore: 133 0.3.133 d508d579b02cdb6df47808421a9b9e12fc9fb75b, {date_rfc_vio_soft_silent}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, lore.kernel.org:7.1.1;astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2, FromAlignment: s
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

commit bb88131c9831075b8dc08cdd375743e5d44c7ca2 upstream.

[BUG]
A corrupted append-DIO dinode (high byte at offset 0xa1
corrupted from 0 to 1) can carry an i_dio_orphaned_slot
outside the mounted filesystem slot range and trigger a
use-after-free error:

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
ocfs2_del_inode_from_orphan() uses i_dio_orphaned_slot to index the
slot-local system inode cache. The dinode validator does not check
this active slot, so an out-of-range value produces an invalid cache
entry pointer that is dereferenced as an inode pointer.

[FIX]
Reject an active i_dio_orphaned_slot outside the slot range during
dinode validation, before DIO orphan recovery can consume it.

Link: https://lore.kernel.org/20260803030007.3993199-3-gality369@gmail.com
Fixes: 06ee5c75b575 ("ocfs2: add functions to add and remove inode in orphan dir")
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
Backport fix for CVE-2026-90204.

 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 68ca2c948290..8bd2b602b8c4 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1459,6 +1459,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if ((le32_to_cpu(di->i_flags) & OCFS2_DIO_ORPHANED_FL) &&
+	    le16_to_cpu(di->i_dio_orphaned_slot) >= OCFS2_SB(sb)->max_slots) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: DIO orphaned slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_dio_orphaned_slot));
+		goto bail;
+	}
+
 	/*
 	 * Reject dinodes whose i_mode does not name one of the seven
 	 * canonical POSIX file types.  ocfs2_populate_inode() copies
-- 
2.43.0

