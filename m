From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Tue Mar  2 12:09:57 2004
Subject: [Ocfs2-devel] unknown symbol mark_buffer_clean found when compile
	OCFSv2 under kernel 2.6.0
In-Reply-To: <20040302175407.GA30145@ca-server1.us.oracle.com>
References: 
	<37FBBA5F3A361C41AB7CE44558C3448E5A30D1@PDSMSX403.ccr.corp.intel.com>
	<20040302174322.GQ31527@ca-server1.us.oracle.com>
	<20040302175407.GA30145@ca-server1.us.oracle.com>
Message-ID: <20040302180950.GA27202@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 02, 2004 at 09:54:08AM -0800, Manish Singh wrote:
> On Tue, Mar 02, 2004 at 09:43:22AM -0800, Joel Becker wrote:
> > On Tue, Mar 02, 2004 at 05:01:59PM +0800, Zhang, Sonic wrote:
> > > My operation:
> > > [host1]> insmod ocfs2.o node_name=westvile2 ip_address=192.168.1.14
> > > cs=1793 guid=6B359212647D8D256E190007E903E0ED
> > > ocfs2: Unknown symbol mark_buffer_clean
> > > Error inserting 'ocfs2.o': -1 Unknown symbol in module
> > 
> > 	You should be using load_ocfs, provided in the ocfs-support
> > package (and in the ocfs-tools svn repos).  THis will properly set all
> > the values from /etc/ocfs.conf, and it will call "insmod ocfs", not
> > "insmod ocfs.[k]o", thus eliminating any 2.4 vs 2.6 problem.
> > 	If load_ocfs is not working for you, please file a bug report.
> 
> This would be load_ocfs2, not load_ocfs (that's for v1).
> 
> -Manish

The biggest problem I have with load_ocfs2 is my modutilites that come
with Fedora can not find ocfs2.ko unless I use modprobe (and load_ocfs2
uses insmod.)

Since insmod should really work, this isn't ocfs2's fault.  Instead of
tweaking load_ocfs2, I just added a line to my /etc/modprobe.conf like:

options ocfs2 node_name=localhost.localdomain debug_context=0xffffffff debug_level=0xffff ip_address=10.10.212.108 cs=1832 guid=5BE3240A7F450F98E94500D0B7B81CA2 comm_voting=1 ip_port_v2=7001

Which brings up an observation... the ocfs RPM spec file could configure
the users /etc/modules.conf|/etc/modprobe.conf and remove the need for
/etc/ocfs.conf.

    --rusty 
