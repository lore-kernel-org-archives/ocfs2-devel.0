Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A051A341ADC
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Aug 2025 13:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755611243; cv=none; b=gZj2LjhC3E/7d/aCTpeob9lz7J6vD5p651mmrpHYyXP1TL+o4PA7TOQkgxPNf8MW5YvMx8ie9dp6tSjHIJfRZwFOCHAnaEEQga0aC9lQ6FYxI8XOMypxJt5D24SbNzkd//sX5PcCDHvDjColcisIbbckr8iatApUN+BamKq2o7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755611243; c=relaxed/simple;
	bh=Ybm10wiHr5ulrJ9Frxyd1d5WckN8g1UtM/uNWu5yBvc=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=XjyESncAOVWJViQJ+gQYYQk1gjkMuNCUzdTA2wh7DbjvvDiIioXG356czNWmepklW2NGO1PxH2ycksAUZezZmmvxv2aoI6Z14jnAGqnx90FZKw5o23G1qJCd4EYL1H41l+MElOmlljKqJHCTO4e7MCoXsoTqAakInSVqR9CDHj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=jecbLfCs; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="jecbLfCs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1755611229; bh=OlS3uc13OkAKUWAvQfgzjGpAgOq2p9mUY7KcYX8F/Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jecbLfCshlk5Tc/9PU9Uaabc5tVXwhVji0jT9/wJiZ0B7c1tIiqS/lgt3YdcZlHRq
	 MIyWzaq5AcLE8VLkv07vN4M0r9Kgenn2A3RZ1N6fXdv0gON6NZ1mgVj2I4RadCTZ82
	 kWJRQ4TOt/X/hnL5nMzhgJ1znrfaYUZlmnmKeYnk=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.230.220])
	by newxmesmtplogicsvrsza29-0.qq.com (NewEsmtp) with SMTP
	id A4125023; Tue, 19 Aug 2025 21:41:01 +0800
X-QQ-mid: xmsmtpt1755610861tgji6fijw
Message-ID: <tencent_357489BEAEE4AED74CBD67D246DBD2C4C606@qq.com>
X-QQ-XMAILINFO: NafziRg7Bx69icZz1+1/hg2anVwN2QhvGYv5r2pepvoqBBCN9avGN9TkyFaypI
	 vqJpVlyz8Yxpck5Acd/0lWobT0QLdjmhWL1t2NjoCPoz7+GAngRuQCnidCX8HJoV0TaOTwZoComE
	 FSM7zbTCqE5TRl1CgC94WU2AfzqDFA7ydhBR1Cyf6bHLTb/DEYFefrWbOHa45cxDWr8IbLPplJcg
	 dCM1BqcIBNDKry8uu59aIWz9m00B+M3NxvVMQZ2Uj4HPHwN3WtSs6xqhk8DaqWUMGeW0cflEfQtU
	 RmZ7dEhaihzZT1GuREwC4guz7xdWBQpr5IgPrVE/vEBXQGotSjjeANFR8BUChtVO1A4va0uM1zvE
	 6HkWD+2+pieqrlFIwIv/vWOi05pk/VH6xZjiEvMcklfKukXJDqhbIGQfI3wynMO6MnpVhubpE6l8
	 NLo8xEFAu/RipUYyp9Vx6JeMUF2XLsWuBr+IQ8yEM9NACj2l1gFdSuue8y/MPlwnvjE8ZE59sNhl
	 vTSRIegk1NjhapaZdN3bAqlCHDH8biROvkYNzp9SCZKwqMeSzz6OGFBrPtHSVELcwij58DVDPVQA
	 31E7ZAzxJrIwXLbgQ2AMlnVyBuL9hJqPCdCPl/E0L36R9wQGjr8p8etjKlpIvjK8GKYupYRNNiRE
	 5WlE5O0XE8qeBl8StePDqOm9FFk5UAZ8957+E73Wl65D5pWyFmQY/ZwaVRJOKLR+zI1WThKWm4ZW
	 Oeu6hozxj/FmrubAzTaSv0D79tSqQhRNKCO4jFuspd2Bvxnz/zhbJ9Zjcul+TPIQIdgLozAineh3
	 ab5/G62fjbAXiSAzqtqcWvqaLfytGWRSbo2YMbQZVd0bOwxpBGVsHYh2DCZd5teebL5z4kcqLig5
	 tJ4cLxsKrOOjK6zykbbv1zv/+3FxY9ePp/3mxMTfddzm30OqzFwt95fBVYEKojqWRdo1/ZZ8TxKk
	 N2XQTUN7tVSiotz4KpmdiRiGklHDpu8PKRhgcIld4ZAjz25QVVZ8du4FRepfo1oogT4ko7+lGROB
	 IpieKRnjRkHNmdqCGygtBzwEJANlBRP6n8JfA1Ffos3jhlWrRNiaxzktsUc6mgMvCW1KA/6w==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Edward Adam Davis <eadavis@qq.com>
To: eadavis@qq.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH V2] ocfs2: prevent release journal inode after journal shutdown
Date: Tue, 19 Aug 2025 21:41:02 +0800
X-OQ-MSGID: <20250819134101.1271797-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <tencent_5E787A6C242FE96CC89454E856EC52CEC40A@qq.com>
References: <tencent_5E787A6C242FE96CC89454E856EC52CEC40A@qq.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before calling ocfs2_delete_osb(), ocfs2_journal_shutdown() has already
been executed in ocfs2_dismount_volume(), so osb->journal must be NULL.
Therefore, the following calltrace will inevitably fail when it reaches
jbd2_journal_release_jbd_inode().

ocfs2_dismount_volume()->
  ocfs2_delete_osb()->
    ocfs2_free_slot_info()->
      __ocfs2_free_slot_info()->
        evict()->
          ocfs2_evict_inode()->
            ocfs2_clear_inode()->
	      jbd2_journal_release_jbd_inode(osb->journal->j_journal,

Adding osb->journal checks will prevent null-ptr-deref during the above
execution path.

Reported-by: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=47d8cb2f2cc1517e515a
Tested-by: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
V1 -> V2: Corrected typos and comments.

 fs/ocfs2/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 14bf440ea4df..6c4f78f473fb 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1281,6 +1281,9 @@ static void ocfs2_clear_inode(struct inode *inode)
 	 * the journal is flushed before journal shutdown. Thus it is safe to
 	 * have inodes get cleaned up after journal shutdown.
 	 */
+	if (!osb->journal)
+		return;
+
 	jbd2_journal_release_jbd_inode(osb->journal->j_journal,
 				       &oi->ip_jinode);
 }
-- 
2.43.0

