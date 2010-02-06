From: tristan.ye <tristan.ye@oracle.com>
Date: Sat, 06 Feb 2010 21:42:08 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for	ocfs2 v6.
In-Reply-To: <20100205162739.GA25027@lst.de>
References: <1265363960-13329-1-git-send-email-tristan.ye@oracle.com>
	<1265363960-13329-2-git-send-email-tristan.ye@oracle.com>
	<20100205162739.GA25027@lst.de>
Message-ID: <4B6D71B0.4070005@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Christoph Hellwig Wrote:
> On Fri, Feb 05, 2010 at 05:59:20PM +0800, Tristan Ye wrote:
>   
>> Major changes from v4 to v5:
>>
>> Fix a ptr passing bug on PPC machine, that is, 32bits binary running
>> on 64bits kernel needs to use compat_ptr() to reterive the right ptr
>> address from userspace if we use u64 as a pointer.
>>
>> The reason why we need this ioctl is to offer the none-privileged
>> end-user a possibility to get filesys info gathering.
>>
>> We use OCFS2_IOC_INFO to manipulate the new ioctl, userspace passes a
>> structure to kernel containing an array of request pointers and request
>> count, such as,
>>
>> * From userspace:
>>
>> struct ocfs2_info_blocksize brq = {
>> 	.ir_request = {
>> 		.ir_magic = OCFS2_INFO_MAGIC,
>> 		.ir_code = OCFS2_INFO_BLOCKSIZE,
>> 		...
>> 	}
>>     
>
> I think you've totally overshoot the target here.  Just add a normal
> ioctls returning a structure with all interesting information without
> all that crap around it.  If it needs to be revisited it's trivial to
> just add another ioctl containing more fields.
>   
Hi Christoph,

I'm totally agreeing with Joel's idea, you see, we're going to add a 
ioctl about ocfs2 INFO, INFO itself was not a separate 'blocksize' or 
'clustersize' anyway.
The ocfs2_info is aiming at reteriving some info pieces as a whole, 
what's more, above logic could be more flexible than separate ioctls one 
by one.
and it's all up to user's demands, folks can even  separate their 
requirements by calling ocfs2_info more than once, by querying one info 
each time, or they can also grab all info by one time if they wish so.  
that's the INFO exactly mean, does it make sense?

Thanks and regards,
Tristan
