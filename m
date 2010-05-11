From: tristan <tristan.ye@oracle.com>
Date: Tue, 11 May 2010 10:12:00 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <20100510200101.GC2836@mail.oracle.com>
References: <1273135408-18512-1-git-send-email-tristan.ye@oracle.com>
	<20100510200101.GC2836@mail.oracle.com>
Message-ID: <4BE8BCF0.8040104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, May 06, 2010 at 04:43:28PM +0800, Tristan Ye wrote:
>> Currently, following 8 ioctls get implemented per the requirement from
>> userspace tool o2info, and I believe it will grow over time:-)
>
> 	"Currently, the following 8 requests are supported ..."
>> +int ocfs2_info_handle_blocksize(struct inode *inode,
>> +				struct ocfs2_info_request __user *req)
>> +{
>> +	int status = -EFAULT;
>> +	struct ocfs2_info_blocksize oib;
>> +
>> +	if (o2info_from_user(oib, req))
>> +		goto bail;
>> +
>> +	oib.ib_blocksize = inode->i_sb->s_blocksize;
>> +	oib.ib_req.ir_flags |= OCFS2_INFO_FL_FILLED;
>> +
>> +	if (o2info_to_user(oib, req))
>> +		goto bail;
>> +
>> +	status = 0;
>> +bail:
>> +	if (status)
>> +		oib.ib_req.ir_flags |= OCFS2_INFO_FL_ERROR;
>> +
>> +	return status;
>> +}
>
> 	You need to send that FL_ERROR to userspace.  Setting it on
> ir_flags doesn't show up in userspace unless you copy it over.  I
> realize that you've already failed the copy to user, but you need to
> retry it and ignore the error code.  Like so:
>
> ---------------------------------------------
> /*
>  * This call is void because we are already reporting an error that may
>  * be -EFAULT.  The error will be returned from the ioctl(2) call.  It's
>  * just a best-effort to tell userspace that this request caused the error.
>  */
> static inline void __o2info_error_to_user(struct ocfs2_info_request *kreq,
> 					  struct ocfs2_info_request __user *req)
> {
> 	kreq->ir_flags |= OCFS2_INFO_FL_ERROR;
> 	(void)o2info_to_user(kreq, req);

Joel,


I thought we'd better not pass the whole ocfs2_info_request body this 
time, but passing only ir_flags instead.

kreq->ir_flags |= OCFS2_INFO_FL_ERROR;

put_user(kreq->ir_flags, (__u32 user *)&(req->ir_flags));

There may be two reasons:

1. copy_to_user(kreq, req) is an overkill when compared to 
put_user(kflags, flags).


2. we're more likely to hit -EFAULT again when passing the whole request 
body, sending ir_flags ONLY to userpace reduce such risk.


Another corner:

How about if we hit -EFAULT again when sending the FL_ERROR to 
userpsace? actually I guess it's quite likely to happen since we've had 
already failed to pass the request body last time.


Tristan.

> }
>
> #define o2info_error_to_user(a, b) \
>              __o2info_error_to_user((struct ocfs2_info_request *)&(a), &(b))
> ---------------------------------------------
>
> 	Now all of the handling functions can say:
>
> bail:
> 	if (status)
> 		o2info_error_to_user(oib, req);
>
>
>> +/*
>> + * OCFS2_IOC_INFO handles an array of requests passed from userspace.
>> + *
>> + * ocfs2_info_handle() recevies a large info aggregation, grab and
>> + * validate the request count from header, then break it into small
>> + * pieces, later specific handlers can handle them one by one.
>> + *
>> + * Idea here is to make each separate request small enough to ensure
>> + * a better backward&forward compatibility, since a small piece of
>> + * request will be less likely to be broken if disk layout get changed.
>> + */
>> +int ocfs2_info_handle(struct inode *inode, struct ocfs2_info *info,
>> +		      int compat_flag)
>> +{
>> +	int i, status = 0;
>> +	u64 req_addr;
>> +	struct ocfs2_info_request __user *reqp;
>> +
>> +	if ((info->oi_count > OCFS2_INFO_MAX_REQUEST) ||
>> +	    (!info->oi_requests)) {
>> +		status = -EINVAL;
>> +		goto bail;
>> +	}
>> +
>> +	for (i = 0; i < info->oi_count; i++) {
>> +		status = -EFAULT;
>> +		if (compat_flag) {
>> +			if (get_user(req_addr,
>> +			     (u64 __user *)compat_ptr(info->oi_requests) + i))
>> +				goto bail;
>> +		} else {
>> +			if (get_user(req_addr,
>> +				     (u64 __user *)(info->oi_requests) + i))
>> +				goto bail;
>> +		}
>> +
>> +		reqp = (struct ocfs2_info_request *)req_addr;
>> +		if (!reqp) {
>> +			status = -EINVAL;
>> +			goto bail;
>> +		}
>> +
>> +		status = ocfs2_info_handle_request(inode, reqp);
>> +		if (status)
>> +			goto bail;
>> +	}
>
> 	There is no need to 'goto bail' in the for loop.  Just 'break'.
>> +
>> +bail:
>> +	return status;
>> +}
>> +
>
> Joel
>
