From: Manish Singh <manish.singh@oracle.com>
Date: Sat Feb 28 17:36:55 2004
Subject: [Ocfs2-devel] Moving to subversion
Message-ID: <20040228233651.GA13019@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I've just reimported the Subversion repository with the internal CVS tree.
This means that development from the Oracle side will use it directly, so
there won't be any syncing lags. Also, full revision history logs are
maintained.

As a result of this, those with pre-existing checkouts will have to
recheckout, since the revision numbers match the old CVS repo and have no
relation to the previous snapshots. If you have changes in your local tree,
I think you'll still be able to make diffs, since a local copy is kept in
the .svn dir. So I hope migration won't be that much of a pain.

-Manish
