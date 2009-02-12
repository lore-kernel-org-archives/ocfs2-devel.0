From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 12 Feb 2009 14:19:03 -0800
Subject: [Ocfs2-devel] mount point is not unique among all nodes
In-Reply-To: <499481EF.40609@suse.de>
References: <499481EF.40609@suse.de>
Message-ID: <4994A057.2000606@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The bug refers to a heartbeat2 issue.

So your qs is: Mount a ocfs2 vol on two nodes, A & B. Then on
node A, create a directory on the ocfs2 vol and then mount a
local filesystem on that dir. Then remove that dir on node B.

While I have not tested this, it will be a problem. We are relying
on vfs_rmdir() to call d_mountpoint(dentry) to nak the unlink.
But it is obviously not cluster-aware.

File a bugzilla. We'll have to think about a solution.

Coly Li wrote:
> Hi list,
>
> Here is a bug report on novell bugzilla (https://bugzilla.novell.com/show_bug.cgi?id=456280) that
> mount point inside node A can be removed from node B.
>
> The problem is, node B does not know an empty dir is be using as mount point on another node. Is
> there any solution to return -EBUSY when a dir is be using as mount point on another node ?
>
> Thanks in advance.
>   
