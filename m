From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Jun  4 15:00:01 2007
Subject: [Ocfs2-devel] Clustered Samba/CTDB on ocfs2 ?
In-Reply-To: <18019.47337.745002.756250@samba.org>
References: <17976.62685.567183.915000@samba.org>
	<20070502204508.GM21982@ca-server1.us.oracle.com>
	<17976.65193.79079.299940@samba.org>
	<20070502212930.GN21982@ca-server1.us.oracle.com>
	<18019.47337.745002.756250@samba.org>
Message-ID: <20070604215955.GB20632@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 04, 2007 at 05:02:01PM +1000, tridge@samba.org wrote:
>  > Ok - understood. Out of curiousity, where is this stuff in its lifetime
>  > (i.e., alpha, aeta, post release, etc). Once we verify that things are
>  > working with Ocfs2 as expected, we could start pointing people asking about
>  > Samba to the CTDB stuff.
> 
> The CTDB stuff has come a long way in the last few weeks. If you or
> anyone else on this list wants to do some testing with OCFS2 then I
> think it would be a good time to start.
> 
> See http://ctdb.samba.org/ and
> http://wiki.samba.org/index.php/CTDB_Setup#Managing_Network_Interfaces 
> for some documentation other information.

Hmm, that all looks a lot more involved than I had first imagined. It might
be a while before I or anyone on my team has the cycles to get a proper test
going :/

But ignoring manpower issues for a second.. What sort of tests do you think
would help to "validate" ocfs2 + clustered samba as a usable setup? I'm
thinking some sort of coherency verification against two clients mounted on
two seperate nodes at the least. Is there a particular test suite you all
run on this stuff?
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
