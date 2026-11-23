Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442546;
	b=ulHBuEBprV4Hkh0vuRx1gS+Fdhz6bkOIb3FUdyIJQdvhA7mQ8nf7mG54nVhNrBktAUVS
	 ZX/A9gPkmkSOUHoFCp3PBCNPNyaJSVs5arskXq3F5MwBDSsHMBNSjK+GxLLsgxwQPTNgj
	 tSgom3ldGXwzNBiiYUni64CkLSpoQFw/nYUr98w2H7q/5iloes4fNhZMsDTKhLBXi1nX0
	 u9W0NWrz3eBIuMg1NT891yDn3OS9FgOvyyO2RADGvTj8lglkFs2akUPe2+FKx8Rs3n9wL
	 k5OUdZ44/RVRnaJn1pK/ITowAeRpHj62vYsiqBL154LHe0Bach3L0ytC60cJpENlbMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442546;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=R42Gma2O/hvCvmP2Zz+AKYDbi1g8qtI0eo0ui3Ob20U=;
	b=sgFKXxNu9CQ7YIxnmyUSTBiMOYyMhQykdh01nqhOn6QtsMaQcE8ezm+D3hry84W1TSr0
	 L9oXiKlNRG6aV7WkpCxpTFADxqGONA+h6DC/RyW2PLQO96ByBVdRWrBthhChQSZzgI/Hb
	 fkFy/p0IVhRpcNi2/uG/K2wNiCjgDNMS741wA+c6MziwCdv4W5WD6hbPtGy4GuNU5Gzc2
	 UmtafD8icoaU/nCWS2mNNWp1YY+UuFi5TSYwpooVljD/0uXfvndZi3LiJO2B7QBig0+3s
	 rXghAPeNStN1Y9ZXkAHz8mqzdsVzFtzAD1sx3Nn3aDk5wj8ytOhmDUyx6DscpzTixtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=jw+IkZ5d;
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C22606A321
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 14:02:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74C22606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=jw+IkZ5d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1795442543;
	bh=T7WYrw9/LA5Yjlx7L6S4/nWrfFc3WoU4bhhoqe/9Efc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jw+IkZ5dLPVMlePlKJKf0S/5LqR+ebUPZsxB0htyMiTibA64PbuxyEBGfZ4SJpo6v
	 Yu7ERRPLXhwCHy/SVlZgGqorG2ctLpuZDpSGVNV4Od7Eo8S5F38lNMujo8HwMkOrSX
	 FrISyGHsuOb1aBykn2UgFzqigWXJNYjFWvZ2K69SYox/EMAjs2t2AwhrSKq8z0CNKg
	 m91j98q71m1C5cChRMtA6F/5d1JZOf0IfHU9Kogbg1Uo4GCmmDhDOTPkePOXz9674G
	 hOvpnnEwXrlZxirxkjnlyYO6SgXAM3bzrt7Do5noIEW1ItM9Ft2M/MhSwHZaM0Cqi0
	 lggA5DUhIFhuA==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 0CD8926B14;
	Mon, 23 Nov 2026 17:02:23 +0300 (MSK)
Received: from mail.astralinux.ru (unknown [10.205.207.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Mon, 23 Nov 2026 17:02:20 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.55.149])
	by mail.astralinux.ru (Postfix) with ESMTPA id 4jY7176kcYz1FqD;
	Mon, 23 Nov 2026 17:02:19 +0300 (MSK)
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
	lvc-project@linuxtesting.org,
	syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com
Subject: [PATCH 5.10/5.15 v2 1/4] ocfs2: add suballoc slot check in ocfs2_validate_inode_block()
Date: Mon, 23 Nov 2026 16:59:34 +0300
Message-ID: <20261123143419.ocfs2-slot-validation-v2-1-mdmitrichenko@astralinux.ru>
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
X-KSMG-AntiSpam-Info: LuaCore: 135 0.3.135 58dcfca10e9e4d27990d8f7387f1467d65061802, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;mail.astralinux.ru:7.1.1;syzkaller.appspot.com:7.1.1,5.0.1;127.0.0.199:7.1.2;astralinux.ru:7.1.1;lkml.kernel.org:7.1.1, FromAlignment: s
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

From: Dmitry Antipov <dmantipov@yandex.ru>

commit fe7a283b39160153b6d1bd7f61b0a9d5d44987a8 upstream.

In 'ocfs2_validate_inode_block()', add suballoc slot check similar to one
in 'ocfs2_get_suballoc_slot_bit()', thus preventing an out-of-bounds
accesses for 'local_system_inodes' in 'get_local_system_inode()'.

Most likely this fixes
https://syzkaller.appspot.com/bug?extid=a77d690840e60bc2ddd8 as well.

Link: https://lkml.kernel.org/r/20250826095106.666980-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=900962ac9bf1860033f2
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 25bf9e549360 ("ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes")
Stable-dep-of: b2d31acbd3b1 ("ocfs2: validate orphan slot during inode read")
[mdmitrichenko: Resolve the overlap with existing dinode checks by
 inserting the suballoc slot check before i_mode validation.]
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 2ffa3571d15b..b6fa3c8c6663 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1452,6 +1452,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
+	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_suballoc_slot));
+		goto bail;
+	}
+
 	/*
 	 * Reject dinodes whose i_mode does not name one of the seven
 	 * canonical POSIX file types.  ocfs2_populate_inode() copies
