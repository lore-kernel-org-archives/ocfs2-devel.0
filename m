From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 9 Dec 2010 09:33:08 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: make existing convertion
 precedent over new lock
In-Reply-To: <4CFFCEB8.8000202@oracle.com>
References: <201012081237.oB7Ibeoo012391@acsinet15.oracle.com>
	<20101208180757.GC21913@mail.oracle.com>
	<20101208181222.GD21913@mail.oracle.com>
	<4CFFCEB8.8000202@oracle.com>
Message-ID: <20101209013308.GA3090@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil/Joel,

On 10-12-08 10:30, Sunil Mushran wrote:
> On 12/08/2010 10:12 AM, Joel Becker wrote:
> >On Wed, Dec 08, 2010 at 10:07:57AM -0800, Joel Becker wrote:
> >>On Wed, Dec 08, 2010 at 08:34:39PM +0800, Wengang Wang wrote:
> >>>Make existing convertion precedent over new lock. It makes o2dlm locking more
> >>>like fair locking.
> >>	Is this a problem you were solving, or just something you
> >>thought about while reading the code?  If it was a problem you ran
> >>into, can you give the details?
> >	It looks like you're just emulating the logic from
> >__dlmconvert_master().  That makes sense.
> 
> This fix is an offshoot of the conversation in his thread.
> http://oss.oracle.com/pipermail/ocfs2-devel/2010-November/007524.html

Yes. The patch tries to fix that problem.
 
> The fix looks ok. But I would rather that we confirm this problem and the
> fix before we push it upstream.

Yes, understand. 
> Wengang, Have you attempted to reproduce the problem and/or test the fix?

I didn't let ct to test the patch yet. I can't reproduce it in house.
What I tested is very common test cases, such as parallel listing and
parallel kernel compiling.

I will let ct test with the patch. But since it's not a frequently
hit problem, not easy to say if the patch works....

What's the idea for such cases?

regards,
wengang.
