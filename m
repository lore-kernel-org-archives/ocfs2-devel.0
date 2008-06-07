From: wwg <wen.gang.wang@oracle.com>
Date: Sat, 07 Jun 2008 11:02:28 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: check return value
 of	ocfs2_journal_load() --for mainline
In-Reply-To: <48481440.5060808@oracle.com>
References: <48475501.9090904@oracle.com> <48481440.5060808@oracle.com>
Message-ID: <4849FA44.1040403@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> Wengang,
>
> Thanks. The patch looks good.
>
> However, please can you respin the patch for mainline. As we have now
> have a 1.4 tree too, inorder to ensure that we don't miss any patches,
> we want all patches to hit mainline before trickling down to 1.2/1.4.
> And as this is a bugfix, we should be able to push this in before
> 2.6.26 is released.
>
> Sunil
OK, got it.
patch for mainline 
(git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git).

Signed-off-by: wengang wang <wen.gang.wang@oracle.com>
---
 super.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)



-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2_journal_load-mainline.patch
Type: text/x-patch
Size: 563 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080607/38f38bb7/attachment.bin 
