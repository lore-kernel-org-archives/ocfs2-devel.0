Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5547818C331
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 13:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721048873; cv=none; b=lRV26JvcNYbXkTuaV+O6RS6qrdPIbidtk7PZb/y5hV7L33NM5iUXmmpam+W0V5OsQRCOEYUcDXn2+HVBFSUZjlro4d/hK+4Z1/G5EFXpCMu/XamsSFFHLV5/wyRHBfL7dVIKng8fiz8Q5FbGOz1T/pvGVg9G/mn3x4xiXyErOcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721048873; c=relaxed/simple;
	bh=O/EUR4LuyoK3NKi3Bs380ukJ5pwbD+rvk2y103dnjK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YtBK/j+Squ4Ar0NitMqGo5O1iKDWeVzW9uIJrmkgKIGgmNvGuDdYg00ymix06AUw7wlt2CjhxOIZg5npy8EGw5tWAWIbFejBWvQ5qC5Kyqr8DyCyTdQjkDquPnGGHJ1P+BEH3GpuOl09pJBEI1D3thxfFKmGuny2ncMJeNRPC9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WN2YN1wqWz4f3mJK
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 21:07:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 62E031A016E
	for <ocfs2-devel@lists.linux.dev>; Mon, 15 Jul 2024 21:07:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgBHKzkhH5VmjCPSAA--.61776S6;
	Mon, 15 Jul 2024 21:07:49 +0800 (CST)
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
Subject: [PATCH 4/4] quota: remove unnecessary error code translation in dquot_quota_enable
Date: Mon, 15 Jul 2024 21:05:34 +0800
Message-Id: <20240715130534.2112678-5-shikemeng@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHKzkhH5VmjCPSAA--.61776S6
X-Coremail-Antispam: 1UD129KBjvdXoWruF1UGFW7CF4DGw4kWry8Zrb_yoWDAwb_Ca
	1I93ykZF48ur4SkanrJF4UA3WYgan5Aw1DXFs2yF98Gr1UJrW5JrWqqrykArs5ZanIkFZ8
	C3ykAw10kF4rWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfxYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s
	0DM28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
	WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZTmfUUUUU=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/

Simply set error code to -EEXIST when quota limit is already enabled in
dquot_quota_enable to remove unnecessary error code translation.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 fs/quota/dquot.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 2ca1f16689de..fdf19360ffc9 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2598,7 +2598,8 @@ static int dquot_quota_enable(struct super_block *sb, unsigned int flags)
 			goto out_err;
 		}
 		if (sb_has_quota_limits_enabled(sb, type)) {
-			ret = -EBUSY;
+			/* compatible with XFS */
+			ret = -EEXIST;
 			goto out_err;
 		}
 		spin_lock(&dq_state_lock);
@@ -2612,9 +2613,6 @@ static int dquot_quota_enable(struct super_block *sb, unsigned int flags)
 		if (flags & qtype_enforce_flag(type))
 			dquot_disable(sb, type, DQUOT_LIMITS_ENABLED);
 	}
-	/* Error code translation for better compatibility with XFS */
-	if (ret == -EBUSY)
-		ret = -EEXIST;
 	return ret;
 }
 
-- 
2.30.0

