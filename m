From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Dec 2009 10:28:14 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Implement new OCFS2_IOC_INFO
 ioctl for ocfs2.
In-Reply-To: <4B15D108.6080909@oracle.com>
References: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>
	<1259310276-7782-2-git-send-email-tristan.ye@oracle.com>
	<4B145A07.3070107@oracle.com> <4B148B79.4090100@oracle.com>
	<20091202003549.GB5269@mail.oracle.com>
	<4B15D108.6080909@oracle.com>
Message-ID: <20091202182813.GA3342@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 02, 2009 at 10:29:28AM +0800, Tristan wrote:
> Joel Becker wrote:
> > struct ocfs2_info_request {
> > /*00*/	__u32 ir_magic;	/* Magic number */
> >   
> 
> Why we need a magic here, just to improve the security?

	Not for security - a malicious user can always fake the magic.
We need to solve security anyway.  The magic number is for convenience.
It catches stupid errors quickly.

> > ---------------------------------------------------------------------------
> > get_info(fd)
> > {
> > 	struct ocfs2_info_request_clustersize crq = {
> > 		.ir_magic = OCFS2_INFO_MAGIC,
> > 		.ir_code = OCFS2_INFO_REQUEST_CLUSTERSIZE,
> > 		.ir_size = sizeof(struct ocfs2Info_request_clustersize),
> > 	};
> > 	struct ocfs2_info_request_blocksize brq = {
> > 		.ir_magic = OCFS2_INFO_MAGIC,
> > 		.ir_code = OCFS2_INFO_REQUEST_BLOCKSIZE,
> > 		.ir_size = sizeof(struct ocfs2Info_request_blocksize),
> > 	};
> > 	uint64_t info_array[2] = {(unsigned long)&crq, (unsigned long)&brq};
> > 	struct ocfs2_info info = {
> > 		.info_requests = info_array,
> > 		.info_count = 2,
> > 	};
> > 	
> > 	rc = ioctl(fd, OCFS2_IOC_INFO, &info);
> > 	...
> > }
> > ---------------------------------------------------------------------------
> >
> > 	o2info can create convenience wrappers for setting the magic
> > number, code, and size, of course.  Note that we cast the request
> > pointers to unsigned longs so that the promotion from ulong to uint64_t
> > is handled by C.  This code works on 32bit and 64bit.
> >   
> 
> Just a confusion here, uint64_t should be 'unsigned long long' on 32bits 
> arch, and 'unsigned long' on 64bits arch, why we not use:
> 
> 
> uint64_t info_array[2] = {(unsigned long long)&crq, (unsigned long long)&brq};

	We're casting pointers.  A pointer is always the size of an
unsigned long.  By casting the pointers to unsigned long, we change them
from pointer types to integer types.  On 32bit this will be a 32bit
value, on 64bit a 64bit one.  That's all the casting does.  The C
compiler will notice we're assigning to uint64_t and promote any 32bit
value for us.

> > --------------------------------------------------------------------------
> > 	u64 req_addr;
> > 	struct ocfs2_info_request __user *reqp;
> >
> > 	for (i = 0; i < info->info_count; i++) {
> > 		ret = -EFAULT;
> > 		if (get_user(&req_addr,
> > 			     (unsigned long)((u64**)(info->info_requests) + i)))
> > 			break;
> > 		reqp = (struct ocfs2_info_request *)(unsigned long)req_addr;
> > 		ret = ocfs2_info_handle(file, reqp);
> > 		if (ret)
> > 			break;
> > 	}
> > --------------------------------------------------------------------------
> >   
> 
> How to avoid accessing an arbitrary mem address, such as, userspace 
> passing a wrong info_count(correct_info_count + 1), so the last entry 
> for pointer should be invalid, how to avoid to access that?

	get_user() will return non-zero if the address is not part of
the program's valid memory.  We then break and return -EFAULT, causing a
segfault.
	Note that we're checking two things.  In this function, we copy
the userspace pointer into reqp.  We haven't actually accessed the
memory at reqp, we've just copied the pointer from info->info_requests.
So here we've checked that info->info_requests+i is a valid memory
location.  In ocfs2_info_handle(), we then copy the actual request from
reqp.  There copy_from_user() is checking that reqp points to valid
memory before copying it.
	Btw, the above function should be checking that reqp is not NULL
;-)

Joel

-- 

"Vote early and vote often." 
        - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
