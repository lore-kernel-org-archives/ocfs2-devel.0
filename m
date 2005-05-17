From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue May 17 18:00:16 2005
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] jlbec commits r2262 -
	branches/alloc_inode/fs/ocfs2
In-Reply-To: <20050517211616.GA13743@lst.de>
References: <200505172112.j4HLCq0p022101@oss.oracle.com>
	<20050517211616.GA13743@lst.de>
Message-ID: <20050517230019.GB1185@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 17, 2005 at 11:16:16PM +0200, Christoph Hellwig wrote:
> Btw, for many functions it would be a lot cleaner to have a local
> 
> struct ocfs2_inode_info *oi = OCFS2_I(inode);
> 
> at the beginning and the just use oi->foo.

	I do it when I see a bunch.  Right now, though, I'm not quite
ready to try and consolidate them, as they are in flux.

Joel

-- 

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

Joel Becker
Senior Member of Technical Staff
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
