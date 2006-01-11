From: J. Bruce Fields <bfields@fieldses.org>
Date: Wed, 11 Jan 2006 16:55:00 -0500
Subject: [Ocfs2-devel] NFS exports of cluster filesystems
In-Reply-To: <20060111214905.GW3313@ca-server1.us.oracle.com>
References: <20051216211736.GA14415@fieldses.org>
	<20060103183047.GD11551@fieldses.org>
	<20060111212500.GJ27971@fieldses.org>
	<20060111214905.GW3313@ca-server1.us.oracle.com>
Message-ID: <20060111215500.GA8618@fieldses.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 11, 2006 at 01:49:05PM -0800, Mark Fasheh wrote:
> You're correct in that right now OCFS2 does not support cluster coherent
> posix locks. It is definitely on our TODO list, though it may take time as
> the changes required are not trivial at all.

Got it, thanks.  Oh, and I just noticed the
Documentation/filesystems/ocfs2.txt.  Maybe you want something like
this?--b.

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index f2595ca..4389c68 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -35,6 +35,7 @@ Features which OCFS2 does not support ye
 	  be cluster coherent.
 	- quotas
 	- cluster aware flock
+	- cluster aware lockf
 	- Directory change notification (F_NOTIFY)
 	- Distributed Caching (F_SETLEASE/F_GETLEASE/break_lease)
 	- POSIX ACLs
