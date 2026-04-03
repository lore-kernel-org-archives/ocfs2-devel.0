Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA29139022D
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Apr 2026 09:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775207294; cv=none; b=j7gFlVDfAn3+Ve3WSniJmFBMRsSjkySgr6Dvl+QOt9EMizFbJjatoLp6K+AU8720q+Fmz9WA9FmBd3KJAlrBEML2frQCC+yfxo+6dBikbNpouhUd+2WQrqHtIn3goq4EJ3ebeabiCPK9RTp8EkPb7UZLBp9BiMHpF0HpMgNoR1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775207294; c=relaxed/simple;
	bh=KVX/l4PEuRo+VH6frFo9E3mzjNLJ1Wbb5iKz/hqBpWk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GUJD1qtUim+78P5AiluKol1izd8tq5qJpfqp2xqXapyvv5yhgYY+YUCP/O9WbXNukZT9TQjybEFKGbvKoXksY7X+oV6SHthgiqbg3OVL4uYqgFPwvgx6b3wMVb8XKf/W9b8EQ6XT4ww8Fpyyov9APt73IMqslKQDtHOkVaYhzb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yaIVOXOk; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yaIVOXOk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775207285; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=fAaWqvZXt7LWuJrd2hBiLGoTtJIzs+OyXzZMSCWQ1Oc=;
	b=yaIVOXOkhB+3KtxKmV8ArVZCUHvdTfNma4tPKgckEkopnCrRaFuhILDSdYTI0AwD+hLZHYjVGspmLqJd4F0v3Oo6hKrB55jBHlId4AB0QJEC0z+Vg3xPCdVu3Qw6CJaMkqsyraK0P7e0PuYdfy0SGSAGe1uKthOOILMUtA9ZEhM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X0JqO6o_1775207284;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X0JqO6o_1775207284 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Apr 2026 17:08:04 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] ocfs2: consolidate extent list validation into block read callbacks
Date: Fri,  3 Apr 2026 17:07:59 +0800
Message-Id: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2 validates extent list fields (l_count, l_next_free_rec) at various
points during extent tree traversal. This is fragile because each caller
must remember to check for corrupted on-disk data before using it.

This series moves those checks into the block read validation callbacks
(ocfs2_validate_dx_root and ocfs2_validate_extent_block), so corrupted
fields are caught early at block read time. Redundant post-read checks
are then removed.

Patch 1-2 handle the dx_root extent list:
  - Move l_count and l_next_free_rec validation into
    ocfs2_validate_dx_root(), skipping inline dx roots.
  - Remove the now-redundant l_next_free_rec == 0 check in
    ocfs2_dx_dir_lookup_rec() and rework the error message to avoid a
    potential NULL pointer dereference of rec.

Patch 3-4 handle extent blocks:
  - Add l_count and l_next_free_rec validation to
    ocfs2_validate_extent_block().
  - Remove the duplicate l_next_free_rec > l_count check in
    __ocfs2_find_path().

Joseph Qi (4):
  ocfs2: validate dx_root extent list fields during block read
  ocfs2: remove empty extent list check in ocfs2_dx_dir_lookup_rec()
  ocfs2: validate extent block list fields during block read
  ocfs2: remove redundant l_next_free_rec check in __ocfs2_find_path()

 fs/ocfs2/alloc.c | 35 +++++++++++++++++++++-------------
 fs/ocfs2/dir.c   | 49 +++++++++++++++++++++++++++---------------------
 2 files changed, 50 insertions(+), 34 deletions(-)

-- 
2.39.3

