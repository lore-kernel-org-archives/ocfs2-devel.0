From: wengang wang <wen.gang.wang@oracle.com>
Date: Tue Apr 17 02:41:10 2007
Subject: [Ocfs2-devel] a patch on ocfs2
Message-ID: <46249641.3070108@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,

I found a bug on ocfs2 covering both 1.2.4 and 1.2.5.
it's simple,  please see the patch on 1.2.5(pasted below):


--- ocfs2-1.2.5/fs/ocfs2/dlm/dlmconvert.c.orig  2007-04-17 
17:28:08.000000000 -0400
+++ ocfs2-1.2.5/fs/ocfs2/dlm/dlmconvert.c       2007-04-17 
17:28:38.000000000 -0400
@@ -490,7 +490,9 @@
                               "cookie=%u:%llu\n",
                               
dlm_get_lock_cookie_node(be64_to_cpu(cnv->cookie)),
                               
dlm_get_lock_cookie_seq(be64_to_cpu(cnv->cookie)));
+               spin_lock(&res->spinlock);
                __dlm_print_one_lock_resource(res);
+               spin_unlock(&res->spinlock);
                goto leave;
        }

-- 
Wengang Wang
Member of Technical Staff
Oracle China Development Center
Open Source Technologies Development

Tel:      +86 10 8278 6265
Mobile:   +86 13381078925
