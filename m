From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 11 May 2010 13:40:35 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <1273562509-27167-2-git-send-email-tristan.ye@oracle.com>
References: <1273562509-27167-1-git-send-email-tristan.ye@oracle.com>
	<1273562509-27167-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100511204035.GB10423@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 11, 2010 at 03:21:49PM +0800, Tristan Ye wrote:
> +/*
> + * This call is void because we are already reporting an error that may
> + * be -EFAULT.  The error will be returned from the ioctl(2) call.  It's
> + * just a best-effort to tell userspace that this request caused the error.
> + */
> +static inline void __o2info_error_to_user(struct ocfs2_info_request *kreq,
> +					  struct ocfs2_info_request __user *req)
> +{
> +	kreq->ir_flags |= OCFS2_INFO_FL_ERROR;
> +	(void)put_user(kreq->ir_flags, (__u32 __user *)&(req->ir_flags));
> +}
> +
> +#define o2info_error_to_user(a, b) \
> +		__o2info_error_to_user((struct ocfs2_info_request *)&(a), b)

	Hmm, since we're not actually passing the error up, perhaps it
should be called "[__]o2info_set_request_error(a, b)".

Joel

-- 

"The cynics are right nine times out of ten."  
        - H. L. Mencken

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
