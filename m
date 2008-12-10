From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 10 Dec 2008 12:54:42 -0000
Subject: [Ocfs2-devel] [PATCH 0/18] ocfs2: Add metadata ECC - almost
	there.
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com> (Joel
	Becker's message of "Tue, 9 Dec 2008 17:09:37 -0800")
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <87oczkchr8.fsf@basil.nowhere.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker <joel.becker@oracle.com> writes:

> These patches add the metadata ECC code to ocfs2.  They have one
> limitation - they do not ECC directory blocks yet.  However, that will
> only take a simple insertion of the dirblock trailer.  With xattr ECC
> completed, the patches are approaching a final form and are ready for
> initial review.  They are atop my xattr-buckets-2 branch.

Could you please expand a bit why you chose ECC over more standard CRCs?

My assumption would be normally that if there is disk corruption it won't
be single flipped bits, but more large scale corruption. Do you have
data/experiences on the contrary?

Thanks,

-andi

-- 
ak at linux.intel.com
