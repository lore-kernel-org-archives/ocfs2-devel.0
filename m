From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Mon Aug  2 13:56:18 2004
Subject: [Ocfs2-devel] Calculating volume size from superblock
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B018122C7@orsmsx410>
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

So it sounds like it isn't a simple thing to do?

How portable is the libocfs2 library?  Is it fairly self contained?

Wondering if I should copy the whole library over to EVMS.  They are GPL
and so is the ocfstools package so the licensing is no problem.

John
