From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 10 Sep 2010 09:10:20 -0700
Subject: [Ocfs2-devel] [PATCH v3] ocfs2: Cache system inodes of other
	slots.
In-Reply-To: <1281949101-4801-1-git-send-email-tao.ma@oracle.com>
References: <1281949101-4801-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100910161020.GA17223@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 16, 2010 at 04:58:21PM +0800, Tao Ma wrote:
> Durring orphan scan, if we are slot 0, and we are replaying
> orphan_dir:0001, the general process is that for every file
> in this dir:
> 1. we will iget orphan_dir:0001, since there is no inode for it.
>    we will have to create an inode and read it from the disk.
> 2. do the normal work, such as delete_inode and remove it from
>    the dir if it is allowed.
> 3. call iput orphan_dir:0001 when we are done. In this case,
>    since we have no dcache for this inode, i_count will
>    reach 0, and VFS will have to call clear_inode and in
>    ocfs2_clear_inode we will checkpoint the inode which will let
>    ocfs2_cmt and journald begin to work.
> 4. We loop back to 1 for the next file.
> 
> So you see, actually for every deleted file, we have to read the
> orphan dir from the disk and checkpoint the journal. It is very
> time consuming and cause a lot of journal checkpoint I/O.
> A better solution is that we can have another reference for these
> inodes in ocfs2_super. So if there is no other race among
> nodes(which will let dlmglue to checkpoint the inode), for step 3,
> clear_inode won't be called and for step 1, we may only need to
> read the inode for the 1st time. This is a big win for us.
> 
> So this patch will try to cache system inodes of other slots so
> that we will have one more reference for these inodes and avoid
> the extra inode read and journal checkpoint.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

"When ideas fail, words come in very handy." 
         - Goethe

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
