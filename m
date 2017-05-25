From: Eric Ren <zren@suse.com>
Date: Thu, 25 May 2017 11:01:00 +0800
Subject: [Ocfs2-devel] DLM Questions
In-Reply-To: <B83AEA8C21BE9F4EB13A8F0B43125DBAE269EDCB@SSIEXCH-MB2.ssi.samsung.com>
References: <CGME20170524162648uscas1p2b2b7f304beb98dc06aa2d3e132ec87a4@uscas1p2.samsung.com>
	<B83AEA8C21BE9F4EB13A8F0B43125DBAE269EDCB@SSIEXCH-MB2.ssi.samsung.com>
Message-ID: <a65b6612-c9be-ccea-b29b-77be225aecfd@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
On 05/25/2017 12:26 AM, Jim Wayda (Stellus) wrote:
> I am interested in using a DLM for my user mode application and have been examining the ocfs2 DLM. I have been experimenting with the o2dlm_test code and have noticed an issue with the trylock command. When I start the o2dlm code with no options, it is operating in classic mode and is using /dlm.
>
>
> 1.       On node 1 and node 2  I issue the command "register test".
>
>
> 2.       On node 1 I issue the command "lock ex mylock" and the operation succeeds.
>
>
> 3.       On node 2 I issue the command "trylock ex mylock" and the operation fails as expected.
>
>
> 4.       On node 1, I then unlock by issuing the command "unlock mylock" and the operation succeeds.
>
>
> 5.       On node 2 I issue the command "trylock ex mylock" and the operation fails. This seems to be an error. The operation should succeed.
>
> Note that if I try the same operations shown above with o2dlm_test invoked with the -u option which causes it to use fsdlm, I don't see the error in step 5 above. Everything works as expected.
>
> It is also my understanding from examining the code that when using /dlm (this mode is referred to as "classic" in the source code), blocking ASTs are supported, but when using fsdlm blocking operations are not supported. Is this a correct understanding?
>
> In the tests that I am running I am using the DLM with a two node ocfs2 cluster, but in my final design I want to remove the DLM code from the file system and use it in another application. Is this feasible?
If you're aiming to use DLM in userland application, I recommend:
1) dlm project
https://pagure.io/dlm

2) dlm book
http://opendlm.sourceforge.net/cvsmirror/opendlm/docs/dlmbook_final.pdf

3) an example you can refer to
clvm:
https://sourceware.org/git/?p=lvm2.git;a=tree;f=daemons/clvmd;h=3daee0b265ef40789ee00264dbc2afde0389f0a7;hb=HEAD

Regards,
Eric
>
> Who is currently maintaining the DLM code?
>
> Thanks,
> -jim
>
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
