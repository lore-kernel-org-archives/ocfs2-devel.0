From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 31 Dec 2009 12:13:13 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add new OCFS2_INFO_IOC ioctls
 for ocfs2 v4.
In-Reply-To: <1262247524-26824-2-git-send-email-tristan.ye@oracle.com>
References: <1262247524-26824-1-git-send-email-tristan.ye@oracle.com>
	<1262247524-26824-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20091231201313.GC3301@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 31, 2009 at 04:18:44PM +0800, Tristan Ye wrote:
> +int ocfs2_info_handle_unknown(struct inode *inode,
> +			      struct ocfs2_info_request __user *user_req)
> +{
> +	int status = 0;
> +	struct ocfs2_info_request req;
> +
> +	if (copy_from_user(&req, user_req, sizeof(struct ocfs2_info_request))) {
> +		status = -EFAULT;
> +		goto bail;
> +	}
> +
> +	req.ir_flags &= ~OCFS2_INFO_FL_FILLED;
> +
> +	if (copy_to_user((struct ocfs2_info_request __user *)user_req, &req,
> +			 sizeof(struct ocfs2_info_request))) {

	Don't need the cast of user_req here.  It's already of the
correct type.

Joel

-- 

"When ideas fail, words come in very handy." 
         - Goethe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
