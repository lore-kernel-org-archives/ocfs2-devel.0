From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 30 Apr 2010 13:47:05 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: avoid direct write if we fall back
 to buffered v3
In-Reply-To: <201004171749.10674.lidongyang@novell.com>
References: <201004171749.10674.lidongyang@novell.com>
Message-ID: <20100430204705.GC1938@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Apr 17, 2010 at 05:49:10PM +0800, Li Dongyang wrote:
> when we fall back to buffered write from direct write, we call
> __generic_file_aio_write but that will end up doing direct write
> even we are only prepared to do buffered write because the file
> has O_DIRECT flag set. This is a fix for
> https://bugzilla.novell.com/show_bug.cgi?id=591039
> revised with Joel's comments.

	Have you tested this version?  I got a compile error:

> @@ -1999,7 +1999,10 @@ relock:
>  			goto out_dio;
>  		}
>  	} else {
> -		written = __generic_file_aio_write(iocb, iov, nr_segs, ppos);
> +		current->backing_dev_info = file->f_mapping->backing_dev_info;
> +		written = generic_file_buffered_write(iocb, iov, nr_segs, *ppos
> +						      ppos, count, 0);
> +		current->backing_dev_info = NULL;
>  	}

- 		written = generic_file_buffered_write(iocb, iov, nr_segs, *ppos
+ 		written = generic_file_buffered_write(iocb, iov, nr_segs, *ppos,

Joel

-- 

"I think it would be a good idea."  
        - Mahatma Ghandi, when asked what he thought of Western
          civilization

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
