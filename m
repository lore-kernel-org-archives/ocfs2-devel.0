From: tristan <tristan.ye@oracle.com>
Date: Mon, 08 Feb 2010 10:24:20 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions
 from ocfs2_fs.h to new added ocfs2_ioctl.h.
In-Reply-To: <20100205230914.GC3416@mail.oracle.com>
References: <1262940717-16769-1-git-send-email-tristan.ye@oracle.com>
	<20100205230914.GC3416@mail.oracle.com>
Message-ID: <4B6F75D4.3090203@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Fri, Jan 08, 2010 at 04:51:56PM +0800, Tristan Ye wrote:
>   
>> Currently we were adding ioctl cmds/structures for ocfs2 into ocfs2_fs.h
>> which was used for define ocfs2 on-disk layout. That sounds a little bit
>> confusing, and it may be quickly polluted espcially when growing the
>> ocfs2_info_request ioctls afterwards(it will grow i bet).
>>
>> As a result, such OCFS2 IOCs do need to be placed somewhere other than ocfs2_fs.h,
>> a separated ocfs2_ioctl.h will be added to store such ioctl structures and definitions
>> which could also be used from userspace to invoke the ioctls.
>>
>> What's more, the patch also introduces new structures and definitions for the new
>> OCFS2_IOC_INFO.
>>     
>
> 	Can I get a version of this patch that does not inlude
> OCFS2_IOC_INFO?  Separate out adding the INFO definitions.  They can go
> in the second patch, as they match the operations.
> 	That way I can apply this patch even before INFO is ready.
>   

Joel,

It really makes sense, they should be logically isolated.

I'll send out a version which separates the ioctl's migration from 
ocfs2_info adding.


Regards,
Tristan.

> Joel
>
>   
