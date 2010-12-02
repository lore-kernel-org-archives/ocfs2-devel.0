From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 1 Dec 2010 21:29:45 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Introduce ocfs2_recover_node
In-Reply-To: <AANLkTikcDcWTXPqPMKxySo9CDOKBfgqHxHcoXj0UO66B@mail.gmail.com>
References: <AANLkTikcDcWTXPqPMKxySo9CDOKBfgqHxHcoXj0UO66B@mail.gmail.com>
Message-ID: <20101202052945.GG16604@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 17, 2010 at 09:50:04AM -0600, Goldwyn Rodrigues wrote:
> @@ -1470,7 +1451,11 @@ void ocfs2_recovery_thread(struct ocfs2_super
> *osb, int node_num)
> 
>  	/* People waiting on recovery will wait on
>  	 * the recovery map to empty. */
> -	if (ocfs2_recovery_map_set(osb, node_num))
> +	ret = ocfs2_recovery_node_set(osb, node_num);
> +	if (ret == -ENOMEM) {
> +		mlog_errno(ret);
> +		goto out;
> +	} else if (ret)
>  		mlog(0, "node %d already in recovery map.\n", node_num);

	This is a broken change.  If we get -ENOMEM, we won't block
other processes.  We can't have that happen.  There are two possible
solutions.  First, like Sunil said, we can preallocate max_slots recovery
entries.  Seems pretty sane.  The other solution would be to set an
in-recovery flag that others can check, so even when the recovery list
is empty because of a failed allocation, other processes still block.  I
prefer the preallocation because it doesn't fail recovery.

Joel

-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
