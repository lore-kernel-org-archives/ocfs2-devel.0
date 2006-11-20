From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Nov 20 09:39:22 2006
Subject: [Ocfs2-devel] [patch 2/3] OCFS2 Configurable timeouts
In-Reply-To: <69C2CFE1-40AA-4E55-AC62-C3AC231BEC29@suse.de>
References: <20061118073600.206222000@suse.de>
	<20061118073632.559447000@suse.de>
	<20061120034725.GB30647@ca-server1.us.oracle.com>
	<69C2CFE1-40AA-4E55-AC62-C3AC231BEC29@suse.de>
Message-ID: <20061120173918.GG30647@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 20, 2006 at 08:30:10AM +0100, Andrew Beekhof wrote:
> On Nov 20, 2006, at 4:47 AM, Mark Fasheh wrote:
> >Is it safe for us to allow the keepalive delay and the idle timeout  
> >values
> >to change while the cluster is up? The next patch should be  
> >checking that
> >the values are the same on all nodes, but if we can change it mid  
> >stream,
> >what's the point?
> 
> good point.
> The simplest option would seem to be to lock the values in once we've  
> sent the first handshake.
> Maybe one day we can allow nodes to (re-)negotiate the intervals but  
> locking it in is probably enough for now.
That sounds good to me.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
