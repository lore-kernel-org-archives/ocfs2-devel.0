From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Sep 28 18:54:50 2005
Subject: [Ocfs2-devel] shutdown of filesystems and quorum
In-Reply-To: <433B2B3E.805@oracle.com>
References: <20050928233249.GB17462@ca-server1.us.oracle.com>
	<433B2B3E.805@oracle.com>
Message-ID: <20050928235448.GE17462@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 28, 2005 at 04:46:06PM -0700, Sunil Mushran wrote:
> umount script should look at /etc/mtab and not /etc/fstab.
> 
> netfs looks at /etc/mtab or /proc/mounts depending on the version.

	And how many hand-mounted OCFS2 filesystems have _netdev in the
options?  Oh, we force it?  I guess that works.

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
