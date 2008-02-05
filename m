From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Feb  5 12:13:39 2008
Subject: [Ocfs2-devel] [patch 1/1] offline de-fragmentation tool
In-Reply-To: <47A67D89.2030403@oracle.com>
References: <47A67D89.2030403@oracle.com>
Message-ID: <20080205201305.GL22671@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 04, 2008 at 10:50:49AM +0800, wengang wang wrote:
> this tool doesn't merge or split extent records for now. and it's nearly 
> help nothing to fs performance.
> the feature to be added is trying to move all data clusters of a file 
> together as possible. so that accessing to file on ocfs2 can get better 
> performance.

Merging extents is pretty high value, so I'd definitely like to see that as
your next step ;)
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
