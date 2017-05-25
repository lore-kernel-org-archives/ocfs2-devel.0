From: Gang He <ghe@suse.com>
Date: Wed, 24 May 2017 20:41:56 -0600
Subject: [Ocfs2-devel] DLM Questions
In-Reply-To: <B83AEA8C21BE9F4EB13A8F0B43125DBAE269EDCB@SSIEXCH-MB2.ssi.samsung.com>
References: <CGME20170524162648uscas1p2b2b7f304beb98dc06aa2d3e132ec87a4@uscas1p2.samsung.com>
	<B83AEA8C21BE9F4EB13A8F0B43125DBAE269EDCB@SSIEXCH-MB2.ssi.samsung.com>
Message-ID: <5926B4F4020000F90007813E@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Jim,


>>> 
> I am interested in using a DLM for my user mode application and have been 
> examining the ocfs2 DLM. I have been experimenting with the o2dlm_test code 
> and have noticed an issue with the trylock command. When I start the o2dlm 
> code with no options, it is operating in classic mode and is using /dlm.
> 
> 
> 1.       On node 1 and node 2  I issue the command "register test".
> 
> 
> 2.       On node 1 I issue the command "lock ex mylock" and the operation 
> succeeds.
> 
> 
> 3.       On node 2 I issue the command "trylock ex mylock" and the operation 
> fails as expected.
> 
> 
> 4.       On node 1, I then unlock by issuing the command "unlock mylock" and 
> the operation succeeds.
How do you unlock the lock? since ocfs2 has a wrapper unlock, which do not unlock a lock, just downgrade a lock.

> 
> 
> 5.       On node 2 I issue the command "trylock ex mylock" and the operation 
> fails. This seems to be an error. The operation should succeed.
How do you trylock a lock? use which argument? OCFS2_LOCK_NONBLOCK or DLM_LKF_NOQUEUE?
OCFS2_LOCK_NONBLOCK does NOT means trylock, which means "DONOT block (sleep), even can get lock, but need a sleep wait"
DLM_LKF_NOQUEUE is more closed to trylock,  do not queue the lock request on the wait queue if it cannot be granted, and this lock will not send blocking AST's before returning -EAGAIN,
that means it can not get a lock if the lock is not this node.

> 
> Note that if I try the same operations shown above with o2dlm_test invoked 
> with the -u option which causes it to use fsdlm, I don't see the error in step 
> 5 above. Everything works as expected.
> 
> It is also my understanding from examining the code that when using /dlm 
> (this mode is referred to as "classic" in the source code), blocking ASTs are 
> supported, but when using fsdlm blocking operations are not supported. Is 
> this a correct understanding?
No, both support Bast.
> 
> In the tests that I am running I am using the DLM with a two node ocfs2 
> cluster, but in my final design I want to remove the DLM code from the file 
> system and use it in another application. Is this feasible?
Theoretically, can do it. 
But if you bring a new lock implementation, there will be lots of potential bugs. 

> 
> Who is currently maintaining the DLM code?
OCFS2 dlm belongs to ocfs2 maintainer, maybe Joseph Qi has some ocfs2 dlm some practical experience. 
fs/dlm belongs to redhat devolper David Teigland <teigland@redhat.com>.

Thanks
Gang

> 
> Thanks,
> -jim
