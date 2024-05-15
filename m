Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1E0127B45
	for <ocfs2-devel@lists.linux.dev>; Wed, 15 May 2024 13:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779796; cv=none; b=jxn3JtdPFOdvWdFqtVuGxSbiVJVax4fL55PcS7CAZuj8vl/FEzOQ4bX9UBXqELSBOUTsTgKr1AN0GLeQald+znhP0L8f1CxosAYtuq+eQI4UQSsncUlPb8Tq9ylC+lqIWnuzacDxDd2AjFZayXODUPByD5q99OQMU+Dcd6Aw+AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779796; c=relaxed/simple;
	bh=B7PqeR83jc564rgcpFbgg8kbs3VTxwFY+XycCSK4J0I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CKnmmfHu4fnOQVl3W3Tk3cttnguTzmO53cJGR+nhtIHohLUaJNbkVJ8lLbLb8AH8GUza2QJUk20rxt7fpfZ+8X3TEzr+5orI/q+qGuQRUsli7+AP5BnFxE10Rk1SFy5qAmDdvaasPzGDSSXRHyooz24RXputnEuDVVOXipS8jjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=M4G+KoeR; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="M4G+KoeR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1715779786; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=pA/BXieSQ7onSemkT+42p9rXghuIU5BPHTO1tEoW9LM=;
	b=M4G+KoeR5rXbJ1BiYu097Rc11SXvRhr/nzo5WnLH8lsrwrfQ7hibfD2/0qhdPkwTM8H+Zvrq0rfle1/1YepOyaAyqfiDLa/Fx69q7OqOIbTWdlGIIqRGuz4+DQdOjkSOoogWbyT5pDEHQidGEt5KbtD6tWmHBpHDWLyeExPMYEc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045075189;MF=mengferry@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W6YDIDf_1715779779;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0W6YDIDf_1715779779)
          by smtp.aliyun-inc.com;
          Wed, 15 May 2024 21:29:45 +0800
From: Ferry Meng <mengferry@linux.alibaba.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Ferry Meng <mengferry@linux.alibaba.com>
Subject: [PATCH 0/2] ocfs2: add checks in ocfs2_xattr_find_entry() to avoid potential out-of-bound access.
Date: Wed, 15 May 2024 21:29:32 +0800
Message-Id: <20240515132934.69511-1-mengferry@linux.alibaba.com>
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

Comments and feedbacks are welcomed.

Ferry Meng (2):
  ocfs2: add bounds checking to ocfs2_xattr_find_entry()
  ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()

 fs/ocfs2/xattr.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

-- 
2.32.0.3.g01195cf9f

