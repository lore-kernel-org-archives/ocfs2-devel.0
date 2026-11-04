Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759281;
	b=Q3HdqP0s7/hObBt5ooz+d/1W9/MmNI7h0fDTX93xoL6ONf9Vp4rHXbWoTbIkV4/zw7UF
	 NEtIbU9F9g4SSQ865bHLDhOX7tYFlrfQ09TtbTywp24QxKomhF2KCnR5+xsh+keSzwRVv
	 5+7dwBTYzTwNJBdb/4VKy9P5DGgYI6gYZYvl9W7nRSb3DIiqmNNJAp98/VBaiZesJXbj6
	 uz3aTHypph4F4gbGkDQh7upkJaEICgjxMfnOS4tOUrdi1C2JzgviiDDBYzXO5+lIK3iBm
	 TIMVrRYhY+fSPgACAzui4LE+OQwA3HRq+j4hEqhcSQ4bqvQSiGWCFDSeOOwmdx9gF3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759281;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=ZMcEMSQF/iA9JS66ib/Q5MS9Jof8nwlvtWZM4A5nkQg=;
	b=go2Eo7WcV3Wvy3m4S2FnVWPiirVmhPfoRUmazQImkjA7YYC8F3V4mIk0iCFXxe+xY0Q4
	 2P/mWduPdEBeGZ4kfXrUVjq5f8WovhDTQP50nbkXodbu5akVHm0MEge6FB+VGOntY6s/U
	 C9FXOIsh1b/cNs7/pYWTof3uA28tUFY/mY0GVqI7o5NLPDYadv+erpsHoUyJls0Zr/6N5
	 iWgosLj22/wHfs+ZyS7U8vibCiRlIbWU2HIf9KYE/aXKJzj4ZYH9O2wCnDWZTBLvarn13
	 fCsBcMPBoyMSHiFM262PV4mK8r/JV096AxtcRt35uvUjG1bUnQgzGTF5Rocim7u69xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1A606A32F
	for <ocfs2-devel@lists.linux.dev>; Wed,  4 Nov 2026 02:27:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2C1A606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowADH8_0smOpqc5s+AA--.9693S2;
	Wed, 04 Nov 2026 10:27:56 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev
Subject: [PATCH] ocfs2: put the new lock when recovery data has a duplicate
Date: Wed,  4 Nov 2026 02:28:05 +0000
Message-Id: <20261104022805.1484045-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADH8_0smOpqc5s+AA--.9693S2
X-Coremail-Antispam: 1UD129KBjvJXoWrtr1UWr18WF13trWDWw45Wrg_yoW8Jr4rpw
	47Xrn8K34xXa10qa1DWr45ArW8uw15Kr1xWrn8u34rZF45Kw1fWay7Xan2qFW5Ja4IganI
	krs3XFWUX390kaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
	v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
	McIj6xIIjxv20xvE14v26rWY6Fy7McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI
	8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
	xVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26F1j6w1UMIIF0xvE2Ix0cI
	8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
	87Iv67AKxVWxJVW8Jr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07b7pBhUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRQBA2rqY-nHQQAAsD

dlm_process_recovery_data() allocates a new dlm_lock for every lock
carried in the recovery message.  When the cookie is already present on
the target queue the entry is only marked bad, so the lock returned by
dlm_new_lock() keeps its initial reference and never reaches a queue
that would later release it.  The lockres reference taken by
dlm_lock_attach_lockres() leaks with it.

Drop the reference on that path so a duplicate entry cannot pin the lock
and its lockres.

Fixes: c3187ce5e335 ("ocfs2: only recover one dead node at a time")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/ocfs2/dlm/dlmrecovery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 7d519e31fcf1..b4c08a73b9ef 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2033,6 +2033,9 @@ static int dlm_process_recovery_data(struct dlm_ctxt *dlm,
 			dlm_lockres_set_refmap_bit(dlm, res, ml->node);
 		}
 		spin_unlock(&res->spinlock);
+
+		if (bad)
+			dlm_lock_put(newlock);
 	}
 	mlog(0, "done running all the locks\n");
 
-- 
2.34.1

