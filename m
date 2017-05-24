From: Jim Wayda (Stellus) <Jim.Wayda@stellus.com>
Date: Wed, 24 May 2017 16:26:46 +0000
Subject: [Ocfs2-devel] DLM Questions
References: <CGME20170524162648uscas1p2b2b7f304beb98dc06aa2d3e132ec87a4@uscas1p2.samsung.com>
Message-ID: <B83AEA8C21BE9F4EB13A8F0B43125DBAE269EDCB@SSIEXCH-MB2.ssi.samsung.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I am interested in using a DLM for my user mode application and have been examining the ocfs2 DLM. I have been experimenting with the o2dlm_test code and have noticed an issue with the trylock command. When I start the o2dlm code with no options, it is operating in classic mode and is using /dlm.


1.       On node 1 and node 2  I issue the command "register test".


2.       On node 1 I issue the command "lock ex mylock" and the operation succeeds.


3.       On node 2 I issue the command "trylock ex mylock" and the operation fails as expected.


4.       On node 1, I then unlock by issuing the command "unlock mylock" and the operation succeeds.


5.       On node 2 I issue the command "trylock ex mylock" and the operation fails. This seems to be an error. The operation should succeed.

Note that if I try the same operations shown above with o2dlm_test invoked with the -u option which causes it to use fsdlm, I don't see the error in step 5 above. Everything works as expected.

It is also my understanding from examining the code that when using /dlm (this mode is referred to as "classic" in the source code), blocking ASTs are supported, but when using fsdlm blocking operations are not supported. Is this a correct understanding?

In the tests that I am running I am using the DLM with a two node ocfs2 cluster, but in my final design I want to remove the DLM code from the file system and use it in another application. Is this feasible?

Who is currently maintaining the DLM code?

Thanks,
-jim
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20170524/e3060eef/attachment-0001.html 
