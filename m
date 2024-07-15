Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBB018C16D
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 13:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721048873; cv=none; b=MzXOQgID61H5u3fIz6AcddaCUkfZBk95OxwPbjrZS2EfjzWIOZHva+N0em4BIaVdJo6hMypQm6GloraWnzCE5BYM5DACMrktP5J3oVzaRHKvvCNCUhwKI1G/+mg4IQ0GgyZCnr4WFAh6JFaHGOhTsb9MySnsuFVwdHGtXdRqNps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721048873; c=relaxed/simple;
	bh=scmUIrpt556yK+4eOEfui3X5RWBuHqjT5k4U/JnHPdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GNf4Yn1ESTfdnMblhBiT95hI24fKbppq4TuqgDKHPLVt/qvZGGIFCfqqlCxc+WQJWM+EtnikfJe9yxHtB/Zxp2ryhYXGbYiNl/Aci8Y/1HqEbsu9DWl2CpO3Ig5vJ8AnjbqwI84QORalfXvW0i5SktgCvVJvPk+uy0ziGe21Hgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WN2YL75m9z4f3n6L
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 21:07:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 209691A01B9
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 21:07:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgBHKzkhH5VmjCPSAA--.61776S3;
	Mon, 15 Jul 2024 21:07:47 +0800 (CST)
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
Subject: [PATCH 1/4] quota: avoid missing put_quota_format when DQUOT_SUSPENDED is passed
Date: Mon, 15 Jul 2024 21:05:31 +0800
Message-Id: <20240715130534.2112678-2-shikemeng@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHKzkhH5VmjCPSAA--.61776S3
X-Coremail-Antispam: 1UD129KBjvdXoW7XF45GFyDAryfWFW3XF1rXrb_yoWDWrg_K3
	4Ik3y8ZFWxXF9ag3WqgrWfWrZ09ayrGws3WF4jyrnrJryDGr45ZF4vqF9xAa4kZ3y7t398
	Zas2yry7KFWrWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTxYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M2
	8IrcIa0xkI8VCY1x0267AKxVWUCVW8JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F
	4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0
	oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7V
	C0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j
	6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
	0xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
	W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1_cTDUUUUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/

Avoid missing put_quota_format when DQUOT_SUSPENDED is passed to
dquot_load_quota_sb.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 fs/quota/dquot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 627eb2f72ef3..23fcf9e9d6c5 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2408,7 +2408,7 @@ static int vfs_setup_quota_inode(struct inode *inode, int type)
 int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
 	unsigned int flags)
 {
-	struct quota_format_type *fmt = find_quota_format(format_id);
+	struct quota_format_type *fmt;
 	struct quota_info *dqopt = sb_dqopt(sb);
 	int error;
 
@@ -2418,6 +2418,7 @@ int dquot_load_quota_sb(struct super_block *sb, int type, int format_id,
 	if (WARN_ON_ONCE(flags & DQUOT_SUSPENDED))
 		return -EINVAL;
 
+	fmt = find_quota_format(format_id);
 	if (!fmt)
 		return -ESRCH;
 	if (!sb->dq_op || !sb->s_qcop ||
-- 
2.30.0

