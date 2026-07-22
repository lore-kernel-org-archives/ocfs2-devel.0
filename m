Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2700918C332
	for <ocfs2-devel@lists.linux.dev>; Wed, 22 Jul 2026 12:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724585; cv=none; b=fOFsl4nHSt5rP1g/OCnWiHvidLtRsJl6MZQEvGIod1kMF8yWreCH1uVgi6rtTUgaAivPTJBeBe9OBwRSJni4DLCxflxhGw0EysmP9ccE2RG0w0iEctqtkZAfXKPNABbflMAqoZaYQAoYqJdawF8aH5mvHQNtkwnnIyH3AfgkYVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724585; c=relaxed/simple;
	bh=7L56uBtRMo/hvHvzYtxEkdsS/JPRTibQ1NDZrB0mIWA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j3d8Yo13muE18Kbl9w0bZZTM8QoW5zq4zV+S/KgVnackJi3D4pMsugC3rB1rUmmldIQczCC8rT0wfcgEUlWYDNMPy5/MIhOjs2CLUGShQaVPrb/lFWTApsum9tjDwsM75hA7XrsIP4BiYvZ/jIKdM6aXLIKMpfYLGGCTP12zxvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=e95F6EQG; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="e95F6EQG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784724574; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=k3LLyO2FSKUUNW7GhIPNPmqFvSD2/2SH5bsybhpIZYY=;
	b=e95F6EQGJA52Qzp1GAuIR9JcG9l6UPtqFAa7LeMCd+2yqxBlAZr65EjBjBgpTygtmpsNy1+/Iz6cvLFZTiyDqZQ7fVIfLDEyJpiP3uCfNsYtw/JymlqcTq4UD4jbZSnwMqieu/H1tJ+cI2vCcTG1Ty60DWHzNCU/MorgabuYkX0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X7dOcjw_1784724573;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7dOcjw_1784724573 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Jul 2026 20:49:34 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] ocfs2: cluster: o2hb_region_pin() fixes
Date: Wed, 22 Jul 2026 20:49:30 +0800
Message-Id: <20260722124933.430554-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes three related issues in o2hb_region_pin(), all are
from the original implementation in commit:
58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions"):

1) It is called with o2hb_live_lock (a spinlock) held, but the
   underlying configfs_depend_item() sleeps (takes inode rwsem and
   pins the filesystem).  This triggers BUG under
   CONFIG_DEBUG_ATOMIC_SLEEP.

2) When called from the configfs drop_item callback, it creates a
   lock order inversion: parent inode_lock -> configfs root
   inode_lock, which can deadlock against subsystem unregistration
   paths taking root -> parent.

3) If pinning fails partway through o2hb_region_inc_user(), the
   o2hb_dependent_users counter is leaked and partially-pinned
   regions are never released, leaving heartbeat regions
   unprotected on subsequent mounts.

Patch 1 reworks o2hb_region_pin() to drop o2hb_live_lock across
each sleeping configfs_depend_item() call, using a config_item
reference to keep the region alive while unlocked.

Patch 2 adds a from_callback parameter to select
configfs_depend_item_unlocked() when called from configfs context,
avoiding the inode_lock nesting.

Patch 3 fixes the error path in o2hb_region_inc_user() to unpin
and decrement the counter on failure.

Joseph Qi (3):
  ocfs2: cluster: don't sleep while holding o2hb_live_lock in
    o2hb_region_pin()
  ocfs2: cluster: avoid lock order inversion in o2hb_region_pin() from
    drop_item
  ocfs2: cluster: fix o2hb_dependent_users leak on pin failure

 fs/ocfs2/cluster/heartbeat.c   | 146 ++++++++++++++++++++++++++-------
 fs/ocfs2/cluster/nodemanager.c |   6 ++
 fs/ocfs2/cluster/nodemanager.h |   1 +
 3 files changed, 122 insertions(+), 31 deletions(-)

-- 
2.39.3

