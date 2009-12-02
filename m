From: Tristan <tristan.ye@oracle.com>
Date: Wed, 02 Dec 2009 10:29:28 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Implement new OCFS2_IOC_INFO
 ioctl for ocfs2.
In-Reply-To: <20091202003549.GB5269@mail.oracle.com>
References: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>
	<1259310276-7782-2-git-send-email-tristan.ye@oracle.com>
	<4B145A07.3070107@oracle.com> <4B148B79.4090100@oracle.com>
	<20091202003549.GB5269@mail.oracle.com>
Message-ID: <4B15D108.6080909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Dec 01, 2009 at 11:20:25AM +0800, Tristan wrote:
>   
>> Size of each request may differ from type to type, think about:
>>     
>
> 	Yes, but you are not passing an array of structures, you are
> passing an array of pointers.  Andi's right, of course, that NULL
> termination is rife for abuse.  Let's pass it via a wrapper structure:
>
> ---------------------------------------------------------------------------
> struct ocfs2_info {
> 	__u64 info_requests;	/* Array of __u64 pointers to our requests */
> 	__u32 info_count;	/* Number of requests in info_requests */
> };
> ---------------------------------------------------------------------------
>
> 	Why is info_requests a __u64?  Because we have to handle 32bit
> binaries on 64bit systems.  In fact, info_requests is an array of 64bit
> values.  See the example below.
> 	I've also modified struct ocfs2_info_request to have a magic
> number and a size:
>
> ---------------------------------------------------------------------------
> /* Magic number of all requests */
> #define OCFS2_INFO_MAGIC            0x4F32494E  /* Magic number for requests */
>
> struct ocfs2_info_request {
> /*00*/	__u32 ir_magic;	/* Magic number */
>   

Why we need a magic here, just to improve the security?

> 	__u32 ir_code;	/* Info request code */
> 	__u32 ir_size;	/* Size of request */
> 	__u32 ir_flags;	/* Request flags */
> /*10*/	/* Request specific fields */
> };
> ---------------------------------------------------------------------------
>
> 	A user now does:
>
> ---------------------------------------------------------------------------
> get_info(fd)
> {
> 	struct ocfs2_info_request_clustersize crq = {
> 		.ir_magic = OCFS2_INFO_MAGIC,
> 		.ir_code = OCFS2_INFO_REQUEST_CLUSTERSIZE,
> 		.ir_size = sizeof(struct ocfs2Info_request_clustersize),
> 	};
> 	struct ocfs2_info_request_blocksize brq = {
> 		.ir_magic = OCFS2_INFO_MAGIC,
> 		.ir_code = OCFS2_INFO_REQUEST_BLOCKSIZE,
> 		.ir_size = sizeof(struct ocfs2Info_request_blocksize),
> 	};
> 	uint64_t info_array[2] = {(unsigned long)&crq, (unsigned long)&brq};
> 	struct ocfs2_info info = {
> 		.info_requests = info_array,
> 		.info_count = 2,
> 	};
> 	
> 	rc = ioctl(fd, OCFS2_IOC_INFO, &info);
> 	...
> }
> ---------------------------------------------------------------------------
>
> 	o2info can create convenience wrappers for setting the magic
> number, code, and size, of course.  Note that we cast the request
> pointers to unsigned longs so that the promotion from ulong to uint64_t
> is handled by C.  This code works on 32bit and 64bit.
>   

Just a confusion here, uint64_t should be 'unsigned long long' on 32bits 
arch, and 'unsigned long' on 64bits arch, why we not use:


uint64_t info_array[2] = {(unsigned long long)&crq, (unsigned long long)&brq};


> 	How does the kernel handle this?  One by one, of course.  First
> we copy_from_user() the ocfs2_info structure.  We check that info_count
> is within some sane boundary (let's say 50 requests) so that someone
> doesn't pass one million.   We also check that info_requests is not
> NULL.  Both allow us to return -EINVAL.
> 	Then, for each request in the array, we grab the header,
> validate it, and call a handler function:
>
> --------------------------------------------------------------------------
> 	u64 req_addr;
> 	struct ocfs2_info_request __user *reqp;
>
> 	for (i = 0; i < info->info_count; i++) {
> 		ret = -EFAULT;
> 		if (get_user(&req_addr,
> 			     (unsigned long)((u64**)(info->info_requests) + i)))
> 			break;
> 		reqp = (struct ocfs2_info_request *)(unsigned long)req_addr;
> 		ret = ocfs2_info_handle(file, reqp);
> 		if (ret)
> 			break;
> 	}
> --------------------------------------------------------------------------
>   

How to avoid accessing an arbitrary mem address, such as, userspace 
passing a wrong info_count(correct_info_count + 1), so the last entry 
for pointer should be invalid, how to avoid to access that?

> 	Now we have a pointer to the *userspace* memory, we need to get
> the header into kernelspace:
>
> --------------------------------------------------------------------------
> int ocfs2_info_handle(file, struct ocfs2_info_request __user *reqp)
> {
> 	int ret = 0;
> 	struct ocfs2_info_request req;
>
> 	if (copy_from_user(&req, reqp, sizeof(struct ocfs2_info_request)))
> 		return -EFAULT;
>
> 	if (req.ir_magic != OCFS2_INFO_MAGIC)
> 		return -EINVAL;
> 	switch (req.ir_code) {
> 		case OCFS2_INFO_REQUEST_CLUSTERSIZE:
> 			if (req.ir_size != sizeof(struct ocfs2_info_request_clustersize)) {
> 				ret = -EINVAL;
> 				break;
> 			}
> 			ret = ocfs2_info_handle_clustersize(file, reqp, &req);
> 			break;
>
> 		...
>
> 		default:
> 			/* Unknown code */
> 			ret = -EINVAL;
> 			break;
> 	}
>
> 	return ret;
> }
> --------------------------------------------------------------------------
>
> 	We can probably wrap the switch into a lookup table, but let's
> not worry about that for now.
> 	As you can see, we've validated the info structure, then we
> validate each request as we get it.  We check the magic, the code, and
> the size to make sure userspace is doing it right.  Only then do we
> actually call the handler function.
> 	Some handler functions will need information from the extra
> portion of the request.  Simple ones will not, and need not copy
> anything else from userspace.  The clustersize handler is an example.
> It needs no more information from the passed request.  It just needs to
> fill in the result to userspace.
>
> --------------------------------------------------------------------------
> int ocfs2_info_handle_clustersize(struct file *file,
> 				  struct ocfs2_info_request __user *user_req,
> 				  struct ocfs2_info_request *req)
> {
> 	struct ocfs2_info_request_clustersize result;
>
> 	memcpy(&result, req, sizeof(struct ocfs2_info_request));
> 	result.ir_request.ir_flags |= OCFS2_INFO_FL_FILLED;
> 	result.ir_clustersize =
> 		OCFS2_SB(file->f_dentry->d_inode->i_sb)->s_clutsersize;
>
>         if (copy_to_user((struct ocfs2_info_request_clustersize __user *)user_req,
> 			 &result,
> 			 sizeof(struct ocfs2_info_request_clustersize)))
> 		return -EFAULT;
> 	return 0;
> }
> --------------------------------------------------------------------------
>
> 	Done right, we can switch between a single ioctl with an array
> of requests, a single ioctl with one request per call, and even multiple
> ioctls, all without changing the handler functions.  Whee!
>   

The scheme above was fine to me:-)

> Joel
>
>   
