From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Mon Aug  2 17:01:06 2004
Subject: [Ocfs2-devel] Calculating volume size from superblock
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B01864545@orsmsx410>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

joel.becker@oracle.com wrote:
> 	As Sunil pointed out, you need to use the global bitmap to
> determine the number of clusters and multiply it by the clustersize.
> The libocfs2 library can help you get that information, or
> you can code
> up the bits to parse the information yourself.  Doing it
> yourself means
> learning how to navigate directories.

Just wondering.  As a possible RFE.  Is there any reason the size of the
global bitmap could not be in the superblock?  It seems strange that in
order to find out how big the filesystem is I have to actually traverse
the filesystem.

Would it be a bad to but the size of the global bitmap into the
superblock?

Thanks,
John
