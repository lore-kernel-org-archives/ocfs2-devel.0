From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue Jan 15 10:22:16 2008
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: add dlm context printing in
	dlm	debug
In-Reply-To: <47806870.5070007@oracle.com>
References: <47806870.5070007@oracle.com>
Message-ID: <478CF97A.7060208@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Can you rework this so that it outputs in /proc/fs/ocfs2_dlm/<domain>/ctxt.
Look at /proc/fs/ocfs2_dlm/.../stat.

As in, dmesg is very clunky for this. Make the patch against ocfs2-1.2 
svn head.

Thanks
Sunil

wengang wang wrote:
> add dlm context printing support in dlm debugging
>
> - echo 'd' >/proc/fs/ocfs2_dlm/debug prints all dlm contexts.
> - echo 'D UUID' >/proc/fs/ocfs2_dlm/debug prints the context of the 
> specified dlm
>
> Signed-off-by: wengang wang <wen.gang.wang@oracle.com>
> Singed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
> dlmdebug.c |  104 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 104 insertions(+)
>
> --- ./fs/ocfs2/dlm/dlmdebug.c.orig    2008-01-09 06:39:18.000000000 -0500
> +++ ./fs/ocfs2/dlm/dlmdebug.c    2008-01-10 03:17:13.000000000 -0500
> @@ -61,6 +61,10 @@
> static int dlm_proc_stats(char *page, char **start, off_t off,
>               int count, int *eof, void *data);
>
> +static void __dlm_print_one_dlm_ctxt(struct dlm_ctxt *dlm);
> +static int dlm_dump_one_dlm_ctxt(const char __user *buf, unsigned int 
> count);
> +static int dlm_dump_all_dlm_ctxts(const char __user *buf, unsigned 
> int count);
> +
> typedef int (dlm_debug_func_t)(const char __user *data, unsigned int 
> len);
>
> struct dlm_debug_funcs
> @@ -75,6 +79,8 @@
>     { 'm', dlm_dump_all_mles },
>     { 'p', dlm_dump_all_purge_lists  },
>     { 'M', dlm_trigger_migration },
> +    { 'd', dlm_dump_all_dlm_ctxts },
> +    { 'D', dlm_dump_one_dlm_ctxt },
> };
> static int dlm_debug_map_sz = (sizeof(dlm_debug_map) /
>                    sizeof(struct dlm_debug_funcs));
> @@ -210,7 +216,105 @@
>     spin_unlock(&dlm_domain_lock);
>     return len;
> }
> +static void __dlm_print_one_dlm_ctxt(struct dlm_ctxt *dlm)
> +{
> +    mlog(ML_NOTICE, "purge_count: %d, name: %s\n",
> +        dlm->purge_count, dlm->name);
> +    mlog(ML_NOTICE, "node_num: %u, key: %u\n",
> +        dlm->node_num, dlm->key);
> +    mlog(ML_NOTICE, "joining_node: %u, reco->new_master: %u\n",
> +        dlm->joining_node, dlm->reco.new_master);
> +    mlog(ML_NOTICE, "reco->dead_node: %u, reco->state: %u\n",
> +        dlm->reco.dead_node, dlm->reco.state);
> +    mlog(ML_NOTICE, "dlm_state: %d, num_joins: %d\n",
> +        dlm->dlm_state, dlm->num_joins);
> +}
> +static int dlm_dump_all_dlm_ctxts(const char __user *data, unsigned 
> int len)
> +{
> +    struct dlm_ctxt *dlm;
> +    struct list_head *iter;
> +
> +    mlog(ML_NOTICE, "dumping ALL dlm contexts for node %s\n",
> +        system_utsname.nodename);
> +    spin_lock(&dlm_domain_lock);
> +    list_for_each(iter, &dlm_domains) {
> +        dlm = list_entry (iter, struct dlm_ctxt, list);
> +        spin_lock(&dlm->spinlock);
> +        __dlm_print_one_dlm_ctxt(dlm);
> +        spin_unlock(&dlm->spinlock);
> +    }
> +    spin_unlock(&dlm_domain_lock);
> +    return len;
> +}
> +static int dlm_dump_one_dlm_ctxt(const char __user *data, unsigned 
> int len)
> +{
> +    struct dlm_ctxt *dlm;
> +    char *buf = NULL, *tmp;
> +    int ret = -EINVAL;
> +
> +    mlog(ML_NOTICE, "dumping one dlm context for node %s\n",
> +        system_utsname.nodename);
> +
> +    if (len >= PAGE_SIZE-1) {
> +        mlog(ML_ERROR, "user passed too much data: %d bytes\n", len);
> +        goto leave;
> +    }
> +    if (len < 4) {
> +        mlog(ML_ERROR, "user passed too little data: %d bytes\n", len);
> +        goto leave;
> +    }
> +    buf = kmalloc(len+1, GFP_NOFS);
> +    if (!buf) {
> +        mlog(ML_ERROR, "could not alloc %d bytes\n", len+1);
> +        ret = -ENOMEM;
> +        goto leave;
> +    }
> +    if (strncpy_from_user(buf, data, len) < len) {
> +        mlog(ML_ERROR, "failed to get all user data\n");
> +        goto leave;
> +    }
> +    buf[len] = '\0';
> +    mlog(0, "got this data from user: %s\n", buf);
> +
> +    tmp = buf+1;
> +    if (*tmp != ' ') {
> +        mlog(ML_ERROR, "bad data\n");
> +        goto leave;
> +    }
> +    tmp ++;
> +
> +    while (*tmp != '\0') {
> +        if (*tmp == '\n' || *tmp == '\r') {
> +            *tmp = '\0';
> +            break;
> +        }
> +        tmp ++;
> +    }
>
> +    spin_lock(&dlm_domain_lock);
> +    dlm = __dlm_lookup_domain(buf+2);
> +    spin_unlock(&dlm_domain_lock);
> +    if (dlm) {
> +        if (!dlm_grab(dlm)) {
> +            mlog(ML_ERROR, "bad dlm!\n");
> +            goto leave;
> +        }
> +        spin_lock(&dlm_domain_lock);
> +        spin_lock(&dlm->spinlock);
> +        __dlm_print_one_dlm_ctxt(dlm);
> +        spin_unlock(&dlm->spinlock);
> +        spin_unlock(&dlm_domain_lock);
> +        dlm_put(dlm);
> +    } else {
> +        mlog(ML_ERROR, "no such dlm: %s(%lu)\n", buf+2, strlen(buf+2));
> +        goto leave;
> +    }
> +    ret = len;
> +leave:
> +    if (buf)
> +        kfree(buf);
> +    return ret;
> +}
> static int dlm_dump_one_lock_resource(const char __user *data,
>                        unsigned int len)
> {
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
