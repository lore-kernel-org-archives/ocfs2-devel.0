From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 20 May 2010 19:41:22 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <4BF5E233.9040206@oracle.com>
References: <1274236135-5383-1-git-send-email-tristan.ye@oracle.com>
	<20100520232643.GC8335@mail.oracle.com>
	<4BF5E233.9040206@oracle.com>
Message-ID: <20100521024122.GC9827@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, May 21, 2010 at 09:30:27AM +0800, tristan wrote:
> Joel Becker wrote:
> > 	The specific compile errors I am getting are:
> >
> > /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c: In function ?ocfs2_info_handle?:
> > /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c:414: error: implicit declaration of function ?compat_ptr?
> >
> > and:
> >
> 
> Joel, thanks for pointing this out, it's a big defect here, I just 
> tested under ppc/x86_64/i386.
> 
> Have not tried on ia64 yet... that's totally my mistake...

	You're not required to test ia64 specifically.  I got the
compile error on i386, so I wonder how you did not.

Joel

-- 

"Get right to the heart of matters.
 It's the heart that matters more."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
