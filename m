From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue Aug  3 13:45:46 2004
Subject: [Ocfs2-devel] Calculating volume size from superblock
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B018122C7@orsmsx410>
References: <60C14C611F1DDD4198D53F2F43D8CA3B018122C7@orsmsx410>
Message-ID: <20040803183817.GL2595@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 02, 2004 at 11:56:03AM -0700, Villalovos, John L wrote:
> So it sounds like it isn't a simple thing to do?

	No, it's not terribly simple.  Though it could be pretty small
in a quick-n-dirty way.

> How portable is the libocfs2 library?  Is it fairly self contained?

	You can see it in the subversion repository for ocfs-tools.
It's not complete yet, so copying it over is probably a bad idea right
now.
	It's self-contained, requiring only libet from e2fsprogs right
now.  It's basically a conceptual port of libe2fs.

Joel

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
