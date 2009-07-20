From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 20 Jul 2009 12:08:46 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: flush dentry lock drop when sync
	ocfs2 volume.
In-Reply-To: <20090720123401.GA15341@duck.suse.cz>
References: <1248080922-24908-1-git-send-email-tao.ma@oracle.com>
	<20090720123401.GA15341@duck.suse.cz>
Message-ID: <20090720190846.GA7768@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 20, 2009 at 02:34:01PM +0200, Jan Kara wrote:
> +void ocfs2_drop_dl_inodes(struct work_struct *work)
> +{
> +	struct ocfs2_super *osb = container_of(work, struct ocfs2_super,
> +					       dentry_lock_work);
> +
> +	__ocfs2_drop_dl_inodes(osb, DL_INODE_DROP_COUNT);
> +	/*
> +	 * Don't queue dropping if umount is in progress. We flush the
> +	 * list in ocfs2_dismount_volume
> +	 */
> +	spin_lock(&dentry_list_lock);
> +	if (osb->dentry_lock_list &&
> +	    !ocfs2_test_osb_flag(osb, OCFS2_OSB_UMOUNT))
>  		queue_work(ocfs2_wq, &osb->dentry_lock_work);
>  	spin_unlock(&dentry_list_lock);
>  }

	The approach is good, but boy, I wish we could use vol_state
instead of a flag.  We are now tracking the mount/umount state in how
many places?

Joel

-- 

Life's Little Instruction Book #456

	"Send your loved one flowers.  Think of a reason later."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
