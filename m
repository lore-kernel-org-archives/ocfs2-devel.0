Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=93.188.205.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961842;
	b=fe26fDaCoe28VayauJOuBq2L4HBaZqzowoBpWfEG5cubYT2n2xTVyaGIBiys8fo59glH
	 jww20TiBUWatXGtOUBhRXAuAANfysl1d9eATpdvuivs2J2oB3eY5oWqu8+oz0LBjTN376
	 rycYB0RDUdcWkvRYPQ7Cl9XlZDH5EmyFl3guDRxYclmeVs4Z+1iDtQb86Wx8qaBmT4Pg5
	 UfWjAX/kWBjHG6MBcS8RvxYhRgS2Rdojz1hFmFDsQvIh06tfO/7a2+YR7jQeYbgVa10Or
	 V1yuoFCMLLcxPH9/nTc2c2zgAtqJpL1USnsTFjnULOzzS34kLa2d2Cvk48Yz4etS63A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961842;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=d9+Qj+rwoehqegl/O269YKHfoC44odWncVlNoyrej1s=;
	b=sRZH44LLdvLxPKvPb7TYMfKph368IonrWwSnXda9fMby34Ip4M4RZAXE4od7gts+hWxX
	 cDdiJ4TOYzAU1EVnGjLpWTj8Dp4aNzA81FcAbC2U+yWJyrremYWlDxptDkIl4pTV3bJDk
	 tNbnijXtK/GXKZWdJt3CNZhIXE5p1h9Opoa9COiOQCjGnVnkqkjkIwrh2Ty8HtrD2mvoR
	 ft3LI+WmYObNxH4CZREcFfJIeyYiGaLojaN0QY5mQFofqtz2HGTUcQ/1YNJOtBOPnRrEa
	 iKYxbcZ0md9N3V18VvSwDzvH/784uwa7xfjHNeuGgD0RLFN022e30aJ+v+72XsjQlFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=yD6PTA42;
	arc=none smtp.remote-ip=93.188.205.243
Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDBE606A32D
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 10:43:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EDBE606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=yD6PTA42
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1793961831;
	bh=ui/aeJnr5ewCmjejlp9WJ4K1mxnk65ETQhHibwFbw5w=;
	h=From:To:Cc:Subject:Date:From;
	b=yD6PTA42Ugdd1dDwRAyX7AUtGHqugWRVlNQjLf09BV9AYy+OU1f6y9CU+BQfENUqq
	 UHaZrng2064F1+1ruNCYV/OUPD78N6kle2ZY2JVtyhfa9ZPRMn7RfFg+4HYyLLAv6h
	 jmVwJvA6QUI4j+loiv6E7pFYwBVk0OUn2yt1m5Ku99iU4Kod4TO0pml8JYhifkIYfZ
	 +nsWth/1D1B5rOsle6C0ATc2NRjwVOsVV3chbB2ohavR6jsj2UZ0c4md05jLkgV22j
	 LRcJDPWgAOcKUL8j9CCFVrnvIHbR8tx51BEq+GUWwOgQulRZsdEKOQXIImxgi/8ymC
	 jfNEDmxXia+gA==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id CA38D1FA27;
	Fri,  6 Nov 2026 13:43:51 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Fri,  6 Nov 2026 13:43:47 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.54.9])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4jLbPt5f90z2QwH;
	Fri, 06 Nov 2026 13:43:46 +0300 (MSK)
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
Subject: [PATCH 5.10/5.15 0/2] ocfs2: backport orphan-slot validation fixes
Date: Fri,  6 Nov 2026 13:42:44 +0300
Message-ID: <20261106104249.1811-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
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

Both orphan-slot fields are read from disk and later used to index
per-slot arrays. Reject out-of-range values during inode validation,
before orphan cleanup or recovery can use them.

Backport the original upstream series [1] to 5.10.y and 5.15.y:

  1. Validate i_orphaned_slot (CVE-2026-90205).
  2. Validate i_dio_orphaned_slot (CVE-2026-90204).

Both patches apply to v5.10.273 and v5.15.224. Built fs/ocfs2/inode.o
after each patch on both branches with GCC 13.3.0, without compiler
warnings. Runtime testing was not performed.

[1] https://lore.kernel.org/all/20260803030007.3993199-1-gality369@gmail.com/

ZhengYuan Huang (2):
  ocfs2: validate orphan slot during inode read
  ocfs2: validate DIO orphan slot during inode read

 fs/ocfs2/inode.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
