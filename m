Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CF3165F16
	for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776359154; cv=none; b=WzPVhVjDxMHdQJr86ye4AZF/7EMzdTbJWAMUCVqpMg4QOcaF/0oAbzE0h8RfGk4TqFnIT+Z83Agfj8kxH+aAs35EPv535TmiHPnLJpG18/GLElKyjqTlIQhHx/pO8kp8/PaFoCLx8Uxz+GNB+KPzqXcjTjnhPXKQVnOsY+KS/qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776359154; c=relaxed/simple;
	bh=54SgjgKi3r4F/3/udeGaQ1Xee994Q8RjfE8u14PdOsg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GHhciSB8+GgCG3RJC7+ZcNeBAz/IwqwAz65ar4+TMFZabZeaq9a3tugkP3G9rXvnP3fnvI0fTGz4tum8WcDQApU2Eu2WYHY/jMAax6X3onTOR3pTK0RX8tz0x1XbPTbdRYntriORd6is0MZLpZFeMKn3v0FU4EJ+yCFKZ6wp0m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HVfzAVhj; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HVfzAVhj"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35d9c7bf9a1so7271942a91.3
        for <ocfs2-devel@lists.linux.dev>; Thu, 16 Apr 2026 10:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776359152; x=1776963952; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ztVJaluVcmICeZy5upHuWNa2vBwn3HqeCa77xsx30b8=;
        b=HVfzAVhjySCiv2ToDERp2w/aosU0VgtRDJ4qMqNayCh6vKE88n+Yh5S7Hxe2s8MMN5
         6SM4YCLn54piFCFVrm1SF5AnHD6oDc7U7mmrCoPtI6W8skNlnyJCaBsDZIMPR3rcwu4W
         YHw6YsRgsIapk/32lKdl4VZdpDzGiKyT8Qs72y1ZCpr2cFVGqdvSkkmDrOC9ynH/TH+/
         H2s+Dqwth3k0apCDie2WcvMhndmWOBIp6fQ2vXk1L7/RtFmTp1ywIX0IEx7XQKceXArp
         EwIxmczvpwx8igaza/ePPZmrrhNAkBT9YEKb5oHwthkjVgqvgCiZXprjvlottBcCZcXR
         Z0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776359152; x=1776963952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ztVJaluVcmICeZy5upHuWNa2vBwn3HqeCa77xsx30b8=;
        b=gKRRPBt1JebsI+KRTzYObcrNPq2roT0LyLutjqiJm3JKtaX2+rUKkBTZ757t5yN4u7
         8wIve4Krb7XDZAAwuYBo0mhzSbKT9SupCp4ZFfXH2/sOfQOjo6e3WMeifDCNMbIyeLxS
         C7h+JvTmmbVDaZqwYY25k+hvwAHiToae22jxuw8fttQyzqPEAxkZ/xym6S7KuKZMBTMK
         YN2ZDeLIVR3P5iLMSXVGYM3nwEOvZ+kKk3bCL92cR0g3qdq0i99Wf5YZ42zToYo7U3hX
         j5hFZ6QPO388lb4CAHmzD8cTUWL/yPOhCbtMTb9DXIC5Ez973qpF4K28h5GwPRU5vafI
         vSLA==
X-Forwarded-Encrypted: i=1; AFNElJ8TeEkk3raink0NpLlY/yB0seQyb5kNViEWKAtKlAf0N9CaiK0UTlYzX1aT0M4L/a+IMYZR2lCNCQQAQg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/1k6kgMuai1jhmqJ94PuP8fONIfd3uQ/kI9tdLEUNoJXiWZs8
	ZQOA8xQ9g9UOxdCaFxzimIEkJYUoQ5J/kr8OeDcOuby4iP1m2zCAE/vncQzdp/pwDFY=
