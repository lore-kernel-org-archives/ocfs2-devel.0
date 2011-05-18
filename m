From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 18 May 2011 03:49:56 -0700
Subject: [Ocfs2-devel] [Ocfs2-users] ocfs or configfs bug ?
In-Reply-To: <4DC9E889.3080008@oracle.com>
References: <4DADA228.5050209@bull.net> <20110419194840.GA27826@noexit>
	<4DAE26BA.3010203@oracle.com> <4DC9E889.3080008@oracle.com>
Message-ID: <20110518104955.GA7330@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 10, 2011 at 06:38:17PM -0700, Sunil Mushran wrote:
> configfs_readdir() is racing configfs_d_delete(). And I cannot
> see how we can use the existing spinlock to prevent the race.
> 
> sysfs uses a coarse lock sysfs_mutex to prevent against this.
> I think we should do the same in configfs.

	sysfs_mutex is peppered everywhere.  It's rather ugly, I think.
I am thinking about how the code reads.  I admit I also don't like that
sysfs_mutex serializes all accesses to the sysfs directory tree, but I'd
be OK with that as a stopgap solution if the code only read better.

Joel

-- 

"The nice thing about egotists is that they don't talk about other
 people."
         - Lucille S. Harper

			http://www.jlbec.org/
			jlbec at evilplan.org
