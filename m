From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Jul  1 05:12:07 2004
Subject: [Ocfs2-devel] [Patch] We resolve the throughput drop problem
	whenr eading filesin OCFS2 volume in the patch "ocfs2-truncate-pages-1.patch"
	againstsvn 1226.
Message-ID: <3ACA40606221794F80A5670F0AF15F8404C7A3A5@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 There are still some improvement we may do for this patch.
1. Move the message from open to close
     So if there is an open in another node during the write on this =
node, it will not affect the next read.
2. Send the message only when there is really a write before the close. =
(Maybe we can use the flag OCFS_OIN_OPEN_FOR_WRITE? It is now only used =
in direct io)
3. When creating a new file, do not send the message.( Need to add some =
flags to OCFS_I(inode) ?)
4.Send the message only to those node that have ever opened this file.( =
maybe similar with process of the DROP_READONLY message for directory =
operation?)
   =20
any more suggestion?
    =20

>-----Original Message-----
>From: ocfs2-devel-bounces@oss.oracle.com=20
>[mailto:ocfs2-devel-bounces@oss.oracle.com] On Behalf Of Wim Coekaerts
>Sent: 2004=C4=EA7=D4=C21=C8=D5 10:53
>To: Zhang, Sonic
>Cc: Fu, Michael; Yang, Elton; Ocfs2-Devel
>Subject: Re: [Ocfs2-devel] [Patch] We resolve the throughput=20
>drop problem whenr eading filesin OCFS2 volume in the patch=20
>"ocfs2-truncate-pages-1.patch" againstsvn 1226.
>
>very interesting !  ll hav to study this one closely :)
>thanks !
>
>On Thu, Jul 01, 2004 at 10:39:07AM +0800, Zhang, Sonic wrote:
>> Hi,
>>=20
>> 	We root caused the problem "The truncate_inode_page call in
>> ocfs_file_releasecauses the severethroughput drop of file reading in
>> OCFS2", which we put forward in our former mails. And now, we also
>> generate a patch to resolve this problem after one week debugging.
>>=20
>> 	This patch is against OCFS2 svn 1226.
>>=20
>> 	The average file reading throughput without our patch is 16
>> Mbtye/sec.
>> 	The average file reading throughput with our patch is 1600
>> Mbtye/sec.
>> 	Our patch has 100 times improvement on file reading throughput.
>> We will submit the full benchmark data of izone in the other=20
>mail soon.
>>=20
>> 	In our patch, we remove ocfs_truncate_pages() and
>> ocfs_extent_map_destroy() from routine ocfs_file_open() and
>> ocfs_file_release(), which enable file data page reuse=20
>between different
>> and sequential file access in one node.=20
>>=20
>> 	In current OCFS2 design, file data consistency among all nodes
>> in the cluster is only ensured if this file is accessed in=20
>sequence. Our
>> patch keeps the same consistency level by a new vote request
>> FLAG_TRUNCATE_PAGES and a new vote action TRUNCATE_PAGES.=20
>This request
>> is broadcast when a file is asked to be opened for write. Then the
>> receivers truncate all in memory pages and extent maps of=20
>this file. The
>> sender truncates part of the pages and maps only when the file is
>> truncated (shortened).
>>=20
>> 	Please refer to the attachment.
>>=20
>> 	The throughput drop problem also occurs when creating, changing
>> and deleting directories on OCFS2 volume. But it is not=20
>covered in this
>> patch. We will work on the other patch to solve this problem.
>>=20
>> 	Any comments are appreciated.
>> 	Thank you.
>>=20
>>=20
>>=20
>> *********************************************
>> Sonic Zhang
>> Software Engineer
>> Intel China Software Lab
>> Tel: (086)021-52574545-1667
>> iNet: 752-1667
>> ********************************************* =20
>
>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel@oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>
