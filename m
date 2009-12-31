From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 31 Dec 2009 12:10:59 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add stuffs associated with
 ocfs2_info_request ioctls to ioctl.h
In-Reply-To: <1262247524-26824-1-git-send-email-tristan.ye@oracle.com>
References: <1262247524-26824-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20091231201059.GB3301@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 31, 2009 at 04:18:43PM +0800, Tristan Ye wrote:
> Currently we were adding ioctl cmds/structures for ocfs2 into ocfs2_fs.h
> which was used for define ocfs2 on-disk layout. That sounds a little bit
> confusing, and it can be quickly polluted espcially when growing the
> ocfs2_info_request ioctls afterwards. The appropriate place to kept in-memory
> ioctl structures is ioctl.h I guess.

	We want a separate ocfs2_ioctl.h.  The definitions of the ioctl
and its structures are things a userspace program would want to use.
ioctl.h, on the other hand, is an internal header for libocfs2.

Joel

-- 

"Up and down that road in our worn out shoes,
 Talking bout good things and singing the blues."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
