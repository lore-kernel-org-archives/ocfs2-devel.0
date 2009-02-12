From: Coly Li <coly.li@suse.de>
Date: Fri, 13 Feb 2009 04:09:19 +0800
Subject: [Ocfs2-devel] mount point is not unique among all nodes
Message-ID: <499481EF.40609@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi list,

Here is a bug report on novell bugzilla (https://bugzilla.novell.com/show_bug.cgi?id=456280) that
mount point inside node A can be removed from node B.

The problem is, node B does not know an empty dir is be using as mount point on another node. Is
there any solution to return -EBUSY when a dir is be using as mount point on another node ?

Thanks in advance.
-- 
Coly Li
SuSE Labs
