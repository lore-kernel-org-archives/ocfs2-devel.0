From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 14 May 2010 13:06:33 -0700
Subject: [Ocfs2-devel] [PATCH 8/10] fs/ocfs2/dlm: Use kstrdup
In-Reply-To: <Pine.LNX.4.64.1005142130310.28935@ask.diku.dk>
References: <Pine.LNX.4.64.1005142130310.28935@ask.diku.dk>
Message-ID: <20100514200632.GD29764@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, May 14, 2010 at 09:30:48PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use kstrdup when the goal of an allocation is copy a string into the
> allocated region.

	Seems fine.  I'll send it along.

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
