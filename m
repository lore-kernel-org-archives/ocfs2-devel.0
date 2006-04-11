From: James Harper <james.harper@bendigoit.com.au>
Date: Tue, 11 Apr 2006 12:12:44 +1000
Subject: [Ocfs2-devel] using ethernet instead of TCP
Message-ID: <AEC6C66638C05B468B556EA548C1A77DCEBF89@trantor>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> James Harper wrote:
> > Has anyone considered having the option of using Ethernet instead of
TCP
> > for inter-node communications?
> 
> TIPC might also be interesting.
> 
>   http://tipc.sourceforge.net/
> 

I wasn't able to see the words 'runs directly on ethernet' in any of the
documents that I just browsed, but it certainly seemed to indicate that
it would run independent of IP, which suggests that it must be able to
use Ethernet directly.

Provided there is nothing incompatible between the way it does things
and the way ocfs2 does things, it seems almost perfect for the job.

James
