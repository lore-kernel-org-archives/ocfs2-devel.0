From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 14 Oct 2018 10:41:08 -0700
Subject: [Ocfs2-devel] [PATCH 22/25] ocfs2: support partial clone range
	and dedupe range
In-Reply-To: <153938929813.8361.16702022670128567518.stgit@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
	<153938929813.8361.16702022670128567518.stgit@magnolia>
Message-ID: <20181014174108.GB6400@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

> @@ -2531,14 +2531,11 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
>  				     struct file *file_out, loff_t pos_out,
>  				     loff_t len, unsigned int remap_flags)
>  {
> -	int ret;
> -
>  	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
>  		return -EINVAL;
>  
> -	ret = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> -					len, remap_flags);
> -	return ret < 0 ? ret : len;
> +	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> +			len, remap_flags);

Seems like ocfs2_remap_file_range and ocfs2_reflink_remap_range should
be merged now.
