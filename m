From: Changwei Ge <ge.changwei@h3c.com>
Date: Fri, 1 Dec 2017 01:57:09 +0000
Subject: [Ocfs2-devel] [patch 01/11] ocfs2: remove ocfs2_is_o2cb_active()
References: <5a208507.xhi09A4mNEE9ngDf%akpm@linux-foundation.org>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F1F41D7C@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Acked-by: Changwei Ge <ge.changwei@h3c.com>

On 2017/12/1 6:25, akpm at linux-foundation.org wrote:
> From: Gang He <ghe@suse.com>
> Subject: ocfs2: remove ocfs2_is_o2cb_active()
> 
> Remove ocfs2_is_o2cb_active().  We have similar functions to identify
> which cluster stack is being used via osb->osb_cluster_stack.
> 
> Secondly, the current implementation of ocfs2_is_o2cb_active() is not
> totally safe.  Based on the design of stackglue, we need to get
> ocfs2_stack_lock before using ocfs2_stack related data structures, and
> that active_stack pointer can be NULL in the case of mount failure.
> 
> Link: https://urldefense.proofpoint.com/v2/url?u=http-3A__lkml.kernel.org_r_1495441079-2D11708-2D1-2Dgit-2Dsend-2Demail-2Dghe-40suse.com&d=DwIDAw&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=rnJPiY1_qJ7_Qs9xIYdLDclkzvGkELwC-r4P43wj1kE&s=4QPFsG8EG4HzXiHfjwTwa9v-sFT2lUoAhvTKPw0gR8Q&e=
> Signed-off-by: Gang He <ghe@suse.com>
> Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
> Reviewed-by: Eric Ren <zren@suse.com>
> Cc: Mark Fasheh <mfasheh@versity.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   fs/ocfs2/dlmglue.c   |    2 +-
>   fs/ocfs2/stackglue.c |    6 ------
>   fs/ocfs2/stackglue.h |    3 ---
>   3 files changed, 1 insertion(+), 10 deletions(-)
> 
> diff -puN fs/ocfs2/dlmglue.c~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function fs/ocfs2/dlmglue.c
> --- a/fs/ocfs2/dlmglue.c~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function
> +++ a/fs/ocfs2/dlmglue.c
> @@ -3413,7 +3413,7 @@ static int ocfs2_downconvert_lock(struct
>   	 * we can recover correctly from node failure. Otherwise, we may get
>   	 * invalid LVB in LKB, but without DLM_SBF_VALNOTVALID?being set.
>   	 */
> -	if (!ocfs2_is_o2cb_active() &&
> +	if (ocfs2_userspace_stack(osb) &&
>   	    lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
>   		lvb = 1;
>   
> diff -puN fs/ocfs2/stackglue.c~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function fs/ocfs2/stackglue.c
> --- a/fs/ocfs2/stackglue.c~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function
> +++ a/fs/ocfs2/stackglue.c
> @@ -48,12 +48,6 @@ static char ocfs2_hb_ctl_path[OCFS2_MAX_
>    */
>   static struct ocfs2_stack_plugin *active_stack;
>   
> -inline int ocfs2_is_o2cb_active(void)
> -{
> -	return !strcmp(active_stack->sp_name, OCFS2_STACK_PLUGIN_O2CB);
> -}
> -EXPORT_SYMBOL_GPL(ocfs2_is_o2cb_active);
> -
>   static struct ocfs2_stack_plugin *ocfs2_stack_lookup(const char *name)
>   {
>   	struct ocfs2_stack_plugin *p;
> diff -puN fs/ocfs2/stackglue.h~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function fs/ocfs2/stackglue.h
> --- a/fs/ocfs2/stackglue.h~ocfs2-get-rid-of-ocfs2_is_o2cb_active-function
> +++ a/fs/ocfs2/stackglue.h
> @@ -298,9 +298,6 @@ void ocfs2_stack_glue_set_max_proto_vers
>   int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
>   void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
>   
> -/* In ocfs2_downconvert_lock(), we need to know which stack we are using */
> -int ocfs2_is_o2cb_active(void);
> -
>   extern struct kset *ocfs2_kset;
>   
>   #endif  /* STACKGLUE_H */
> _
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
