From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Oct 2008 10:22:02 -0700
Subject: [Ocfs2-devel] [PATCH] quota: Add callbacks for allocating
	and	destroying dquot structures
In-Reply-To: <12245234403083-git-send-email-jack@suse.cz>
References: <12245234403083-git-send-email-jack@suse.cz>
Message-ID: <20081021172201.GA10060@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 20, 2008 at 07:23:34PM +0200, Jan Kara wrote:
> Some filesystems would like to keep private information together with each
> dquot. Add callbacks alloc_dquot and destroy_dquot allowing filesystem to
> allocate larger dquots from their private slab in a similar fashion we
> currently allocate inodes.

...

> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -294,6 +294,8 @@ struct dquot_operations {
>  	int (*free_inode) (const struct inode *, unsigned long);
>  	int (*transfer) (struct inode *, struct iattr *);
>  	int (*write_dquot) (struct dquot *);		/* Ordinary dquot write */
> +	struct dquot *(*alloc_dquot)(struct super_block *, int);	/* Allocate memory for new dquot (can be NULL if no special entries dquot are needed) */
> +	void (*destroy_dquot)(struct dquot *);		/* Free memory for dquot */

	Probably want to mention that ->destroy_dquot() is optional and
really matches ->alloc_dquot().

Joel

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
