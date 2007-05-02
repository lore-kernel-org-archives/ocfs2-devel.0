From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed May  2 14:29:35 2007
Subject: [Ocfs2-devel] Clustered Samba/CTDB on ocfs2 ?
In-Reply-To: <17976.65193.79079.299940@samba.org>
References: <17976.62685.567183.915000@samba.org>
	<20070502204508.GM21982@ca-server1.us.oracle.com>
	<17976.65193.79079.299940@samba.org>
Message-ID: <20070502212930.GN21982@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 03, 2007 at 07:12:09AM +1000, tridge@samba.org wrote:
> no, it doesn't need fcntl locking in the filesystem.
> 
> Basically CTDB is a clustered version of the tdb database in Samba. It
> has its own DLM, and its own communications system (can be either TCP
> or infiniband).

Ok, excellent. This should be a good fit then :)


> Not all of the Samba internal databases can use CTDB yet, so for those
> that aren't yet using CTDB they should be stored on a filesystem that
> supports fcntl locking. Eventually all the Samba databases will be
> able to use CTDB, at which time Samba should be making no fcntl lock
> requests to the cluster filesystem at all. In the meantime, you can
> still test Samba on ocfs2, but if you (for example) change passwords
> on two nodes at the same time then there is a slight risk of data
> corruption in the passsword database. That's because the tdbsam
> database is not yet using CTDB. You could avoid that particular
> problem by using a ldap server for your password database.

Ok - understood. Out of curiousity, where is this stuff in its lifetime
(i.e., alpha, aeta, post release, etc). Once we verify that things are
working with Ocfs2 as expected, we could start pointing people asking about
Samba to the CTDB stuff.


> I assume ocfs2 is data coherent? That is the main requirement from the
> cluster filesystem. If you are not data coherent then clustered Samba
> will still work, but a user who writes a file to one node may get old
> data if they fetch it on another node.

Yeah - we handle data coherency between nodes. O_DIRECT gets you around some
of those guarantees, so mixing it with buffered I/O is generally discouraged.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
