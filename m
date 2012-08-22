From: Jie Liu <jeff.liu@oracle.com>
Date: Wed, 22 Aug 2012 22:17:59 +0800
Subject: [Ocfs2-devel] RFC: OCFS2 heartbeat improvements
Message-ID: <5034EA17.107@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi All,

These days, I am investigating an issue regarding OCFS2 unexpected
reboot in some real world use cases.
This problem occurred when the network status goes south, when the disk
IO load is too high, etc...
I suspect it might caused by ocfs2 fencing if it's BIO reading/writing
can not be scheduled and processed quickly, or
something like this happened in the network IO heartbeat thread.

Now am trying to reproduce this problem locally.  In the meantime, I'd
like to ping you guys with some rough ideas
to improve the disk IO heartbeat to see if they are sounds reasonable or
not.

Firstly, if an OCFS2 node is suffer from heavy disk IO, how about to fix
the bio read/write to make this IO request can not
be preempted by other requests? e.g,  for o2hb_issue_node_write(),
currently, it do bio submission with WRITE only,
'submit_bio(WRITE, bio)'.   If we change the flag to WRITE_SYNC, or even
submit the request combine with REQ_FUA,
maybe could get highest priority for disk IO request.

Secondly, the comments for bio allocation at o2hb_setup_one_bio()
indicates that we can pre-allocate bio instead of
acquire for each time.  But I have not saw any code snippet doing such
things in kernel. :(
how about creating a private bio set for each o2hb_region, so that we
can do allocation out of it?
maybe it's faster than do allocation from global bio sets.  Also, does
it make sense if creating a memory pool
on each o2hb_region, so that we can have continuous pages bind to those
bios?


Any comments are appreciated!

Thanks,
-Jeff






-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120822/c454d0b4/attachment.html 
