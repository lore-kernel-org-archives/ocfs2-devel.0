From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Thu, 05 Jun 2008 16:10:27 -0700
Subject: [Ocfs2-devel] OCFS2 and direct-io writes
In-Reply-To: <9560740CA5C0C54BB3853AC9A4164BBB0308251D@EX-101.mail.navisite.com>
References: <9560740CA5C0C54BB3853AC9A4164BBB0308251D@EX-101.mail.navisite.com>
Message-ID: <48487263.9060205@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ivan,

Updating inode->i_size will require us to take the EX on the inode
cluster lock. (We take great pains to avoid taking that lock
in the directio path lest we serialize those ios across the
cluster.)

As far as treating unwritten extents as holes goes, we do that
simply to remember to initialize them, which is more efficient
in the buffered path. Skipping this will be a security hole.

Mark, Comments?

Also cc-ing Chris incase he can shed some light into XFS behavior.

Sunil


Eivind Sarto wrote:
>
> I am looking at possibility of using OCFS2 with an existing 
> application that
> requires very high throughput for read and write file access.
> Files are created by single writer (process) and can be read by 
> multiple reader,
> possibly while the file is being written.  100+ different files may be 
> written
> simultaneously, and can be read by 1000+ readers.
>
> I am currently using XFS on a local filesystem, preallocating the 
> unwritten extents with RESVSP,
> writing and reading the files with large direct-io requests.
>
> OCFS2-1.3.9 appears to almost support the features I need.  Large 
> direct-io requests can be passed straight
> through to the storage device and allocation of unwritten extents are 
> supported (even same API as XFS).
> However, direct-io writes are not supported if the file is being 
> appended.  The direct-io requests
> is converted to a buffered-io and the io write-bandwidth is not very good.
>
> I am not familiar with OCFS2 internals and my question is the following:
> Would it be possible to modify OCFS2 to support direct-io when writing 
> a file sequentially?
> Would it easier if the data blocks had already been allocated as 
> unwritten extents (using RESVSP)?
>
>
> I actually attempted to hack the OCFS2 code a bit to allow direct-io 
> writes to happen when the extents
> had previously been allocated with a RESVSP.  It only to a couple of 
> minor changes:
>   file.c:ocfs2_prepare_inode_for_write()
>       Don't disable direct_io if file is growing.
>   file.c:ocfs2_check_range_for_holes()
>       Don't treat unwritten extents as holes.
>   aops.c:ocfs2_direct_IO_get_blocks()
>       Map unwritten extents if they exists.
>
> With these changes, a single/local OCFS2 filesystem will allow me to 
> write/create files using
> large, direct-io.  All the write requests go straight through to the 
> storage.  And the write performance
> is very close to that of XFS.
> But, in a distributed environment the inode->i_size does not get 
> syncronized with the other nodes in
> the cluster.  The direct-io path does not syncronize the inode->i_size.
>
> Would it be possible to safely to update the i_size for all nodes in a 
> cluster, without causing any
> races or other problems?
> If so, does anyone have any suggestions as to how and where in the 
> code I could syncronize the i_size?
>
> Any feedback would be appreciated.
> Thanks,
> -ivan
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
