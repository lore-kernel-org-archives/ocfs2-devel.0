From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue Apr 17 09:51:21 2007
Subject: [Ocfs2-devel] a patch on ocfs2
In-Reply-To: <46249641.3070108@oracle.com>
References: <46249641.3070108@oracle.com>
Message-ID: <4624FB06.2080805@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Remove the spinlocks. Instead remove the leading underscores....
Replace __dlm_print_one_lock_resource() with dlm_print_one_lock_resource().
And resubmit.

Also read the "The Perfect Patch" in http://oss.oracle.com/osswiki/OCFS2.

Your patch, while good, is missing the header and Signed-off-by lines. 
Case in point:
http://kernel/~smushran/patches/dlm-fix_lockres_refcnt.patch

If you still have qs, maybe quickest if you ping Tao/Tiger.

Thanks
Sunil

wengang wang wrote:
> Hi Sunil,
>
> I found a bug on ocfs2 covering both 1.2.4 and 1.2.5.
> it's simple,  please see the patch on 1.2.5(pasted below):
>
>
> --- ocfs2-1.2.5/fs/ocfs2/dlm/dlmconvert.c.orig  2007-04-17 
> 17:28:08.000000000 -0400
> +++ ocfs2-1.2.5/fs/ocfs2/dlm/dlmconvert.c       2007-04-17 
> 17:28:38.000000000 -0400
> @@ -490,7 +490,9 @@
>                               "cookie=%u:%llu\n",
>                               
> dlm_get_lock_cookie_node(be64_to_cpu(cnv->cookie)),
>                               
> dlm_get_lock_cookie_seq(be64_to_cpu(cnv->cookie)));
> +               spin_lock(&res->spinlock);
>                __dlm_print_one_lock_resource(res);
> +               spin_unlock(&res->spinlock);
>                goto leave;
>        }
>
