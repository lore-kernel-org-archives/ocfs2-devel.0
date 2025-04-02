Received: from ksmg02.maxima.ru (ksmg02.mt-integration.ru [81.200.124.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0380204693
	for <ocfs2-devel@lists.linux.dev>; Wed,  2 Apr 2025 07:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.200.124.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743577591; cv=none; b=ouT6oKAI2LjYG5Z1BqpFhQ/O9lxO5dqKEzv/UOlCyIOpiF423/iR9paeidZ84h00ACyJGzQgBXSM30D6FLZzCLfxnMXDhomq5RJ74GMTtWFNnPm/5uQPoHk9ysxU1aI3AGRh+GgV9h4uq+/JfbzBM8/yDDeaA0pETvmOaBque6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743577591; c=relaxed/simple;
	bh=K6pwnpc1IEDoeg+bqRhhm5VvdsHC8NLfjh3UILJrld0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uWKH4cF2wPybM+oA2UovaUedGq20NSzNf/9NmNrr8eGS+2M2DrjU6nhZ9+iVDTiPknpAlNvxO0yifcuC8fZ/ugHh2OxF4uSG+KmSJCWRhhBxaoTtUFrULehL7LC3LLm9A9b6xYmNJEy3/mBRHZfvW80Kda5JP2WpiGqOPQ8yIww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru; spf=pass smtp.mailfrom=mt-integration.ru; dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b=erMa2Fxk; arc=none smtp.client-ip=81.200.124.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mt-integration.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mt-integration.ru header.i=@mt-integration.ru header.b="erMa2Fxk"
Received: from ksmg02.maxima.ru (localhost [127.0.0.1])
	by ksmg02.maxima.ru (Postfix) with ESMTP id 9689E1E0007;
	Wed,  2 Apr 2025 09:56:59 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg02.maxima.ru 9689E1E0007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mt-integration.ru;
	s=sl; t=1743577019; bh=P/yuVpNMrxD1ORN2hdZed6xJfO+r2i0/xQIH6x7ilQU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=erMa2FxkbmC4p/TJgf16RHlzumVc7Z6l18xSVAJfvshWVKQK2x5bT6a4wep77dIZY
	 kK1KsP9PCknpLNW6fwhqMr4/sTzEQMQU1xc6P3Y2JhlEaoCb+FUxRMJNPyY/R7kp4h
	 vADhYllSoseD80qi/3QioQQdQws5xaVOVCHqCtWhzvuQClAyPxxhJ7SQDU4skEK4sQ
	 8s56/XHXU5D+wHZR4sFmPA784buJRqnmnv9WwPH5OVUAQfoeti/wwPILQSAQFyIf4G
	 oaNE2O6WlNk9n+NS2m3xggefJVmUuj5suXrGprnPTJuz48pcknMFw9YcXWcWFEq0oL
	 JGEgQSEMddWIQ==
Received: from ksmg02.maxima.ru (autodiscover.maxima.ru [81.200.124.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.maxima.ru", Issuer "GlobalSign GCC R3 DV TLS CA 2020" (verified OK))
	by ksmg02.maxima.ru (Postfix) with ESMTPS;
	Wed,  2 Apr 2025 09:56:59 +0300 (MSK)
Received: from deb16-01-masimov-t-build.mti-lab.com (172.25.20.25) by
 mmail-p-exch02.mt.ru (81.200.124.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 2 Apr 2025 09:56:58 +0300
From: Murad Masimov <m.masimov@mt-integration.ru>
To: Mark Fasheh <mark@fasheh.com>
CC: Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>, <ocfs2-devel@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>, Murad Masimov
	<m.masimov@mt-integration.ru>
Subject: [PATCH 0/2] ocfs2: Fix issues in ocfs2_finish_quota_recovery
Date: Wed, 2 Apr 2025 09:56:26 +0300
Message-ID: <20250402065628.706359-1-m.masimov@mt-integration.ru>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mmail-p-exch01.mt.ru (81.200.124.61) To
 mmail-p-exch02.mt.ru (81.200.124.62)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dmarc=none header.from=mt-integration.ru;spf=none smtp.mailfrom=mt-integration.ru;dkim=none
X-KSMG-AntiSpam-Envelope-From: m.masimov@mt-integration.ru
X-KSMG-AntiSpam-Info: LuaCore: 53 0.3.53 da91f386ac5d59a1df8d7a7d55ad5b472b5df140, {rep_avail}, {Tracking_from_domain_doesnt_match_to}, mt-integration.ru:7.1.1;81.200.124.62:7.1.2;127.0.0.199:7.1.2;ksmg02.maxima.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 81.200.124.62
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 192297 [Apr 02 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/04/02 03:33:00 #27848807
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 7

These patches fix issues during the second phase of quota recovery process
that is done when filesystem is mounted.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Murad Masimov (2):
  ocfs2: Fix possible memory leak in ocfs2_finish_quota_recovery
  ocfs2: Fix deadlock in ocfs2_finish_quota_recovery

 fs/ocfs2/quota_local.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--
2.39.2

