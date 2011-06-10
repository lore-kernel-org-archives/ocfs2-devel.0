From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 09 Jun 2011 17:43:17 -0700
Subject: [Ocfs2-devel] [PATCH] remove lockres from purge list when we
 are getting it for creating lock
In-Reply-To: <20110610003250.GA3437@laptop.jp.oracle.com>
References: <201106080229.p582TILH031715@acsmt356.oracle.com>
	<4DF0576F.1010002@oracle.com> <4DF11229.2070706@oracle.com>
	<20110610003250.GA3437@laptop.jp.oracle.com>
Message-ID: <4DF168A5.2050601@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 06/09/2011 05:32 PM, Wengang Wang wrote:
> On 11-06-09 11:34, Sunil Mushran wrote:
>> Different issue. That patch plugged a hole when the master was remote.
>> In this case the master is local.
> I think in my case, the master is remote too. The phenomemon is local
> node keeps sending messages infinitely to the master which is dead.
>> In this case, the window is very tiny as we not only need the recovery to
>> kick-in in the that window, we also need the lockres to be moved to the
>> purgelist in that window.
>>
>> But it just so happens that ovm via userdlm hits createlock a lot making
>> this issue more likely to trigger than with the fs.
> Yes, OVM create the lock in every 5 seconds via dlmfs.

Do you have a reproducible testcase? If not, work on that. That would
be most helpful in fixing this issue.

Right now I am also working on a problem in this area. Not the same
though. I can work on this issue too. But I need a testcase.
