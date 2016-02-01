From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 01 Feb 2016 17:23:39 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: remove unused label
Message-ID: <3477441.9K8aQAEjZq@wuerfel>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-arm-kernel@lists.infradead.org

A recent cleanup modified the ocfs2_file_write_iter function, which
no longer uses its 'relock' label, as gcc warns:

fs/ocfs2/file.c: In function 'ocfs2_file_write_iter':
fs/ocfs2/file.c:2198:1: error: label 'relock' defined but not used [-Werror=unused-label]

This removes the label as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 1a46f12e5071 ("ocfs2: code clean up for direct io")
---
Found on ARM randconfig builds on linux-next last week.

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 41c506e7814e..c18ab45f8d21 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2195,7 +2195,6 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 
 	inode_lock(inode);
 
-relock:
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
