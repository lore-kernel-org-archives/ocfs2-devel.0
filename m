From: wengang wang <wen.gang.wang@oracle.com>
Date: Thu, 05 Jun 2008 10:52:49 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: check return value of
	ocfs2_journal_load()
Message-ID: <48475501.9090904@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

we should check the return value of ocfs2_journal_load() before going on.
this patch is based on 1.2 svn, but mainline git should has the same fix.

Signed-off-by: wengang wang <wen.gang.wang@oracle.com>
---
 super.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)



-- 
Wengang Wang
Member of Technical Staff
Oracle Asia R&D Center
Open Source Technologies Development

Tel:      +86 10 8278 6265
Mobile:   +86 13381078925

-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2_journal_load.patch
Type: text/x-patch
Size: 548 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080605/6b419fb4/attachment.bin 
