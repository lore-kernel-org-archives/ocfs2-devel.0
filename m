From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 3 Nov 2010 18:18:41 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <1288782126-13007-1-git-send-email-tristan.ye@oracle.com>
References: <1288782126-13007-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20101104011839.GA14640@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 03, 2010 at 07:02:05PM +0800, Tristan Ye wrote:
> The new code is dedicated to calculate free inodes number of all inode_allocs,
> then return the info to userpace in terms of an array.
> 
> Specially, flag 'OCFS2_INFO_FL_NON_COHERENT', manipulated by '--cluster-coherent'
> from userspace, is now going to be involved. setting the flag on means no cluster
> coherency considered, usually, userspace tools choose none-coherency strategy by
> default for the sake of performace.

	This looks pretty straightforward.  Note that any non-cached
allocator is going to lock, regardless of the coherency flag.  Do we
want to use ocfs2_ilookup() instead?

> +int ocfs2_info_scan_inode_alloc(struct inode *inode_alloc,
> +				struct ocfs2_info_freeinode *fi, __u32 slot)
> +{
> +	int status = 0, unlock = 0;
> +
> +	struct buffer_head *bh = NULL;
> +	struct ocfs2_dinode *dinode_alloc = NULL;
> +
> +	mutex_lock(&inode_alloc->i_mutex);
> +
> +	if (!(fi->ifi_req.ir_flags & OCFS2_INFO_FL_NON_COHERENT)) {

	Also, I'm thinking that this would look much better as:

	if (!ocfs2_info_coherent(&fi->ifi_req)) {

That implies we probably also want ocfs2_info_set_filled(request), etc.
Good, bad?

Joel

-- 

The Graham Corollary:

	The longer a socially-moderated news website exists, the
	probability of an old Paul Graham link appearing at the top
	approaches certainty.

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
