From: Zhen Ren <zren@suse.com>
Date: Sun, 12 Jul 2015 04:10:14 -0600
Subject: [Ocfs2-devel] [PATCH 1/2 v2] ocfs2: fix race between dio and
 recover orphan
In-Reply-To: <559FAA0E.8090005@huawei.com>
References: <559FAA0E.8090005@huawei.com>
Message-ID: <55A2C9A6020000D40006F887@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

The following added lines are same as the deleted. Is it because the unnecessary trailing whitespaces?

-	level = ocfs2_iocb_rw_locked_level(iocb);
-	ocfs2_rw_unlock(inode, level);
+		level = ocfs2_iocb_rw_locked_level(iocb);
+		ocfs2_rw_unlock(inode, level);

--
Eric
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
