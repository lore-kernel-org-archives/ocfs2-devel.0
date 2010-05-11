From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 10 May 2010 23:51:06 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <4BE8BCF0.8040104@oracle.com>
References: <1273135408-18512-1-git-send-email-tristan.ye@oracle.com>
	<20100510200101.GC2836@mail.oracle.com>
	<4BE8BCF0.8040104@oracle.com>
Message-ID: <20100511065106.GA16757@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 11, 2010 at 10:12:00AM +0800, tristan wrote:
> Joel Becker wrote:
> > static inline void __o2info_error_to_user(struct ocfs2_info_request *kreq,
> > 					  struct ocfs2_info_request __user *req)
> > {
> > 	kreq->ir_flags |= OCFS2_INFO_FL_ERROR;
> > 	(void)o2info_to_user(kreq, req);
> 
> I thought we'd better not pass the whole ocfs2_info_request body this 
> time, but passing only ir_flags instead.
> 
> kreq->ir_flags |= OCFS2_INFO_FL_ERROR;
> 
> put_user(kreq->ir_flags, (__u32 user *)&(req->ir_flags));

	Yep, this is better.  As you say, the full copy is overkill.

> Another corner:
> 
> How about if we hit -EFAULT again when sending the FL_ERROR to 
> userpsace? actually I guess it's quite likely to happen since we've had 
> already failed to pass the request body last time.

	I expect we might.  We just ignore that error.  The user is
still going to get the error code back via the return code of ioctl().
Essentially it's just a best effort.  If we got -EFAULT on the entire
copy, maybe the put_user() works, maybe it doesn't.  Gives the user a
chance to check.
Joel

-- 

"We will have to repent in this generation not merely for the
 vitriolic words and actions of the bad people, but for the 
 appalling silence of the good people."
	- Rev. Dr. Martin Luther King, Jr.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
