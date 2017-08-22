From: Mark Fasheh <mfasheh@versity.com>
Date: Tue, 22 Aug 2017 15:49:59 -0500
Subject: [Ocfs2-devel] [PATCH] ocfs2: re-queue AST or BAST if sending is
 failed to improve the reliability
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373AC2CB9E5@H3CMLB14-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373AC2CB721@H3CMLB14-EX.srv.huawei-3com.com>
	<CAAXPY_+YpQgRPBu1AeDMj-a3ouUxVktL7gdkSkSaEdeTKTUCvw@mail.gmail.com>
	<63ADC13FD55D6546B7DECE290D39E373AC2CB9E5@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <CAAXPY_Khwm1o4gnCjPAhfn576F9dOrCkEggEb4BcrexvxywLkw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Aug 8, 2017 at 5:56 AM, Changwei Ge <ge.changwei@h3c.com> wrote:
>>> It will improve the reliability a lot.
>> Can you detail your testing? Code-wise this looks fine to me but as
>> you note, this is a pretty hard to hit corner case so it'd be nice to
>> hear that you were able to exercise it.
>>
>> Thanks,
>>    --Mark
> Hi Mark,
>
> My test is quite simple to perform.
> Test environment includes 7 hosts. Ethernet devices in 6 of them are
> down and then up repetitively.
> After several rounds of up and down. Some file operation hangs.
>
> Through debugfs.ocfs2 tool involved in NODE 2 which was the owner of
> lock resource 'O000000000000000011150300000000',
> it told that:
>
> debugfs: dlm_locks O000000000000000011150300000000
> Lockres: O000000000000000011150300000000   Owner: 2    State: 0x0
> Last Used: 0      ASTs Reserved: 0    Inflight: 0    Migration Pending: No
> Refs: 4    Locks: 2    On Lists: None
> Reference Map: 3
>  Lock-Queue  Node  Level  Conv  Cookie           Refs  AST  BAST
> Pending-Action
>  Granted     2     PR     -1    2:53             2     No   No    None
>  Granted     3     PR     -1    3:48             2     No   No    None
>
> That meant NODE 2 had granted NODE 3 and the AST had been transited to
> NODE 3.
>
> Meanwhile, through debugfs.ocfs2 tool involved in NODE 3,
> it told that:
> debugfs: dlm_locks O000000000000000011150300000000
> Lockres: O000000000000000011150300000000   Owner: 2    State: 0x0
> Last Used: 0      ASTs Reserved: 0    Inflight: 0    Migration Pending: No
> Refs: 3    Locks: 1    On Lists: None
> Reference Map:
>  Lock-Queue  Node  Level  Conv  Cookie           Refs  AST  BAST
> Pending-Action
>  Blocked     3     PR     -1    3:48             2     No   No    None
>
> That meant NODE 3 didn't ever receive any AST to move local lock from
> blocked list to grant list.
>
> This consequence  makes sense, since AST sending is failed which can be
> seen in kernel log.
>
> As for BAST, it is more or less the same.
>
> Thanks
> Changwei


Thanks for the testing details. I think you got Andrew's e-mail wrong
so I'm CC'ing him now. It might be a good idea to re-send the patch
with the right CC's - add some of your testing details to the log.
You're free to use my

Reviewed-by: Mark Fasheh <mfasheh@versity.com>

as well.

Thanks again,
   --Mark
