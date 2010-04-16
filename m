From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 16 Apr 2010 03:07:36 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
 to buffered v2
In-Reply-To: <201004152101.56289.lidongyang@novell.com>
References: <201004152101.56289.lidongyang@novell.com>
Message-ID: <20100416100735.GA25091@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 15, 2010 at 09:01:56PM +0800, Li Dongyang wrote:
> -	if (direct_io) {
> -		ret = generic_segment_checks(iov, &nr_segs, &ocount,
> -					     VERIFY_READ);
> -		if (ret)
> -			goto out_dio;
> +	ret = generic_segment_checks(iov, &nr_segs, &ocount,
> +				     VERIFY_READ);
> +	if (ret)
> +		goto out_dio;
>  
> -		count = ocount;
> -		ret = generic_write_checks(file, ppos, &count,
> -					   S_ISBLK(inode->i_mode));
> -		if (ret)
> -			goto out_dio;
> +	count = ocount;
> +	ret = generic_write_checks(file, ppos, &count,
> +				   S_ISBLK(inode->i_mode));
> +	if (ret)
> +		goto out_dio;

	Make sure you add the management of current->backing_dev_info
just like __generic_file_aio_write() does.  We want to ensure that page
writeback works OK.

Joel

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
