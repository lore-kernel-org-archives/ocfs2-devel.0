From: Mark Fasheh <mfasheh@versity.com>
Date: Mon, 7 Aug 2017 15:19:59 -0500
Subject: [Ocfs2-devel] [PATCH] ocfs2: re-queue AST or BAST if sending is
 failed to improve the reliability
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373AC2CB721@H3CMLB14-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373AC2CB721@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <CAAXPY_+YpQgRPBu1AeDMj-a3ouUxVktL7gdkSkSaEdeTKTUCvw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 7, 2017 at 2:13 AM, Changwei Ge <ge.changwei@h3c.com> wrote:
> Hi,
>
> In current code, while flushing AST, we don't handle an exception that
> sending AST or BAST is failed.
> But it is indeed possible that AST or BAST is lost due to some kind of
> networks fault.
>
> If above exception happens, the requesting node will never obtain an AST
> back, hence, it will never acquire the lock or abort current locking.
>
> With this patch, I'd like to fix this issue by re-queuing the AST or
> BAST if sending is failed due to networks fault.
>
> And the re-queuing AST or BAST will be dropped if the requesting node is
> dead!
>
> It will improve the reliability a lot.

Can you detail your testing? Code-wise this looks fine to me but as
you note, this is a pretty hard to hit corner case so it'd be nice to
hear that you were able to exercise it.

Thanks,
   --Mark
