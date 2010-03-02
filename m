From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 1 Mar 2010 19:29:45 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions
 from ocfs2_fs.h to new added ocfs2_ioctl.h.
In-Reply-To: <4B8C8252.1060507@oracle.com>
References: <1266997872-17091-1-git-send-email-tiger.yang@oracle.com>
	<20100302012121.GC447@mail.oracle.com>
	<4B8C7304.8070108@oracle.com>
	<20100302023217.GD447@mail.oracle.com>
	<4B8C8252.1060507@oracle.com>
Message-ID: <20100302032945.GG447@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 02, 2010 at 11:13:22AM +0800, tristan wrote:
> > 	That's right, you put it in the C sources.  This way we know
> > what includes each C file has, and only the C files needing the include
> > file actually include it.
> >   
> 
> I'm fine with this:)
> 
> BTW, it's a bad idea to add ocfs2_ioctl.h to ocfs2.h? it's not generic 
> enough to be there to let every C file refer it? right?

	I'm wavering on this.  We have ocfs2_fs.h and ocfs2_lockid.h in
there, but not ocfs2_lockingver.h...

Oh, hell, put it in ocfs2.h right by the other ocfs2_*.h headers.  Can't
hurt.

Joel

-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
