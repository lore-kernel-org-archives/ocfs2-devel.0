From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Tue, 29 May 2012 15:09:08 -0700
Subject: [Ocfs2-devel] [PATCH] Fix waiting status race condition in dlm
	recovery
In-Reply-To: <1337925202-13086-1-git-send-email-xiaowei.hu@oracle.com>
References: <1337925202-13086-1-git-send-email-xiaowei.hu@oracle.com>
Message-ID: <CAEeiSHXcaKXi7Qm5vLBmTp2CjiB7DCrUee5qmr03YpuJbzP5yg@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 24, 2012 at 10:53 PM, <xiaowei.hu@oracle.com> wrote:

>
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 01ebfd0..62659e8 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -555,6 +555,7 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8
> dead_node)
>        int all_nodes_done;
>        int destroy = 0;
>        int pass = 0;
> +       int dying = 0;
>
>        do {
>                /* we have become recovery master.  there is no escaping
> @@ -659,6 +660,7 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm, u8
> dead_node)
>                list_for_each_entry(ndata, &dlm->reco.node_data, list) {
>                        mlog(0, "checking recovery state of node %u\n",
>                             ndata->node_num);
> +                       dying = 0;
>                        switch (ndata->state) {
>                                case DLM_RECO_NODE_DATA_INIT:
>                                case DLM_RECO_NODE_DATA_REQUESTING:
> @@ -679,6 +681,13 @@ static int dlm_remaster_locks(struct dlm_ctxt *dlm,
> u8 dead_node)
>                                             dlm->name, ndata->node_num,
>
> ndata->state==DLM_RECO_NODE_DATA_RECEIVING ?
>                                             "receiving" : "requested");
> +                                       spin_lock(&dlm->spinlock);
> +                                       dying = !test_bit(ndata->node_num,
> dlm->live_nodes_map);
> +                                       spin_unlock(&dlm->spinlock);
> +                                       if (dying) {
> +                                               ndata->state =
> DLM_RECO_NODE_DATA_DEAD;
> +                                               break;
> +                                       }
>




I would suggest exploring adding this in dlm hb down event. Checking live
map all
over the place is hacky. We do it more than we should right now. Let's not
add to the
mess.





>                                        all_nodes_done = 0;
>                                        break;
>                                case DLM_RECO_NODE_DATA_DONE:
> --
> 1.7.7.6
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120529/1080a567/attachment.html 
