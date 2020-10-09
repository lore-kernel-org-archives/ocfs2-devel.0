From: Theodore Y. Ts'o <tytso@mit.edu>
Date: Thu, 8 Oct 2020 22:05:25 -0400
Subject: [Ocfs2-devel] [PATCH v5 1/4] jbd2: introduce/export functions
 jbd2_journal_submit|finish_inode_data_buffers()
In-Reply-To: <20201006004841.600488-2-mfo@canonical.com>
References: <20201006004841.600488-1-mfo@canonical.com>
	<20201006004841.600488-2-mfo@canonical.com>
Message-ID: <20201009020525.GE235506@mit.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauricio Faria de Oliveira <mfo@canonical.com>
Cc: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>, dann frazier <dann.frazier@canonical.com>, Joseph Qi <joseph.qi@linux.alibaba.com>

On Mon, Oct 05, 2020 at 09:48:38PM -0300, Mauricio Faria de Oliveira wrote:
> Export functions that implement the current behavior done
> for an inode in journal_submit|finish_inode_data_buffers().
> 
> No functional change.
> 
> Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
