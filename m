From: Kurt Hackel <Kurt.Hackel@oracle.com>
Date: Thu Jul  1 11:12:08 2004
Subject: [Ocfs2-devel] [Patch] We resolve the throughput drop problemwhe
	nr eading filesin OCFS2 volume in the patch "ocfs2-truncate-pages-1.patch"a
	gainstsvn 1226.
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8404C7A3A5@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8404C7A3A5@pdsmsx403>
Message-ID: <20040701161106.GA14297@ca2.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Great work!  We had internally discussed something along the lines of
#4, but figured we would not have time to implement it.  Basically, we
were going to extend the current READONLY cache locks to regular files
(today it only works for directories) and then take a READONLY lock on
every buffered read (not direct-io) and a regular lock on every buffered
write.  The writer would have to notify readers to drop the READONLY
property and flush the inode's data pages and extent map.

In practice, the only differences between this and what you have come up
with are (a) your method will require a dlm message on every write,
where the READONLY method would require messages on write only if the
master of the lock changes or new readers have joined, and (b) yours is
already done and tested. :)

I think we should go ahead with your patch and optimize it further later
if we need to.  

Thanks!
-kurt


On Thu, Jul 01, 2004 at 06:09:56PM +0800, Ling, Xiaofeng wrote:
>  There are still some improvement we may do for this patch.
> 1. Move the message from open to close
>      So if there is an open in another node during the write on this node, it will not affect the next read.
> 2. Send the message only when there is really a write before the close. (Maybe we can use the flag OCFS_OIN_OPEN_FOR_WRITE? It is now only used in direct io)
> 3. When creating a new file, do not send the message.( Need to add some flags to OCFS_I(inode) ?)
> 4.Send the message only to those node that have ever opened this file.( maybe similar with process of the DROP_READONLY message for directory operation?)
>     
> any more suggestion?
>      
> 
> >-----Original Message-----
> >From: ocfs2-devel-bounces@oss.oracle.com 
> >[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Wim Coekaerts
> >Sent: 2004??7??1?? 10:53
> >To: Zhang, Sonic
> >Cc: Fu, Michael; Yang, Elton; Ocfs2-Devel
> >Subject: Re: [Ocfs2-devel] [Patch] We resolve the throughput 
> >drop problem whenr eading filesin OCFS2 volume in the patch 
> >"ocfs2-truncate-pages-1.patch" againstsvn 1226.
> >
> >very interesting !  ll hav to study this one closely :)
> >thanks !
> >
> >On Thu, Jul 01, 2004 at 10:39:07AM +0800, Zhang, Sonic wrote:
> >> Hi,
> >> 
> >> 	We root caused the problem "The truncate_inode_page call in
> >> ocfs_file_releasecauses the severethroughput drop of file reading in
> >> OCFS2", which we put forward in our former mails. And now, we also
> >> generate a patch to resolve this problem after one week debugging.
> >> 
> >> 	This patch is against OCFS2 svn 1226.
> >> 
> >> 	The average file reading throughput without our patch is 16
> >> Mbtye/sec.
> >> 	The average file reading throughput with our patch is 1600
> >> Mbtye/sec.
> >> 	Our patch has 100 times improvement on file reading throughput.
> >> We will submit the full benchmark data of izone in the other 
> >mail soon.
> >> 
> >> 	In our patch, we remove ocfs_truncate_pages() and
> >> ocfs_extent_map_destroy() from routine ocfs_file_open() and
> >> ocfs_file_release(), which enable file data page reuse 
> >between different
> >> and sequential file access in one node. 
> >> 
> >> 	In current OCFS2 design, file data consistency among all nodes
> >> in the cluster is only ensured if this file is accessed in 
> >sequence. Our
> >> patch keeps the same consistency level by a new vote request
> >> FLAG_TRUNCATE_PAGES and a new vote action TRUNCATE_PAGES. 
> >This request
> >> is broadcast when a file is asked to be opened for write. Then the
> >> receivers truncate all in memory pages and extent maps of 
> >this file. The
> >> sender truncates part of the pages and maps only when the file is
> >> truncated (shortened).
> >> 
> >> 	Please refer to the attachment.
> >> 
> >> 	The throughput drop problem also occurs when creating, changing
> >> and deleting directories on OCFS2 volume. But it is not 
> >covered in this
> >> patch. We will work on the other patch to solve this problem.
> >> 
> >> 	Any comments are appreciated.
> >> 	Thank you.
> >> 
> >> 
> >> 
> >> *********************************************
> >> Sonic Zhang
> >> Software Engineer
> >> Intel China Software Lab
> >> Tel: (086)021-52574545-1667
> >> iNet: 752-1667
> >> *********************************************  
> >
> >
> >> _______________________________________________
> >> Ocfs2-devel mailing list
> >> Ocfs2-devel@oss.oracle.com
> >> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
> >_______________________________________________
> >Ocfs2-devel mailing list
> >Ocfs2-devel@oss.oracle.com
> >http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> >
> >
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
