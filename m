From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 10 Dec 2008 10:15:52 -0800
Subject: [Ocfs2-devel] [PATCH 0/18] ocfs2: Add metadata ECC - almost
	there.
In-Reply-To: <87oczkchr8.fsf@basil.nowhere.org>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
	<87oczkchr8.fsf@basil.nowhere.org>
Message-ID: <20081210181552.GH16888@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 10, 2008 at 01:54:51PM +0100, Andi Kleen wrote:
> Joel Becker <joel.becker@oracle.com> writes:
> 
> > These patches add the metadata ECC code to ocfs2.  They have one
> > limitation - they do not ECC directory blocks yet.  However, that will
> > only take a simple insertion of the dirblock trailer.  With xattr ECC
> > completed, the patches are approaching a final form and are ready for
> > initial review.  They are atop my xattr-buckets-2 branch.
> 
> Could you please expand a bit why you chose ECC over more standard CRCs?
> 
> My assumption would be normally that if there is disk corruption it won't
> be single flipped bits, but more large scale corruption. Do you have
> data/experiences on the contrary?

	If you look at our block_check structure, you'll see that it
uses crc32c for the overall block, and then the ECC can attempt to
correct a single bit if the crc fails.

Joel

-- 

"If the human brain were so simple we could understand it, we would
 be so simple that we could not."
	- W. A. Clouston

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
