From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 18 17:34:00 2008
Subject: [Ocfs2-devel] Re: [PATCH] o2net: Reconnect after idle time out.V2
In-Reply-To: <47B47204.400@oracle.com>
References: <20080214023137.GA14136@tma-pc1.cn.oracle.com>
	<47B47204.400@oracle.com>
Message-ID: <20080219013337.GF22671@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 14, 2008 at 08:53:24AM -0800, Zach Brown wrote:
> Tao Ma wrote:
> > Modification from V1 to V2:
> > 1. Use atomic ops instead of spin_lock in timer.
> > 2. Add some comments when querying connect_expired work.
> >    These comments are copied form Zach's mail.;)
> 
> :)
> 
> This looks OK to me, thanks for updating it.

Ok, thanks guys. This is in ocfs2.git now.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
