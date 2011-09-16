From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 16 Sep 2011 08:57:57 +0800
Subject: [Ocfs2-devel] [PATCH] Wakeup down-convert thread just after
 clearing OCFS2_LOCK_UPCONVERT_FINISHING -v3
In-Reply-To: <4E729E13.5070800@oracle.com>
References: <201109150327.p8F3REQA017979@acsmt356.oracle.com>
	<4E7232B0.9080004@oracle.com> <4E723412.9060001@oracle.com>
	<20110916004200.GA3433@laptop.jp.oracle.com>
	<4E729E13.5070800@oracle.com>
Message-ID: <20110916005757.GB3581@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 11-09-15 17:53, Sunil Mushran wrote:
> On 09/15/2011 05:42 PM, Wengang Wang wrote:
> >Hi Sunil,
> >
> >On 11-09-15 10:21, Sunil Mushran wrote:
> >>http://people.redhat.com/~teigland/make_panic
> >>
> >>This test has been useful in exposing dlmglue issues.
> >>
> >>On 09/15/2011 10:15 AM, Sunil Mushran wrote:
> >>>I am fine with the kick in recover from dlm error. Not so in cluster lock.
> >>>We have to be very very sure before meddling with that function. It is
> >>>a state machine with many hidden gotchas.
> >>>
> >>>So is this patch for a bug encountered or just code audit. Also, what kind
> >>>testing has been done.
> >Yes, a bug(hang) encountered. After testing and analysis, I found the root cause.
> >And it's NOT the dlm error case. The hang was fixed by the original patch.
> >I will email you about the orabug and testcase(pretty easy to reproduce).
> 
> 
> Which original patch?

The first drop of this patch.

thanks,
wengang.
> 
> 
> >I will try http://people.redhat.com/~teigland/make_panic to see if it
> >can find something.
