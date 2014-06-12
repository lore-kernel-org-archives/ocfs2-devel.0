From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 12 Jun 2014 15:52:14 -0700
Subject: [Ocfs2-devel] [patch 1/8] ocfs2: should add inode into orphan
	dir after	updating entry in ocfs2_rename()
In-Reply-To: <20140609200400.1AB405A4A6F@corp2gmr1-2.hot.corp.google.com>
References: <20140609200400.1AB405A4A6F@corp2gmr1-2.hot.corp.google.com>
Message-ID: <20140612225214.GA5484@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 09, 2014 at 01:03:59PM -0700, Andrew Morton wrote:
> From: alex chen <alex.chen@huawei.com>
> Subject: ocfs2: should add inode into orphan dir after updating entry in ocfs2_rename()
> 
> There are two files a and b in dir /mnt/ocfs2.
>     node A                           node B
> mv a b
> In ocfs2_rename(), after calling
> ocfs2_orphan_add(), the inode of
> file b will be added into orphan
> dir.
> 
> If ocfs2_update_entry() fails,
> ocfs2_rename return error and mv
> operation fails. But file b still
> exists in the parent dir.
> 
> ocfs2_queue_orphan_scan
> -> ocfs2_queue_recovery_completion
> -> ocfs2_complete_recovery
> -> ocfs2_recover_orphans
> The inode of the file b will be
> put with iput().
> 
> ocfs2_evict_inode
> -> ocfs2_delete_inode
> -> ocfs2_wipe_inode
> -> ocfs2_remove_inode
> OCFS2_VALID_FL in the inode
> i_flags will be cleared.
> 
>                                    The file b still can be accessed
>                                    on node B.
>                                    ls /mnt/ocfs2
>                                    When first read the file b with
>                                    ocfs2_read_inode_block(). It will
>                                    validate the inode using
>                                    ocfs2_validate_inode_block().
>                                    Because OCFS2_VALID_FL not set in
>                                    the inode i_flags, so the file
>                                    system will be readonly.
> 
> So we should add inode into orphan dir after updating entry in
> ocfs2_rename().

That looks fine. I guess the downside now is that if we fail during orphan
add we could leak the file which would have been otherwise replaced. In my
opinion though this is much better than going readonly because we have a
link to a dead file.


Thanks for this Alex,
	--Mark

--
Mark Fasheh
