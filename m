From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 22 Jun 2010 17:49:38 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
Message-ID: <20100623004937.GB20090@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 22, 2010 at 05:11:50PM -0700, Patrick J. LoPresti wrote:
> The simplest approach is just to delete the check, like so:
> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> index 0eaa929..0ba41f3 100644
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2215,14 +2215,6 @@ static int ocfs2_initialize_super(struct super_block *sb,
>                 goto bail;
>         }
> 
> -       if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
> -           > (u32)~0UL) {
> -               mlog(ML_ERROR, "Volume might try to write to blocks beyond "
> -                    "what jbd can address in 32 bits.\n");
> -               status = -EINVAL;
> -               goto bail;
> -       }
> -
>         if (ocfs2_setup_osb_uuid(osb, di->id2.i_super.s_uuid,
>                                  sizeof(di->id2.i_super.s_uuid))) {
>                 mlog(ML_ERROR, "Out of memory trying to setup our uuid.\n");
> 
> 
> Questions for the list:
> 
> 1) Is this patch sufficient?  Or should I try to modify the check to
> take into account the cluster size?  Anything else I need to check
> here (e.g. inode64 mount option)?

	This patch is not sufficient.  The journal options need to be
checked, as does the block addressing space of the kernel.

Joel

-- 

"Gone to plant a weeping willow
 On the bank's green edge it will roll, roll, roll.
 Sing a lulaby beside the waters.
 Lovers come and go, the river roll, roll, rolls."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
