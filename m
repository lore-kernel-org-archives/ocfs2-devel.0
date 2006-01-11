From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed, 11 Jan 2006 13:49:05 -0800
Subject: [Ocfs2-devel] NFS exports of cluster filesystems
In-Reply-To: <20060111212500.GJ27971@fieldses.org>
References: <20051216211736.GA14415@fieldses.org>
	<20060103183047.GD11551@fieldses.org>
	<20060111212500.GJ27971@fieldses.org>
Message-ID: <20060111214905.GW3313@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Bruce,

On Wed, Jan 11, 2006 at 04:25:00PM -0500, J. Bruce Fields wrote:
> On a quick skim it doesn't appear to define a ->lock() method anywhere.
> Which I assume means that it doesn't attempt to provide cluster coherent
> posix byte-range (fcntl/lockf) locks.  Are there plans to change this?
You're correct in that right now OCFS2 does not support cluster coherent
posix locks. It is definitely on our TODO list, though it may take time as
the changes required are not trivial at all.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
