From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 10 Dec 2008 18:16:12 -0800
Subject: [Ocfs2-devel] [PATCH 0/18] ocfs2: Add metadata ECC -
	almost	there.
In-Reply-To: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20081211021612.GK21455@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 09, 2008 at 05:09:37PM -0800, Joel Becker wrote:
> These patches add the metadata ECC code to ocfs2.  They have one
> limitation - they do not ECC directory blocks yet.  However, that will

	Following this are the two patches for directory blocks.  With
these patches, the ECC code is complete (barring comments/testing/bugs).
	The metaecc branch will be updated with these patches shortly.
I need to rebase it on a fixed xattr-buckets-2.

Joel

-- 

"In the arms of the angel, fly away from here,
 From this dark, cold hotel room and the endlessness that you fear.
 You are pulled from the wreckage of your silent reverie.
 In the arms of the angel, may you find some comfort here."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
