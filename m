From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 09 Jun 2011 18:10:47 -0700
Subject: [Ocfs2-devel] [PATCH] remove lockres from purge list when we
 are getting it for creating lock
In-Reply-To: <20110610010138.GB3437@laptop.jp.oracle.com>
References: <201106080229.p582TILH031715@acsmt356.oracle.com>
	<4DF108A8.7010307@oracle.com>
	<20110610010138.GB3437@laptop.jp.oracle.com>
Message-ID: <4DF16F17.6030100@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/09/2011 06:01 PM, Wengang Wang wrote:
>
> Yes, you are right. There is such a problem that the lockres can be
> added to purge list after we drop dlm->spinlock. I am not sure if it's the more
> likely case since there is a 8 seconds delay between the the time the lockres is
> added to purge list and the time it is purged. I guess in normal case, the create-
> lock should already finished in the 8 seconds.
>
> I considered about the inflight_locks. But I didn't think it well so far.
> Because simply moving the lockres out from purge list is not good
> enough, I will take a good think about making use of inflight_locks.
>
>> Secondly, we currently manipulate the purgelist in one function only.
>> __dlm_calc_lockres_usage(). We should stick to that.
> If we make good use of inflight_locks, I think we can.
>> BTW, how are you testing this?
> I tested with the steps which can cause the original problem to prove it
> works.(but without UT).
> Also I made a regression test with the existing ocfs2-test suites(the
> multiple-xxx with reducing interations).

What's UT?

I am looking for is a testcase that reliably reproduces the problem.
Not necessarily that can be checked in. But something that triggers
the issue.
