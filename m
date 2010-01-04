From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 4 Jan 2010 00:58:07 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Add stuffs associated with
 ocfs2_info_request ioctls to ioctl.h
In-Reply-To: <4B41541F.8030704@oracle.com>
References: <1262247524-26824-1-git-send-email-tristan.ye@oracle.com>
	<20091231201059.GB3301@mail.oracle.com>
	<4B41541F.8030704@oracle.com>
Message-ID: <20100104085806.GA13852@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 04, 2010 at 10:36:15AM +0800, tristan wrote:
> Oh, I may misunderstand your words, Joel. Did you mean we only split the on-disk layout and ioctls into two parts(ocfs2_fs.h and ocfs2_ioctl.h) in ocfs2-tools for userspace,
> while kernel part still maintains one ocfs2_fs.h to cover both definitions for on-disk and ioctl strutures?

	No, I don't mean that.  I mean we have ocfs2_fs.h and
ocfs2_ioctl.h in both the kernel and the tools.

> If not, why we need maintain two ioctl headers in kernel part(ioctl.h and ocfs2_ioctl.h)?

	ioctl.h contains things that are only important inside the
kernel build; specifically, the declarations of the ioctl functions
called by file_operations.  No userspace program needs the declaration
of kernel code functions.   ocfs2_ioctl.h should contain the things a
userspace program needs to invoke the ioctls.  The IOC definitions and
any structures they use.
	Basically, anything ocfs2_*.h is a userspace header that can be
installed for userspace programs to use.  They get copied to ocfs2-tools
include/ocfs2-kernel.  All the other headers are kernel-only.

Joel


-- 

Life's Little Instruction Book #222

	"Think twice before burdening a friend with a secret."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
