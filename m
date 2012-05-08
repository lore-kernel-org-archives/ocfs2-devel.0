From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 07 May 2012 19:10:32 -0700
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: implement discontiguous
	localalloc bitmap
In-Reply-To: <20120508002256.GD4713@dhcp-172-17-9-228.mtv.corp.google.com>
References: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
	<1336432890-18638-3-git-send-email-srinivas.eeda@oracle.com>
	<20120508002256.GD4713@dhcp-172-17-9-228.mtv.corp.google.com>
Message-ID: <4FA88098.9070301@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Mon, May 07, 2012 at 04:21:29PM -0700, Srinivas Eeda wrote:
>   
>
> 	OH MY DOG NO.  NEVER EVER DO THIS.  You cannot update an old
> filesystem on the fly!  What about other nodes that are running older
> versions of the software?  They will crash or corrupt data!  The entire
> point of feature bits is to make sure all nodes are speaking the same
> code.
>
> NAK NAK NAK
>
> 	This explains why you trusted la_rec_count earlier.  But that is
> broken.  When your patches are done, the code should use la_bm_off and
> la_bitmap when !DISCONTIG_LA and then use la_rec_count, etc when
> DISCONTIG_LA.  The only way to transition between them is a tunefs.ocfs2
> operation that walks the filesystem, flushes the bitmap, and then
> sets/clears la_rec_count appropriately depending on the direction..
>   
Please please don't hate me :( ... the changes takes care of old formats 
as well ...  I used the reserved space in the structure so that the code 
changes will be minimal and still compatible with old file system 
formats. I agree that we need to have some reserved space still 
available. So as discussed I'll redo the changes accordingly. Please 
ignore all the patches.

Thanks,
--Srini
