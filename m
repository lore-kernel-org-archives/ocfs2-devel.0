Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442546;
	b=sJhSYi5z92UTeiJPGqxOx7EFgtUluSgQRAx336TcbVTjhj4ESgaag/zt3Xe28LWau3yl
	 +qoCkpDskWrXFKIzynyYrzFnJcFVcO1ESeCS+SeQeA0WkNV//qw5e4TNZBOZBCxfxJV/v
	 q4gGdHgwo7avNj/VwDj1/R1NupTqNMVKPQJa3RdjsOm0byNAGzXnnQ1h4LnPqnjS1pKLR
	 na3OZnNSQjWhiBlrFdg/vlMNC+m+Hb3zrS+ZEsn78MmqAKZk8Bkgg+Dg84FNzq+tev7kl
	 YMyCIZi9CJtlNaIwNCHxzs8F+RwyhoqyDZ4vUKS3MmYh2/wR+XVBgofMPUHGUuT8hmQ==
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
	bh=jLwPrA29UfF0rF3l+0JqxHk0l7GCHQOzEWj6GSA4pz8=;
	b=BAtUVgjJNvRWrVfxBPPvMAuWbJUTTuUf5NWP+DKXt5mysBqG2WwVE/bJj/R3yAXi3WN+
	 kV+KAvBcS8dyTtw9muwgrx+y5KqIuH5mXXBVGAyNoVyym2eTuOcOTAIrVs8iCNaRo5gwp
	 PIqk2XovFzeEhNeegJQNmLWuJstg1fmIzbFYF6tl1xrolVxgwXaYTsK6mDbB8KnLGIE3h
	 3lk1YOHeXT0+QGfaoWww97ZYIJMmpRLpjkExdag4pDrXHn7L3GAeHzlDCxuwRH0rI4IIA
	 +VKXxI3er0ZvU3H0n4ttdgR9pTfvkv8ysCgHLemkPxVEyn24JotU/N5tGiuJk8rrhhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=qBsfe6Sy;
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A32606A31E
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Nov 2026 14:02:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12A32606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=qBsfe6Sy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1795442535;
	bh=Bt08yUaTGOAKOQa75/FF8i/YMZfDqfyocPvqYBtiFeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBsfe6Sy4bQ48w8U7sfvZ/NorXwGJoSbNsEIBjcrnkAaQpucdiz08i2M79PTXRPpW
	 QMDPG2PXgYE+mHg1HoyyJ0ysfgJX/nVWUovd8jwMATM/BPBnVKYppcpG9Z7UZ+mY6i
	 DRuXVTC/oprYQm5rGn1RdTNh1jQDSEa3kY1zVhJLOZ7uUSQwTiNPQumdBvgfw806EA
	 +E/7kHYKIc2KJPer/z4RzF3eai1HBYcn9HSaiw1gbIx+FnaBkQNdYAJUea06P77wh5
	 zHJdeKszBOd3K9XvTDv9Uk71FNpMfhzCTVcS2aQ52cghvFEimEcwFSmYf98bqmRk4o
	 QSyO2e2N+J7PQ==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 7114625456;
	Mon, 23 Nov 2026 17:02:15 +0300 (MSK)
Received: from mail.astralinux.ru (unknown [10.205.207.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Mon, 23 Nov 2026 17:02:13 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.55.149])
	by mail.astralinux.ru (Postfix) with ESMTPA id 4jY7106WDCz1FqB;
	Mon, 23 Nov 2026 17:02:12 +0300 (MSK)
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
Subject: [PATCH 5.10/5.15 v2 0/4] ocfs2: backport dinode slot validation fixes
Date: Mon, 23 Nov 2026 16:59:33 +0300
Message-ID: <20261123143419.ocfs2-slot-validation-v2-0-mdmitrichenko@astralinux.ru>
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

Both orphan-slot fields are read from disk and later used to index
per-slot arrays.  Backport the upstream validation fixes for
CVE-2026-90205 and CVE-2026-90204 to 5.10.y and 5.15.y, together with
the suballoc-slot check and its follow-up correction.

Patch 1 provides the suballoc-slot validation that the orphan-slot
commits expect.  Patch 2 completes that check: OCFS2_INVALID_SLOT is
valid only for system inodes, and a mismatch between the on-disk system
flag and the requested inode type must report corruption rather than
BUG().  Patch 2 is included to avoid leaving the earlier check
incomplete; the orphan-slot commits can be cherry-picked without it.

Patch 1 carries Stable-dep-of tags for patches 2 and 3.  Patch 3 carries
Stable-dep-of for patch 4, which does not cherry-pick cleanly without the
ordinary orphan-slot check.  Patch 2 retains its upstream Fixes tag.

The series applies to v5.10.275 and v5.15.226.  Patch 1 needs a context
adjustment because the target branches already have other dinode
validation checks: retain them and insert the suballoc-slot check before
i_mode validation.  Its added code is unchanged from upstream.
Patches 2-4 cherry-pick without conflicts or code changes after patch 1.

As of 23 November, these four commits are absent from 5.10.y and 5.15.y
and their stable queues.  All four are present in the newer active
stable branches (6.1.y, 6.6.y, 6.12.y, 6.18.y and 7.3.y).

Changes in v2:
  - Add fe7a283b3916 as a prerequisite and include its follow-up fix
    25bf9e549360.
  - Add Stable-dep-of tags for the dependencies described above.
  - Resolve the patch 1 context conflict with the existing checks.
  - Rebase and rebuild on v5.10.275 and v5.15.226.

v1: https://lore.kernel.org/all/20261106104249.1811-1-mdmitrichenko@astralinux.ru/

Dmitry Antipov (1):
  ocfs2: add suballoc slot check in ocfs2_validate_inode_block()

Joseph Qi (1):
  ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes

ZhengYuan Huang (2):
  ocfs2: validate orphan slot during inode read
  ocfs2: validate DIO orphan slot during inode read

 fs/ocfs2/inode.c | 57 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 7 deletions(-)

