From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 5 Feb 2010 15:09:14 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions
 from ocfs2_fs.h to new added ocfs2_ioctl.h.
In-Reply-To: <1262940717-16769-1-git-send-email-tristan.ye@oracle.com>
References: <1262940717-16769-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100205230914.GC3416@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 08, 2010 at 04:51:56PM +0800, Tristan Ye wrote:
> Currently we were adding ioctl cmds/structures for ocfs2 into ocfs2_fs.h
> which was used for define ocfs2 on-disk layout. That sounds a little bit
> confusing, and it may be quickly polluted espcially when growing the
> ocfs2_info_request ioctls afterwards(it will grow i bet).
> 
> As a result, such OCFS2 IOCs do need to be placed somewhere other than ocfs2_fs.h,
> a separated ocfs2_ioctl.h will be added to store such ioctl structures and definitions
> which could also be used from userspace to invoke the ioctls.
> 
> What's more, the patch also introduces new structures and definitions for the new
> OCFS2_IOC_INFO.

	Can I get a version of this patch that does not inlude
OCFS2_IOC_INFO?  Separate out adding the INFO definitions.  They can go
in the second patch, as they match the operations.
	That way I can apply this patch even before INFO is ready.

Joel

-- 

"Always give your best, never get discouraged, never be petty; always
 remember, others may hate you.  Those who hate you don't win unless
 you hate them.  And then you destroy yourself."
	- Richard M. Nixon

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
