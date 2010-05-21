From: tristan <tristan.ye@oracle.com>
Date: Fri, 21 May 2010 09:30:27 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <20100520232643.GC8335@mail.oracle.com>
References: <1274236135-5383-1-git-send-email-tristan.ye@oracle.com>
	<20100520232643.GC8335@mail.oracle.com>
Message-ID: <4BF5E233.9040206@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, May 19, 2010 at 10:28:55AM +0800, Tristan Ye wrote:
>> The reason why we need this ioctl is to offer the none-privileged
>> end-user a possibility to get filesys info gathering.
>>
>> We use OCFS2_IOC_INFO to manipulate the new ioctl, userspace passes a
>> structure to kernel containing an array of request pointers and request
>> count, such as,
>
> 	This patch fails to build in ia32.  Have you tested it there?
> Details below.
>
>> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
>> index 7d9d9c1..06b6f1c 100644
>> --- a/fs/ocfs2/ioctl.c
>> +++ b/fs/ocfs2/ioctl.c
>> @@ -23,8 +23,33 @@
>>  #include "ioctl.h"
>>  #include "resize.h"
>>  #include "refcounttree.h"
>> +#include "sysfile.h"
>> +#include "buffer_head_io.h"
>> +#include "suballoc.h"
>> +
>>  
>>  #include <linux/ext2_fs.h>
>> +#include <linux/compat.h>
>
> 	First off, linux/compat.h is already included as the third
> include of ioctl.c.  Why are you including it again?
>

Oh, that's true, why I'm so blind...

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
>
> 	The specific compile errors I am getting are:
>
> /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c: In function ?ocfs2_info_handle?:
> /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c:414: error: implicit declaration of function ?compat_ptr?
>
> and:
>

Joel, thanks for pointing this out, it's a big defect here, I just 
tested under ppc/x86_64/i386.

Have not tried on ia64 yet... that's totally my mistake...



>> +		} else {
>> +			if (get_user(req_addr,
>> +				     (u64 __user *)(info->oi_requests) + i))
>> +				goto bail;
>
> /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c:418: warning: cast to pointer from integer of different size
>
> 	The reason you are getting "implicit declaration of function
> 'compat_ptr' is because it only exists when CONFIG_COMPAT is defined.
> CONFIG_COMPAT cannot exist on ia32 or any other 32-bit platform.
> 	I say you should define a function "ocfs2_get_request_ptr()"
> that wraps both the comapt and non-compat get_user() calls.  Inside that
> function, you should have:
>
> 	if (compat_flag) {
> #ifdef CONFIG_COMPAT
> 		if (get_user(...compat_ptr...))
> 			goto bail;
> #else
> 		BUG();
> #endif
> 	} else {
>
> 	That way the info_handle() function isn't polluted by the ifdef.
>
> Joel
