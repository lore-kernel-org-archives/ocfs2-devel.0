From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Jul 2009 14:54:24 -0700
Subject: [Ocfs2-devel] [PATCH 1/6] ocfs2: Make global quota files
	blocksize aligned
In-Reply-To: <1247673304-31080-2-git-send-email-jack@suse.cz>
References: <1247673304-31080-1-git-send-email-jack@suse.cz>
	<1247673304-31080-2-git-send-email-jack@suse.cz>
Message-ID: <20090721215424.GE19170@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 15, 2009 at 05:54:59PM +0200, Jan Kara wrote:
> Change i_size of global quota files so that it always remains aligned to block
> size. This is mainly because the end of quota block may contain checksum (if
> checksumming is enabled) and it's a bit awkward for it to be "outside" of quota
> file (and it makes life harder for ocfs2-tools).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/quota_global.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
> index edfa60c..5a4ae61 100644
> --- a/fs/ocfs2/quota_global.c
> +++ b/fs/ocfs2/quota_global.c
> @@ -211,14 +211,16 @@ ssize_t ocfs2_quota_write(struct super_block *sb, int type,
>  
>  	mutex_lock_nested(&gqinode->i_mutex, I_MUTEX_QUOTA);
>  	if (gqinode->i_size < off + len) {
> +		loff_t rounded_end = ALIGN(off + len, sb->s_blocksize);

	We have ocfs2_align_bytes_to_blocks() for this.

Joel

-- 

"Conservative, n.  A statesman who is enamoured of existing evils,
 as distinguished from the Liberal, who wishes to replace them
 with others."
	- Ambrose Bierce, The Devil's Dictionary

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
