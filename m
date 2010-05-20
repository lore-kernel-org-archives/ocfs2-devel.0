From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 20 May 2010 16:49:55 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <20100520232643.GC8335@mail.oracle.com>
References: <1274236135-5383-1-git-send-email-tristan.ye@oracle.com>
	<20100520232643.GC8335@mail.oracle.com>
Message-ID: <20100520234955.GD8335@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 20, 2010 at 04:26:43PM -0700, Joel Becker wrote:
> On Wed, May 19, 2010 at 10:28:55AM +0800, Tristan Ye wrote:
> > The reason why we need this ioctl is to offer the none-privileged
> > end-user a possibility to get filesys info gathering.
> > 
> > We use OCFS2_IOC_INFO to manipulate the new ioctl, userspace passes a
> > structure to kernel containing an array of request pointers and request
> > count, such as,
> 
> 	This patch fails to build in ia32.  Have you tested it there?

	I'll be clearer for future reference.  Anyone adding or
modifying code that handles compat pointers needs to compile and test:

1) A 32bit user program on a 32bit OS.
2) A 32bit user program on a 64bit OS with CONFIG_COMPAT set.
3) A 64bit user program on a 64bit OS with CONFIG_COMPAT set.
4) A 32bit user program on a 64bit OS with CONFIG_COMPAT *not* set.
5) A 64bit user program on a 64bit OS with CONFIG_COMPAT *not* set.

Only test (4) should return an error.
	I realize this is a lot of testing, but it only needs to be done
once.  It's only when you are actually touching CONFIG_COMPAT stuff.

Joel

-- 

"Hey mister if you're gonna walk on water,
 Could you drop a line my way?"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
