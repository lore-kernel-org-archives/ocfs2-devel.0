From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 7 May 2008 11:04:25 -0700
Subject: [Ocfs2-devel] [PATCH]ocfs2-1.2: Add dput for uuid entry.
In-Reply-To: <48217514.9040808@oracle.com>
References: <482150B9.3030002@oracle.com> <482172FD.3040404@oracle.com>
	<48217514.9040808@oracle.com>
Message-ID: <20080507180424.GA25992@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, May 07, 2008 at 05:23:32PM +0800, Tao Ma wrote:
> aha, sorry for the noise. :(
> 
> dput is added in the next commit 29a7f3ada7fea5510504c5359c3f70d109aeb055.
> http://www.uwsg.indiana.edu/hypermail/linux/kernel/0611.3/0126.html
> 
> So here my question is should we patch these 2 patches into our 
> ocfs2-1.2 or just the 1st one?

	Well, this is all stuff for debugfs, which is usually part of
the kernel, right?  Or does El4 still not have it?

Joel

-- 

"I don't want to achieve immortality through my work; I want to
 achieve immortality through not dying."
        - Woody Allen

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
