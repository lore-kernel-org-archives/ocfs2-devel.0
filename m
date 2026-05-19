Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8CA1A9FBD
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 May 2026 01:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779154603; cv=none; b=HLrNUiNBUA1t+MIkWi4RjvZsx7CTEEXEfiQGUuLwvK1iqexXvtYkSnKSrXbrk0wYBbPZzcikEIjT79/TfAescryNBskZtfohcUrsQ+9EpZP4QFWoL2eOjvyojDa02HOCOrY6qVHI1tDaWEpXjmN16Vn9f5TVGSrAv3FEVECU1Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779154603; c=relaxed/simple;
	bh=GwWvSd7YZR0iihWLdASextiH1h2VlPHWAKg39ZMUNWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=luryHfK6rFJ5rAw+tiyt/kiXwgTcRUcsPstRIb4XENX40tHKUN5oT4zgU2l4QZkSgfJhqVb56EFk1dgdkTs5CoHhjkfp/0JVYaEZxgv6Xoba/QrcyDBdN20rdoUNoAvK+MrDmVAjMwIE7Un8/Pp2Dkb/wyGekBr8uPxn86PXsWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn; spf=pass smtp.mailfrom=mails.ucas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mails.ucas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.ucas.ac.cn
Received: from fric.. (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowABnTOOevgtqbyV5EQ--.8777S2;
	Tue, 19 May 2026 09:36:30 +0800 (CST)
From: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
To: linux-kernel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev
Cc: Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
Subject: [PATCH] ocfs2: fix NULL deref in ocfs2_wait_for_recovery after recovery_exit
Date: Tue, 19 May 2026 01:36:29 +0000
Message-Id: <20260519013629.1105967-1-xujiakai24@mails.ucas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnTOOevgtqbyV5EQ--.8777S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZryxZFy5tr47uF1fGr4xCrg_yoW8XrWxpr
	srGrs3Ka4qqFyrAFn8XFy5XrWv93yjgFWDWr109w1a9F4rt39rZryUK3W8uFy5JFWqqayf
	trs7t3y5Cw4jk3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9j14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40E
	FcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr
	0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbVc_DUUUUU==
X-CM-SenderInfo: 50xmxthndljko6pdxz3voxutnvoduhdfq/

In ocfs2_recovery_exit(), the recovery_map is freed via kfree() but
osb->recovery_map is not set to NULL afterward. If ocfs2_wait_for_recovery()
is called subsequently (e.g. during inode eviction in the dismount path or
via a racing stat() syscall), ocfs2_recovery_completed() dereferences the
stale pointer, leading to a NULL pointer dereference at rm->rm_used.

Fix this by:
1. Setting osb->recovery_map = NULL after kfree() in ocfs2_recovery_exit()
2. Adding a NULL guard in ocfs2_recovery_completed() so that it safely
   returns "recovery completed" when the map has been freed

Fixes: 553abd046af6 ("ocfs2: Change the recovery map to an array of node numbers.")
Signed-off-by: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
---
 fs/ocfs2/journal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f9bf3bac085d..5529a177f90e 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -243,6 +243,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
 	/* XXX: Should we bug if there are dirty entries? */
 
 	kfree(rm);
+	osb->recovery_map = NULL;
 }
 
 static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
@@ -1225,6 +1226,9 @@ static int ocfs2_recovery_completed(struct ocfs2_super *osb)
 	int empty;
 	struct ocfs2_recovery_map *rm = osb->recovery_map;
 
+	if (!rm)
+		return 1;
+
 	spin_lock(&osb->osb_lock);
 	empty = (rm->rm_used == 0);
 	spin_unlock(&osb->osb_lock);
-- 
2.34.1

