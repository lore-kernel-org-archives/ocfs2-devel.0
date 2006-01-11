From: J. Bruce Fields <bfields@fieldses.org>
Date: Wed, 11 Jan 2006 16:25:00 -0500
Subject: [Ocfs2-devel] NFS exports of cluster filesystems
In-Reply-To: <20060103183047.GD11551@fieldses.org>
References: <20051216211736.GA14415@fieldses.org>
	<20060103183047.GD11551@fieldses.org>
Message-ID: <20060111212500.GJ27971@fieldses.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jan 03, 2006 at 01:30:47PM -0500, bfields wrote:
> As implementers of the Linux NFSv4 server support, we've found there's
> interest in good support for NFS exports of cluster filesystems (via
> NFSv4 and earlier versions).
> 
> There are a number of obstacles to this, and we're interested in finding
> solutions that are acceptable to OCFS2.  (If I've directed this to the
> wrong email list, please let me know!)
> 
> To give an example--there are a couple of problems with the current VFS
> support for posix byte-range locks:

I noticed just the other day that OCFS2 had popped up in linux/fs/ the
other day.  Yay!

On a quick skim it doesn't appear to define a ->lock() method anywhere.
Which I assume means that it doesn't attempt to provide cluster coherent
posix byte-range (fcntl/lockf) locks.  Are there plans to change this?

--b.
