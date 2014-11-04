From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 4 Nov 2014 14:45:33 -0800
Subject: [Ocfs2-devel] [PATCH] Remove filesize checks for sync I/O
 journal commit
In-Reply-To: <20141104155222.GA5746@shrek.lan>
References: <20141104155222.GA5746@shrek.lan>
Message-ID: <20141104144533.a05c6dd5d3db3b5274d4e36c@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 4 Nov 2014 09:52:22 -0600 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

> Filesize is not a good indication that the file needs to be synced.
> An example where this breaks is:
>  1. Open the file in O_SYNC|O_RDWR
>  2. Read a small portion of the file (say 64 bytes)
>  3. Lseek to starting of the file
>  4. Write 64 bytes
> 
> If the node crashes, it is not written out to disk because this
> was not committed in the journal and the other node which reads
> the file after recovery reads stale data (even if the write on
> the other node was successful)
> 
> ...
>
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -2381,9 +2381,7 @@ out_dio:
>  		if (ret < 0)
>  			written = ret;
>  
> -		if (!ret && ((old_size != i_size_read(inode)) ||
> -			     (old_clusters != OCFS2_I(inode)->ip_clusters) ||
> -			     has_refcount)) {
> +		if (!ret) {
>  			ret = jbd2_journal_force_commit(osb->journal->j_journal);
>  			if (ret < 0)
>  				written = ret;

Can we have a signed-off-by for this, please?
