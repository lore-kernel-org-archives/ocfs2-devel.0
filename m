Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D54322C62
	for <ocfs2-devel@lists.linux.dev>; Tue, 19 Aug 2025 13:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755610404; cv=none; b=GhFzaT25mXn1CnU9DsHA3pWIVTO8mZHpylGV5h1mZ50I95AC30EintZtZRexnLpdjB/OQX+9klHCc545aK4bSh0+84DqFMeyJJcgRvVzmndjovpDq2YwHLHDtJzY3tNp793+UvTqHmiYphb9pfPoMDysk0+7nxq1v3cYUIAVEVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755610404; c=relaxed/simple;
	bh=QyzjF/0AaOroCSH9RzV1rO0zR6QeIeCkyR33hpWQa4c=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=F8bLp0eU9vml3Ts1TlkL75YyBFq+vai18ftLH1c5m6hEv1f/pmSdNJ6gSX9oLUi1LaAJeX8Mvo4yx/+I54AZ+zDVn5I0nqlTzDu1mGmkwJ9WCtJuO02PcBCfyDuaaqeuT46ER0dkCDCE65IbKxgVaZKxII+QHO/rTYh8W5Y8unE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=tpToMNmv; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="tpToMNmv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1755610390; bh=vz/aLcAyIdl0LH4vvwbsWgUHYbgEUH4l4+X75EZNmNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpToMNmvJHODtBaYfq4Bi7ubfrGjkYP+eq7gNP6ZJRqapHcDdmtxReSueU1DWHVH/
	 iAAyQJbOUse6BstURg9vX8ArBaMKy2FHe2TarpYDQ85TfXYu2fkVW4BqW8XYCV7vI8
	 KRIuIOUq9dBR/CJA4wBnUMJ474auAv+1HQpfhniM=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.230.220])
	by newxmesmtplogicsvrszc41-0.qq.com (NewEsmtp) with SMTP
	id 83037A32; Tue, 19 Aug 2025 21:32:48 +0800
X-QQ-mid: xmsmtpt1755610368tgabz2ymh
Message-ID: <tencent_5E787A6C242FE96CC89454E856EC52CEC40A@qq.com>
X-QQ-XMAILINFO: MIAHdi1iQo+zIrDfBBjifQF3t9+JGdjLtdlyu1RdcFzik61Q3xQsm7gkw07w0x
	 M43FICJTS7Z4NJENS/AP3tnUP0c5pNwO+p6K7JiGKwm+Gg71++H7ErGKGCSQ97Kd8ljJ+Ybr+dCi
	 GQq2UOpeVzzGMpuf9FaafqefcDWr3LXrDZW/Q4CRqdHrrnsgXOkzQJ/rJmZGqMSn4wBO9Wl9rc/x
	 YvxWbd9SxOJWpi5tUewNJnHilZb70p8Z4wqe8bZYkyTK10Rp7swrOscDlKrVetwo9TeUkYyPlGts
	 X0KZyq78OonSD3KKOKMj3UeBoo3Qo//4KI13BrtJPXvYf5RS3onuI6HltbuMUcHVMAaVIUPL6Fyo
	 7V8g1vbQCektp6gB/06xGqJKiDoleEvyIpYLaqKeYxSzqx1SE3m+Mpl7wxSyQLkCqOOD5GCMw7dd
	 CXwX5I13P4TgtjOkbMJC3snmRaSjFWPnDY6+172xyc0QsSQWrigwF56XFL8h4+LgdQ7XPD2K/I4/
	 yZDyDcaroOIaAXcC4l3cK+nIXON1B7+VU8iUjjtFztHoR3bT8rTSEZBsSfCB6B6ULRYcX+f+h9Ef
	 Rg3PglsNuiwhzIlv48i2zNC3vzaCfQ8GbYxCggleCiOVfPOIPCo7xKzSrYRnmoHEGGueoLut99aP
	 1HQDQoHJorY6U1omofNBvQwIsKlmsBMDWKsEhK6MTcSooKeGWkJm7wRpm9Q5Fe1T+1/pA4xEL/Ew
	 SIQZ+1EL2K7nLIK1s0Ls2iIXg3xXtRDKAzlnRqQDKVf2v2pR6GaGcrWjZBD8Q+YcJqYooifcfD88
	 4sn7do+jtPoRNRo3xqWtrmT849+b+BpLJdImTFntRq0yHuKu/1OvIx78CTpfTsajn4nuuygiSzr7
	 t3rnB1klUqiCnVfX8nBh2+NGr8+/5fq+rQ48IqCpbBa36cXUJy0sfIXQC5NXQxvOYYWhjnpevvBs
	 jspE95jvnrXWOYm6ZPKNFnQ5hBWSbKUEWnF9/EwLAul17bc7Aa7A==
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] ocfs2: prevent release journal inode after journal shutdown
Date: Tue, 19 Aug 2025 21:32:48 +0800
X-OQ-MSGID: <20250819133247.1261704-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <68a46146.050a0220.e29e5.00c2.GAE@google.com>
References: <68a46146.050a0220.e29e5.00c2.GAE@google.com>
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

Adding osb->journal checks will prevent UAF during the above execution path.

Reported-by: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
Closest: https://syzkaller.appspot.com/bug?extid=47d8cb2f2cc1517e515a
Tested-by: syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
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

