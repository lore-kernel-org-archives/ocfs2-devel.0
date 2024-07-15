Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BD518C320
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 13:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721048873; cv=none; b=gb2Pb9G0Xj/P9/Hfk8t59NKqtyUv9AdBLRINdD1AT1+Ep2OZzSpPdT1GSSeyDE4kQwrbgQ3dgQyvhTeV9CKNjsvT59or8DBBFcX3NDGylVrCYMAOkOHQax5nsBfyIk7lX9duC7BF72cVjJ4LOanqVLj1+pGNXcnwATbPyEWnY0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721048873; c=relaxed/simple;
	bh=xHT4+bFd6sXV4vlzD8qkhOgc25DmDNqPRZ6ChEspulo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BGFUI3iXM+YBZXEe5Bg3z7YGASj++d0T+Hr4qam4eLNq7n1Z1LrvdV/wVhyR8tpL1Ey4sez1Ovz31AgP3OySPgetassbU95i90e752CqN+NgbOo2+7nvA87nuHKrY7pmT0hWpO4RGMcvUDWWphyBkcC6AG3NQ8hZIpDwFvyu2QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WN2YT0Pw8z4f3kkH
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 21:07:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ED5481A0181
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 21:07:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgBHKzkhH5VmjCPSAA--.61776S5;
	Mon, 15 Jul 2024 21:07:48 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: jack@suse.com
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	hughd@google.com,
	akpm@linux-foundation.org,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] quota: remove redundant return at end of void function
Date: Mon, 15 Jul 2024 21:05:33 +0800
Message-Id: <20240715130534.2112678-4-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20240715130534.2112678-1-shikemeng@huaweicloud.com>
References: <20240715130534.2112678-1-shikemeng@huaweicloud.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHKzkhH5VmjCPSAA--.61776S5
X-Coremail-Antispam: 1UD129KBjvdXoWrury3ZryfXr4rur1fCF4xtFb_yoWDJFX_Cr
	yfu34Fyr4Ut3Z3tFWUtr4rJwnaqws8Cw1UXF47t3W3Gw1rtrW8Ar1qvwn3JryDJ347C3y3
	CrW8CrsrGFWrKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTkYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r1rM2
	8IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
	4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UACztUUUUU=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/

Function dquot_claim_space_nodirty nad dquot_reclaim_space_nodirty have
no return value, just remove redundant return at end of the functions.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 fs/quota/dquot.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a08a71890cd8..2ca1f16689de 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1830,7 +1830,6 @@ void dquot_claim_space_nodirty(struct inode *inode, qsize_t number)
 	spin_unlock(&inode->i_lock);
 	mark_all_dquot_dirty(dquots);
 	srcu_read_unlock(&dquot_srcu, index);
-	return;
 }
 EXPORT_SYMBOL(dquot_claim_space_nodirty);
 
@@ -1872,7 +1871,6 @@ void dquot_reclaim_space_nodirty(struct inode *inode, qsize_t number)
 	spin_unlock(&inode->i_lock);
 	mark_all_dquot_dirty(dquots);
 	srcu_read_unlock(&dquot_srcu, index);
-	return;
 }
 EXPORT_SYMBOL(dquot_reclaim_space_nodirty);
 
-- 
2.30.0

