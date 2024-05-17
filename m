Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05157224D6
	for <ocfs2-devel@lists.linux.dev>; Fri, 17 May 2024 09:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715938932; cv=none; b=bBDC/nqoP+xqH1kjC9sM2hxJ81wE+H5TQlDHP5W3U8VNF6XHvLO7Lsh5LWFTXlq6JesXj+5YgAATVPR2KYbIsL8j5NNR94Dbk4HQJ//wpW7UxZfiY/egOGu8Sjpk9cciGwZcoGsm94C7uoHvzorKT5FUMfCkjV6g6M7Ea5vS4pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715938932; c=relaxed/simple;
	bh=IVvnRV6hnYHhtVXXcf/vgiezSElLbioCWLuRkoRmcHY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iqyxm2ZM79NqIskIGuOAo5GU8UT0Idv33jYD+JOD3wzg0h2BmRWfERjjY2LNqXfE+sbRR0UAhiHJy/eHgcZ9wGpbUTcFuR6uw9cW8oV3RtG94DS+s0kHJE6sEbIgZAjMOJaPPAkS/24NXjgagQZfNRfNll+6QVPfxPEN/1t3lEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CKdqQeb8; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CKdqQeb8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1715938923; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=QgYHiA2D/PhDXSmwX2QgWvfRzxnp5N5zSE4/nZm4IEY=;
	b=CKdqQeb8N8OCUeJTZtceLWhiqZe+AwT3WSmO5muqg8zaS4pJ/AvUoNvidKvlxO+2VIVyV3U8s4/rQj4Afd/L+Adws4w7xL9f00NgMQG7gBavcXqHHnavbNwXA+0nZVYcdZMp5WPbOpdOkJ3rTGog9/TMdMFOr02lUQvYLC4o1k8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033022160150;MF=mengferry@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W6eF4EW_1715938910;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0W6eF4EW_1715938910)
          by smtp.aliyun-inc.com;
          Fri, 17 May 2024 17:42:01 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH v2 0/2] ocfs2: add checks in ocfs2_xattr_find_entry() to avoid potential out-of-bound access.
Date: Fri, 17 May 2024 17:41:45 +0800
Message-Id: <20240517094147.87133-1-mengferry@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi, all:

This patch series attempts to address a scenario where accessing user-defined
xattrs in a carefully crafted image can lead to out-of-bound access.(To speak
truthfully, I do not think this vehavior would occur under proper usage.)

In my testing environment, I constructed an OCFS2 image, created a file with
several user-defined xattrs(long name attributes, this will cause a "Non-INLINE"
xattr, which requires additional space for storage), and then forcibly modified
the xe_name_offset using a binary editing tool (e.g "hexedit"). Upon remounting
the image and running 'getfattr -d /path/to/file', this patchset was able to 
detect "partial" malicious modification.

In v2, I make these changes:
- (1/2) use xs->end directly, no need to parse a parameter.
- (2/2) define a local var 'name_offset'.

Ferry Meng (2):
  ocfs2: add bounds checking to ocfs2_xattr_find_entry()
  ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()

 fs/ocfs2/xattr.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

-- 
2.32.0.3.g01195cf9f

