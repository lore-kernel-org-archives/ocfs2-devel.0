From: tridge@samba.org <tridge@samba.org>
Date: Wed May  2 14:11:24 2007
Subject: [Ocfs2-devel] Clustered Samba/CTDB on ocfs2 ?
In-Reply-To: <20070502204508.GM21982@ca-server1.us.oracle.com>
References: <17976.62685.567183.915000@samba.org>
	<20070502204508.GM21982@ca-server1.us.oracle.com>
Message-ID: <17976.65193.79079.299940@samba.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark,

 > Definitely - working well with Samba is one of the things that Ocfs2 is
 > interested in.

great!

 > Does it require the file system to support cluster-aware fcntl locking?
 > That's the one thing that Ocfs2 doesn't do yet.

no, it doesn't need fcntl locking in the filesystem.

Basically CTDB is a clustered version of the tdb database in Samba. It
has its own DLM, and its own communications system (can be either TCP
or infiniband).

Not all of the Samba internal databases can use CTDB yet, so for those
that aren't yet using CTDB they should be stored on a filesystem that
supports fcntl locking. Eventually all the Samba databases will be
able to use CTDB, at which time Samba should be making no fcntl lock
requests to the cluster filesystem at all. In the meantime, you can
still test Samba on ocfs2, but if you (for example) change passwords
on two nodes at the same time then there is a slight risk of data
corruption in the passsword database. That's because the tdbsam
database is not yet using CTDB. You could avoid that particular
problem by using a ldap server for your password database.

I assume ocfs2 is data coherent? That is the main requirement from the
cluster filesystem. If you are not data coherent then clustered Samba
will still work, but a user who writes a file to one node may get old
data if they fetch it on another node.

Cheers, Tridge
