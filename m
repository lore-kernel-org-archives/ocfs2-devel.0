From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Dec  6 21:12:38 2007
Subject: [Ocfs2-devel] [RFC] to make files of ocfs2 under sysfs canonical
In-Reply-To: <4758ca1d.11588c0a.7668.ffff9173@mx.google.com>
References: <4758ca1d.11588c0a.7668.ffff9173@mx.google.com>
Message-ID: <20071207051224.GA29246@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Dec 07, 2007 at 12:22:17PM +0800, Denis Cheng wrote:
> ocfs2 uses a subsystem under sysfs: /sys/o2cb, which is not good,
> 
> the canonical use of sysfs is one kset under /sys/fs, like the approach
> gfs2 does.
> 
> if someone will agree my opinion, I can improve this code.

o2cb is, in theory, independent of the filesystem.  Thus, it doesn't
necessarily belong under /sys/fs.

The bigger problem is that there are tools expecting /sys/o2cb to be
there.  We can't just drop it.

Joel

-- 

"Drake!  We're LEAVING!"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
