From: Xue jiufei <xuejiufei@huawei.com>
Date: Wed, 3 Dec 2014 16:20:20 +0800
Subject: [Ocfs2-devel] [PATCH] Remove filesize checks for sync I/O
 journal commit
In-Reply-To: <20141104155222.GA5746@shrek.lan>
References: <20141104155222.GA5746@shrek.lan>
Message-ID: <547EC7C4.1030102@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn,
On 2014/11/4 23:52, Goldwyn Rodrigues wrote:
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
I have a question that if user open the file with O_SYNC,
it will call filemap_fdatawait_range() after generic_perform_write()
to wait until data reaches the disk, why another node may read the
stale data?

Thanks,
Xuejiufei

> --- 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 324dc93..69fb9f7 100644
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
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
