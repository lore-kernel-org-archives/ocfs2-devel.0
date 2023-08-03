Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA0A1ED48
	for <ocfs2-devel@lists.linux.dev>; Thu,  3 Aug 2023 14:59:55 +0000 (UTC)
Received: from localhost.biz (unknown [10.81.81.211])
	by gw.red-soft.ru (Postfix) with ESMTPA id DDF773E039C;
	Thu,  3 Aug 2023 17:54:29 +0300 (MSK)
From: Artem Chernyshev <artem.chernyshev@red-soft.ru>
To: Joel Becker <jlbec@evilplan.org>,
	Mark Fasheh <mark@fasheh.com>
Cc: Artem Chernyshev <artem.chernyshev@red-soft.ru>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Kurt Hackel <kurt.hackel@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] fs: ocfs2: namei: Check return value of ocfs2_add_entry()
Date: Thu,  3 Aug 2023 17:54:17 +0300
Message-Id: <20230803145417.177649-1-artem.chernyshev@red-soft.ru>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 179049 [Aug 03 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 526 526 7a6a9b19f6b9b3921b5701490f189af0e0cd5310, {Tracking_from_domain_doesnt_match_to}, red-soft.ru:7.1.1;localhost.biz:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/08/03 11:45:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/08/03 09:18:00 #21658041
X-KLMS-AntiVirus-Status: Clean, skipped

Process result of ocfs2_add_entry() in case we have an error
value.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
---
 fs/ocfs2/namei.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 17c52225b87d..03bccfd183f3 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1535,6 +1535,10 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 		status = ocfs2_add_entry(handle, new_dentry, old_inode,
 					 OCFS2_I(old_inode)->ip_blkno,
 					 new_dir_bh, &target_insert);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
 	}
 
 	old_inode->i_ctime = current_time(old_inode);
-- 
2.37.3

