From: Matthew Wilcox <matthew@wil.cx>
Date: Sat, 06 Apr 2013 13:20:36 -0000
Subject: [Ocfs2-devel] [PATCH 3/4] fsfreeze: manage kill signal
	when	sb_start_pagefault is called
In-Reply-To: <515FF380.5020406@gmail.com>
References: <515FF380.5020406@gmail.com>
Message-ID: <20130406132028.GD28744@parisc-linux.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk.kim@samsung.com>, Steven Whitehouse <swhiteho@redhat.com>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, Jan Kara <jack@suse.cz>

On Sat, Apr 06, 2013 at 12:05:52PM +0200, Marco Stornelli wrote:
> In every place where sb_start_pagefault was called now we must manage
> the error code and return VM_FAULT_RETRY.

Erm ... in patch 1/4:

 static inline void sb_start_pagefault(struct super_block *sb)
 {
-       __sb_start_write(sb, SB_FREEZE_PAGEFAULT, true);
+       __sb_start_write_wait(sb, SB_FREEZE_PAGEFAULT, false);
 }

>  
> -	sb_start_pagefault(inode->i_sb);
> +	ret = sb_start_pagefault(inode->i_sb);
> +	if (ret)
> +		return VM_FAULT_RETRY;
>  	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);

Does the compiler not warn that you're assigning void to 'ret'?  Or was
there some other SNAFU sending these patches?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
