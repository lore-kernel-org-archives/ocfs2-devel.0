From: Manish Singh <manish.singh@oracle.com>
Date: Tue Mar  2 11:54:12 2004
Subject: [Ocfs2-devel] unknown symbol mark_buffer_clean found when compile
	OCFSv2 under kernel 2.6.0
In-Reply-To: <20040302174322.GQ31527@ca-server1.us.oracle.com>
References: 
	<37FBBA5F3A361C41AB7CE44558C3448E5A30D1@PDSMSX403.ccr.corp.intel.com>
	<20040302174322.GQ31527@ca-server1.us.oracle.com>
Message-ID: <20040302175407.GA30145@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 02, 2004 at 09:43:22AM -0800, Joel Becker wrote:
> On Tue, Mar 02, 2004 at 05:01:59PM +0800, Zhang, Sonic wrote:
> > My operation:
> > [host1]> insmod ocfs2.o node_name=westvile2 ip_address=192.168.1.14
> > cs=1793 guid=6B359212647D8D256E190007E903E0ED
> > ocfs2: Unknown symbol mark_buffer_clean
> > Error inserting 'ocfs2.o': -1 Unknown symbol in module
> 
> 	You should be using load_ocfs, provided in the ocfs-support
> package (and in the ocfs-tools svn repos).  THis will properly set all
> the values from /etc/ocfs.conf, and it will call "insmod ocfs", not
> "insmod ocfs.[k]o", thus eliminating any 2.4 vs 2.6 problem.
> 	If load_ocfs is not working for you, please file a bug report.

This would be load_ocfs2, not load_ocfs (that's for v1).

-Manish
