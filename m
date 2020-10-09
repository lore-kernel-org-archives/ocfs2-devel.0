From: Theodore Y. Ts'o <tytso@mit.edu>
Date: Thu, 8 Oct 2020 22:08:00 -0400
Subject: [Ocfs2-devel] [PATCH v5 2/4] jbd2, ext4,
 ocfs2: introduce/use journal callbacks
 j_submit|finish_inode_data_buffers()
In-Reply-To: <20201006004841.600488-3-mfo@canonical.com>
References: <20201006004841.600488-1-mfo@canonical.com>
	<20201006004841.600488-3-mfo@canonical.com>
Message-ID: <20201009020800.GF235506@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauricio Faria de Oliveira <mfo@canonical.com>
Cc: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>, dann frazier <dann.frazier@canonical.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

On Mon, Oct 05, 2020 at 09:48:39PM -0300, Mauricio Faria de Oliveira wrote:
> Introduce journal callbacks to allow different behaviors
> for an inode in journal_submit|finish_inode_data_buffers().
> 
> The existing users of the current behavior (ext4, ocfs2)
> are adapted to use the previously exported functions
> that implement the current behavior.
> 
> Users are callers of jbd2_journal_inode_ranged_write|wait(),
> which adds the inode to the transaction's inode list with
> the JI_WRITE|WAIT_DATA flags. Only ext4 and ocfs2 in-tree.
> 
> Both CONFIG_EXT4_FS and CONFIG_OCSFS2_FS select CONFIG_JBD2,
> which builds fs/jbd2/commit.c and journal.c that define and
> export the functions, so we can call directly in ext4/ocfs2.
> 
> Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
