From: Marcin Slusarz <marcin.slusarz@gmail.com>
Date: Mon, 31 Dec 2007 20:04:02 -0000
Subject: [Ocfs2-devel] [RFC][PATCH] byteorder: introduce le32_add_cpu &
	friends to	core
In-Reply-To: <20071231193801.GS13821@ca-server1.us.oracle.com>
References: <20071230190619.GA13757@joi>
	<20071231193801.GS13821@ca-server1.us.oracle.com>
Message-ID: <20071231200519.GA10232@joi>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors <kernel-janitors@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Mon, Dec 31, 2007 at 11:38:01AM -0800, Mark Fasheh wrote:
> On Sun, Dec 30, 2007 at 08:06:34PM +0100, Marcin Slusarz wrote:
> > There are many places where these functions would be useful.
> > (just look at: grep -r 'cpu_to_[ble12346]*([ble12346]*_to_cpu.*[-+]' linux-src/)
> > What do you think?
> > 
> > ps: this patch depends on http://lkml.org/lkml/2007/12/25/35
> > --
> > 
> > add inline functions which add native byte order variable to
> > little/big endian variable to core header and as an example
> > convert ext3 to use them
> 
> You might want to note where you got these functions from in your message.
Yes, my mistake, sorry about that.

> Also, it would be easier to follow these changes if you had broken things up
> into two patches - one which moved stuff from ocfs2 into generic helpers and
> a 2nd one to convert ext3.
Will do (tomorrow).

> Looking into my crystal ball, I see a bunch of "convert to using byteorder
> math macros" patches coming down the pipe. Since we're talking about disk
> fields where a mistake could be costly, I suggest that any patch more than a
> couple of lines should be tested by the submitter with sparse. A statement
> that sparse didn't produce any new warnings (with the patch applied) could
> be included in the description.
Good idea. Thanks.

Marcin
