From: Daniel Sobe <daniel.sobe@nxp.com>
Date: Tue, 7 May 2019 13:52:46 +0000
Subject: [Ocfs2-devel] [EXT] Re: [PATCH] fs/ocfs2: fix race in
	ocfs2_dentry_attach_lock
In-Reply-To: <42f392d4-4678-ec0f-751f-02a91d5746a4@oracle.com>
References: <20190503170102.14775-1-wen.gang.wang@oracle.com>
	<42f392d4-4678-ec0f-751f-02a91d5746a4@oracle.com>
Message-ID: <VI1PR04MB561473F3E4D67530CAE0AE26ED310@VI1PR04MB5614.eurprd04.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Wengang,

I have applied your patch to the latest debian kernel in "stretch-backports", and been using it for 1..2 days. Today is the first time that I saw the pr_err() message:

May 07 15:23:19 drs1p001 kernel: race found in ocfs2_dentry_attach_lock dentry=0000000016c2f15c

I don't know whether it helps, but I thought I'll report it anyway. I don't remember any special activity at that time, just the same stuff I was doing all day.

Regards,

Daniel

-----Original Message-----
From: Wengang Wang <wen.gang.wang@oracle.com> 
Sent: Freitag, 3. Mai 2019 19:03
To: 'ocfs2-devel at oss.oracle.com' <ocfs2-devel@oss.oracle.com>
Cc: Daniel Sobe <daniel.sobe@nxp.com>
Subject: [EXT] Re: [PATCH] fs/ocfs2: fix race in ocfs2_dentry_attach_lock

Caution: EXT Email

Daneil,

You could try this patch.
I didn't confirm yet if the patch helped or the problem didn't happen again where it happened (though I am sure the racing is there).

Anyone who is interested could take a pre-review on this patch.

Thanks,
Wengang

On 2019/5/3 10:01, Wengang Wang wrote:
> ocfs2_dentry_attach_lock() can be executed in parallel threads against 
> the same dentry. Make that race safe.
>
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>   fs/ocfs2/dcache.c | 27 +++++++++++++++++++++------
>   1 file changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c index 
> 290373024d9d..980e571c163c 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -227,12 +227,13 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>                            struct inode *inode,
>                            u64 parent_blkno)
>   {
> -     int ret;
> +     int ret, new_dl = 0;
>       struct dentry *alias;
> -     struct ocfs2_dentry_lock *dl = dentry->d_fsdata;
> +     struct ocfs2_dentry_lock *dl, *dl_free_on_race = NULL;
>
>       trace_ocfs2_dentry_attach_lock(dentry->d_name.len, dentry->d_name.name,
> -                                    (unsigned long long)parent_blkno, dl);
> +                                    (unsigned long long)parent_blkno,
> +                                    dentry->d_fsdata);
>
>       /*
>        * Negative dentry. We ignore these for now.
> @@ -243,11 +244,15 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>       if (!inode)
>               return 0;
>
> +     spin_lock(&dentry_attach_lock);
>       if (d_really_is_negative(dentry) && dentry->d_fsdata) {
>               /* Converting a negative dentry to positive
>                  Clear dentry->d_fsdata */
>               dentry->d_fsdata = dl = NULL;
> +     } else {
> +             dl = dentry->d_fsdata;
>       }
> +     spin_unlock(&dentry_attach_lock);
>
>       if (dl) {
>               mlog_bug_on_msg(dl->dl_parent_blkno != parent_blkno, @@ 
> -310,10 +315,20 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>
>   out_attach:
>       spin_lock(&dentry_attach_lock);
> -     dentry->d_fsdata = dl;
> -     dl->dl_count++;
> +     /* d_fsdata could be set by parallel thread */
> +     if (unlikely(dentry->d_fsdata)) {
> +             pr_err("race found in ocfs2_dentry_attach_lock dentry=%p\n", dentry);
> +             if (!alias)
> +                     dl_free_on_race = dl;
> +     } else {
> +             dentry->d_fsdata = dl;
> +             dl->dl_count++;
> +             if (!alias)
> +                     new_dl = 1;
> +     }
>       spin_unlock(&dentry_attach_lock);
>
> +     kfree(dl_free_on_race);
>       /*
>        * This actually gets us our PRMODE level lock. From now on,
>        * we'll have a notification if one of these names is @@ -330,7 
> +345,7 @@ int ocfs2_dentry_attach_lock(struct dentry *dentry,
>        * We need to do this because error here means no d_instantiate(),
>        * which means iput() will not be called during dput(dentry).
>        */
> -     if (ret < 0 && !alias) {
> +     if (ret < 0 && new_dl) {
>               ocfs2_lock_res_free(&dl->dl_lockres);
>               BUG_ON(dl->dl_count != 1);
>               spin_lock(&dentry_attach_lock);
