From: wengang wang <wen.gang.wang@oracle.com>
Date: Tue Apr 17 20:41:48 2007
Subject: [Ocfs2-devel] Re: [PATCH] ocfs2_dlm: add spinlock protection before
 __dlm_print_one_lock_resource is called
In-Reply-To: <46258EB6.3010406@oracle.com>
References: <46249641.3070108@oracle.com> <46258EB6.3010406@oracle.com>
Message-ID: <46259387.5040002@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

same problem happens on dlm_deref_lockres_worker(1.2.5 and 1.2.4) and  
dlm_deref_lockres_handler(1.2.4 only)
fix is the same.

wengang wang wrote:
> ocfs2_dlm:  add spinlock protection per __dlm_print_one_lock_resource 
> calling
>
> In dlm_convert_lock_handler(), in case of !lock, 
> __dlm_print_one_lock_resource is called. __dlm_print_one_lock_resource 
> needs protection of spinlock on res->spinlock.  current source lost 
> that protection.
> use dlm_print_one_lock_resource instead of __dlm_print_one_lock_resource.
>
> Signed-off-by: wengang wang <wen.gang.wang@oracle.com>
>
> Index: ocfs2-1.2.5/fs/ocfs2/dlm/dlmconvert.c
>
> ===================================================================
> --- ocfs2-1.2.5/fs/ocfs2/dlm/dlmconvert.c.orig  2007-04-18 
> 11:15:36.000000000 -0400
> +++ ocfs2-1.2.5/fs/ocfs2/dlm/dlmconvert.c       2007-04-18 
> 11:16:00.000000000 -0400
> @@ -490,7 +490,7 @@
>                               "cookie=%u:%llu\n",
>                               
> dlm_get_lock_cookie_node(be64_to_cpu(cnv->cookie)),
>                               
> dlm_get_lock_cookie_seq(be64_to_cpu(cnv->cookie)));
> -               __dlm_print_one_lock_resource(res);
> +               dlm_print_one_lock_resource(res);
>                goto leave;
>        }
>
>
>
>

-- 
Wengang Wang
Member of Technical Staff
Oracle China Development Center
Open Source Technologies Development

Tel:      +86 10 8278 6265
Mobile:   +86 13381078925
