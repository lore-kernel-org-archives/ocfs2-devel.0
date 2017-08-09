From: Joseph Qi <jiangqi903@gmail.com>
Date: Wed, 9 Aug 2017 19:32:58 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: re-queue AST or BAST if sending is
 failed to improve the reliability
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373AC2CB721@H3CMLB14-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373AC2CB721@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <6b282ca9-f7b9-08d6-666d-565098587475@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 17/8/7 15:13, Changwei Ge wrote:
> Hi,
> 
> In current code, while flushing AST, we don't handle an exception that
> sending AST or BAST is failed.
> But it is indeed possible that AST or BAST is lost due to some kind of
> networks fault.
> 
Could you please describe this issue more clearly? It is better analyze
issue along with the error message and the status of related nodes.
IMO, if network is down, one of the two nodes will be fenced. So what's
your case here?

Thanks,
Joseph

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
> 
> 
> Thanks.
> 
> Changwei.