X-Gm-Gg: AeBDiesHeF0W4WMoQbbTxAUxo/+3CZ2eRsBIivKLjiKxxC8t/Nwgx+H6BzbXyioskI9
	uov2HvLprFWr8DWZCdMyxDeCo2v3r8Ot4a18bsaN/6vxLEysaj4ZJwUirzYRcwJLmlBJC/ye4wF
	dmn3ZQgzzWj5joUioT759x3ZBaCASwaKl53zD8IFtCFkVyU3NGXgaTBakb+toFLymzZMYj0a9yC
	Y2wM1RxtvyVBu+79gn3k/tM+GzlyG+TTXRgUJQp2w1RRE3XX7/kPHHWUwRAbw7UAjVCIrlW9eFJ
	dx8lSvvDU/3c/URZWSaQWiGVGmL0WpcXChhvkIYXh/6LMqh4MWOKML74lL72l9Y61N8QTHFn5d9
	IasNYpl77k6HLDKfC1hPC1r4rPr/372mwNlXvqikNSP5x4XlMdaMaRWXuylY/ybu4qLpZQjQbFq
	cC8B9bD32Dy25xrJGNzUFulANWzwTq0cyhYXCndlgXWIL9CK7wQSZsgJZ9fQ0=
X-Received: by 2002:a17:90b:2b4f:b0:35a:1762:92fc with SMTP id 98e67ed59e1d1-3613e0467abmr142420a91.26.1776359152191;
        Thu, 16 Apr 2026 10:05:52 -0700 (PDT)
Received: from localhost.localdomain ([240c:c001:1:2e07:d16d:209a:fff3:5532])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4780ef365sm57634075ad.1.2026.04.16.10.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 10:05:51 -0700 (PDT)
From: Wxm-233 <lty2wxm@gmail.com>
X-Google-Original-From: Wxm-233 <2200013188@stu.pku.edu.cn>
To: joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,
	ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	linux-kernel@vger.kernel.org
Subject: [BUG]: ocfs2 possible lock inversion involving ip_alloc_sem and local alloc inode
Date: Fri, 17 Apr 2026 01:05:25 +0800
Message-ID: <20260416170525.1490-1-2200013188@stu.pku.edu.cn>
X-Mailer: git-send-email 2.45.2.windows.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

we hit the lockdep warning below on
6.19.0-rc5-00042-g944aacb68baf under syzkaller-style workloads:

  WARNING: possible circular locking dependency detected

The reported acquisition is:

  ocfs2_write_begin()
    down_write(&OCFS2_I(inode)->ip_alloc_sem)
    ...
    ocfs2_reserve_local_alloc_bits()
      inode_lock(local_alloc_inode)

Lockdep reports a cycle that can be summarized as:

  LOCAL_ALLOC_SYSTEM_INODE inode_lock
    -> ip_xattr_sem
    -> ip_alloc_sem
    -> LOCAL_ALLOC_SYSTEM_INODE inode_lock

The write-side path is visible in:

  ocfs2_file_write_iter()
    -> __generic_file_write_iter()
    -> generic_perform_write()
    -> ocfs2_write_begin()
    -> ocfs2_write_begin_nolock()
    -> ocfs2_lock_allocators()
    -> ocfs2_reserve_clusters_with_limit()
    -> ocfs2_reserve_local_alloc_bits()

The reverse dependency appears to be built by normal OCFS2 metadata
paths rather than a purely artificial sequence.

In particular, ocfs2_try_remove_refcount_tree() takes:

  down_write(&oi->ip_xattr_sem);
  down_write(&oi->ip_alloc_sem);

and ocfs2_init_acl() can take ip_xattr_sem in the create path after
cluster reservation / transaction setup. Together with the local alloc
system inode locking and journal/sb dependencies, this seems to form
the lockdep cycle.

So this looks more like a real lock ordering problem in OCFS2 than a
fuzzer-only oddity. I have not confirmed a live deadlock, but the
warning appears to reflect an inconsistent locking hierarchy across the
write, xattr/refcount cleanup, and create/ACL paths.

The full warning starts with:

  syz.5.144/14770 is trying to acquire lock:
  &ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]

while already holding:

  &oi->ip_alloc_sem

If useful, I can follow up with the full report/log pair.

Thanks.
