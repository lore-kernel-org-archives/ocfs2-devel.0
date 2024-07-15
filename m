Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB5718C165
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 13:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721048874; cv=none; b=UEAK1U2lb7zgss1l1LwGSWdqOAUi6TRjuEUO/5j+QqlUprZplOIFKYSWG37mZqM/S+6Cvj8Q1pnlZpK532dmPglY/cCwSypW4sQ/zM0SUoI7GMw4tzJue84GEECC5MqUn9Xyn0vgRhwnX+c3Aa0r449XQBtJgWJ9S+Ex2dIbFZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721048874; c=relaxed/simple;
	bh=ePXF9ZLNfnoImIzw7g5TwMAtkddwvRI5bYuHlN/kTVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dLf1Hggb4SiERTdp+4x9EiWqZEbf9qaMhM6inadGJtzJ2RLRzS76v7jKyfhj1ZpkfnN0BoZbwOE2OPSKNezrH4ta+Ij/moo7KDzepsZ53X2G/pVjUGKZaz4ldyiTVMHTZRAPrjmBLqr1C43/t/GoF400p8756t5kF7gE9gLp8uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WN2YM2nMCz4f3n6N
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 21:07:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 806D11A016E
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 21:07:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgBHKzkhH5VmjCPSAA--.61776S4;
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
Subject: [PATCH 2/4] quota: remove unneeded return value of register_quota_format
Date: Mon, 15 Jul 2024 21:05:32 +0800
Message-Id: <20240715130534.2112678-3-shikemeng@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHKzkhH5VmjCPSAA--.61776S4
X-Coremail-Antispam: 1UD129KBjvJXoWxXFy5WFyUJw13KF1fAr4fZrb_yoWrXF4xpw
	1kCrs3tFyrtryDZ3yUXay5ury8W39rWF12vr48A3W2qrn09rW8Ar1UG34FvFy5Cry8Aw1Y
	qFn5C3W7Cw4jgrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Kb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2WrWUUUUU
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/

The register_quota_format always returns 0, simply remove unneeded return
value.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 fs/ocfs2/super.c      | 6 ++----
 fs/quota/dquot.c      | 3 +--
 fs/quota/quota_v1.c   | 3 ++-
 fs/quota/quota_v2.c   | 9 +++------
 include/linux/quota.h | 2 +-
 mm/shmem.c            | 7 +------
 6 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index afee70125ae3..73caa8914ebe 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1571,15 +1571,13 @@ static int __init ocfs2_init(void)
 
 	ocfs2_set_locking_protocol();
 
-	status = register_quota_format(&ocfs2_quota_format);
-	if (status < 0)
-		goto out3;
+	register_quota_format(&ocfs2_quota_format);
+
 	status = register_filesystem(&ocfs2_fs_type);
 	if (!status)
 		return 0;
 
 	unregister_quota_format(&ocfs2_quota_format);
-out3:
 	debugfs_remove(ocfs2_debugfs_root);
 	ocfs2_free_mem_caches();
 out2:
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 23fcf9e9d6c5..a08a71890cd8 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -163,13 +163,12 @@ static struct quota_module_name module_names[] = INIT_QUOTA_MODULE_NAMES;
 /* SLAB cache for dquot structures */
 static struct kmem_cache *dquot_cachep;
 
-int register_quota_format(struct quota_format_type *fmt)
+void register_quota_format(struct quota_format_type *fmt)
 {
 	spin_lock(&dq_list_lock);
 	fmt->qf_next = quota_formats;
 	quota_formats = fmt;
 	spin_unlock(&dq_list_lock);
-	return 0;
 }
 EXPORT_SYMBOL(register_quota_format);
 
diff --git a/fs/quota/quota_v1.c b/fs/quota/quota_v1.c
index 3f3e8acc05db..6f7f0b4afba9 100644
--- a/fs/quota/quota_v1.c
+++ b/fs/quota/quota_v1.c
@@ -235,7 +235,8 @@ static struct quota_format_type v1_quota_format = {
 
 static int __init init_v1_quota_format(void)
 {
-        return register_quota_format(&v1_quota_format);
+	register_quota_format(&v1_quota_format);
+	return 0;
 }
 
 static void __exit exit_v1_quota_format(void)
diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
index c48c233f3bef..1fda93dcbc1b 100644
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -440,12 +440,9 @@ static struct quota_format_type v2r1_quota_format = {
 
 static int __init init_v2_quota_format(void)
 {
-	int ret;
-
-	ret = register_quota_format(&v2r0_quota_format);
-	if (ret)
-		return ret;
-	return register_quota_format(&v2r1_quota_format);
+	register_quota_format(&v2r0_quota_format);
+	register_quota_format(&v2r1_quota_format);
+	return 0;
 }
 
 static void __exit exit_v2_quota_format(void)
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 07071e64abf3..89a0d83ddad0 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -526,7 +526,7 @@ struct quota_info {
 	const struct quota_format_ops *ops[MAXQUOTAS];	/* Operations for each type */
 };
 
-int register_quota_format(struct quota_format_type *fmt);
+void register_quota_format(struct quota_format_type *fmt);
 void unregister_quota_format(struct quota_format_type *fmt);
 
 struct quota_module_name {
diff --git a/mm/shmem.c b/mm/shmem.c
index a8b181a63402..d27104e1af9b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4660,11 +4660,7 @@ void __init shmem_init(void)
 	shmem_init_inodecache();
 
 #ifdef CONFIG_TMPFS_QUOTA
-	error = register_quota_format(&shmem_quota_format);
-	if (error < 0) {
-		pr_err("Could not register quota format\n");
-		goto out3;
-	}
+	register_quota_format(&shmem_quota_format);
 #endif
 
 	error = register_filesystem(&shmem_fs_type);
@@ -4693,7 +4689,6 @@ void __init shmem_init(void)
 out2:
 #ifdef CONFIG_TMPFS_QUOTA
 	unregister_quota_format(&shmem_quota_format);
-out3:
 #endif
 	shmem_destroy_inodecache();
 	shm_mnt = ERR_PTR(error);
-- 
2.30.0

