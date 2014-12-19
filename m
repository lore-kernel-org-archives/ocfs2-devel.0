From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 19 Dec 2014 12:49:25 -0800
Subject: [Ocfs2-devel] [patch 10/15] ocfs2: add orphan recovery types	in
	ocfs2_recover_orphans
In-Reply-To: <548f65e5.W2X7pIDuU7pvqzIH%akpm@linux-foundation.org>
References: <548f65e5.W2X7pIDuU7pvqzIH%akpm@linux-foundation.org>
Message-ID: <20141219204925.GZ7238@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Dec 15, 2014 at 02:51:17PM -0800, Andrew Morton wrote:
> From: Joseph Qi <joseph.qi@huawei.com>
> Subject: ocfs2: add orphan recovery types in ocfs2_recover_orphans
> 
> Define two orphan recovery types, which indicates if need truncate file or
> not.
> 
> Originally, only deleted inode will be add to orphan dir.  We use orphan
> dir to temporary store the file in append O_DIRECT write to ensure the
> block allocation and inode size updating in the same handle once the
> append O_DIRECT fails.  So now there may be not truly deleted files in
> orphan dir.

Most of this looks good btw, just a minor comment below.


> @@ -1902,7 +1917,7 @@ void ocfs2_queue_orphan_scan(struct ocfs
>  
>  	for (i = 0; i < osb->max_slots; i++)
>  		ocfs2_queue_recovery_completion(osb->journal, i, NULL, NULL,
> -						NULL);
> +						NULL, ORPHAN_NO_NEED_TRUNCATE);
>  	/*
>  	 * We queued a recovery on orphan slots, increment the sequence
>  	 * number and update LVB so other node will skip the scan for a while
> @@ -2090,6 +2105,39 @@ static void ocfs2_clear_recovering_orpha
>  	ocfs2_node_map_clear_bit(osb, &osb->osb_recovering_orphan_dirs, slot);
>  }
>  
> +static int ocfs2_truncate_file_locked(struct inode *inode)

Call this "ocfs2_truncate_file" please, we use the _locked for when it's
expected you enter the functino with the object already locked.
	--Mark

--
Mark Fasheh
