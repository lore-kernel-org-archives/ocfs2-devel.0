From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jun 22 13:37:59 2004
Subject: [Ocfs2-devel] The truncate_inode_page call in
	ocfs_file_releasecaus es the severethroughput drop of file reading in OCFS2.
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E0480298D@pdsmsx403>
References: <37FBBA5F3A361C41AB7CE44558C3448E0480298D@pdsmsx403>
Message-ID: <20040622183011.GA13204@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 22, 2004 at 04:57:56PM +0800, Zhang, Sonic wrote:
> Hi Wim,
> 
> 	I remember that the OCFS only make sure the metadata is
> consistent among different nodes in the cluster, but it doesn't care
> about the file data consistency.
Actually we use journalling and the inode sequence numbers for metadata
consistency. the truncate_inode_pages calls *are* used for data consistency,
but you're right in that we only really provide a minimal effort for that
(relying mostly on direct I/O in the database case for real consistency).

> 	So, I think we don't need to notify every change of a file to
> all active nodes. What should be done is only notify the changes in the
> inode metadata of a file, which costs little bandwidth. Why do you care
> about the file data consistency in your example?
Well, we already more or less handle this. Again, I think you're thinking
metadata when you want to be thinking data.

> 	If OCFS has to make sure the file data consistency, the current
> truncate_inode_page() solution also doesn't work. See my sample:
> 
> 1. Node 1 writes block 1 to file 1, flush to disk and keep it open.
> 2. Node 2 open file 1, reads block 1 and wait.
> 3. Node 1 writes block 1 again with new data. Also flush to disk.
> 4. Node 2 reads block 1 again.
> 
> Now, the data of block 1 got by node 2 is not the data on the disk.
Yeah, that's probably a hole in our scheme :)
	--Mark

> 
> 
> 
> -----Original Message-----
> From: wim.coekaerts@oracle.com [mailto:wim.coekaerts@oracle.com] 
> Sent: Tuesday, June 22, 2004 4:01 PM
> To: Zhang, Sonic
> Cc: Ocfs2-Devel; Rusty Lynch; Fu, Michael; Yang, Elton
> Subject: Re: [Ocfs2-devel] The truncate_inode_page call in
> ocfs_file_releasecaus es the severethroughput drop of file reading in
> OCFS2.
> 
> yeah... it's on purpose for the reason you mentioned.
> multinodeconsistency
> 
> i was actually cosnidering testing by taking out truncateinodepages,
> this has been discussed internqally for quite a few months, it's a big
> nightmare i have nightly ;-)
> 
> the problem is, how can we notify. I think we don't want to notify every
> node on every change othewise we overload the interconnect and we don't
> have a good consistent map, if I remmeber Kurts explanation correctly.
> 
> this has to be fixed for regular performance for sure, the question is
> how do we do this in a good way. 
> 
> I'd say, feel free to experiment... just remember that the big probelm
> is multinode consistency. imagine this :
> 
> I open file /ocfs/foo and read it
> all cached
> close file, no one on this node has it open
> 
> on node2 I write some data, either O_DIRECT or regular
> close or keep it open whichever
> 
> on node1 I now do an md5sum
> 
> 
> 
> > development machine. But, if we try to bypass the call to
> > truncate_inode_page(), the file reading throughput in one node can
> reach
> > 1300M bytes/sec, which is about 75% of that of ext3.
> > 
> > 	I think it is not a good idea to clean all page caches of an
> > inode when its last reference is closed. This inode may be reopened
> very
> > soon and its cached pages may be accessed again. 
> > 
> > 	I guess your intention to call truncate_inode_page() is to avoid
> > inconsistency of the metadata if a process on the other node changes
> the
> > same inode metadata on disk before it is reopened in this node. Am I
> > right? Do you have more concern?
> > 
> > 	I think in this case we have 2 options. One is to clean all
> > pages of this inode when receive the file change notification (rename,
> > delete, move, attributes, etc) in the receiver thread. The other is to
> > only invalidate pages contain the metadata of this inode.
> > 
> > 	What's your opinion?
> > 
> > 	Thank you.
> > 
> > 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel@oss.oracle.com
> > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
